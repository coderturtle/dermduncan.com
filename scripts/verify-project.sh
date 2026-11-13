#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT_DIR/.project-setup/logs"
LOG_FILE="$LOG_DIR/verify-project.log"
failures=0

usage() {
  echo "Usage: $0 [--dry-run]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

log() {
  echo "$1"
  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$LOG_DIR"
    printf "%s %s\n" "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$1" >> "$LOG_FILE"
  fi
}

check_file() {
  if [ -f "$ROOT_DIR/$1" ]; then
    log "OK: $1"
  else
    log "MISSING: $1"
    failures=$((failures + 1))
  fi
}

for path in \
  docs/setup.md \
  docs/local-assumptions.md \
  docs/reproducibility.md \
  .env.example \
  scripts/check-prereqs.sh \
  scripts/bootstrap-project.sh \
  scripts/verify-project.sh \
  .hekton/project.yaml \
  config.toml; do
  check_file "$path"
done

if ! "$ROOT_DIR/scripts/check-public-boundary.sh"; then
  failures=$((failures + 1))
fi

if [ "$failures" -ne 0 ]; then
  log "Verification failed with $failures issue(s)"
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  log "Mode: dry-run"
  log "Would run: hugo --minify"
elif command -v hugo >/dev/null 2>&1; then
  hugo --minify
else
  log "Skipping 'hugo --minify' because the hugo CLI is not installed. Run ./scripts/check-prereqs.sh for install guidance."
fi

log "Verification passed"
