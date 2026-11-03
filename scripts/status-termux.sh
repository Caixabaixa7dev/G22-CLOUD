#!/data/data/com.termux/files/usr/bin/bash
set -eu

APP_DIR="${G22_APP_DIR:-$HOME/g22-cloud-server}"
STATE_DIR="${G22_STATE_DIR:-$HOME/.local/share/g22-cloud-server}"
PID_FILE="$STATE_DIR/run/api.pid"
printf 'Aplicação: %s\n' "$APP_DIR"
if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE")"
  case "$pid" in *[!0-9]*|'') echo 'Estado: arquivo PID inválido'; exit 1 ;; esac
  if kill -0 "$pid" 2>/dev/null; then echo "Estado: processo ativo (PID $pid)"; else echo 'Estado: processo encerrado (PID obsoleto)'; fi
else
  echo 'Estado: parada (sem PID registrado)'
fi
if command -v curl >/dev/null 2>&1; then
  curl --max-time 2 --silent --show-error "http://${HOST:-127.0.0.1}:${PORT:-3000}/health" || true
  printf '\n'
else
  echo 'Health check HTTP: curl indisponível.'
fi
