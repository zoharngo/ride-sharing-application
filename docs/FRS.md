# RideIL — Functional Requirements Specification (FRS)

**Document Version:** 1.0
**Date:** January 27, 2026
**Project:** RideIL — Compliant Ride-Sharing Platform for Israel
**Reference:** FRD v1.0, DEVELOPMENT_PLAN v1.1

---

## 1. Introduction

### 1.1 Purpose

This Functional Requirements Specification defines HOW each functional requirement identified in the FRD will be technically implemented. It provides detailed input/output specifications, processing logic, data models, validation rules, error handling, and acceptance criteria for the RideIL platform.

### 1.2 Scope

This document covers the MVP implementation encompassing:
- Rider mobile application (iOS and Android via React Native)
- Driver mobile application (iOS and Android via React Native)
- Backend microservices (Node.js/NestJS)
- Admin web portal
- Database schema and data flows
- External service integrations

### 1.3 Terminology

| Term | Definition |
|------|-----------|
| Rider | A passenger using the app to request a taxi ride |
| Driver | A licensed taxi driver registered on the platform |
| Trip | A complete ride lifecycle from request to completion |
| OTP | One-Time Password sent via SMS for phone verification |
| JWT | JSON Web Token used for API authentication |
| MoT | Ministry of Transportation (Israel) |
| PPA | Privacy Protection Authority (Israel) |

---

## 2. System Overview

### 2.1 Architecture

The system follows a microservices architecture deployed on AWS (il-central-1):

```
Mobile Apps (React Native)
    ↕ HTTPS/WSS
API Gateway (AWS API Gateway)
    ↕
Microservices (NestJS on Kubernetes/EKS)
├── Auth Service
├── Rider Service
├── Driver Service
├── Trip Service
├── Matching Service
├── Location Service
├── Pricing Service
├── Payment Service
├── Notification Service
├── Compliance Service
├── Safety Service
├── Audit Service
└── Admin Service
    ↕
Data Layer
├── PostgreSQL (primary relational data)
├── Redis (caching, real-time location, sessions)
├── MongoDB (audit logs, document metadata)
└── Elasticsearch (search, reporting)
    ↕
External Services
├── Stripe Israel (payments)
├── Google Maps Platform (maps, routing, geocoding)
├── Twilio (SMS/OTP)
├── Firebase Cloud Messaging (push notifications)
├── Amazon SES (email)
└── AWS S3 (document storage)
```

### 2.2 Technology Stack

| Layer | Technology |
|-------|-----------|
| Mobile | React Native, Redux Toolkit, React Navigation, i18next |
| Backend | Node.js (TypeScript), NestJS, Prisma ORM, Passport.js |
| Databases | PostgreSQL 15+, Redis 7+, MongoDB, Elasticsearch |
| Infrastructure | AWS EKS, Terraform, GitHub Actions, Prometheus/Grafana |
| Security | JWT, AES-256-GCM, TLS 1.3, Certificate Pinning |

---

## 3. Detailed Functional Specifications

### 3.1 Authentication Module

#### SPEC-AUTH-01: Phone Registration with OTP

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-AUTH-01 |
| **Endpoint** | `POST /api/v1/auth/register` |
| **Input** | `{ phone_number: string, full_name: string, preferred_language: "he" \| "ar" \| "en" }` |
| **Processing** | 1. Validate phone format (Israeli: +972-5X-XXX-XXXX) 2. Check for existing account 3. Generate 6-digit OTP 4. Store OTP in Redis with 5-minute TTL 5. Send OTP via Twilio SMS 6. Return registration_token |
| **Output** | `{ registration_token: string, otp_expires_in: 300 }` |
| **Validation** | Phone: `/^\+972[0-9]{9}$/`; Name: 2–255 chars; Language: enum |
| **Error Handling** | `400` invalid format; `409` phone exists; `429` rate limited (5/hr) |
| **Acceptance Criteria** | OTP delivered within 10s; account created on verification; rate limiting enforced |

