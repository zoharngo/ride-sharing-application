# RideIL Implementation Checklist

**Version:** 1.0
**Date:** January 26, 2026
**Purpose:** Development team task tracking for MVP launch

---

## Pre-Development Setup

### Legal & Compliance
- [ ] Engage Israeli labor law counsel for driver agreements
- [ ] Confirm taxi dispatch license requirements with Ministry of Transportation
- [ ] Appoint Data Protection Officer (DPO) - Required by Amendment 13
- [ ] Register database with Privacy Protection Authority
- [ ] Draft driver contractor agreement template

### Infrastructure Setup
- [ ] Create AWS account with il-central-1 as primary region
- [ ] Set up eu-west-1 as disaster recovery region
- [ ] Configure Terraform for infrastructure-as-code
- [ ] Set up GitHub Actions CI/CD pipeline
- [ ] Configure AWS Secrets Manager with rotation policies
- [ ] Set up VPC with private subnets for data layer

### Third-Party Accounts
- [ ] Stripe Israel merchant account setup
- [ ] Google Maps Platform API keys and billing
- [ ] Twilio account for SMS/OTP
- [ ] Firebase project for push notifications
- [ ] Amazon SES for transactional email

---

## Phase 1: Foundation & Compliance Core

### Database (PostgreSQL)
- [ ] Create `riders` table with recovery email field
- [ ] Create `drivers` table with all verification fields
- [ ] Create `vehicles` table with accessibility flag
- [ ] Create `documents` table with verification workflow
- [ ] Create `trips` table with timeout fields (no circular FK)
- [ ] Create `receipts` table (linked via trip_id only)
- [ ] Create `audit_log` table with append-only rules
- [ ] Set up column-level encryption for sensitive fields
- [ ] Create database indexes per schema specification
- [ ] Set up automated backups with encryption

### Authentication Service
- [ ] Implement phone + OTP registration flow
- [ ] Implement OTP verification with rate limiting
- [ ] Implement JWT token generation (15 min expiry)
- [ ] Implement refresh token flow (7 day expiry)
- [ ] Add optional email for account recovery
- [ ] Implement session management with Redis
- [ ] Add multi-device session handling

### Driver Onboarding API
- [ ] POST /drivers/register - Basic registration
- [ ] POST /drivers/me/documents - Document upload
- [ ] GET /drivers/me/documents - List documents
- [ ] Implement document validation (format, dates)
- [ ] Create verification queue for admin
- [ ] Implement document expiry tracking
- [ ] Add expiry notification system (90, 60, 30, 14, 7, 1 days)

### Admin API (Basic)
- [ ] GET /admin/drivers/pending - Verification queue
- [ ] POST /admin/drivers/:id/verify - Approve driver
- [ ] POST /admin/drivers/:id/reject - Reject with reason
- [ ] POST /admin/drivers/:id/suspend - Suspend driver
- [ ] Implement audit logging for all admin actions
- [ ] Add admin MFA requirement

### Document Storage (S3)
- [ ] Create encrypted S3 bucket
- [ ] Implement presigned URL generation for uploads
- [ ] Add access logging for compliance
- [ ] Set up lifecycle policies for document retention

---

## Phase 2: Core Ride-Sharing Features

### Rider Mobile App (React Native)
- [ ] Splash screen with branding
- [ ] Registration screen (phone entry)
- [ ] OTP verification screen
- [ ] Home screen with map (Google Maps SDK)
- [ ] Destination entry with autocomplete
- [ ] Ride confirmation with fare estimate
- [ ] Finding driver animation screen
- [ ] Driver assigned with ETA display
- [ ] Trip in progress with live tracking
- [ ] Trip complete with fare breakdown
- [ ] Basic rating (1-5 stars)
- [ ] Profile screen
- [ ] Payment methods management
- [ ] Trip history list
- [ ] Hebrew and English localization
- [ ] RTL layout support for Hebrew

### Driver Mobile App (React Native)
- [ ] Splash screen
- [ ] Registration flow
- [ ] Document upload wizard (multi-step)
- [ ] Pending verification status screen
- [ ] Home screen with online/offline toggle
- [ ] Incoming request with 30-second timer
- [ ] Navigation integration (Google Maps)
- [ ] At pickup confirmation
- [ ] Trip in progress view
- [ ] Complete trip with meter entry
- [ ] Basic rating for rider
- [ ] Profile and document management
- [ ] Hebrew and English localization

