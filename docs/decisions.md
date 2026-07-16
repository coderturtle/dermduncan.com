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
- **No invented facts.** No LinkedIn export exists locally, so brief-supplied claims (HUB progression/outcomes, Vanguard remit) are flagged `needs_confirmation` in `docs/rebuild/claims-register.md`; unverifiable dates render at year level with a visible footnote; no formal Vanguard title is asserted anywhere (remit description only). **This branch must not merge to main (= production deploy) until Dermot confirms the flagged claims.**
- **Privacy tightened.** Personal phone number and home address removed from `config.toml` (they rendered on the old CV page); placeholder Google Analytics ID dropped.
- **Legacy URLs.** /projects/*, /awards/* preserved and restyled; /search/ aliased to /career/; theme demo blog post (/blog/force-ssl/) and tag pages dropped as theme demo/derived content with negligible inbound-link value. Award pages carried hugo-resume example body text (Liberty Mutual/"Eddie") — replaced with real summaries. Certification PDFs now published via `static/docs/` (fixes RISK-0005).
- **Loop E critique** with six perspectives and scores recorded in `docs/rebuild/critique.md`; one refinement pass applied (WCAG contrast fix for meta text, chapter 3 tightening, SOC 2 wording). A second visual-polish pass was deliberately declined.

## 2026-07-15 - Confirmed titles and dates applied (rebuild branch)

Dermot confirmed directly: HUB ended May 2024, with Managing Director & Head of Cloud Engineering held from May 2022; Vanguard began October 2024 as Head of Architecture, promoted to Head of Architecture & CTO in February 2026; the conflicted POC-savings metric stays as qualitative "six-figure savings". Applied across data/career/*, hero kicker, JSON-LD and the claims register. The career-page date footnote is now conditional and no longer renders (all displayed dates are confirmed). Remaining merge gate: HUB outcome metrics, SOC 2 wording, engineer-count wording and the Fidelity Labs framing (claims C13, C18–C21).

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
