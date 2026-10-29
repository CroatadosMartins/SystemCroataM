# UploadcroataM

Sistema simples da unidade para trocar **arquivos, fotos, textos e recados** entre os computadores.
Cada computador tem um nome (ex.: "Recepção"), e tudo que um envia aparece na hora nos outros.

- **Login:** CPF + senha. O CPF vira o e-mail `12345678900@equipeaps.local` no Supabase Auth.
- **Banco e arquivos:** Supabase da unidade (projeto próprio, separado dos outros sistemas).
- **Site:** Vercel, publicado a partir deste repositório.

## Arquivos

| Arquivo | Para que serve |
| --- | --- |
| `index.html` | O sistema inteiro (telas e lógica) |
| `config.js` | **Único arquivo a editar**: URL e Publishable key do Supabase da unidade |
| `supabase/01_tabelas.sql` | Tabelas `historico_arquivos` e `recados`, permissões e tempo real |
| `supabase/02_armazenamento.sql` | Bucket `arquivos` do Storage e permissões |
| `supabase/03_sinal_de_vida.sql` | Função que impede o Supabase gratuito de pausar |
| `.github/workflows/supabase-keepalive.yml` | Chama o sinal de vida todo dia |

## Instalação

1. Rode os 3 scripts de `supabase/` no SQL Editor, na ordem.
2. Em Authentication > Users, crie o usuário `12345678900@equipeaps.local` com a senha (marque *Auto Confirm User*).
3. Edite `config.js` com a Project URL e a Publishable key.
4. Importe este repositório na Vercel (Framework: *Other*, sem build).
5. No GitHub, em Settings > Secrets and variables > Actions, crie `SUPABASE_URL` e `SUPABASE_PUBLISHABLE_KEY`.
