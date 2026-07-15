# Operating Model

dermduncan.com is a public Hugo-based personal CV/portfolio site adopted into Hekton as a factory-output project.

## Common Commands

```bash
./scripts/check-prereqs.sh
./scripts/bootstrap-project.sh --dry-run
./scripts/bootstrap-project.sh
./scripts/verify-project.sh
hugo server -D
hugo --minify
```

## Change Policy

- Keep Hekton metadata, documentation, and site content/theme changes in separate commits.
- Treat `.github/workflows/main.yml` and anything AWS-facing as production-sensitive; changes require human review.
- Do not modify the vendored `themes/hugo-resume` theme without explicit approval.
- Do not write to the live vault unless the user authorizes that session.

## Validation

Cheapest local checks:

```bash
./scripts/check-prereqs.sh
./scripts/verify-project.sh
```

Full local build check (requires the Hugo CLI, which is not installed on this machine as of adoption):

```bash
hugo --minify
```

Production deploys happen via GitHub Actions on push to `main` — see `.github/workflows/main.yml` and `docs/reproducibility.md` for the required repository variables.
