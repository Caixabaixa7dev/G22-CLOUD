#!/data/data/com.termux/files/usr/bin/bash
set -eu

REPO_URL="${1:-${G22_REPO_URL:-}}"
APP_DIR="${G22_APP_DIR:-$HOME/g22-cloud-server}"

command -v git >/dev/null 2>&1 || { echo 'Git não encontrado.' >&2; exit 1; }
command -v node >/dev/null 2>&1 || { echo 'Node.js não encontrado.' >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo 'npm não encontrado.' >&2; exit 1; }

if [ -d "$APP_DIR/.git" ]; then
  git -C "$APP_DIR" pull --ff-only
elif [ -e "$APP_DIR" ]; then
  echo "Destino existe e não é um clone Git: $APP_DIR. Nada foi sobrescrito." >&2
  echo 'Defina G22_APP_DIR para outro caminho ou escolha manualmente um destino após inspecioná-lo.' >&2
  exit 1
else
  [ -n "$REPO_URL" ] || { echo 'Informe a URL do repositório como argumento ou em G22_REPO_URL.' >&2; exit 1; }
  git clone "$REPO_URL" "$APP_DIR"
fi

"$APP_DIR/scripts/bootstrap-termux.sh"
printf 'Deploy concluído em %s. O serviço não foi iniciado automaticamente.\n' "$APP_DIR"
