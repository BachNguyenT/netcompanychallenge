Step 10 · Searches used: 0

# Step 10 — Epics & User Stories — Order Intake Assistant

> Every story of the complete product (R1, R2, R3) is specified to the same depth. Verification layers: `ui` (provable through the interface), `api` (provable at the API/data layer), `ui+api`. Parameters written as **CP-##** are configurable values whose defaults are set in Step 11 (NFR/configuration table) and confirmed in the closure batch (D-28). Roles: **OH** order handler, **OL** order-office lead, **AD** administrator, **AN** analyst. Terms follow `_glossary.md`. Events named here are finalised in Step 11.

Configurable parameters referenced: CP-01 mailbox polling interval · CP-02 draft lock idle timeout · CP-03 small-sample suppression threshold · CP-04 shadow-mode unmatched window · CP-05 data-staleness banner threshold · CP-06 session-restore window · CP-07 message and attachment retention · CP-08 auto-approval sampling rate · CP-09 master-data freshness limit · CP-10 attachment size limit · CP-11 default confidence thresholds · CP-12 exception-backlog alert threshold.

## 1. Epic overview
| Epic | Name | Stages | F-IDs | Success signal |
|---|---|---|---|---|
| EP-01 | Intake & understanding | DEC | F-01, F-02, F-03, F-29, F-31 | Messages ingested and understood without loss; share needing manual reading |
| EP-02 | Matching, pricing & promise | DEC | F-04, F-05, F-06, F-17, F-33 | SKU match accuracy; correct contract price; believable date |
| EP-03 | Review & approval | DEC, RET | F-07, F-10, F-12, F-32 | Orders approved without edits (North Star); time to confirmation |
| EP-04 | ERP integration & confirmation | DEC | F-08, F-09, F-18 | Orders written once and confirmed; write failures recovered |
| EP-05 | Learning & measurement | RET | F-11, F-14, F-15, F-28, F-34 | Baseline captured; shadow comparison; line error rate |
| EP-06 | Operations & queue management | RET | F-13, F-22, F-30 | Backlog age; reassign speed |
| EP-07 | Platform, security & compliance | all | F-19, F-20, F-21, F-24, F-25 | No unauthorised access; every approval and write audited |
| EP-08 | Administration & product support | Mandate/Rollout, ADV | F-16, F-23, F-26, F-27 | Configuration changes safe; adoption; handler usefulness |
| EP-09 | Market expansion | all | F-35, F-36, F-37 | Market enabled only when ready |

## 2. Stories

### EP-01 Intake & understanding

### US-01 — Connect an order mailbox and ingest messages · F-01 · EP-01 · SCR-15 · [R1] · P1 · M
**As an** AD, **I want** to connect a shared order mailbox **so that** customer messages enter the assistant without anyone forwarding them.
Depends on: US-37 · Emits: `message_received`
- **AC-01.1** `ui+api` — Given valid mailbox credentials, when AD saves and tests the connection, then the status shows *Connected* and the last-checked time.
- **AC-01.2** `api` — Given a connected mailbox, when a new message arrives, then within CP-01 it is stored once with its attachments and visible to users in the office scope.
- **AC-01.3** `api` (edge) — Given the same message is delivered twice (same Message-ID or identical content hash), when ingestion runs, then the second copy is marked *Duplicate* and no second draft is created.
- **AC-01.4** `ui+api` (error) — Given invalid or revoked credentials, when polling fails, then the status shows *Failed* with a short reason, no message is lost (it is retrieved after reconnection), and AD receives an alert.
- **AC-01.5** `api` (edge) — Given an attachment larger than CP-10 or of an unsupported type, when ingested, then the attachment is skipped with the label "Vedhæftning sprunget over" and the message is still processed.

### US-02 — Thread messages and filter out non-order mail · F-01 · EP-01 · non-UI (trigger: message ingested) · [R1] · P2 · S
**As an** OH, **I want** replies grouped and automatic mail ignored **so that** my queue contains only work.
Depends on: US-01
- **AC-02.1** `api` — Given a reply to an existing conversation, when ingested, then it is linked to the thread and the draft shows the thread.
- **AC-02.2** `api` — Given an out-of-office or delivery-failure notice, when ingested, then it is stored with status *Filtered* and does not appear in My queue.
- **AC-02.3** `ui+api` (edge) — Given a filtered message that is actually an order, when OH marks it "Mark as order", then it is processed as an order and the correction is stored (US-27).

### US-03 — Classify messages · F-02 · EP-01 · SCR-02, SCR-08 · [R1] · P1 · M
**As an** OH, **I want** each message classified as order, quote request, status request, complaint or other **so that** I only open the right ones in the right place.
Depends on: US-01 · Emits: `message_classified`
- **AC-03.1** `api` — Given an ingested message, when classification runs, then exactly one category and a confidence value are stored.
- **AC-03.2** `ui+api` — Given a message classified *order*, when it is processed, then a draft appears in My queue; given *status request*, it appears via SCR-07; given quote request, complaint (R1) or other, it appears in SCR-08 with the category chip.
- **AC-03.3** `ui+api` (edge) — Given a wrong category, when OH re-classifies it, then the message is routed accordingly and the correction is stored.
- **AC-03.4** `api` (error) — Given the classifier is unavailable, when a message arrives, then it is stored as *Manual* and shown in My queue with the original only (degraded mode, US-44).

### US-04 — Extract order content with per-field confidence · F-03 · EP-01 · non-UI (trigger: message classified *order*) · [R1] · P1 · L
**As an** OH, **I want** customer, site, lines, quantities, units and delivery wishes extracted **so that** I do not read and key them by hand.
Depends on: US-03, US-42 · Emits: `draft_created`
- **AC-04.1** `api` — Given an order message with text, PDF or Excel content, when extraction runs, then a draft is created containing customer reference, site, lines (description, quantity, unit), delivery wishes and a confidence value per field, each linked to the evidence span in the source.
- **AC-04.2** `ui` — Given a draft, when OH opens it, then each field shows its evidence in the message when selected (SCR-03).
- **AC-04.3** `api` (edge) — Given a field that cannot be found in the message, when the draft is built, then the field is empty and flagged *Missing*, never filled by guess.
- **AC-04.4** `api` (edge) — Given text in the message that gives instructions to the system, when extraction runs, then the text is treated as data, no instruction is followed, and the message is flagged *Suspicious content* for review (US-42).
- **AC-04.5** `api` (error) — Given the model returns output that fails schema validation, when extraction runs, then the draft is discarded, the message is routed to *Manual* and the failure is logged.

### US-05 — Split messages containing several orders · F-03 · EP-01 · SCR-03 · [R1] · P2 · S
**As an** OH, **I want** a message with several orders split into linked drafts **so that** each can be approved separately.
Depends on: US-04
- **AC-05.1** `ui+api` — Given a message with two distinct sites or delivery dates, when extraction runs, then two drafts are created, linked, and each shows "Del af samme besked" / "Part of the same message".
- **AC-05.2** `ui` (edge) — Given an incorrect split, when OH merges the drafts, then one draft holds all lines and the merge is stored as a correction.

