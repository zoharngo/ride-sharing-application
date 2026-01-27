# RideIL — Functional Requirements Document (FRD)

**Document Version:** 1.0
**Date:** January 27, 2026
**Project:** RideIL — Compliant Ride-Sharing Platform for Israel
**Target Launch:** Q2 2026 (Phased)

---

## 1. Executive Summary

RideIL is a mobile taxi-dispatch platform that connects passengers with licensed taxi drivers in Israel. The platform operates under a **taxi-dispatch model**, the only legally compliant approach for paid ride-hailing in Israel as of January 2026. The application will be available on iOS and Android, supporting Hebrew, Arabic, and English.

### Business Objectives

| # | Objective |
|---|-----------|
| BO-1 | Launch a fully compliant taxi-dispatch service in Israel |
| BO-2 | Comply with Israeli Protection of Privacy Law (Amendment 13) |
| BO-3 | Comply with Ministry of Transportation driver/vehicle licensing |
| BO-4 | Provide a safe, transparent ride experience for passengers and drivers |
| BO-5 | Build a future-ready architecture that can activate private-driver features when legislation passes |
| BO-6 | Achieve app store approval on both Google Play and Apple App Store |

### Key Success Metrics

- Driver onboarding pipeline active with document verification
- End-to-end ride flow operational (request → match → trip → payment → receipt)
- App store listings approved in both stores
- Zero critical compliance findings at launch audit

---

## 2. Project Scope

### 2.1 In Scope (MVP)

| Area | Features |
|------|----------|
| **Authentication** | Phone+OTP registration/login, JWT sessions, optional email recovery |
| **Rider Experience** | Ride request, destination search, fare estimate, real-time driver tracking, trip completion, payment, digital receipt, rating |
| **Driver Experience** | Registration, document upload, online/offline toggle, trip acceptance, navigation, meter entry, trip completion, rating |
| **Matching** | Nearest-driver matching with rating and acceptance-rate weighting |
| **Payment** | Credit card (Stripe Israel), cash option, VAT-compliant receipts |
| **Safety** | Panic button (support alert), trip sharing link |
| **Compliance** | Driver/vehicle document verification, expiry tracking, audit logging |
| **Admin** | Driver verification queue, approve/reject, basic dashboard |
| **Localization** | Hebrew and English (MVP), Arabic (post-MVP) |

### 2.2 Out of Scope (MVP)

- Private-driver ride-hailing mode (pending legislation)
- Scheduled rides
- In-app messaging between rider and driver
- Promo codes and referral programs
- Advanced analytics and heat maps
- Lost-and-found system
- Full Arabic localization (deferred to post-MVP)
- Cash settlement/reconciliation system
- Multi-vehicle management per driver

---

## 3. Stakeholders

### 3.1 Primary Users

| Stakeholder | Description | Key Needs |
|-------------|-------------|-----------|
| **Riders** | Passengers requesting taxi rides in Israel | Quick ride request, transparent pricing, safety, digital receipt |
| **Drivers** | Licensed taxi drivers with valid operating rights | Easy onboarding, fair matching, clear earnings, document management |
| **Admin Staff** | Operations, compliance, and support personnel | Driver verification tools, compliance monitoring, complaint handling |

### 3.2 Secondary Stakeholders

| Stakeholder | Interest |
|-------------|----------|
| Ministry of Transportation | Regulatory compliance of drivers and vehicles |
| Privacy Protection Authority | Data handling compliance under Amendment 13 |
| Tax Authority | VAT reporting on all trip receipts |
| Payment Processors | PCI DSS compliant transaction processing |
| Insurance Providers | Valid commercial passenger transport coverage |

---

## 4. Functional Requirements

### 4.1 Authentication and Account Management

| ID | Requirement | Priority |
|----|------------|----------|
| FR-AUTH-01 | System shall allow rider registration via Israeli phone number (+972) with OTP verification | P0 |
| FR-AUTH-02 | System shall allow driver registration via phone number with OTP verification | P0 |
| FR-AUTH-03 | System shall issue JWT access tokens (15-minute expiry) and refresh tokens (7-day expiry) | P0 |
| FR-AUTH-04 | System shall allow optional email registration for account recovery | P1 |
| FR-AUTH-05 | System shall support logout and session termination | P0 |
| FR-AUTH-06 | Admin users shall authenticate with multi-factor authentication | P0 |
| FR-AUTH-07 | System shall enforce rate limiting on OTP requests (max 5 per hour per number) | P0 |

### 4.2 Rider Features

