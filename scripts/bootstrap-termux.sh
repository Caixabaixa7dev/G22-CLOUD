#!/data/data/com.termux/files/usr/bin/bash
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
STATE_DIR="${G22_STATE_DIR:-$HOME/.local/share/g22-cloud-server}"

command -v node >/dev/null 2>&1 || { echo 'Node.js não encontrado. Instale-o pelo Termux antes do bootstrap.' >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo 'npm não encontrado.' >&2; exit 1; }
mkdir -p "$STATE_DIR/logs" "$STATE_DIR/run"
cd "$ROOT"
npm ci --omit=dev
printf 'Bootstrap concluído. Código: %s | Dados/logs: %s\n' "$ROOT" "$STATE_DIR"
