# Screens — inventory, states and critical path (all releases)

Source: `04-specify/09-solution-design.md` (owner). Copy is Danish with English gloss; further languages arrive with markets.

## 1. To-be journey, aha moment and critical path

| Stage | Steps with the product | Pain removed | Screen |
|---|---|---|---|
| Mandate/Rollout | OL and AD configure mailboxes and thresholds; OH sees what the assistant does and does not do | trust, R-26 | SCR-15..SCR-19, SCR-24, SCR-29 |
| DEC | 1. Message arrives and is classified. 2. A draft appears in My queue with customer, site, lines, prices, delivery date and confidence. 3. OH opens the review workspace, checks flagged lines, approves. 4. The order is written to the ERP. 5. Confirmation is sent to the customer. | P-09, P-10, P-11 | SCR-02, SCR-03, SCR-04, SCR-05 |
| RET | Exceptions after the order are listed; corrections feed learning; OL watches the queue and measures | P-01, P-04 (via O-03), O-04 | SCR-09, SCR-11, SCR-12 |
| ADV | OH answers a short usefulness pulse | — | SCR-25 |

**Aha moment:** OH approves the first draft in the review workspace with one click and sees the confirmation go out.
**Critical path (first build slice):** SCR-01 sign in → SCR-02 My queue → SCR-03 Review workspace → approve → (write-back, confirmation, SCR-05 preview when required). Behind it, non-UI: mailbox connector → classification → extraction → matching → price/stock check → delivery proposal.

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