| ID | Requirement | Priority |
|----|------------|----------|
| FR-RIDE-01 | Rider shall see a map centered on current GPS location on the home screen | P0 |
| FR-RIDE-02 | Rider shall enter a destination using address search with autocomplete | P0 |
| FR-RIDE-03 | Rider shall see a fare estimate based on Israeli taxi tariff rates before confirming | P0 |
| FR-RIDE-04 | Rider shall select payment method (card or cash) before requesting a ride | P0 |
| FR-RIDE-05 | Rider shall be able to request a wheelchair-accessible vehicle | P0 |
| FR-RIDE-06 | Rider shall see assigned driver's name, photo, rating, vehicle details, and ETA | P0 |
| FR-RIDE-07 | Rider shall track the driver's real-time location on the map | P0 |
| FR-RIDE-08 | Rider shall receive push notifications for trip status changes | P0 |
| FR-RIDE-09 | Rider shall see an itemized fare breakdown at trip completion including VAT | P0 |
| FR-RIDE-10 | Rider shall receive a digital receipt for every completed trip | P0 |
| FR-RIDE-11 | Rider shall rate the driver on a 1–5 star scale after trip completion | P1 |
| FR-RIDE-12 | Rider shall view trip history with details and receipts | P1 |
| FR-RIDE-13 | Rider shall manage saved payment methods | P1 |
| FR-RIDE-14 | Rider shall be able to cancel a ride before the trip starts | P0 |
| FR-RIDE-15 | Rider shall be able to share a live trip link with an emergency contact | P1 |
| FR-RIDE-16 | Rider shall trigger a panic button during an active trip | P0 |
| FR-RIDE-17 | Rider shall submit a complaint linked to a specific trip | P1 |
| FR-RIDE-18 | Rider shall manage profile information (name, email, language preference) | P1 |
| FR-RIDE-19 | Rider shall request deletion of personal data (GDPR-style right to erasure) | P0 |

### 4.3 Driver Features

| ID | Requirement | Priority |
|----|------------|----------|
| FR-DRIV-01 | Driver shall register and upload required licensing documents | P0 |
| FR-DRIV-02 | Driver shall upload: taxi operating license, driver license, medical certificate, background check, training certificate | P0 |
| FR-DRIV-03 | Driver shall register a vehicle with: details, taxi vehicle license, inspection certificate, meter certification, insurance | P0 |
| FR-DRIV-04 | Driver shall see onboarding status (pending verification, approved, rejected) | P0 |
| FR-DRIV-05 | Driver shall toggle online/offline availability status | P0 |
| FR-DRIV-06 | Driver shall receive ride requests with pickup location, distance, fare estimate, and rider rating | P0 |
| FR-DRIV-07 | Driver shall accept or decline a ride request within 30 seconds | P0 |
| FR-DRIV-08 | Driver shall receive navigation to pickup location | P0 |
| FR-DRIV-09 | Driver shall confirm arrival at pickup location | P0 |
| FR-DRIV-10 | Driver shall start a trip and enter meter reading at start | P0 |
| FR-DRIV-11 | Driver shall complete a trip and enter meter reading at end | P0 |
| FR-DRIV-12 | Driver shall confirm cash received (for cash payment trips) | P0 |
| FR-DRIV-13 | Driver shall rate the rider on a 1–5 star scale | P1 |
| FR-DRIV-14 | Driver shall view trip history and earnings summary | P1 |
| FR-DRIV-15 | Driver shall receive alerts when documents are expiring (90, 60, 30, 14, 7, 1 days) | P0 |
| FR-DRIV-16 | Driver shall be suspended automatically when a critical document expires | P0 |
| FR-DRIV-17 | Driver shall trigger a panic button during an active trip | P0 |

### 4.4 Matching and Trip Management

| ID | Requirement | Priority |
|----|------------|----------|
| FR-TRIP-01 | System shall match riders with the nearest available qualified driver within 5 km | P0 |
| FR-TRIP-02 | Matching shall use weighted scoring: distance (40%), rating (25%), acceptance rate (20%), vehicle match (15%) | P0 |
| FR-TRIP-03 | System shall expand search radius to 10 km if no drivers found within 5 km | P0 |
| FR-TRIP-04 | System shall attempt up to 5 driver matches before returning "no drivers available" | P0 |
| FR-TRIP-05 | System shall enforce the trip state machine: requested → accepted → driver_en_route → driver_arrived → in_progress → completed | P0 |
| FR-TRIP-06 | System shall allow cancellation from any pre-trip state with logged reason | P0 |
| FR-TRIP-07 | System shall enforce timeout: 30s driver acceptance, ETA+10min arrival, 5min rider pickup, 10min trip start | P0 |
| FR-TRIP-08 | System shall maintain an immutable trip ledger with cryptographic hashes | P0 |
| FR-TRIP-09 | New drivers (first 50 trips) shall have reduced rating threshold of 3.5 | P1 |

