Step 06 · Searches used: 4/4 (all spent verifying S-037's key figures: S-038, S-039, S-046, Eurostat) · Sources: S-037..S-051 (S-038, S-039, S-046 re-checked), S-029

# Step 06 — Problem Statement (re-run on the user's selected problem)

> The user selected G1, unstructured B2B order intake, with a delivery-promise check (R-23). This file re-runs Step 06 on that basis. The earlier delivery-concept version is archived in `_superseded-2026-10-21/`. Scores are judgments from the cited evidence, not measurements.

## 1. Opportunity matrix
Importance = severity × frequency judged from the evidence (1-10). Satisfaction = how well current alternatives meet the need (1-10). Opportunity = Importance + max(Importance − Satisfaction, 0).

| O-ID | Opportunity (need not met) | P-IDs | Stage | Lane / segment | Importance (basis) | Satisfaction (basis) | Score | Rank |
|---|---|---|---|---|---|---|---|---|
| O-02 | The trade customer gets a fast, correct order confirmation: right items, right price, a believable delivery date | P-11, P-01, P-02 | DEC | A / SEG-1 | 8 (P-01/P-02 are H/H with 3 source types; P-11 thin) | 3 (peers' Trustpilot 2.0-3.3/5; S-004, S-005, S-007) | **13** | 1 |
| O-01 | The order handler turns an unstructured message (email, PDF, Excel, photo, list) into a correct, priced draft with little re-keying | P-09, P-10 | DEC | C / SEG-3a, SEG-1 | 7 (existence strong: 4+ source types; severity M-H and size unmeasured, so not higher) | 4 (EDI covers large repeat buyers; portals have low uptake; manual status quo; AI unproven: S-039, S-047, S-046) | **10** | 2= |
| O-03 | Problems in an order (unmatched SKU, price mismatch, stock shortfall, missing site data) are caught before it is committed, not after delivery | P-01, P-04, P-06, P-10 | DEC, RET | C, A | 7 (P-04 H/H; the upstream cause is unverified) | 4 (no systematic check evidenced) | **10** | 2= |
| O-04 | Company A can see how orders arrive and how long they take, to decide where to automate | (gap: S-037 "not found") | DEC | C / management | 6 (decision enabler; no pain registered) | 2 (no baseline exists in the evidence) | **10** | 2= |

**How this relates to the user's choice.** On evidence alone the matrix ranks O-02 (delivery-related) first, as my earlier Discover did. R-23 selects order intake as the entry point because the user's criteria add ease (an overlay pilot in 10-12 weeks) and fit with Netcompany (S-037 §3), which this matrix does not score. O-02 is still served inside the same flow through the delivery-promise check, and O-03 through the review and exception queue. The solution therefore covers all four opportunities, in order-intake sequence.

## 2. Target stages for the product
| Stage | Why |
|---|---|
| Decision | Receive → understand → match → price → promise → review → write → confirm happens here; the bottleneck of the B2B order path (05 update §U4); O-01, O-02, O-03 |
| Retention | Basic after-the-order exception list and measurement (O-03, O-04); proactive delivery tracking is parked (G2 follow-up) |
| Awareness, Consideration | Not targeted: existing B2B customers already use the order mailbox; reason: the product changes how the merchant handles the message, not how customers find it |
| Advocacy | Not targeted; improves indirectly through faster, more accurate confirmations |

## 3. Cost of the problem
No Company A figure exists (R-06; S-037: share of unstructured orders, minutes per order and error rate "not found"). The only sizing is the user's labelled illustrative model (R-31, S-037 §4.2):

| Input | Value | Status |
|---|---|---|
| Stores | 300 | assumption |
| Unstructured orders per store per day | 20 | assumption |
| Minutes per order | 12 | assumption |
| Loaded labour cost | EUR 46.5/h | derived from Eurostat sector figures, **not verified here** (S-041) |
| Result | 300 × 20 × 12 min = 1,200 h/day; ≈ EUR 55,800/day; ≈ **EUR 14m/year** at ~250 working days; range EUR 1.9m-33.1m as stated in S-037 | assumption, not data |

Per handler persona (illustrative): 20 orders × 12 min ≈ 4 hours per store per day on this task, if the assumptions hold. Market-level aggregate: not quantifiable. All of this is replaced by the weeks 1-2 baseline (R-27). Error cost (wrong item, quantity, price) is not quantifiable from available evidence; the baseline codes credit notes to estimate it.

## 4. Root causes (top opportunities)

### O-02 — slow, uncertain confirmation
Symptom: customers wait for confirmations, ask for quotes, and delivery dates are unreliable (E36, E37, P-01, P-02).
1. Why? The confirmation waits for a handler to read the message and check stock and delivery manually (S-037 G1/G2).
2. Why? Stock, price and delivery data sit in separate country systems (R-01, R-03).
3. Why? No single promise computation across stock, supplier lead time and delivery capacity (S-027 as an explainer, Low).
4. Why? Each country built its own systems for local needs (R-01).
5. **Root cause (hypothesis):** the confirmation is handmade from fragments. Addressed in scope only as a rule-based date with a confidence level (R-28); deeper delivery orchestration is parked.

### O-01 — free-form orders must be interpreted by people
Symptom: handlers re-key orders from emails, PDFs, photos (E28-E33, E38).
1. Why? Customers send orders in formats the ERP cannot read (35% of Solar's order lines are non-digital, S-038; Danish firms' online revenue is 25 pts EDI and 8 pts web, S-039).
2. Why? Small customers do not justify EDI, and portals see low uptake (S-047); customers choose merchants on service, convenience and advice (S-040).
3. Why? Trade orders need interpretation: shorthand ("45x95 C24 4.8m"), contract prices, project context (S-037, inference).
4. Why? Interpretation lives in staff knowledge; the ERP stores structured data only (S-043 job ads; inference).
5. **Root cause (hypothesis):** interpreting free-form trade orders has been human work because no tool could read them reliably until 2026 (AI order entry became generally available on 1 Sep 2026, S-046), and its cost is hidden inside general sales roles (S-037 §4.1).
Implication: do not push customers to portals; keep their channel and automate the interpretation, with a person approving.

### O-03 — errors found late
Symptom: wrong item, quantity or price surfaces as credit notes or complaints (P-04; S-037 plan codes credit notes).
1. Why? Errors enter at keying or interpretation. 2. Why? Handlers work quickly through a queue. 3. Why? There is no confidence signal on ambiguous lines. 4. Why? No exception routing exists in the ERP. 5. **Root cause (hypothesis):** there is no learning loop or confidence-based check between the message and the ERP.
Evidence quality: steps 1-5 are hypotheses to be tested by the baseline (D-24).

## 5. POV statement

> **Order handlers in Danish builders' merchants, who turn emails, PDFs, photos and lists from trade customers into ERP orders by hand, need a way to get a correct, priced draft order they can approve in one click, because the long tail of trade orders will not move to EDI or portals (customers choose on service and convenience), so the interpretation work stays with people and its cost stays invisible.**

Non-obvious insight: the answer to unstructured orders is not to make customers structure them (EDI covers large repeat buyers; portals see low uptake) but to keep their channel and automate the interpretation, with a person in control. Evidence: S-038, S-039, S-040, S-043, S-046, S-047. Size at Company A is a hypothesis (D-24, RK-05).

## 6. How-Might-We (ranked)
1. **HMW read the orders customers already send, and prepare a correct, priced draft, without asking customers to change how they order?** — O-01
2. **HMW let a person approve or correct a draft quickly and safely, so that mistakes are caught before the order reaches the ERP?** — O-03, O-01
3. **HMW give the customer a fast confirmation with a believable delivery date, and give the business a measured baseline of how orders arrive?** — O-02, O-04

## 7. Riskiest assumptions → `_decisions.md`
| ID | Assumption | Validation |
|---|---|---|
| D-24 | A meaningful share of B2B order lines arrives unstructured and takes minutes each | Weeks 1-2 baseline (R-27); S-037 §4.2 lists what would undermine it |
| D-25 | AI extraction plus matching is accurate enough that most drafts are approved without edits | Shadow mode, weeks 3-8; threshold set after baseline |
| D-12 / D-23 | Draft-order write-back to the Danish pilot ERP is feasible within 12 weeks | Week-1 spike |
| RK-08 | Mis-extraction or injected text in customer messages could cause wrong orders | Human approval; red-team test set |

## 8. Solution-led input check
The input is mixed: the problem is selected and the scope is given (R-23, R-25, R-28). The user's concept addresses O-01, O-03 and, through the promise check, O-02; the evidence-ranked first opportunity (O-02) is only partly covered (rule-based date, no delivery orchestration). This is recorded, not blocking: the user made the choice with the weights in S-037 §3, and O-02 follow-ups sit in the Parking Lot (Step 08).

## Deliverables checklist
- [x] Every O-ID lists P-IDs and scoring basis
- [x] Cost figures sourced, or marked as labelled assumptions / unquantifiable
- [x] Exactly one POV; exactly three HMWs
- [x] No Lean UX problem statement
