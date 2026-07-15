# Risks

## Open

### RISK-0001 - No .gitignore; built public/ output and .DS_Store files are tracked

There is no `.gitignore` in the repo. The Hugo build output (`public/`) and 10 tracked `.DS_Store` files (root, `content/`, `docs/`, `old/`, `old/docs/`, `public/`, `public/img/`, `static/`, `static/img/`, `themes/`) are tracked in Git. Add a `.gitignore` and untrack these in a dedicated hygiene commit after adoption, not inside it.

### RISK-0003 - Hugo version and theme provenance are not documented in-repo

Hugo `0.123.7` (extended edition) is pinned only via the `HUGO_VERSION` GitHub Actions repository variable, not documented locally until this adoption pass. `docs/setup.md` tells a human to `brew install hugo` but doesn't say "extended," and `scripts/check-prereqs.sh` accepts any `hugo` binary without checking version or edition — a blank-machine rebuild can silently end up on a different Hugo than CI uses. `themes/hugo-resume` is vendored directly with no `.gitmodules` and no recorded upstream version, despite the CI workflow requesting `submodules: recursive`.

### RISK-0004 - Deploy workflow depends on undocumented GitHub Actions repository variables

`.github/workflows/main.yml` requires `AWS_REGION`, `BUCKET_NAME`, `CF_DISTRIBUTION_ID`, `HUGO_VERSION`, `ROLE_TO_ASSUME`, `SITE_BASE_URL`, and `CODE_SESSION_NAME` to already be set as GitHub Actions repository variables. None of these were tracked in-repo before adoption. Their names (not current values — this repo is public, see `docs/decisions.md`) are now recorded in `docs/reproducibility.md`.

### RISK-0005 - Certification PDF links are broken on the live production site

`content/projects/contributions/*.md` (7 files) link to `/docs/*.pdf`, but `docs/` is a plain repo directory, not under `static/`, so Hugo never copies those PDFs into the deployed `public/` output and the S3 sync step only uploads `./public/`. Verified live 2026-07-15: `https://dermduncan.com/` returns 200, but all 7 `https://dermduncan.com/docs/*.pdf` links return 404. Pre-existing production defect, not introduced by adoption — left unfixed per the no-refactor-during-adoption rule, but flagged here since it affects real visitor-facing content.

## Accepted

### RISK-0002 - Personal contact details are committed in config.toml

`config.toml` contains the site owner's real email, phone number, and address. This is intentional, already-public CV content on the live site — accepted as-is, not a defect. Re-confirm with the owner before adding further personal data during any future content change.
