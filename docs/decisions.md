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
