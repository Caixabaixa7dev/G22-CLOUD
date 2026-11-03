# G22 Cloud Server

Fundação inicial do sistema para desenvolvimento no Windows e execução local no Termux. O projeto ainda não busca ofertas, não persiste dados de negócio e não envia mensagens.

## Estado da Fase 1

- API Express com `GET /health` e `GET /ready`.
- Endereço padrão `127.0.0.1:3000`; não exponha a API diretamente à internet.
- Erros JSON previsíveis, limite de corpo JSON e logs sem conteúdo de requisições.
- Scripts de operação no Termux guardam logs e PID em `~/.local/share/g22-cloud-server`, fora do repositório.
- `deploy-termux.sh` recusa destinos existentes que não sejam clones Git e usa `git pull --ff-only` para atualizar.

## Requisitos

- Node.js 20 ou superior e npm.
- Git para clonar/atualizar no Termux.

## Windows — desenvolvimento e testes

Na raiz do projeto:

```powershell
npm install
npm test
npm start
```

Em outro terminal, confira a API:

```powershell
Invoke-RestMethod http://127.0.0.1:3000/health
Invoke-RestMethod http://127.0.0.1:3000/ready
```

Para usar outra porta nesta sessão PowerShell: `$env:PORT = '3100'` e iniciar novamente.

## GitHub — primeiro envio

O login no navegador não garante que o Git esteja autenticado no terminal. Crie um repositório vazio no GitHub, sem README/licença pré-criados, e use a URL SSH ou HTTPS configurada na sua máquina:

```powershell
git init
git add .
git commit -m "feat: criar fundação do G22 Cloud Server"
git branch -M main
git remote add origin <URL_DO_REPOSITORIO>
git push -u origin main
```

Se `git push` pedir autenticação, conclua pelo fluxo do Git Credential Manager ou chave SSH no próprio computador. Não cole tokens no projeto ou no chat. O prompt mestre e o script de diagnóstico estão neste diretório e serão incluídos se você executar `git add .`; avalie se deseja versionar o prompt mestre antes do primeiro envio.

## Termux — primeira implantação

Confirme o caminho de destino antes de clonar. Por padrão o deploy usa `~/g22-cloud-server`; se existir, o script aborta sem sobrescrever. A pasta anterior `~/g22-server` não é tocada.

```sh
G22_REPO_URL='URL_DO_REPOSITORIO' bash scripts/deploy-termux.sh
```

O deploy instala apenas dependências declaradas com `npm ci --omit=dev` e não inicia o serviço. Depois:

```sh
bash scripts/start-termux.sh
bash scripts/status-termux.sh
bash scripts/logs-termux.sh
bash scripts/restart-termux.sh
bash scripts/stop-termux.sh
```

Para escolher caminho alternativo sem alterar scripts:

```sh
G22_APP_DIR="$HOME/g22-cloud-server-v1" G22_REPO_URL='URL_DO_REPOSITORIO' bash scripts/deploy-termux.sh
```

`G22_STATE_DIR` pode selecionar diretório de logs/PID; use armazenamento persistente do Termux. A API ainda não configura autostart/Termux:Boot. O `ready` indica apenas que a API está inicializada; não há banco ou integrações nesta fase.

## Segurança e dados

- Nunca versione `.env` ou credenciais; use `.env.example` apenas como referência.
- Mantenha `HOST=127.0.0.1` até uma fase própria de acesso remoto autenticado.
- Não há conta Supabase, túnel, integração de marketplace ou WhatsApp configurados.
- Faça backup off-device antes de introduzir dados persistentes nas próximas fases.