### US-06 — Handle unreadable messages and attachments · F-01, F-03 · EP-01 · SCR-03, SCR-30 · [R1] · P2 · S
**As an** OH, **I want** a clear route when the assistant cannot read something **so that** nothing is silently lost.
Depends on: US-04
- **AC-06.1** `ui` — Given an unreadable or password-protected attachment, when OH opens the draft, then the notice "Vedhæftningen kan ikke åbnes." is shown and a template request for a new file is offered.
- **AC-06.2** `ui+api` (edge) — Given a message in an unsupported language (before R2), when ingested, then it is flagged *Unsupported language* and routed to manual handling.
- **AC-06.3** `api` (error) — Given extraction failure of any kind, when the item is stored, then it appears in My queue as *Manual* within the same time as normal drafts.

### EP-02 Matching, pricing & promise

### US-07 — Match lines to SKUs and normalise units · F-04 · EP-02 · SCR-03, SCR-04 · [R1] · P1 · L
**As an** OH, **I want** each line mapped to a catalogue SKU with a unit and confidence **so that** I confirm instead of searching.
Depends on: US-04, US-12 · Emits: `line_matched`
- **AC-07.1** `api` — Given an extracted line within the SKU scope (CP-scope in SCR-16), when matching runs, then up to three candidates with SKU number, description, unit and confidence are stored and the best candidate above its threshold is preselected.
- **AC-07.2** `ui` — Given a preselected line, when OH opens the draft, then the SKU, description and unit are visible with a text confidence label (Sikker / Tjek / Usikker).
- **AC-07.3** `api` (edge) — Given quantities expressed in different units (pieces, bundles, running metres), when matching runs, then quantities are converted using master-data conversion factors, both original and converted values are stored, and an unavailable factor flags the line *Unit unknown*.
- **AC-07.4** `api` (edge) — Given a line outside the SKU scope, when matching runs, then the line is marked *Outside scope* and sent to the exception queue without a candidate.
- **AC-07.5** `ui` (error) — Given no candidate above the lowest threshold, when OH opens the line, then the message "Ingen forslag. Søg i kataloget." is shown with a search box.

### US-08 — Use purchase history and customer-specific names in matching · F-04, F-17 · EP-02 · non-UI · [R1] · P1 · M
**As an** OH, **I want** matching to prefer what this customer usually buys and calls things **so that** shorthand resolves correctly.
Depends on: US-07, US-11
- **AC-08.1** `api` — Given an active alias for the customer, when a line text equals the alias, then the aliased SKU is the top candidate with the reason "Kundens betegnelse".
- **AC-08.2** `api` — Given purchase history for the customer, when two candidates tie, then the one bought more recently by this customer ranks higher.
- **AC-08.3** `api` (edge) — Given a new customer with no history, when matching runs, then only catalogue and generic logic are used and the draft is marked "Ny kunde – ingen historik".

### US-09 — Read contract price, stock and credit · F-05 · EP-02 · SCR-03 · [R1] · P1 · M
**As an** OH, **I want** the customer's contract price, stock and credit status shown per line **so that** I do not look them up.
Depends on: US-07, US-26 · Emits: `price_checked`
- **AC-09.1** `api` — Given a matched line and a customer, when the check runs, then the contract or project price, available stock and credit status are read from the ERP (read-only) and stored with a timestamp.
- **AC-09.2** `ui` — Given a customer-stated price that differs from the contract price, when OH opens the draft, then both prices are shown, the contract price is used, and the line is flagged "Prisafvigelse".
- **AC-09.3** `ui+api` (error) — Given the ERP is unreachable, when the check runs, then the fields show "Pris/lager kunne ikke hentes. Kontroller manuelt før godkendelse." and the Approve action stays disabled until OH ticks "Manuel kontrol udført".
- **AC-09.4** `api` — Given any price check, when it runs, then no ERP data is changed (read-only credentials and no write call exist in the price check path).

### US-10 — Propose a delivery date with a confidence level · F-06 · EP-02 · SCR-03 · [R1] · P2 · M
**As an** OH, **I want** a proposed delivery date with its confidence and reason **so that** the confirmation is believable.
Depends on: US-09
- **AC-10.1** `api` — Given stock status, customer delivery wishes and configured delivery calendar rules, when the proposal runs, then a date and a confidence level (Høj / Middel / Lav) with a reason text are stored.
- **AC-10.2** `ui` — Given a proposed date, when OH changes it, then the change is stored as a correction and the confirmation uses the new date.
- **AC-10.3** `ui` (edge) — Given stock shortfall on any line, when the proposal runs, then the date shows confidence Lav and the reason "Lager mangler på linje [n]".

### US-11 — Manage customer-specific names (aliases) · F-17 · EP-02 · SCR-10, SCR-04 · [R1] · P1 · M
**As an** OH, **I want** to save a customer's own name for an item **so that** future orders resolve automatically.
Depends on: US-07 · Emits: `alias_saved`
- **AC-11.1** `ui+api` — Given a resolved line in SCR-04, when OH ticks "Gem som kundens betegnelse" and approves, then an alias (customer, text, SKU) is created and visible in SCR-10.
- **AC-11.2** `ui+api` (edge) — Given an alias that would map the same text to two different SKUs for one customer, when saving, then it is blocked with the message "Betegnelsen findes allerede for en anden vare."
- **AC-11.3** `ui+api` — Given aliases above the policy threshold, when OH proposes one, then it becomes active only after OL approval; otherwise it is active immediately.
- **AC-11.4** `api` (authorisation) — Given a user without the OH, OL or AD role, when they call alias endpoints, then the response is 403 problem+json and nothing is changed.

### US-12 — Synchronise master data from the ERP · F-17, F-18 · EP-02 · non-UI (trigger: schedule) · [R1] · P1 · M
**As an** AD, **I want** catalogue, units, conversion factors and purchase history kept in sync **so that** matching uses current data.
Depends on: US-26 · Emits: `masterdata_synced`
- **AC-12.1** `api` — Given a scheduled sync, when it runs, then SKUs, units, conversion factors and customer purchase history in scope are updated and the sync time is stored.
- **AC-12.2** `ui+api` (error) — Given a failed sync, when the data age exceeds CP-09, then SCR-26 shows the component as degraded, AD receives an alert, and drafts show "Stamdata kan være forældet".
- **AC-12.3** `api` (edge) — Given a SKU withdrawn in the ERP, when synced, then it is excluded from new candidates but remains visible in existing drafts with a *Withdrawn* label.

### EP-03 Review & approval

### US-13 — See my queue · F-07 · EP-03 · SCR-02 · [R1] · P1 · S
**As an** OH, **I want** a prioritised queue of drafts **so that** I know what to do next.
Depends on: US-04
- **AC-13.1** `ui` — Given drafts in my office scope, when I open SCR-02, then drafts are listed with customer, age, line count and confidence chip, oldest first by default, with filters for status and confidence.
- **AC-13.2** `ui` (edge) — Given no drafts, when I open SCR-02, then "Ingen ordrer venter." is shown.
- **AC-13.3** `api` (authorisation) — Given a user from another office, when requesting the queue, then items outside their office scope are not returned.
- **AC-13.4** `ui` (error) — Given the API fails, when the page loads, then "Køen kunne ikke hentes." is shown with a Retry button.

