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

## 2026-07-15 - Doubt-driven review before push

### Changed Files

- `.hekton/project.yaml`, `.hekton/risk-register.yaml`, `.hekton/agent-run-log.yaml`: corrected maturity evidence, redacted AWS values, corrected `.DS_Store` count, added RISK-0005, recorded this review pass.
- `docs/reproducibility.md`, `docs/risks.md`, `docs/adoption-audit.md`, `docs/project-walkthrough.md`, `docs/decisions.md`, `docs/setup.md`, `docs/next-actions.md`: same fixes reflected across docs.
- `scripts/check-prereqs.sh`: added a soft "hugo extended edition" warning.
- `mind-palace/next-actions.md`, `mind-palace/session-log.md`: re-synced with the corrected `docs/` versions.

### What Changed

Before pushing/opening a PR, ran the `doubt-driven-development` process against the adoption diff: a fresh-context single-model reviewer (general-purpose subagent) and a Codex cross-model reviewer, both given only the diff (`9fe0342..HEAD`) and the adoption contract, instructed to find issues rather than validate. Both were told to verify claims against the live filesystem/git/production state rather than trust the new docs' own assertions.

### Why It Changed

User explicitly requested a doubt-driven-development pass before pushing and opening the PR.

### Decisions Made

See `docs/decisions.md` 2026-07-15 entries: redact-vs-keep AWS values (user chose redact), and running both reviewers before push. Full finding-by-finding reconciliation:

