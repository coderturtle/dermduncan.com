#!/usr/bin/env bash
# Deployment-free test for scripts/deploy-site.sh. Needs no AWS credentials and
# makes no network calls: a stub `aws` on PATH emulates the documented S3 CLI
# comparison rules against a local directory standing in for the bucket.
#
# Scenario: deploy v1; edit a page so its byte length is unchanged and its
# timestamp is no newer than the bucket copy (the worst case for any
# size/time comparison); then show that the previous command
# (`sync --size-only`) skips the edit while deploy-site.sh publishes it.
# Also checks deletion and cache-control, and that the deploy workflow uses the
# script without --size-only and keeps its target and invalidation.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
mkdir -p "$T/bin" "$T/site/blog" "$T/bucket"

cat > "$T/bin/aws" <<'PY'
#!/usr/bin/env python3
"""Minimal emulation of `aws s3 sync` / `aws s3 cp --recursive` for tests.
Bucket = $FAKE_S3_ROOT/<bucket>. Object metadata (size, mtime, cache-control)
is kept in a JSON sidecar. Comparison rules follow the AWS CLI docs:
sync uploads when the object is missing, the size differs, or (unless
--size-only) the local file is newer than the object; --delete removes objects
with no local file. cp --recursive always uploads matching files."""
import fnmatch, json, os, shutil, sys, time
args = [a for a in sys.argv[1:]]
while args and args[0].startswith("--"):          # global options (e.g. --endpoint-url x)
    args = args[2:]
assert args[0] == "s3", args
cmd, src, dst = args[1], args[2], args[3]
opts = args[4:]
bucket = dst.replace("s3://", "").strip("/")
broot = os.path.join(os.environ["FAKE_S3_ROOT"], bucket)
os.makedirs(broot, exist_ok=True)
metaf = os.path.join(os.environ["FAKE_S3_ROOT"], bucket + ".meta.json")
meta = json.load(open(metaf)) if os.path.exists(metaf) else {}
def opt(name):
    return opts[opts.index(name) + 1] if name in opts else None
cc = opt("--cache-control")
log = open(os.environ["FAKE_S3_LOG"], "a")
log.write(" ".join(sys.argv[1:]) + "\n")
local = {}
for d, _, fs in os.walk(src):
    for f in fs:
        p = os.path.join(d, f); local[os.path.relpath(p, src)] = p
def upload(key, path):
    os.makedirs(os.path.dirname(os.path.join(broot, key)) or broot, exist_ok=True)
    shutil.copyfile(path, os.path.join(broot, key))
    meta[key] = {"size": os.path.getsize(path), "mtime": time.time(), "cache_control": cc}
    print(f"upload: {key}")
if cmd == "sync":
    for key, path in sorted(local.items()):
        m = meta.get(key)
        if (m is None or os.path.getsize(path) != m["size"]
                or ("--size-only" not in opts and os.path.getmtime(path) > m["mtime"])):
            upload(key, path)
    if "--delete" in opts:
        for key in sorted(set(meta) - set(local)):
            os.remove(os.path.join(broot, key)); del meta[key]; print(f"delete: {key}")
elif cmd == "cp" and "--recursive" in opts:
    rules = [(opts[i], opts[i + 1]) for i in range(len(opts) - 1) if opts[i] in ("--exclude", "--include")]
    for key, path in sorted(local.items()):
        keep = True
        for kind, pat in rules:
            if fnmatch.fnmatch(key, pat):
                keep = kind == "--include"
        if keep:
            upload(key, path)
else:
    sys.exit(f"fake aws: unsupported command {args}")
json.dump(meta, open(metaf, "w"))
PY
chmod +x "$T/bin/aws"
export PATH="$T/bin:$PATH" FAKE_S3_ROOT="$T/bucket" FAKE_S3_LOG="$T/aws.log"

fail=0
check() { if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi; }
B="$T/bucket/test-bucket"

