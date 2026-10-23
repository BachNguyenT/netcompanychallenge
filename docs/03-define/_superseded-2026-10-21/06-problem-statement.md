Step 06 · Searches used: 4/4 · Sources: S-004..S-011, S-016, S-017, S-025..S-028

# Step 06 — Problem Statement

> Open items carried: persona choice `[D-02]` (pro vs DIY), Danish manual processes `[D-08]`. They are marked, not assumed. The POV is written for the shared customer problem so it holds under either D-02 outcome.

## 1. Opportunity matrix
Importance = judgment from severity × frequency of the pains (1-10). Satisfaction = baseline 5 (average peer Trustpilot score ≈ 2.5/5 × 2: S-004..S-008) adjusted by theme-specific evidence. **These are judgment scores, not measurements.** Opportunity = Importance + max(Importance − Satisfaction, 0).

| O-ID | Opportunity (need not met) | P-IDs | Stage | Lane / segment | Importance (basis) | Satisfaction (basis) | Score | Rank |
|---|---|---|---|---|---|---|---|---|
| O-01 | Customers can rely on the availability and delivery date promised when they order | P-01, P-02 | CON, DEC, RET | A / SEG-1, SEG-2 | 9 (H severity, H frequency; 3 source types) | 3 (baseline 5, −2: complaint is core in every peer sampled) | **15** | 1 |
| O-04 | When something goes wrong, customers reach someone who resolves it, and are told proactively | P-05, P-08 | RET, ADV | A / SEG-2 (SEG-1 not evidenced) | 8 (H/H; review-site + forum) | 2 (baseline −3: unreachable support and no replies on 4 of 5 chains) | **14** | 2 |
| O-02 | Buyers can plan around a delivery: status, window, receiver and site access are coordinated | P-03, P-06 | DEC, RET | A / SEG-1 (H), SEG-2 (M) | 8 (H for pros; P-06 thin) | 3 (baseline −2: nothing comparable found in Nordic peers; UK app case only, S-017) | **13** | 3 |
| O-03 | Customers receive the right goods undamaged | P-04 | RET | A / SEG-1, SEG-2 | 8 (H/H; 3 source types) | 4 (baseline −1: also depends on carriers and producers) | **12** | 4 |
| O-05 | Store staff keep stock records accurate with low extra effort | P-07 | RET (internal) | B / SEG-3 | 6 (M/M; thin, no staff voice) | 4 (records known to drift, S-016) | **8** | 5 |
| U-01 | Manual back-office processes (Denmark) — **not scored: no evidence** `[D-08]` | — | — | — | — | — | — | — |

O-01, O-03 and O-04 are *symptoms at the customer*; O-05 is the internal enabler of O-01 (hypothesis D-09), which is why it scores low as a standalone need but matters as a root cause.

## 2. Target stages for the product
| Stage | Why |
|---|---|
| Decision | The promise is made and confirmed here (O-01, O-02); the bottleneck begins here (05 §6) |
| Retention (delivery and after) | Where the promise is kept or broken, and exceptions arise (O-01..O-04); 6 of 8 pains |
| Consideration | The stock/date claim shown to the customer must be credible (P-01) — a lighter touch |
| Awareness, Advocacy | Not targeted as such; Advocacy improves as a result (P-08), no separate effort. Stated, not left blank |

## 3. Cost of the problem
No Company A or Nordic cost figures were found (R-06). Benchmarks from other contexts only, **not Company A's cost**:

| Figure | Context | S-ID | Reliability |
|---|---|---|---|
| 60% of merchants say sales are lost because a product is not in stock; 38% because delivery/lead time is too long | UK builders' merchants (supplier-relationship survey) | S-026 | Low-Medium |
| WISMO = 40-60% of e-commerce support contacts, £4.50-8.00 per contact; proactive notifications cut ~40% | UK e-commerce, vendor blogs | S-025 | Low |
| ~€14 per missed first delivery attempt; 5-10% first-attempt failure | European parcels | S-028 | Low (not heavy goods) |
| US$3,000-7,000 per delivery damage claim | US building-materials distribution, vendor | S-010 | Low-Medium |
| Idle crew and rented machinery (no figure) | UK trade | S-017 | Low-Medium |
| Peers' margins are thin: EBITDA 3.7% (STARK), EBITA 5.9% (Byggmax) | Nordic | S-002, S-003 | High / Medium-High |

Persona-level cost per period (time/money): **not quantifiable from available evidence.** Market-level aggregate: **not quantifiable.** Both go to `D-07` (sizing method) and `D-10` (baseline measurement). Nothing is estimated silently.