### 4.5 Payment and Receipts

| ID | Requirement | Priority |
|----|------------|----------|
| FR-PAY-01 | System shall calculate fares using Israeli taxi tariff rates (Tariff 1 and 2) | P0 |
| FR-PAY-02 | System shall process credit card payments through Stripe Israel | P0 |
| FR-PAY-03 | System shall support cash payments with driver confirmation | P0 |
| FR-PAY-04 | System shall calculate and display 17% VAT on all receipts | P0 |
| FR-PAY-05 | System shall generate a unique receipt number for every completed trip | P0 |
| FR-PAY-06 | Receipt shall include: company details, trip details, fare breakdown, VAT, driver/vehicle info, meter readings | P0 |
| FR-PAY-07 | System shall produce receipts in PDF format for download | P1 |
| FR-PAY-08 | System shall block riders with >2 unpaid cash trips from using cash payment | P0 |

### 4.6 Safety

| ID | Requirement | Priority |
|----|------------|----------|
| FR-SAFE-01 | Panic button shall freeze the trip and capture GPS location | P0 |
| FR-SAFE-02 | Panic button shall alert the support team within 60 seconds SLA | P0 |
| FR-SAFE-03 | Emergency contacts shall be notified immediately on panic trigger | P0 |
| FR-SAFE-04 | Emergency services UI (Police 100, MDA 101) shall display after 30 seconds | P0 |
| FR-SAFE-05 | Auto-escalation to emergency services if no support response within 180 seconds | P1 |
| FR-SAFE-06 | Trip sharing shall generate a link with live location visible to contact | P1 |

### 4.7 Compliance and Admin

| ID | Requirement | Priority |
|----|------------|----------|
| FR-COMP-01 | Admin shall review, approve, reject, or suspend driver applications | P0 |
| FR-COMP-02 | System shall track all document expiry dates and auto-suspend on expiry | P0 |
| FR-COMP-03 | System shall allow mid-trip completion but block new trips when documents expire | P0 |
| FR-COMP-04 | System shall log all admin actions immutably (actor, action, entity, timestamp, reason) | P0 |
| FR-COMP-05 | System shall generate compliance reports (trip history, driver activity, complaints) | P1 |
| FR-COMP-06 | System shall support data export in PDF, CSV, and JSON formats | P1 |
| FR-COMP-07 | Admin dashboard shall show document expiry alerts, compliance metrics, and pending verifications | P0 |
| FR-COMP-08 | System shall support data subject access requests (view, export, delete personal data) | P0 |

### 4.8 Offline Mode

| ID | Requirement | Priority |
|----|------------|----------|
| FR-OFF-01 | Rider app shall queue ride requests locally and retry on reconnection | P1 |
| FR-OFF-02 | Driver app shall continue GPS recording locally during offline active trips | P0 |
| FR-OFF-03 | Driver app shall allow trip completion offline and sync on reconnection | P0 |
| FR-OFF-04 | System shall require re-authentication after 30 minutes offline | P0 |
| FR-OFF-05 | Panic button shall fall back to native phone dialer when offline | P0 |

---

## 5. User Stories and Use Cases

### 5.1 Rider Use Cases

**UC-R1: Request a Ride**
> As a rider, I want to enter my destination and request a taxi so that I can get a ride to my location.

Flow:
1. Rider opens app and sees map centered on current location
2. Rider taps "Where to?" and searches for destination
3. System displays fare estimate based on tariff
4. Rider selects payment method (card/cash)
5. Rider taps "Request Taxi"
6. System matches rider with nearest qualified driver
7. Rider sees driver details, vehicle info, and ETA

**UC-R2: Complete a Trip**
> As a rider, I want to see my fare breakdown and receive a receipt so that I have a record of the trip.

Flow:
1. Driver completes the trip and enters final meter reading
2. System calculates fare with VAT
3. Rider sees itemized fare breakdown
4. Payment is processed (card) or driver confirms cash received
5. Digital receipt is generated and available in app
6. Rider is prompted to rate the driver

**UC-R3: Trigger Panic Button**
> As a rider, I want to press a panic button during a trip so that help is alerted immediately.

Flow:
1. Rider presses the safety button (always visible during trip)
2. Trip is frozen (no status changes allowed)
3. Precise GPS location captured
4. Support team alerted (critical priority)
5. Emergency contacts notified
6. After 30 seconds, emergency services dial options appear
7. If no support response in 180 seconds, auto-escalation

### 5.2 Driver Use Cases

**UC-D1: Onboard as a Driver**
> As a taxi driver, I want to register on the platform and submit my documents so that I can start receiving ride requests.

