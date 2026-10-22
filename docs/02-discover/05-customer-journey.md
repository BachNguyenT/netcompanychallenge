Step 05 · Lanes: Customer (PER-1/PER-2), Store & warehouse employee (PER-3, internal form) · Searches used: 0/4 (Awareness is thin; accepted as a flagged gap rather than spending budget on inferred behaviour)

# Step 05 — Customer Journey Mapping (as-is)

> As-is = how people solve "get building materials where and when I need them" and "run a store" **today**, with today's alternatives. No solutions or features appear in this file. Company A is an archetype; peers' customers stand in (R-17).

## 1. Journey overview
**Customer lane.** Customers decide where to buy mainly on availability, price and delivery date (S-007, S-017). The journey breaks *after* the order: the promise made at ordering ("in stock", "2-5 days") is not kept (stock wrong, dates slip), the customer cannot see where the order is, and when something goes wrong support is unreachable (S-004..S-009). Pros pay more for the same failures because crews and rented machines idle (S-017).
**Store & warehouse employee lane.** Staff run sales, ordering and claims, picking, receiving and stocking with chain routines and ERP (S-019). Stock records are known to drift (S-016). There is no first-hand staff evidence; this lane is `Evidence: thin` throughout.

## 2. Stage tables

### Lane A — Customer (PER-1 pro / PER-2 DIYer; differences annotated)
| Field | Awareness | Consideration | Decision | Retention | Advocacy |
|---|---|---|---|---|---|
| Trigger / entry | Project starts; urgent shortage on site (pro) (S-017) | Needs availability and a delivery date | Ready to order | Delivery day arrives, or does not | After a failure or after a good delivery |
| Goal | Know materials will be available | Pick a merchant/chain | Order with certainty | Receive right goods on the right day, fix issues | Warn or recommend |
| Actions | Pop out for supplies (pro) (S-017) | Compare chains; check "in stock" (S-007) | Order by webshop/phone/counter | Wait, chase, receive, inspect, claim | Post public reviews (S-004..S-008) |
| Touchpoints | Store, phone, merchant app (UK, S-017) | Webshop, store | Webshop, counter, trade account | Carrier, tracking number, support chat/email | Trustpilot, forums (Byggahus) |
| Thoughts (verbatim) | — | "Item listed as in stock with 2-5 day delivery" then not in stock (S-007, para.) | "Ordered 27/2, heard nothing" (S-007) | "Three weeks and counting" (S-004) | "Company has not replied" (S-004/S-007 platform note) |
| Emotion | −1 *friction* | −1 *uncertain* | 0 *hopeful* (E4 +1 where it works) | −2 *angry* | −1 *resigned* |
| Pain points | — | P-01 | P-01, P-03 | P-02, P-03, P-04, P-05, P-06 | P-08 |
| Current workaround | Store run | Call the branch; choose another chain (S-007) | Phone to confirm | Phone driver/branch; ask supplier to collect (S-009); hire cranes without certainty (S-017) | Public review |
| Drop-off reasons | — | Out of stock; price gap between markets (E15) | Unclear window, unreachable support | "Future orders might go elsewhere" (S-009) | Silence from company |
| Moment of truth | Whether the merchant can supply fast enough | Whether "available" is believable | Order confirmation clarity | **Delivery day: right goods, undamaged, on time** | Whether a problem got resolved |
| Evidence | S-017 | S-007, S-017 | S-007, S-017 | S-004..S-011 | S-004..S-007 |
| Evidence strength | **thin** (1 item) | ok | ok | ok | ok |

Pro vs DIY: pros add site constraints (access, receiver, unloading, machine hire timing) (S-011, S-017) and trade accounts; DIYers add home delivery and webshop self-service (S-007). Evidence for pros is UK/vendor-based; flagged RK-02.

### Lane B — Store & warehouse employee (PER-3). Internal-tool form: **Mandate / Rollout** replaces Awareness + Consideration
| Field | Mandate / Rollout | Decision (first real use) | Retention (daily core use) | Advocacy |
|---|---|---|---|---|
| Trigger | Board invests in one solution (S-001); statutory consultation in NO/SE (S-012, S-013) | New tool or process arrives in store | Daily routines | not evidenced |
| Goal | Understand what changes and why | Do the job without extra effort | Efficient sales, picking, receiving, stocking | — |
| Actions | Consultation with representatives (NO, SE); information to staff (S-012) | Learn tool | Sales and advice, ordering and claims, picking/packing, goods receipt, stocking (S-019) | — |
| Touchpoints | Employee reps, store manager | Handheld / ERP | ERP and chain routines (S-019) | — |
| Thoughts | **No evidence** | **No evidence** | **No evidence** | **No evidence** |
| Emotion | not evidenced | not evidenced | not evidenced | not evidenced |
| Pain points | — | — | P-07 | — |
| Workaround | — | — | Manual counts (S-016 context); no employee-level workaround evidenced | — |
| Moment of truth | Whether staff believe the change is justified, not surveillance (S-012, S-014) | First shift with the tool | Peak delivery/pick times | — |
| Evidence | S-001, S-012, S-013 | — | S-016, S-019 | — |
| Evidence strength | ok (regulation) | **thin** | **thin** | **thin** |

