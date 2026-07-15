# Source & Claims Register

Source hierarchy: (1) LinkedIn — **no export available locally**; (2) existing dermduncan.com content (`data/*.json`, `content/`); (3) 2018 CV (`old/docs/dermscv.pdf`); (4) live sibling sites; (5) rebuild brief.

Confidence: **high** = two local sources agree; **medium** = single local source; **brief-only** = supplied by the rebuild brief with no local corroboration.

| # | Claim | Role/Project | Source | Confidence | Publish | Needs Dermot's confirmation | Anonymise |
|---|---|---|---|---|---|---|---|
| C01 | O2 internship: scripted migration of network-route records from spreadsheets to new system | O2 Ireland | experience.json | medium | yes | no | no |
| C02 | Fidelity Sept 2007 – Aug 2018, roles: Associate SE → SE (FIMT) → Snr SE / Principal Architect (XTRAC) → Director of Software Architecture (APS) | Fidelity | CV 2018 + experience.json | high | yes | no | no |
| C03 | 1-click dev-environment installer; decision-support system for PMs | Fidelity Ireland | experience.json + CV | high | yes | no | no |
| C04 | Financial reporting tool cut report creation from ~a week to minutes; RoR support app moved tasks to L1 | FIMT | experience.json + CV | high | yes | no | no |
| C05 | XTRAC Connect java integration engine on AWS (Beanstalk, S3, DynamoDB), building block for digitisation-of-services strategy | XTRAC | CV 2018 + experience.json | high | yes | no | no |
| C06 | Cavendish pensions smart wizard: 28-page PDF → digital journey, processing time from >1 week to <1 day | XTRAC | CV 2018 + experience.json | high | yes | no | no |
| C07 | Automated AWS environment creation (CloudFormation, ruby, Jenkins) — one person could operate the platform | XTRAC | CV 2018 + experience.json | high | yes | no | no |
| C08 | Fidsafe re-architecture: 10k → 10M+ user scale design; CD pipelines enabled daily vs monthly releases; >$400k first-year cost cut | XTRAC | CV 2018 + experience.json | high | yes | no | no |
| C09 | Serverless migration of Java/Spring REST API to NodeJS microservices (API Gateway, Lambda, SQS) | XTRAC | CV 2018 + experience.json | high | yes | no | no |
| C10 | APS: defined org cloud strategy; IaC pattern for shared reusable infra; live coding workshops (serverless, Alexa, ML); labs team of 3; 1-in-5 POCs funded | Fidelity APS | CV 2018 + experience.json | high | yes | no | no |
| C11 | POC/MVP savings: CV says "400k+ per project", experience.json says "100k+ per project, 2–3 projects per quarter" — **conflict** | Fidelity APS | CV vs experience.json | conflicted | qualified only | yes | no |
| C12 | Director of Architecture, Fidelity PI, Feb 2019 – Oct 2020: 15-person team, cloud-native EDA platform backbone of digital experience ecosystem; learning dojo; Event Storming/DDD; cloud COE | Fidelity PI | experience.json | medium | yes | no | no |
| C13 | Fidelity Labs / venture-side innovation architecture, technical diligence for venture/innovation teams, distributed-ledger experimentation | Fidelity | brief (citing prior LinkedIn) | brief-only | qualified | yes | no |
| C14 | HUB: first technical hire outside CTO, 8th employee; defined hiring, resource plans, tech radar, architecture principles; Azure foundations (ARM/Bicep/Terraform, Azure DevOps); security posture + SOC monitoring | HUB | experience.json | medium-high | yes | no | no |
| C15 | HUB start January 2021 | HUB | experience.json | medium | yes | no | no |
| C16 | HUB end date | HUB | none (experience.json says "Present", stale) | none | year withheld | **yes** | no |
| C17 | HUB progression to Head of Cloud Engineering / Managing Director remit | HUB | brief (citing prior LinkedIn) | brief-only | yes, qualified | yes | no |
| C18 | Company grew to 70+ people (experience.json) / 60+ engineers across Ireland, UK, India (brief) | HUB | experience.json + brief | medium | yes — use "60+ engineers; ~70-person company" carefully | yes | no |
| C19 | SOC 2 Type I readiness led/materially supported | HUB | brief | brief-only | yes, qualified ("led SOC 2 Type I readiness") | yes | no |
| C20 | ~40% cloud running-cost reduction; 2× live environments; ~80% provisioning-time reduction | HUB | brief | brief-only | yes with "approximately" | **yes** | no |
| C21 | Engineering Enablement Platform + COE model; event-driven automation; IaC; Azure OpenAI + RAG exploration | HUB | brief | brief-only | yes | yes | no |
| C22 | Vanguard: leads Architecture and CTO/platform-engineering function for European business (UK PI, European FAS); AI enablement + responsible AI governance | Vanguard | brief | brief-only | yes as remit description, **never as formal title** | **yes — formal title + start date required** | no |
| C23 | Vanguard start date | Vanguard | none | none | withheld | **yes** | no |
| C24 | 6 AWS certifications (CP, Dev-A, SA-A, SysOps-A, DevOps-P, SA-P) earned by 2018 | Credentials | CV 2018 + cert PDFs in docs/ | high | yes, as historical/archive | no (currency unknown → archive framing) | no |
| C25 | Awards: Startup Weekend Boston 3rd (blockchain), Android Wear Hackathon 1st, Emotion Lab '16 Best UX | Awards | CV + content/awards | high | yes | no | no |
| C26 | Hekton (agentic software factory), Gremlins (agent-first SDLC), Agentic Tekton (thought leadership) are Dermot's current research programme | Now | live sites + this repo's provenance + brief | high (existence), medium (framing) | yes — no confidential internals | no | Hekton internals not described beyond public-safe framing |
| C27 | MSc Software Development, H.Dip Web Tech, H.Dip Systems Analysis, B.Eng Electronic & Computer Engineering — NUI Galway, 2002–2010 | Education | education.json + CV | high | yes | no | no |
| C28 | Client-facing conceptual architecture for HUB product MVPs with clients & SMEs | HUB | experience.json | medium | yes (no client names) | no | client names never present |

## Publication rules applied

- No client names, no internal Vanguard/HUB/Fidelity system names beyond what already appears in Dermot's own public CV material.
- Conflicted metric C11 is published in qualified form ("saving the firm six figures per funded project") until confirmed.
- Unverified dates (C16, C23) render at year level or as "Current"; never invented.
- No formal Vanguard title is asserted anywhere on the site (C22).
