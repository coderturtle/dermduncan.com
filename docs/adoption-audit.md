# Adoption Audit - dermduncan.com

Date: 2026-07-15

## Intake

- Source requested: `coderturtle/dermduncan.com`
- GitHub resolution: `coderturtle/dermduncan.com` (direct match, no resolution needed)
- Source URL: `https://github.com/coderturtle/dermduncan.com`
- Temporary intake path: `/private/tmp/hekton-adoption/dermduncan.com`
- Permanent local path: `<hekton>/factory-output/dermduncan.com`
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
- Generated/local-only files identified: tracked `public/` (Hugo build output), tracked `.DS_Store` files — 10 total (root, `content/`, `docs/`, `old/`, `old/docs/`, `public/`, `public/img/`, `static/`, `static/img/`, `themes/`)
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
- Deploy-time configuration: `AWS_REGION`, `BUCKET_NAME`, `CF_DISTRIBUTION_ID`, `HUGO_VERSION` (`0.123.7` extended at audit time), `ROLE_TO_ASSUME`, `SITE_BASE_URL`, `CODE_SESSION_NAME` — all set as GitHub Actions repository variables, not tracked in-repo. Current values were read via `gh variable list` (read-only) but are deliberately not repeated here since this repo is public — see `docs/decisions.md`.

## Risk Review

- License risk: none — MIT, present at repo root
- Secrets risk: none found
- Personal-data risk: low — `config.toml` carries the owner's real email, phone, and address, which is intentional, already-public CV content
- Production risk: low overall, but one real defect confirmed live 2026-07-15 (post-initial-audit, during doubt-driven review): all 7 certification PDF links (`/docs/*.pdf`) 404 on the production site — see RISK-0005. Core site (homepage) and the deploy pipeline itself are confirmed working (curl 200).
- Dependency risk: low — no package manager/lockfile; Hugo version and edition (extended) are pinned via a CI variable but weren't enforced locally until this pass
- Remote/publication risk: none — repo and site were already public before adoption

See `.hekton/risk-register.yaml` and `docs/risks.md` for the tracked risk entries.

## Addendum — Doubt-Driven Review (2026-07-15)

Before pushing, this adoption was run through a doubt-driven-development pass: a fresh-context single-model reviewer and a Codex cross-model reviewer, both given the diff and the adoption contract with no access to this document's reasoning. Findings that survived reconciliation and were fixed in a follow-up commit:

- Real AWS identifiers (IAM role ARN/account ID, CloudFront distribution ID, OIDC session name) had been pulled via `gh variable list` and committed verbatim into these docs — redacted to variable names only, per explicit user decision, since this is a public repo.
- The `.DS_Store` inventory above undercounted (said 7, actually 10 — missing `old/docs/`, `static/`, `static/img/`).
- The repo-local `mind-palace/` mirror had gone stale one commit after creation.
- `docs/project-walkthrough.md` falsely claimed certification PDFs were "served directly from the site"; live verification found all 7 return 404 in production (RISK-0005, pre-existing, not caused by adoption).
- Hugo's "extended edition" requirement (used in CI) wasn't documented for local setup or checked by `scripts/check-prereqs.sh`.
- `maturity_level: 3` / `validated` had been asserted without a recorded live-verification step; a real `curl` check was then performed and recorded as evidence.
