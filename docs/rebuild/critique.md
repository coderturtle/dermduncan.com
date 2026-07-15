# Loop E — Multi-Perspective Critique

Date: 2026-07-15. Reviewed against the built site (Hugo 0.123.7 output, desktop 1280px and 600px mobile screenshots, rendered HTML inspection).

## Executive recruiter — 4/5

Under 90 seconds a visitor gets: name, current remit (hero kicker), positioning line, six-scale trajectory (spine), and a one-click conventional career view with dates and achievements. Differentiator (agentic-enterprise research alongside executive role) is explicit.
Deductions: the two most recent roles carry a date-confirmation footnote, and the Vanguard entry shows a remit description rather than a formal title. Both are honest-by-design (no LinkedIn export available) but a recruiter may notice. Resolves when Dermot confirms titles/dates.

## CIO / CTO — 4/5

Enterprise range is visible: regulated-environment delivery (Fidelity, HUB SOC 2, Vanguard), organisational design, budget/roadmap ownership, exec and client partnership, responsible AI governance. The Vanguard chapter frames the unit of design as the operating environment, which is the right altitude. The site avoids overstating the CTO title while still showing CTO-function scope.
Deductions: chapter 5 outcomes are necessarily thin (role is current, no publishable metrics); mitigated by honest framing ("fuller results belong to a future update").

## Engineering / architecture peer — 4/5

Real technical substance survives the executive framing: XTRAC Connect stack, Fidsafe twelve-factor re-architecture, serverless migration specifics, ARM/Bicep/Terraform pipelines, EDA platform, dojo katas, and a concrete description of Hekton's governance-as-code mechanics. Continued hands-on work is demonstrated by the sixth chapter rather than claimed.
Deductions: capability threads assert compounding at a level of tidiness a sceptical peer might probe; evidence links are mostly internal (role details) rather than external artefacts, apart from the three live sites and GitHub handles.

## Narrative editor — 4/5

Every chapter follows the same grammar and ends with a causal "What this unlocked" transition; the spine and capability threads make compounding legible in two independent ways; the homepage states the thesis in one sentence. Résumé chronology is quarantined on /career/ by design.
Deductions: chapter 3's intervention paragraph is long (nine sentences); a few summaries repeat the "X became Y" construction often enough to notice.

## UX / accessibility reviewer — 3.5/5 (pre-fix)

Works: skip link, semantic landmarks, keyboard-reachable everything (native details/summary, real buttons with aria-pressed, aria-live filter hint), mobile menu with aria-expanded and Escape handling, no-JS fallbacks (menu stays visible, all threads render), prefers-reduced-motion kills transitions/smooth-scroll, vertical spine (no horizontal timeline), verified no horizontal overflow at 600px.
Failures found: `--ink-faint` (#8b96a5 on #fafaf7 ≈ 2.9:1; dark-mode #6d7885 on #12161c ≈ 3.5:1) is used for small meta text (eras, role dates, card kickers) — below WCAG AA 4.5:1. The light-mode `--unlock` label colour is borderline (≈4.5:1). **Fix required (refinement pass 1).**
Note: 390px headless-Chrome screenshot clipping was diagnosed as macOS Chrome's minimum-window clamp, not layout overflow; 600px render and CSS audit (no fixed widths below the breakpoint) confirm.

## Evidence and confidentiality reviewer — 4/5

Claims register covers all load-bearing claims with source, confidence and confirmation flags. No formal Vanguard title asserted anywhere (including JSON-LD). No client names, no internal system detail beyond Dermot's own public CV material, no Hekton internals beyond public-safe framing, no invented dates (year-level display + footnote instead). Personal phone number and home address removed from site config. Claim-register references were leaking into rendered outcome bullets — found and fixed before commit.
Deductions: HUB outcome metrics (40%/2x/80%) and SOC 2 wording rest on the brief alone; they are flagged `needs_confirmation` and the branch must not merge until Dermot confirms them. The C11 metric conflict ($400k vs $100k per project) is handled by qualitative wording ("six-figure savings per funded project").

## Refinement pass 1 (applied)

1. Contrast: darken light-mode `--ink-faint` to #5c6877, brighten dark-mode to #97a2b0; darken light-mode `--unlock` to #7a4e18.
2. Narrative: tighten chapter 3 intervention; vary repeated "X became Y" constructions in two summaries.
3. Evidence: reword SOC 2 outcome bullet so it reads as a led programme rather than a bare certification claim.

## Refinement pass 2 (considered, deliberately not taken)

Further visual polish (custom illustrations per chapter, animated spine drawing) rejected as decoration without narrative meaning; per the brief, stopping at coherent production quality.

## Post-fix scores

Recruiter 4 · CIO/CTO 4 · Peer 4 · Narrative 4 · UX/accessibility 4.5 · Evidence 4.5
