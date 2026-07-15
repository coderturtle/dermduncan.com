# Brief

dermduncan.com is Derm Duncan's personal CV/portfolio website: experience, education, skills, certifications, awards, and a couple of project write-ups, presented as a Hugo static site and served from `https://dermduncan.com` via AWS S3 + CloudFront.

It was adopted into the Hekton factory on 2026-07-15 from a pre-existing, already-live GitHub repo (`coderturtle/dermduncan.com`). The site's production deployment pipeline (GitHub Actions -> AWS OIDC role -> S3 -> CloudFront) predates Hekton and was left untouched by adoption.

Goal going forward: keep the site accurate as Derm's CV changes, and gradually close the repo-hygiene and documentation gaps recorded at adoption time (`docs/risks.md`, `docs/next-actions.md`) without disrupting the working deploy.
