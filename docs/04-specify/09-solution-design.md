Step 09 · Searches used: 2/4 · Sources: S-037, S-053, S-055, S-058, S-059

# Step 09 — Solution Design (UX) — Order Intake Assistant

> Users are Company A staff. Customers interact only by email (no customer-facing UI, R-25). Copy is given in English with Danish for key strings; the UI language is (D-20 decided). Vocabulary follows Step 03 and `_glossary.md` (draft order, order handler, review screen, exception queue, shadow mode, contract price). Roles: **OH** order handler (PER-4), **OL** order-office lead, **AD** administrator, **AN** analyst (read-only dashboards). Role set is (D-22 decided).

## 1. To-be journey, aha moment and critical path

| Stage | Steps with the product | Pain removed | Screen |
|---|---|---|---|
| Mandate/Rollout | OL and AD configure mailboxes and thresholds; OH sees what the assistant does and does not do | trust, R-26 | SCR-15..SCR-19, SCR-24, SCR-29 |
| DEC | 1. Message arrives and is classified. 2. A draft appears in My queue with customer, site, lines, prices, delivery date and confidence. 3. OH opens the review workspace, checks flagged lines, approves. 4. The order is written to the ERP. 5. Confirmation is sent to the customer. | P-09, P-10, P-11 | SCR-02, SCR-03, SCR-04, SCR-05 |
| RET | Exceptions after the order are listed; corrections feed learning; OL watches the queue and measures | P-01, P-04 (via O-03), O-04 | SCR-09, SCR-11, SCR-12 |
| ADV | OH answers a short usefulness pulse | — | SCR-25 |

**Aha moment:** OH approves the first draft in the review workspace with one click and sees the confirmation go out.
**Critical path (first build slice):** SCR-01 sign in → SCR-02 My queue → SCR-03 Review workspace → approve → (write-back, confirmation, SCR-05 preview when required). Behind it, non-UI: mailbox connector → classification → extraction → matching → price/stock check → delivery proposal.

## 2. UX flows

Each flow lists happy, alternative, error and edge cases. "Becomes AC" = turned into an acceptance criterion in Step 10.

### FL-01 Receive to approve (F-01..F-09, F-11, F-15, F-28) · DEC · [R1]
**User goal:** turn a customer message into a confirmed ERP order. **Entry:** My queue (SCR-02) or an alert link. **Success:** order in the ERP, confirmation sent, correction data stored. **Removes:** P-09, P-10, P-11.

| # | Action | System response | Screen | State |
|---|---|---|---|---|
| 1 | (non-UI) Message arrives in a configured order mailbox | Connector ingests it once, threads it, stores attachments, classifies it as *order*, extracts customer, site, lines, quantities, units, delivery wishes with per-field confidence, matches SKUs, reads contract prices and stock/credit, proposes a delivery date with confidence | — | draft created |
| 2 | OH opens My queue | Drafts listed by age and confidence; badge shows count needing attention | SCR-02 | populated |
| 3 | OH opens a draft | Message and draft shown side by side; fields with low confidence highlighted and linked to the evidence in the message | SCR-03 | draft |
| 4 | OH approves ("Godkend") | Approval recorded; if the office is in **shadow mode**, nothing is written (see FL-06); otherwise the draft order is written to the ERP | SCR-03 | approving |
| 5 | (non-UI) Write-back succeeds | ERP order number stored; confirmation sent to the customer in the customer's language | SCR-03 banner | written |
| 6 | OH sees success and the next draft opens | | SCR-03 | success |

Alternative paths:
| Condition | Variation | Outcome |
|---|---|---|
| Line below threshold | Line flagged amber/red with text label ("Usikker"/"Unsure") and 1-3 SKU candidates | OH picks candidate in line editor (SCR-04) |
| OH edits any field | Edit recorded as a correction (F-11) | Draft is no longer counted as approved without edits |
| Confirmation requires a custom note | OH opens preview (SCR-05) before sending | Edited text sent |
| Message not an order | Routed to Non-order queue (SCR-08) | OH handles outside the assistant |
| Message is a status request | FL-03 | |
| Message is a complaint | R1: routed to SCR-08 with label; R2: FL-20 | |

