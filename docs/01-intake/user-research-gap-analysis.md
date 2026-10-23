# Company A: Process Gap Analysis and Priority Evaluation

*User-supplied research (source S-037). Pasted by the user on 2026-10-23, originally dated Oct 23, 2026 (author shown as @Someone). Reproduced here with tables reconstructed from the flattened paste; wording is the author's. Not independently verified by the pipeline unless a later file says so (see `_sources.md`, S-037 to S-051).*

Ten process gaps were assessed against public evidence from Nordic builders' merchants and peers; G1 (unstructured B2B order intake) ranks first at 4.0 of 5, narrowly ahead of G2 (delivery promise and exceptions) at 3.9.

## 1. Comparable companies, processes and gaps

Company A is an anonymous archetype, so peers in the same case set stand in for it. STARK Group is the closest structural match; none matches exactly. Customer-facing processes are those a customer sees or takes part in; internal ones affect staff only.

| Group | Footprint in DK / NO / SE (verified) | Fit with Company A | Customer-facing processes and signals | Internal processes and signals | Gaps |
|---|---|---|---|---|---|
| STARK Group (STARK Danmark, Beijer Byggmaterial, Neumann Bygg) | STARK Danmark: 80+ locations in Denmark and Greenland; Beijer: 113 stores (some sources say 116); Neumann Bygg in Norway. Group: 1,050+ branches and distribution centres, net sales EUR 7.76bn (FY2024/25) | Closest: Danish head office, all three markets, hundreds of outlets. B2B-heavy (about 85% of STARK Danmark revenue), whereas Company A also serves consumers | 24/7 customer phone line; quotes by request; Trustpilot 3.3/5 (6,793 reviews) citing delivery, stock and responsiveness; automated national distribution centre in Denmark | 120 staff dedicated to B2B sales at Glostrup; goods registered in AS400; EDI orders, confirmations and invoices run automatically; EUR 81m transformation costs in FY2024/25 | G1, G2, G5, G10 |
| Bygma Gruppen | Denmark, Sweden, Iceland, Faroe Islands, Greenland, Poland; 125+ locations; 2025 revenue DKK 11.6bn; no Norway presence found | Partial (no Norway) | Three webshops built to keep agreed discounts (earlier research, to re-verify); Trustpilot 4.2 | Job ads: staff serve customers by phone, handle orders and quotes, prepare invoicing | G1, G5 |
| Optimera (Saint-Gobain) | Two entities: Optimera Norway (160 outlets, about 2,000 staff, over NOK 15bn) and Optimera Svenska (64 branches, about 900 staff, about SEK 4bn) | Partial; shows the delivery-technology trend | Regional order mailboxes; professional online trade up 26% in 2025; Alrik chosen for transport visibility across 64 Swedish branches (25 Aug 2026) | An "ordrekontor"; job ads for order reception and registration | G1, G2 |
| Byggmax | 210+ stores in SE, NO, FI, DK; 2025 net sales SEK 6,133m, EBITA 5.9% | Consumer-led; competitive benchmark | E-commerce about 17% of Q3 2026 revenue (trade press); Trustpilot 2.0/5 (4,468 reviews) on non-delivery and unreachable support; agentic commerce launched May 2026 | Alrik for logistics across 200+ stores | G2, G8 |

Two proxies are used only for digital-share benchmarks: Solar and Ahlsell (technical wholesale), and Travis Perkins (UK) for ERP-disruption lessons.

## 2. Gap analysis

Company A is an anonymous archetype, so all evidence comes from peers (STARK/Beijer/Neumann, Bygma, Optimera, Byggmax, Solar, Ahlsell, Travis Perkins). Reliability: High = company reports, official statistics, job ads; Medium = trade press, Trustpilot, buying-group research; Low = vendor-authored. "Source types" counts independent kinds of source, not pages.