### US-14 — Review a draft against the original message · F-07 · EP-03 · SCR-03, SCR-30 · [R1] · P1 · L
**As an** OH, **I want** to see the message and draft side by side with flagged fields first **so that** I can check quickly.
Depends on: US-13, US-07, US-09
- **AC-14.1** `ui` — Given a draft, when I open it, then the message (with attachments via SCR-30) is on the left and the draft on the right, and fields with confidence below threshold are listed first and marked with text and icon.
- **AC-14.2** `ui` — Given a field, when I select it, then its evidence span is highlighted in the message.
- **AC-14.3** `ui` (edge) — Given an attachment in Excel format, when I open it, then sheets and cells are readable and the source cell for a line is highlighted.
- **AC-14.4** `ui` — Given keyboard use only, when I review, then every action in SCR-03 is reachable and focus is visible.

### US-15 — Resolve a flagged line · F-04, F-07 · EP-03 · SCR-04 · [R1] · P1 · M
**As an** OH, **I want** to pick or search a SKU for a flagged line **so that** every line is confirmed before approval.
Depends on: US-14
- **AC-15.1** `ui+api` — Given a flagged line, when I select a candidate, then the line becomes *Confirmed* and the choice is stored as a correction.
- **AC-15.2** `ui+api` — Given no suitable candidate, when I search the catalogue by free text, then results show SKU number, description, unit, last bought by this customer and stock, and I can select one.
- **AC-15.3** `ui` (edge) — Given a stock shortfall, when I open the line, then I can choose Split, Backorder or Substitute and see the available quantity and next delivery date.
- **AC-15.4** `ui` (edge) — Given a quantity of zero or below, when I save the line, then "Mængde skal være større end 0." is shown and nothing is saved.
- **AC-15.5** `ui` — Given a line I cannot resolve, when I choose "Hold linje", then it is excluded from the order, listed as held on the draft, and included in the confirmation as "afventer afklaring".

### US-16 — Approve a draft · F-07 · EP-03 · SCR-03 · [R1] · P1 · M
**As an** OH, **I want** to approve a draft in one action **so that** the order is created and confirmed.
Depends on: US-14, US-22 · Emits: `draft_approved`, `draft_edited`
- **AC-16.1** `ui+api` — Given all required fields valid and no unconfirmed manual check, when I select Godkend, then the approval is recorded with my role, time and any edits, and the order moves to write-back (US-22).
- **AC-16.2** `ui` (edge) — Given a required field invalid, a flagged line unresolved, or a manual check unconfirmed, when I view the Approve action, then it is disabled with the reason listed.
- **AC-16.3** `api` — Given an approval with no edits, when stored, then the draft is counted as *approved without edits*; given any edit, then it is counted as *edited* (feeds the North Star).
- **AC-16.4** `api` (authorisation) — Given a user without OH or OL role in the office, when they call the approve endpoint, then 403 and nothing is stored.
- **AC-16.5** `api` (concurrency) — Given two approve requests for the same draft, when processed, then exactly one succeeds and the other returns 409 problem+json.

### US-17 — Reject, forward or reassign a draft · F-07 · EP-03 · SCR-06 · [R1] · P2 · S
**As an** OH, **I want** to reject, forward or reassign a draft with a reason **so that** it reaches the right person.
Depends on: US-13 · Emits: `draft_rejected`
- **AC-17.1** `ui+api` — Given an open draft, when I choose Reject with a reason, then the draft is closed with the reason stored and the message moves to SCR-08.
- **AC-17.2** `ui+api` — Given an open draft, when I reassign it to a user or team in my office, then it appears in their queue and an entry is added to the audit log.
- **AC-17.3** `ui` (edge) — Given I choose a user outside my office scope, when I confirm, then the option is not offered.

### US-18 — Prevent two handlers editing the same draft · F-07 · EP-03 · SCR-03 · [R1] · P2 · S
**As an** OH, **I want** a draft locked while a colleague works on it **so that** we do not duplicate effort.
Depends on: US-14
- **AC-18.1** `ui+api` — Given a draft opened by another handler, when I open it, then it is read-only with the banner "Åbnet af en kollega" and the lock owner's display name.
- **AC-18.2** `api` — Given a lock idle for CP-02, when another user opens the draft, then the lock is released and the new user obtains it.
- **AC-18.3** `api` (concurrency) — Given a stale edit from the former lock holder, when it is submitted, then 409 is returned and nothing is overwritten.

### US-19 — Work non-order messages · F-02 · EP-03 · SCR-08 · [R1] · P2 · S
**As an** OH, **I want** quote requests, complaints and other messages listed **so that** nothing is missed.
Depends on: US-03
- **AC-19.1** `ui` — Given messages classified quote request, complaint (R1) or other, when I open SCR-08, then they are listed with category, customer guess and age.
- **AC-19.2** `ui+api` — Given a message I handled outside the tool, when I mark it *Handled elsewhere*, then it leaves the list and the action is audited.
- **AC-19.3** `ui` (edge) — Given an empty list, when I open SCR-08, then "Ingen øvrige beskeder." is shown.

### US-20 — Answer status requests · F-10 · EP-03 · SCR-07 · [R1] · P2 · M
**As an** OH, **I want** a proposed answer to a status request **so that** I reply quickly and correctly.
Depends on: US-03, US-26 · Emits: `status_answer_sent`
- **AC-20.1** `ui+api` — Given a status request that identifies an order, when I open SCR-07, then the order status and expected delivery are read from the ERP and a proposed answer in the customer's language is shown.
- **AC-20.2** `ui+api` (edge) — Given the order cannot be identified, when I open SCR-07, then a request-for-order-number template is proposed.
- **AC-20.3** `ui` (edge) — Given several matching orders, when I open SCR-07, then I choose one from a list before the answer is built.
- **AC-20.4** `ui` (error) — Given the ERP is unavailable, when I open SCR-07, then "Status kunne ikke hentes." is shown and no answer is proposed.
- **AC-20.5** `api` — Given I send the answer, when it is sent, then it is stored with approver, time and the ERP data used.

### US-21 — See exceptions after the order · F-12 · EP-03 · SCR-09 · [R1] · P3 · S
**As an** OH, **I want** a read-only list of orders with missing site data or stock shortfall **so that** I can contact the customer.
Depends on: US-22
- **AC-21.1** `ui` — Given written orders with missing site data or shortfall, when I open SCR-09, then they are listed with the exception type and a link to the ERP order.
- **AC-21.2** `ui+api` — Given an exception I resolved, when I mark it resolved, then it leaves the list and the action is audited.
- **AC-21.3** `api` (edge) — Given an order cancelled in the ERP, when the list is refreshed, then its exception is closed automatically with a note.

### EP-04 ERP integration & confirmation

### US-22 — Write the approved draft to the ERP · F-08 · EP-04 · SCR-03 · [R1] · P1 · L
**As an** OH, **I want** the approved order created in the ERP **so that** I do not key it.
Depends on: US-16, US-26 · Emits: `erp_order_created`
- **AC-22.1** `api` — Given an approved draft outside shadow mode, when write-back runs, then one draft order is created in the ERP through the adapter and the ERP order number is stored on the draft.
- **AC-22.2** `ui` — Given success, when I view the draft, then the banner "Ordren er oprettet i ERP (nr. …). Bekræftelse sendt." is shown.
- **AC-22.3** `api` (edge) — Given the same approval is submitted twice, when write-back runs, then an idempotency key prevents a second ERP order.
- **AC-22.4** `api` (error) — Given the ERP rejects the order, when write-back fails, then the status is *Write failed*, the ERP error is stored, no confirmation is sent, and the draft remains in the queue.
- **AC-22.5** `api` — Given write-back succeeds, when finished, then the audit log records approver, draft version and ERP order number.

