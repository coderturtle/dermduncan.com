#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT_DIR/.project-setup/logs"
LOG_FILE="$LOG_DIR/bootstrap-project.log"

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

log "Bootstrapping dermduncan.com"
if [ "$DRY_RUN" -eq 1 ]; then
  log "Mode: dry-run"
  "$ROOT_DIR/scripts/check-prereqs.sh" --dry-run || true
  log "Would run: hugo --minify (build check only, no deploy)"
else
  log "Mode: apply"
  mkdir -p "$LOG_DIR"
  "$ROOT_DIR/scripts/check-prereqs.sh"
  log "No package install step required (Hugo has no lockfile/dependency manager)."
fi

log "Bootstrap complete"