## 4. Root causes (top 3 opportunities)

### O-01 — promise not kept
Symptom: "in stock, 2-5 days" turns out false (E1, E5, E7, S-007, S-004).
1. Why? The availability and date shown do not reflect real stock, supplier or dispatch status (S-007).
2. Why? The promise is computed from stock records and static lead times that drift from reality (S-016, S-027).
3. Why? Records are maintained through manual store routines and several local systems; supplier lead time and delivery capacity are not part of the calculation (S-019, S-027, R-01).
4. Why? Each country/region built its own systems and processes for local needs (R-01, S-001).
5. **Root cause (hypothesis, D-09/D-10):** nothing owns or computes a single "order promise" across stock, supplier lead time and delivery capacity; the promise is made locally from partial data.
Implication: fixing last-mile delivery alone will not stop the failures; the promise must be made from reliable data.
Evidence quality: steps 1-2 sourced (reviews, academic, vendor); steps 3-5 are Company A hypotheses from the brief.

### O-04 — problems not resolved
Symptom: unreachable support, no follow-up, no reply to reviews (E2, E3, E6, S-007, S-006).
1. Why? Customers cannot get through or get an answer (S-007: phone support removed, email rarely answered).
2. Why? Hypothesis: the people handling contacts cannot see one reliable view of the order, delivery and claim `[D-10]`.
3. Why? Order, delivery and claim information sit in separate systems and local processes (R-01; S-027 on fragmented ERP data).
4. Why? Hypothesis: exceptions have no owner; routine volume is what the process is built for.
5. **Root cause (hypothesis):** exception handling is not designed as a process with an owner and a shared order view.
Evidence quality: steps 1 sourced; 2-5 hypotheses.

### O-02 — buyers cannot plan
Symptom: builders lack oversight of arrival; cannot plan cranes and crews (S-017); wrong access point / nobody to receive (S-011).
1. Why? Buyers get no reliable status or window (S-017).
2. Why? Dispatch plans stay internal and are not shared as a commitment with a window and a receiver (S-011, vendor).
3. Why? Delivery-execution data and customer-facing channels are different systems (R-01, hypothesis).
4. Why? Delivery was designed as an internal logistics process, not as a customer-facing commitment (hypothesis).
5. **Root cause (hypothesis):** delivery execution data is not exposed to the buyer as a planned, confirmable event.
Evidence quality: low (UK/vendor); RK-02.

## 5. POV statement

> **Customers who order building materials for delivery — tradespeople whose crews and rented machines wait on the goods, and home improvers alike `[D-02]` — need a way to rely on what they are promised (the item is available, it arrives on a stated date) and to get fast, proactive help when it is not, because the promise is made at the order from stock, supplier and delivery data that nobody reconciles across stores and systems, so the failure is built in before the truck is loaded.**

Non-obvious insight: delivery failures are mostly *promise-time* failures, not last-mile failures. Evidence: P-01/P-02 are triangulated across review, forum and vendor sources (S-004, S-007, S-009, S-016, S-027); the causal chain is a research-supported hypothesis (D-09, D-10).

## 6. How-Might-We (ranked)
1. **HMW make the availability and delivery date a customer sees at ordering match what Company A can actually deliver?** — O-01
2. **HMW keep buyers informed, and let them act, before a delivery goes wrong so that nobody has to chase?** — O-02, O-04
3. **HMW resolve the cases that still go wrong fast, with one owner and one view of the order, in every country?** — O-03, O-04

## 7. Riskiest assumptions → `_decisions.md`
| ID | Assumption | Validation |
|---|---|---|
| D-10 | Company A's promise failures are mainly caused by stock/data/dispatch problems it controls (not mostly by supplier lead times or carriers) | Baseline: classify last 3 months of failed/late orders by cause in the pilot market |
| D-11 | Reliable availability and date outrank price in customer choice for delivered orders (evidence is UK merchants' survey, S-026) | Pilot: measure repeat orders and cancelled orders before/after |
| D-12 | Order, stock and delivery data in the pilot market can be read from existing systems by API or export within the pilot timeframe | Technical discovery in week 1; depends on D-03 |

## 8. Solution-led input check
Input is problem-led; no solution non-negotiable (R-07's mission structure aside) conflicts with the top opportunities. No blocking `D-##`.

## Deliverables checklist
- [x] Every O-ID lists P-IDs and scoring basis
- [x] Cost figures sourced or marked unquantifiable (+ D-07, D-10)
- [x] Exactly one POV; exactly three HMWs
- [x] No Lean UX problem statement
