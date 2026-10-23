Step 07 · Searches used: 5/6 · Sources: S-002, S-010, S-014, S-017, S-025..S-032

# Step 07 — Solution Proposal (includes problem-solution fit)

## 1. Depth and reason
**depth: full.** The input is problem-led (no user concept to validate), so three genuinely different mechanisms are compared (rule: Step 07 SKILL.md, Depth).

## 2. Concepts

| Field | Concept 1 — Promise & Delivery Hub | Concept 2 — Store Stock Truth | Concept 3 — Care & Claims Desk |
|---|---|---|---|
| Mechanism | An orchestration layer **on top of** existing country systems. It reads stock, supplier lead times and delivery capacity through adapters, computes the availability and delivery promise, lets customers confirm a window, tracks delivery, and runs exceptions and claims on one order view | A mobile data-capture app embedded in goods receipt, picking and cycle counts, plus store task execution, to keep store stock records accurate | A case-management desk that gives support, branches and dispatch one order view, ownership and SLA for exceptions and claims; proactive messages |
| Opportunities addressed | O-01, O-02, O-03, O-04 (indirectly O-05 via data-quality alerts) | O-05, indirectly O-01 | O-04, partly O-03 |
| Journey stages changed | CON (credible claim), DEC (confirm window), RET (tracking, exceptions), ADV (fewer unresolved complaints) | RET (internal) | RET, ADV |
| Stakeholder tensions resolved | STK-1↔STK-5: one core, per-country configuration. STK-2/3↔STK-8: promise includes supplier lead time | STK-4↔STK-3: accuracy as by-product of existing tasks. Raises STK-6 tension | STK-3 ↔ support: one owner |
| Hypothesis | If customers are shown a promise made from reconciled data and are told proactively about exceptions, then promise failures, "where is my order" contacts and cancellations fall, measured by on-time-in-full and promise accuracy | If receiving and picking capture updates stock, records drift less, then promises are more accurate | If exceptions have an owner and one view, then resolution time falls |
| Analogous successes | Travis Perkins and STARK UK/Jewson launched real-time delivery tracking with named windows (S-030, no quantified result); retail order-promising cases: −40% stock-mismatch cancellations in 3 months (S-031, vendor) | Reflexis-type store task tools: vendor claims only (S-015); stock-accuracy research (S-016) | WISMO reduction ~40% from proactive messages (S-025, vendor) |
| Analogous failures | Lidl SAP: ~€500m, abandoned after 7 years; lesson: do not customise/replace core ERP around local processes (S-029) | No failure found for store task tools; compliance gaps with employee consultation (S-012) | None found (searches tried: 1) |
| Feasibility — technical | ⚠️ needs read access to stock/order/delivery data in the pilot market (D-12, D-03); promise rules are standard; ML ETA needs ≥ 6 months of data, so start rules-based (S-032) | ✅ mobile capture is mature | ✅ case management is mature; needs order data feed |
| Feasibility — economic | ⚠️ cost and value not sized (D-07) | ⚠️ benefit indirect, not sized | ✅ lowest cost; benefit not sized |
| Feasibility — regulatory | ⚠️ customer data under GDPR; driver GPS needs DPIA (S-014); use aggregate staff metrics | ❌ highest friction: NO WEA ch. 9, SE MBL §11, DK monitoring scrutiny (S-012..S-014) | ✅ |
| Feasibility — organisational | ⚠️ needs country management, dispatch, carriers (STK-5, STK-9) | ⚠️ staff acceptance, no staff voice (RK-03) | ⚠️ support ownership |
| Effort / time to deployable first release | M (thin overlay in one market; full scope L) | M | S |
| Key assumptions | D-10, D-11, D-12 | D-09 | O-04 root cause hypotheses |

## 3. Fit evidence and failure modes
- **Works elsewhere:** merchants in the UK launched named-window delivery tracking; STARK UK (the parent of Nordic peers) did it for Jewson (S-030). Outcome numbers were not found, so effect size is not evidenced for builders' merchants. Retail order-promising cases show cancellation reductions of 40-52%, but are vendor-reported and not heavy goods (S-031).
- **Fails when:** a core-system replacement or heavy customisation is attempted (S-029). Failure modes to watch for Concept 1: stock data too poor to promise from (low-confidence promises), integration delays, notification fatigue, dispatch not adopting status events, staff consultation delaying rollout in NO/SE (S-012, S-013).
- **No failure case for delivery tracking itself** was found (1 search).

## 4. Decision matrix
Weights derived from the judging rubric (R-12) and time to market (R-15), not the default: opportunity coverage 30 (Problem Understanding, Prioritisation), business impact and innovation 25, feasibility 25 (Feasible Solution), time to deployable release 15, risk 5. Scores 1-5, each a judgment.

| Criterion | Weight | C1 Hub | C2 Store Stock Truth | C3 Care & Claims Desk |
|---|---|---|---|---|
| Opportunity coverage | 30% | 5 — four of five scored O-IDs (O-01 15, O-04 14, O-02 13, O-03 12) | 2 — O-05 (score 8) + indirect | 3 — O-04 (14), part of O-03 |
| Business impact & innovation | 25% | 5 — customer-visible, measurable (OTIF, WISMO, claims); differentiating vs peers (whitespace 1-3, 02 §5) | 3 — indirect, hard to measure | 3 — useful, less differentiating |
| Feasibility | 25% | 3 — integration unknowns | 3 — consultation friction | 4 — mature tech |
| Time to deployable first release | 15% | 3 — pilot slice feasible, full scope larger | 4 | 4 |
| Risk (inverse) | 5% | 3 — data quality, scope | 2 — labour law, no staff voice | 4 |
| **Weighted score** | 100% | **4.10** | **2.80** | **3.45** |

