-- UploadcroataM — SCRIPT 3 de 3: sinal de vida
-- O Supabase gratuito pausa o projeto após ~7 dias sem uso. O GitHub chama
-- esta função todo dia (.github/workflows/supabase-keepalive.yml) e ela grava
-- uma única linha. Não toca em nenhum dado do sistema.

create table if not exists public.sinal_de_vida (
  id int primary key default 1 check (id = 1),
  visto_em timestamptz not null default now(),
  vezes bigint not null default 0
);

alter table public.sinal_de_vida enable row level security;
-- Sem política: ninguém lê nem grava direto, só pela função abaixo.

create or replace function public.sinal_de_vida()
returns timestamptz
language sql
security definer
set search_path = public
as $$
  insert into public.sinal_de_vida (id, visto_em, vezes)
  values (1, now(), 1)
  on conflict (id) do update
    set visto_em = now(), vezes = public.sinal_de_vida.vezes + 1
  returning visto_em;
$$;

revoke all on function public.sinal_de_vida() from public;
grant execute on function public.sinal_de_vida() to anon, authenticated, service_role;

select 'Script 3 OK: sinal de vida pronto' as resultado, public.sinal_de_vida() as primeiro_sinal;
