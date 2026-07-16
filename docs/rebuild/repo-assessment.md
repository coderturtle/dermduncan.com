# Rebuild Loop A — Repository Assessment & Content Inventory

Date: 2026-07-15. Branch: `agent/fable/career-story-rebuild`.

## Stack

- **Framework:** Hugo (extended). Live workflow installs `hugo_extended_${HUGO_VERSION}` + Dart Sass. Local build verified with Hugo v0.164.0+extended.
- **Theme:** `hugo-resume` (vendored under `themes/`). Bootstrap-based single-page CV layout.
- **Deployment:** GitHub Actions on push to `main` → S3 + CloudFront (OIDC role). **Pushing to main deploys production** — all rebuild work stays on a feature branch until reviewed.
- **Hygiene debt (pre-existing, RISK-0001):** no `.gitignore`; built `public/` and `.DS_Store` files are tracked.
- **Pre-existing production defect (RISK-0005):** the 7 certification PDFs link to `/docs/*.pdf`, which Hugo never publishes (they live in repo `docs/`, not `static/`). All 404 in production today.

## Content inventory (current site)

| Path | Content | Disposition in rebuild |
|---|---|---|
| `content/_index.md` | One-line "Proven Software Platform Architect" summary | Replace with new homepage narrative |
| `data/experience.json` | 9 roles, O2 → HUB ("Present" — stale) | Superseded by new structured career model; facts reused |
| `data/education.json` | NUIG degrees ×4 | Reuse verbatim in career view |
| `data/skills.json` | 5 generic CV paragraphs | Retire (résumé prose the brief asks to remove) |
| `content/projects/creations/` | Alexa workshop, Blockpaw, Coderturtle, Gremlins | Keep URLs; reframe Gremlins/Coderturtle inside the narrative |
| `content/projects/contributions/` | 7 AWS cert pages (all "expired-era" 2018 certs) | Move to archive/credentials section of career view; keep URLs |
| `content/awards/` | 3 hackathon awards | Keep as evidence items in career view |
| `content/blog/force-ssl.md` | Theme example post (not Dermot's writing) | Remove from nav; keep URL alive |
| `old/` | Pre-Hugo site + 2018 CV PDF (`old/docs/dermscv.pdf`) | Source material only; not published |
| `docs/*.pdf` | AWS cert PDFs | Leave; certs are legacy credentials now |

## Career source documents found

1. `data/experience.json` — role summaries through HUB (written ~2021-2024; HUB marked "Present", now stale).
2. `old/docs/dermscv.pdf` — 2018 CV. Rich verified detail for Fidelity years (titles, dates, XTRAC Connect, Fidsafe, labs, workshops, certs, awards).
3. `content/projects/` + `content/awards/` — side projects and awards.
4. Live sibling sites: `theagentictekton.com` (200), `coderturtle.io` (200), `gremlins.io` (200) — valid link targets for the "Now" section.
5. The rebuild brief itself — supplies HUB progression/outcomes and Vanguard scope. **No LinkedIn export exists in the repo or project context**, so brief-supplied facts are registered in the claims register with `needs_confirmation` where not corroborated.

## Key assumptions (documented, not blocking)

- A1: Hugo + S3/CloudFront stack is preserved; the `hugo-resume` theme presentation is replaced by root-level layouts (decision logged in `docs/decisions.md`).
- A2: HUB role ended before the current Vanguard role began; exact end/start dates are unknown here → year-level display, flagged for confirmation.
- A3: No formal Vanguard job title is available in any local source → the site describes the remit ("leads Architecture and the CTO/platform-engineering function for Vanguard's European business") and never asserts a formal "CTO" title.
- A4: Hekton has no public URL → described in the narrative, not linked.
- A5: The six 2018 AWS certifications are treated as historical credentials (likely expired), presented in an archive block, per the brief.
