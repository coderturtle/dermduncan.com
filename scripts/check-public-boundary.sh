#!/usr/bin/env bash
# Fails if private editorial material is staged (pre-commit) or tracked (CI/verify).
# Usage: scripts/check-public-boundary.sh [--staged]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
if [ "${1:-}" = "--staged" ]; then
  files=$(git diff --cached --name-only --diff-filter=ACMR)
  content() { git show ":$1" 2>/dev/null || true; }
else
  files=$(git ls-files)
  content() { cat "$1" 2>/dev/null || true; }
fi
fail=0
# 1. Private paths must never be tracked.
if echo "$files" | grep -E '^(docs/rebuild/|docs/private/)|\.private\.md$|claims-register' >/dev/null; then
  echo "BOUNDARY: private editorial file staged/tracked:"; echo "$files" | grep -E '^(docs/rebuild/|docs/private/)|\.private\.md$|claims-register'; fail=1
fi
# 2. Site source must not carry internal editorial notes.
for f in $(echo "$files" | grep -E '^(data|content|layouts|assets|config\.toml)' || true); do
  if content "$f" | grep -nE 'notes_internal|needs_confirmation|claims-register|\bC[0-9]{2}[ab]?\b' >/dev/null; then
    echo "BOUNDARY: internal editorial note in $f:"; content "$f" | grep -nE 'notes_internal|needs_confirmation|claims-register|\bC[0-9]{2}[ab]?\b' | head -5; fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "public boundary: OK"
exit "$fail"