Error paths:
| Trigger | Message (exact copy) | Recovery |
|---|---|---|
| ERP write fails | "Ordren blev ikke oprettet i ERP. Intet er sendt til kunden. Prøv igen eller kontakt administrator." / "The order was not created in the ERP. Nothing was sent to the customer. Retry or contact an administrator." | Retry button; item stays in queue with status *Write failed* (FL-05) |
| Stock or price check unavailable | "Pris/lager kunne ikke hentes. Kontroller manuelt før godkendelse." / "Price/stock could not be retrieved. Check manually before approving." | Approve disabled until the OH confirms manual check |
| Extraction failed | "Assistenten kunne ikke læse denne besked." / "The assistant could not read this message." | Message opens in manual mode with the original only |
| Attachment unreadable or password-protected | "Vedhæftningen kan ikke åbnes." / "The attachment cannot be opened." | OH requests a new file; template reply offered |

Edge cases:
| Edge case | Handling | AC? |
|---|---|---|
| Same message received twice or forwarded | De-duplicated by message ID and content hash; second marked *Duplicate* | Yes |
| Several orders in one message | Split into separate drafts, linked | Yes |
| Customer not found in ERP | Draft held; OH searches or creates request for customer set-up (outside product); no write | Yes |
| Units in packs vs pieces vs running metres (S-059) | Unit normalised; both shown; conversion factor from master data | Yes |
| Message language other than Danish/English | Flagged *Unsupported language* until R2 (F-31); routed to manual | Yes |
| Two handlers open the same draft | The second user sees the draft read-only with the banner "Åbnet af en kollega" / "Opened by another handler" and the lock owner's display name; the lock expires after a configured idle time | Yes |
| Message contains instructions aimed at the system (injection) | Content treated as data; any directive is ignored; message flagged if it matches known patterns (S-055) | Yes |

### FL-02 Resolve exceptions in review (F-04, F-05, F-06, F-07) · DEC · [R1]
Happy: OH opens an exception line → line editor (SCR-04) shows the original text span, candidates with SKU number, description, unit, last bought by this customer, stock → OH selects → line becomes *Confirmed*.
Alternative: no candidate fits → OH searches the catalogue by free text; → *No match* line can be removed or held back; order can be approved partially only if the customer's message allows ("Hold linje"). Stock shortfall: shows available quantity and next delivery date; OH chooses *Split*, *Backorder*, or *Substitute*. Price mismatch: contract price differs from customer-stated price → highlights both; OH keeps contract price and adds a note, or flags to OL.
Errors: catalogue search timeout → "Søgningen tog for lang tid." / "Search timed out." + retry. Edge: customer-specific name saved as alias (FL-07); quantity zero or negative → inline validation "Mængde skal være større end 0."

### FL-03 Status request (F-02, F-10) · DEC · [R1]
Happy: message classified *status request* → system finds the order number or customer+date in the ERP → proposes an answer (status, expected delivery) → OH reviews (SCR-07) → sends. Alternative: order not found → asks customer for order number (template). Error: ERP unavailable → "Status kunne ikke hentes." Edge: ambiguous reference to several orders → list for OH to choose.

### FL-04 Non-order messages (F-02) · DEC · [R1]
Happy: quote requests, complaints (R1), other → listed in SCR-08 with category, customer guess, age; OH marks *Handled elsewhere*, replies from their mail client, or reassigns. Edge: mis-classified order → "Mark as order" re-runs extraction; the correction is stored (F-11).

### FL-05 Write-back failure and retry (F-08) · DEC · [R1]
Happy: write fails (timeout, validation error, duplicate) → draft status *Write failed* → OH or OL retries; idempotency key prevents duplicate ERP orders. Alternative: API unavailable → RPA fallback (if enabled) → if both fail, item stays queued and OL is alerted. Error copy as in FL-01. Edge: ERP reports the order exists (duplicate) → show existing ERP order number and link; no second order.

