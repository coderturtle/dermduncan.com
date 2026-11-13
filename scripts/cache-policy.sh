# Cache-Control policy for the deployed site. Sourced by scripts/deploy-site.sh
# (to set S3 object metadata) and scripts/smoke-check-live.sh (to verify the
# headers delivered through CloudFront). Keep the two in step by editing only
# this file.
#
# CloudFront (verified 2026-11-13): legacy cache settings, MinTTL 0,
# DefaultTTL 86400, MaxTTL 31536000, no response-headers policy, no edge
# functions, query strings not in the cache key. With MinTTL 0, CloudFront
# honours these origin headers.

# HTML: always revalidate, so a deploy is visible on the next page load.
CC_HTML="no-cache, max-age=0, must-revalidate"
# Feeds, sitemap, robots, search indexes and other generated text: short cache.
CC_FEED="public, max-age=300, must-revalidate"
# Content-hashed assets (name.<16+ hex>.ext): safe to cache forever.
CC_IMMUTABLE="public, max-age=31536000, immutable"
# Non-versioned CSS and JS: conservative until asset fingerprinting exists.
CC_CODE="public, max-age=3600"
# Non-versioned images, icons, fonts and documents: conservative.
CC_ASSET="public, max-age=86400"

# aws s3 --include patterns per class (later filters take precedence).
FEED_PATTERNS=("*.xml" "*.txt" "*.json" "*.webmanifest")
CODE_PATTERNS=("*.css" "*.js")
HASH16="[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]"
HASHED_PATTERNS=("*.${HASH16}*.css" "*.${HASH16}*.js" "*.${HASH16}*.woff2" "*.${HASH16}*.png" "*.${HASH16}*.svg" "*.${HASH16}*.webp")

# Expected Cache-Control for a site path (used by checks and tests).
cache_control_for() {
  local p="$1"
  case "$p" in
    */|*.html) echo "$CC_HTML"; return ;;
  esac
  if [[ "$p" =~ \.[0-9a-f]{16,}[^/]*\.(css|js|woff2|png|svg|webp)$ ]]; then echo "$CC_IMMUTABLE"; return; fi
  case "$p" in
    *.xml|*.txt|*.json|*.webmanifest) echo "$CC_FEED" ;;
    *.css|*.js) echo "$CC_CODE" ;;
    *) echo "$CC_ASSET" ;;
  esac
}