| ID | Gap | What it is (process) | Evidence that the gap exists | Source types | Evidence strength | Existing solutions |
|---|---|---|---|---|---|---|
| G1 | Unstructured B2B order intake | Trade customers send orders by email, PDF, photo, list or phone; staff read them, match items to SKUs, apply contract prices and re-key into the ERP | Solar: 65% of order lines digital in 2024 and still 65% in Q2 2025, so 35% arrive otherwise. Danish companies: 33% of revenue online (25 pts EDI, 8 pts web) in 2025. UK trade: est. 8% of sales online in 2022 (NBG). Job ads at Beijer ("hämta/administrera order & offerter"), Bygma ("ordrebehandling og tilbudsgivning"), Optimera ("ordremottak og ordreregistrering"); STARK ad still cites AS400. Optimera publishes regional order mailboxes. A dealer says staff would otherwise "type all of that into our ERP" (Toolbx launch, 1 Sep 2026). Not found: share of orders arriving as email/PDF/photo, minutes per order, error rate | 5: company reports, official statistics, job ads, trade press, vendor | Existence moderate-strong; size weak | EDI (works for large repeat buyers); B2B portals (low uptake); AI order entry: Toolbx (US, GA 1 Sep 2026), DJUST, Hyperfox, Esker, SAP partner tools: no verified building-materials results |
| G2 | Delivery promise, tracking, ETA and exceptions | Stock and delivery date are promised at order from partial data; late, short or wrong deliveries are chased by phone; no proactive exception handling | Optimera Svenska (25 Aug 2026): "Reliable, efficient deliveries are central to the service we offer our customers"; picked Alrik for 64 branches. Byggmax picked Alrik for 200+ stores (Feb 2025). XL-Bygg uses Alrik AI for incomplete site addresses. Trustpilot: Byggmax 2.0/5 (4,468 reviews), Beijer 2.8/5, STARK 3.3/5 (6,793) citing delivery and stock problems. AECOM/TfL study (2017): 41% of failed deliveries at one London site were drivers leaving the queue. Not found: Nordic late-delivery rate or cost of "where is my order" contacts | 5: company releases, trade press, review sites, public-sector study, vendor | Qualitatively strong; no Nordic numbers | Alrik (Optimera, Byggmax, XL-Bygg), Descartes, DispatchTrack, STARK automated DC. Alrik customers self-report 25-30% lower delivery cost: unverified |
| G10 | Fragmented systems and data | Each country runs its own ERP/WMS/e-commerce; no shared order or product model, so improvements do not scale | The case brief; STARK EUR 81m transformation costs (FY2024/25) and AS400 in branches; Travis Perkins attributes early-2025 problems to Oracle cutover; Lidl dropped its SAP programme after about 7 years and about EUR 500m (2018) | 4: brief, company reports, job ads, trade press | Strong that it is a root cause | Full ERP replacement: high failure risk (Travis Perkins, Lidl); overlay/integration layers (Alrik-style) |
| G5 | Project quotes and contract pricing | Quotes built by hand; discounts differ by customer and project | Job ads ("tilbudsgivning", "offert- och orderhantering"); a STARK reviewer complains of "ALWAYS having to ask for a quote"; Netcompany's retail page cites quote support because "price and discount structures often vary"; Bygma built three webshops to keep agreed discounts (earlier research, to re-verify) | 2: job ads, reviews (+ supplier page) | Moderate-weak | CPQ tools (not researched in depth) |
| G4 | Product data quality (PIM) | Different catalogues and missing attributes per country, breaking search and SKU matching | Netcompany retail page lists master data as "slow manual processes"; vendor QFlow says 95% of delivery records contain data errors | 2: supplier page, vendor | Weak | PIM suites (inRiver, Informatica, SAP Commerce); LLM data enrichment |
| G3 | Store staff knowledge and task assistant | Knowledge sits with individuals; new staff ramp up slowly; stores work differently (Norway hint in brief) | Beijer's RELEX assistant "Rebot" answers 60,000+ queries a month (RELEX may report this platform-wide); Lowe's Mylow Companion (NVIDIA case). Contradiction: NAV, Virke and NHO data do not support a Norwegian retail labour shortage; no staff voice found | 2: vendor cases, case brief | Weak, partly contradicted | Beijer/RELEX assistant, Lowe's Mylow |
| G8 | Returns, claims, credit notes, customer service | Claims handled by email and phone, each branch in its own way | Trustpilot STARK: praise and complaints on "reklamation"; Byggmax runs AI customer service; no volume or handling-time data | 2: reviews, company announcements | Weak | Case-management tools; AI service agents (Byggmax) |
| G6 | Forecasting and replenishment | Stock does not match seasonal demand; legacy ERP forecasts poorly | Beijer uses RELEX across 117 stores; Optimera, Byggmax, K-Bygg also RELEX customers (vendor and company releases) | 2-3: company releases, vendor | Moderate; already served | RELEX and similar specialists |
| G9 | B2B account opening and credit | Paper or web forms re-typed; slow during promotions | Travis Perkins opened 45,000 net new accounts in 2025 (company results); earlier vendor case of 15,000 applications a year keyed by hand | 1-2: company, vendor | Weak | RPA/document-AI vendors |
| G7 | Click and collect and omnichannel orders | Web orders must sync with store stock and be picked on time | Byggmakker uses Omnium OMS; Beijer Skanna self-scan app; review complaint about click-and-collect payment taken with no confirmation | 1-2: company, reviews | Weak | OMS platforms (Omnium) |

