Step 08 · Searches used: 3/3 · Sources: S-002, S-003, S-012..S-014, S-025, S-033..S-036

# Step 08 — Product Strategy & Scoping (complete product)

> Scope below is the **complete** Promise & Delivery Hub (Step 07), phased into releases. R1 is shaped by the ~3-month pilot target (R-15) and a single pilot market (R-11); that shrinks R1, not the specification. Open items are marked `[D-##]`.

## 1. Vision, mission, hypothesis
**Vision.** Every promise Company A makes to a customer — in stock, on this date, in this window — is one it can keep, in every country.
**Mission.** Give customers, branches, dispatch and support one reliable view and one commitment for every order, configured for each market's way of working.
**Hypothesis.** We believe customers who order building materials for delivery (pros and DIYers `[D-02]`) experience broken promises and unresolved problems (O-01, O-04, O-02) because the promise is made from partial, drifting stock and delivery data across local systems. If we build a Promise & Delivery Hub that makes the promise from reconciled data and handles exceptions proactively, customers will receive what was promised without chasing, measured by the Kept-promise rate.

## 2. North Star (defined here once)
**Kept-promise rate (KPR).**
- **Definition:** delivered orders where, per order, (a) delivery occurred within the confirmed window or date, (b) all ordered lines arrived, (c) goods were undamaged, and (d) the customer raised no exception — divided by all delivered orders, excluding changes the customer requested after confirmation. Measured per market and branch, weekly.
- **Why it reflects delivered value:** it is the customer-visible success of the promise, spanning O-01, O-02 and O-03.
- **Benchmark:** OTIF (a subset of KPR) is typically 95-99% where well run; one construction-materials distributor case shows 94.1% on time and 95.7% in full (S-033, Low-Medium reliability). Company A's baseline is unknown.
- **Targets (3 and 12 months after launch):** not set. `[D-13]` Recommended default: baseline measured in the first 4 weeks of the pilot; targets agreed as percentage-point gains over that baseline, then confirmed.

## 3. Stage metrics and guardrails
| Stage | Metric | Definition | Measurement event (for Step 11) | Benchmark |
|---|---|---|---|---|
| AWR | Promise coverage | Share of eligible orders created with a Hub promise (the Hub is not an acquisition channel, so reach = coverage of order channels) | `promise_requested`, `order_created` | none; baseline |
| CON | Promise-to-order conversion | Promise views that become confirmed orders | `promise_shown`, `order_confirmed` | none; baseline |
| DEC | Window-confirmation rate and time-to-aha | Orders with a confirmed window (and site details for trade) within 24 h of ordering; median time to first confirmed window | `window_confirmed` | none; baseline |
| RET | Kept-promise rate (North Star), exception resolution time | KPR as §2; median hours from exception raised to resolved | `delivered`, `exception_raised`, `exception_resolved` | OTIF 95-99% (S-033) |
| ADV | Post-delivery NPS | NPS question after delivery or after case closure | `survey_answered` | retail 37-42; Nordic average ~49 (S-035, Low-Medium) |

Guardrails:
1. **"Where is my order" contacts per 100 deliveries** — should fall; context 35-60% of e-commerce contacts (S-025, Low).
2. **First-contact resolution of exceptions** — 72-78% retail average (S-034, Low).
3. **Promise calibration** — share of "high-confidence" promises that fail; must stay below a threshold to be set after baseline `[D-13]`.
4. **Staff-data guardrail:** metrics about staff are aggregate by team/store only; no per-employee ranking (S-012, S-014).

## 4. Business-model snapshot
- **Who pays:** Company A (board investment, R-12 context); no external customer price. Cost allocation to countries is a Company A decision `[D-16]`.
- **Value logic:** fewer cancelled/failed orders, fewer contacts, fewer claims, more repeat orders; sizing pending `[D-07]`.
- **Acquisition/adoption channel:** internal rollout by country management; customers reached through Company A's existing ordering channels.
- **Main cost drivers:** integration per country, notification (SMS) volumes, hosting, support and change management.
- **Key partners:** carriers/TMS vendors, the country systems' vendors, an SMS/email provider.

## 5. To-be journey and aha moment
**Aha moment (customer):** the first order where the confirmed window is kept and the customer never had to chase.
**Aha moment (staff):** the first exception handled from one order view with a clear owner.

| Stage | What changes for the persona | Surfaces | Release |
|---|---|---|---|
| Awareness | Not served as a marketing stage: customers already know Company A; reason: the Hub is an internal investment (R-12), not an acquisition channel | — | — |
| Consideration | Availability and date shown are believable, with a confidence level | Promise widget/API in ordering channel; staff promise lookup | R1 |
| Decision | Customer confirms a delivery window; trade gives site details | Window selection, site-details form | R1 |
| Retention | Day-before and live-window updates, tracking, proof of delivery; exceptions reported once and followed through | Status page, SMS/email, exception report, case tracking, staff workbench | R1 (case tracking R2) |
| Advocacy | Fewer unresolved complaints; post-delivery feedback | Survey, closure message | R1 (survey), reviews are handled outside the product |
| Staff Mandate/Rollout | Early information and consultation (NO, SE), clear purpose and aggregate-only metrics | Rollout plan §9; staff guidance F-22 | R1 |