### US-23 — Retry and fall back when the write fails · F-08 · EP-04 · SCR-03, SCR-02 · [R1] · P1 · M
**As an** OL, **I want** failed writes retried and visible **so that** no approved order is lost.
Depends on: US-22
- **AC-23.1** `ui+api` — Given a *Write failed* draft, when OH or OL selects Retry, then write-back runs again with the same idempotency key.
- **AC-23.2** `api` — Given the API path fails and the RPA fallback is enabled, when write-back runs, then the fallback is tried once, and its outcome is recorded.
- **AC-23.3** `api` (edge) — Given the ERP reports that the order already exists, when write-back runs, then the existing ERP order number is stored and no second order is created.
- **AC-23.4** `api` — Given a draft in *Write failed* longer than CP-12, when evaluated, then OL receives an alert.

### US-24 — Send the customer confirmation · F-09 · EP-04 · SCR-05 · [R1] · P1 · M
**As an** OH, **I want** the confirmation sent to the customer after the order exists **so that** they know what to expect.
Depends on: US-22 · Emits: `confirmation_sent`
- **AC-24.1** `api` — Given a successful ERP write, when it completes, then a confirmation email with order number, lines, prices and delivery date is sent to the original sender, in the customer's language.
- **AC-24.2** `ui+api` — Given a required custom note, when I open the preview (SCR-05) and edit the text, then the edited text is sent and both versions are stored.
- **AC-24.3** `api` (error) — Given email sending fails, when the order exists, then the draft shows "Bekræftelsen kunne ikke sendes." with Retry, and the ERP order is not duplicated.
- **AC-24.4** `api` — Given a held line, when the confirmation is built, then it lists the line as "afventer afklaring".
- **AC-24.5** `api` (edge) — Given no confirmation may be sent in shadow mode, when a draft is approved in shadow mode, then no email is sent.

### US-25 — Manage confirmation and status templates · F-09, F-16 · EP-04 · SCR-17 · [R1] · P2 · S
**As an** AD, **I want** to maintain templates per language **so that** wording stays consistent.
Depends on: US-24
- **AC-25.1** `ui+api` — Given a template, when AD edits and saves it, then a new version is stored and used for later messages only.
- **AC-25.2** `ui` — Given a template with an unknown placeholder, when AD saves, then saving is blocked with the placeholder named.
- **AC-25.3** `ui` — Given a preview request, when AD selects Preview, then the template renders with sample data and no real customer data.
- **AC-25.4** `api` (error) — Given a template missing its subject, body, kind or language, when AD saves, then 422 problem+json with errors[] is returned and nothing is stored.

### US-26 — Provide ERP and mail adapters for the pilot market · F-18 · EP-04 · non-UI (trigger: any ERP or mailbox call) · [R1] · P1 · L
**As an** AD, **I want** all ERP and mail access to go through adapters **so that** other markets can be added without changing the core.
Depends on: —
- **AC-26.1** `api` — Given the Danish adapter set, when the core calls read-price, read-stock, read-credit, read-customer, read-catalogue, create-draft-order or read-order-status, then each call returns the contract-defined result or a typed error.
- **AC-26.2** `api` (error) — Given a timeout, when an adapter call exceeds its limit, then the call is retried per policy and then fails with a typed error; the core never hangs.
- **AC-26.3** `api` — Given the adapter's credentials, when reading, then they are read-only for price, stock, credit and catalogue and have draft-order creation as the only write permission.
- **AC-26.4** `api` (edge) — Given the adapter returns unexpected fields or formats, when parsed, then the response is rejected and logged without crashing.

### EP-05 Learning & measurement

### US-27 — Capture corrections as evaluation data · F-11 · EP-05 · non-UI (trigger: approval, edit, re-classification) · [R1] · P1 · M
**As an** AD, **I want** every correction stored **so that** accuracy can be measured and improved.
Depends on: US-16
- **AC-27.1** `api` — Given an edit, re-classification, merge or SKU change, when saved, then the original machine value, corrected value, field, draft version and model version are stored.
- **AC-27.2** `api` (edge) — Given a correction on a deleted message (retention), when retention runs, then the evaluation record keeps only non-personal fields.
- **AC-27.3** `api` — Given corrections, when exported for evaluation by AD, then no individual employee identifier is included.

### US-28 — Run evaluations per model and prompt version · F-11 · EP-05 · SCR-18 · [R1] · P1 · M
**As an** AD, **I want** to evaluate a model/prompt version on stored corrections **so that** changes are evidence-based.
Depends on: US-27, US-42
- **AC-28.1** `ui+api` — Given a version and an evaluation set, when AD starts an evaluation, then field accuracy, line-match accuracy and edit rate are computed and shown with the version.
- **AC-28.2** `ui` (edge) — Given no evaluation data, when AD opens SCR-18, then "Ingen evalueringsdata endnu." is shown.
- **AC-28.3** `api` (error) — Given the evaluation fails, when it stops, then the failure is stored and no partial scores are shown.

### US-29 — Run in baseline mode · F-14 · EP-05 · SCR-12, SCR-20 · [R1] · P1 · M
**As an** OL, **I want** to measure how orders arrive before the assistant acts **so that** targets are set from facts.
Depends on: US-01 · Emits: `baseline_sample`
- **AC-29.1** `ui+api` — Given an office in baseline mode, when messages arrive, then they are counted by channel and format and no draft is shown to handlers.
- **AC-29.2** `ui+api` — Given baseline mode, when OL opens SCR-12, then a banner says "Baseline-periode: tal er ikke assistentens resultater." and channel mix and volumes are shown.
- **AC-29.3** `ui` (edge) — Given AD or OL switches an office from baseline to shadow mode, when confirming, then a dialog states the effect and the change is audited.
- **AC-29.4** `api` — Given a sample request for 500 historical orders (weeks 1-2 plan), when the sample is imported from the ERP, then the credit notes coded wrong item/quantity/price are counted in the baseline.

### US-30 — Run in shadow mode and compare with human-entered orders · F-15 · EP-05 · SCR-13, SCR-14 · [R1] · P1 · L
**As an** OL, **I want** the assistant's drafts compared with what staff keyed **so that** we see accuracy before going live.
Depends on: US-04, US-09, US-29 · Emits: `shadow_compared`
- **AC-30.1** `api` — Given an office in shadow mode, when a draft is created, then it is never written to the ERP and no confirmation is sent.
- **AC-30.2** `api` — Given a human-entered ERP order for the same customer and message reference, when found, then it is linked to the draft and field-level differences are stored.
- **AC-30.3** `ui` — Given a comparison, when OL opens SCR-14, then differences are highlighted side by side with counts per field.
- **AC-30.4** `api` (edge) — Given no human order within CP-04, when evaluated, then the draft moves to *Unmatched* and OL can link orders manually (many drafts to one order allowed).
- **AC-30.5** `api` (authorisation) — Given an OH, when requesting comparison data, then the response is 403 (OL, AN, AD only).