#### SPEC-AUTH-02: OTP Verification

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-AUTH-01, FR-AUTH-03 |
| **Endpoint** | `POST /api/v1/auth/verify-otp` |
| **Input** | `{ registration_token: string, otp_code: string }` |
| **Processing** | 1. Retrieve OTP from Redis by token 2. Compare codes (constant-time comparison) 3. If match: create rider record, issue JWT + refresh token 4. If mismatch: increment attempt counter (max 3) 5. Delete OTP from Redis on success |
| **Output** | `{ access_token: string, refresh_token: string, rider: RiderProfile }` |
| **Validation** | OTP: exactly 6 digits; token: valid UUID |
| **Error Handling** | `401` invalid OTP; `410` expired OTP; `429` too many attempts |
| **Acceptance Criteria** | Successful verification issues valid JWT; failed attempts logged; max 3 attempts |

#### SPEC-AUTH-03: Token Refresh

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-AUTH-03 |
| **Endpoint** | `POST /api/v1/auth/refresh-token` |
| **Input** | `{ refresh_token: string }` |
| **Processing** | 1. Validate refresh token signature and expiry 2. Check token not revoked (Redis blacklist) 3. Issue new access token (15 min) 4. Optionally rotate refresh token (7 days) |
| **Output** | `{ access_token: string, refresh_token?: string }` |
| **Error Handling** | `401` invalid/expired/revoked token |
| **Acceptance Criteria** | New access token valid for 15 min; revoked tokens rejected |

---

### 3.2 Rider Module

#### SPEC-RIDE-01: Request a Ride

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-RIDE-01 through FR-RIDE-05 |
| **Endpoint** | `POST /api/v1/trips/request` |
| **Input** | `{ pickup: { lat, lng, address }, dropoff: { lat, lng, address }, payment_method: "card" \| "cash", wheelchair_accessible: boolean }` |
| **Processing** | 1. Validate rider has active account and valid payment method (if card) 2. Check rider not blocked from cash (if cash) 3. Calculate fare estimate from pricing service 4. Create trip record (status: `requested`) 5. Trigger matching service 6. Return trip details |
| **Output** | `{ trip_id, trip_number, status, estimated_fare: { min, max, currency }, estimated_time_minutes }` |
| **Validation** | Coordinates within Israel bounding box (29.5–33.3°N, 34.2–35.9°E); addresses non-empty |
| **Error Handling** | `400` invalid coordinates; `402` no payment method; `403` cash blocked; `503` no drivers |
| **Acceptance Criteria** | Trip created in DB; matching initiated; fare estimate within tariff bounds |

#### SPEC-RIDE-02: Get Trip Status and Driver Location

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-RIDE-06, FR-RIDE-07 |
| **WebSocket** | `ws://api.rideil.co.il/ws` → Events: `trip:status_changed`, `driver:location_update`, `trip:eta_update` |
| **REST Fallback** | `GET /api/v1/trips/:tripId` |
| **Output (WS)** | `{ event, data: { trip_id, status, driver: { lat, lng, heading, eta_seconds }, vehicle: { plate, make, model, color } } }` |
| **Processing** | 1. Subscribe to trip channel on WebSocket connect 2. Receive driver location updates every 5–10 seconds 3. Receive status change events in real-time 4. Calculate ETA from driver location to pickup/dropoff |
| **Error Handling** | Reconnect with exponential backoff (1s, 2s, 4s, 8s, max 30s); fall back to REST polling at 10s intervals |
| **Acceptance Criteria** | Location updates received within 2s of driver position change; ETA accurate within ±2 min |

#### SPEC-RIDE-03: Cancel a Trip

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-RIDE-14 |
| **Endpoint** | `POST /api/v1/trips/:tripId/cancel` |
| **Input** | `{ reason: string }` |
| **Processing** | 1. Validate trip is in cancellable state (requested, accepted, driver_en_route, driver_arrived) 2. Record cancellation with timestamp, actor, reason 3. Notify other party via push notification 4. Release driver to accept new requests 5. Apply cancellation fee if applicable (driver_arrived + >5 min wait) |
| **Output** | `{ trip_id, status: "cancelled", cancellation_fee?: number }` |
| **Error Handling** | `400` trip not cancellable (in_progress, completed); `404` trip not found |
| **Acceptance Criteria** | Trip status updated atomically; driver notified within 3s; audit log entry created |

---

### 3.3 Driver Module

