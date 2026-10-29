-- UploadcroataM — SCRIPT 2 de 3: armazenamento dos arquivos (Storage)
-- Cria o "bucket" chamado arquivos. É público para LER pelo link
-- (o link é longo e difícil de adivinhar), mas só quem fez login envia/apaga.

insert into storage.buckets (id, name, public)
values ('arquivos', 'arquivos', true)
on conflict (id) do update set public = true;

drop policy if exists "croatam_ler" on storage.objects;
create policy "croatam_ler" on storage.objects
  for select to authenticated using (bucket_id = 'arquivos');

drop policy if exists "croatam_enviar" on storage.objects;
create policy "croatam_enviar" on storage.objects
  for insert to authenticated with check (bucket_id = 'arquivos');

drop policy if exists "croatam_alterar" on storage.objects;
create policy "croatam_alterar" on storage.objects
  for update to authenticated using (bucket_id = 'arquivos');

drop policy if exists "croatam_apagar" on storage.objects;
create policy "croatam_apagar" on storage.objects
  for delete to authenticated using (bucket_id = 'arquivos');

select 'Script 2 OK: bucket arquivos pronto' as resultado;
