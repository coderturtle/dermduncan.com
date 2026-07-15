# AGENTS.md - dermduncan.com

## Project Classification

- **Type:** factory-output
- **Local repo:** /Users/hekton/Development/hekton/factory-output/dermduncan.com
- **Vault:** /Users/hekton/vaults/hekton-mind-palace/20-projects/factory-output/dermduncan.com
- **Vault mutation allowed:** false
- **Owner:** hekton

## Shared Agent Rules

Follow all rules in `~/hekton/AGENTS.md`, including the Hekton Documentation Contract, Ongoing Hekton Project Operating Rules, and session-scoped commit discipline.

This project is classified as **factory-output**. All agents must:

1. Read `.hekton/project.yaml` before making structural changes.
2. Read `README.md`, `docs/project-walkthrough.md`, `docs/session-log.md`, `docs/decisions.md`, and `docs/next-actions.md` before material changes.
3. Stay within `/Users/hekton/Development/hekton/factory-output/dermduncan.com` for project changes.
4. Keep adoption and future product changes in separate commits.
5. Update `docs/decisions.md` for significant design or deployment decisions.
6. Append to `docs/session-log.md` at the end of every material session.
7. Update `docs/next-actions.md` when the queue changes.
8. Not mutate the live Obsidian vault unless the user explicitly authorizes that session.

## Adoption Notes

- This is Derm Duncan's personal CV/portfolio site, live at `https://dermduncan.com`.
- The GitHub repo `coderturtle/dermduncan.com` matched the requested project name directly — no name resolution was needed.
- The Git remote uses `git@github.com-coderturtle:coderturtle/dermduncan.com.git` so pushes use the coderturtle SSH key.
- The site already has a working AWS S3 + CloudFront production deployment via GitHub Actions/OIDC. Adoption did not touch that deployment.
- The repo has no `.gitignore`; the built `public/` directory and stray `.DS_Store` files are tracked. This was left alone during adoption (see `docs/risks.md` RISK-0001) — do not fix it in the same commit as other work without calling it out separately.

## Traceability Artefacts

All of the following must be kept current:

| Artefact | Location |
|---|---|
| `.hekton/project.yaml` | repo root |
| `docs/session-log.md` | repo docs/ |
| `docs/decisions.md` | repo docs/ |
| `docs/risks.md` | repo docs/ |
| `docs/operating-model.md` | repo docs/ |
| `docs/project-walkthrough.md` | repo docs/ |
| `docs/next-actions.md` | repo docs/ |
| `index.md` | repo-local `mind-palace/` mirror |
| `decisions.md` | repo-local `mind-palace/` mirror |
| `next-actions.md` | repo-local `mind-palace/` mirror |
| `session-log.md` | repo-local `mind-palace/` mirror |