#### SPEC-DRIV-01: Document Upload

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-DRIV-01, FR-DRIV-02 |
| **Endpoint** | `POST /api/v1/drivers/me/documents` |
| **Input** | Multipart form: `{ document_type: enum, file: binary (JPEG/PNG/PDF, max 10MB), license_number?: string, expiry_date: date }` |
| **Processing** | 1. Validate file type and size 2. Scan for malware (ClamAV) 3. Generate SHA-256 hash 4. Encrypt and upload to S3 5. Create document record (status: `pending`) 6. Validate expiry date is in the future 7. Add to admin verification queue |
| **Output** | `{ document_id, document_type, upload_timestamp, verification_status: "pending" }` |
| **Validation** | File: JPEG/PNG/PDF, ≤10MB; expiry_date > today; license_number format per type |
| **Error Handling** | `400` invalid file type/size; `422` expired document; `413` file too large |
| **Acceptance Criteria** | File encrypted at rest in S3; SHA-256 stored; admin queue entry created |

#### SPEC-DRIV-02: Toggle Online Status

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-DRIV-05 |
| **Endpoint** | `PUT /api/v1/drivers/me/status` |
| **Input** | `{ status: "online" \| "offline" }` |
| **Processing** | 1. Validate driver is approved and all documents current 2. If going online: begin location updates (expected every 10s) 3. If going offline: remove from matching pool 4. Update driver status in Redis and PostgreSQL |
| **Output** | `{ driver_id, status, active_documents_valid: boolean }` |
| **Error Handling** | `403` documents expired; `403` account suspended; `409` has active trip |
| **Acceptance Criteria** | Online driver appears in matching queries within 5s; offline driver excluded immediately |

#### SPEC-DRIV-03: Accept Trip Request

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-DRIV-07 |
| **Endpoint** | `POST /api/v1/trips/:tripId/accept` |
| **Input** | `{ driver_id }` (from JWT) |
| **Processing** | 1. Validate trip is in `requested` state and assigned to this driver 2. Validate acceptance within 30-second window 3. Update trip status to `accepted` → `driver_en_route` 4. Calculate ETA to pickup 5. Notify rider via WebSocket + push 6. Begin route recording |
| **Output** | `{ trip_id, status: "driver_en_route", eta_to_pickup_minutes, rider: { name, pickup_address } }` |
| **Error Handling** | `409` already accepted/cancelled; `408` timeout (>30s); `403` driver not assigned |
| **Acceptance Criteria** | Trip status updated atomically; rider notified within 3s; ETA calculated |

#### SPEC-DRIV-04: Complete Trip

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-DRIV-11 |
| **Endpoint** | `POST /api/v1/trips/:tripId/complete` |
| **Input** | `{ meter_reading_end: number }` |
| **Processing** | 1. Validate trip is `in_progress` 2. Validate meter_reading_end > meter_reading_start 3. Calculate fare from pricing service (tariff rates) 4. Calculate VAT (17%) 5. Process payment (card) or mark for cash confirmation 6. Generate receipt 7. Update trip status to `completed` 8. Unlock driver for new requests |
| **Output** | `{ trip_id, status: "completed", fare: FareBreakdown, receipt_id, payment_status }` |
| **Error Handling** | `400` invalid meter reading; `402` payment failed (retry); `409` wrong trip state |
| **Acceptance Criteria** | Fare matches tariff calculation; receipt generated with all required fields; ledger entry immutable |

---

### 3.4 Matching Module

#### SPEC-MATCH-01: Driver-Rider Matching

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-TRIP-01 through FR-TRIP-04 |
| **Internal Service** | Matching Service (triggered by Trip Service) |
| **Input** | `{ rider_id, pickup_location: GeoPoint, vehicle_requirements }` |
| **Processing** | 1. Query PostGIS: drivers within 5km, status=online, no active trip 2. Filter: wheelchair_accessible if required 3. Filter: rating ≥ 4.0 (or ≥ 3.5 for new drivers with <50 trips) 4. Score: distance (40%) + rating (25%) + acceptance_rate (20%) + vehicle_match (15%) 5. Send request to top-scored driver via WebSocket 6. Wait 30 seconds for response 7. If declined/timeout: next driver (up to 5 attempts) 8. If no match: expand to 10km and retry once 9. If still no match: notify rider "no drivers available" |
| **Output** | `{ matched: boolean, driver_id?, eta_minutes?, attempts }` |
| **Data Requirements** | Driver locations in Redis (updated every 10s); driver ratings in PostgreSQL; PostGIS spatial queries |
| **Error Handling** | No available drivers → rider notified; matching timeout → circuit breaker |
| **Acceptance Criteria** | Match found within 60s (95th percentile); distance calculation accurate within 500m |