### FL-06 Baseline mode and shadow mode (F-14, F-15) · RET · [R1]
Weeks 1-2 (baseline mode): messages are only logged and counted (channel mix, volumes, handling-time samples); no drafts are shown. Weeks 3-8 (shadow mode): drafts are created but never written; OL sees them in SCR-13/14 next to what the handler keyed in the ERP; differences are listed per field. Switching mode is an AD/OL action with a confirmation dialog. Error: no human-entered order found for a draft after 48 h → *Unmatched* bucket. Edge: a human order covering several drafts → many-to-one matching shown with a manual link control.

### FL-07 Aliases and customer-specific names (F-17) · DEC · [R1]
Happy: in SCR-04 OH ticks "Gem som kundens betegnelse" → alias saved for that customer→SKU; managed in SCR-10 (search, edit, deactivate, history). Alternative: OL approves aliases above a policy threshold. Edge: alias conflicts (same name → two SKUs) → blocked with explanation. Error: save fails → toast with retry.

### FL-08 Queue management by the lead (F-13) · RET · [R1]
Happy: OL opens SCR-11: counts by status, age distribution, oldest item, assignments by team; reassigns items or sets a service timer; sees alerts. No individual productivity ranking (R-26): the screen offers team and office aggregates only. Error: data stale → banner "Data er ældre end 5 minutter." Edge: item assigned to an absent person → offered for reassign.

### FL-09 Measurement dashboard (F-14, F-28) · RET · [R1]
Happy: OL/AN/AD see channel mix, volumes, North Star (orders approved without edits), time to confirmation, handling time per order (team level), line error rate, exception backlog, cost per order; filter by office and period; export as CSV. Baseline banner while in baseline mode. Empty state until data exists. Edge: metrics with fewer than 10 orders in a period shown as "For få data" to avoid individual inference.

### FL-10 Admin configuration (F-16, F-18, F-19, F-21) · all · [R1]
Mailboxes: connect, test, pause, set polling rules, set non-order filters. SKU scope: define the in-scope catalogue (top ~2,000) and alias policy. Thresholds: per-field confidence thresholds, with a test against the evaluation set before activation. Templates and languages: confirmation and status templates. Model/prompt versions: view versions, evaluation results, activate or roll back (two-person rule optional). Users and roles: map SSO groups to roles and office scopes. Errors: connection test fails → exact provider error summarised, no secrets shown. Edge: changing a threshold records who/when/previous value in the audit log.

### FL-11 Privacy, retention and audit (F-20) · all · [R1]
Audit log viewer (filter by event type, object, user, period; export). Retention settings (message and attachment retention in days; automatic deletion job). Data-subject requests for customer contacts: AD registers a request (access, rectification, deletion); the system finds messages and drafts containing the contact; AD reviews and executes deletion/anonymisation; the request is closed with a record. Edge: legal hold flag blocks deletion; deleting a message that has an ERP order keeps the order reference only.

### FL-12 Onboarding, help, feedback (F-26, F-27) · Mandate/Rollout, ADV · [R1]
First sign-in shows a short onboarding checklist (SCR-29) and the page "What the assistant does and does not do" (SCR-24), including: "Assistenten overvåger ikke enkeltpersoner." / "The assistant does not monitor individuals." Feedback modal (SCR-25) with free text and a 1-5 usefulness pulse (team-level reporting only).

### FL-13 Notifications and preferences (F-22) · DEC · [R1]
In-app badge and optional email digest for new drafts needing attention, write failures, and mailbox problems (for AD/OL). Preferences (SCR-23): channels, digest time, UI language. Edge: quiet hours; digest not sent if nothing new.

### FL-14 Degraded mode and status (F-23, F-24) · all · [R1]
If the model or the extraction service is unavailable, incoming messages are still ingested and shown in My queue as *Manual* with the original message only; a banner states "Assistenten er midlertidigt utilgængelig. Beskeder behandles manuelt." / "The assistant is temporarily unavailable. Messages are handled manually." The status page (SCR-26) shows mailbox, ERP and model health. Maintenance page SCR-27 during planned downtime.

