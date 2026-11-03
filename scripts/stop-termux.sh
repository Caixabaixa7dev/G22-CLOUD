#!/data/data/com.termux/files/usr/bin/bash
set -eu

STATE_DIR="${G22_STATE_DIR:-$HOME/.local/share/g22-cloud-server}"
PID_FILE="$STATE_DIR/run/api.pid"
[ -f "$PID_FILE" ] || { echo 'Arquivo PID ausente; API não iniciada por este script.'; exit 0; }
pid="$(cat "$PID_FILE")"
case "$pid" in *[!0-9]*|'') echo 'Arquivo PID inválido; nenhum processo foi encerrado.' >&2; exit 1 ;; esac
if ! kill -0 "$pid" 2>/dev/null; then rm -f "$PID_FILE"; echo 'Processo já encerrado; arquivo PID obsoleto removido.'; exit 0; fi
if [ -r "/proc/$pid/cmdline" ] && ! tr '\000' ' ' <"/proc/$pid/cmdline" | grep -Fq 'apps/termux-api/server.js'; then
  echo 'O PID não parece pertencer à API; não foi encerrado.' >&2
  exit 1
fi
kill -TERM "$pid"
for _ in 1 2 3 4 5 6 7 8 9 10; do
  if ! kill -0 "$pid" 2>/dev/null; then rm -f "$PID_FILE"; echo 'API encerrada.'; exit 0; fi
  sleep 1
exit 1