---

### 3.5 Payment Module

#### SPEC-PAY-01: Fare Calculation

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-PAY-01, FR-PAY-04 |
| **Internal Service** | Pricing Service |
| **Input** | `{ tariff_type: "tariff_1" \| "tariff_2", meter_start: number, meter_end: number, trip_duration_minutes: number, waiting_minutes: number }` |
| **Processing** | 1. Determine tariff (day=tariff_1 / night+weekend=tariff_2) 2. Calculate: base = flag_drop_fee 3. distance_charge = (meter_end - meter_start) × distance_rate 4. time_charge = waiting_minutes × time_rate 5. subtotal = base + distance_charge + time_charge 6. vat = subtotal × 0.17 7. total = subtotal + vat 8. Round to 2 decimal places (ILS) |
| **Output** | `{ base_fare, distance_charge, time_charge, waiting_charge, subtotal, vat_rate: 0.17, vat_amount, total_amount, currency: "ILS" }` |
| **Validation** | meter_end ≥ meter_start; amounts ≥ 0; tariff rates from config (updatable by admin) |
| **Error Handling** | `400` invalid meter readings; fallback to estimate if meter data missing |
| **Acceptance Criteria** | Calculation matches official MoT tariff rates; VAT correct to the agora (0.01 ILS) |

#### SPEC-PAY-02: Process Card Payment

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-PAY-02 |
| **Internal Service** | Payment Service → Stripe API |
| **Input** | `{ trip_id, amount: number, currency: "ILS", payment_method_id: string }` |
| **Processing** | 1. Create Stripe PaymentIntent 2. Confirm payment using stored payment method 3. Handle 3D Secure if required 4. On success: update trip.payment_status = "completed" 5. On failure: retry once, then mark "failed" and notify rider 6. Record transaction_id for reconciliation |
| **Output** | `{ payment_status: "completed" \| "failed", transaction_id, error_message? }` |
| **Error Handling** | Card declined → notify rider to update payment; network error → retry with backoff; Stripe outage → queue for later |
| **Acceptance Criteria** | Payment processed within 10s; PCI DSS compliance maintained; no raw card data stored |

---

### 3.6 Safety Module

#### SPEC-SAFE-01: Panic Button

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-SAFE-01 through FR-SAFE-05 |
| **Endpoint** | `POST /api/v1/safety/panic` |
| **Input** | `{ trip_id, triggered_by: "rider" \| "driver", location: { lat, lng, accuracy } }` |
| **Processing** | 1. IMMEDIATELY freeze trip (no status changes) 2. Capture and encrypt current GPS location 3. Create safety_incident record (severity: critical) 4. Alert support team via internal push (60s SLA) 5. Send SMS/push to rider's emergency contacts with trip link 6. After 30 seconds: display emergency services UI (Police 100, MDA 101) 7. After 180 seconds without support response: auto-escalate 8. Intensify location tracking (every 2 seconds) |
| **Output** | `{ incident_id, status: "active", support_alerted: true, emergency_contacts_notified: true }` |
| **Error Handling** | Offline: fall back to native phone dialer for 100/101; partial failure: prioritize support alert |
| **Acceptance Criteria** | Trip frozen within 1s; support alerted within 5s; emergency contacts within 10s; all actions logged |

---

### 3.7 Compliance Module

#### SPEC-COMP-01: Document Expiry Tracking

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-COMP-02, FR-COMP-03 |
| **Internal Service** | Compliance Service (daily cron job) |
| **Processing** | 1. Query all documents with expiry_date within alert windows [90,60,30,14,7,1,0 days] 2. For each expiring document: a. Send notification to driver at configured intervals b. If expired (day 0): apply EXPIRY_ACTION per document type c. If driver has active trip: allow completion, then block d. 24-hour grace period before full suspension 3. Log all actions in audit_log |
| **Expiry Actions** | taxi_operating_license → suspend_driver; driver_license → suspend_driver; taxi_vehicle_license → suspend_vehicle; insurance_policy → suspend_vehicle; vehicle_inspection → suspend_vehicle; medical_certificate → flag_for_review |
| **Error Handling** | Job failure → alert ops team; retry within 1 hour |
| **Acceptance Criteria** | No driver with expired critical documents can accept new trips; notifications sent at all configured intervals |

