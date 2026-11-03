#!/data/data/com.termux/files/usr/bin/bash
set -eu
LOG_FILE="${G22_STATE_DIR:-$HOME/.local/share/g22-cloud-server}/logs/api.log"
if [ ! -f "$LOG_FILE" ]; then echo "Log ainda não existe: $LOG_FILE"; exit 0; fi
tail -n "${1:-100}" "$LOG_FILE"