# v1 of the site, uploaded the way production did before this change.
mkdir -p "$T/site/css" "$T/site/brand"
printf '<html><body>Published 2024</body></html>\n' > "$T/site/index.html"
printf '<html><body>Career</body></html>\n' > "$T/site/career.html"
printf '<html><body>Old page</body></html>\n' > "$T/site/blog/old.html"
printf 'body{}\n' > "$T/site/css/site.css"
printf 'body{}\n' > "$T/site/css/site.min.0123456789abcdef0123456789abcdef.css"
printf '<svg/>\n' > "$T/site/brand/mark.svg"
printf '<urlset/>\n' > "$T/site/sitemap.xml"
aws s3 sync "$T/site/" s3://test-bucket --size-only --delete --cache-control max-age=31536000 >/dev/null
check "fixture starts with every object at max-age=31536000" 'python3 -c "import json,sys; m=json.load(open(sys.argv[1])); sys.exit(0 if m and all(v[\"cache_control\"]==\"max-age=31536000\" for v in m.values()) else 1)" "$B.meta.json"'

# Same-length edit with an old timestamp; career.html left untouched; a page removed.
printf '<html><body>Published 2025</body></html>\n' > "$T/site/index.html"
touch -t 200001010000 "$T/site/index.html"
rm "$T/site/blog/old.html"
check "edit keeps the same byte length" '[ "$(wc -c < "$T/site/index.html")" -eq "$(wc -c < "$B/index.html")" ]'

# Previous production command: the edit is silently skipped.
aws s3 sync "$T/site/" s3://test-bucket --size-only --delete --cache-control max-age=31536000 >/dev/null
check "old 'sync --size-only' skips the same-length edit (reproduces the bug)" 'grep -q "2024" "$B/index.html"'

# New deploy script.
"$ROOT/scripts/deploy-site.sh" "$T/site" test-bucket >/dev/null
check "deploy-site.sh publishes the same-length edit" 'grep -q "2025" "$B/index.html"'
check "removed pages are deleted from the bucket" '[ ! -e "$B/blog/old.html" ]'
check "every object's Cache-Control matches scripts/cache-policy.sh, unchanged files included" 'bash -c '"'"'source "$1/scripts/cache-policy.sh"; python3 -c "import json,sys; print(\"\n\".join(k+\"\t\"+v[\"cache_control\"] for k,v in json.load(open(sys.argv[1])).items()))" "$2.meta.json" | while IFS=$'"'"'"'"'"'"'"'"'\t'"'"'"'"'"'"'"'"' read -r k cc; do want="$(cache_control_for "/$k")"; [ "$cc" = "$want" ] || { echo "  $k: got [$cc] want [$want]"; exit 1; }; done'"'"' _ "$ROOT" "$B"'
check "unchanged HTML (career.html) now revalidates" 'python3 -c "import json,sys; sys.exit(0 if json.load(open(sys.argv[1]))[\"career.html\"][\"cache_control\"].startswith(\"no-cache\") else 1)" "$B.meta.json"'
check "deploy-site.sh never passes --size-only" '[ "$(grep -c -- "--size-only" "$T/aws.log")" -eq 2 ]'  # only the two deliberate old-command runs
check "refuses to deploy a directory without index.html" '! "$ROOT/scripts/deploy-site.sh" "$T/bin" test-bucket >/dev/null 2>&1'

# The production workflow uses the script, keeps its target and invalidation.
W="$ROOT/.github/workflows/main.yml"
check "main.yml no longer uses --size-only" '! grep -q -- "--size-only" "$W"'
check "main.yml deploys via scripts/deploy-site.sh to vars.BUCKET_NAME" 'grep -q "scripts/deploy-site.sh ./public \"\${{ vars.BUCKET_NAME }}\"" "$W"'
check "main.yml checks out deploy-site.sh and cache-policy.sh" 'grep -q "scripts/deploy-site.sh" "$W" && grep -q "scripts/cache-policy.sh" "$W"'
check "main.yml keeps the CloudFront invalidation of /*" 'grep -q "create-invalidation --distribution-id \${{ vars.CF_DISTRIBUTION_ID }} --paths \"/\*\"" "$W"'

exit $fail
