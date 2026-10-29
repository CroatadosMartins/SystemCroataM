-- UploadcroataM — SCRIPT 1 de 3: tabelas
-- Rode no SQL Editor do projeto Supabase DA UNIDADE (não nos outros projetos).
-- Pode rodar de novo sem problema: nada é apagado.

-- Histórico de tudo que foi enviado (arquivo, foto, texto)
create table if not exists public.historico_arquivos (
  id          bigint generated always as identity primary key,
  nome        text not null,
  tipo        text not null default 'arq',      -- 'arq' | 'foto' | 'txt'
  url         text not null,
  computador  text,                              -- nome do PC que enviou
  criado_em   timestamptz not null default now()
);

-- Recados entre os computadores
create table if not exists public.recados (
  id          bigint generated always as identity primary key,
  texto       text not null check (char_length(texto) between 1 and 1000),
  computador  text,
  criado_em   timestamptz not null default now()
);

create index if not exists historico_arquivos_criado_em_idx on public.historico_arquivos (criado_em desc);
create index if not exists recados_criado_em_idx on public.recados (criado_em desc);

-- Segurança básica: só quem fez login (CPF + senha) lê e grava.
alter table public.historico_arquivos enable row level security;
alter table public.recados enable row level security;

drop policy if exists "logados_tudo" on public.historico_arquivos;
create policy "logados_tudo" on public.historico_arquivos
  for all to authenticated using (true) with check (true);

drop policy if exists "logados_tudo" on public.recados;
create policy "logados_tudo" on public.recados
  for all to authenticated using (true) with check (true);

-- Tempo real: avisa os outros computadores na hora que algo chega.
do $$
begin
  if not exists (select 1 from pg_publication_tables
                 where pubname = 'supabase_realtime' and tablename = 'historico_arquivos') then
    alter publication supabase_realtime add table public.historico_arquivos;
  end if;
  if not exists (select 1 from pg_publication_tables
                 where pubname = 'supabase_realtime' and tablename = 'recados') then
    alter publication supabase_realtime add table public.recados;
  end if;
end $$;

select 'Script 1 OK: tabelas criadas' as resultado;