### Location Service
- [ ] Driver location update endpoint (PUT /location/driver)
- [ ] Location caching in Redis
- [ ] ETA calculation integration
- [ ] Location history storage (encrypted)
- [ ] Collection frequency: 10 seconds during trip

### Matching Service
- [ ] Implement nearest-driver query (PostGIS)
- [ ] Add driver rating filter (minimum 4.0)
- [ ] Add acceptance rate weighting
- [ ] Implement 30-second acceptance timeout
- [ ] Add retry logic (up to 5 drivers)
- [ ] Special case: wheelchair-accessible matching
- [ ] New driver protection (first 50 trips, 3.5 rating threshold)

### Trip Service
- [ ] POST /trips/estimate - Fare estimate
- [ ] POST /trips/request - Create trip request
- [ ] POST /trips/:id/accept - Driver accepts
- [ ] POST /trips/:id/arrive - Driver arrived
- [ ] POST /trips/:id/start - Start trip
- [ ] POST /trips/:id/complete - Complete trip
- [ ] POST /trips/:id/cancel - Cancel with reason
- [ ] Implement trip state machine with valid transitions
- [ ] Add timeout enforcement (acceptance, arrival, pickup)

### Notification Service
- [ ] Firebase Cloud Messaging integration
- [ ] Trip status change notifications
- [ ] Driver assignment notification
- [ ] Driver arrived notification
- [ ] Trip complete notification
- [ ] Document expiry reminders

---

## Phase 3: Payment & Receipts

### Pricing Service
- [ ] Implement Israeli taxi tariff calculation
- [ ] Support Tariff 1 and Tariff 2 rates
- [ ] Calculate VAT (17%)
- [ ] Generate fare estimates from distance/time
- [ ] Support meter reading input

### Payment Integration (Stripe)
- [ ] Stripe Israel account connection
- [ ] Card tokenization for PCI compliance
- [ ] Payment intent creation
- [ ] Payment confirmation after trip
- [ ] Refund processing capability
- [ ] Payment method management API

### Cash Payment Flow
- [ ] Payment method selection (card/cash) in app
- [ ] Cash indicator on driver trip request
- [ ] Driver cash confirmation flow
- [ ] "Cash Not Received" flagging
- [ ] Cash trip receipt generation

### Receipt Generation
- [ ] Generate unique receipt numbers
- [ ] Itemized breakdown (base, distance, time, VAT)
- [ ] Company VAT number inclusion
- [ ] PDF generation for download
- [ ] Email receipt delivery
- [ ] Receipt hash for integrity

### Trip Ledger
- [ ] Immutable trip record storage
- [ ] Audit trail for all changes
- [ ] Compliance report queries
- [ ] Data export functionality

---

## Phase 4: Safety & Support Systems

### Panic Button
- [ ] Panic button UI (prominent, red)
- [ ] Trip freeze on trigger
- [ ] Location capture at trigger time
- [ ] Support team alert (60-second SLA)
- [ ] Emergency contacts notification
- [ ] Emergency services prompt (after 30 seconds)
- [ ] Auto-escalation (180 seconds without response)
- [ ] Safety incident logging

### Emergency Contacts
- [ ] Add/edit emergency contacts in profile
- [ ] Contact notification on panic trigger
- [ ] Trip sharing link generation

### Trip Sharing
- [ ] Generate shareable trip link
- [ ] Real-time location visible to contact
- [ ] Auto-expire after trip completion

### Complaint System
- [ ] In-app complaint submission
- [ ] Link to specific trip
- [ ] Category selection
- [ ] Evidence upload (photos)
- [ ] Support ticket creation
- [ ] Status tracking for user

### Rating System
- [ ] 1-5 star rating UI
- [ ] Optional comment field
- [ ] Rolling 100-trip average calculation
- [ ] Rating threshold enforcement (4.0 minimum)
- [ ] Warning system for low ratings
- [ ] New driver protection implementation

---

## Phase 5: Admin & Compliance Tooling

### Admin Portal (Web)
- [ ] Admin authentication with MFA
- [ ] Driver management dashboard
- [ ] Vehicle management dashboard
- [ ] Document verification queue
- [ ] Compliance dashboard (expiring documents)
- [ ] Trip lookup and investigation tools
- [ ] Complaint management interface
- [ ] User management tools