## 3. Prioritisation criteria and evaluation

Scores are 1 (low) to 5 (high). They are judgement calls anchored in the evidence in sections 2 and 4.1, not measurements. Weighted score = 30% Impact + 30% Evidence trust + 20% Ease + 20% Netcompany strength.

| Aspect | Weight | What a high score means |
|---|---|---|
| Impact | 30% | Large effect on cost, revenue or service in the markets the brief names (DK manual processes, NO store operations, SE delivery); fits the case brief |
| Evidence trust | 30% | Several independent, non-vendor sources show the pain is real and current at peers |
| Ease | 20% | A pilot in 10-12 weeks in one market, as an overlay on the existing ERP, without replacing systems |
| Netcompany strength | 20% | Reuses EASLEY AI, PULSE, AMPLIO, Feniks AI and retail references; productisable; supports the 20%+ EBITDA target for 2029 |

| Rank | Gap | Impact | Evidence trust | Ease | Netcompany strength | Weighted |
|---|---|---|---|---|---|---|
| 1 | G1 Unstructured B2B order intake | 4 | 4 | 4 | 4 | 4.0 |
| 2 | G2 Delivery promise, ETA, exceptions | 5 | 4 | 3 | 3 | 3.9 |
| 3 | G10 Fragmented systems | 5 | 4 | 1 | 4 | 3.7 |
| 4 | G5 Project quotes and pricing | 4 | 3 | 3 | 3 | 3.3 |
| 5 | G4 Product data (PIM) | 3 | 3 | 3 | 4 | 3.2 |
| 6= | G3 Store staff assistant | 3 | 2 | 4 | 4 | 3.1 |
| 6= | G8 Returns, claims, customer service | 3 | 2 | 4 | 4 | 3.1 |
| 8 | G6 Forecasting and replenishment | 4 | 3 | 2 | 2 | 2.9 |
| 9 | G9 B2B account opening and credit | 2 | 2 | 4 | 3 | 2.6 |
| 10 | G7 Click and collect, OMS | 3 | 2 | 2 | 3 | 2.5 |

### Why the top scores were given
| Gap and score | Reasoning | Proof |
|---|---|---|
| G1 Impact 4 | Touches order-to-cash and sales-office productivity; the brief says manual processes weigh most in Denmark. Not 5 because order volumes by channel are unknown | Section 2, G1 row; Eurostat labour cost EUR 47.3/h in DK wholesale and retail |
| G1 Evidence 4 | Manual order and quote handling appears in job ads at four merchants; order mailboxes are public; digital share is 35-50% below 100% even at leaders. Not 5 because no source measures email/PDF share or minutes per order | Solar AR 2024; DI Oct 2025; NBG 2023; Beijer, Bygma, Optimera ads |
| G1 Ease 4 | AI reads, matches and proposes; a person approves; the ERP is untouched except draft-order write-back. Risks: master data quality, write access to AS400/SAP | STARK AS400 ad; Toolbx draft-in-under-a-minute claim is vendor-only |
| G1 Netcompany 4 | EASLEY AI for extraction, AMPLIO for exception queues, Solar and AO Johansen references, resellable to other wholesalers. One point off: SaaS rivals exist (Hyperfox, Toolbx, DJUST) | Netcompany Solar and Retail & Wholesale pages |
| G2 Impact 5 | Delivery drives site schedules; Optimera calls reliable delivery "central" to its service | Optimera Svenska release, 25 Aug 2026 |
| G2 Evidence 4 | Strong qualitative evidence from five source types, but no Nordic late-delivery or cost figures | Review sites; Alrik customer announcements; AECOM/TfL (London, 2017) |
| G2 Ease 3 | Needs carrier, GPS and TMS data across several parties | Alrik shows an overlay works but takes integration effort |
| G2 Netcompany 3 | PULSE fits, but Alrik already holds Optimera, Byggmax and XL-Bygg in Sweden | Alrik announcements 2025-2026 |
| G10 Ease 1 | Replacing or consolidating systems breaks the no-replacement constraint and the 10-12 week limit | Travis Perkins Oracle cutover; Lidl SAP |

### Sensitivity to the weights
| Weighting (Impact / Evidence / Ease / Netcompany) | G1 | G2 | G10 | Rank 1 |
|---|---|---|---|---|
| Base 30 / 30 / 20 / 20 | 4.00 | 3.90 | 3.70 | G1 |
| Equal 25 / 25 / 25 / 25 | 4.00 | 3.75 | 3.50 | G1 |
| Speed-weighted 25 / 25 / 30 / 20 | 4.00 | 3.75 | 3.35 | G1 |
| Impact-weighted 40 / 30 / 15 / 15 | 4.00 | 4.10 | 3.95 | G2 |

