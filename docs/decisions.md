# Decisions

Append-only decision log for dermduncan.com.

## 2026-07-15 - Adopt as Hekton factory output

dermduncan.com is classified as a `factory-output` project because it is a public personal CV/portfolio website deliverable maintained by the factory. It is not shared Hekton machinery and does not have a lab-style promotion target.

## 2026-07-15 - Preserve existing Git history

The repo was cloned from GitHub and kept as a normal Git repository rather than being re-created from a new scaffold. Adoption adds Hekton metadata and docs only; product behavior, theme, content, and the existing AWS deployment remain unchanged.

## 2026-07-15 - Keep live vault mutation disabled

The project proposes `20-projects/factory-output/dermduncan.com` as its mind-palace path, but this adoption session does not write to the live Obsidian vault. Repo-local `mind-palace/` files are the draft control plane until the user approves a sync.

## 2026-07-15 - Do not fix repository hygiene during adoption

The repo has no `.gitignore`, and the built `public/` directory plus several `.DS_Store` files are tracked. This is a real issue (see `docs/risks.md` RISK-0001) but adding a `.gitignore` and untracking those paths is a hygiene change, not Hektonization, so it was left for a dedicated follow-up commit rather than bundled into the adoption commit.

## 2026-07-15 - Keep the existing AWS deployment pipeline as-is

The site already has a working production deployment (S3 + CloudFront, OIDC-based GitHub Actions workflow). Adoption documents this pipeline's required repository variables in `docs/reproducibility.md` but does not modify the workflow, infrastructure, or repository variables.

## 2026-07-15 - Read GitHub Actions repository variables, but do not publish their values

`gh variable list -R coderturtle/dermduncan.com` was run read-only to document what the deploy workflow depends on (an explicit adoption-audit item: "Setup: known commands, missing docs, manual steps"). This is outside the adoption agent's originally-documented read-only command list, which is git-only; a first pass committed the actual returned values (AWS account ID via the IAM role ARN, CloudFront distribution ID, OIDC session name, etc.) verbatim into `docs/reproducibility.md`, `.hekton/risk-register.yaml`, `docs/risks.md`, and `.hekton/project.yaml`.

A doubt-driven review before pushing flagged this as a real, if low-severity, disclosure: those variables currently require GitHub repo write access to view (an unauthenticated visitor to the public repo cannot see them via `gh variable list` or the Settings UI), so committing the values makes previously access-gated data fully public. The workflow's own `mask-aws-account-id: true` step is a signal the original owner didn't want the account ID appearing even in build logs. The user was asked and chose to redact: docs now name the required variables (`AWS_REGION`, `BUCKET_NAME`, `CF_DISTRIBUTION_ID`, `HUGO_VERSION`, `ROLE_TO_ASSUME`, `SITE_BASE_URL`, `CODE_SESSION_NAME`) without repeating their current values. A repo admin can re-fetch current values with the same `gh variable list` command.

## 2026-07-15 - Doubt-driven review before push, findings fixed in a follow-up commit

Before pushing/opening a PR, this adoption was run through a doubt-driven-development pass (fresh-context single-model review + Codex cross-model review, both given only the diff and the adoption contract). Real findings — the AWS-value disclosure above, an undercounted `.DS_Store` inventory, a stale `mind-palace/` mirror, a false claim that certification PDFs are served from the site (they 404 in production — pre-existing, not caused by adoption; see `docs/risks.md` RISK-0005), an undocumented Hugo "extended edition" requirement, and a `maturity_level: 3` claim asserted without a recorded live-verification step — were fixed in a follow-up commit rather than by amending the original adoption commit. See `docs/adoption-audit.md`'s "Addendum — Doubt-Driven Review" for the full list.

## 2026-07-15 - Track (but do not start) onboarding to the Infrastructure Gremlin / Terraform pattern

The user wants dermduncan.com's AWS infra managed the same way as the other Hekton-managed sites. Checked: only `coderturtle.io` and `agentic-tekton` currently have a real `infra/aws-static-site/deploy-manifest.yaml` + Terraform module wired to `agentic-infra-lab`'s reusable Infrastructure Gremlin workflow (`workflows/provision-infra-from-manifest.md`, `pattern: hekton/aws-static-site`). dermduncan.com has no `infra/` directory; its S3 bucket, CloudFront distribution, and IAM deploy role were hand-created in 2024, predating that pattern (which only exists since ~2026-07-02), and are driven solely by `.github/workflows/main.yml` — the same "manually-created, out-of-Terraform" shape as `hekton-field-journal`'s role.

