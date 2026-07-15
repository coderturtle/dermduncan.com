# Adoption Audit - dermduncan.com

Date: 2026-07-15

## Intake

- Source requested: `coderturtle/dermduncan.com`
- GitHub resolution: `coderturtle/dermduncan.com` (direct match, no resolution needed)
- Source URL: `https://github.com/coderturtle/dermduncan.com`
- Temporary intake path: `/private/tmp/hekton-adoption/dermduncan.com`
- Permanent local path: `/Users/hekton/Development/hekton/factory-output/dermduncan.com`
- Owner/account: `coderturtle`
- Privacy boundary: public
- Git history: preserve
- Upstream sync: keep possible

## Initial Inspection

- README reviewed: yes
- License reviewed: MIT License
- Dependency manifests reviewed: none (Hugo has no lockfile; theme is vendored directly under `themes/hugo-resume`)
- Setup docs reviewed: README states the site is built with Hugo
- `.gitignore` reviewed: absent — the built `public/` directory and `.DS_Store` files at several levels are tracked
- Remotes reviewed: origin points to `coderturtle/dermduncan.com`
- Recent history reviewed: latest commits are workflow/variable maintenance on the existing S3 deploy pipeline
- Generated/local-only files identified: tracked `public/` (Hugo build output), tracked `.DS_Store` files (root, `content/`, `docs/`, `old/`, `public/`, `public/img/`, `themes/`)
- Secrets scan performed: no tracked `.env` files, private keys, or obvious credential values found; grep for AWS key patterns, private key headers, and password/secret assignments returned nothing

## Classification

- Classification: `factory-output`
- Rationale: this is a public personal CV/portfolio website deliverable, not reusable Hekton platform machinery and not a time-boxed experimental lab.
- Vault control-plane path: `20-projects/factory-output/dermduncan.com`
- Canonical lifecycle stage: `active`
- Adoption status: `adopted`

## Technical Shape

- Framework: Hugo (static site generator)
- Theme: `hugo-resume`, vendored directly in `themes/hugo-resume` (no `.gitmodules`, despite the CI workflow requesting `submodules: recursive`)
- Content: Markdown under `content/`, structured JSON data under `data/` (education, experience, skills)
- Hosting: AWS S3 + CloudFront (private origin, OIDC-based deploy)
- Deployment: GitHub Actions (`.github/workflows/main.yml`) — builds with the Hugo CLI, uploads the `public/` artifact, assumes an AWS IAM role via OIDC, syncs to S3, invalidates CloudFront
- Deploy-time configuration: `AWS_REGION`, `BUCKET_NAME` (`dermduncan.com`), `CF_DISTRIBUTION_ID`, `HUGO_VERSION` (`0.123.7` at audit time), `ROLE_TO_ASSUME`, `SITE_BASE_URL` (`https://dermduncan.com`), `CODE_SESSION_NAME` — all set as GitHub Actions repository variables, not tracked in-repo

## Risk Review

- License risk: none — MIT, present at repo root
- Secrets risk: none found
- Personal-data risk: low — `config.toml` carries the owner's real email, phone, and address, which is intentional, already-public CV content
- Production risk: low — site is already live and deploying successfully; adoption made no behavior change
- Dependency risk: low — no package manager/lockfile; Hugo version is pinned via a CI variable but not documented locally
- Remote/publication risk: none — repo and site were already public before adoption

See `.hekton/risk-register.yaml` and `docs/risks.md` for the tracked risk entries.