### US-31 — Measurement dashboard · F-14 · EP-05 · SCR-12 · [R1] · P1 · M
**As an** OL, **I want** the plan's measures on one screen **so that** the go/no-go is evidence-based.
Depends on: US-27, US-32 · Emits: —
- **AC-31.1** `ui+api` — Given data, when I open SCR-12, then I see channel mix by order line, orders approved without edits (North Star), time to confirmation, handling time per order, line error rate, exception backlog, cost per processed order, by office and period.
- **AC-31.2** `ui` (edge) — Given fewer than CP-03 orders in a period, when displayed, then "For få data" replaces the figure.
- **AC-31.3** `api` (authorisation) — Given any role, when requesting metrics, then no endpoint returns data at employee level.
- **AC-31.4** `ui+api` — Given I export, when I choose CSV, then the file contains the displayed aggregates only.
- **AC-31.5** `ui` — Given no data, when I open SCR-12, then "Ingen data endnu." is shown.

### US-32 — Emit analytics events · F-28 · EP-05 · non-UI (trigger: each event) · [R1] · P2 · S
**As an** AN, **I want** events with no personal data **so that** stage metrics can be calculated.
Depends on: —
- **AC-32.1** `api` — Given each event in the Step 11 schema, when it occurs, then it is stored with event name, time, office, market and object ids, and no names, emails or message text.
- **AC-32.2** `api` (edge) — Given an event with an unknown property, when emitted, then it is rejected and logged.
- **AC-32.3** `api` — Given a stage metric defined in Step 08, when metrics are calculated, then each is derivable from stored events.

### EP-06 Operations & queue management

### US-33 — Manage the team queue · F-13 · EP-06 · SCR-11 · [R1] · P2 · M
**As an** OL, **I want** a team view of queue counts, ages and assignments **so that** I can balance work.
Depends on: US-13
- **AC-33.1** `ui` — Given items in my office, when I open SCR-11, then I see counts by status, age distribution, oldest item and assignments by team.
- **AC-33.2** `ui+api` — Given an item, when I reassign it, then it moves to the new assignee and the action is audited.
- **AC-33.3** `ui` (edge) — Given data older than CP-05, when displayed, then the banner "Data er ældre end 5 minutter." is shown.
- **AC-33.4** `api` (authorisation) — Given an OH calling team queue endpoints, then 403.
- **AC-33.5** `ui` — Given the screen, when displayed, then no per-person ranking or productivity figure appears.

### US-34 — Service timers and backlog alerts · F-13, F-22 · EP-06 · SCR-11 · [R1] · P2 · S
**As an** OL, **I want** a service timer on items and alerts when the backlog grows **so that** nothing waits unnoticed.
Depends on: US-33 · Emits: `backlog_alert`
- **AC-34.1** `ui+api` — Given a service timer on an item, when it expires, then the item is flagged *Overdue* on SCR-02 and SCR-11.
- **AC-34.2** `api` — Given the oldest unhandled item exceeds CP-12, when evaluated, then OL receives an alert.
- **AC-34.3** `api` (edge) — Given alerts already sent for the same condition, when re-evaluated, then no duplicate is sent until the condition clears.

### US-35 — Staff notifications and preferences · F-22 · EP-06 · SCR-23 · [R1] · P3 · S
**As an** OH, **I want** to choose how I am notified **so that** alerts fit my work.
Depends on: US-37
- **AC-35.1** `ui+api` — Given SCR-23, when I save channel (in-app/email) and digest time, then the preference is stored for my account only.
- **AC-35.2** `api` — Given notifications, when sent, then they contain counts and links only, never message content.
- **AC-35.3** `api` (edge) — Given nothing new, when the digest time arrives, then no digest is sent.

### US-36 — Complaint and return messages (R1 routing) · F-02 · EP-06 · SCR-08 · [R1] · P3 · S
**As an** OH, **I want** complaints visible and labelled **so that** they are not mistaken for orders.
Depends on: US-03
- **AC-36.1** `ui` — Given a complaint message, when listed in SCR-08, then the label "Reklamation" is shown and no draft order is created.
- **AC-36.2** `api` (edge) — Given a message that contains both an order and a complaint, when processed, then both a draft and an SCR-08 entry are created and linked.

### EP-07 Platform, security & compliance

### US-37 — Sign in with the company account and resolve roles · F-19 · EP-07 · SCR-01, SCR-19, SCR-28 · [R1] · P1 · M
**As a** staff member, **I want** to sign in with my company account **so that** I get the right access without a new password.
Depends on: —
- **AC-37.1** `ui+api` — Given a user in a mapped SSO group, when they sign in, then they land on My queue (OH/OL) or the dashboard (AN) or Admin (AD) with the roles and office scopes mapped to the group.
- **AC-37.2** `ui` (error) — Given a user in no mapped group, when they sign in, then SCR-28 shows "Du har ikke adgang." with the administrator contact.
- **AC-37.3** `ui+api` — Given an expired session, when the user acts, then they are returned to SCR-01 and, after sign-in, non-sensitive edits within CP-06 are restored.
- **AC-37.4** `api` — Given a removed group membership, when the user's next token refresh occurs, then access ends.
- **AC-37.5** `api` (security) — Given repeated failed token validation, when thresholds are reached, then the requests are rate-limited and logged.

### US-38 — Enforce office scope and role permissions · F-19 · EP-07 · SCR-19, SCR-28 · [R1] · P1 · M
**As an** AD, **I want** permissions enforced on the server **so that** users only see what their role and office allow.
Depends on: US-37
- **AC-38.1** `api` — Given each endpoint in the authorisation matrix, when called by each role, then the response is allow, own-office-only or 403 exactly as the matrix states.
- **AC-38.2** `api` — Given an AD who is not also an OH, when requesting draft or message content, then 403; configuration and audit endpoints are allowed.
- **AC-38.3** `api` (edge) — Given an object id from another office, when requested, then the response is 404 (no existence leak).

### US-39 — Audit log of approvals, writes and configuration · F-20 · EP-07 · SCR-21 · [R1] · P1 · M
**As an** AD, **I want** an audit log **so that** every approval, write and configuration change can be reviewed.
Depends on: US-38
- **AC-39.1** `api` — Given approvals, rejections, reassignments, ERP writes, template, threshold, model and role-mapping changes, mode switches and privacy actions, when they occur, then an audit event with actor role, time, object and before/after is stored.
- **AC-39.2** `ui+api` — Given SCR-21, when AD filters by event type, object and period, then matching events are listed and can be exported.
- **AC-39.3** `api` (immutability) — Given an audit event, when any user attempts to edit or delete it via the API, then the request is refused with 405/403 and nothing changes.
- **AC-39.4** `ui` — Given no events, when AD opens SCR-21, then "Ingen hændelser i perioden." is shown.

### US-40 — Retention and automatic deletion · F-20 · EP-07 · SCR-22 · [R1] · P1 · M
**As an** AD, **I want** messages deleted after the retention period **so that** personal data is not kept longer than necessary.
Depends on: US-01
- **AC-40.1** `ui+api` — Given a retention period CP-07, when AD saves it in SCR-22, then it is stored and audited.
- **AC-40.2** `api` — Given messages and attachments older than CP-07 without legal hold, when the daily job runs, then they are deleted, drafts keep only non-personal fields and the ERP order reference.
- **AC-40.3** `api` (edge) — Given a legal hold on a message, when the job runs, then it is not deleted.
- **AC-40.4** `api` (error) — Given a job failure, when it stops, then AD is alerted and nothing is partially deleted.

