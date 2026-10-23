Step 08 · Searches used: 2/3 (touchless-rate and APQC cost benchmarks) · Sources: S-037, S-038, S-039, S-046, S-048, S-052, S-053, S-055, S-057

# Step 08 — Product Strategy & Scoping (complete product)

> The complete Order Intake Assistant (Step 07), phased into releases. R1 is shaped by the user's 12-week Denmark plan (R-24, R-25, R-27); that shrinks R1, not the specification. R2 and R3 come from S-037's "Later phases" column (D-26 to confirm). Open items are marked `[D-##]`. The earlier delivery-concept Step 08 is archived.

## 1. Vision, mission, hypothesis
**Vision.** Every trade order Company A receives, in whatever form the customer sends it, becomes a correct, priced order in the ERP within minutes, with a person in control.
**Mission.** Give order handlers an assistant that reads, matches, prices and prepares each order so they approve instead of key, and give management a measured view of how orders arrive.
**Hypothesis.** We believe order handlers (PER-4) at Danish merchant branches and order offices spend a large share of their time re-keying unstructured orders from trade customers (P-09, P-10) because interpreting free-form trade orders has been human work and its cost is invisible. If we build an assistant that prepares draft orders for one-click approval and keeps the customer's channel, handlers will approve most drafts without edits and customers will get faster, more accurate confirmations, measured by the share of orders approved without edits, with line error rate and time to confirmation as guardrails.

## 2. North Star (defined here once)
**Orders approved without edits** (OAWE).
- **Definition:** among orders for which the assistant produced a draft, the share that the order handler approved with no change to customer, lines, quantities, units, SKUs, prices or delivery date. Measured weekly per office and market.
- **Why it reflects value:** it is the point where interpretation work has moved from the person to the assistant while the person remains accountable. It is the first measure in the user's plan (R-27).
- **Guardrail pairing:** it is only meaningful together with the post-approval line error rate (§3), because approving a wrong draft without edits would otherwise score as success.
- **Benchmarks (adjacent, not identical):** APQC touchless order rate: average ~67%, top performers ~94% (S-057, cross-industry, fully touchless); Esker/Siemens Healthineers: automated-order rate 8% → 85% (S-052, vendor). Company A baseline unknown.
- **Targets at 3 and 12 months:** set after the weeks 1-2 baseline, as gains over baseline (R-27, D-13 decided).

## 3. Stage metrics and guardrails
| Stage | Metric | Definition | Measurement event (names finalised in Step 11) | Benchmark |
|---|---|---|---|---|
| Mandate/Rollout | Adoption | Share of order messages in the pilot office processed through the workspace (vs outside it) | `message_received`, `message_opened_in_workspace` | none; baseline |
| AWR | Not served | Existing B2B customers already email their orders; the product changes handling, not discovery | — | — |
| CON | Not served | Same reason; customers keep their channel (R-25) | — | — |
| DEC | **Orders approved without edits** (North Star) and **time to confirmation** (median minutes from message received to confirmation sent) | As §2 and §3 text | `draft_created`, `draft_approved`, `draft_edited`, `confirmation_sent` | S-052, S-057 |
| RET | **Line error rate** (credit notes coded wrong item, quantity or price per 1,000 order lines) and **handling time per order** (median minutes of handler time, measured at team level) | R-27 measures | `credit_note_coded` (from ERP), `handling_time_recorded` | APQC cost per order context (S-048) |
| ADV | Handler usefulness | Anonymous team-level score from a short in-product pulse | `pulse_answered` | none |

Guardrails:
1. **Post-approval line error rate** must not rise versus baseline (protects the North Star).
2. **Exception-queue backlog age** (oldest unhandled item) stays below a threshold set after baseline.
3. **Cost per processed order** (LLM and run cost) stays below a ceiling set after baseline (D-13 decided).
4. **Structural guardrail (R-26):** no metric is reported, stored or displayed at the level of an individual employee; aggregation is by team and office only.

## 4. Business-model snapshot
- **Who pays:** Company A (executive board investment); no external price for the pilot.
- **Supplier angle (context, S-037 §3):** the solution is intended to be productisable and resellable to other wholesalers, supporting Netcompany's EBITDA target for 2029 (R-29); this is not a Company A requirement.
- **Value logic:** handler time released, fewer line errors and credit notes, faster confirmations. Sized only by the labelled illustrative model (R-31) until the baseline.
- **Adoption channel:** internal rollout through the order-office lead; customers are reached by the existing order mailbox.
- **Main cost drivers:** ERP integration per market, LLM usage, change management, evaluation and monitoring.
- **Key partners:** ERP vendor/IT owner (STK-11), LLM provider (STK-12, D-19), mail platform.