### Compliance Dashboard
- [ ] Document expiry calendar view
- [ ] At-risk driver/vehicle alerts
- [ ] Compliance metrics charts
- [ ] Automated report generation

### Report Generator
- [ ] Trip history reports
- [ ] Driver activity reports
- [ ] Vehicle activity reports
- [ ] Complaint summary reports
- [ ] Safety incident reports
- [ ] Export to PDF, CSV, JSON

---

## Phase 6: Launch Preparation

### Security Audit
- [ ] Third-party penetration testing
- [ ] Fix all critical/high findings
- [ ] Document remediation

### Privacy Audit
- [ ] Amendment 13 compliance verification
- [ ] Data flow documentation
- [ ] Privacy Impact Assessment completion

### Load Testing
- [ ] Test system at 10x expected peak
- [ ] Identify and fix bottlenecks
- [ ] Document capacity limits

### App Store Submission
- [ ] Hebrew app store listing (Google Play)
- [ ] Hebrew app store listing (Apple)
- [ ] Privacy policy hosted and linked
- [ ] Data Safety form completed (Google)
- [ ] App Privacy labels completed (Apple)
- [ ] iOS permission descriptions added
- [ ] Export compliance declaration
- [ ] Age rating questionnaire completed

### Legal Documents
- [ ] Privacy Policy (Hebrew, English)
- [ ] Terms of Service (Hebrew, English)
- [ ] Driver Agreement finalized
- [ ] All documents reviewed by legal counsel

### Operations Readiness
- [ ] Incident response runbook
- [ ] Support team training completed
- [ ] Escalation procedures documented
- [ ] Emergency contacts configured

---

## Offline Mode Implementation

### Rider App
- [ ] Local request queue with retry
- [ ] "Connecting..." indicator
- [ ] Last known driver location display
- [ ] Encrypted payment intent storage
- [ ] Automatic sync on reconnection

### Driver App
- [ ] Offline warning display
- [ ] Local GPS recording during trip
- [ ] Encrypted route data storage
- [ ] Offline trip completion capability
- [ ] Automatic sync on reconnection

### Sync Service
- [ ] Priority-based sync (safety first)
- [ ] Conflict resolution for trip states
- [ ] 30-minute maximum offline duration
- [ ] Re-authentication requirement after timeout

---

## Testing Requirements

### Unit Tests
- [ ] Authentication service tests
- [ ] Matching algorithm tests
- [ ] Fare calculation tests
- [ ] Trip state machine tests
- [ ] Rating calculation tests

### Integration Tests
- [ ] End-to-end trip flow
- [ ] Payment processing flow
- [ ] Document verification flow
- [ ] Notification delivery

### Mobile App Tests
- [ ] UI component tests
- [ ] Navigation flow tests
- [ ] Offline mode tests
- [ ] Localization tests (Hebrew RTL)

### Security Tests
- [ ] Authentication bypass attempts
- [ ] SQL injection testing
- [ ] XSS testing
- [ ] Rate limiting verification
- [ ] Certificate pinning verification

### Accessibility Tests
- [ ] VoiceOver testing (iOS)
- [ ] TalkBack testing (Android)
- [ ] Color contrast verification
- [ ] Touch target size verification

---

## Monitoring & Observability

### Prometheus Metrics
- [ ] Request latency histograms
- [ ] Error rate counters
- [ ] Active trips gauge
- [ ] Driver online count gauge
- [ ] Payment success rate

### Grafana Dashboards
- [ ] System overview dashboard
- [ ] Trip metrics dashboard
- [ ] Payment metrics dashboard
- [ ] Error tracking dashboard

### Alerting Rules
- [ ] High error rate alert
- [ ] Payment failure spike alert
- [ ] System unavailability alert
- [ ] Safety incident alert

### Logging (ELK)
- [ ] Structured logging format
- [ ] Request correlation IDs
- [ ] Audit log indexing
- [ ] Log retention policies

---

## Definition of Done

Each feature is considered complete when:
- [ ] Code reviewed and approved
- [ ] Unit tests passing (>80% coverage)
- [ ] Integration tests passing
- [ ] Security review completed
- [ ] Accessibility verified
- [ ] Hebrew localization complete
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] QA sign-off received

---

*Last updated: January 26, 2026*
