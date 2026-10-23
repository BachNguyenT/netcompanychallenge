-- Order Intake Assistant — physical schema (PostgreSQL 16 + pg_trgm + pgvector)
-- Becomes Flyway V1__baseline.sql in Step 23. Authoritative for tables and columns.
-- Conventions: UUID primary keys (gen_random_uuid), timestamptz, snake_case, enums as text + CHECK,
-- audit columns created_at/updated_at where rows are mutable, no employee-level metric tables (R-26).
-- The PostgreSQL-backed job queue library (db-scheduler or JobRunr, ADR-06) adds its own tables via its own migration.

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS vector;

-- ---------------------------------------------------------------- markets, offices, users
CREATE TABLE markets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code            text NOT NULL UNIQUE CHECK (code IN ('DK','NO','SE')),
  name            text NOT NULL,
  enabled         boolean NOT NULL DEFAULT false,
  language_codes  text[] NOT NULL DEFAULT '{}',
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE offices (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id    uuid NOT NULL REFERENCES markets(id),
  code         text NOT NULL UNIQUE,
  name         text NOT NULL,
  mode         text NOT NULL DEFAULT 'baseline' CHECK (mode IN ('baseline','shadow','live')),
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_offices_market ON offices(market_id);

CREATE TABLE app_users (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  idp_subject   text NOT NULL UNIQUE,
  display_name  text NOT NULL,          -- personal (staff)
  email         text NOT NULL,          -- personal (staff)
  status        text NOT NULL DEFAULT 'active' CHECK (status IN ('active','disabled')),
  last_seen_at  timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE role_mappings (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  idp_group  text NOT NULL,
  role       text NOT NULL CHECK (role IN ('OH','OL','AD','AN')),
  office_id  uuid REFERENCES offices(id) ON DELETE CASCADE,   -- NULL = all offices of the market (AD, AN)
  market_id  uuid NOT NULL REFERENCES markets(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (idp_group, role, market_id, office_id)
);

CREATE TABLE user_scopes (
  user_id    uuid NOT NULL REFERENCES app_users(id) ON DELETE CASCADE,
  role       text NOT NULL CHECK (role IN ('OH','OL','AD','AN')),
  office_id  uuid REFERENCES offices(id) ON DELETE CASCADE,
  market_id  uuid NOT NULL REFERENCES markets(id),
  resolved_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_user_scopes ON user_scopes(user_id, role, market_id, COALESCE(office_id, '00000000-0000-0000-0000-000000000000'::uuid));

CREATE TABLE notification_preferences (
  user_id       uuid PRIMARY KEY REFERENCES app_users(id) ON DELETE CASCADE,
  in_app        boolean NOT NULL DEFAULT true,
  email         boolean NOT NULL DEFAULT false,
  digest_time   time,
  language      text NOT NULL DEFAULT 'da' CHECK (language IN ('da','en','nb','sv')),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE notifications (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES app_users(id) ON DELETE CASCADE,
  kind        text NOT NULL,
  payload     jsonb NOT NULL DEFAULT '{}',   -- counts and links only, never message content
  created_at  timestamptz NOT NULL DEFAULT now(),
  read_at     timestamptz
);
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);

CREATE TABLE onboarding_progress (
  user_id   uuid NOT NULL REFERENCES app_users(id) ON DELETE CASCADE,
  step_key  text NOT NULL,
  done_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, step_key)
);

CREATE TABLE feedback (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id   uuid REFERENCES offices(id),
  user_id     uuid REFERENCES app_users(id) ON DELETE SET NULL,   -- optional; ratings are reported only as team aggregates
  rating      smallint CHECK (rating BETWEEN 1 AND 5),
  text        text,                 -- may contain personal data
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------- mail ingestion
CREATE TABLE mailboxes (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id        uuid NOT NULL REFERENCES offices(id),
  address          text NOT NULL,
  provider         text NOT NULL CHECK (provider IN ('graph','imap')),
  status           text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','connected','failed','paused')),
  last_checked_at  timestamptz,
  last_error       text,
  filters          jsonb NOT NULL DEFAULT '{}',
  secret_ref       text NOT NULL,            -- reference into the secrets manager, never the secret
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (office_id, address)
);

CREATE TABLE threads (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  mailbox_id          uuid NOT NULL REFERENCES mailboxes(id),
  external_thread_key text NOT NULL,
  created_at          timestamptz NOT NULL DEFAULT now(),
  UNIQUE (mailbox_id, external_thread_key)
);

CREATE TABLE messages (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  mailbox_id            uuid REFERENCES mailboxes(id),
  office_id             uuid NOT NULL REFERENCES offices(id),
  thread_id             uuid REFERENCES threads(id),
  external_id           text,
  internet_message_id   text,
  content_hash          text NOT NULL,
  direction             text NOT NULL DEFAULT 'inbound' CHECK (direction IN ('inbound','outbound')),
  channel               text NOT NULL DEFAULT 'email' CHECK (channel IN ('email','voicemail','photo','edi_change')),
  from_address          text,                 -- personal (customer contact)
  from_name             text,                 -- personal (customer contact)
  to_addresses          text[] NOT NULL DEFAULT '{}',
  subject               text,
  body_text             text,                 -- may contain personal data
  language              text,
  status                text NOT NULL DEFAULT 'received' CHECK (status IN
                          ('received','duplicate','filtered','classified','manual','processed','handled_elsewhere','deleted')),
  category              text CHECK (category IN ('order','quote_request','status_request','complaint','other')),
  category_confidence   numeric(4,3) CHECK (category_confidence BETWEEN 0 AND 1),
  flags                 text[] NOT NULL DEFAULT '{}',   -- suspicious_content, unsupported_language, speech_to_text ...
  legal_hold            boolean NOT NULL DEFAULT false,
  received_at           timestamptz NOT NULL,
  deleted_at            timestamptz,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_messages_external ON messages(mailbox_id, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX idx_messages_office_status ON messages(office_id, status, received_at DESC);
CREATE INDEX idx_messages_hash ON messages(content_hash);
CREATE INDEX idx_messages_retention ON messages(received_at) WHERE deleted_at IS NULL AND legal_hold = false;
CREATE INDEX idx_messages_from ON messages(lower(from_address));

CREATE TABLE attachments (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id    uuid NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
  file_name     text NOT NULL,
  content_type  text NOT NULL,
  size_bytes    bigint NOT NULL CHECK (size_bytes >= 0),
  storage_key   text,
  status        text NOT NULL DEFAULT 'stored' CHECK (status IN ('stored','skipped','unreadable')),
  skip_reason   text,
  created_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_attachments_message ON attachments(message_id);

-- ---------------------------------------------------------------- master data mirrored from the ERP
CREATE TABLE customers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id       uuid NOT NULL REFERENCES markets(id),
  erp_customer_no text NOT NULL,
  name            text NOT NULL,         -- personal when the customer is a sole trader
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','blocked','closed')),
  synced_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, erp_customer_no)
);
CREATE INDEX idx_customers_name_trgm ON customers USING gin (name gin_trgm_ops);

CREATE TABLE customer_contacts (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id  uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  email        text,                  -- personal
  name         text,                  -- personal
  phone        text,                  -- personal
  created_at   timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_contacts_email ON customer_contacts(lower(email));

CREATE TABLE sites (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id    uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  erp_site_ref   text,
  address_line   text NOT NULL,
  postal_code    text,
  city           text,
  contact_name   text,                -- personal
  contact_phone  text,                -- personal
  access_notes   text,
  synced_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_sites_customer ON sites(customer_id);

CREATE TABLE skus (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id    uuid NOT NULL REFERENCES markets(id),
  sku_no       text NOT NULL,
  description  text NOT NULL,
  base_unit    text NOT NULL,
  status       text NOT NULL DEFAULT 'active' CHECK (status IN ('active','withdrawn')),
  in_scope     boolean NOT NULL DEFAULT false,
  search_vec   tsvector GENERATED ALWAYS AS (to_tsvector('simple', coalesce(sku_no,'') || ' ' || coalesce(description,''))) STORED,
  embedding    vector(1024),
  synced_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, sku_no)
);
CREATE INDEX idx_skus_search ON skus USING gin (search_vec);
CREATE INDEX idx_skus_desc_trgm ON skus USING gin (description gin_trgm_ops);
CREATE INDEX idx_skus_embedding ON skus USING hnsw (embedding vector_cosine_ops);
CREATE INDEX idx_skus_scope ON skus(market_id, in_scope) WHERE status = 'active';

CREATE TABLE sku_units (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sku_id           uuid NOT NULL REFERENCES skus(id) ON DELETE CASCADE,
  unit_code        text NOT NULL,
  factor_to_base   numeric(18,6) NOT NULL CHECK (factor_to_base > 0),
  label            text,
  UNIQUE (sku_id, unit_code)
);

CREATE TABLE customer_purchase_history (
  customer_id     uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  sku_id          uuid NOT NULL REFERENCES skus(id) ON DELETE CASCADE,
  last_bought_at  date NOT NULL,
  times_bought    integer NOT NULL CHECK (times_bought >= 1),
  typical_qty     numeric(18,3),
  PRIMARY KEY (customer_id, sku_id)
);

CREATE TABLE aliases (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id      uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  alias_text       text NOT NULL,
  normalized_text  text NOT NULL,
  sku_id           uuid NOT NULL REFERENCES skus(id),
  status           text NOT NULL DEFAULT 'active' CHECK (status IN ('proposed','active','inactive')),
  proposed_by      uuid REFERENCES app_users(id) ON DELETE SET NULL,
  approved_by      uuid REFERENCES app_users(id) ON DELETE SET NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_aliases_active ON aliases(customer_id, normalized_text) WHERE status = 'active';

-- ---------------------------------------------------------------- configuration, models, templates
CREATE TABLE model_versions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind          text NOT NULL CHECK (kind IN ('classification','extraction','matching','estimate')),
  name          text NOT NULL,
  provider      text NOT NULL,
  region        text NOT NULL,
  status        text NOT NULL DEFAULT 'candidate' CHECK (status IN ('candidate','active','retired')),
  activated_at  timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_model_active_per_kind ON model_versions(kind) WHERE status = 'active';

CREATE TABLE prompt_versions (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  model_version_id  uuid NOT NULL REFERENCES model_versions(id),
  name              text NOT NULL,
  content           text NOT NULL,
  content_hash      text NOT NULL,
  created_at        timestamptz NOT NULL DEFAULT now(),
  UNIQUE (model_version_id, content_hash)
);

CREATE TABLE eval_runs (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  model_version_id    uuid NOT NULL REFERENCES model_versions(id),
  prompt_version_id   uuid REFERENCES prompt_versions(id),
  set_name            text NOT NULL,
  status              text NOT NULL DEFAULT 'running' CHECK (status IN ('running','completed','failed')),
  field_accuracy      numeric(5,4),
  line_match_accuracy numeric(5,4),
  edit_rate           numeric(5,4),
  details             jsonb NOT NULL DEFAULT '{}',
  started_at          timestamptz NOT NULL DEFAULT now(),
  finished_at         timestamptz
);

CREATE TABLE model_calls (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  correlation_id     text NOT NULL,
  purpose            text NOT NULL,
  model_version_id   uuid REFERENCES model_versions(id),
  prompt_version_id  uuid REFERENCES prompt_versions(id),
  tokens_in          integer,
  tokens_out         integer,
  cost_micro_eur     bigint,
  latency_ms         integer,
  outcome            text NOT NULL CHECK (outcome IN ('ok','invalid_output','timeout','refused','error')),
  created_at         timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_model_calls_time ON model_calls(created_at);

CREATE TABLE thresholds (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id            uuid NOT NULL REFERENCES markets(id),
  version              integer NOT NULL,
  classification_min   numeric(4,3) NOT NULL CHECK (classification_min BETWEEN 0 AND 1),
  field_min            numeric(4,3) NOT NULL CHECK (field_min BETWEEN 0 AND 1),
  line_match_min       numeric(4,3) NOT NULL CHECK (line_match_min BETWEEN 0 AND 1),
  review_below         numeric(4,3) NOT NULL CHECK (review_below BETWEEN 0 AND 1),
  active               boolean NOT NULL DEFAULT false,
  created_at           timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, version),
  CHECK (line_match_min <= review_below)
);
CREATE UNIQUE INDEX uq_thresholds_active ON thresholds(market_id) WHERE active;

CREATE TABLE sku_scopes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id   uuid NOT NULL REFERENCES markets(id),
  name        text NOT NULL,
  rule        jsonb NOT NULL,
  active      boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_sku_scopes_active ON sku_scopes(market_id) WHERE active;

CREATE TABLE templates (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id   uuid NOT NULL REFERENCES markets(id),
  kind        text NOT NULL CHECK (kind IN ('confirmation','status_answer','missing_info','complaint_ack','delivery_notice')),
  language    text NOT NULL CHECK (language IN ('da','en','nb','sv')),
  version     integer NOT NULL,
  subject     text NOT NULL,
  body        text NOT NULL,
  active      boolean NOT NULL DEFAULT false,
  created_by  uuid REFERENCES app_users(id) ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, kind, language, version)
);
CREATE UNIQUE INDEX uq_templates_active ON templates(market_id, kind, language) WHERE active;

CREATE TABLE feature_flags (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id   uuid NOT NULL REFERENCES markets(id),
  key         text NOT NULL,
  enabled     boolean NOT NULL DEFAULT false,
  updated_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, key)
);

CREATE TABLE sync_runs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id    uuid NOT NULL REFERENCES markets(id),
  kind         text NOT NULL CHECK (kind IN ('catalogue','customers','purchase_history','prices')),
  status       text NOT NULL CHECK (status IN ('running','succeeded','failed')),
  counts       jsonb NOT NULL DEFAULT '{}',
  error        text,
  started_at   timestamptz NOT NULL DEFAULT now(),
  finished_at  timestamptz
);
CREATE INDEX idx_sync_runs_market ON sync_runs(market_id, kind, started_at DESC);

CREATE TABLE component_health (
  component   text PRIMARY KEY,
  status      text NOT NULL CHECK (status IN ('ok','degraded','down')),
  detail      text,
  checked_at  timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------- drafts
CREATE TABLE drafts (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id                uuid NOT NULL REFERENCES messages(id),
  office_id                 uuid NOT NULL REFERENCES offices(id),
  parent_draft_id           uuid REFERENCES drafts(id),
  draft_type                text NOT NULL DEFAULT 'order' CHECK (draft_type IN ('order','status_request','change')),
  status                    text NOT NULL DEFAULT 'new' CHECK (status IN
                              ('new','in_review','approved','writing','written','write_failed','rejected','shadow','unmatched','manual','closed')),
  customer_id               uuid REFERENCES customers(id),
  customer_text             text,
  site_id                   uuid REFERENCES sites(id),
  site_text                 text,
  delivery_wish_text        text,
  delivery_wish_date        date,
  proposed_delivery_date    date,
  delivery_confidence       text CHECK (delivery_confidence IN ('high','medium','low')),
  delivery_reason           text,
  overall_confidence        numeric(4,3) CHECK (overall_confidence BETWEEN 0 AND 1),
  evidence                  jsonb NOT NULL DEFAULT '{}',
  flags                     text[] NOT NULL DEFAULT '{}',
  language                  text,
  extraction_model_id       uuid REFERENCES model_versions(id),
  extraction_prompt_id      uuid REFERENCES prompt_versions(id),
  assigned_to_user_id       uuid REFERENCES app_users(id) ON DELETE SET NULL,
  locked_by_user_id         uuid REFERENCES app_users(id) ON DELETE SET NULL,
  lock_expires_at           timestamptz,
  service_due_at            timestamptz,
  erp_order_no              text,
  idempotency_key           uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  approved_at               timestamptz,
  approved_by_user_id       uuid REFERENCES app_users(id) ON DELETE SET NULL,
  approved_without_edits    boolean,
  edited                    boolean NOT NULL DEFAULT false,
  manual_check_confirmed    boolean NOT NULL DEFAULT false,
  version                   integer NOT NULL DEFAULT 0,
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_drafts_queue ON drafts(office_id, status, created_at);
CREATE INDEX idx_drafts_assignee ON drafts(assigned_to_user_id, status);
CREATE INDEX idx_drafts_message ON drafts(message_id);
CREATE INDEX idx_drafts_erp_order ON drafts(erp_order_no) WHERE erp_order_no IS NOT NULL;

CREATE TABLE draft_lines (
  id                         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id                   uuid NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
  line_no                    integer NOT NULL,
  source_text                text NOT NULL,
  source_span                jsonb,
  quantity                   numeric(18,3) CHECK (quantity > 0),
  unit_code                  text,
  quantity_original          numeric(18,3),
  unit_original              text,
  sku_id                     uuid REFERENCES skus(id),
  match_confidence           numeric(4,3) CHECK (match_confidence BETWEEN 0 AND 1),
  confidence_level           text CHECK (confidence_level IN ('sure','check','unsure')),
  state                      text NOT NULL DEFAULT 'proposed' CHECK (state IN
                               ('proposed','confirmed','flagged','held','removed','outside_scope','unit_unknown')),
  contract_price_minor       bigint,
  currency                   char(3),
  customer_stated_price_minor bigint,
  price_flag                 boolean NOT NULL DEFAULT false,
  stock_available            numeric(18,3),
  stock_checked_at           timestamptz,
  credit_status              text CHECK (credit_status IN ('ok','warning','blocked','unknown')),
  shortfall_action           text CHECK (shortfall_action IN ('split','backorder','substitute')),
  note                       text,
  UNIQUE (draft_id, line_no)
);
CREATE INDEX idx_draft_lines_sku ON draft_lines(sku_id);

CREATE TABLE line_candidates (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_line_id  uuid NOT NULL REFERENCES draft_lines(id) ON DELETE CASCADE,
  sku_id         uuid NOT NULL REFERENCES skus(id),
  rank           smallint NOT NULL CHECK (rank BETWEEN 1 AND 10),
  score          numeric(5,4) NOT NULL,
  reason         text,
  UNIQUE (draft_line_id, sku_id)
);

CREATE TABLE approvals (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id             uuid NOT NULL REFERENCES drafts(id),
  approved_by_user_id  uuid REFERENCES app_users(id) ON DELETE SET NULL,
  role                 text,
  draft_version        integer NOT NULL,
  edits_count          integer NOT NULL DEFAULT 0,
  auto_approved        boolean NOT NULL DEFAULT false,
  policy_version       integer,
  approved_at          timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_approvals_draft ON approvals(draft_id);

CREATE TABLE erp_write_attempts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id      uuid NOT NULL REFERENCES drafts(id),
  attempt_no    integer NOT NULL,
  method        text NOT NULL CHECK (method IN ('api','rpa')),
  outcome       text NOT NULL CHECK (outcome IN ('success','rejected','error','duplicate')),
  erp_order_no  text,
  error_detail  text,
  started_at    timestamptz NOT NULL DEFAULT now(),
  finished_at   timestamptz,
  UNIQUE (draft_id, attempt_no)
);

CREATE TABLE confirmations (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id          uuid NOT NULL REFERENCES drafts(id),
  template_id       uuid REFERENCES templates(id),
  language          text NOT NULL,
  subject           text NOT NULL,
  body_text         text NOT NULL,
  original_body     text,
  body_edited       boolean NOT NULL DEFAULT false,
  status            text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','sent','failed','suppressed_shadow')),
  error             text,
  sent_at           timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_confirmations_draft ON confirmations(draft_id);

CREATE TABLE status_requests (
  draft_id         uuid PRIMARY KEY REFERENCES drafts(id) ON DELETE CASCADE,
  erp_order_no     text,
  order_status     text,
  expected_date    date,
  proposed_answer  text,
  answer_sent_at   timestamptz,
  answer_snapshot  jsonb
);

CREATE TABLE post_order_exceptions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id     uuid NOT NULL REFERENCES offices(id),
  draft_id      uuid REFERENCES drafts(id),
  erp_order_no  text NOT NULL,
  type          text NOT NULL CHECK (type IN ('missing_site_data','stock_shortfall')),
  status        text NOT NULL DEFAULT 'open' CHECK (status IN ('open','resolved','auto_closed')),
  detected_at   timestamptz NOT NULL DEFAULT now(),
  resolved_at   timestamptz
);
CREATE INDEX idx_post_order_open ON post_order_exceptions(office_id, status);

-- ---------------------------------------------------------------- learning, shadow, baseline, metrics
CREATE TABLE corrections (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id            uuid REFERENCES drafts(id) ON DELETE SET NULL,
  draft_line_id       uuid REFERENCES draft_lines(id) ON DELETE SET NULL,
  field               text NOT NULL,
  machine_value       jsonb,
  corrected_value     jsonb,
  correction_type     text NOT NULL CHECK (correction_type IN ('edit','reclassify','merge','sku_change','date_change','unit_change')),
  model_version_id    uuid REFERENCES model_versions(id),
  created_at          timestamptz NOT NULL DEFAULT now()
  -- deliberately no user column: corrections are not attributable to individuals (R-26, US-27.3)
);
CREATE INDEX idx_corrections_model ON corrections(model_version_id, created_at);

CREATE TABLE shadow_comparisons (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  draft_id      uuid NOT NULL REFERENCES drafts(id),
  erp_order_no  text,
  status        text NOT NULL DEFAULT 'unmatched' CHECK (status IN ('linked','unmatched','reviewed')),
  diff_count    integer NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_shadow_status ON shadow_comparisons(status, created_at);

CREATE TABLE shadow_field_diffs (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  comparison_id     uuid NOT NULL REFERENCES shadow_comparisons(id) ON DELETE CASCADE,
  field             text NOT NULL,
  assistant_value   text,
  human_value       text
);

CREATE TABLE baseline_samples (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id         uuid NOT NULL REFERENCES offices(id),
  message_id        uuid REFERENCES messages(id) ON DELETE SET NULL,
  channel           text NOT NULL CHECK (channel IN ('email','phone','voicemail','photo','edi','web','app','other')),
  format            text NOT NULL CHECK (format IN ('email_text','pdf','excel','photo','phone','edi','web','other')),
  is_order          boolean NOT NULL DEFAULT true,
  lines_count       integer CHECK (lines_count >= 0),
  handling_minutes  numeric(8,2) CHECK (handling_minutes >= 0),   -- sampled at office level, never per person
  observed_at       timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_baseline_office ON baseline_samples(office_id, observed_at);

CREATE TABLE baseline_credit_notes (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id    uuid NOT NULL REFERENCES offices(id),
  erp_ref      text NOT NULL,
  reason_code  text NOT NULL CHECK (reason_code IN ('wrong_item','wrong_quantity','wrong_price','other')),
  lines_count  integer NOT NULL DEFAULT 1,
  issued_on    date NOT NULL
);

CREATE TABLE metric_events (
  id           bigserial PRIMARY KEY,
  event_name   text NOT NULL,
  occurred_at  timestamptz NOT NULL DEFAULT now(),
  office_id    uuid REFERENCES offices(id),
  market_id    uuid REFERENCES markets(id),
  draft_id     uuid,
  message_id   uuid,
  properties   jsonb NOT NULL DEFAULT '{}'      -- no names, emails or message text (US-32)
);
CREATE INDEX idx_metric_events_name_time ON metric_events(event_name, occurred_at);
CREATE INDEX idx_metric_events_office ON metric_events(office_id, occurred_at);

CREATE TABLE metric_rollups (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id     uuid NOT NULL REFERENCES offices(id),
  period_start  date NOT NULL,
  period_end    date NOT NULL,
  metric        text NOT NULL,
  value         numeric(18,4),
  sample_size   integer NOT NULL,
  UNIQUE (office_id, period_start, period_end, metric)
);

-- ---------------------------------------------------------------- compliance
CREATE TABLE retention_policies (
  market_id                   uuid PRIMARY KEY REFERENCES markets(id),
  message_retention_days      integer NOT NULL CHECK (message_retention_days > 0),
  attachment_retention_days   integer NOT NULL CHECK (attachment_retention_days > 0),
  updated_at                  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE dsr_requests (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type            text NOT NULL CHECK (type IN ('access','rectification','deletion')),
  subject_email   text NOT NULL,        -- personal
  status          text NOT NULL DEFAULT 'registered' CHECK (status IN ('registered','executed','failed','closed')),
  match_counts    jsonb NOT NULL DEFAULT '{}',
  closing_note    text,
  registered_at   timestamptz NOT NULL DEFAULT now(),
  executed_at     timestamptz
);

CREATE TABLE audit_events (
  id              bigserial PRIMARY KEY,
  occurred_at     timestamptz NOT NULL DEFAULT now(),
  actor_user_id   uuid,                 -- personal (staff identifier)
  actor_role      text,
  event_type      text NOT NULL,
  object_type     text,
  object_id       uuid,
  before_state    jsonb,
  after_state     jsonb,
  correlation_id  text
);
CREATE INDEX idx_audit_time ON audit_events(occurred_at DESC);
CREATE INDEX idx_audit_type ON audit_events(event_type, occurred_at DESC);
CREATE INDEX idx_audit_object ON audit_events(object_type, object_id);

CREATE FUNCTION audit_events_immutable() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'audit_events is append-only';
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_audit_no_update BEFORE UPDATE OR DELETE ON audit_events
  FOR EACH ROW EXECUTE FUNCTION audit_events_immutable();

-- ---------------------------------------------------------------- R2 tables
CREATE TABLE cases (
  id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id               uuid NOT NULL REFERENCES messages(id),
  office_id                uuid NOT NULL REFERENCES offices(id),
  category                 text NOT NULL CHECK (category IN ('complaint','return')),
  linked_order_no          text,
  status                   text NOT NULL DEFAULT 'open' CHECK (status IN ('open','acknowledged','closed')),
  assigned_to_user_id      uuid REFERENCES app_users(id) ON DELETE SET NULL,
  acknowledgement_sent_at  timestamptz,
  closed_at                timestamptz,
  created_at               timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_cases_office ON cases(office_id, status);

CREATE TABLE auto_approval_policies (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id   uuid NOT NULL REFERENCES markets(id),
  version     integer NOT NULL,
  rules       jsonb NOT NULL,
  active      boolean NOT NULL DEFAULT false,
  paused      boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (market_id, version)
);
CREATE UNIQUE INDEX uq_policy_active ON auto_approval_policies(market_id) WHERE active;

CREATE TABLE auto_approval_samples (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  approval_id  uuid NOT NULL REFERENCES approvals(id),
  status       text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','correct','wrong')),
  reviewed_at  timestamptz
);

CREATE TABLE estimate_models (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id   uuid NOT NULL REFERENCES markets(id),
  kind        text NOT NULL CHECK (kind IN ('rule','ml')),
  active      boolean NOT NULL DEFAULT false,
  evaluation  jsonb NOT NULL DEFAULT '{}',
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_estimate_active ON estimate_models(market_id) WHERE active;

-- ---------------------------------------------------------------- R3 tables
CREATE TABLE market_readiness_items (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id    uuid NOT NULL REFERENCES markets(id),
  item_key     text NOT NULL CHECK (item_key IN ('adapters_tested','language_templates_reviewed','thresholds_evaluated','consultation_recorded')),
  done         boolean NOT NULL DEFAULT false,
  done_at      timestamptz,
  done_by_role text,
  UNIQUE (market_id, item_key)
);

CREATE TABLE delivery_exceptions (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id        uuid NOT NULL REFERENCES offices(id),
  erp_order_no     text NOT NULL,
  type             text NOT NULL CHECK (type IN ('delay','missing_site_data','other')),
  source_event_id  text NOT NULL,
  status           text NOT NULL DEFAULT 'open' CHECK (status IN ('open','notified','resolved')),
  notice_sent_at   timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (source_event_id)
);
CREATE INDEX idx_delivery_exceptions_office ON delivery_exceptions(office_id, status);
