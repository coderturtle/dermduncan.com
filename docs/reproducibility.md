# Reproducibility

This project should be rebuildable on a future blank Hekton machine using documented scripts, plus out-of-band GitHub configuration for deployment.

## Blank-Machine Flow

```bash
git clone git@github.com-coderturtle:coderturtle/dermduncan.com.git <hekton>/factory-output/dermduncan.com
cd <hekton>/factory-output/dermduncan.com
./scripts/check-prereqs.sh
./scripts/bootstrap-project.sh --dry-run
./scripts/bootstrap-project.sh
./scripts/verify-project.sh
```

## What Bootstrap Does

- Checks for `git`, `bash`, and `hugo`.
- Writes setup logs under `.project-setup/logs/`.
- Does not install Hugo itself (see `docs/setup.md` for the `brew install hugo` step) — installing tools stays a documented manual/CLI step, not an opaque automated one.

## What Verify Does

- Checks required Hekton setup files.
- Runs `hugo --minify` when the `hugo` CLI is available; otherwise records that the check was skipped.

## Deployment Configuration (Not Tracked In-Repo)

`.github/workflows/main.yml` deploys to AWS on every push to `main`. It depends on these GitHub Actions repository variables, which must be configured in the GitHub repo settings (not in Git) before a fresh deploy will work:

| Variable | Purpose |
|---|---|
| `AWS_REGION` | AWS region for the deploy role/S3 bucket |
| `BUCKET_NAME` | S3 bucket the built site syncs to |
| `CF_DISTRIBUTION_ID` | CloudFront distribution to invalidate on deploy |
| `HUGO_VERSION` | Hugo CLI version installed in CI (extended edition — see `docs/local-assumptions.md`) |
| `ROLE_TO_ASSUME` | AWS IAM role ARN assumed via OIDC for the deploy |
| `SITE_BASE_URL` | Base URL passed to `hugo --baseURL` |
| `CODE_SESSION_NAME` | OIDC role session name |

Current values were read with `gh variable list -R coderturtle/dermduncan.com` (read-only; these are GitHub Actions variables, not secrets, so the command itself didn't touch anything) but are deliberately **not** repeated here: this repo is public, and the account ID embedded in the IAM role ARN plus the CloudFront distribution ID are more exposed by sitting in a permanently-tracked doc than by living in GitHub's variables UI, which requires repo write access to view even on a public repo. See `docs/decisions.md`. A repo admin can fetch current values with the same `gh variable list` command.

### How the upload works

The deploy job calls `scripts/deploy-site.sh ./public "$BUCKET_NAME"`:

1. `aws s3 sync ./public/ s3://<bucket> --delete` removes objects that are no longer built and uploads new files. The earlier `--size-only` flag is gone: it skipped edited pages whose byte length did not change.
2. Every file is then re-uploaded with `aws s3 cp --recursive`, one pass per cache class, so object metadata (including `Cache-Control`) is rewritten on every deploy, not only for files whose content changed. HTML is uploaded last.

CloudFront is then invalidated for `/*`, as before. Content types are guessed by the AWS CLI from file extensions, as before.

### Cache policy

Defined once in `scripts/cache-policy.sh`:

| Files | Cache-Control |
|---|---|
| HTML | `no-cache, max-age=0, must-revalidate` |
| Feeds, sitemap, `*.txt`, `*.json`, `*.webmanifest` | `public, max-age=300, must-revalidate` |
| Content-hashed assets (`name.<16+ hex>.ext`, e.g. the fingerprinted CSS and JS) | `public, max-age=31536000, immutable` |
| Non-versioned CSS and JS (the plain `site.css` / `site.js` kept for old cached pages) | `public, max-age=3600` |
| Other non-versioned assets (images, icons, fonts, PDFs) | `public, max-age=86400` |

CloudFront (checked 2026-11-13) uses legacy cache settings with MinTTL 0, DefaultTTL 86400 and MaxTTL 31536000, no response-headers policy and no edge functions, so it honours these origin headers. Query strings are not part of the cache key.

### Tests

`scripts/test-deploy-site.sh` runs in the PR build check with no AWS credentials or network access: a stub `aws` emulates S3 against a local directory. Starting from a bucket in the old state (everything `max-age=31536000`), it reproduces the old same-length skip, then checks that `deploy-site.sh` publishes the edit, deletes removed pages, and gives every object the policy's `Cache-Control`, including unchanged HTML. It also checks that `main.yml` keeps its bucket variable and `/*` invalidation.

### Post-deployment smoke check

After a deploy, build the deployed commit with the production Hugo version and compare with the live site:

```sh
hugo --minify -d /tmp/dd-site
scripts/smoke-check-live.sh /tmp/dd-site / /career/ /path/you/changed/
```

For each path it checks the delivered bytes and the `Cache-Control` header against the policy, retrying for up to `SMOKE_TIMEOUT` seconds (default 600) while the CloudFront invalidation completes. It prints `x-cache` and `age` so a stale edge is visible.

### Known limitation: browsers that cached the old site

Before this change every file, HTML included, was served with `max-age=31536000`. A browser that visited before the fix may reuse its copy of a page or stylesheet for up to a year without asking the server, and nothing on the server side can recall it. A normal reload usually revalidates the page itself, but not always its stylesheet. Once a browser has fetched a page under the new policy, later changes appear on the next visit.

To give someone a guaranteed-fresh view (for example when announcing the updated profile), share a URL their browser has never fetched, such as `https://dermduncan.com/?ref=profile-2026`. The query string is ignored by CloudFront's cache key, so it serves the current page, while the browser treats it as a new URL. Since the CSS and JS are now fingerprinted (`/css/site.<sha256>.css`, `/js/site.<sha256>.js`), a page fetched fresh always loads the matching styles and script, even in a browser holding an old `/css/site.css`. The plain `/css/site.css` and `/js/site.js` are still published, so pages cached under the old policy keep working until they expire.

## Rules

- Keep local-only files out of Git going forward — a `.gitignore` is a recorded follow-up (`docs/next-actions.md`), not added during adoption.
- Do not commit `.env` files.
- Document any new external services before adding automation.
- Keep theme upgrades, content changes, and dependency-equivalent changes separate from adoption or documentation-only commits.