Recorded as a tracked next action (`docs/next-actions.md`) rather than started now: importing already-live production AWS resources into Terraform state is itself a production-sensitive change. Per the reusable workflow's own contract, it needs a real manifest, a gremlin preflight/plan pass, a Well-Architected advisory review, and a human-owned `terraform apply` at the approval gate — none of which belongs inside a docs-only adoption PR, and the manifest itself would need the same real-identifier-disclosure judgment call already made above (see the 2026-07-15 AWS-values decision) before anything gets committed to this public repo.

## 2026-07-15 - Rebuild as an interactive career story (branch agent/fable/career-story-rebuild)

Replaced the hugo-resume CV presentation with a data-driven career narrative per the Fable rebuild brief. Key decisions:

- **Stack preserved, theme presentation replaced.** Hugo + S3/CloudFront + GitHub Actions untouched. All templates are now root-level `layouts/` (which override the vendored theme); `theme` removed from `config.toml`. Verified the build against the production-pinned Hugo 0.123.7 as well as local 0.164.0. The theme directory is left in place for now (removal is a hygiene follow-up).
- **Content model over hard-coded copy.** All narrative lives in `data/career/*.yaml` (chapters, roles, capabilities, stories, principles, now). Relationships (role→chapter, stage→chapter, story→chapter, capability links) are modelled as ids, giving the conceptual graph without a graph database.
- **No invented facts.** Claims are checked against owner-held evidence, which is kept privately; anything unconfirmed stayed off the site until the owner confirmed it.
- **Privacy tightened.** Personal phone number and home address removed from `config.toml` (they rendered on the old CV page); placeholder Google Analytics ID dropped.
- **Legacy URLs.** /projects/*, /awards/* preserved and restyled; /search/ aliased to /career/; theme demo blog post (/blog/force-ssl/) and tag pages dropped as theme demo/derived content with negligible inbound-link value. Award pages carried hugo-resume example body text (Liberty Mutual/"Eddie") — replaced with real summaries. Certification PDFs now published via `static/docs/` (fixes RISK-0005).
- **Critique pass.** A multi-perspective critique informed one refinement pass (contrast fix for meta text, chapter tightening, SOC 2 wording); a second visual-polish pass was deliberately declined.

## 2026-07-15 - Confirmed titles and dates applied (rebuild branch)

Owner-confirmed titles and dates applied across `data/career/*`, the hero kicker and JSON-LD; the career-page date footnote became conditional. The current Vanguard title is recorded under 2026-11-12.

## 2026-07-16 - Doubt-driven-development pass on the interactive-features commit

Ran the doubt-driven-development skill against the capability map / command-K palette / build-provenance work (commit 82fb5e6) before pushing. Two cycles:

**Cycle 1 (single-model, Explore agent, fresh context, ARTIFACT+CONTRACT only):** 7 findings, 6 real and fixed, 1 refuted with evidence.
- Fixed: focus could escape the palette's `inert` trap via the `.skip-link` (not covered by the inert target list); `role="img"` on the capability-map SVG hid its interactive `<a>` children from assistive tech (changed to `role="group"`); reordering nav markup regressed the mobile menu so the hamburger/search trigger landed below the opened menu instead of above it (restored original order); Escape only closed the palette while focus stayed in the search input, and result links were natively tabbable, so Tab-ing into a result stranded a keyboard user with no way to close via Escape (added `tabindex="-1"` on result links, `aria-activedescendant` composite pattern, and a container-level Escape backstop); hardcoded "6"/"8"/"9" counts in the map SVG height and ARIA labels would silently go wrong if a chapter or capability were ever added or removed (replaced with `len` of the actual data).
- Refuted: a claimed `</script>` truncation risk in the palette's JSON island. Verified empirically that Hugo's `jsonify` already HTML-escapes `<`, `>`, `&` (Go's `encoding/json` default behaviour), so the literal bytes never appear in output — confirmed by injecting a test value containing `</script><script>` and inspecting the built HTML.

**Cycle 2 (cross-model, Codex `gpt-5.5`, `codex exec --sandbox read-only`, same ARTIFACT+CONTRACT):** corroborated cycle 1's now-fixed findings (it was reviewing the pre-fix commit, since the cycle-1 fixes were still uncommitted working-tree changes at that point) and surfaced 3 new, verified findings:
- **Real data-model bug, not just a code smell**: `data/career/chapters.yaml`'s per-chapter `capabilities:` lists (used to draw the map's edges) and `data/career/capabilities.yaml`'s per-capability `stages[].chapter` references (used to render the list view) had drifted out of sync — 8 capability/chapter pairs existed in one file's data but not the other's, meaning the map and the list literally disagreed about which capabilities appeared in which chapters. Reproduced with a standalone Ruby cross-reference script; reconciled both files so every reference is bidirectional (added a missing 6th "agentic-enterprise" stage to the `architecture` capability thread rather than deleting it from the chapter, since Hekton's factory/governance design is genuinely architecture work).
- Clicking a capability node while the map view was open updated the URL hash and correctly filtered the (hidden) list panel, but never switched the view back to List, so the result of the click was invisible. Fixed: the hashchange handler now switches to List view when it applies a filter.
- The map's hover/focus handler built a CSS attribute selector by string-concatenating a data-driven id with no escaping; a future id containing a quote or bracket would throw at runtime. Fixed with `CSS.escape()` (with a regex fallback for older engines).

Both cycles' fixes are committed together with the original feature commit's follow-up. Stopped after 2 cycles: cycle 2's findings were fixed and no new issues surfaced on the final re-verification pass (clean build, zero broken links, no console errors, all fixes confirmed via a puppeteer-core-driven dev server rather than static reasoning alone).

## 2026-11-12 - Executive positioning refresh; editorial evidence kept private

Content refresh for executive readers: corrected the current Vanguard title to "Head of Architecture & Chief Technology Office, Europe" across content, metadata and structured data; added a homepage "Selected impact" section; rewrote the Vanguard chapter and story; tied Fidelity results to their specific roles and periods; and labelled the agentic research as experimental. Templates gained optional status tags for chapter outcomes and story results, Markdown rendering for story fields, and career-record anchors and chapter links.

Editorial working documents are now maintained privately rather than in this public repository. `scripts/check-public-boundary.sh` guards against their reintroduction. Published history was not rewritten.

## 2026-11-13 - Vanguard architecture-decision vignette; visual identity

- The Vanguard signature story gains an "architecture decision" vignette (a streaming-architecture direction for backend systems), rendered from an optional `decision` block in `data/career/stories.yaml`. It separates the decision and intended outcomes from demonstrated results. Chapter five and the homepage reference it briefly rather than repeating it.
- Homepage "Selected impact" is now one proof point per employer (order later revised; see below): Fidelity (transforming enterprise engineering), HUB (building and scaling), Vanguard (shaping enterprise technology direction).
- New visual identity: a four-part symbol from the owner-supplied mark artwork (four rounded modules around an open centre, one copper module), recoloured to the brand palette with a horizontal "Dermot Duncan" wordmark. Palette: petrol `#102e35`, teal `#237875` (now the site accent, AA on all light surfaces), sea glass `#88afa5`, copper `#bd7953` (graphic accent only; it does not meet text contrast on light backgrounds). SVG sources and PNG exports in `static/brand/`; favicons drawn on a 16-pixel grid for crisp 16px and 32px rendering; adaptive `favicon.svg` for dark browser chrome; 1200×630 social card. Generator scripts in `scripts/brand/` (stdlib Python; the wordmark is outlined from the site's Georgia Bold).

## 2026-11-13 — Copy hygiene and accuracy pass

- Focused cleanup after a multi-perspective wording review; no general rewrite. Kept in its own commit, separate from positioning and brand work.
- The Chief Technology Office / Chief Technology Officer distinction is stated once, on the career page (`title_note` on the role). Vanguard is described as October 2024 – present.
- HUB introduction standardised ("the eighth employee and first technical hire alongside the CTO"); outcome figures shown as ~40% / ~80% everywhere.
- Fidsafe's 10 million+ is described as design capacity.
- Streaming wording clarified: looser coupling through published event contracts, not the disappearance of dependencies. Direction, progress and outcomes remain separate.
- Chapter six is presented as personal research within the six-part narrative, distinct from professional roles.
- Older archive pages (awards, projects, certifications, education) given light factual and editorial corrections only.

## 2026-11-13 — Final pre-publication cleanup

- Selected impact ordered Vanguard, Fidelity, HUB (one proof point per employer). The homepage keeps two pointers to the personal research (the journey's sixth chapter and "Outside the day job"); the research story stays on /stories/.
- Vanguard remit described by responsibilities first, with organisational boundaries stated once in the signature story.
- The streaming-architecture narrative stays at the level of direction, intended benefits and status.
- `old/docs/dermscv.pdf` and `data/experience.json` (legacy, unused by the site) removed from tracking and ignored. They remain in earlier published history.

## 2026-11-13 — Build-only pull-request check

- `.github/workflows/pr-build.yml` builds every pull request to `main` with the production Hugo version and edition (`vars.HUGO_VERSION`, falling back to 0.123.7 extended), production environment and flags, then runs `scripts/check-links.py` and `scripts/check-public-boundary.sh`.
- It triggers only on `pull_request` (never `pull_request_target` or `workflow_dispatch`), has `contents: read` permission only, no `id-token`, no secrets and no publication steps. Deployment stays solely in `main.yml`.
