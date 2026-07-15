# Risks

## Open

### RISK-0001 - No .gitignore; built public/ output and .DS_Store files are tracked

There is no `.gitignore` in the repo. The Hugo build output (`public/`) and `.DS_Store` files at several levels (root, `content/`, `docs/`, `old/`, `public/`, `public/img/`, `themes/`) are tracked in Git. Add a `.gitignore` and untrack these in a dedicated hygiene commit after adoption, not inside it.

### RISK-0003 - Hugo version and theme provenance are not documented in-repo

Hugo `0.123.7` is pinned only via the `HUGO_VERSION` GitHub Actions repository variable, not documented locally until this adoption pass. `themes/hugo-resume` is vendored directly with no `.gitmodules` and no recorded upstream version, despite the CI workflow requesting `submodules: recursive`.

### RISK-0004 - Deploy workflow depends on undocumented GitHub Actions repository variables

`.github/workflows/main.yml` requires `AWS_REGION`, `BUCKET_NAME`, `CF_DISTRIBUTION_ID`, `HUGO_VERSION`, `ROLE_TO_ASSUME`, `SITE_BASE_URL`, and `CODE_SESSION_NAME` to already be set as GitHub Actions repository variables. None of these were tracked in-repo before adoption; current values are now recorded in `docs/reproducibility.md`.

## Accepted

### RISK-0002 - Personal contact details are committed in config.toml

`config.toml` contains the site owner's real email, phone number, and address. This is intentional, already-public CV content on the live site — accepted as-is, not a defect. Re-confirm with the owner before adding further personal data during any future content change.