1. **Real AWS identifiers committed in docs** (role ARN/account ID, CloudFront distribution ID, OIDC session name) — valid, fixed: redacted to variable names only.
2. **`.DS_Store` count wrong** (said 7, actual 10) — valid, verified via `git ls-files`, fixed.
3. **`mind-palace/` mirror stale** after the first follow-up commit — valid, fixed.
4. **`gh variable list` used outside the documented read-only allowlist without recording the scope decision** — valid, folded into #1's fix; decision now recorded in `docs/decisions.md`.
5. **`project-walkthrough.md` falsely claimed certification PDFs are served from the site** — valid, verified live (all 7 `/docs/*.pdf` return 404, homepage returns 200), fixed text and added RISK-0005.
6. **Hugo "extended edition" requirement undocumented/unchecked** — valid, fixed docs wording and added a soft check-prereqs.sh warning.
7. **`maturity_level: 3`/"validated" asserted without a recorded verification step** — valid, fixed by performing and recording a real `curl` check.
8. **`~/hekton` registry files left uncommitted, diff not self-contained** (Codex) — classified as noise: this is expected cross-repo registry behavior, already transparently documented in `docs/next-actions.md`, not a defect in this repo's diff.
9. **Repo visibility unverified** (Codex's sandbox had no network) — classified as noise: independently verified both before and after via `gh repo view coderturtle/dermduncan.com` (`isPrivate: false`, `visibility: PUBLIC`).

### Assumptions Made

- The user's "redact values, keep names" decision applies uniformly to all 7 deploy variables, not just the ones judged individually sensitive.

### Risks

Added RISK-0005 (broken certification-PDF links, pre-existing production defect, not caused by adoption). See `.hekton/risk-register.yaml` and `docs/risks.md`.

### Next Actions

See `docs/next-actions.md` — added RISK-0005 fix and a possible future hardening of the Hugo-edition check.

### Validation Status

- Re-verified `gh repo view coderturtle/dermduncan.com --json isPrivate,visibility`: `{"isPrivate":false,"visibility":"PUBLIC"}`.
- Live-verified via `curl`: `https://dermduncan.com/` → 200; all 7 `https://dermduncan.com/docs/*.pdf` → 404.
- No further validation commands re-run this pass (reproducibility/governance/taxonomy results from the prior entry stand; nothing in this pass touched required-file presence).

### Mind-Palace Updated

Repo-local mirror re-synced to match corrected docs. Live vault still not touched.

## 2026-07-15 - Track infra onboarding to the Infrastructure Gremlin pattern

### Changed Files

- `docs/next-actions.md`, `docs/decisions.md`, `.hekton/project.yaml`, `mind-palace/next-actions.md`: recorded a tracked next action to onboard dermduncan.com's AWS infra to the same Infrastructure Gremlin / Terraform pattern (`agentic-infra-lab`) already used by `coderturtle.io` and `agentic-tekton`.

### What Changed

User asked (after the PR was opened) whether this site's infra was already managed by the shared Terraform setup, and confirmed they want it tracked toward that goal so all sites are managed the same way. Checked `agentic-infra-lab`'s `workflows/provision-infra-from-manifest.md` and every factory-output repo: only `coderturtle.io` and `agentic-tekton` have a real `infra/aws-static-site/deploy-manifest.yaml` wired to it. dermduncan.com has none — its S3/CloudFront/IAM were hand-created in 2024, before this pattern existed.

### Why It Changed

Explicit user request, scoped deliberately to "track it," not "do it now": importing live production AWS resources into Terraform state is production-sensitive and needs its own manifest, Infrastructure Gremlin preflight/plan, Well-Architected review, and human-owned `terraform apply` — out of scope for a docs-only follow-up commit, and any manifest would reopen the same real-identifier-disclosure question already resolved earlier this session.

### Decisions Made

See `docs/decisions.md` 2026-07-15 "Track (but do not start) onboarding to the Infrastructure Gremlin / Terraform pattern."

### Next Actions

See `docs/next-actions.md` — new infra-onboarding item.

### Validation Status

Docs-only change; no validation commands re-run.

### Mind-Palace Updated

`mind-palace/next-actions.md` updated to match.

## 2026-07-15 — Career-story rebuild (Fable loop)

### What Changed

Full site rebuild on branch `agent/fable/career-story-rebuild` (not merged, not deployed): new homepage, six journey chapters, nine capability threads with client-side filtering, four signature stories, leadership principles, Now section, conventional career view; data model in `data/career/`; root layouts + hand-written CSS/JS replacing the hugo-resume theme presentation; legacy demo-content cleanup and RISK-0005 PDF fix. Loop artefacts in `docs/rebuild/` (repo assessment, claims register, critique).

### Why It Changed

User brief: replace the online-CV experience with an interactive executive career narrative showing capability compounding across six scales.

### Decisions Made

See `docs/decisions.md` 2026-07-15 "Rebuild as an interactive career story".

### Next Actions

See `docs/next-actions.md` — new items for claim confirmation and old-build cleanup.

### Validation Status

`hugo` build passes on production-pinned 0.123.7 and local 0.164.0 (zero errors; only version-skew deprecation warnings on 0.164). Internal-link integrity check over the built output: no missing targets. Rendered-output greps confirm no internal notes (NEEDS-CONFIRMATION/claim refs) or theme demo text leak into HTML. Headless-Chrome screenshots verified desktop (1280px) and mobile (600px) rendering, nav toggle, spine, filters, career view. No test suite exists in this repo; no linter configured.

### Mind-Palace Updated

Repo-local mirror only (`mind-palace/session-log.md`); live vault untouched per project rules.

## 2026-07-15 — Confirmed titles and dates applied

Dermot confirmed HUB end (May 2024), the MD & Head of Cloud Engineering progression (from May 2022), Vanguard Head of Architecture (Oct 2024) and Head of Architecture & CTO (Feb 2026), and the six-figure POC wording. Applied across the content model, hero, JSON-LD and claims register; career-page date footnote now conditional and gone. Build re-verified on Hugo 0.123.7 (leak grep 0, link check clean, career page screenshot). Remaining merge gate: claims C13, C18–C21.

## 2026-07-16 — Interactive features, rebrand, doubt-driven-development pass, merge and deploy

### What Changed

Fixed a real CSS grid bug on the principles page (paragraph text wrapping one character per line — `.principle` was a 2-column grid with three items instead of two). Rebranded to a distinct verdigris accent and a restrained serif on the hero/chapter headlines, differentiating from coderturtle.io and The Agentic Tekton. Added a "Perfection is a road, not a destination" signature quote. Added three interactive features: a capability-compounding SVG map (list/map toggle on `/capabilities/`, hover/focus traces one thread's connections), a Cmd/Ctrl-K jump palette (fuzzy-filter across chapters/stories/capabilities/pages), and a footer line stating real build provenance. Ran a two-cycle doubt-driven-development pass (fresh-context Explore agent, then Codex cross-model) before pushing — full detail in `docs/decisions.md` 2026-07-15 and 2026-07-16 entries. Real findings fixed: a focus-trap leak via the skip-link, invalid `role="img"` ARIA on the SVG map, a mobile-nav DOM-order regression, a palette keyboard/Escape gap, hardcoded chapter/capability counts, and a genuine data-model drift between `chapters.yaml` and `capabilities.yaml` (8 chapter/capability pairs existed in one file but not the other — the map and the list view literally disagreed with each other). One claimed finding (`</script>` truncation risk in the palette's JSON island) was checked empirically and refuted: Hugo's `jsonify` already HTML-escapes by default.

PR #2 opened and merged to `main` (`c5e23fa`), which triggered the existing GitHub Actions deploy workflow (run 29532983404) automatically. Both build and deploy jobs succeeded.

### Why It Changed

User requested interactivity improvements to emphasise the career-compounding thesis, then requested a doubt-driven-development pass before pushing, then requested commit + PR, then requested merge.

### Decisions Made

See `docs/decisions.md` 2026-07-15 "Rebuild as an interactive career story" (updated), 2026-07-16 "Doubt-driven-development pass on the interactive-features commit".

### Next Actions

See `docs/next-actions.md` — HUB outcome metrics, SOC 2 wording, "60+ engineers" wording, and the Fidelity Labs/venture framing remain flagged `needs_confirmation` in `docs/rebuild/claims-register.md`, now live pending Dermot's confirmation (not blocking further iteration, since dates/titles were already confirmed and merged).

### Validation Status

Clean build on production-pinned Hugo 0.123.7 from a detached worktree at the merge commit (not just the working directory). Zero broken internal links. Zero console errors; all interactive features driven end-to-end via a puppeteer-core script against the real dev server. `chapters.yaml`/`capabilities.yaml` cross-reference reconciled and re-verified with a standalone script. Live production checks post-deploy: homepage, `/journey/`, `/capabilities/`, `/career/` all 200; new hero copy confirmed live; previously-404ing certification PDF confirmed 200 (RISK-0005 fixed in production).

### Mind-Palace Updated

Repo-local mirror only (`mind-palace/session-log.md`); live vault untouched per project rules.