#### SPEC-COMP-02: Audit Logging

| Attribute | Value |
|-----------|-------|
| **Requirement ID** | FR-COMP-04 |
| **Processing** | Every state-changing action records: `{ timestamp, actor_type, actor_id, action, entity_type, entity_id, old_value, new_value, request_id, session_id, ip_hash }` |
| **Storage** | PostgreSQL audit_log table with append-only rules (UPDATE/DELETE blocked at DB level) |
| **Retention** | 7 years minimum |
| **Acceptance Criteria** | No audit record can be modified or deleted; all admin actions logged; all trip state changes logged |

---

## 4. Non-Functional Requirements

### 4.1 Performance

| Metric | Target |
|--------|--------|
| API response time (p95) | < 200ms |
| WebSocket message delivery | < 2 seconds |
| Driver matching time (p95) | < 60 seconds |
| Payment processing | < 10 seconds |
| Page load (mobile app) | < 3 seconds |
| Concurrent active trips | 1,000 (MVP), scalable to 10,000 |
| System availability | 99.9% uptime |

### 4.2 Security

| Requirement | Implementation |
|-------------|---------------|
| Encryption at rest | AES-256-GCM (PostgreSQL column-level, S3 file-level) |
| Encryption in transit | TLS 1.3 mandatory |
| Payment security | PCI DSS Level 1; tokenization via Stripe |
| API authentication | JWT with 15-minute expiry |
| Admin access | MFA required |
| Rate limiting | Per-endpoint limits via API Gateway |
| Certificate pinning | Enforced on mobile apps |
| Input validation | Server-side via class-validator on all endpoints |
| SQL injection | Parameterized queries via Prisma ORM |
| XSS prevention | Content Security Policy headers; output encoding |

### 4.3 Scalability

| Component | Strategy |
|-----------|----------|
| Backend services | Horizontal scaling via Kubernetes HPA |
| Database | Read replicas for PostgreSQL; Redis cluster |
| File storage | S3 auto-scaling |
| WebSocket | Sticky sessions with Redis pub/sub for multi-node |
| Message queue | RabbitMQ clustering; migrate to Kafka at >10k concurrent |

### 4.4 Accessibility

| Requirement | Standard |
|-------------|----------|
| Mobile app | WCAG 2.1 AA |
| Screen readers | VoiceOver (iOS), TalkBack (Android) |
| Touch targets | Minimum 48dp × 48dp |
| Color contrast | Minimum 4.5:1 ratio |
| RTL support | Full Hebrew and Arabic layout support |
| Dynamic type | iOS Dynamic Type, Android font scaling |

### 4.5 Localization

| Language | MVP | Post-MVP |
|----------|-----|----------|
| Hebrew (he) | ✓ | ✓ |
| English (en) | ✓ | ✓ |
| Arabic (ar) | — | ✓ |

RTL layout automatically applied for Hebrew and Arabic via i18next direction detection.

---

## 5. Data Model

### 5.1 Entity Relationship Summary

```
riders (1) ──── (N) trips ──── (1) drivers
                  │                    │
                  │                    ├── (N) documents
                  │                    │
                  ├── (1) receipts     └── (N) vehicles
                  │                              │
                  ├── (N) complaints              └── (N) documents
                  │
                  └── (N) safety_incidents
```

### 5.2 Key Entities

