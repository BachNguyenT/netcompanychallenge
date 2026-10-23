# Assumption & Ambiguity Closure Log — Order Intake Assistant (Company A, netcompany)
**Step 12 · Run date:** 2026-10-23

## Sweep results
| # | Item | Found in | Kind | Triage | Resolution | Resolved by |
|---|---|---|---|---|---|---|
| 1 | D-26 R2/R3 composition | 08 | open D | decision | Confirmed as specified | user, D-26 |
| 2 | D-17 AI wording (core vs supporting) | R-20 vs R-28 | open D / contradiction | decision | AI core for extraction and matching; rules for price/stock/credit | user, D-17 |
| 3 | D-18 Netcompany components required? | 07, 11 | open D | decision | Vendor-neutral; optional candidates only | user, D-18 |
| 4 | D-21, D-22 pilot footprint and roles | 08, 09 | open D | decision | One regional order office; four roles | user, D-21, D-22 |
| 5 | D-19, D-30 LLM provider and hosting region | 11 | open D | decision | EU-region hosted model behind provider interface; EU hosting acceptable | user, D-19, D-30 |
| 6 | D-29 mail platform and IdP | 11 | open D / unsourced inference | decision | Microsoft 365 + Entra ID default design; alternatives via adapters | user, D-29 |
| 7 | D-32 frontend hosting (deviation from confirmed Vercel default) | 11 | open D / contradiction with stack default | decision | Container next to the backend | user, D-32 |
| 8 | D-23, D-03 unknown pilot ERP | 11 | open D | accepted-risk | Adapter + week-1 spike, go/no-go | user, D-23, D-03; RK-07 |
| 9 | D-20, D-27 language and notifications | 09 | open D | decision | Danish with English fallback; email and in-app | user, D-20, D-27 |
| 10 | D-28 operating parameters and NFR targets (my proposals) | 10, 11 | open D / unsourced numbers | decision | Accepted; configurable | user, D-28 |
| 11 | D-24, D-25 size and accuracy hypotheses | 06, 07 | open D | accepted-risk | Baseline and shadow mode validate; week-12 go/no-go | user, D-24, D-25; RK-05, RK-06 |
| 12 | D-33, D-34 legal inputs (lawful basis, retention, bookkeeping, AI disclosure) | 11 | open D | accepted-risk | DPO/legal sign-off is a go-live gate | user, D-33, D-34 |
| 13 | D-31 R2 vendors | 11 | open D | decision | Decide at R2 start | user, D-31 |
| 14 | D-05 date | context | open D | decision | No fixed date | user, D-05 |
| 15 | `[D-##]` markers still in files (06-11) | 06-11 | unpropagated marker | — | Replaced by the resolved content; 0 remain | closure |
| 16 | D-27 and D-28 raised in 09/10/11 but missing from the register | 09-11 | orphan | — | Added to `_decisions.md` | closure |
| 17 | Step 10 count summary contained unverified numbers | 10 | unsourced fact | researchable | Recounted by script: 65 stories, 237 ACs | closure |
| 18 | 11 stated API counts by release without a count | 11 | unsourced fact | researchable | Recounted from `x-release`: R1 79, R2 13, R3 6 | closure |
| 19 | Stories without an edge/error AC: US-06, US-25, US-44, US-45, US-59 | 10 | completeness gap | — | ACs added or labelled in Step 10 | closure |
| 20 | SCR-19 had no story; US-38 had no SCR | 09/10 | orphan | — | SCR-19 linked to US-37, US-38 | closure |
| 21 | F-IDs hidden inside ranges in the SCR inventory (F-03, F-05, F-06, F-25, F-31) | 09 | orphan (mechanical) | — | Listed explicitly | closure |
| 22 | Stories with no endpoint (US-08, US-27, US-53, US-57 had no x-stories link) | 11 | orphan | — | Linked to existing operations; US-26, US-32, US-42, US-45, US-63, US-64 documented as internal | closure |
| 23 | Define files for the earlier delivery-hub concept (06-08) | 03-define | contradiction with the user's decision | — | Archived to `03-define/_superseded-2026-10-21/` | closure |
| 24 | R-22 (replacement allowed) vs R-26 (excluded) | requirements | contradiction | owner wins | R-26 owns; R-22 marked superseded | closure |
| 25 | Step 06 matrix ranks O-02 first while the user's scoring ranks G1 first | 06 vs S-037 | contradiction (documented) | decision already made | Recorded in 06 §1 and §8; O-02 served through the promise check | user (S-037 §4) |
| 26 | `schema.sql` pgvector statements not run | 11 | unverified | researchable | Verified: pgvector 0.8.0 built in a local PostgreSQL 16 container and the full unmodified schema applied (54 tables, HNSW index, audit trigger); provider availability stays spike SP-04 (RK-09) | closure |
| 27 | S-040..S-051 and Eurostat sector figures unverified | sources | unsourced / unverified | accepted-risk | RK-10; used as labelled context/assumptions | closure |
| 28 | Demo-only artefacts in Steps 08-11 | 08-11 | demo artefact | — | None found ("[MVP]" appears only in a checklist sentence stating its absence) | closure |

