# Next Actions

Mirror of `docs/next-actions.md` — see the repo copy for the authoritative, up-to-date list.

- [ ] Add a `.gitignore` and untrack `public/`/10 tracked `.DS_Store` files in a dedicated hygiene commit.
- [ ] Fix broken certification-PDF links (RISK-0005) — all 7 `/docs/*.pdf` links 404 in production; `docs/` needs to move under `static/`.
- [ ] Install the Hugo CLI (extended edition, `0.123.7`) locally so local builds can be verified for real.
- [ ] Record `hugo-resume` theme provenance/version if it's ever updated.
- [ ] Review and optionally sync this mind-palace mirror into the live vault after backup.
- [ ] Human-review whether `old/` should stay in the live repo or move to an archive location.
- [ ] Add `.env.example` directly (git-contract guardrail blocks agent commits to `.env*`; user approved it).
- [ ] `governance-check` and `validate-taxonomy` gaps are recorded in the repo copy — pre-existing/expected, not blockers.