## 6. Completeness checklist
| Surface | Covered by | N/A reason |
|---|---|---|
| Public entry (website/landing/app listing) | — | N/A: no public marketing site; customers arrive via Company A's existing ordering channels and SMS/email links |
| Sign-up, login, logout, session expiry | F-13 (staff SSO), F-21 (customers: secure order links) | Customer self-registration N/A: customers use existing accounts or links |
| Identity verification / KYC | — | N/A: no regulated identity checks |
| Onboarding to the aha moment | F-22 (staff onboarding), F-02 (first window) | Customer onboarding N/A: first order is the onboarding |
| Core loop features | F-01..F-12 | — |
| Roles & permissions; invitations | F-13 | — |
| Admin / back-office tools to run the service | F-10, F-14, F-11 | — |
| Settings & profile; notification preferences | F-14 (admin settings), F-16 (customer preferences) | — |
| Notifications | F-04 | — |
| Payments, billing, invoices, refunds | — | N/A: no money moves in the Hub; claim outcomes (credit/refund) are executed in existing finance systems and recorded in F-10 |
| Consent, terms, privacy, cookies | F-15 | — |
| Data subject rights: export, correction, deletion | F-15 | — |
| Help, support contact, feedback | F-18, F-25 | — |
| Audit log / activity history | F-15 | — |
| Integrations & webhooks | F-19, F-08, F-23, F-24 | — |
| Analytics instrumentation | F-20 | — |
| Error, maintenance, not-found; degraded behaviour | F-18 | — |
| Localisation | F-17 | — |
| Accessibility commitments | F-26 | — |

## 7. Scope table — complete product

| F-ID | Feature | Type | Stage | O-IDs / basis | Release | Priority | Notes |
|---|---|---|---|---|---|---|---|
| F-01 | Availability and delivery promise at ordering (widget/API for channels + staff lookup), with confidence and "call branch" fallback | user-facing | CON, DEC | O-01 | [R1] | P1 | `[D-14]` which channel(s) host it in R1 |
| F-02 | Delivery window selection, confirmation, reschedule, change receiver, cancel (within rules) | user-facing | DEC | O-01, O-02 | [R1] | P1 | critical path to aha |
| F-03 | Site details for trade deliveries (access point, receiver, unloading needs) | user-facing | DEC | O-02, P-06 | [R1] | P2 | `[D-02]`: raise to P1 if pros are the beachhead |
| F-04 | Order and delivery status page; notifications (confirmation, day-before, live window, delay, delivered) by SMS/email | user-facing | RET | O-02 | [R1] | P1 | SMS read rates very high (S-036, Low) |
| F-05 | Proof of delivery view and customer exception report (damaged, missing, wrong) with photos | user-facing | RET | O-03 | [R1] | P1 | |
| F-06 | Customer case tracking and proactive updates for exceptions and claims | user-facing | RET, ADV | O-04 | [R2] | P2 | R1 uses F-10 plus email updates sent via F-04 |
| F-07 | Promise engine: rules-based availability-to-promise (stock by location, supplier lead time, delivery capacity, cut-offs, calendars) | back-office | CON, DEC | O-01 | [R1] | P1 | core |
| F-08 | Pilot-market adapter(s) and canonical order/stock/delivery data model; data-quality monitoring | integration | all | O-01, R-22, D-12 | [R1] | P1 | adapters depend on D-03 |
| F-09 | Delivery-event capture (driver app or carrier/TMS integration): status, proof of delivery, photos, signature | integration | RET | O-02, O-03 | [R1] | P1 | build vs integrate decided in Step 11 |
| F-10 | Exceptions and claims workbench: unified order view, ownership, SLA timers, templates, supplier/carrier recovery | back-office | RET | O-04, O-03 | [R1] | P1 | `[D-15]` operating owner per country |
| F-11 | Control-tower dashboard: KPR, promise accuracy, contacts, exceptions, claims; aggregate by market/branch | back-office | RET | North Star, stage metrics | [R1] | P2 | needed for baseline `[D-13]` |
| F-12 | AI-assisted functions: delivery-date/ETA prediction, exception triage, message drafts (human-overridable) | back-office | RET | O-01, O-04 | [R2] | P2 | needs ≥ 6 months of delivery data (S-032); R-20 |
| F-13 | Staff identity and access: corporate SSO, roles and permissions per country/branch | operational | all | security | [R1] | P1 | |
| F-14 | Admin: per-country configuration of rules, calendars, languages, templates, feature flags | operational | all | R-08 | [R1] | P1 | |
| F-15 | Consent, privacy notices, retention, customer data export/deletion, audit log, DPIA artefacts | operational | all | GDPR, S-014 | [R1] | P1 | required to operate legally |
| F-16 | Notification preferences and opt-out | operational | RET | GDPR/ePrivacy basis, to confirm in Step 11 | [R1] | P2 | |
| F-17 | Localisation framework and pilot-market language | operational | all | R-10 | [R1] | P2 | further languages arrive with F-23/F-24 |
| F-18 | Help content, status/maintenance/not-found pages, degraded-mode behaviour | operational | all | NFR | [R1] | P2 | |
| F-19 | Integration API and webhooks for webshop, trade app, counter/POS and other channels | integration | all | R-08, R-22 | [R1] | P1 | |
| F-20 | Analytics instrumentation for stage metrics | operational | all | §3 | [R1] | P2 | |
| F-21 | Customer access via secure order links or existing account | operational | DEC, RET | auth model | [R1] | P1 | |
| F-22 | Staff onboarding and in-app guidance; rollout materials hosted in the product | operational | Mandate/Rollout | S-012, S-013 | [R1] | P2 | consultation itself is a rollout activity, §9 |
| F-23 | Adapter and language set for second market | integration | all | R-11 | [R2] | P1 | market per `[D-04]` sequence |
| F-24 | Adapter and language set for third market | integration | all | R-11 | [R3] | P1 | |
| F-25 | Feedback capture and post-delivery survey | user-facing | ADV | ADV metric | [R1] | P3 | |
| F-26 | Accessibility conformance for customer-facing pages (WCAG 2.2 AA commitment) | operational | all | accessibility checklist | [R1] | P2 | |