G1 stays first under three of four weightings. G2 overtakes only when Impact is weighted at 40% and Ease at 15%, which conflicts with the brief's statement that time to market is critical.

## 4. Confirmed problem to solve and scope

The problem selected is G1, unstructured B2B order intake, with a delivery-promise check borrowed from G2. It is an evidence-backed hypothesis: the problem demonstrably exists at peers, its size at Company A is unmeasured.

### 4.1 Evidence by aspect
| Aspect | Fact | Source and date | Reliability |
|---|---|---|---|
| Company | 65% of Solar's order lines were digital in 2024 and still 65% in Q2 2025, so about 35% arrive by other channels | Solar Annual Report 2024 (Feb 2025) | High |
| Company | Ahlsell Norway passes 50% digital trade (about 45 stores) | Ahlsell marketing director via VVSforum, 6 May 2026 | Medium-High |
| Company | STARK Danmark: about 85% B2B revenue; 24/7 phone line; AS400 still named in a 2026 branch job ad | stark.dk; Indeed DK job ad, 2026 | High |
| Company | Optimera publishes regional order mailboxes and runs an order office; Beijer publishes branch order emails | Company websites | High for existence |
| Customer behaviour | Danish companies earned 33% of revenue online in 2025 (25 pts EDI, 8 pts web), the highest share to date | Dansk Industri, Oct 2025, Danmarks Statistik data | High |
| Customer behaviour | UK: an estimated 8% of trade sales online in 2022; trade customers cite location (54.5%), service (54%), convenience (40.5%) and advice (32.5%) | NBG / Insider Trends via Builders' Merchants News, May 2023 | Medium |
| Customer behaviour | Maxbo Proff: about half of professional customers use the web solution but revenue does not match user numbers | Bygg.no, "Digital skepsis i byggevaremarkedet" (Norwegian) | Medium |
| Customer feedback | STARK reviewers complain of always having to ask for a quote and of payment taken with no confirmation sent | Trustpilot, 2026 (single reviews; 68% of reviews are five-star) | Medium, thin |
| Customer feedback | Byggmax 2.0/5 (4,468 reviews), Beijer 2.8/5: non-delivery, unreachable support | Trustpilot, 2024-2026 | Medium (self-selected) |
| Employment | Job ads name order and quote handling as a core duty: Beijer ("hämta/administrera order & offerter"), Bygma ("ordrebehandling og tilbudsgivning"), Optimera ("ordremottak og ordreregistrering") | Indeed and Karrierestart job ads, 2025-2026 | High for existence, no scale |
| Employment | Hourly labour cost, wholesale and retail 2025: DK EUR 47.3, NO EUR 49.1, SE EUR 43.0 (EU27 EUR 29.5) | Eurostat lc_lci_lev, updated Apr 2026 | High |
| Employment | Order handling sits inside general sales roles, not a separate order-desk cost line, so it is hard to see in reports | Inference from job ads | Inference |

### 4.2 Why G1 is not solved yet, and what would change the ranking

Previous attempts solved part of the problem. EDI works for large, repeat buyers; B2B portals see low uptake (Byggmakker about 1.5% of revenue via its portal in 2016; Maxbo Proff: about half of professional customers use it but revenue does not match); big ERP replacements disrupted service (Travis Perkins, Lidl). AI order entry only reached general availability on 1 Sep 2026 (Toolbx, US), with one named early user and no independent results. No public failure of AI or OCR order entry in building materials was found.

Likely reasons the long tail persists (inference, not directly sourced): small trade customers do not justify EDI; the counter and phone carry advice and relationship value; project pricing needs human confirmation; customers distrust online stock and delivery dates; legacy ERPs such as AS400 are hard to write back to; and order-handling cost is hidden inside general sales roles rather than shown as an order-desk cost line.

What would change the ranking:

| Finding | Effect |
|---|---|
| More than 80% of Company A's B2B order lines already arrive by EDI, web shop or app | G1 Impact falls to 3; G2 ranks first |
| Nordic data showing late or failed deliveries above 10% and large "where is my order" costs | G2 can rank first |
| Company A already uses Alrik or a similar tool | G2 Netcompany strength falls to 2 |
| Independent evidence of store-to-store inconsistency in Norway | G3 Evidence trust rises |
| Unstructured orders take under 3 minutes each, or order-desk work is under 0.2 FTE per store | G1 is undermined |

