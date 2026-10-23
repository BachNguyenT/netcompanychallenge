# PRD Quality Rubric — Order Intake Assistant
Run on 2026-10-23 against `12-prd.md` and `build-pack/`.

## Complete product
- [x] Every capability in Step 07's required list (1-25) is an in-scope F-ID (F-01..F-28); R2/R3 items confirmed by the user (D-26); nothing was moved to the Parking Lot from the required list
- [x] Step 08's completeness checklist is fully answered (F-ID or N/A + reason)
- [x] Every release is specified at full depth (65 stories, 237 ACs across R1-R3); R1 is deployable on its own
- [x] No demo-only artefacts, no `[MVP]` labels, nothing "to be designed later" (searched: 0 hits for TBD / "to be designed" / unpropagated markers)

## Engineer-readiness
- [x] A team could build, deploy and operate R1 from this PRD + `build-pack/` without a clarifying question — except items deliberately registered as week-1 spikes or accepted risks: ERP write path (D-23, SP-01), model accuracy (D-25, SP-02), mail access policy (SP-03), provider extension availability (SP-04), legal sign-offs (D-33, D-34)
- [x] Every story has ≥ 2 Given/When/Then ACs including ≥ 1 edge/error AC; every AC has a verification layer (checked by script)
- [x] Every SCR has all applicable states with copy (R2/R3 screens have empty/loading/error/success copy)
- [x] `openapi.yaml` lints (Redocly: valid, 0 warnings) and covers every story that needs an endpoint (internal stories listed in 11 §7); `schema.sql` applies (PostgreSQL 16 + pg_trgm + pgvector 0.8.0); every operation has an authorisation row for every role (generated from one list)
- [x] Every external dependency has a fallback; every NFR target has a measurement method
- [x] Environments, CI/CD, migrations, seed data, observability and rollback are specified

## Traceability
- [x] Every F → O/basis → P chain is complete; orphan check clean (`12-closure-log.md`)
- [x] Every UI story → SCR; every endpoint → US; every stage metric → event; every PII-flagged field → register row

## Evidence & zero-assumption
- [x] Every specific fact cites S-###, R-## or D-##; unverified sources are marked (S-040..S-051, S-041) and carried as labelled context or assumptions (RK-10)
- [x] Closure certification shows 0 open items, user-confirmed
- [x] No file other than its owner redefines North Star, scope, P/O-IDs, the domain model or the contract (PRD sections are generated from the owning files)

## Scope clarity
- [x] Release explicit for every feature; Parking Lot complete with revisit conditions
- [x] §0 "Not in scope" populated

## Proportionate
- [x] No section exists only to fill the template; business content is snapshot-level; the business-case steps (13-16) have not been run and the PRD says so

**Result:** Pass. Known limits, stated openly: problem size at Company A unmeasured (RK-05); AI accuracy unproven (RK-06); Sections 4-5 reproduce the owning files verbatim, so they are long.