Sensitivity: C1 stays first unless feasibility is weighted above ~55% with the other weights scaled proportionally (computed from the table).

## 5. Go / Pivot / Stop
**Decision: Go with Concept 1.** **Confidence: Medium** — the problem evidence is strong but sourced from peers, not Company A (RK-04), and the root-cause chain is a hypothesis (D-09, D-10). Concept 3's exception desk is part of Concept 1's capabilities (O-04); Concept 2's stock feedback becomes a data-quality feed and a later enabler, not a separate programme (R-03: fragmentation is a constraint). No Pivot/Stop, so no blocking D-##.

## 6. Chosen concept — Promise & Delivery Hub (working name)

### How it works
A thin, configurable layer between customers/channels and each country's existing systems. When a customer (or branch staff) builds an order, the Hub returns what can actually be promised: which items can come from which location or supplier, the earliest date and delivery window, and how confident that promise is. The customer confirms a window and, for trade, who receives and how to access the site. On the delivery day the customer gets a named window, live status and proof of delivery. If anything goes wrong — delay, shortage, damage — an exception is raised, a named owner is assigned, the customer hears first and can follow the case to resolution. One core product, with per-country configuration for rules, languages, systems adapters and consultation steps (R-08). It does **not** replace ERP/POS (S-029; RK-01 resolved towards integration) and uses AI only in supporting roles (R-20).

### Required capabilities (complete list for production)
User-facing (customers: PER-1 pro, PER-2 DIY)
1. Availability and delivery promise at ordering, with confidence and fallback to "call branch" when data is unavailable
2. Delivery window selection and confirmation; reschedule/change receiver/cancel within rules
3. Site details for trade deliveries (access point, receiver contact, unloading needs)
4. Order and delivery status page; proactive notifications (SMS/email) at confirmation, day before, live window, delay, delivered
5. Proof of delivery and delivery exception reporting by the customer (damaged, missing, wrong) with photos
6. Case tracking and proactive updates for exceptions and claims
Operational and back-office (staff: support, branch, dispatch)
7. Promise engine: rules-based availability-to-promise from stock by location, supplier lead times and delivery capacity, with per-country cut-offs and calendars
8. Country adapters and canonical order/stock/delivery data model; data-quality monitoring (stock mismatches, stale feeds)
9. Delivery-event capture: driver/carrier status events, proof of delivery, photos, signatures (driver app or integration with the existing TMS/carrier, decision in Step 11)
10. Exceptions and claims workbench: unified order view, ownership, SLA timers, templates in DA/NO/SV, supplier and carrier recovery tracking
11. Control-tower dashboard: on-time-in-full, promise accuracy, contacts, exceptions, claims by market/branch (aggregate only)
12. AI-assisted functions (supporting): delivery-date/ETA prediction once a baseline exists; exception triage; message drafts — always human-overridable
Platform and legal
13. Staff identity and access: corporate SSO, roles and permissions per country/branch; customer access via existing accounts or secure order links
14. Admin: per-country configuration of rules, calendars, languages, templates, feature flags
15. Consent, privacy notices, retention, customer data export/deletion, audit log, DPIA artefacts
16. Notification preferences and opt-out
17. Localisation (DA, NO, SV, EN)
18. Help/support content, status and maintenance pages, error and degraded-mode behaviour
19. Integration API and webhooks for webshop, trade app, counter/POS and other channels
20. Analytics instrumentation for stage metrics

### USPs (each traced)
1. **Promise made from reconciled data** — no peer sampled is credible on promise reliability (02 §5 whitespace 1; O-01).
2. **Proactive exception handling with an owner** — "no follow-up" is the recurring complaint (whitespace 2; O-04).
3. **Site-aware delivery for trade** — access, receiver, window (whitespace 3; O-02).
4. **One core, local configuration** — answers "one solution, different implementations" (R-08; STK-1↔STK-5).

### Stated limitations and preconditions
- It cannot fix late suppliers or physical shrink; it makes them visible in the promise.
- Promise quality depends on stock data quality; low-confidence promises are shown as such. Store-level accuracy work (O-05) is an enabler outside this concept.
- Needs read (and for exceptions, write) access to existing systems in each country (D-12, D-03).
- Not a price, assortment or ERP replacement programme; heavy-goods dispatch rules differ from parcels (S-028 is parcel data).

### Top-3 assumptions → `_decisions.md`
D-10 (failures mainly controllable), D-11 (promise reliability outranks price), D-12 (data accessible in pilot timeframe). Additionally D-09 (stock accuracy → promise link).

## Deliverables checklist
- [x] Every concept maps to O-IDs and stages
- [x] Fit evidence includes a failure case (S-029) and states none found for tracking
- [x] Feasibility covers all four dimensions
- [x] USPs each trace to a gap or O-ID; limitations stated
- [x] Required-capabilities list covers the whole solution incl. operational/back-office, not a demo slice
- [x] No per-option RICE scores