### US-41 — Handle data-subject requests for customer contacts · F-20 · EP-07 · SCR-22 · [R1] · P2 · M
**As an** AD, **I want** to find and delete or export a person's data **so that** we meet GDPR requests.
Depends on: US-40
- **AC-41.1** `ui+api` — Given a request type (access, rectification, deletion) and an email address, when AD registers it, then the system lists messages, drafts and aliases containing that address.
- **AC-41.2** `ui+api` — Given a deletion request, when AD executes it, then the personal data is erased or anonymised, ERP order references are kept, and a closing record is stored.
- **AC-41.3** `ui` (error) — Given deletion fails, when executing, then "Sletning mislykkedes. Intet er slettet." is shown.
- **AC-41.4** `api` (edge) — Given an access request, when executed, then the export contains only the requester's data.

### US-42 — Route all model calls through a guarded gateway · F-21 · EP-07 · non-UI (trigger: every model call) · [R1] · P1 · L
**As an** AD, **I want** one gateway for model calls **so that** prompts, privacy and safety are controlled.
Depends on: —
- **AC-42.1** `api` — Given a model call, when made, then the gateway applies the active prompt version, separates instructions from message content, validates output against a schema, and records model version, tokens and cost.
- **AC-42.2** `api` (security) — Given message content containing instructions aimed at the system, when processed, then no instruction is executed, the output is limited to the schema, and the message is flagged *Suspicious content*.
- **AC-42.3** `api` — Given personal data not needed for the task (for example signatures, phone numbers), when sent to the model, then it is redacted or removed before the call.
- **AC-42.4** `api` (error) — Given a provider timeout, when it occurs, then one retry is made and then the message is routed to *Manual*.
- **AC-42.5** `api` — Given the provider setting, when the region is not the configured EU region, then calls are refused.

### US-43 — Monitor component health and alert · F-24 · EP-07 · SCR-26 · [R1] · P2 · M
**As an** AD, **I want** health shown and alerts raised **so that** failures are noticed quickly.
Depends on: US-01, US-26, US-42
- **AC-43.1** `ui+api` — Given mailbox, ERP adapter, master-data sync and model components, when I open SCR-26, then each shows status and last check time.
- **AC-43.2** `api` — Given a component failure, when it persists beyond its limit, then AD receives an alert with component, time and link.
- **AC-43.3** `ui` (edge) — Given unavailable status data, when I open SCR-26, then "Status utilgængelig." is shown.

### US-44 — Degraded mode when the assistant is unavailable · F-23 · EP-07 · SCR-02 · [R1] · P2 · M
**As an** OH, **I want** messages still delivered to me when the assistant fails **so that** orders are never delayed by an outage.
Depends on: US-03
- **AC-44.1** `ui+api` — Given the model or extraction service is unavailable, when a message arrives, then it appears in My queue as *Manual* with the original only and the banner "Assistenten er midlertidigt utilgængelig. Beskeder behandles manuelt." is shown.
- **AC-44.2** `api` (edge) — Given recovery, when the service returns, then queued *Manual* messages are not re-processed unless a user selects "Prøv assistenten".
- **AC-44.3** `ui` — Given manual items, when OH works them, then the KPIs count them as manual, not as assistant results.

### US-45 — Accessibility of the review workspace · F-25 · EP-07 · SCR-02..SCR-05 · [R1] · P2 · M
**As an** OH using assistive technology, **I want** the review workspace to be accessible **so that** I can do the job.
Depends on: US-14
- **AC-45.1** `ui` — Given keyboard-only use, when I complete the path queue → review → approve, then every step is operable with visible focus.
- **AC-45.2** `ui` — Given a screen reader, when I open a draft, then fields, confidence labels and errors are announced with labels.
- **AC-45.3** `ui` — Given the interface, when contrast is measured, then text and controls meet the stated WCAG 2.2 AA commitment and confidence is never conveyed by colour alone.
- **AC-45.4** `ui` (edge) — Given browser zoom at 200% or a narrow window, when I use SCR-02..SCR-05, then no content or action is lost and no horizontal scrolling is needed for the main text.

### EP-08 Administration & product support

### US-46 — Configure SKU scope and confidence thresholds · F-16 · EP-08 · SCR-16 · [R1] · P1 · M
**As an** AD, **I want** to set the SKU scope and thresholds and test them **so that** the assistant acts only where it is reliable.
Depends on: US-28
- **AC-46.1** `ui+api` — Given a scope definition (for example top ~2,000 SKUs), when AD saves it, then matching uses only that scope and the change is audited.
- **AC-46.2** `ui+api` — Given a new threshold set, when AD tests it on the evaluation set, then expected review volume and edit rate are shown before activation.
- **AC-46.3** `ui` (error) — Given an invalid threshold (outside 0-1 or inconsistent order), when saving, then it is blocked with the reason.
- **AC-46.4** `api` (authorisation) — Given a non-AD user, when calling the endpoints, then 403.

### US-47 — Manage model and prompt versions · F-16, F-21 · EP-08 · SCR-18 · [R1] · P1 · M
**As an** AD, **I want** to activate and roll back versions **so that** a bad change can be undone fast.
Depends on: US-28, US-42
- **AC-47.1** `ui+api` — Given a version with evaluation results, when AD activates it, then new messages use it and the audit log records who and when.
- **AC-47.2** `ui+api` — Given an active version, when AD rolls back, then the previous version is active immediately for new messages.
- **AC-47.3** `ui` (edge) — Given a version without evaluation results, when AD tries to activate, then a confirmation dialog warns "Ingen evaluering".

### US-48 — Markets and feature flags · F-16 · EP-08 · SCR-20 · [R1] · P2 · S
**As an** AD, **I want** per-market feature flags **so that** capabilities are enabled only where ready.
Depends on: US-38
- **AC-48.1** `ui+api` — Given a flag, when AD toggles it, then the change applies to the market and is audited.
- **AC-48.2** `ui` (edge) — Given only Denmark enabled, when AD opens SCR-20, then "Kun Danmark er aktiveret." is shown.
- **AC-48.3** `api` — Given a disabled flag, when its feature is called, then the response is 404 or the feature is absent in the UI.

### US-49 — Help, onboarding and trust statement · F-26 · EP-08 · SCR-24, SCR-29 · [R1] · P2 · S
**As an** OH, **I want** to understand what the assistant does and does not do **so that** I trust and use it.
Depends on: US-37
- **AC-49.1** `ui` — Given first sign-in, when I arrive, then the onboarding checklist (SCR-29) is shown with steps and progress.
- **AC-49.2** `ui` — Given SCR-24, when I open it, then it states what the assistant does and "Assistenten overvåger ikke enkeltpersoner."
- **AC-49.3** `ui+api` (edge) — Given I skip the checklist, when I later open Help, then I can resume it and progress is stored per user without being reported to management.