Thin cells are logged as RK-03 (`_decisions.md`), not filled by inference. The one "workaround" cell that says "not evidenced" must be tested with store staff in Define or by user-supplied input.

## 3. Emotion curve
```
Customer lane
+2 |
+1 |               (praise cases: E4, E12, E13)
 0 |          ●
-1 |   ●  ●                              ●
-2 |                   ●
     AWR   CON   DEC   RET   ADV
```
Plotted points: AWR −1, CON −1, DEC 0, RET −2, ADV −1. The employee lane is not plotted: no emotion evidence.

## 4. Stage × Pain Registry
Severity/frequency are H/M/L judgments from the evidence cited. H/H items carry ≥ 2 source types; the top pains carry 3.

| ID | Pain | Stage | Lane | Segment | Severity | Freq. | Current workaround | Evidence (S-IDs) |
|---|---|---|---|---|---|---|---|---|
| P-01 | Availability promise broken: shown/stated "in stock" but unavailable or missing at delivery | CON, DEC | A | SEG-1/2 | H | H | Call, reorder elsewhere | S-007, S-009 (E7), S-016 (stock-record inaccuracy as a cause) |
| P-02 | Delivery date or window slips or is unclear | DEC, RET | A | SEG-1/2 | H | H | Phone the branch/driver | S-004, S-007, S-008, S-010, S-017 |
| P-03 | No visibility of order or delivery status; trade cannot plan cranes, crews or machine hire | DEC, RET | A | SEG-1 (H), SEG-2 (M) | H (pro) / M | M-H | Phone; over-hire equipment | S-007, S-011, S-017 |
| P-04 | Wrong, damaged or missing goods on delivery | RET | A | SEG-1/2 | H | H | Claim; ask supplier to collect | S-006, S-009, S-010 |
| P-05 | Support unreachable and claims unresolved | RET, ADV | A | SEG-2 (SEG-1 not evidenced) | H | H | Repeat email/chat; public review | S-004, S-005, S-006, S-007, S-009 |
| P-06 | Site-receiving fails: nobody to receive, wrong access point, no unloading equipment | DEC, RET | A | SEG-1 | H | L-M | Phone driver | S-011 only → `Evidence: thin` |
| P-07 | Store stock records drift; routines are manual and chain/ERP-specific | RET | B | SEG-3 | M | M | Manual counts | S-016, S-019 → `Evidence: thin` (no staff voice, no Nordic data) |
| P-08 | No reply to public complaints | ADV | A | SEG-2 | M | H | — | S-004, S-007 (platform notes) |

**Unvalidated candidate (not a P-ID):** U-01 "manual processes" (brief R-02, Denmark). The sector evidence does not say which processes are manual or how much they cost; see D-08.
Out of scope pains logged for completeness: price perception and cross-border price gaps (E15, E27).

## 5. Moments of truth
- Customer lane: **delivery day** — right goods, undamaged, on the promised date; and **first contact after a failure** — can the customer reach someone who resolves it.
- Employee lane: first shift with a new tool/process, and whether the change is perceived as justified rather than monitoring (S-012).

## 6. Journey bottleneck
**Bottleneck: the span between order confirmation (Decision) and delivery receipt (Retention) — the promise gap.** Pains P-01 to P-06 all sit here: 6 of 8 registered pains, all rated H severity (P-03 H for pros), including the 3-source-type pains P-01, P-02, P-04 (S-004..S-011). It is also where peers' public reputations are damaged (Byggmax 2.0/5, Beijer 2.8/5: S-004, S-007).
**Cross-lane deadlock (hypothesis, flagged).** The customer lane's promise depends on accurate store/warehouse stock and supplier lead times (lane B, STK-8), while staff carry the effort and statutory limits constrain how their work can be measured (S-012, S-013, S-016). Pain is felt by customers; the cause largely sits with employees and suppliers; the sponsor (board) sees neither directly. This is consistent with the brief's remark that "the challenges are interconnected" (S-001), but the Nordic causal link is **not** proven by our evidence — it is a research-supported hypothesis to confirm with Company A data (D-03, D-09).

## Deliverables checklist
- [x] All five stages for lane A; internal-tool collapse stated for lane B
- [x] Every cell evidenced or marked thin (RK-02, RK-03)
- [x] Every P-ID has stage, lane, severity, frequency, workaround and S-IDs
- [x] Bottleneck named with evidence; cross-lane deadlock flagged as hypothesis
- [x] No solutions or features in this file
