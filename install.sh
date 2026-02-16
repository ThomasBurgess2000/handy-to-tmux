#!/usr/bin/env bash
set -euo pipefail

DEST="$HOME/.local/bin/handy-to-tmux"
mkdir -p "$(dirname "$DEST")"
cp handy-to-tmux "$DEST"
chmod +x "$DEST"
echo "Installed to $DEST"