### FL-15 Sign-in and access (F-19) · all · [R1]
Happy: SSO redirect → role and office scope resolved → My queue. Error: not in any mapped group → SCR-28 "Du har ikke adgang." / "You do not have access." with the AD contact. Edge: session expiry mid-edit keeps the draft edits locally for 5 minutes and restores after sign-in (non-sensitive fields only).

### FL-16 Master-data sync and adapters (F-17, F-18) · all · [R1]
(non-UI) A scheduled job pulls catalogue, units, conversion factors and purchase history from the ERP; a freshness check raises an alert if older than the configured age. Adapters isolate ERP specifics behind one interface. Errors: sync failure → alert to AD and status page; the last good snapshot continues to serve with a *stale* marker on drafts.

### FL-17 LLM gateway and guardrails (F-21) · all · [R1]
(non-UI) All model calls go through the gateway: redaction/minimisation, versioned prompts, system instructions separated from message content, outputs validated against a schema, per-call cost recorded. A model output that fails schema validation or contains actions outside the allowed set is discarded and the message is routed to manual (S-055). Edge: provider timeout → retry once, then manual route.

### FL-18 After-the-order exceptions (F-12) · RET · [R1]
SCR-09 lists orders with missing site data or stock shortfall detected after write-back; OH or OL marks resolved or contacts the customer from their mail client; read-only data from the ERP. Edge: ERP shows the order cancelled → item auto-closed with a note.

### R2 flows
**FL-19 Additional intake channels (F-29):** voicemail and phone-call transcripts, photos and EDI change messages enter the same queue; SCR-03 shows the transcript or image beside the draft with highlighted evidence; edge: low-quality image → "Billedet er for utydeligt" / "The image is too unclear" + request-resend template; transcripts carry a *Speech-to-text* label.
**FL-20 Complaints and returns (F-30):** classified complaint → draft acknowledgement → case queue (SCR-32) with category and linked order; no claims processing; edge: complaint containing an order → both paths.
**FL-21 Full catalogue and languages (F-31):** SKU scope extended in admin to full catalogue; additional languages enabled per mailbox; edge: mixed-language message → language per line recorded.
**FL-22 Auto-approval policy (F-32):** AD defines a policy (customer groups, minimum confidence, maximum order value, excluded categories); eligible drafts are written without a click; every automatic approval is auditable and sampled for review (default 10%); a kill switch pauses all. Edge: a sampled review finds an error → auto-approval pauses for that customer group and OL is alerted.
**FL-23 ML delivery estimate (F-33):** admin compares rule-based and ML estimates on stored history; activation only after evaluation threshold; fallback to rules. Edge: fewer than 6 months of history → option disabled with explanation.
**FL-24 Model tuning (F-34):** AD runs an evaluation on stored corrections; a candidate model is released only if it beats the current model on the evaluation set; rollback in one click.

### R3 flows
**FL-25 Market adapter sets (F-35, F-36):** AD enables a market: adds adapters, language set, office scopes, templates, thresholds; a checklist shows readiness (adapters tested, templates reviewed, consultation step recorded as complete by an authorised user). Edge: market flag cannot be enabled before the checklist is complete.
**FL-26 Sweden delivery exceptions (F-37):** exceptions from the carrier/transport-visibility tool (delay, missing site data) arrive as items in SCR-37; OH or OL can send a pre-approved customer notice; (D-18 decided) for the named tools.

## 3. Information architecture
| Role | Navigation (left menu) | Entry points |
|---|---|---|
| OH | Kø (My queue) · Undtagelser (Exceptions) · Øvrige beskeder (Non-order) · Kunde-betegnelser (Aliases) · Hjælp | Email alert, deep link to a draft, ERP link (if provided) |
| OL | OH items plus Teamkø (Team queue) · Måling (Dashboard) · Skyggetest (Shadow comparison) | Same |
| AN | Måling (Dashboard) · Skyggetest | Dashboard link |
| AD | Everything above plus Administration (Mailboxes, Scope, Thresholds, Templates, Model versions, Users, Markets, Privacy & audit, Status) | Status page, alert email |
Cross-cutting: global search by customer, message or ERP order number; profile menu (preferences, language, feedback, sign out).
Visibility: OH sees drafts in their office scope; OL sees all items in the office; AN sees aggregates only; AD sees configuration and audit but no draft content unless also OH (separation of duties; (D-22 decided)).

