# Endpoint Authorisation Matrix

Roles are additive per user (a person can hold several). **Anonymous** is denied everywhere except `getHealth`. **System** = inbound service principals / webhook validation; no user role reaches those endpoints. `own-office` = allowed for objects in the office scopes of the caller's role assignment, 404 otherwise. **AD does not read draft or message content unless the same user also holds OH** (separation of duties, D-22). No endpoint returns employee-level metrics (R-26).

| operationId | Method + path | US-IDs | Anonymous | OH | OL | AN | AD | System | Release | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| getCurrentUser | GET /api/v1/me | US-37 | deny | allow | allow | allow | allow | deny | R1 |  |
| getMyPreferences | GET /api/v1/me/preferences | US-35, US-51 | deny | allow | allow | allow | allow | deny | R1 |  |
| updateMyPreferences | PUT /api/v1/me/preferences | US-35, US-51 | deny | allow | allow | allow | allow | deny | R1 | own account only |
| listOnboardingSteps | GET /api/v1/me/onboarding | US-49 | deny | allow | allow | allow | allow | deny | R1 | progress is private to the user |
| completeOnboardingStep | POST /api/v1/me/onboarding/{stepKey}/complete | US-49 | deny | allow | allow | allow | allow | deny | R1 |  |
| submitFeedback | POST /api/v1/feedback | US-50 | deny | allow | allow | allow | allow | deny | R1 | ratings reported as team aggregates only |
| listNotifications | GET /api/v1/notifications | US-35, US-34 | deny | allow | allow | allow | allow | deny | R1 | own only; counts and links only |
| getSystemStatus | GET /api/v1/status | US-43, US-44, US-51 | deny | allow | allow | allow | allow | deny | R1 |  |
| getHealth | GET /api/v1/health | US-43 | allow | allow | allow | allow | allow | deny | R1 | anonymous allowed |
| listOffices | GET /api/v1/offices | US-37, US-29 | deny | allow | allow | allow | allow | deny | R1 |  |
| setOfficeMode | PUT /api/v1/offices/{officeId}/mode | US-29, US-30 | deny | deny | own-office | deny | allow | deny | R1 | requires confirm=true; audited |
| listDrafts | GET /api/v1/drafts | US-13 | deny | own-office | own-office | deny | deny | deny | R1 | AD only if also OH |
| getDraft | GET /api/v1/drafts/{draftId} | US-14, US-04, US-09, US-10 | deny | own-office | own-office | deny | deny | deny | R1 | 404 outside office scope |
| updateDraft | PATCH /api/v1/drafts/{draftId} | US-14, US-10, US-09, US-18 | deny | own-office | own-office | deny | deny | deny | R1 | requires lock; 409 on stale version |
| updateDraftLine | PATCH /api/v1/drafts/{draftId}/lines/{lineId} | US-15, US-11, US-18, US-27 | deny | own-office | own-office | deny | deny | deny | R1 | requires lock; saveAsAlias creates or proposes an alias |
| holdDraftLine | POST /api/v1/drafts/{draftId}/lines/{lineId}/hold | US-15 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| listLineCandidates | GET /api/v1/drafts/{draftId}/lines/{lineId}/candidates | US-07, US-08, US-15 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| searchSkus | GET /api/v1/skus | US-15 | deny | own-office | own-office | deny | deny | deny | R1 | needs a draft context role |
| acquireDraftLock | POST /api/v1/drafts/{draftId}/lock | US-18 | deny | own-office | own-office | deny | deny | deny | R1 | 409 if held by another user |
| releaseDraftLock | DELETE /api/v1/drafts/{draftId}/lock | US-18 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| approveDraft | POST /api/v1/drafts/{draftId}/approve | US-16, US-22, US-27, US-30 | deny | own-office | own-office | deny | deny | deny | R1 | 409 on concurrent approval; idempotent by version |
| rejectDraft | POST /api/v1/drafts/{draftId}/reject | US-17 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| reassignDraft | POST /api/v1/drafts/{draftId}/assign | US-17, US-33 | deny | own-office | own-office | deny | deny | deny | R1 | audited |
| mergeDrafts | POST /api/v1/drafts/merge | US-05 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| setServiceTimer | PUT /api/v1/drafts/{draftId}/service-timer | US-34 | deny | deny | own-office | deny | deny | deny | R1 |  |
| retryDraftWrite | POST /api/v1/drafts/{draftId}/retry-write | US-23 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| previewConfirmation | GET /api/v1/drafts/{draftId}/confirmation-preview | US-24, US-25 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| sendConfirmation | POST /api/v1/drafts/{draftId}/confirmation | US-24 | deny | own-office | own-office | deny | deny | deny | R1 | only after a successful ERP write |
| listMessages | GET /api/v1/messages | US-19, US-36 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| getMessage | GET /api/v1/messages/{messageId} | US-14, US-06 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| updateMessageStatus | POST /api/v1/messages/{messageId}/actions | US-19, US-03, US-02 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| getAttachmentContent | GET /api/v1/messages/{messageId}/attachments/{attachmentId}/content | US-14, US-06, US-53 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| getStatusRequest | GET /api/v1/status-requests/{draftId} | US-20 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| sendStatusAnswer | POST /api/v1/status-requests/{draftId}/send | US-20 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| listPostOrderExceptions | GET /api/v1/post-order-exceptions | US-21 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| resolvePostOrderException | POST /api/v1/post-order-exceptions/{exceptionId}/resolve | US-21 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| listAliases | GET /api/v1/aliases | US-11 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| createAlias | POST /api/v1/aliases | US-11 | deny | own-office | own-office | deny | deny | deny | R1 | 409 if the same text maps to another SKU |
| updateAlias | PATCH /api/v1/aliases/{aliasId} | US-11 | deny | own-office | own-office | deny | deny | deny | R1 |  |
| approveAlias | POST /api/v1/aliases/{aliasId}/approve | US-11 | deny | deny | own-office | deny | deny | deny | R1 |  |
| getTeamQueue | GET /api/v1/team-queue | US-33, US-34 | deny | deny | own-office | deny | allow | deny | R1 | aggregates only; no per-person figures |
| getMetrics | GET /api/v1/metrics | US-31, US-29 | deny | deny | own-office | allow | allow | deny | R1 | no endpoint returns employee-level data (R-26) |
| exportMetricsCsv | GET /api/v1/metrics/export | US-31 | deny | deny | own-office | allow | allow | deny | R1 |  |
| getBaselineSummary | GET /api/v1/baseline/summary | US-29 | deny | deny | own-office | allow | allow | deny | R1 |  |
| importBaselineSample | POST /api/v1/baseline/samples | US-29 | deny | deny | own-office | deny | allow | deny | R1 |  |
| listShadowComparisons | GET /api/v1/shadow-comparisons | US-30 | deny | deny | own-office | allow | allow | deny | R1 |  |
| getShadowComparison | GET /api/v1/shadow-comparisons/{comparisonId} | US-30 | deny | deny | own-office | allow | allow | deny | R1 |  |
| linkShadowComparison | POST /api/v1/shadow-comparisons/{comparisonId}/link | US-30 | deny | deny | own-office | deny | allow | deny | R1 |  |
| listMailboxes | GET /api/v1/admin/mailboxes | US-01 | deny | deny | deny | deny | allow | deny | R1 |  |
| createMailbox | POST /api/v1/admin/mailboxes | US-01 | deny | deny | deny | deny | allow | deny | R1 |  |
| updateMailbox | PATCH /api/v1/admin/mailboxes/{mailboxId} | US-01 | deny | deny | deny | deny | allow | deny | R1 |  |
| testMailbox | POST /api/v1/admin/mailboxes/{mailboxId}/test | US-01 | deny | deny | deny | deny | allow | deny | R1 |  |
| getSkuScope | GET /api/v1/admin/sku-scope | US-46, US-56 | deny | deny | deny | deny | allow | deny | R1 |  |
| updateSkuScope | PUT /api/v1/admin/sku-scope | US-46, US-56 | deny | deny | deny | deny | allow | deny | R1 | R2 full catalogue is a scope value |
| listThresholds | GET /api/v1/admin/thresholds | US-46 | deny | deny | deny | deny | allow | deny | R1 |  |
| evaluateThresholds | POST /api/v1/admin/thresholds/evaluate | US-46 | deny | deny | deny | deny | allow | deny | R1 |  |
| activateThresholds | POST /api/v1/admin/thresholds | US-46 | deny | deny | deny | deny | allow | deny | R1 |  |
| listTemplates | GET /api/v1/admin/templates | US-25 | deny | deny | deny | deny | allow | deny | R1 |  |
| saveTemplate | POST /api/v1/admin/templates | US-25, US-57 | deny | deny | deny | deny | allow | deny | R1 | 422 on unknown placeholder |
| previewTemplate | POST /api/v1/admin/templates/preview | US-25 | deny | deny | deny | deny | allow | deny | R1 |  |
| listModelVersions | GET /api/v1/admin/model-versions | US-47, US-28 | deny | deny | deny | deny | allow | deny | R1 |  |
| startEvaluation | POST /api/v1/admin/evaluations | US-28 | deny | deny | deny | deny | allow | deny | R1 |  |
| getEvaluation | GET /api/v1/admin/evaluations/{evaluationId} | US-28 | deny | deny | deny | deny | allow | deny | R1 |  |
| activateModelVersion | POST /api/v1/admin/model-versions/{modelVersionId}/activate | US-47, US-61 | deny | deny | deny | deny | allow | deny | R1 | 409 if a tuned candidate does not beat the current model |
| rollbackModelVersion | POST /api/v1/admin/model-versions/rollback | US-47, US-61 | deny | deny | deny | deny | allow | deny | R1 |  |
| listRoleMappings | GET /api/v1/admin/role-mappings | US-37 | deny | deny | deny | deny | allow | deny | R1 |  |
| saveRoleMappings | PUT /api/v1/admin/role-mappings | US-37, US-38 | deny | deny | deny | deny | allow | deny | R1 | audited |
| listFeatureFlags | GET /api/v1/admin/feature-flags | US-48 | deny | deny | deny | deny | allow | deny | R1 |  |
| setFeatureFlag | PUT /api/v1/admin/feature-flags/{key} | US-48 | deny | deny | deny | deny | allow | deny | R1 |  |
| listAuditEvents | GET /api/v1/admin/audit-events | US-39 | deny | deny | deny | deny | allow | deny | R1 |  |
| exportAuditEvents | GET /api/v1/admin/audit-events/export | US-39 | deny | deny | deny | deny | allow | deny | R1 |  |
| getRetentionPolicy | GET /api/v1/admin/privacy/retention | US-40 | deny | deny | deny | deny | allow | deny | R1 |  |
| updateRetentionPolicy | PUT /api/v1/admin/privacy/retention | US-40 | deny | deny | deny | deny | allow | deny | R1 |  |
| setLegalHold | PUT /api/v1/admin/privacy/legal-holds/{messageId} | US-40 | deny | deny | deny | deny | allow | deny | R1 |  |
| listDsrRequests | GET /api/v1/admin/privacy/dsr | US-41 | deny | deny | deny | deny | allow | deny | R1 |  |
| registerDsrRequest | POST /api/v1/admin/privacy/dsr | US-41 | deny | deny | deny | deny | allow | deny | R1 |  |
| executeDsrRequest | POST /api/v1/admin/privacy/dsr/{requestId}/execute | US-41 | deny | deny | deny | deny | allow | deny | R1 | access request returns the export reference in closingNote |
| triggerMasterDataSync | POST /api/v1/admin/master-data/sync | US-12 | deny | deny | deny | deny | allow | deny | R1 |  |
| receiveMailNotification | POST /api/v1/integrations/mail/notifications | US-01 | deny | deny | deny | deny | deny | allow | R1 | validated by validation token and client state; system principal only |
| receiveTranscript | POST /api/v1/integrations/transcripts | US-52 | deny | deny | deny | deny | deny | allow | R2 | service principal only |
| receiveEdiChange | POST /api/v1/integrations/edi-changes | US-54 | deny | deny | deny | deny | deny | allow | R2 | service principal only |
| receiveDeliveryException | POST /api/v1/integrations/delivery-exceptions | US-65 | deny | deny | deny | deny | deny | allow | R3 | service principal only |
| listCases | GET /api/v1/cases | US-55 | deny | own-office | own-office | deny | deny | deny | R2 |  |
| acknowledgeCase | POST /api/v1/cases/{caseId}/acknowledge | US-55 | deny | own-office | own-office | deny | deny | deny | R2 |  |
| closeCase | POST /api/v1/cases/{caseId}/close | US-55 | deny | own-office | own-office | deny | deny | deny | R2 |  |
| getAutoApprovalPolicy | GET /api/v1/admin/auto-approval | US-58 | deny | deny | deny | deny | allow | deny | R2 |  |
| saveAutoApprovalPolicy | PUT /api/v1/admin/auto-approval | US-58 | deny | deny | deny | deny | allow | deny | R2 |  |
| pauseAutoApproval | POST /api/v1/admin/auto-approval/pause | US-59 | deny | deny | deny | deny | allow | deny | R2 |  |
| listAutoApprovalSamples | GET /api/v1/auto-approval/samples | US-59 | deny | own-office | own-office | deny | deny | deny | R2 |  |
| reviewAutoApprovalSample | POST /api/v1/auto-approval/samples/{sampleId}/review | US-59 | deny | own-office | own-office | deny | deny | deny | R2 |  |
| listEstimateModels | GET /api/v1/admin/estimate-models | US-60 | deny | deny | deny | deny | allow | deny | R2 |  |
| activateEstimateModel | POST /api/v1/admin/estimate-models/{estimateModelId}/activate | US-60 | deny | deny | deny | deny | allow | deny | R2 | 409 if fewer than six months of history |
| startModelTuning | POST /api/v1/admin/tuning | US-61 | deny | deny | deny | deny | allow | deny | R2 |  |
| getMarketReadiness | GET /api/v1/admin/markets/{marketCode}/readiness | US-62 | deny | deny | deny | deny | allow | deny | R3 |  |
| updateReadinessItem | PUT /api/v1/admin/markets/{marketCode}/readiness/{itemKey} | US-62 | deny | deny | deny | deny | allow | deny | R3 |  |
| enableMarket | POST /api/v1/admin/markets/{marketCode}/enable | US-62 | deny | deny | deny | deny | allow | deny | R3 | 409 listing open items |
| listDeliveryExceptions | GET /api/v1/delivery-exceptions | US-65 | deny | own-office | own-office | deny | deny | deny | R3 |  |
| sendDeliveryNotice | POST /api/v1/delivery-exceptions/{exceptionId}/notice | US-65 | deny | own-office | own-office | deny | deny | deny | R3 |  |