## Cross-file consistency
| Concept | Owner file says | Other file said | Fixed in |
|---|---|---|---|
| Scope and releases | 08 (37 features: R1 28, R2 6, R3 3) | 10 counts 28/6/3 | consistent |
| North Star | 08 §2 (orders approved without edits) | 09/10/11 reference it | consistent |
| Roles | 09 §3 / D-22 | authorisation matrix columns OH/OL/AN/AD | consistent |
| Contract and schema enums | `schema.sql` CHECKs | `openapi.yaml` enums | compared for DraftStatus, LineState, MessageStatus, roles, languages: identical |
| Auth model | 11 ADR-03 (OIDC) | stack default JWT issuance | D-29 explicit answer |

## Traceability check
| Check | Orphans found | Fixed |
|---|---|---|
| F without O/basis | 0 (every F lists an O-ID or a basis R-/S-/regulation) | — |
| In-scope F without US | 0 (37 features, 65 stories) | — |
| Step 07 required capability without F-ID or approved PL item | 0 (capabilities 1-25 → F-01..F-28; R2/R3 items per D-26) | — |
| Completeness-checklist row blank | 0 | — |
| AC without verification layer / abbreviated story | 0 (237 ACs tagged) | 5 stories needed an edge/error AC: fixed |
| Operation without authorisation-matrix row | 0 (98 operations, 98 rows; generated from one list) | — |
| PII field without register row | 0 (14 flagged columns covered in 11 §10.2) | — |
| Demo-only artefact in Steps 08-11 | 0 | — |
| UI US without SCR | 0 | US-38 fixed |
| SCR without F | 0 | — |
| SCR without story | 0 | SCR-19 fixed |
| Endpoint without US | 0 | — |
| Stage metric without event | 0 | — |

## Certification
- Files swept: `_requirements.md`, `_glossary.md`, `_decisions.md`, `_sources.md`, `_context.md`, `01-intake/*`, `02-discover/*`, `03-define/06-08`, `04-specify/09-11`, `05-deliver/build-pack/openapi.yaml`, `schema.sql`.
- Decisions resolved at Gate 0 / Gate A / here: Gate 0 (D-none; R-01..R-22), the user's research (D-01, D-02, D-04, D-06, D-07, D-08, D-13, D-14), closure (D-03, D-05, D-17..D-34 except those already resolved).
- Items resolved by research instead of asking: S-038, S-039, S-046 verified; EU AI Act timeline, Graph permissions, LLM EU residency, hybrid search, hosting prices researched in Step 11.
- Accepted risks (D-IDs): D-03, D-23, D-24, D-25, D-33, D-34; risks RK-02..RK-10.
- Not verified here (stated, not hidden): managed-provider availability of pgvector and pg_trgm (RK-09, SP-04); S-040..S-051 (RK-10).
- **Remaining open items: 0** · **Completeness check: clean**
- Confirmed by user: 2026-10-23, answers to the 14 closure questions (all recommended options chosen: R2/R3 as specified; AI core for extraction/matching; vendor-neutral on Netcompany components; one regional order office and four roles; EU-region hosted model and EU hosting; Microsoft 365 + Entra ID; frontend container next to the backend; ERP-agnostic adapter with week-1 spike; Danish UI with English fallback and email/in-app notifications; NFR proposals accepted; D-24/D-25 as accepted hypotheses; DPO/legal sign-off as a go-live gate; R2 vendors at R2 start; no fixed date).
