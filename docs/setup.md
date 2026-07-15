# Setup

This project follows the Hekton reproducible setup standard:

```text
documented -> scripted -> idempotent-ish -> logged -> reproducible on a blank machine
```

## Intended Flow

```bash
./scripts/check-prereqs.sh
./scripts/bootstrap-project.sh --dry-run
./scripts/bootstrap-project.sh
./scripts/verify-project.sh
```

## Project-Specific Steps

1. Use the `coderturtle` GitHub account.
2. Clone the repo using the coderturtle SSH host alias:

```bash
git clone git@github.com-coderturtle:coderturtle/dermduncan.com.git ~/Development/hekton/factory-output/dermduncan.com
```

3. Install the Hugo CLI (matching `HUGO_VERSION=0.123.7` used in CI), e.g.:

```bash
brew install hugo
```

4. Run the site locally:

```bash
hugo server -D
```

5. Build before publishing or opening a PR:

```bash
hugo --minify
```

## Deployment

Production deploys happen automatically via `.github/workflows/main.yml` on push to `main`. It requires the GitHub Actions repository variables listed in `docs/reproducibility.md` to already be configured — this repo does not track them.
