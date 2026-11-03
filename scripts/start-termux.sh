#!/data/data/com.termux/files/usr/bin/bash
set -eu

APP_DIR="${G22_APP_DIR:-$HOME/g22-cloud-server}"
STATE_DIR="${G22_STATE_DIR:-$HOME/.local/share/g22-cloud-server}"
PID_FILE="$STATE_DIR/run/api.pid"
LOG_FILE="$STATE_DIR/logs/api.log"

[ -f "$APP_DIR/apps/termux-api/server.js" ] || { echo "Aplicação não encontrada em $APP_DIR" >&2; exit 1; }
mkdir -p "$STATE_DIR/run" "$STATE_DIR/logs"
if [ -f "$PID_FILE" ]; then
  old_pid="$(cat "$PID_FILE")"
  case "$old_pid" in *[!0-9]*|'') echo 'Arquivo PID inválido; examine antes de removê-lo.' >&2; exit 1 ;; esac
  if kill -0 "$old_pid" 2>/dev/null; then echo "API aparentemente já está ativa (PID $old_pid)."; exit 0; fi
  rm -f "$PID_FILE"
fi

cd "$APP_DIR"
HOST="${HOST:-127.0.0.1}" PORT="${PORT:-3000}" nohup node apps/termux-api/server.js >>"$LOG_FILE" 2>&1 </dev/null &
pid=$!
printf '%s\n' "$pid" > "$PID_FILE"
sleep 1
if kill -0 "$pid" 2>/dev/null; then echo "API iniciada (PID $pid), endereço ${HOST:-127.0.0.1}:${PORT:-3000}."; else rm -f "$PID_FILE"; echo 'A API encerrou ao iniciar; consulte logs.' >&2; exit 1; fi
