# Next Actions

- [ ] Add a `.gitignore` (`public/`, `.DS_Store`, Hugo's `resources/` cache) and untrack already-committed build output/`.DS_Store` files in a dedicated hygiene commit, separate from adoption.
- [ ] Document the GitHub Actions repository variables the deploy workflow depends on (`AWS_REGION`, `BUCKET_NAME`, `CF_DISTRIBUTION_ID`, `HUGO_VERSION`, `ROLE_TO_ASSUME`, `SITE_BASE_URL`, `CODE_SESSION_NAME`) — captured in `docs/reproducibility.md` during adoption; keep current if any change.
- [ ] Install the Hugo CLI locally (matching `HUGO_VERSION=0.123.7`) so `hugo --minify` can be run as a real local build check instead of being skipped.
- [ ] Record the `hugo-resume` theme's upstream source/version if it's ever updated, since it's vendored directly with no submodule or lockfile pinning it.
- [ ] Review and optionally sync repo-local `mind-palace/` files into the live vault after backup.
- [ ] Human-review whether `old/` (the pre-Hugo site snapshot) is still worth keeping in the live repo or should move to an archive location.
