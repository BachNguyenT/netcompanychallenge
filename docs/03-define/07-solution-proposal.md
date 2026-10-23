Step 07 · Searches used: 5/6 · Sources: S-029, S-037, S-038, S-039, S-043, S-046, S-047, S-049, S-052..S-056

# Step 07 — Solution Proposal (includes problem-solution fit)

## 1. Depth and reason
**depth: full.** The user's concept (R-28) is part of the input, which would allow an abbreviated pass. Counter-evidence forces full depth instead: (a) no independent building-materials results exist for AI order entry (S-046), (b) my earlier Discover evaluated a different opportunity as strongest (archived), and (c) vendor material warns that automated order entry often degrades to assisted manual entry (S-053). The user's concept is therefore compared with two genuinely different mechanisms.

## 2. Concepts

| Field | Concept 1 — Order Intake Assistant (user's concept) | Concept 2 — Structured self-service channel | Concept 3 — Template-based capture + RPA |
|---|---|---|---|
| Mechanism | Reads the order mailbox (email, PDF, Excel), uses an LLM to extract the order and semantic matching to map trade shorthand to SKUs, applies contract price and checks stock/credit by rules, proposes a delivery date, and presents a draft for one-click human approval before writing to the ERP | Moves the long tail of trade customers to a quick-order form / portal / lightweight EDI so orders arrive structured | Builds per-customer extraction templates for the top customers' PDFs/Excel and keys the data by RPA |
| Opportunities addressed | O-01, O-03, O-04, part of O-02 | O-01 (only for customers who move) | O-01 for the top customers |
| Journey stages changed | DEC (receive → confirm), RET (exceptions, measures) | CON, DEC | DEC |
| Stakeholder tensions | Keeps the customer relationship channel; no monitoring of individual handlers (R-26) | Needs customer behaviour change (STK-2); channel conflict with relationship selling | Needs maintenance whenever customers change layouts |
| Hypothesis | If handlers approve AI-prepared drafts instead of keying, handling time per order and line errors fall, measured by approval-without-edit share, handling time, line error rate, time to confirmation | If customers get a trusted self-service route, a meaningful share of order lines move off email | If templates exist for the top customers, keying disappears for them |
| Analogous successes | Esker/Siemens Healthineers: automated-order rate 8% → 85%, 93% of fields captured (S-052, vendor, not building materials). Toolbx: GA 1 Sep 2026, building supply, draft orders reviewed before ERP (S-046, no results) | Solar: 65% of order lines digital (S-038); Ahlsell Norway >50% digital trade (S-050): digital works for many customers | none building-specific found |
| Analogous failures | "Automation illusion": teams still validate nearly every order; SKU mismatches surface after shipment (S-053). Prompt-injection risk for email agents (S-055) | Portal uptake low: Byggmakker ~1.5% of revenue (2016), Maxbo Proff revenue below user numbers (S-047); buyers keep emailing their rep (S-056) | Template OCR breaks when layouts change; teams stop trusting output (S-053) |
| Feasibility — technical | ⚠️ ERP write-back (API, RPA fallback) unknown (D-23); LLM accuracy unproven (D-25); doable as an overlay in the pilot office | ✅ standard e-commerce; ⚠️ needs trusted price/stock data | ⚠️ brittle, high maintenance |
| Feasibility — economic | ⚠️ unsized (R-31 illustrative); LLM usage cost to be modelled (D-19) | ⚠️ build cost plus adoption campaigns | ✅ cheap to start, costly to maintain |
| Feasibility — regulatory | ⚠️ GDPR on message contents; processor terms for the LLM (D-19); AI Act classification to check (Step 11) | ✅ | ✅ |
| Feasibility — organisational | ⚠️ handler adoption; order-office lead owns exceptions (D-22) | ⚠️ sales staff vs portal | ⚠️ IT maintenance owner |
| Effort / time to deployable first release | M (fits 12 weeks with a pilot office) | L (adoption takes months) | M |
| Key assumptions | D-24, D-25, D-12/D-23 | Customers adopt the form | Layouts stay stable |

## 3. Fit evidence and failure modes
- **Works elsewhere (weak evidence):** vendor cases in other industries (S-052) and a first building-supply launch with no results (S-046). Peers in the Nordics show the long tail exists (S-038, S-039, S-043, S-044).
- **Fails when:** extraction is treated as the hard part. SKU resolution and incomplete orders are the hard part (S-053); portals alone do not move small customers (S-047, S-056); ERP replacement derails service (S-029).
- **Failure modes to watch for Concept 1:** exceptions pile up and handlers stop trusting drafts; wrong SKU accepted by a hurried approver; duplicate or partial ERP writes; prompt-injection or malicious attachments in customer mail (S-055); GDPR exposure from sending message contents to an LLM (D-19); customer-specific item names not learned.
- **Failure case search:** one, plus the portal evidence; no public failure of AI/OCR order entry in building materials was found (S-037 §4.2).

## 4. Decision matrix
Weights derived from the judging rubric (R-12) and the time-to-market constraint (R-15, R-30): opportunity coverage 30 (Problem Understanding, Prioritisation), business impact and innovation 25, feasibility 25, time to deployable first release 15, risk 5. Scores 1-5, each a judgment.

| Criterion | Weight | C1 Assistant | C2 Self-service | C3 Templates + RPA |
|---|---|---|---|---|
| Opportunity coverage | 30% | 5 — O-01, O-03, O-04 and part of O-02 | 2 — only customers who change | 3 — top customers only |
| Business impact & innovation | 25% | 4 — measurable handling time, keeps the channel; unproven | 3 — scale if adopted | 2 — incremental |
| Feasibility | 25% | 3 — ERP write and accuracy unknown | 4 — mature tech | 4 — mature tech, brittle |
| Time to deployable first release | 15% | 3 — tight for 12 weeks | 3 — slow adoption | 4 |
| Risk (inverse) | 5% | 3 | 2 | 3 |
| **Weighted score** | 100% | **3.85** | **2.90** | **3.15** |

Arithmetic: C1 = 1.50 + 1.00 + 0.75 + 0.45 + 0.15 = 3.85; C2 = 0.60 + 0.75 + 1.00 + 0.45 + 0.10 = 2.90; C3 = 0.90 + 0.50 + 1.00 + 0.60 + 0.15 = 3.15. Sensitivity: C3 overtakes C1 only if feasibility and time are weighted above about 55% combined.

## 5. Go / Pivot / Stop
**Decision: Go with Concept 1, gated by the baseline.** **Confidence: Medium.** The problem is evidenced to exist but unsized (RK-05), and the technology has no independent building-materials results (RK-06). Mitigations are built into the plan the user set: weeks 1-2 baseline, weeks 3-8 shadow mode, 100% human review, week-12 go/no-go (R-27). No Pivot/Stop, so no blocking `D-##`.

## 6. Chosen concept — Order Intake Assistant (working name)

### How it works
The assistant sits between Company A's order mailboxes and its ERP. A message arrives; the system classifies it (order, quote request, status request, complaint), extracts customer, site, lines, quantities, units and delivery wishes, maps each line to a SKU using the catalogue and the customer's purchase history, applies the contract price and checks stock and credit by reading the ERP (rules, not AI), proposes a delivery date with a confidence level, and presents a draft next to the original message. The order handler approves or corrects it in one click; lines below the confidence threshold go to an exception queue. On approval the draft order is written to the ERP (API, with RPA as fallback) and a confirmation goes to the customer in their language. Every correction is stored as evaluation data, and a dashboard shows the baseline measures. In weeks 3-8 the same pipeline runs in shadow mode: it prepares drafts for comparison, and nothing is written. The ERP stays; customers keep emailing. One core, with market adapters for Norway and Sweden later (R-24, R-26).

### Required capabilities (complete list for production)
Order handling (users: order handlers)
1. Mailbox connector: ingest email, PDF and Excel from configured order mailboxes; de-duplication, threading, attachment handling, non-order filtering
2. Message classification and routing: order, quote request, status request, complaint, other
3. Extraction of customer, site, lines, quantities, units, delivery wishes, each with confidence
4. SKU matching on catalogue and purchase history (top ~2,000 SKUs first), unit normalisation, alternatives
5. Price and check (read-only): contract/project price, stock and credit from the ERP
6. Delivery-date proposal with a confidence level (rule-based; ML ETA later)
7. Review workspace: message and draft side by side; one-click approve; edit lines; reject, forward, reassign; exception queue by confidence
8. Draft-order write-back to the ERP via API with RPA fallback; idempotency, retry, error queue, status sync
9. Customer confirmation in the customer's language after approval; templates; reply tracking
10. Status-request answers from ERP data, sent after approval
11. Correction capture as evaluation data; offline evaluation harness; model/prompt version metrics
12. Read-only list of exceptions after the order (missing site data, stock shortfall)
Operations and measurement
13. Order-office lead view: queue monitor, assignment, service timers; aggregate only, no per-employee ranking (R-26)
14. Measurement dashboard: channel mix, handling time per order, share approved without edits, line error rate, time to confirmation; baseline mode for weeks 1-2 (R-27)
15. Shadow-mode comparison: AI draft vs the human-entered order, no ERP write
16. Admin configuration: mailboxes, SKU scope, confidence thresholds, templates, languages, feature flags per market, model/prompt versions
17. Master-data sync (catalogue, units, customer purchase history) and a customer-specific alias dictionary managed by handlers
18. Pilot-market adapters for ERP and mail; adapters for other markets later
Platform and legal
19. Staff identity and access: SSO, roles (order handler, order-office lead, administrator, analyst), scoped to office/market
20. Privacy: DPIA artefacts, message retention and deletion, minimisation/redaction before LLM calls, data-subject requests for customer contacts, full audit log of approvals and ERP writes
21. LLM gateway: provider abstraction, prompt versioning, injection guardrails (instructions separated from data, least privilege, human approval), cost metering, EU region (D-19)
22. Staff notifications (queue alerts) and preferences
23. Localisation (Danish UI, English; D-20), help, status/maintenance pages, degraded mode (when AI is down, messages pass through unprocessed to the queue)
24. Observability: mailbox, ERP and model health, alerts
25. Accessibility conformance for the review workspace

### USPs (each traced)
1. **Keeps the customer's channel and removes the re-keying** — portals see low uptake (S-047, S-056; O-01).
2. **Human in control with confidence routing and a learning loop** — avoids the "automation illusion" (S-053; O-03).
3. **Trade-aware SKU resolution from purchase history** — SKU resolution, not OCR, is the hard part (S-053; O-01).
4. **Overlay on the existing ERP, one core, market adapters** — no replacement (R-26, R-30, S-029).

### Stated limitations and preconditions
- The size of the problem at Company A is unmeasured (RK-05); accuracy is unproven (RK-06); go/no-go follows the baseline.
- Needs read access (pricing, stock, credit) and draft-order write access to the Danish ERP (D-23).
- Mailbox only in the MVP; phone/voicemail, photos and EDI changes later.
- Does not automate project quotes, forecasting or delivery orchestration; does not replace ERP; does not monitor individual employees (R-26).

### Top-3 assumptions → `_decisions.md`
D-24 (size), D-25 (accuracy), D-12/D-23 (ERP write access).

## Deliverables checklist
- [x] Every concept maps to O-IDs and stages
- [x] Fit evidence includes failure cases (S-053, S-047, S-029)
- [x] Feasibility covers all four dimensions
- [x] USPs trace to a gap or O-ID; limitations stated
- [x] Required-capabilities list covers the whole solution (operational, back-office, legal), not a demo slice
- [x] No per-option RICE scores
