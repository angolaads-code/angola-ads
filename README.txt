# ANGOLA ADS — guia de configuração gratuita

Este pacote contém a primeira versão do site, preparada para uma base de dados online com moderação.
É necessário configurar os serviços gratuitos uma vez. Não partilhes a chave `service_role` com ninguém e nunca a coloques no HTML.

## O que está incluído
- `index.html`: site responsivo e formulário público para enviar anúncios.
- `supabase.sql`: tabelas, regras de segurança e fluxo de aprovação.
- `README.txt`: este guia.

## Passo 1 — criar a base de dados
1. Abre https://supabase.com/ e cria uma conta/projeto gratuito.
2. Guarda a palavra-passe do projeto num local seguro.
3. No painel do projeto, abre **SQL Editor** > **New query**.
4. Abre `supabase.sql`, copia todo o conteúdo para a consulta e carrega em **Run**.
5. Confirma que a consulta terminou sem erros.

## Passo 2 — criar o utilizador administrador
1. No Supabase, abre **Authentication** > **Users**.
2. Escolhe **Add user** / **Create new user** e cria o teu email e uma palavra-passe forte.
3. Copia o valor **User UID** desse utilizador.
4. Volta ao **SQL Editor** e executa, trocando o texto pelo UID real:
   insert into public.angola_ads_admins (user_id) values ('O-TEU-USER-UID');
5. Guarda as credenciais do administrador. Não as coloques no site público.

Não existe registo público de contas para vendedores. A conta é só para o administrador aprovar anúncios.

## Passo 3 — ligar o site ao Supabase
1. No painel do Supabase abre **Project Settings** > **API** (ou **Data API**, conforme a versão do painel).
2. Copia a **Project URL** e a chave pública **anon/public**. Nunca copies a chave `service_role` / `secret`.
3. Abre `index.html` num editor de texto.
4. Procura estas duas linhas no início do JavaScript:
   `const SUPABASE_URL = "COLOCA_AQUI_A_URL_DO_SUPABASE";`
   `const SUPABASE_ANON_KEY = "COLOCA_AQUI_A_CHAVE_ANON_PUBLICA";`
5. Substitui apenas o texto entre aspas pelos teus valores.
6. Guarda o ficheiro. Testa-o depois de o publicares (alguns bloqueadores podem impedir que a biblioteca seja carregada localmente).

A chave `anon/public` é feita para ser usada no navegador. A segurança depende das regras RLS instaladas pelo SQL; não publiques a chave `service_role`.

## Passo 4 — publicar gratuitamente com GitHub Pages
1. Cria uma conta em https://github.com/ se ainda não tens.
2. Cria um repositório novo, por exemplo `angola-ads`.
3. Envia o ficheiro `index.html` para o repositório (upload files).
4. Abre **Settings** > **Pages**.
5. Em **Build and deployment**, escolhe **Deploy from a branch**, seleciona `main` e `/ (root)`, e guarda.
6. Aguarda a publicação. O GitHub mostrará o endereço público do site na página Pages.

O GitHub Pages aloja ficheiros estáticos; a base de dados e o painel de autenticação ficam no Supabase. Os nomes exatos dos menus podem mudar.

## Passo 5 — testar tudo
1. Abre o site publicado numa janela anónima.
2. Envia um anúncio de teste. Deverá aparecer a mensagem de que ficou pendente, mas não deve aparecer na lista pública.
3. Para abrir o painel de administrador, clica cinco vezes no texto **ANGOLA ADS** no rodapé.
4. Entra com o email e a palavra-passe criados no Passo 2.
5. Aprova o anúncio e confirma que aparece na página pública.
6. Testa o botão de WhatsApp num telemóvel e no computador.

## Limitações e segurança da primeira versão
- O site não processa pagamentos e não confirma a identidade dos vendedores.
- Não há upload de fotografias nesta versão; os cartões usam ícones por categoria.
- A moderação é manual. Rejeita anúncios ilegais, fraudulentos ou que exponham dados pessoais sem autorização.
- A conta de administrador usa Supabase Auth; as regras da base de dados impedem utilizadores anónimos de aprovar anúncios.
- O plano gratuito tem limites e condições que podem mudar; consulta o painel do fornecedor.
- O domínio será inicialmente um endereço gratuito fornecido pelo serviço de alojamento. Um domínio próprio pode custar dinheiro.
- Faz uma cópia de segurança periódica dos dados antes de lançar a plataforma para um público grande.