## 5. To-be journey and aha moment
**Aha moment (handler):** the first morning the queue holds ready drafts and the handler clears the easy ones with one click each.
**Aha moment (customer):** a correct, correctly priced confirmation arrives within minutes, with no need to ask.

| Stage | What changes | Surfaces | Release |
|---|---|---|---|
| Mandate/Rollout | Staff know what the assistant does and does not do (no individual monitoring); the order-office lead configures and monitors | Onboarding and guidance, admin, lead view | R1 |
| AWR, CON | Not served (reasons in §3) | — | — |
| DEC | Message → draft → one-click approval → confirmation; exceptions queued by confidence | Mailbox connector, review workspace, confirmation email | R1 |
| RET | Drafts are written to the ERP; corrections feed learning; exceptions after the order are listed | Write-back, exceptions list, dashboard | R1 (auto-approval policy and tuning R2) |
| ADV | Handlers rate usefulness; customers feel faster service | Pulse | R1 |

## 6. Completeness checklist
| Surface | Covered by | N/A reason |
|---|---|---|
| Public entry (website/landing/app listing) | — | N/A: internal staff product; customers use their existing email channel |
| Sign-up, login, logout, session expiry | F-19 (staff SSO) | Customer sign-up N/A: customers have no accounts in this product |
| Identity verification / KYC | — | N/A: staff identity via corporate SSO; customers not identified by the product beyond ERP records |
| Onboarding to the aha moment | F-26 | — |
| Core loop features | F-01..F-12 | — |
| Roles & permissions; invitations | F-19 | Invitations N/A: users come from corporate SSO groups |
| Admin / back-office / operator tools | F-13, F-14, F-16, F-17 | — |
| Settings & profile; notification preferences | F-16 (admin settings), F-22 (user preferences) | — |
| Notifications | F-22 (staff), F-09 (customer confirmation email) | — |
| Payments, billing, invoices, refunds | — | N/A: no money moves; prices are read from the ERP |
| Consent, terms, privacy, cookies | F-20 | Cookie consent N/A: staff app without tracking cookies beyond strictly necessary (to confirm in Step 11) |
| Data subject rights: export, correction, deletion | F-20 | — |
| Help, support contact, feedback | F-23, F-27 | — |
| Audit log / activity history | F-20 | — |
| Integrations & webhooks | F-01, F-05, F-08, F-18, F-29, F-35, F-36 | — |
| Analytics instrumentation | F-28 | — |
| Error, maintenance, not-found pages; degraded behaviour | F-23 | — |
| Localisation | F-23, F-31 | — |
| Accessibility commitments | F-25 | — |

## 7. Scope table — complete product