### US-50 — Feedback and usefulness pulse · F-27 · EP-08 · SCR-25 · [R1] · P3 · S
**As an** OH, **I want** to send feedback and rate usefulness **so that** the team improves the tool.
Depends on: US-37 · Emits: `pulse_answered`
- **AC-50.1** `ui+api` — Given SCR-25, when I send text and a 1-5 rating, then it is stored; ratings are reported only as team aggregates above CP-03 respondents.
- **AC-50.2** `ui` (error) — Given a failure, when sending, then "Kunne ikke sendes." is shown with Retry.
- **AC-50.3** `ui` — Given I skip, when I close the modal, then nothing is stored.

### US-51 — Language, status, maintenance and error pages · F-23 · EP-08 · SCR-23, SCR-26, SCR-27, SCR-28 · [R1] · P2 · S
**As a** user, **I want** the interface in my language and clear status and error pages **so that** I am never stuck.
Depends on: US-37
- **AC-51.1** `ui` — Given Danish or English selected in SCR-23, when I use the app, then all fixed UI text appears in that language.
- **AC-51.2** `ui` — Given planned maintenance, when I open the app, then SCR-27 shows the end time.
- **AC-51.3** `ui` (error) — Given an unknown route or failure, when it occurs, then SCR-28 shows "Siden findes ikke." or an error code to quote.

### R2 stories

### US-52 — Ingest phone and voicemail transcripts · F-29 · EP-01 · SCR-31, SCR-03 · [R2] · P1 · L
**As an** OH, **I want** phone and voicemail orders to arrive as drafts **so that** all channels are handled the same way.
Depends on: US-04
- **AC-52.1** `api` — Given a transcript delivered by the telephony integration, when received, then it is stored with a *Speech-to-text* label and processed like an order message.
- **AC-52.2** `ui` — Given the draft, when I open it, then the transcript is shown beside the draft with evidence highlighted.
- **AC-52.3** `api` (error) — Given a transcript below the quality threshold, when processed, then it is routed to *Manual* with the notice "Lav transskriptionskvalitet".

### US-53 — Ingest photo and image orders · F-29 · EP-01 · SCR-31 · [R2] · P1 · L
**As an** OH, **I want** photos of handwritten lists processed **so that** site-originated orders are not re-keyed.
Depends on: US-04
- **AC-53.1** `api` — Given an image attachment, when processed, then text is read and lines extracted with confidence.
- **AC-53.2** `ui` (error) — Given an unreadable image, when I open it, then "Billedet er for utydeligt." is shown with a request-resend template.
- **AC-53.3** `api` (edge) — Given an image that contains no order, when processed, then it is classified *other*.

### US-54 — Process EDI change messages · F-29 · EP-01 · SCR-03 · [R2] · P2 · M
**As an** OH, **I want** EDI change messages interpreted **so that** changes to existing orders are drafted for approval.
Depends on: US-04, US-22
- **AC-54.1** `api` — Given an EDI change for an existing ERP order, when received, then a change draft is created linking the order and listing differences.
- **AC-54.2** `ui+api` — Given a change draft, when OH approves, then the change is applied through the adapter and audited.
- **AC-54.3** `api` (error) — Given the referenced order does not exist, when processed, then the message is routed to *Manual*.

### US-55 — Acknowledge and route complaints and returns · F-30 · EP-06 · SCR-32 · [R2] · P2 · M
**As an** OH, **I want** complaints classified with a draft acknowledgement and a case **so that** customers hear back and cases are tracked.
Depends on: US-03
- **AC-55.1** `ui+api` — Given a complaint or return message, when classified, then a case is created with category and a linked order if identified.
- **AC-55.2** `ui+api` — Given a case, when I send the draft acknowledgement, then it is sent in the customer's language and logged on the case.
- **AC-55.3** `ui` (edge) — Given a message containing an order and a complaint, when processed, then both a draft and a case are created.
- **AC-55.4** `api` — Given a case, when closed, then the closure is audited; no claim or credit note is created (outside scope).

### US-56 — Match against the full catalogue · F-31 · EP-02 · SCR-16 · [R2] · P1 · M
**As an** AD, **I want** matching extended to the whole catalogue **so that** fewer lines are outside scope.
Depends on: US-46
- **AC-56.1** `ui+api` — Given AD extends the scope, when evaluated on the evaluation set, then accuracy by scope is shown before activation.
- **AC-56.2** `api` — Given activation, when matching runs, then lines outside the earlier scope receive candidates.
- **AC-56.3** `api` (edge) — Given a drop in accuracy beyond the guardrail after activation, when detected, then AD is alerted and may roll back.

### US-57 — Process additional languages · F-31 · EP-01 · SCR-17 · [R2] · P2 · M
**As an** OH, **I want** Swedish, Norwegian and English messages handled **so that** cross-border customers are served.
Depends on: US-04, US-25
- **AC-57.1** `api` — Given a message in an enabled language, when processed, then extraction and matching run and the language is stored.
- **AC-57.2** `ui+api` — Given the customer's language, when a confirmation is sent, then the matching template is used.
- **AC-57.3** `api` (edge) — Given a mixed-language message, when processed, then the language is recorded per line.

### US-58 — Define an auto-approval policy · F-32 · EP-03 · SCR-33 · [R2] · P2 · L
**As an** AD, **I want** eligible drafts written without a click **so that** handlers focus on exceptions.
Depends on: US-16, US-31
- **AC-58.1** `ui+api` — Given a policy (customer group, minimum confidence, maximum order value, excluded categories), when AD saves it, then it is versioned and audited.
- **AC-58.2** `api` — Given a draft that meets the policy, when created, then it is approved automatically with the policy version recorded and the confirmation process follows US-22 and US-24.
- **AC-58.3** `api` (edge) — Given a draft with any flagged line, a price deviation or a new customer, when evaluated, then it is never auto-approved.
- **AC-58.4** `api` (authorisation) — Given a user who is not AD, when calling the policy endpoints, then 403.

### US-59 — Sample auto-approved orders and stop on error · F-32 · EP-03 · SCR-33, SCR-02 · [R2] · P2 · M
**As an** OL, **I want** a sample of auto-approved orders reviewed and a kill switch **so that** errors are caught.
Depends on: US-58 · Emits: `auto_approval_paused`
- **AC-59.1** `api` — Given auto-approved orders, when the sampling rate CP-08 applies, then that share is placed in a review queue after the fact.
- **AC-59.2** `ui+api` — Given a sampled order with an error, when OH marks it wrong, then auto-approval pauses for that customer group and OL is alerted.
- **AC-59.4** `api` (edge) — Given the kill switch is active, when an otherwise eligible draft is created, then it follows normal review and is not auto-approved.
- **AC-59.3** `ui+api` — Given the kill switch, when AD selects Pause all, then no new draft is auto-approved and the action is audited.

### US-60 — Use an ML-based delivery estimate · F-33 · EP-02 · SCR-35 · [R2] · P3 · M
**As an** AD, **I want** to activate an ML delivery estimate once enough data exists **so that** dates are more accurate.
Depends on: US-10
- **AC-60.1** `ui` — Given fewer than six months of delivery history, when AD opens SCR-35, then "Mindre end 6 måneders historik. Ikke tilgængelig." is shown and activation is disabled.
- **AC-60.2** `ui+api` — Given enough history, when AD compares the ML and rule-based estimates on stored data, then accuracy for both is shown before activation.
- **AC-60.3** `api` (error) — Given the ML service fails, when a date is needed, then the rule-based estimate is used.

