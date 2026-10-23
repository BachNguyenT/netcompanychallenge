# Discover Findings & Directions — Company A (netcompany)

*Steps 00-05 complete · 2026-10-16 · Stops before Step 06. The directions below are inputs to Define (Step 06 owns the numbered opportunities `O-##`; Step 07 the solution). Nothing here is a chosen solution.*

## 1. What the stated problem really is
The brief lists four challenges. The evidence (peer proxies, R-17) points to **one failure chain**, not four problems:

> Company A (like its peers) **makes promises it cannot reliably keep** — "in stock", "arrives on date X" — because stock records, order handling and delivery run on country-specific systems and manual routines. Customers experience this as delivery and fulfilment failure; staff experience it as extra work; the board sees the symptoms as inconsistent operations.

Evidence: 6 of 8 registered pains sit in one span of the customer journey, between order confirmation and delivery receipt (P-01..P-06, `05-customer-journey.md` §6). Three of them (availability promise, delivery date, wrong/damaged goods) are triangulated by three source types. Peers' public ratings reflect it: Byggmax 2.0/5 (4,468 reviews), Beijer 2.8/5, Obs Bygg 2/5 (S-004, S-007, S-008).

**Fragmented systems** is confirmed as a root cause / constraint (R-03), not a candidate. It sets how any solution is integrated and rolled out.

## 2. What we could and could not verify
| Brief statement | Finding | Strength |
|---|---|---|
| Sweden: delivery & fulfilment may matter most | Consistent: delivery/stock/communication complaints dominate Swedish peer reviews; STARK is investing in a Swedish automated DC (S-007, S-004, S-020) | Moderate (consumer-skewed reviews) |
| Norway: store operations may matter most | **Not testable.** No Norwegian staff or store-ops evidence; reviews are about service and product issues. Norway has the strictest worker-consultation duty for tools that control staff (WEA ch. 9, S-012) | Weak / none |
| Denmark: manual processes may matter most | **Not testable.** No evidence on which processes are manual (D-08) | None |
| Pain and urgency differ by market | Plausible, but desk research cannot separate country-internal operations; needs Company A data (D-01) | n/a |

## 3. Directions to choose from
Evidence strength refers to the *problem*, not the solution. 3-month pilot fit refers to R-15. AI role follows R-20 (supporting only where it beats rules).

| | A. Delivery & order-promise reliability | B. Store operations execution | C. Manual-process automation | D. Root-cause-first (stock accuracy → promise) |
|---|---|---|---|---|
| What it fixes | Customer-visible promise gap: availability check, date/window, tracking, exception handling, claims intake | Store routines and stock accuracy via task/count tooling | Back-office manual work | Same chain as A, starting from accurate stock at receipt/pick |
| Who feels it | Customers (pro and DIY), dispatch, support | Store/warehouse staff, managers | Back-office staff | Staff, then customers |
| Lead market (brief hint) | Sweden | Norway | Denmark | Any |
| Problem evidence | **Strong** (P-01..P-06; 3 source types on top pains) | Thin (P-07; no staff voice) | **None** (U-01, D-08) | Moderate (hypothesis D-09) |
| Measurable impact | Strong: on-time-in-full, "where is my order" contacts, claims, repeat orders | Indirect: staff time, count accuracy | Hours saved (unquantified) | Both |
| 3-month pilot fit | Good: overlay on existing systems, one market | Good technically; heavy consultation in NO/SE | Unknown (process unspecified) | Weaker: touches stores and systems; scope risk against "one problem" |
| Legal/change friction | Lower; driver GPS needs DPIA (S-014) | **Highest** (S-012, S-013, S-014) | Medium | Medium-high |
| AI fit | Delivery-date prediction, exception triage | Count prioritisation, anomaly detection | Order/document intake (strongest AI fit) | Both |
| Main risk | Peer evidence ≠ Company A; depends on stock data quality | Staff acceptance; unproven benefit | Cannot be defined | Scope creep |

**Not a direction:** replacing core systems (ERP/POS). Allowed by R-22 but conflicts with the ~3-month pilot (RK-01); better kept as a later-release option.

## 4. Recommendation (to be confirmed at Gate A)
**Direction A, framed as closing the promise gap**, with stock accuracy as an enabling component rather than a separate programme. Reasons: strongest triangulated evidence; the only direction whose outcomes are customer-visible and measurable; least employee-control friction; fits a one-market, 3-month overlay; clear, bounded AI role.
**What would change this:** Company A data showing that its Danish manual processes (C) or Norwegian store execution (B) cost more than delivery failures; or evidence that the stock-accuracy root cause (D) is the binding constraint.

## 5. Decisions needed from you (details in `_decisions.md`)
| ID | Question | Recommended |
|---|---|---|
| D-02 | Beachhead customer: pros (PER-1) or DIY (PER-2)? Matrix is a tie (19 vs 20) | Confirm which the board prioritises commercially; design for pros as first-class extension |
| D-01 / D-04 | Treat the brief's market hints as hypotheses; pick the pilot market | Sweden for A, subject to your data |
| D-08 | Which Danish manual processes? | You name them, or direction C stays unspecified |
| D-07 | How to size value without Company A data | Peer-benchmark ranges, labelled assumptions |
| D-09 | Accept the stock-accuracy → promise link as a hypothesis to measure in the pilot | Yes |
| D-05 | Presentation date | Needed to size remaining work |
| RK-02 / RK-03 | Thin evidence on pros and staff | Interviews (kit on request) or accept the risk |

## 6. Evidence limitations
All sources are public peer data and vendor material, not Company A. Review sites skew negative and consumer. Several sources were search-result summaries rather than pages read in full (marked in `_sources.md`). No Nordic figure was found for failed-delivery rate, cost per failure or manual work hours; therefore no financial claim is made.

---
# Update 2026-10-23 — user research incorporated; the user's decision supersedes my earlier recommendation

The user supplied their own gap analysis (S-037, `01-intake/user-research-gap-analysis.md`). It ranks ten gaps and selects **G1, unstructured B2B order intake** (4.0 of 5), narrowly ahead of **G2, delivery promise and exceptions** (3.9), with Denmark as the pilot market. This is the user's decision (R-23 to R-27) and replaces my earlier recommendation (Direction A, delivery promise hub). Where the two analyses meet:

- **Agrees:** fragmented systems are a root cause, not a candidate; overlay beats ERP replacement (Lidl, Travis Perkins); delivery visibility is a credible follow-on (the user keeps a delivery-promise check inside scope).
- **Differs:** my Discover found strong evidence for delivery pain and **no** evidence for manual processes (D-08). S-037 supplies that evidence (job ads at the merchants it names (Beijer, Bygma, Optimera; S-037 itself counts four), Solar/DI digital shares, public order mailboxes, a vendor launch), but states that the size at Company A is unmeasured. Both analyses agree that no source gives share of unstructured orders, minutes per order or error rates.
- **Sensitivity:** G1 stays first under three of four weightings; G2 overtakes when Impact is weighted 40% and Ease 15% (S-037 §3). The decision therefore rests on speed and fit with the 10-12 week constraint, which is consistent with the brief.
- **What would overturn it** (S-037 §4.2): more than 80% of B2B lines already arriving structurally, under 3 minutes per unstructured order, or order-desk work under 0.2 FTE per store.

Open and carried forward: D-12 / D-23 (ERP write access), D-17 (AI wording), D-18 (Netcompany components), D-19 (LLM provider and data), D-24 / D-25 (size and accuracy assumptions), RK-05 to RK-08.

Archived: the Define files for the delivery concept are in `03-define/_superseded-2026-10-21/` (kept for the record; not a source for the PRD).
