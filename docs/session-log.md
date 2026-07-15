# Session Log

Append-only session history for dermduncan.com.

## 2026-07-15 - Adopt dermduncan.com into Hekton

### Changed Files

- `.hekton/project.yaml`, `.hekton/governance.yaml`, `.hekton/risk-register.yaml`, `.hekton/change-log.yaml`, `.hekton/review-log.yaml`, `.hekton/agent-run-log.yaml`: new Hekton control-plane metadata.
- `AGENTS.md`, `CLAUDE.md`, `CODEX.md`: new agent operating rules for this repo.
- `docs/session-log.md`, `docs/decisions.md`, `docs/operating-model.md`, `docs/project-walkthrough.md`, `docs/next-actions.md`, `docs/setup.md`, `docs/local-assumptions.md`, `docs/reproducibility.md`, `docs/risks.md`, `docs/adoption-audit.md`: new Hekton documentation set.
- `.env.example`: new, notes no local env vars are required.
- `scripts/check-prereqs.sh`, `scripts/bootstrap-project.sh`, `scripts/verify-project.sh`: new executable setup/verify scripts.
- `mind-palace/index.md`, `mind-palace/brief.md`, `mind-palace/decisions.md`, `mind-palace/next-actions.md`, `mind-palace/session-log.md`: new repo-local mind-palace mirror (draft, not synced to the live vault).

### What Changed

Adopted the pre-existing `coderturtle/dermduncan.com` repository (Derm Duncan's live personal CV site, built with Hugo) into the Hekton factory as a `factory-output` project. Cloned into temporary intake for inspection, audited license/secrets/remotes/dependencies, classified as `factory-output`/`public`/`coderturtle`, then re-cloned with full history into `~/Development/hekton/factory-output/dermduncan.com` on a new branch (`agent/claude/adopt-dermduncan-com`) rather than `main`.

### Why It Changed

User requested onboarding `dermduncan.com` as a Hekton factory-output project, following the Existing Project Adoption Agent workflow (`~/hekton/agents/existing-project-adoption-agent.md`).

### Decisions Made

See `docs/decisions.md` for the full list: classification, history preservation, vault mutation deferral, deferring repo-hygiene fixes, and keeping the existing AWS deploy pipeline untouched.

### Assumptions Made

- The repo's existing `origin` remote and AWS deployment pipeline should be left exactly as-is during adoption.
- `hugo` CLI is not installed on this machine; local build verification was skipped rather than blocking adoption on a tool install.

### Risks

See `.hekton/risk-register.yaml` and `docs/risks.md`: no `.gitignore` (RISK-0001), personal contact info in `config.toml` (RISK-0002, accepted), undocumented Hugo/theme version (RISK-0003), undocumented deploy-time GitHub Actions variables (RISK-0004).

### Next Actions

See `docs/next-actions.md`.

### Validation Status

- `./scripts/check-prereqs.sh --dry-run`: **failed** (exit 1) — `hugo` CLI is not installed on this machine. Real, expected signal; not masked.
- `./scripts/verify-project.sh --dry-run`: passed.
- `just validate-reproducibility ~/Development/hekton/factory-output/dermduncan.com`: **passed**.
- `just governance-check ~/Development/hekton/factory-output/dermduncan.com`: crashes during the cross-file vault-mutation-consistency check with exit 1 and no error message. Reproduced the identical crash against the already-adopted `coderturtle.io`, so this is a pre-existing bug in `~/hekton/scripts/governance-check.sh` (a `set -e`/pipefail issue when a `grep | grep | head -1` chain matches nothing), not something introduced by this adoption. All checks that ran before the crash point passed.
- `just validate-taxonomy`: does not report on this project. It discovers factory-output projects via `index.md` files under the live Obsidian vault (`20-projects/factory-output/<name>/`), and live vault sync was intentionally not performed (see Mind-Palace Updated below). The one real failure in that run's global output (`coderturtle.io — missing 'classification' in frontmatter`) is pre-existing and unrelated to this session.
- PM Brain Sync and Mirror Gremlin registry `register` commands both succeeded (registry-only writes; `dermduncan.com` project_id used in both).

### Mind-Palace Updated

Proposed (repo-local `mind-palace/` mirror drafted; live vault not touched — requires explicit human sync approval).