Still an assumption: orders per store per day, share of unstructured orders, minutes per order, Company A's ERP, master-data quality and API readiness. Illustrative cost model (assumption, not data): 300 stores, 20 unstructured orders per store per day, 12 minutes each, EUR 46.5 per hour loaded labour cost gives about EUR 14m a year (range EUR 1.9m to 33.1m). To validate in weeks 1-2: channel mix by order line, a one-week sample of email and PDF orders, and credit notes coded "wrong item, quantity or price".

### 4.3 Scope along the user journey

The MVP covers one market (Denmark), about 3-5 stores or one regional order office, email and PDF/Excel from existing B2B customers with contract prices, and the top roughly 2,000 SKUs. Every order is reviewed by a person before it reaches the ERP.

| Journey step | Feature | MVP (weeks 1-12) | Later phases | Role of AI |
|---|---|---|---|---|
| 1. Receive | Connector to the order mailbox for email, PDF and Excel | Yes | Phone and voicemail transcripts, photos, EDI changes | Supporting |
| 2. Understand | Classify intent (order, quote, status, complaint) and extract customer, site, lines, quantities, units, delivery wishes | Order and status requests | Complaints and returns | Core (LLM extraction) |
| 3. Match | Map free text such as "45x95 C24 4.8m" to SKUs using the catalogue and purchase history; normalise units | Top roughly 2,000 SKUs | Full catalogue, other languages | Core (semantic matching) |
| 4. Price and check | Apply contract or project price from the ERP; check stock and credit | Read-only rules | Project quotes (G5) | Rules, not AI |
| 5. Promise | Delivery date with a confidence level | Rule-based | ML-based ETA once 6+ months of delivery data exist | Supporting |
| 6. Review | Review screen: approve or correct in one click; exception queue for low-confidence lines | 100% human review | Gradual autonomy by confidence | Human in the loop |
| 7. Write | Draft order written to the ERP via API, with RPA fallback | Yes | Adapters for Norway and Sweden | Integration |
| 8. Confirm | Order confirmation to the customer in their language | Yes | Proactive updates | AI drafting |
| 9. Learn and measure | Corrections stored as evaluation data; baseline dashboard | Yes | Model tuning | Supporting |
| 10. After the order | Read-only list of exceptions (missing site data, stock shortfall); integrate rather than rebuild delivery tracking | Basic list | Sweden: proactive delivery exceptions via PULSE, linked to tools such as Alrik | Supporting |

Out of scope: ERP replacement, project-quote automation, forecasting, any monitoring of individual employees.

Plan: weeks 1-2 measure the baseline (channel mix by order line, a sample of 500 historical orders, credit notes coded for wrong item, quantity or price); weeks 3-8 build and run in shadow mode; weeks 9-12 supervised go-live and go or no-go. Measures: share of orders approved without edits, handling time per order, line error rate, time to confirmation. Targets are set after the baseline, not before.

## 5. Sources
| Source | Type | Reliability |
|---|---|---|
| Solar A/S Annual Report 2024 | Company report | High |
| Dansk Industri, Dansk e-handel 2025 | Industry body, Danmarks Statistik data | High |
| Builders' Merchants News, NBG report | Buying-group research via trade press | Medium |
| Eurostat hourly labour costs | Official statistics | High |
| STARK Group results release, Nov 2025 | Company release | High |
| STARK Danmark on Trustpilot | Customer reviews | Medium |
| STARK job ad (AS400), Indeed DK | Job ad | High for existence, no scale |
| Beijer job ads, Indeed SE | Job ad | High for existence, no scale |
| InsightDIY, Optimera and Alrik | Trade press on company release | Medium-High |
| Alrik, Byggmax announcement | Vendor | Low-Medium |
| Svensk Byggtidning, Byggmax agentic commerce | Trade press | Medium |
| Toolbx AI Order Entry, Distribution Strategy Group | Trade press on vendor release | Medium (vendor claims) |
| LBM Journal, Toolbx launch | Trade press, vendor-arranged testimonial | Medium |
| Travis Perkins FY2025 results | Company report | High |
| Netcompany, Solar case and Retail & Wholesale | Supplier pages | Medium |
| APQC, cost per sales order | Independent benchmark, cross-industry | Medium-High |
| Sana Commerce / Sapio survey, Digital Commerce 360 | Vendor-commissioned survey; covers online orders only, so not used as an order-desk error rate | Low-Medium |

Limits: several pages were read only as search summaries; Danish, Swedish and Norwegian quotes were translated; Swedish and Norwegian pay figures should be re-checked in the official tables before submission.
