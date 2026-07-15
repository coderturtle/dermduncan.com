# Project Walkthrough

dermduncan.com is Derm Duncan's personal CV/portfolio site: a Hugo static site built on the `hugo-resume` theme, presenting his experience, education, skills, certifications, awards, and a couple of project write-ups. It is a Hekton factory-output project: the factory helps maintain it going forward, but the site itself — live at `https://dermduncan.com` — is the deliverable.

The adoption did not change site behavior. It added Hekton control-plane files so future agents understand the project's classification, repo location, public/private boundary, setup flow, risks, and next actions before editing.

## What's here

- `content/` — Markdown source for the CV sections (awards, projects, blog), driven by `data/experience.json`, `data/education.json`, and `data/skills.json`.
- `themes/hugo-resume/` — the vendored theme (not a Git submodule, despite the CI workflow requesting one).
- `docs/` — certification PDFs served directly from the site.
- `old/` — a preserved copy of an earlier, pre-Hugo version of the site.
- `public/` — Hugo's build output, checked into Git (see `docs/risks.md` RISK-0001 — there is no `.gitignore`).

## Deployment

The site already has a real production deployment, unlike a from-scratch Hekton scaffold: `.github/workflows/main.yml` builds the site with the Hugo CLI on every push to `main`, uploads the `public/` artifact, assumes an AWS IAM role via GitHub's OIDC provider, syncs the artifact to an S3 bucket, and invalidates the CloudFront distribution in front of it. The bucket, distribution, region, deploy role, base URL, Hugo version, and OIDC session name are all supplied as GitHub Actions repository variables rather than tracked in the repo — `docs/reproducibility.md` documents what those are so a blank-machine rebuild knows what needs to exist outside of Git.

## What to understand deeply vs. skim

The main thing worth understanding deeply before touching this repo is that `public/` is committed build output, not source — never hand-edit anything under `public/`; edit `content/`, `data/`, or `config.toml` and let the Hugo build (locally or in CI) regenerate it. The governance ledgers under `.hekton/` and the repo-local `mind-palace/` mirror are traceability scaffolding that agents can keep current after material changes, but don't need deep human attention on every edit.