| Entity | Primary Key | Key Fields | Relationships |
|--------|------------|------------|---------------|
| **riders** | UUID | phone_number (unique), full_name, preferred_language, recovery_email | Has many trips, complaints |
| **drivers** | UUID | rider_id (FK), full_legal_name, taxi_license_number, status | Has many trips, documents, vehicles |
| **vehicles** | UUID | driver_id (FK), license_plate, taxi_vehicle_license_number, wheelchair_accessible, status | Has many documents, trips |
| **documents** | UUID | entity_type, entity_id, document_type, file_path_encrypted, expiry_date, verification_status | Belongs to driver or vehicle |
| **trips** | UUID | trip_number (unique), rider_id, driver_id, vehicle_id, status, payment_method, timestamps, fare fields | Has one receipt; has many complaints, safety_incidents |
| **receipts** | UUID | trip_id (FK), receipt_number (unique), fare breakdown, VAT, total, receipt_hash | Belongs to trip |
| **complaints** | UUID | complaint_number (unique), trip_id, category, severity, status | Belongs to trip |
| **safety_incidents** | UUID | incident_number (unique), trip_id, incident_type, triggered_by, location_encrypted | Belongs to trip |
| **audit_log** | UUID | actor_type, actor_id, action, entity_type, entity_id, old/new_value | Append-only |

### 5.3 Data Retention

| Data | Retention | After Expiry |
|------|-----------|-------------|
| Rider account | Until deletion request + 30 days | Soft delete, anonymize |
| Trip records | 7 years | Archive to cold storage |
| Location (precise) | 30 days post-trip | Delete |
| Location (aggregated) | 2 years | Delete |
| Payment records | 7 years | Archive |
| Safety incidents | 7 years | Archive |
| Audit logs | 7 years | Archive |
| Documents (files) | Until replaced + 90 days | Delete from S3 |

---

## 6. Interface Requirements

### 6.1 REST API

- Base URL: `https://api.rideil.co.il/api/v1`
- Authentication: Bearer token (JWT)
- Format: JSON
- Documentation: OpenAPI 3.0 / Swagger
- Rate limits: Configurable per endpoint via API Gateway
- Versioning: URL path (`/v1/`)

### 6.2 WebSocket API

- URL: `wss://api.rideil.co.il/ws`
- Authentication: JWT token in connection handshake
- Protocol: Socket.IO (for reconnection and room management)
- Events: `driver:location_update`, `trip:status_changed`, `trip:driver_assigned`, `trip:eta_update`, `safety:alert`
- Heartbeat: 25-second interval; reconnect after 3 missed beats

### 6.3 External Integrations

| Service | Protocol | Authentication | Rate Limits |
|---------|----------|---------------|-------------|
| Stripe Israel | REST API | API key (secret) | 100 req/s |
| Google Maps Platform | REST + SDK | API key | Per-billing quota |
| Twilio | REST API | Account SID + Auth Token | Configurable |
| Firebase Cloud Messaging | REST API | Service account key | 500 msg/s |
| Amazon SES | AWS SDK | IAM role | Per-region limits |
| AWS S3 | AWS SDK | IAM role | 5,500 GET/s, 3,500 PUT/s |

### 6.4 Admin Web Portal

- Technology: React (web)
- Authentication: Email + password + MFA (TOTP)
- Access: Role-based (super_admin, compliance_officer, support_agent)
- Features: Driver queue, compliance dashboard, trip lookup, complaint management, report generation

---

## 7. Technical Constraints

### 7.1 Platform Requirements

| Constraint | Value |
|-----------|-------|
| iOS minimum | iOS 15+ |
| Android minimum | API 28 (Android 9.0) |
| Android target API | API 34 (Android 14) |
| Node.js | 20 LTS |
| PostgreSQL | 15+ |
| Redis | 7+ |

### 7.2 Regulatory Constraints

| Constraint | Impact |
|-----------|--------|
| Israeli taxi tariff rates | No dynamic/surge pricing; rates from MoT config |
| Amendment 13 (Privacy) | DPO required; 72-hour breach notification; data subject rights |
| PCI DSS Level 1 | No raw card storage; tokenization mandatory |
| Data residency | Primary data in AWS il-central-1 (Israel) |
| Electronic Invoice Law | Receipt format must comply with Israeli requirements |
| Accessibility law | WCAG 2.1 AA; VoiceOver/TalkBack support |

### 7.3 Operational Constraints

| Constraint | Value |
|-----------|-------|
| Deployment window | Blue-green deployments; zero downtime |
| Backup frequency | Continuous (PostgreSQL WAL); daily snapshots |
| Recovery time objective (RTO) | 1 hour |
| Recovery point objective (RPO) | 5 minutes |
| Log retention | 7 years (compliance); 90 days (operational) |

---

*End of Functional Requirements Specification*
