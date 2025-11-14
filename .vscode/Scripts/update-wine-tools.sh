#!/usr/bin/env bash
set -Eeuo pipefail

log() { printf '[%(%Y-%m-%dT%H:%M:%SZ)T] %s\n' -1 "$*"; }

# --- Make sure asdf is available for BOTH old (bash) and new (Go) installs ---
if ! command -v asdf >/dev/null 2>&1; then
  # Go build puts the binary here:
  if [ -x "$HOME/.asdf/bin/asdf" ]; then
    export PATH="$HOME/.asdf/bin:$PATH"
  fi
fi
if ! command -v asdf >/dev/null 2>&1 && [ -f "$HOME/.asdf/asdf.sh" ]; then
  # Older bash implementation
  . "$HOME/.asdf/asdf.sh"
fi
if ! command -v asdf >/dev/null 2>&1; then
  log "ERROR: asdf is not available on PATH. Aborting."
  exit 127
fi

log "asdf version: $(asdf --version || echo unknown)"
log "Refreshing asdf shims (picks up any updated Windows binaries you point to)..."
asdf reshim
log "Done."

