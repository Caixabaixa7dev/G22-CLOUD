#!/data/data/com.termux/files/usr/bin/bash
set -eu
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
"$SCRIPT_DIR/stop-termux.sh"
"$SCRIPT_DIR/start-termux.sh"