## 4. Screen inventory

| SCR-ID | Screen | Type | Role | Stage | F-IDs | Data shown (entities) | Primary action | Secondary actions | Release |
|---|---|---|---|---|---|---|---|---|---|
| SCR-01 | Sign in / session expired | page | all | all | F-19 | User, Session | Sign in with company account | — | R1 |
| SCR-02 | My queue | page | OH, OL | DEC | F-07, F-22 | Message, Draft, confidence summary, status | Open draft | Filter, search, assign to me | R1 |
| SCR-03 | Review workspace | page | OH | DEC | F-02, F-03, F-04, F-05, F-06, F-07, F-08, F-09, F-10, F-11, F-25 | Message, Attachment, Draft, DraftLine, Customer, Site, SKU, ContractPrice, StockCheck, DeliveryProposal, Confidence, Exception | Approve | Edit line, reject, forward, reassign, open preview | R1 |
| SCR-04 | Line editor | drawer | OH | DEC | F-04, F-07, F-17 | DraftLine, SKU candidates, Unit conversions, Alias, purchase history | Select SKU | Search catalogue, hold line, save as customer name | R1 |
| SCR-05 | Confirmation preview | modal | OH | DEC | F-09 | Confirmation text, language, recipients | Send | Edit text, cancel | R1 |
| SCR-06 | Reject / forward / reassign | modal | OH, OL | DEC | F-07 | Draft, reason list, users/teams | Confirm | Cancel | R1 |
| SCR-07 | Status request review | page | OH | DEC | F-10 | Message, Order status (ERP), proposed answer | Send answer | Edit, reject | R1 |
| SCR-08 | Non-order messages | page | OH, OL | DEC | F-02 | Message, category | Mark handled | Re-classify as order, reassign | R1 |
| SCR-09 | After-the-order exceptions | page | OH, OL | RET | F-12 | ErpOrderRef, exception type | Mark resolved | Open order, assign | R1 |
| SCR-10 | Customer-specific names (aliases) | page | OH, OL | DEC | F-17 | Alias, Customer, SKU, history | Add / edit alias | Deactivate, view history | R1 |
| SCR-11 | Team queue | page | OL | RET | F-13 | Queue aggregates, ages, assignments | Reassign | Set service timer, view alerts | R1 |
| SCR-12 | Measurement dashboard | page | OL, AN, AD | RET | F-14, F-28 | MetricSnapshot, ChannelMix | Change filter | Export CSV | R1 |
| SCR-13 | Shadow comparison list | page | OL, AN, AD | RET | F-15 | ShadowComparison summary | Open comparison | Filter, export | R1 |
| SCR-14 | Shadow comparison detail | page | OL, AN, AD | RET | F-15 | Draft vs human-entered ERP order, field differences | Link orders manually | Mark reviewed | R1 |
| SCR-15 | Admin: mailboxes | page | AD | all | F-01, F-16 | MailboxConfig, status | Save | Test connection, pause | R1 |
| SCR-16 | Admin: scope and thresholds | page | AD | all | F-16, F-31 | SKU scope, Threshold, evaluation results | Activate | Test on evaluation set | R1 |
| SCR-17 | Admin: templates and languages | page | AD | all | F-09, F-16, F-23, F-31 | Template, Language | Save template | Preview | R1 |
| SCR-18 | Admin: model and prompt versions | page | AD | all | F-11, F-16, F-21 | ModelVersion, EvalRun | Activate version | Roll back, compare | R1 |
| SCR-19 | Admin: users, roles, offices | page | AD | all | F-19 | SSO group mapping, Office, Role | Save mapping | — | R1 |
| SCR-20 | Admin: markets and feature flags | page | AD | all | F-16 | Market, FeatureFlag | Toggle | Show readiness checklist | R1 |
| SCR-21 | Audit log | page | AD | all | F-20 | AuditEvent | Filter | Export | R1 |
| SCR-22 | Privacy: retention and data-subject requests | page | AD | all | F-20 | RetentionPolicy, DsrRequest | Execute request | Register request, set legal hold | R1 |
| SCR-23 | My preferences | page | all | all | F-22, F-23 | NotificationPreference, Language | Save | — | R1 |
| SCR-24 | Help: what the assistant does | page | all | Mandate/Rollout | F-23, F-26 | Help articles | — | Open feedback | R1 |
| SCR-25 | Feedback and pulse | modal | all | ADV | F-27 | Feedback | Send | Skip | R1 |
| SCR-26 | System status | page | all | all | F-23, F-24 | Component health | — | — | R1 |
| SCR-27 | Maintenance | page | all | all | F-23 | Notice | — | — | R1 |
| SCR-28 | No access / not found / error | page | all | all | F-23 | Message | Go to My queue | Contact administrator | R1 |
| SCR-29 | Onboarding checklist | page/modal | all | Mandate/Rollout | F-26 | Checklist state | Mark step done | Skip | R1 |
| SCR-30 | Draft side panel: attachment viewer (PDF/Excel/image) | drawer | OH | DEC | F-01, F-07 | Attachment | — | Zoom, download | R1 |
| SCR-31 | Intake channel viewer: transcript and image | drawer | OH | DEC | F-29 | Transcript, Image | — | Request resend | R2 |
| SCR-32 | Complaint and return case queue | page | OH, OL | RET | F-30 | Case, Message, linked Order | Acknowledge | Assign, close | R2 |
| SCR-33 | Admin: auto-approval policy | page | AD | all | F-32 | Policy, sampling results | Save policy | Pause all | R2 |
| SCR-34 | Admin: model evaluation and release gate | page | AD | all | F-34, F-33 | EvalRun, candidate vs current | Release | Roll back | R2 |
| SCR-35 | Admin: delivery estimate settings | page | AD | all | F-33 | EstimateModel, comparison | Activate | Fall back | R2 |
| SCR-36 | Admin: market readiness checklist | page | AD | all | F-35, F-36 | Market, Checklist | Enable market | — | R3 |
| SCR-37 | Delivery exceptions (Sweden) | page | OH, OL | RET | F-37 | DeliveryException, ErpOrderRef | Send notice | Mark resolved | R3 |