| F-ID | Feature | Type | Stage | O-IDs / basis | Release | Priority | Notes |
|---|---|---|---|---|---|---|---|
| F-01 | Mailbox connector: ingest email, PDF, Excel from configured order mailboxes; de-duplication, threading, attachments, non-order filtering | integration | DEC | O-01 | [R1] | P1 | critical path |
| F-02 | Message classification and routing: order, quote request, status request, complaint, other | back-office | DEC | O-01 | [R1] | P1 | MVP acts on order and status; others routed to a human queue |
| F-03 | Order extraction: customer, site, lines, quantities, units, delivery wishes, each with confidence | back-office | DEC | O-01 | [R1] | P1 | R-28 |
| F-04 | SKU matching on catalogue and purchase history (top ~2,000 SKUs first), unit normalisation, alternatives | back-office | DEC | O-01 | [R1] | P1 | R-25 |
| F-05 | Price and availability check (read-only): contract/project price, stock, credit from the ERP | integration | DEC | O-01, O-02 | [R1] | P1 | rules, not AI (R-28) |
| F-06 | Delivery-date proposal with a confidence level (rule-based) | back-office | DEC | O-02 | [R1] | P2 | G2 borrow (R-23) |
| F-07 | Review workspace: message and draft side by side; approve in one click; edit lines; reject, forward, reassign; exception queue by confidence | user-facing | DEC | O-01, O-03 | [R1] | P1 | critical path |
| F-08 | Draft-order write-back to the ERP via API with RPA fallback; idempotency, retry, error queue, status sync | integration | DEC | O-01 | [R1] | P1 | RK-07, D-23 |
| F-09 | Customer confirmation in the customer's language after approval; templates; reply tracking | user-facing | DEC | O-02 | [R1] | P1 | Danish with English fallback (D-20) |
| F-10 | Status-request answers from ERP data, sent after approval | user-facing | DEC | O-02 | [R1] | P2 | S-037 §4.3 "order and status requests" |
| F-11 | Correction capture as evaluation data; evaluation harness; model/prompt version metrics | back-office | RET | O-03, O-04 | [R1] | P1 | R-27 |
| F-12 | Read-only list of exceptions after the order (missing site data, stock shortfall) | user-facing | RET | O-03 | [R1] | P3 | S-037 step 10 |
| F-13 | Order-office lead view: queue monitor, assignment, service timers; aggregate only | user-facing | RET | O-03, R-26 | [R1] | P2 | four roles (D-22) |
| F-14 | Measurement dashboard including baseline mode for weeks 1-2 | user-facing | RET | O-04, R-27 | [R1] | P1 | North Star and stage metrics |
| F-15 | Shadow-mode comparison: assistant draft vs the human-entered order; no ERP write | back-office | DEC | R-27 (weeks 3-8) | [R1] | P1 | part of the real rollout plan, not a demo device |
| F-16 | Admin configuration: mailboxes, SKU scope, confidence thresholds, templates, languages, feature flags per market, model/prompt versions | operational | all | R-24, R-26 | [R1] | P1 | |
| F-17 | Master-data sync (catalogue, units, customer purchase history) and a customer-specific alias dictionary managed by handlers | integration | DEC | O-01 | [R1] | P1 | |
| F-18 | Pilot-market adapters for ERP and mail (Denmark) | integration | all | R-30, D-23 | [R1] | P1 | |
| F-19 | Staff identity and access: corporate SSO, roles, scoping by office/market | operational | all | security, (D-22 decided) | [R1] | P1 | |
| F-20 | Privacy and audit: DPIA artefacts, retention and deletion, redaction before LLM calls, data-subject requests for customer contacts, audit log of approvals and ERP writes | operational | all | GDPR (S-014) | [R1] | P1 | required to operate legally |
| F-21 | LLM gateway: provider abstraction, prompt versioning, injection guardrails, cost metering, EU region | operational | all | S-055, (D-19 decided) | [R1] | P1 | |
| F-22 | Staff notifications (queue alerts) and preferences | operational | DEC | O-03 | [R1] | P3 | |
| F-23 | Localisation, help, status/maintenance/not-found pages, degraded mode (AI unavailable → messages pass through unprocessed) | operational | all | NFR | [R1] | P2 | (D-20 decided) |
| F-24 | Observability: mailbox, ERP and model health; alerts | operational | all | NFR | [R1] | P2 | |
| F-25 | Accessibility conformance for the review workspace (WCAG 2.2 AA commitment) | operational | all | accessibility checklist | [R1] | P2 | |
| F-26 | Staff onboarding and in-product guidance; rollout materials stating what the assistant does and does not do | operational | Mandate/Rollout | R-26 | [R1] | P2 | |
| F-27 | Feedback and support channel to the project team | operational | ADV | support | [R1] | P3 | |
| F-28 | Analytics instrumentation for stage metrics | operational | all | §3 | [R1] | P2 | |
| F-29 | Additional intake channels: phone/voicemail transcripts, photo/image orders, EDI change messages | integration | DEC | O-01, S-037 §4.3 | [R2] | P1 | |
| F-30 | Complaint and return message handling: classify, draft acknowledgement, route to a case queue (no claims processing) | user-facing | DEC, RET | O-03, S-037 §4.3 | [R2] | P2 | claims handling stays parked |
| F-31 | Full-catalogue matching and additional languages | back-office | DEC | O-01, S-037 §4.3 | [R2] | P1 | |
| F-32 | Confidence-based auto-approval policy (gradual autonomy) with guardrails and audit | back-office | DEC | O-01, S-037 §4.3 | [R2] | P2 | requires baseline data |
| F-33 | ML-based delivery-date estimate once 6+ months of delivery data exist | back-office | DEC | O-02, S-032 | [R2] | P3 | |
| F-34 | Model tuning from stored corrections, with evaluation-gated release | back-office | RET | O-03, S-037 §4.3 | [R2] | P2 | |
| F-35 | Norway adapter set: ERP/mail adapters, Norwegian language, local configuration | integration | all | R-24, S-037 §4.3 | [R3] | P1 | |
| F-36 | Sweden adapter set: ERP/mail adapters, Swedish language, local configuration | integration | all | R-24, S-037 §4.3 | [R3] | P1 | |
| F-37 | Sweden proactive delivery exceptions linked to carrier or transport-visibility tools | integration | RET | O-02, S-037 §4.3 | [R3] | P3 | tools optional and vendor-neutral (D-18) |

