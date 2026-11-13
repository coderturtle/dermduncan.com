#!/usr/bin/env bash
# Post-deployment smoke check: compare files from a local production build of
# the deployed commit with the live site, byte for byte, and check that each
# response carries the Cache-Control header set by scripts/cache-policy.sh.
#
# Usage: scripts/smoke-check-live.sh <public-dir> [path ...]
#   e.g. hugo --minify -d /tmp/dd-site && scripts/smoke-check-live.sh /tmp/dd-site / /career/
# Defaults: home, career, sitemap, favicon, plain and fingerprinted CSS/JS.
#
# CloudFront caching: the deploy invalidates /*, but edges can serve the old
# copy until the invalidation completes (usually a few minutes). Each path is
# retried until content and header both match, or SMOKE_TIMEOUT seconds pass
# (default 600). CloudFront's x-cache and age headers are printed so a stale
# edge is visible. Query strings are not part of this distribution's cache key,
# so they are not used to bypass it.
set -euo pipefail

SRC="${1:?usage: smoke-check-live.sh <public-dir> [path ...]}"
shift
BASE="${SMOKE_BASE_URL:-https://dermduncan.com}"
TIMEOUT="${SMOKE_TIMEOUT:-600}"
INTERVAL="${SMOKE_INTERVAL:-20}"
# shellcheck source=scripts/cache-policy.sh
source "$(dirname "$0")/cache-policy.sh"
if [ $# -eq 0 ]; then
  # Home, career, sitemap, favicon, the fingerprinted CSS/JS the home page links
  # to, and the plain /css/site.css kept for pages cached under the old policy.
  hashed=$(grep -o -E '(href|src)="?/(css|js)/site\.[0-9a-f]{16,}\.(css|js)' "$SRC/index.html" | sed -E 's/^(href|src)="?//' | sort -u)
  # shellcheck disable=SC2086
  set -- / /career/ /sitemap.xml /favicon.ico /css/site.css $hashed
fi

norm() { tr -d '\r' | tr 'A-Z' 'a-z' | sed -E 's/[[:space:]]*,[[:space:]]*/, /g; s/^[[:space:]]+|[[:space:]]+$//g'; }

fail=0
for path in "$@"; do
  file="$SRC$path"; [ "${path%/}" != "$path" ] && file="${file}index.html"
  if [ ! -f "$file" ]; then echo "MISSING LOCAL $path ($file)"; fail=1; continue; fi
  want="$(shasum -a 256 < "$file" | cut -d' ' -f1)"
  want_cc="$(cache_control_for "$path" | norm)"
  deadline=$(( $(date +%s) + TIMEOUT ))
  while :; do
    hdr="$(mktemp)"
    got="$(curl -sS -D "$hdr" "$BASE$path" | shasum -a 256 | cut -d' ' -f1)"
    got_cc="$(grep -i '^cache-control:' "$hdr" | head -1 | cut -d: -f2- | norm)"
    info="$(grep -i -E '^(x-cache|age):' "$hdr" | tr -d '\r' | tr '\n' ' ')"; rm -f "$hdr"
    body_ok=$([ "$got" = "$want" ] && echo yes || echo no)
    cc_ok=$([ "$got_cc" = "$want_cc" ] && echo yes || echo no)
    if [ "$body_ok" = yes ] && [ "$cc_ok" = yes ]; then
      echo "OK    $path  [cache-control: $got_cc] $info"; break
    fi
    if [ "$(date +%s)" -ge "$deadline" ]; then
      echo "FAIL  $path  content:$body_ok cache-control:$cc_ok (got [$got_cc], want [$want_cc]) $info"
      fail=1; break
    fi
    sleep "$INTERVAL"
  done
done
exit $fail