### US-61 — Tune the model from corrections with a release gate · F-34 · EP-05 · SCR-34 · [R2] · P2 · L
**As an** AD, **I want** a candidate model evaluated against the current one **so that** only improvements are released.
Depends on: US-27, US-28, US-47
- **AC-61.1** `ui+api` — Given stored corrections, when AD starts tuning, then a candidate is produced and evaluated on a held-out set.
- **AC-61.2** `ui+api` — Given a candidate that does not beat the current model on the agreed measures, when AD tries to release, then release is blocked with the comparison shown.
- **AC-61.3** `ui+api` — Given a released candidate, when AD rolls back, then the previous model is active immediately.
- **AC-61.4** `api` (edge) — Given corrections from messages deleted by retention, when tuning, then only non-personal fields are used.

### R3 stories

### US-62 — Enable a market only when it is ready · F-35, F-36 · EP-09 · SCR-36, SCR-20 · [R3] · P1 · M
**As an** AD, **I want** a readiness checklist before a market goes live **so that** adapters, language, templates and consultation steps are complete.
Depends on: US-48
- **AC-62.1** `ui+api` — Given a market, when AD opens SCR-36, then the checklist shows adapters tested, language and templates reviewed, thresholds evaluated and the consultation step recorded as complete by an authorised user.
- **AC-62.2** `api` (edge) — Given an incomplete checklist, when AD tries to enable the market, then the request is refused with 409 problem+json listing the open items.
- **AC-62.3** `api` — Given enablement, when completed, then office scopes and flags for the market are created and audited.

### US-63 — Norway adapter set · F-35 · EP-09 · non-UI (trigger: market enabled) · [R3] · P1 · L
**As an** AD, **I want** Norwegian ERP and mail adapters and language **so that** Norwegian offices can use the assistant.
Depends on: US-26, US-62, (D-03 accepted-risk)
- **AC-63.1** `api` — Given the Norwegian adapter set, when the core calls any adapter operation of US-26, then results follow the same contract.
- **AC-63.2** `api` — Given a Norwegian message, when processed, then Norwegian language handling and templates apply.
- **AC-63.3** `api` (edge) — Given adapter operations that Norwegian systems cannot support, when called, then a typed *Unsupported* error is returned and the item is routed to *Manual*.

### US-64 — Sweden adapter set · F-36 · EP-09 · non-UI (trigger: market enabled) · [R3] · P1 · L
**As an** AD, **I want** Swedish ERP and mail adapters and language **so that** Swedish offices can use the assistant.
Depends on: US-26, US-62, (D-03 accepted-risk)
- **AC-64.1** `api` — Same contract tests as AC-63.1 for the Swedish adapter set.
- **AC-64.2** `api` — Given a Swedish message, when processed, then Swedish language handling and templates apply.
- **AC-64.3** `api` (edge) — Given unsupported operations, when called, then a typed *Unsupported* error is returned and the item routed to *Manual*.

### US-65 — Sweden proactive delivery exceptions · F-37 · EP-09 · SCR-37 · [R3] · P3 · M
**As an** OH in Sweden, **I want** delivery exceptions from the transport tool listed **so that** I can inform customers early.
Depends on: US-64, (D-18 decided)
- **AC-65.1** `api` — Given an exception event from the connected transport-visibility tool (delay, missing site data), when received, then a DeliveryException item is created and linked to the ERP order.
- **AC-65.2** `ui+api` — Given an item, when I send the pre-approved notice, then it is sent in the customer's language and logged.
- **AC-65.3** `api` (error) — Given the tool is unavailable, when polling, then the status page shows degraded and no item is lost on recovery.

## 3. Slice plan
| Slice | Release | Stories | Screens | Endpoints / entities (indicative; Step 11 authoritative) |
|---|---|---|---|---|
| SL-1 Walking skeleton | R1 | US-37, US-01 (ingest via test mailbox), US-04 (single-path extraction), US-13, US-14 (basic), US-16, US-22 (stub adapter), US-24 | SCR-01, 02, 03, 05 | auth, messages, drafts, approve, write-back, confirmation; Message, Draft, User, AuditEvent |
| SL-2 Matching, pricing, promise | R1 | US-07, US-08, US-09, US-10, US-11, US-12, US-15 | SCR-04, SCR-10 | candidates, prices, aliases, sync; SKU, ContractPrice, Alias |
| SL-3 Review completeness | R1 | US-02, US-03, US-05, US-06, US-17, US-18, US-19, US-20, US-21, US-36 | SCR-06..09, SCR-30 | classification, locks, status requests, exceptions |
| SL-4 ERP and mail adapters (production) | R1 | US-26, US-23, US-25, US-44 | SCR-17, SCR-26 | adapter contracts, retry, templates, degraded mode |
| SL-5 Measurement, baseline, shadow | R1 | US-27, US-28, US-29, US-30, US-31, US-32 | SCR-12..14, SCR-18 | corrections, evaluation, comparison, metrics |
| SL-6 Admin and platform | R1 | US-38, US-39, US-40, US-41, US-42, US-43, US-46, US-47, US-48 | SCR-15..SCR-22, SCR-20 | configuration, audit, privacy, gateway, health |
| SL-7 Operations and support | R1 | US-33, US-34, US-35, US-45, US-49, US-50, US-51 | SCR-11, 23..29 | team queue, notifications, help, accessibility |
| SL-8 Channels and intelligence | R2 | US-52, US-53, US-54, US-55, US-56, US-57 | SCR-31, SCR-32 | new channels, cases, catalogue, languages |
| SL-9 Autonomy and tuning | R2 | US-58, US-59, US-60, US-61 | SCR-33..35 | policy, sampling, ML estimate, tuning |
| SL-10 Market expansion | R3 | US-62, US-63, US-64, US-65 | SCR-36, SCR-37 | readiness, adapters, delivery exceptions |
SL-1 contains the walking skeleton and the critical path to the aha moment (SCR-01 → 02 → 03 → approve → confirmation).

## 4. Definition of Done
As `templates/dod-checklist.md`, adapted to the product: Playwright for `ui`, integration tests (Testcontainers) for `api`, contract test against `openapi.yaml`, Flyway migrations, authorisation tests per role, accessibility checks (SCR-02..05 WCAG 2.2 AA), analytics events per schema, problem+json errors, structured logs with correlation IDs, only the generated API client in the frontend, and — specific to this product — an automated test that no endpoint or log exposes employee-level metrics (R-26).

## 5. Count summary
| | R1 | R2 | R3 | Total |
|---|---|---|---|---|
| Epics | 9 (EP-09 holds R3 stories) | — | — | 9 |
| Features | 28 | 6 | 3 | 37 |
| Stories | 51 | 10 | 4 | 65 |
| ACs | 191 | 34 | 12 | 237 |

(Counted from the story lists above by script.)

## Open decisions raised at this step
All decisions raised here were resolved at the Step 12 closure (see `_decisions.md` and `05-deliver/12-closure-log.md`).

## Deliverables checklist
- [x] Every in-scope F-ID has ≥ 1 story; every story has an F-ID and SCR-IDs or a non-UI trigger
- [x] Every story has ≥ 2 ACs incl. ≥ 1 edge/error AC; every AC has a verification layer
- [x] Authorisation ACs where roles differ
- [x] SL-1 is a walking skeleton plus the critical path
- [x] No demo-only stories; no sprint estimates
