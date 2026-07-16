# Session Log

Mirror of `docs/session-log.md` — see the repo copy for the authoritative, full-detail log.

## 2026-07-15 - Adopt dermduncan.com into Hekton

Adopted the pre-existing `coderturtle/dermduncan.com` repo as a Hekton `factory-output` project. Added Hekton control-plane files, docs, setup/verify scripts, and this repo-local mind-palace mirror. No product behavior changed.

Before pushing, ran a doubt-driven-development review (single-model + Codex cross-model) against the adoption diff. Real findings fixed in a follow-up commit: redacted committed AWS identifiers (role ARN/account ID, CloudFront distribution ID) down to variable names only since this is a public repo; corrected an undercounted `.DS_Store` inventory (7 claimed, 10 actual); caught and fixed this mirror going stale; discovered and recorded a real pre-existing production defect — all 7 certification PDF links 404 live (RISK-0005); documented Hugo's "extended edition" requirement; added real live-verification evidence (curl 200) backing the `maturity_level: 3` claim.

Full detail in the repo's `docs/session-log.md` and `docs/adoption-audit.md`'s doubt-driven-review addendum.

## 2026-07-15 - Career-story rebuild (Fable loop)

Rebuilt the site as an interactive career narrative on branch `agent/fable/career-story-rebuild` (unmerged, so nothing deployed): six journey chapters, capability threads, four signature stories, principles, Now section and a conventional career view, driven by `data/career/*.yaml` with root-level layouts replacing the hugo-resume presentation. Claims register + six-perspective critique in `docs/rebuild/`. Build verified on production Hugo 0.123.7 and local 0.164.0; link integrity, leak greps and desktop/mobile screenshots checked. Merge is gated on Dermot confirming flagged claims (HUB/Vanguard titles, dates and metrics).

## 2026-07-15 - Confirmed titles and dates applied

HUB and Vanguard titles/dates confirmed by Dermot and applied; remaining merge gate is HUB outcome metrics, SOC 2, engineer count and Fidelity Labs framing (C13, C18–C21). Detail in `docs/session-log.md`.

## 2026-07-16 - Interactive features, doubt-driven-development, merge and deploy

Added a capability-compounding map, Cmd/Ctrl-K jump palette and build-provenance footer line; rebranded to a distinct verdigris accent + serif signature. Two-cycle doubt-driven-development pass caught and fixed real issues, most notably a genuine data drift between `chapters.yaml` and `capabilities.yaml`. PR #2 merged to `main` (`c5e23fa`) and deployed live via the existing GitHub Actions workflow; verified 200s and new content on dermduncan.com post-deploy. HUB outcome metrics, SOC 2 wording, engineer count and Fidelity Labs framing remain flagged `needs_confirmation`, now live pending Dermot's confirmation. Detail in `docs/session-log.md`.
