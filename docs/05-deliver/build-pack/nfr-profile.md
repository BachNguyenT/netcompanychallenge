# Production NFR Profile, Compliance, PII and Retention

Source: `04-specify/11-solution-architecture.md` (owner). Targets marked accepted were proposed by the pipeline and accepted by the user at closure (D-28); legal inputs are go-live gates (D-33, D-34).

## 8. Security model
- **Authentication:** company OIDC; backend is an OAuth2 resource server validating issuer, audience, expiry and signature (JWKS cache); groups → roles/offices through `role_mappings` (US-37). Access-token lifetime as issued by the IdP; app session idle timeout 30 min, absolute 12 h (accepted, D-28). Service principals for inbound webhooks (Graph validation token + clientState; bearer service tokens for R2/R3).
- **Authorisation:** server-side per `authorisation-matrix.md` (98 rows × 4 roles + anonymous + system); office scoping on every query (`office_id IN scopes`), 404 outside scope; AD does not read draft/message content unless also OH (D-22).
- **Input and output safety:** all inputs validated (Bean Validation mirroring the schema); message content is untrusted data: separated from instructions, model outputs validated against a JSON schema, no tool/function execution by the model, ERP access read-only except draft-order creation (US-26 AC-26.3), human approval before any write (ADR-02, S-055).
- **Rate limiting:** per user 120 req/min and per integration endpoint 60 req/min, returning 429 problem+json (accepted, D-28).
- **CORS:** same-origin through the proxy; no wildcard origins.
- **Secrets:** platform secrets manager; mailbox credentials stored as references (`secret_ref`); no secrets in the database, logs or images.
- **Audit:** every approval, write, mode switch, configuration and privacy action (US-39); append-only trigger.
- **Dependency and code scanning:** dependency scanning (OWASP Dependency-Check or equivalent) and container scanning in CI; SAST on pull requests.

## 9. Production NFR profile
Full tables are in `build-pack/nfr-profile.md` (this section). **Accepted (D-28)** = my proposal, accepted at closure; Company A volumes are unknown (R-06, D-24), so capacity rows follow the labelled illustrative model R-31.

### 9.1 Security
| Requirement | Standard | Target | Verification |
|---|---|---|---|
| Authentication | OIDC via company IdP | No local passwords; MFA as per IdP policy | Integration test with test IdP; configuration review |
| Authorisation | Authorisation matrix | 100% of operations × roles tested | Generated test per matrix row (DoD) |
| Input validation | OWASP ASVS L1 | All inputs validated server-side | ASVS L1 checklist; fuzz tests on ingest |
| LLM-specific risks | OWASP LLM Top 10 (S-055) | Prompt-injection suite passes (no action outside schema) | Red-team test set in shadow mode (RK-08) |
| Encryption at rest | AES-256 managed | DB, object store, backups encrypted | Provider configuration evidence |
| Encryption in transit | TLS 1.2+ | All hops | Scanner (SSL Labs-type) |
| Dependency scanning | CI | No unresolved critical/high at release | CI gate |
| Session management | httpOnly, secure cookies | Idle 30 min, absolute 12 h (accepted, D-28) | Test |

### 9.2 Accessibility
WCAG 2.2 AA on SCR-01..SCR-30; keyboard navigable; screen-reader labels; contrast ≥ 4.5:1; visible focus; confidence never by colour alone. Verification: axe in Playwright on every screen + manual keyboard test of the critical path.

### 9.3 Performance (accepted, D-28)
| Metric | Target | Measurement |
|---|---|---|
| Message arrival → draft in queue | p95 ≤ 5 min (CP-01 polling 60 s + processing), excluding provider outages | `message_received` → `draft_created` events |
| Review workspace open | p95 ≤ 1.5 s | RUM / Playwright |
| LCP on office network | ≤ 2.5 s | Lighthouse CI |
| API read p95 / p99 | ≤ 400 ms / ≤ 1 s | Micrometer |
| API write p95 (excl. async ERP) | ≤ 800 ms | Micrometer |
| DB query p95 | ≤ 100 ms | pg_stat_statements |
| Error rate | < 1% 5xx | Metrics |
No external benchmark sources were found for these targets; they are engineering proposals.

### 9.4 Reliability (accepted, D-28)
| Requirement | Target | Measurement |
|---|---|---|
| Availability | 99.5% monthly, measured Mon-Fri 06:00-18:00 Danish time | Synthetic probes |
| MTTR | ≤ 4 h | Incident log |
| Rollback | Previous image redeployable ≤ 15 min; migrations expand/contract | Release drill |
| Backups | Continuous WAL + daily snapshot; RPO ≤ 15 min, RTO ≤ 4 h | Restore test before go-live and quarterly |
| Degraded mode | Messages continue to arrive as *Manual* when AI is down (US-44) | Fault-injection test |

