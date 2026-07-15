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

## Rules

- Keep local-only files out of Git going forward — a `.gitignore` is a recorded follow-up (`docs/next-actions.md`), not added during adoption.
- Do not commit `.env` files.
- Document any new external services before adding automation.
- Keep theme upgrades, content changes, and dependency-equivalent changes separate from adoption or documentation-only commits.