Release summary: **R1** delivers the full order-intake loop for the Denmark pilot office: mailbox in, extraction and matching, pricing and checks, review and one-click approval, write-back, confirmation, measurement, shadow mode, and every operational surface needed to run it legally and safely. **R2** adds channels (phone, photos, EDI changes), complaint and return routing, the full catalogue and more languages, auto-approval by confidence, ML delivery estimate and model tuning. **R3** adds Norway and Sweden adapter sets and Swedish proactive delivery exceptions.

Product definition: *The Order Intake Assistant reads the orders Company A's trade customers already send and prepares correct, priced draft orders that order handlers approve in one click, so that interpretation work moves from people to the assistant while people stay in control.*

## 8. Parking Lot (sole owner)
| PL-ID | Item | Why outside scope | Revisit condition | Status |
|---|---|---|---|---|
| PL-01 | Project-quote automation (G5) | Excluded by the user (R-26) | After R1 baseline shows quote handling is large | open |
| PL-02 | Forecasting and replenishment (G6) | Excluded by the user (R-26); already served by specialists (S-051) | Board request | open |
| PL-03 | ERP replacement or consolidation (G10) | Excluded by the user (R-26); S-029 | Overlay proves infeasible | open |
| PL-04 | Delivery orchestration and proactive tracking beyond the date proposal (G2) | Outside the chosen solution; ranked second (S-037 §3) | Nordic data show late/failed deliveries above 10% (S-037 §4.2) | open |
| PL-05 | Store staff assistant (G3), PIM (G4), claims and credit-note processing (G8), account opening and credit (G9), click and collect / OMS (G7) | Outside the chosen solution; weaker evidence (S-037 §2-3) | Per S-037 ranking-change table | open |
| PL-06 | DIY consumer features | D-02 decided: B2B only | Board request | open |
Permanently excluded (not parked): monitoring of individual employees (R-26).

## 9. Scale: rollout across markets
One core, per-market adapter sets (R-24, R-26). Denmark is R1 (pilot); Norway and Sweden are R3 (F-35, F-36).

| | Denmark (R1) | Norway (R3) | Sweden (R3) |
|---|---|---|---|
| Brief's stated priority | Manual processes (the chosen opportunity) | Store operations (not this product) | Delivery and fulfilment (F-37 only) |
| Employee-facing legal step | GDPR; Datatilsynet scrutiny of monitoring (S-014); Danish consultation rules not yet researched | Working Environment Act ch. 9 applies to control measures; this product has none by design (R-26), consultation on changed work routines to be confirmed (S-012) | MBL §11 negotiation before significant changes (S-013) |
| Adapters | ERP/mail for the pilot (D-23) | (D-03 accepted-risk) | (D-03 accepted-risk) |
| Language | Danish, English (D-20 decided) | Norwegian (R2/R3) | Swedish (R2/R3) |

## 10. Scope decision log
| Feature | Decision | Rationale | Evidence / D-ID |
|---|---|---|---|
| F-29..F-34 | R2 | From S-037 "Later phases" column | D-26 |
| F-35..F-37 | R3 | Same | D-26, D-18 |
| F-06 | R1 with rule-based date | S-037 step 5 | R-28 |
| F-15 | R1 | Shadow mode is part of weeks 3-8 | R-27 |
| Delivery orchestration | Parking Lot | Chosen solution is order intake | PL-04 |
| Nothing required by Step 07's list was moved to the Parking Lot | — | — | — |

## Open decisions raised at this step
All decisions raised here were resolved at the Step 12 closure (see `_decisions.md` and `05-deliver/12-closure-log.md`).

## Deliverables checklist
- [x] North Star defined exactly once (OAWE)
- [x] One metric per journey stage (AWR/CON/ADV stated as not served or pulse, with reasons)
- [x] Every Step 07 capability (1-25) is an F-ID (F-01..F-28 incl. additions; R2/R3 F-29..F-37)
- [x] Completeness checklist answered
- [x] Every F-ID has a release; R1 deployable on its own
- [x] No demo-only items, no `[MVP]` labels
- [x] Gate A passed (2026-10-23, on the user's instruction to run to the PRD on the decisions in S-037)