### 9.5 Scalability (capacity assumptions from R-31, not forecasts)
| Scenario | Load | Approach |
|---|---|---|
| Launch (pilot office) | up to 500 messages/day, 20 concurrent users | Single API + worker instance each, one DB |
| 6 months | up to 2,000 messages/day, 60 concurrent users | Scale workers horizontally; read replica optional |
| 12 months (Denmark, illustrative 300 stores × 20 orders) | up to 6,000 orders/day, 300 concurrent users | Partition metric_events by month; queue concurrency; LLM batching limits |
LLM cost per message is **not estimated here**: it is measured in shadow mode (cost metering, US-42) before any business-case figure uses it.

### 9.6 Configurable parameters CP-01..CP-12 (defaults accepted, D-28)
| CP | Parameter | Default |
|---|---|---|
| CP-01 | Mailbox polling interval (webhook plus poll fallback) | 60 s |
| CP-02 | Draft lock idle timeout | 15 min |
| CP-03 | Small-sample suppression threshold | 10 orders (metrics) / 10 respondents (pulse) |
| CP-04 | Shadow-mode unmatched window | 48 h |
| CP-05 | Data-staleness banner | 5 min |
| CP-06 | Session-restore window | 5 min |
| CP-07 | Retention: messages and attachments | 90 days after processing (drafts keep non-personal fields 24 months, audit 24 months, evaluation data non-personal indefinitely) — legal basis to be confirmed by Company A's DPO (D-33) |
| CP-08 | Auto-approval sampling rate | 10% |
| CP-09 | Master-data freshness limit | 24 h |
| CP-10 | Attachment size limit | 25 MB per file, 50 MB per message |
| CP-11 | Default confidence thresholds | classification ≥ 0.80, field ≥ 0.80, line match ≥ 0.85, review below 0.95 (replaced by evaluation results before go-live) |
| CP-12 | Exception-backlog alert threshold | oldest unhandled item > 4 working hours |

## 10. Compliance, PII register and retention
### 10.1 Applicable regulations
| Regulation | Applies? | Trigger |
|---|---|---|
| GDPR (EU/EEA) | Yes | Customer contacts' data in emails; staff identifiers |
| Datatilsynet guidance and supervision (S-014, S-064) | Yes (Denmark) | DPIA for AI processing; employee-monitoring scrutiny avoided by design (R-26) |
| EU AI Act (S-060) | Yes, classification to confirm | Company A is a deployer of a GPAI-based system; AI literacy duty since 2 Feb 2025; Article 50 transparency from 2 Aug 2026 (customers receive confirmations drafted with AI and approved by a person; wording of any AI disclosure to be confirmed by legal, D-34) |
| Employee consultation rules | NO (WEA ch. 9, S-012), SE (MBL §11, S-013); Danish rules not researched | Relevant when expanding (R3); control measures avoided by design |
| Danish bookkeeping law | Not researched | ERP, not this product, holds the accounting record; to confirm with Company A (D-33) |

### 10.2 PII register
| Entity.field | Subject | Purpose | Legal basis (proposed; DPO to confirm, D-33) | Retention | Access |
|---|---|---|---|---|---|
| messages.from_address, from_name, body_text; attachment content in object store | Customer contacts (business emails, may include sole traders) | Interpret and fulfil orders; audit | Legitimate interests / contract performance | CP-07 | OH, OL (office scope) |
| customer_contacts.email, name, phone; sites.contact_name, contact_phone | Customer contacts | Send confirmations; site delivery coordination | Same | Mirrors ERP sync; deleted via DSR | OH, OL |
| customers.name | Sole traders | Order identification | Same | Mirrors ERP | OH, OL |
| dsr_requests.subject_email | Requesters | Handle data-subject requests | Legal obligation | 24 months after closure | AD |
| app_users.display_name, email; *_user_id columns; audit_events.actor_user_id | Staff | Authentication, attribution of approvals, audit | Employment / legitimate interests | Account life + 24 months for audit | AD (audit), own user |
| feedback.text | Staff | Product improvement | Consent | 12 months | AD |
Redaction before model calls (US-42 AC-42.3): signatures, phone numbers and unrelated personal data are removed before text leaves the platform. Data-subject export/deletion: US-41. Breach notification process: Company A's incident process; the product raises alerts (F-24).
### 10.3 Data processing agreements needed
| Vendor | Data shared | DPA status |
|---|---|---|
| LLM provider | Redacted message text and attachments | Needed; SCCs if third-country access (S-062) — D-19 |
| Cloud hosting + managed PostgreSQL + object storage | All stored data | Needed — D-30 |
| Mail platform (Microsoft 365 default) | Mailbox content | Company A's existing agreement — D-29 |
| Error tracking | Stack traces with no message text | Needed if used (scrubbing enforced) |
| R2 vendors (telephony transcription, vision) | Voice transcripts, images | Needed — D-31 |