Release summary: **R1** delivers the full promise-to-resolution loop in the pilot market — promise, window confirmation, tracking and notifications, proof of delivery, exception reporting, the staff workbench, dashboard, adapters, access, compliance and admin — on one deployable footprint. **R2** adds the second market, customer case tracking and AI-assisted functions. **R3** adds the third market.

Product definition: *The Promise & Delivery Hub gives Company A's customers, branches, dispatch and support a reliable delivery promise and a single, owned path through any exception, so that promises made are promises kept.*

## 8. Parking Lot (sole owner)
| PL-ID | Item | Why outside scope | Revisit condition | Status |
|---|---|---|---|---|
| PL-01 | Store stock-accuracy and store-task execution programme (Concept 2, O-05) | Outside the chosen solution; evidence thin (P-07, RK-03); highest labour-law friction | Pilot baseline shows stock data quality is the binding constraint (D-09, D-10) | open |
| PL-02 | Manual back-office process automation (U-01, Denmark) | No evidence on which processes `[D-08]` | D-08 answered with named processes | open |
| PL-03 | Replacement of ERP/POS | Conflicts with R-15; Lidl case (S-029); RK-01 | Integration proves infeasible in all markets | open |
| PL-04 | Price harmonisation across markets | Out of scope pain (E15, E27) | Board request | open |
| PL-05 | Supplier portal for sharing lead times | Idea beyond the solution; lead times come through adapters in R1 | Supplier data quality limits promise accuracy | open |

## 9. Scale: rollout across markets (from the brief's "Scale")
One core product, three implementations (R-08). Pilot market per `[D-04]`; recommended Sweden (consistent delivery-pain evidence, S-004, S-007, S-020; MBL §11 negotiation first, S-013).

| | Sweden | Norway | Denmark |
|---|---|---|---|
| Brief's stated priority | Delivery and fulfilment | Store operations | Manual processes `[D-08]` |
| Employee-facing legal step | Negotiation under MBL §11 before significant change (S-013) | Consultation under WEA ch. 9 for control measures; aggregate metrics (S-012) | GDPR, Datatilsynet focus on monitoring (S-014) |
| What the Hub stresses | Delivery visibility, exceptions | Same product; staff-facing parts need early representative involvement; data-quality alerts rather than staff tasks | Same product; automate exception admin first; revisit PL-02 once `[D-08]` |
| Systems adapter | `[D-03]` unknown | `[D-03]` | `[D-03]` |
| Release | per D-04 | per D-04 | per D-04 |

## 10. Scope decision log
| Feature | Decision | Rationale | Evidence / D-ID |
|---|---|---|---|
| F-12 | R2 | Needs delivery history; rules-based promise first | S-032, R-20 |
| F-06 | R2 | R1 exceptions are visible by notification and handled in F-10 | O-04 |
| F-23/F-24 | R2/R3 | Single pilot market in R1 | R-11, R-15 |
| Concept 2 and U-01 | Parking Lot | Not part of chosen solution | PL-01, PL-02 (D-08, D-09) |
| Nothing required by Step 07 was moved to the Parking Lot | — | — | — |

## Open decisions raised at this step
D-13 North Star targets/baseline; D-14 first-release ordering channel(s); D-15 who operates exceptions per country; D-16 cost allocation to countries.

## Deliverables checklist
- [x] North Star defined exactly once
- [x] One metric per journey stage (AWR stated as coverage with reason)
- [x] Every capability in Step 07's list is an F-ID (Step 07 items 1-20 → F-01..F-20; additions F-21..F-26 from the completeness checklist)
- [x] Completeness checklist answered
- [x] Every F-ID has a release; R1 deployable on its own
- [x] No demo-only items, no `[MVP]` labels
- [ ] Gate A passed (pending user)