Flow:
1. Driver registers with phone + OTP
2. Driver enters personal information
3. Driver uploads taxi operating license (photo + details)
4. Driver uploads driver's license
5. Driver uploads additional certifications
6. Driver registers vehicle with documents
7. Driver sees "Pending Verification" status
8. Admin reviews and approves/rejects
9. Driver receives activation notification

**UC-D2: Accept and Complete a Trip**
> As a driver, I want to receive and complete ride requests so that I can earn fares.

Flow:
1. Driver toggles to "Online" status
2. System pushes ride request with 30-second timer
3. Driver accepts (or declines / times out)
4. Driver navigates to pickup location
5. Driver confirms arrival
6. Rider boards, driver starts trip
7. Navigation to destination
8. Driver completes trip, enters meter reading
9. Payment processed, driver rates rider

### 5.3 Admin Use Cases

**UC-A1: Verify a Driver**
> As an admin, I want to review driver documents so that only compliant drivers operate on the platform.

Flow:
1. Admin opens verification queue
2. Admin selects a pending driver application
3. Admin reviews each uploaded document
4. Admin cross-references document details
5. Admin approves, requests additional info, or rejects with reason
6. Decision logged immutably
7. Driver notified of outcome

---

## 6. Business Rules

### 6.1 Regulatory Rules

| ID | Rule |
|----|------|
| BR-01 | Only licensed taxi drivers with valid operating rights may operate on the platform |
| BR-02 | All vehicles must hold a valid taxi vehicle operating license |
| BR-03 | Fare calculation must use regulated Israeli taxi tariff rates (no surge/dynamic pricing) |
| BR-04 | VAT (17%) must be calculated, displayed, and included on all receipts |
| BR-05 | Digital receipts must comply with Israeli Electronic Invoice Law |
| BR-06 | Precise location data retained max 30 days post-trip; aggregated data max 2 years |
| BR-07 | Data breach notification must be sent to Privacy Protection Authority within 72 hours |
| BR-08 | All personal data processing must have documented lawful basis |

### 6.2 Operational Rules

| ID | Rule |
|----|------|
| BR-09 | Drivers with expired critical documents (license, insurance) are auto-suspended |
| BR-10 | Drivers currently on a trip may complete it even if a document expires mid-trip |
| BR-11 | Grace period of 24 hours after document expiry for renewal before full suspension |
| BR-12 | Drivers with a rating below 4.0 (rolling 100-trip average) are deprioritized in matching |
| BR-13 | Drivers with a rating below 3.0 for 2 consecutive weeks are temporarily suspended |
| BR-14 | Riders with >2 unpaid cash trips are blocked from using cash payment |
| BR-15 | New drivers (first 50 trips) have a reduced rating threshold of 3.5 |
| BR-16 | Maximum 5 match attempts before "no drivers available" is returned to rider |

### 6.3 Safety Rules

| ID | Rule |
|----|------|
| BR-17 | Panic button events are treated as critical severity with 1-hour response SLA |
| BR-18 | Support must respond to panic alerts within 60 seconds |
| BR-19 | Drivers cannot refuse passengers with service animals |
| BR-20 | All safety incidents are logged immutably and retained for 7 years |

---

## 7. Assumptions and Dependencies

### 7.1 Assumptions

| # | Assumption |
|---|-----------|
| A-1 | Israeli taxi-dispatch model legislation remains stable through launch |
| A-2 | Drivers already hold valid taxi operating licenses from the Ministry of Transportation |
| A-3 | Google Maps Platform provides adequate coverage and Hebrew routing in Israel |
| A-4 | Stripe Israel supports the required payment flows and card types |
| A-5 | Ministry of Transportation APIs for license verification may not be available; manual verification is the MVP fallback |
| A-6 | Users have smartphones with GPS capability and data connectivity |
| A-7 | Israeli VAT rate remains at 17% through launch period |

### 7.2 Dependencies

| # | Dependency | Risk if Unavailable |
|---|-----------|---------------------|
| D-1 | AWS il-central-1 region availability | Must use eu-west-1 with higher latency |
| D-2 | Stripe Israel merchant account approval | Delay payment feature; use alternative provider |
| D-3 | Google Maps Platform API access | No routing/geocoding; must find alternative |
| D-4 | Apple App Store approval | Cannot launch on iOS |
| D-5 | Google Play Store approval | Cannot launch on Android |
| D-6 | Twilio SMS delivery in Israel | Cannot send OTP; use backup provider (019) |
| D-7 | Data Protection Officer appointment | Required before processing personal data |
| D-8 | Taxi dispatch service license (if required) | May not be able to legally operate |

---

*End of Functional Requirements Document*
