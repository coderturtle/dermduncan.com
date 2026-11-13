#!/usr/bin/env bash
# Publish a built Hugo site to S3 with per-type Cache-Control metadata.
#
# Usage: scripts/deploy-site.sh <public-dir> <bucket-name> [extra aws global options...]
#   e.g. scripts/deploy-site.sh ./public "$BUCKET_NAME"
# Extra options (such as --endpoint-url) are passed straight to the aws CLI; they
# exist for local testing and are not used by the production workflow.
#
# 1. `s3 sync --delete` removes objects no longer in the build and uploads new
#    files, defaulting to the HTML (revalidate) policy. No --size-only: that flag
#    skipped edited files whose byte length was unchanged.
# 2. Every file is then re-uploaded with `s3 cp --recursive`, one pass per cache
#    class (see scripts/cache-policy.sh). This rewrites the object metadata on
#    every deploy, including objects whose content did not change, so policy
#    changes take effect on the first deploy. HTML goes last.
# Content types are guessed by the aws CLI from file extensions, as before.
# CloudFront invalidation stays in the workflow, after this script.
set -euo pipefail

SRC="${1:?usage: deploy-site.sh <public-dir> <bucket-name> [aws options...]}"
BUCKET="${2:?usage: deploy-site.sh <public-dir> <bucket-name> [aws options...]}"
shift 2
GLOBAL=("$@")
# shellcheck source=scripts/cache-policy.sh
source "$(dirname "$0")/cache-policy.sh"

if [ ! -f "$SRC/index.html" ]; then
  echo "deploy-site: $SRC/index.html not found; refusing to sync an empty or wrong directory" >&2
  exit 1
fi

s3() { aws ${GLOBAL[@]+"${GLOBAL[@]}"} s3 "$@"; }
cp_class() {  # cp_class <cache-control> <include-pattern...>: uploads matching files only
  local cc="$1"; shift
  local args=(--exclude "*") p
  for p in "$@"; do args+=(--include "$p"); done
  s3 cp "$SRC/" "s3://$BUCKET" --recursive "${args[@]}" --cache-control "$cc"
}

echo "deploy-site: sync with --delete"
s3 sync "$SRC/" "s3://$BUCKET" --delete --cache-control "$CC_HTML"

echo "deploy-site: assets (images, icons, fonts, documents)"
asset_args=()
for p in "*.html" "${CODE_PATTERNS[@]}" "${FEED_PATTERNS[@]}"; do asset_args+=(--exclude "$p"); done
s3 cp "$SRC/" "s3://$BUCKET" --recursive "${asset_args[@]}" --cache-control "$CC_ASSET"
echo "deploy-site: non-versioned CSS and JS"
cp_class "$CC_CODE" "${CODE_PATTERNS[@]}"
echo "deploy-site: content-hashed assets"
cp_class "$CC_IMMUTABLE" "${HASHED_PATTERNS[@]}"
echo "deploy-site: feeds, sitemap and generated text"
cp_class "$CC_FEED" "${FEED_PATTERNS[@]}"
echo "deploy-site: HTML"
cp_class "$CC_HTML" "*.html"
