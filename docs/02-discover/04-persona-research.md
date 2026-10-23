Step 04 · Searches used: 2/4

# Step 04 — Persona Research

> Personas are built only from attributes the evidence supports; unsupported attributes are omitted, not invented. Company A is an archetype (G-01).

## 1. Segment Attractiveness Matrix & Beachhead

Candidate segments (SEG-#) from the Step 03 evidence log. Weights are equal (no `R-##` implies other weights). Scores 1-5; **scores are my judgment from the cited evidence, not measurements**.

| Criterion | SEG-1 Pros: small/mid contractors & tradespeople | SEG-2 DIY / consumer customers | SEG-3 Store & warehouse employees (internal users) |
|---|---|---|---|
| Urgency (severity × frequency) | 4 — idle machine hire and schedule risk (S-017, S-011) but thin Nordic evidence | 4 — high frequency across 5 chains (S-004..S-008), lower stakes per incident | 3 — pain inferred from studies/job ads, no staff voice (S-016, S-019) |
| Value / ability to pay | 4 — chains prioritise SME professionals (S-023); order values not evidenced | 3 — price-led, price complaints (S-007, S-004) | 3 — internal productivity only, not quantified |
| Reachability | 4 — account relationships, apps in use by peers (S-017, S-024 digital uptake) | 5 — webshop already exists at peers (S-007) | 5 — employer mandate |
| Ease of implementation | 3 — site conditions (S-011) | 4 — customer-facing notifications and tracking need fewer behaviour changes | 3 — works-council / union consultation in NO and SE (S-012, S-013), GDPR (S-014) |
| Scalability across DK/NO/SE | 4 | 4 | 3 — country labour rules differ |
| **Total (of 25)** | **19** | **20** | **17** |
| Phase | Beachhead candidate (tie) | Beachhead candidate (tie) | Internal user group — served by whichever opportunity is chosen |

**Reading.** The matrix puts SEG-2 one point ahead of SEG-1, which is inside the noise of subjective 1-5 scoring. The two differ in evidence and in business logic:
- **For SEG-2 (DIY/consumer):** the evidence is richest (thousands of reviews) and the fix is cheapest to pilot.
- **For SEG-1 (pros):** Nordic merchants such as Beijer focus on SME professionals (S-023), and the delivery pain has the sharpest consequences (idle cranes and crews, S-017), but we found almost no first-hand Nordic pro voice.
SEG-3 are users of any solution, not an external beachhead. SEG-4 (dispatch / drivers) and larger project-account contractors are **not scored: no evidence** (gap logged).

**Beachhead status: provisional.** Per R-04 / D-02 the choice is made at Gate A, not here. Recommended: confirm with the user which of SEG-1 / SEG-2 the board cares about commercially; if the user cannot say, run Define on SEG-2 for the evidence base and design the solution so the pro variant (site delivery, accounts) is a first-class extension (flag as `D-02`).

**Phase-2 segments:** whichever of SEG-1/SEG-2 is not chosen; larger construction-firm project accounts (no evidence yet).

## 2. Personas

### PER-1 — "Site-running tradesperson" (`SEG-1`) — co-candidate primary
**Role / context:** small-firm builder, carpenter or installer who orders materials for live jobs | **Buyer, user, or both:** both | **Primary or secondary:** candidate primary (D-02)

| Attribute | Content | Evidence |
|---|---|---|
| Goals | Materials on site when the crew needs them; plan cranes and machine hire around delivery; hassle-free repeat ordering from a regular product pool | S-017 |
| Current alternative / workaround | Pop out to the store mid-job; phone the branch; pre-ordered pallet deliveries | S-017, S-011 |
| Frustrations | No clear oversight of when orders arrive; wrong access point, nobody to receive; damaged or missing goods | S-017, S-011, S-010 |
| Context of use | On site, mobile; ordering on the go | S-017 |
| Tools used | Merchant trade apps (credit account, invoices) in the UK; Nordic small contractors increasingly use digital tools (87% say digital helps serve customers) | S-017, S-024 |
| Tech proficiency | not evidenced in the sources — omitted | — |
| Decision authority & budget | not evidenced — omitted | — |

Quotes (UK, paraphrased in source): builders "didn't have a clear oversight of when orders would arrive" (S-017).

### PER-2 — "Delivery-ordering DIYer" (`SEG-2`) — co-candidate primary
**Role / context:** private home improver ordering bulky materials or goods | **Buyer, user, or both:** both | **Primary or secondary:** candidate primary (matrix leader, D-02)

| Attribute | Content | Evidence |
|---|---|---|
| Goals | Order is available, arrives on the promised date, and can be fixed fast if wrong | S-004, S-007 |
| Current alternative / workaround | Call or chat support; reorder from another chain; public review | S-007, S-009 |
| Frustrations | Item "in stock" but not; slipped dates; no follow-up; unreachable support | S-007, S-004, S-005 |
| Context of use | Webshop / store; home delivery | S-007 |
| Tools used | Webshop, tracking numbers, chat/email | S-007 |
| Tech proficiency, decision authority | omitted (no evidence) | — |

Quotes: "Bestilte mine varer 27/2. Jeg hører ingenting fra Byggmax" (S-007, 2024-03-13); "Three weeks and counting for my order" (S-004, 2024-06).

### PER-3 — "Store & warehouse employee" (`SEG-3`) — secondary (internal user)
**Role / context:** shop and warehouse staff in a building-materials store | **Buyer, user, or both:** user only; mandate from the executive board | **Primary or secondary:** secondary

| Attribute | Content | Evidence |
|---|---|---|
| Goals | not evidenced from employee voice — omitted | — |
| Current alternative / workaround | Routines per chain concept and ERP systems; manual counts | S-019 |
| Frustrations | Inventory records inaccurate (system-level evidence); repetitive manual tasks (Low, unread article) | S-016 |
| Context of use | Counter, warehouse, goods receipt, picking and packing | S-019 |
| Tools used | ERP, chain-specific routines | S-019 |
| Tech proficiency, decision authority | omitted | — |
| Success in own words | **No evidence** — see risk RK-03 | — |

### Persona comparison
| | PER-1 Tradesperson | PER-2 DIYer | PER-3 Store/warehouse employee |
|---|---|---|---|
| Goal | Material on site on time | Promise kept, fixable | Efficient routines, accurate stock (not evidenced) |
| Context | Site, mobile | Home, webshop/store | Store, warehouse |
| Buyer/user | Both | Both | User |
| Current alternative | Phone / store run | Support chat, other chain | ERP + manual routines |
| Evidence depth | Thin (UK/vendor) | Rich (reviews) | Thin (job ads, US study) |

## 3. Stakeholder Value Map

| ID | Stakeholder | Role | Gives (to whom) | Gets (from whom) | Infl. | Int. | Motivation | Evidence |
|---|---|---|---|---|---|---|---|---|
| STK-1 | Executive board | Buyer / sponsor | Investment (to IT/programme) | One solution with the greatest business impact | H | H | Compete in a highly competitive market | S-001 |
| STK-2 | Pro customers (SEG-1) | Customer | Orders, loyalty | Materials on time, visibility | M | H | Keep crews and machines productive | S-017 |
| STK-3 | DIY customers (SEG-2) | Customer | Orders, reviews | Reliable promise, resolution | L (individually) | H | Project completed | S-004, S-007 |
| STK-4 | Store & warehouse staff (SEG-3) | User, operator | Daily execution, stock accuracy | Easier routines, clearer tasks | M | H | Not evidenced | S-019 |
| STK-5 | Country management DK / NO / SE | Local owners of processes and systems | Local requirements, rollout capacity | Fit with local needs | H | H | Brief: "each with its own local business needs" | S-001 |
| STK-6 | Employee representatives / unions | Statutory consultation (NO, SE) | Consultation, acceptance | Early involvement, justification | M-H | M | Protect staff from undue control | S-012, S-013 |
| STK-7 | Data protection authorities (Datatilsynet, IMY, Datatilsynet NO) | Regulators | Supervision | Compliant processing | M | M | Employee-monitoring scrutiny rising in DK | S-014 |
| STK-8 | Suppliers / producers | Source of goods | Goods and lead times | Orders, forecasts | M | M | Door, kitchen and parquet delays traced to producers in reviews | S-008, S-006, S-009 |
| STK-9 | Carriers / drivers (own or third party) | Delivery execution | Delivery, proof of delivery | Route, window, site info | M | M | No direct evidence | S-011 (vendor) |

### Tensions
| Between | Tension | Evidence | Implication |
|---|---|---|---|
| STK-1 ↔ STK-5 | One strategic solution vs local autonomy and systems | S-001 | Rollout must be "one solution, different implementations"; country management is a co-sponsor, not a recipient |
| STK-1/STK-4 ↔ STK-6 | Metrics on employees (task completion, picking) vs statutory limits on control measures | S-012, S-013, S-014 | Design aggregate (team/store) metrics; build consultation into the plan for NO and SE |
| STK-2/STK-3 ↔ STK-8 | Customers are promised dates that producers do not meet | S-008, S-009 | A reliable promise needs supplier lead-time data, not only internal stock |
| STK-4 ↔ STK-3 | Better stock accuracy takes staff effort; the benefit shows up with customers and HQ | S-016 (cause), S-007 (effect) — **hypothesis, not evidenced for Nordics** | Make accuracy a by-product of existing tasks (e.g. goods receipt, picking) instead of extra counting |

```
Board ──(invests)──▶ [Solution] ──(reliable promise)──▶ Customers
  ▲                      │  ▲                              │
  └─(business impact)────┘  └─(accurate stock/time)── Store staff, Suppliers, Carriers
Unions / DPAs ── constrain how Store-staff data is used (NO ch.9, SE MBL §11, DK GDPR)
```

## 4. Journey lanes for Step 05
1. **Customer lane** — one lane covering the order-to-delivery journey with PER-1 (pro) and PER-2 (DIY) differences annotated at each stage, because D-02 is open.
2. **Store & warehouse employee lane (PER-3)** — internal-tool form: *Mandate / Rollout* replaces Awareness + Consideration (customer-journey.md §3), stated explicitly.
The executive board is the buyer (STK-1) and appears only in the Mandate / Rollout column.

## Open items raised
- D-02 (existing): pro vs DIY; see recommendation above.
- RK-02 / RK-03 (new risks): thin first-hand evidence for pros and staff — see `_decisions.md`.

## Deliverables checklist
- [x] Beachhead addressed: provisional, tie documented, D-02 stays open by design (user delegated to Gate A)
- [x] Every persona attribute cites S- or R-IDs; unsupported ones omitted
- [x] Buyer vs user explicit
- [x] Stakeholder map and tensions present
- [x] Lanes listed for Step 05

---
# Update 2026-10-23 — beachhead resolved by the user (D-02) and new primary persona

## U1. Beachhead
D-02 is **decided**: B2B trade customers with contract prices and the order handlers who serve them (R-25, S-037 §4.3). DIY consumers are not targeted in this scope (Phase-2 / not targeted). This replaces the provisional tie between SEG-1 and SEG-2 above.

| Segment | Role | Status |
|---|---|---|
| SEG-1 Trade customers (existing B2B, contract prices) | Sends orders by email/PDF/Excel/phone | Beachhead (customer side) |
| SEG-3a Order handlers (store / regional order office) | Reads, matches, prices, keys, confirms | **Primary user** of the product |
| SEG-2 DIY consumers | — | Not targeted |
| SEG-3 Other store staff | — | Not targeted |

## U2. Personas (additions; PER-2 DIYer is now out of scope)
### PER-4 — "Order handler" (SEG-3a) — **primary user**
**Role / context:** employee in a store or regional order office who receives B2B orders by email/PDF/phone and enters them in the ERP | **Buyer, user, or both:** user (buyer = executive board) | **Primary**

| Attribute | Content | Evidence |
|---|---|---|
| Goals | Not evidenced in the handler's words — omitted | — |
| Current alternative / workaround | Reads each message, matches items to SKUs, applies the contract price, keys the order into the ERP | S-037 §2 G1, S-043 |
| Frustrations | Re-keying ("type all of that into our ERP"); order and quote handling sits inside general sales roles so the cost is invisible | E38, S-037 §4.1 |
| Context of use | Regional order mailbox; branch order emails; ERP such as AS400 at STARK (Company A's ERP unknown) | S-043, S-044, S-042 |
| Tools used | Email, ERP, phone | S-043, S-042 |
| Tech proficiency, decision authority | not evidenced — omitted | — |

### PER-1 — "Trade customer ordering by email" (SEG-1), revised
Small/mid contractor with contract prices who sends orders as lists, PDFs, photos or emails. Goals/frustrations as above in Step 04 (S-017, S-011) and E32-E37: wants a fast confirmation, correct prices, no need to "ask for a quote". Tech proficiency and decision authority are not evidenced.

## U3. Stakeholder map (additions)
| ID | Stakeholder | Role | Gives | Gets | Infl. | Int. | Evidence |
|---|---|---|---|---|---|---|---|
| STK-10 | Order-office lead / sales manager | Supervises handlers, owns exception handling | Approval of working practice, rules | Faster, more accurate order intake | H | H | S-044 (ordrekontor) |
| STK-11 | ERP / IT owner in Denmark | Controls API/write access | Access, change windows | A safe overlay | H | M | S-042 (AS400), S-037 |
| STK-12 | LLM / cloud provider | Processes message content | Model API | Usage fees | M | L | D-19 |
| STK-13 | Customer service | Receives status queries and complaints | — | Fewer "where is my order" queries | L-M | M | S-037 G2 |

Tensions added: (1) efficiency vs perceived monitoring of handlers: resolved by R-26 (no individual monitoring; aggregate measures only); (2) relationship value of phone/email vs digitisation: portals fail (S-047), so the product keeps the channel and removes the re-keying; (3) legacy ERP write access vs 12-week plan (RK-07, D-23).

## U4. Lanes for Step 05 (revised)
1. **Trade customer lane (SEG-1):** order-by-email path, B2B. 2. **Order handler lane (SEG-3a):** internal form (Mandate/Rollout replaces Awareness + Consideration). The earlier delivery lanes stay on file for the delivery-promise check.