Non-UI features and their triggers: F-01 (new message in mailbox), F-02, F-03, F-04, F-05, F-06 (run on draft creation), F-08 (on approval), F-11 (on approval/edit; evaluation run on schedule or request), F-17 sync (schedule), F-18 (adapter calls: every ERP or mail operation), F-20 retention job (daily), F-21 (every model call), F-24 (continuous), F-28 (every event), F-29 channels (arrival), F-31, F-33, F-34, F-35, F-36 configuration-driven. Every F-ID is covered by a screen or a documented non-UI trigger.

## 5. Screen-state matrix (key copy; English / Danish)

| SCR | Empty | Loading | Error | Success / populated | Permission / role |
|---|---|---|---|---|---|
| SCR-01 | — | "Sender dig videre…" / "Redirecting you…" | "Login mislykkedes. Prøv igen." / "Sign-in failed. Try again." | My queue | No mapped role → SCR-28 |
| SCR-02 | "Ingen ordrer venter. Godt gået." / "No orders waiting." | Skeleton of 8 rows | "Køen kunne ikke hentes." + Retry | List of drafts with age and confidence chip (Sikker / Tjek / Usikker with text) | OH sees own office; OL all in office |
| SCR-03 | n/a | Message left, skeleton right | "Kunne ikke åbne udkastet." + Retry; field errors inline | Banner "Ordren er oprettet i ERP (nr. …). Bekræftelse sendt." / "Order created in ERP (no. …). Confirmation sent." | Read-only if locked: "Åbnet af en kollega." / "Opened by another handler." |
| SCR-04 | "Ingen forslag. Søg i kataloget." / "No suggestions. Search the catalogue." | Spinner on list | "Søgningen tog for lang tid." + Retry | Candidates with SKU no., description, unit, last bought, stock | OH, OL |
| SCR-05 | n/a | — | "Bekræftelsen kunne ikke sendes." / "The confirmation could not be sent." + Retry | "Bekræftelse sendt." | OH |
| SCR-06 | n/a | — | "Handlingen mislykkedes." | Toast "Gemt." | OH, OL |
| SCR-07 | n/a | Skeleton | "Status kunne ikke hentes." | Proposed answer with order status and expected delivery | OH |
| SCR-08 | "Ingen øvrige beskeder." / "No other messages." | Skeleton | "Listen kunne ikke hentes." | List with category chips | OH, OL |
| SCR-09 | "Ingen undtagelser." / "No exceptions." | Skeleton | "Kunne ikke hentes." | List with exception type | OH, OL |
| SCR-10 | "Ingen kundebetegnelser endnu." / "No customer-specific names yet." | Skeleton | Save error toast + Retry | List with search | Edit: OH propose, OL approve per policy |
| SCR-11 | "Køen er tom." | Skeleton | "Data er ældre end 5 minutter." banner | Aggregates by status/age/team | OL, AD only |
| SCR-12 | "Ingen data endnu. Baseline starter ved første besked." / "No data yet." | Skeleton charts | "Målinger kunne ikke hentes." | Tiles + charts; "For få data" under 10 orders | OL, AN, AD; no per-person data for any role |
| SCR-13 | "Skyggetest er ikke aktiv." / "Shadow mode is not active." | Skeleton | "Kunne ikke hentes." | Summary of matches/differences | OL, AN, AD |
| SCR-14 | n/a | Skeleton | "Sammenligning ikke mulig: ingen ERP-ordre fundet." | Side-by-side with differences highlighted | OL, AN, AD |
| SCR-15 | "Ingen postkasser tilsluttet." | Spinner on Test | "Forbindelsen mislykkedes: [kort årsag]." | Mailbox list with status | AD |
| SCR-16 | "Ingen tærskler sat; standard bruges." | Spinner | "Evaluering mislykkedes." | Thresholds with last evaluation | AD |
| SCR-17 | "Ingen skabeloner." | Skeleton | Save error | Template list, preview | AD |
| SCR-18 | "Ingen modelversioner." | Skeleton | "Versionen kunne ikke aktiveres." | Version list with evaluation scores | AD |
| SCR-19 | "Ingen grupper tilknyttet." | Skeleton | Save error | Group → role/office mapping | AD |
| SCR-20 | "Kun Danmark er aktiveret." | Skeleton | Save error | Flags with readiness | AD |
| SCR-21 | "Ingen hændelser i perioden." | Skeleton | "Loggen kunne ikke hentes." | Filterable list | AD |
| SCR-22 | "Ingen åbne anmodninger." | Skeleton | "Sletning mislykkedes. Intet er slettet." | Requests with status; retention rules | AD |
| SCR-23 | n/a | — | Save error | "Gemt." | own profile |
| SCR-24 | n/a | — | — | Help text incl. "Assistenten overvåger ikke enkeltpersoner." | all |
| SCR-25 | n/a | — | "Kunne ikke sendes." | "Tak for din feedback." | all |
| SCR-26 | n/a | Skeleton | "Status utilgængelig." | Component health with timestamps | all |
| SCR-27 | n/a | — | — | "Planlagt vedligeholdelse til [tid]." | all |
| SCR-28 | n/a | — | "Der opstod en fejl. Henvis til kode [id]." | "Siden findes ikke." / "Du har ikke adgang." | all |
| SCR-29 | n/a | — | — | Checklist progress | all |
| SCR-30 | "Ingen vedhæftninger." | Spinner | "Vedhæftningen kan ikke åbnes." | Viewer | OH |
| SCR-31 (R2) | "Ingen transskription." | Spinner | "Billedet er for utydeligt." | Transcript / image with highlights | OH |
| SCR-32 (R2) | "Ingen åbne sager." | Skeleton | "Kunne ikke hentes." | Case list | OH, OL |
| SCR-33 (R2) | "Ingen politik oprettet." | Skeleton | Save error | Policy with sampling results | AD |
| SCR-34 (R2) | "Ingen kandidatmodeller." | Spinner | "Evaluering mislykkedes." | Candidate vs current | AD |
| SCR-35 (R2) | "Mindre end 6 måneders historik. Ikke tilgængelig." | Skeleton | Error | Comparison | AD |
| SCR-36 (R3) | "Ingen markeder tilføjet." | Skeleton | Error | Checklist | AD |
| SCR-37 (R3) | "Ingen leveringsundtagelser." | Skeleton | Error | List | OH, OL |

