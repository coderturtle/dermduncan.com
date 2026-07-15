# Reproducibility

This project should be rebuildable on a future blank Hekton machine using documented scripts, plus out-of-band GitHub configuration for deployment.

## Blank-Machine Flow

```bash
git clone git@github.com-coderturtle:coderturtle/dermduncan.com.git ~/Development/hekton/factory-output/dermduncan.com
cd ~/Development/hekton/factory-output/dermduncan.com
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

| Variable | Purpose | Value at adoption time |
|---|---|---|
| `AWS_REGION` | AWS region for the deploy role/S3 bucket | `us-east-1` |
| `BUCKET_NAME` | S3 bucket the built site syncs to | `dermduncan.com` |
| `CF_DISTRIBUTION_ID` | CloudFront distribution to invalidate on deploy | `E1YNDLEZ2TCKQ8` |
| `HUGO_VERSION` | Hugo CLI version installed in CI | `0.123.7` |
| `ROLE_TO_ASSUME` | AWS IAM role ARN assumed via OIDC for the deploy | `arn:aws:iam::600059206606:role/dermduncan_hugo_s3deployer` |
| `SITE_BASE_URL` | Base URL passed to `hugo --baseURL` | `https://dermduncan.com` |
| `CODE_SESSION_NAME` | OIDC role session name | `GHA-DERMDUNCAN-S3` |

These were read with `gh variable list -R coderturtle/dermduncan.com` (read-only; these are GitHub Actions variables, not secrets, and were not modified).

## Rules

- Keep local-only files out of Git going forward — a `.gitignore` is a recorded follow-up (`docs/next-actions.md`), not added during adoption.
- Do not commit `.env` files.
- Document any new external services before adding automation.
- Keep theme upgrades, content changes, and dependency-equivalent changes separate from adoption or documentation-only commits.
