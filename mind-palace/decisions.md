# Decisions

Mirror of `docs/decisions.md` — see the repo copy for the authoritative log.

## 2026-07-15 - Adopt as Hekton factory output

Classified `factory-output`: a public personal CV/portfolio deliverable, not shared machinery or a lab.

## 2026-07-15 - Preserve existing Git history

Cloned with full history rather than re-scaffolded. Adoption is metadata/docs only.

## 2026-07-15 - Keep live vault mutation disabled

Repo-local `mind-palace/` is the draft control plane until the user approves a live vault sync.

## 2026-07-15 - Do not fix repository hygiene during adoption

No `.gitignore`, tracked `public/` build output — real issue, deferred to a dedicated follow-up commit.

## 2026-07-15 - Keep the existing AWS deployment pipeline as-is

Documented, not modified.

## 2026-07-15 - Rebuild as an interactive career story

Hugo stack and deployment preserved; theme presentation replaced by root layouts + data model. No invented facts: unverified claims flagged in the claims register, dates at year precision, no formal Vanguard title asserted. Personal phone/address removed from config. Full detail in repo `docs/decisions.md`.