Copy rule: confidence is always shown as text and icon as well as colour (accessibility, F-25). Danish strings are drafts for review (D-20 decided).

## 6. Off-app touchpoints
| Touchpoint | Trigger | Content outline |
|---|---|---|
| Order confirmation email | After successful ERP write (F-09) | Order number, lines, prices, delivery date, contact; language of customer's message |
| Status answer email | After OH sends (F-10) | Order number, status, expected delivery |
| Request for missing information | OH uses template | Which fields are missing (site, contact, quantity) |
| Staff digest/alert email | New drafts needing attention, write failures, mailbox errors (F-22) | Counts and deep links; no message content |
| Admin alert email | Mailbox, ERP sync, model health failures (F-24) | Component, time, link to SCR-26 |
| Acknowledgement email for complaints (R2) | OH sends (F-30) | Receipt confirmation, reference |
| Delivery notice (R3, Sweden) | OH sends from SCR-37 (F-37) | Delay information |

## 7. Design decision log
| Decision | Choice | Rationale | Alternatives | ID |
|---|---|---|---|---|
| Layout of review | One workspace: message left, draft right, flagged fields first | HITL practice (S-058); minimises context switching | Wizard; separate pages | — |
| Confidence display | Three levels with text and icon | Accessibility; avoids colour-only | Numeric percentage | S-058 |
| Order of events | Approve → ERP write → then send confirmation | Customers never receive a confirmation for an order that does not exist | Confirmation first | — |
| Approve gating | Approve disabled while a required field is invalid or a mandatory manual check is unconfirmed | Prevents the "automation illusion" (S-053) | Warn only | S-053 |
| No individual metrics | No per-employee view anywhere; team aggregates only; small-sample suppression | R-26, S-014 | Per-user dashboards | R-26 |
| Shadow mode | Controlled per office by OL/AD with a confirmation dialog | R-27 | Global switch | R-27 |
| Locking | Soft lock on opened drafts with read-only for others | Avoids double handling | Optimistic merge | — |
| Draft recovery after session expiry | Local non-sensitive edit cache, 5 minutes | Avoids lost edits | None | — |
| Message content in alerts | Counts and links only | Privacy | Content previews | GDPR |
| Separation of duties | AD sees configuration and audit, not draft content unless also OH | Least privilege | AD sees everything | D-22 |
| UI language | Danish with English fallback | D-20 | English only | D-20 |

## Open decisions raised at this step
All decisions raised here were resolved at the Step 12 closure (see `_decisions.md` and `05-deliver/12-closure-log.md`).

## Deliverables checklist
- [x] Critical path names the SCR sequence to the aha moment
- [x] Every in-scope F-ID (all releases) appears on a screen or a documented non-UI trigger
- [x] Every SCR has states with copy (R2/R3 abbreviated copy kept to empty/loading/error/success)
- [x] Operational surfaces from Step 08's checklist have screens (privacy, audit, admin, help, status, error)
- [x] No Parking Lot features designed; no demo-only screens
