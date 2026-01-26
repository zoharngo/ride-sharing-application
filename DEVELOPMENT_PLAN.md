# Israeli Ride-Sharing Application - Comprehensive Development Plan

**Project Name:** RideIL - Compliant Ride-Sharing Platform for Israel
**Version:** 1.1
**Date:** January 26, 2026
**Last Updated:** January 26, 2026 (Technical Review Revisions)
**Target Launch:** Phased approach beginning Q2 2026

---

## Table of Contents

1. [Regulatory Compliance Framework](#1-regulatory-compliance-framework)
2. [Technical Architecture](#2-technical-architecture)
3. [Compliance Features](#3-compliance-features)
4. [Development Roadmap](#4-development-roadmap)
5. [Risk Assessment](#5-risk-assessment)
6. [Ongoing Compliance](#6-ongoing-compliance)

---

## 1. Regulatory Compliance Framework

### 1.1 Legal Operating Model

#### Current Legal Baseline (January 2026)

The application will operate under a **taxi-dispatch model** as the legally valid baseline in Israel. This model connects passengers exclusively with licensed taxi drivers and registered taxi vehicles. This approach ensures compliance with current Israeli transportation law while positioning for future regulatory changes.

**Key Legal Context:**
- Private-driver paid ride-hailing (Uber/Lyft model) is advancing through proposed legislation ("Arrangement for online ride-sharing services") but is **not yet finalized** as an operative framework
- The ministerial committee approved the bill on January 18, 2026, but it still requires full parliamentary (Knesset) approval
- Until the legislation passes, the taxi-dispatch model is the only legally compliant approach

#### Future-Ready Architecture

The system architecture will include feature flags and modular components to enable rapid activation of private-driver ride-hailing features once legislation is enacted, including:
- Non-taxi driver screening workflows
- Private vehicle registration
- Enhanced insurance verification
- Consumer protection disclosures specific to the new framework

### 1.2 Ministry of Transportation Requirements

#### 1.2.1 Driver Licensing Requirements

All drivers must hold valid **taxi operating rights/licenses** issued by the Ministry of Transportation:

| Requirement | Description | Verification Method |
|------------|-------------|---------------------|
| Taxi Operating Right (Public Right) | License to operate as a taxi driver | Document upload + API verification (if available) |
| Valid Israeli Driver's License | With appropriate category for passenger transport | Document upload + periodic re-verification |
| Medical Fitness Certificate | Required for commercial passenger transport | Document upload with expiry tracking |
| Background Check Clearance | Police clearance certificate | Document upload + periodic renewal |
| Professional Training Certification | Completion of taxi driver training | Certificate upload |

**Application Reference:** [gov.il - Taxi Operation License Request](https://www.gov.il/en/service/taxi_operation_licence_request)

#### 1.2.2 Vehicle Licensing Requirements

All vehicles must hold valid **taxi vehicle operating licenses**:

| Requirement | Description | Renewal Period |
|------------|-------------|----------------|
| Taxi Vehicle Operating License | Vehicle registered as taxi | Annual |
| Vehicle Roadworthiness Certificate | Annual vehicle inspection (test) | Annual |
| Taxi Meter Certification | Calibrated and sealed meter | Per regulation |
| Commercial Insurance | Comprehensive coverage for passenger transport | Annual |
| Vehicle Age Compliance | Maximum age limits per regulation | Ongoing |

**Application Reference:** [gov.il - Taxi Vehicle License Request](https://www.gov.il/en/service/taxi_vehicle_license_request)

#### 1.2.3 Fare and Meter Regulations

Israeli taxi regulations require:
- **Meter-based pricing** for all trips (with regulated tariff rates)
- Transparent fare display before/during trip
- Official receipt provision
- No circumvention of meter requirements

The application must support meter-based fare calculation and cannot implement surge pricing or dynamic pricing that conflicts with regulated taxi tariffs.

### 1.3 Data Protection and Privacy Compliance

#### 1.3.1 Protection of Privacy Law (Amendment 13)

**Effective Date:** August 14, 2025 (fully in force for 2026 operations)

Amendment 13 introduces sweeping reforms to Israeli privacy law. Key compliance requirements:

| Requirement | Implementation Approach |
|-------------|------------------------|
| **Legal Basis for Processing** | Document lawful basis for all personal data processing (contract performance, legitimate interest, consent) |
| **Data Minimization** | Collect only data necessary for service delivery; minimize location data retention |
| **Purpose Limitation** | Use data only for specified, explicit purposes disclosed to users |
| **Data Subject Rights** | Implement access, correction, deletion, and portability requests |
| **Security Measures** | Encryption at rest and in transit; access controls; security audits |
| **Breach Notification** | 72-hour notification requirement for significant breaches |
| **Data Protection Officer** | Appoint DPO for oversight of data processing activities |
| **Cross-Border Transfers** | Implement appropriate safeguards for international data transfers |
| **Privacy Impact Assessments** | Conduct PIAs for high-risk processing (location tracking) |
| **Organizational Safeguards** | Written policies, employee training, access logging |

**Reference:** [IAPP - Amendment 13 Analysis](https://iapp.org/news/a/israel-marks-a-new-era-in-privacy-law-amendment-13-ushers-in-sweeping-reform)

#### 1.3.2 Location Data Special Considerations

Location data is considered sensitive and requires enhanced protections:
- **Retention limits:** Precise GPS data retained only for operational necessity (active trip + dispute period)
- **Aggregation/anonymization:** Convert to aggregated/anonymized form for analytics after operational period
- **Access restrictions:** Strict role-based access to raw location data
- **Audit logging:** All access to location data logged

### 1.4 Consumer Protection Requirements

Under Israeli Consumer Protection Law (1981):

| Requirement | Implementation |
|-------------|----------------|
| **Transparent Pricing** | Clear fare estimates and final pricing displayed |
| **Receipt Provision** | Digital receipts with itemized breakdown |
| **Cancellation Rights** | Clear cancellation policy with required disclosures |
| **Complaint Handling** | Documented complaint process with response timelines |
| **Accessible Information** | Terms of service in Hebrew (and Arabic where applicable) |
| **Advertising Standards** | No misleading claims about service or pricing |

### 1.5 Insurance Requirements

#### Commercial Passenger Transport Insurance

| Coverage Type | Minimum Requirement |
|--------------|---------------------|
| Third-Party Liability | Per Ministry of Transportation requirements |
| Passenger Injury Coverage | Mandatory coverage amounts |
| Vehicle Damage | Comprehensive coverage |
| Professional Liability | Platform operator coverage |
| Cyber Insurance | Data breach and business interruption |

All drivers/vehicles must maintain valid insurance, verified during onboarding and re-verified at renewal dates.

### 1.6 Accessibility Requirements

Under Israel's Equal Rights for Persons with Disabilities Law (1998) and related regulations:

| Requirement | Implementation |
|-------------|----------------|
| **Accessible App Design** | WCAG 2.1 AA compliance for mobile apps |
| **Screen Reader Support** | Full VoiceOver/TalkBack compatibility |
| **Accessible Vehicle Options** | Filter for wheelchair-accessible taxis |
| **Service Animal Accommodation** | Cannot refuse passengers with service animals |
| **Communication Accessibility** | Options for users with hearing impairments |

### 1.6.1 App Store Compliance Checklist

#### Google Play Store Requirements

| Requirement | Status | Implementation Notes |
|-------------|--------|---------------------|
| Privacy Policy link | Required | Host at rideil.co.il/privacy, link in app settings and Play Store listing |
| Data Safety form | Required | Complete during Play Console submission |
| Background location disclosure | Required | In-app prominent disclosure before permission request |
| Target API level | Required | Minimum API 34 (Android 14) for 2026 launch |
| Content rating | Required | Complete IARC questionnaire, expected rating: Teen (13+) |
| App signing | Required | Use Play App Signing |

#### Apple App Store Requirements

| Requirement | Status | Implementation Notes |
|-------------|--------|---------------------|
| App Privacy labels | Required | Complete in App Store Connect |
| Sign in with Apple | Conditional | Required if any third-party social login added |
| Location usage descriptions | Required | Add NSLocation*UsageDescription keys to Info.plist |
| Export compliance | Required | Declaration needed for TLS/AES encryption |
| Age rating | Required | 12+ recommended |
| Hebrew localization | Required | Full store listing localization |

#### iOS Permission Usage Descriptions

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>RideIL needs your location to find nearby drivers and track your trip for safety.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>RideIL needs continuous location access to receive trip requests and provide real-time navigation to passengers.</string>

<key>NSCameraUsageDescription</key>
<string>RideIL needs camera access to photograph and upload your license and vehicle documents for verification.</string>
```

### 1.7 Payment Processing Compliance

| Requirement | Implementation |
|-------------|----------------|
| **Israeli Payment Standards** | Integration with local payment processors compliant with Bank of Israel regulations |
| **PCI DSS Compliance** | Level 1 compliance for card data handling |
| **VAT Handling** | Proper VAT calculation, display, and reporting |
| **Electronic Invoice Law** | Compliant digital invoice generation |
| **Anti-Money Laundering** | KYC procedures where applicable |

### 1.8 Labor Law Considerations

The driver classification issue requires careful legal analysis:

| Model | Implications |
|-------|-------------|
| **Independent Contractors** | Standard for taxi-dispatch model (drivers are pre-existing licensees); requires proper contractor agreements |
| **Future Considerations** | If private-driver model enabled, may require reassessment based on control factors and Israeli labor court precedents |

Recommendation: Engage Israeli labor law counsel for driver agreement structures and ongoing compliance monitoring.

### 1.9 Company Licensing Requirements

The operating company must obtain:

| License/Registration | Issuing Authority |
|---------------------|-------------------|
| Business Registration | Registrar of Companies |
| Taxi Dispatch Service License | Ministry of Transportation (if required for dispatch operations) |
| Privacy Registration | Privacy Protection Authority (database registration) |
| Consumer Service Provider Registration | As applicable |

---

## 2. Technical Architecture

### 2.1 High-Level Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              CLIENT APPLICATIONS                                 │
├─────────────────────────────────┬───────────────────────────────────────────────┤
│     Passenger Mobile App        │           Driver Mobile App                   │
│     (iOS / Android)             │           (iOS / Android)                     │
│     - React Native              │           - React Native                      │
│     - Hebrew/Arabic/English     │           - Hebrew/Arabic/English             │
└─────────────────────────────────┴───────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              API GATEWAY LAYER                                   │
│     - AWS API Gateway (selected for native AWS integration)                      │
│     - Rate Limiting, Authentication, Request Routing                            │
│     - SSL/TLS Termination, Certificate Pinning                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           MICROSERVICES LAYER                                    │
├─────────────┬──────────────┬─────────────┬──────────────┬───────────────────────┤
│   Auth      │   Rider      │   Driver    │   Trip       │   Compliance          │
│   Service   │   Service    │   Service   │   Service    │   Service             │
├─────────────┼──────────────┼─────────────┼──────────────┼───────────────────────┤
│   Payment   │   Matching   │   Location  │   Pricing    │   Notification        │
│   Service   │   Service    │   Service   │   Service    │   Service             │
├─────────────┼──────────────┼─────────────┼──────────────┼───────────────────────┤
│   Dispute   │   Analytics  │   Audit     │   Admin      │   Safety              │
│   Service   │   Service    │   Service   │   Service    │   Service             │
└─────────────┴──────────────┴─────────────┴──────────────┴───────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              DATA LAYER                                          │
├─────────────────────────────────┬───────────────────────────────────────────────┤
│   PostgreSQL (Primary DB)       │   Redis (Caching / Real-time)                 │
│   - User Data                   │   - Session Management                        │
│   - Trip Records                │   - Driver Location Cache                     │
│   - Compliance Documents        │   - Rate Limiting                             │
├─────────────────────────────────┼───────────────────────────────────────────────┤
│   MongoDB (Document Store)      │   Elasticsearch                               │
│   - Audit Logs                  │   - Trip Search                               │
│   - Location History            │   - Compliance Reports                        │
├─────────────────────────────────┼───────────────────────────────────────────────┤
│   AWS S3 / Object Storage       │   Message Queue (RabbitMQ)                    │
│   - Document Uploads            │   - Event Processing                          │
│   - Encrypted Backups           │   - Async Operations                          │
│                                 │   - Scale to Kafka at >10k concurrent trips   │
└─────────────────────────────────┴───────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         EXTERNAL INTEGRATIONS                                    │
├─────────────────────────────────┬───────────────────────────────────────────────┤
│   Payment Processors            │   Maps & Navigation                           │
│   - Israeli payment gateways    │   - Google Maps / Waze API                    │
│   - Credit card processing      │   - Hebrew routing support                    │
├─────────────────────────────────┼───────────────────────────────────────────────┤
│   Government APIs (if avail.)   │   Communication Services                      │
│   - License verification        │   - SMS (Israeli providers)                   │
│   - Vehicle registration        │   - Push notifications                        │
├─────────────────────────────────┼───────────────────────────────────────────────┤
│   Insurance Verification        │   Emergency Services Integration              │
│   - Policy validation           │   - Israel Police (100)                       │
│   - Coverage confirmation       │   - Magen David Adom (101)                    │
└─────────────────────────────────┴───────────────────────────────────────────────┘
```

### 2.2 Technology Stack

#### 2.2.1 Mobile Applications

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Framework | React Native | Cross-platform development, strong Hebrew/RTL support |
| State Management | Redux Toolkit | Predictable state, offline capability |
| Navigation | React Navigation | Native navigation experience |
| Maps | react-native-maps + Google Maps SDK | Excellent Israel coverage |
| Localization | i18next | Hebrew, Arabic, English support |
| Push Notifications | Firebase Cloud Messaging | Reliable cross-platform delivery |
| Secure Storage | react-native-keychain | Encrypted credential storage |

#### 2.2.2 Backend Services

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Runtime | Node.js (TypeScript) | Type safety, async I/O for real-time |
| API Framework | NestJS | Enterprise-grade, modular architecture |
| Authentication | Passport.js + JWT + OAuth2 | Flexible auth strategies |
| API Documentation | OpenAPI/Swagger | Standards-compliant documentation |
| Validation | class-validator | Strong input validation |
| ORM | Prisma | Type-safe database access |

#### 2.2.3 Database Layer

| Database | Use Case | Encryption |
|----------|----------|------------|
| PostgreSQL 15+ | Primary relational data (users, trips, compliance) | AES-256 at rest |
| Redis 7+ | Caching, real-time location, sessions | In-transit encryption |
| MongoDB | Audit logs, document storage | Field-level encryption |
| Elasticsearch | Search and compliance reporting | Encryption at rest |

#### 2.2.4 Infrastructure

| Component | Technology | Configuration |
|-----------|------------|---------------|
| Cloud Provider | AWS il-central-1 (Israel) | Primary region for data residency compliance; eu-west-1 for disaster recovery |
| API Gateway | AWS API Gateway | Native AWS integration, lower operational overhead |
| Message Queue | RabbitMQ (MVP) | Migrate to Kafka at >10k concurrent trips |
| Container Orchestration | Kubernetes (EKS) | High availability, auto-scaling |
| CI/CD | GitHub Actions | Automated testing and deployment |
| Infrastructure as Code | Terraform | Reproducible infrastructure |
| Secrets Management | AWS Secrets Manager | Encrypted secret storage with automatic rotation |
| Monitoring | Prometheus + Grafana | Real-time metrics |
| Logging | ELK Stack | Centralized, searchable logs |
| APM | DataDog | Application performance monitoring |
| Mobile Security | Certificate Pinning | Prevent MITM attacks on mobile apps |

### 2.3 Database Schema Design

#### 2.3.1 Core Entities

```sql
-- Riders (Passengers) - Renamed from 'users' for API consistency
CREATE TABLE riders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,  -- Israeli mobile format (+972)
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    national_id_hash VARCHAR(64),  -- Hashed for privacy
    preferred_language VARCHAR(10) DEFAULT 'he',  -- he, ar, en
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,  -- Soft delete for data retention
    consent_version VARCHAR(20),
    consent_timestamp TIMESTAMPTZ,

    -- Account recovery (optional but recommended)
    recovery_email VARCHAR(255),
    recovery_email_verified BOOLEAN DEFAULT FALSE,

    CONSTRAINT valid_language CHECK (preferred_language IN ('he', 'ar', 'en'))
);

-- Drivers
CREATE TABLE drivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID REFERENCES riders(id),  -- Link to rider account if driver is also a rider
    full_legal_name VARCHAR(255) NOT NULL,
    national_id_encrypted BYTEA NOT NULL,  -- Encrypted storage
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(255),

    -- Taxi Operating License
    taxi_license_number VARCHAR(50) NOT NULL,
    taxi_license_issue_date DATE NOT NULL,
    taxi_license_expiry_date DATE NOT NULL,
    taxi_license_document_id UUID REFERENCES documents(id),
    taxi_license_verified BOOLEAN DEFAULT FALSE,
    taxi_license_verified_at TIMESTAMPTZ,
    taxi_license_verified_by UUID,

    -- Driver's License
    driver_license_number_encrypted BYTEA NOT NULL,
    driver_license_expiry_date DATE NOT NULL,
    driver_license_document_id UUID REFERENCES documents(id),

    -- Additional Certifications
    medical_certificate_expiry DATE,
    background_check_date DATE,
    background_check_expiry DATE,
    professional_training_completed BOOLEAN DEFAULT FALSE,

    -- Status
    status VARCHAR(20) DEFAULT 'pending_verification',
    status_reason TEXT,
    onboarded_at TIMESTAMPTZ,
    suspended_at TIMESTAMPTZ,

    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT valid_status CHECK (status IN (
        'pending_verification', 'active', 'suspended',
        'license_expired', 'documents_pending', 'rejected'
    ))
);

-- Vehicles
CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID REFERENCES drivers(id),

    -- Vehicle Identification
    license_plate VARCHAR(20) NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(30) NOT NULL,

    -- Taxi Vehicle License
    taxi_vehicle_license_number VARCHAR(50) NOT NULL,
    taxi_vehicle_license_expiry DATE NOT NULL,
    taxi_vehicle_license_document_id UUID REFERENCES documents(id),
    taxi_vehicle_license_verified BOOLEAN DEFAULT FALSE,

    -- Roadworthiness
    last_inspection_date DATE,
    next_inspection_due DATE,
    inspection_document_id UUID REFERENCES documents(id),

    -- Meter
    meter_certification_date DATE,
    meter_certification_expiry DATE,

    -- Insurance
    insurance_policy_number VARCHAR(100),
    insurance_provider VARCHAR(100),
    insurance_expiry DATE,
    insurance_document_id UUID REFERENCES documents(id),
    insurance_verified BOOLEAN DEFAULT FALSE,

    -- Accessibility
    wheelchair_accessible BOOLEAN DEFAULT FALSE,

    -- Status
    status VARCHAR(20) DEFAULT 'pending_verification',

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT valid_status CHECK (status IN (
        'pending_verification', 'active', 'suspended',
        'inspection_due', 'insurance_expired', 'rejected'
    ))
);

-- Documents (for compliance verification)
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(20) NOT NULL,  -- 'driver', 'vehicle'
    entity_id UUID NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    file_path_encrypted VARCHAR(500) NOT NULL,  -- S3 path, encrypted
    file_hash VARCHAR(64) NOT NULL,  -- SHA-256 for integrity
    upload_timestamp TIMESTAMPTZ DEFAULT NOW(),
    expiry_date DATE,
    verification_status VARCHAR(20) DEFAULT 'pending',
    verified_by UUID,
    verified_at TIMESTAMPTZ,
    rejection_reason TEXT,

    CONSTRAINT valid_doc_type CHECK (document_type IN (
        'taxi_operating_license', 'driver_license', 'taxi_vehicle_license',
        'vehicle_inspection', 'insurance_policy', 'medical_certificate',
        'background_check', 'training_certificate', 'meter_certification'
    )),
    CONSTRAINT valid_verification_status CHECK (verification_status IN (
        'pending', 'verified', 'rejected', 'expired'
    ))
);

-- Trips (Immutable Ledger)
CREATE TABLE trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_number VARCHAR(20) UNIQUE NOT NULL,  -- Human-readable reference

    -- Participants
    rider_id UUID REFERENCES riders(id) NOT NULL,
    driver_id UUID REFERENCES drivers(id) NOT NULL,
    vehicle_id UUID REFERENCES vehicles(id) NOT NULL,

    -- Trip Details
    status VARCHAR(20) NOT NULL,
    trip_type VARCHAR(20) DEFAULT 'metered',  -- metered, fixed (future)

    -- Locations (encrypted at rest)
    pickup_location_encrypted BYTEA NOT NULL,
    pickup_address TEXT NOT NULL,
    dropoff_location_encrypted BYTEA,
    dropoff_address TEXT,
    route_polyline_encrypted BYTEA,  -- Encoded route

    -- Timestamps with timeout specifications
    requested_at TIMESTAMPTZ NOT NULL,
    acceptance_deadline TIMESTAMPTZ,           -- requested_at + 30 seconds
    accepted_at TIMESTAMPTZ,
    expected_arrival_at TIMESTAMPTZ,           -- For ETA timeout calculation
    driver_arrived_at TIMESTAMPTZ,
    rider_pickup_deadline TIMESTAMPTZ,         -- arrived_at + 5 minutes
    trip_started_at TIMESTAMPTZ,
    trip_completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancelled_by VARCHAR(20),
    cancellation_reason TEXT,

    -- Pricing (immutable record)
    estimated_fare_amount DECIMAL(10, 2),
    final_fare_amount DECIMAL(10, 2),
    fare_currency VARCHAR(3) DEFAULT 'ILS',
    meter_reading_start DECIMAL(10, 2),
    meter_reading_end DECIMAL(10, 2),
    vat_amount DECIMAL(10, 2),

    -- Payment (receipt linked via receipts.trip_id, not here - avoids circular FK)
    payment_method VARCHAR(20),                -- 'card', 'cash'
    payment_status VARCHAR(20),
    payment_transaction_id VARCHAR(100),

    -- Compliance
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Prevent modification of critical fields
    CONSTRAINT immutable_trip CHECK (
        -- Trip IDs and participants cannot change after creation
        -- Enforced at application level with audit logging
        TRUE
    ),

    CONSTRAINT valid_trip_status CHECK (status IN (
        'requested', 'accepted', 'driver_en_route', 'driver_arrived',
        'in_progress', 'completed', 'cancelled', 'disputed'
    )),

    CONSTRAINT valid_payment_method CHECK (payment_method IN ('card', 'cash'))
);

-- Create index for immutable trip history queries
CREATE INDEX idx_trips_rider_created ON trips(rider_id, created_at DESC);
CREATE INDEX idx_trips_driver_created ON trips(driver_id, created_at DESC);
CREATE INDEX idx_trips_vehicle_created ON trips(vehicle_id, created_at DESC);
CREATE INDEX idx_trips_date_range ON trips(created_at);

-- Receipts
CREATE TABLE receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES trips(id) NOT NULL,
    receipt_number VARCHAR(30) UNIQUE NOT NULL,

    -- Itemization
    base_fare DECIMAL(10, 2) NOT NULL,
    distance_charge DECIMAL(10, 2),
    time_charge DECIMAL(10, 2),
    waiting_charge DECIMAL(10, 2),
    subtotal DECIMAL(10, 2) NOT NULL,
    vat_rate DECIMAL(5, 4) NOT NULL,
    vat_amount DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'ILS',

    -- Metadata
    issued_at TIMESTAMPTZ DEFAULT NOW(),
    pdf_path VARCHAR(500),  -- S3 path to generated PDF

    -- Immutability
    receipt_hash VARCHAR(64) NOT NULL  -- SHA-256 of receipt data
);

-- Complaints and Safety Incidents
CREATE TABLE complaints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    complaint_number VARCHAR(20) UNIQUE NOT NULL,
    trip_id UUID REFERENCES trips(id),

    -- Reporter
    reporter_type VARCHAR(20) NOT NULL,  -- 'rider', 'driver', 'third_party'
    reporter_id UUID,
    reporter_contact VARCHAR(255),

    -- Complaint Details
    category VARCHAR(50) NOT NULL,
    severity VARCHAR(20) DEFAULT 'medium',
    description TEXT NOT NULL,

    -- Evidence
    evidence_document_ids UUID[],

    -- Resolution
    status VARCHAR(20) DEFAULT 'open',
    assigned_to UUID,
    resolution_notes TEXT,
    resolved_at TIMESTAMPTZ,
    response_deadline TIMESTAMPTZ,

    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT valid_category CHECK (category IN (
        'fare_dispute', 'driver_behavior', 'vehicle_condition', 'safety_concern',
        'payment_issue', 'service_quality', 'discrimination', 'other'
    )),
    CONSTRAINT valid_severity CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    CONSTRAINT valid_status CHECK (status IN (
        'open', 'in_progress', 'awaiting_response', 'resolved', 'escalated', 'closed'
    ))
);

-- Safety Incidents (Panic Button Events)
CREATE TABLE safety_incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_number VARCHAR(20) UNIQUE NOT NULL,
    trip_id UUID REFERENCES trips(id),

    -- Incident Details
    incident_type VARCHAR(50) NOT NULL,
    triggered_by VARCHAR(20) NOT NULL,  -- 'rider', 'driver', 'system'
    triggered_at TIMESTAMPTZ NOT NULL,

    -- Location at time of incident
    location_encrypted BYTEA NOT NULL,

    -- Response
    emergency_services_notified BOOLEAN DEFAULT FALSE,
    emergency_services_notified_at TIMESTAMPTZ,
    emergency_reference_number VARCHAR(50),

    -- Follow-up
    status VARCHAR(20) DEFAULT 'active',
    resolution_notes TEXT,
    resolved_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT valid_incident_type CHECK (incident_type IN (
        'panic_button', 'route_deviation', 'extended_stop',
        'driver_report', 'rider_report', 'system_alert'
    ))
);

-- Audit Log (Append-Only)
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ DEFAULT NOW(),

    -- Actor
    actor_type VARCHAR(20) NOT NULL,  -- 'user', 'driver', 'admin', 'system'
    actor_id UUID,
    actor_ip_hash VARCHAR(64),

    -- Action
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID,

    -- Change Details
    old_value JSONB,
    new_value JSONB,

    -- Context
    request_id VARCHAR(100),
    session_id VARCHAR(100),

    -- Immutability enforcement
    CONSTRAINT no_updates CHECK (TRUE)  -- Enforced at application level
);

-- Make audit_log append-only at DB level
CREATE RULE audit_log_no_update AS ON UPDATE TO audit_log DO INSTEAD NOTHING;
CREATE RULE audit_log_no_delete AS ON DELETE TO audit_log DO INSTEAD NOTHING;

-- Compliance Reports
CREATE TABLE compliance_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_type VARCHAR(50) NOT NULL,
    report_period_start DATE NOT NULL,
    report_period_end DATE NOT NULL,

    -- Filters
    driver_id UUID REFERENCES drivers(id),
    vehicle_id UUID REFERENCES vehicles(id),

    -- Report Data
    report_data JSONB NOT NULL,
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    generated_by UUID NOT NULL,

    -- Export
    export_file_path VARCHAR(500),
    export_format VARCHAR(20)  -- 'pdf', 'csv', 'json'
);
```

### 2.4 API Design

#### 2.4.1 API Structure

```
/api/v1
├── /auth
│   ├── POST /register              # User registration
│   ├── POST /login                 # Phone + OTP login
│   ├── POST /verify-otp            # OTP verification
│   ├── POST /refresh-token         # Token refresh
│   └── POST /logout                # Session termination
│
├── /riders
│   ├── GET /me                     # Get rider profile
│   ├── PATCH /me                   # Update rider profile
│   ├── GET /me/trips               # Trip history
│   ├── GET /me/receipts            # Receipt history
│   ├── POST /me/payment-methods    # Add payment method
│   └── DELETE /me/data             # Data deletion request (GDPR-style)
│
├── /drivers
│   ├── POST /register              # Driver registration
│   ├── GET /me                     # Get driver profile
│   ├── PATCH /me                   # Update driver profile
│   ├── POST /me/documents          # Upload verification document
│   ├── GET /me/documents           # List documents
│   ├── PUT /me/status              # Update availability
│   ├── GET /me/trips               # Driver trip history
│   └── GET /me/earnings            # Earnings summary
│
├── /vehicles
│   ├── POST /                      # Register vehicle
│   ├── GET /:vehicleId             # Get vehicle details
│   ├── PATCH /:vehicleId           # Update vehicle
│   ├── POST /:vehicleId/documents  # Upload vehicle document
│   └── DELETE /:vehicleId          # Remove vehicle
│
├── /trips
│   ├── POST /estimate              # Fare estimate
│   ├── POST /request               # Request ride
│   ├── GET /:tripId                # Get trip details
│   ├── POST /:tripId/accept        # Driver accepts (driver app)
│   ├── POST /:tripId/arrive        # Driver arrived
│   ├── POST /:tripId/start         # Start trip
│   ├── POST /:tripId/complete      # Complete trip
│   ├── POST /:tripId/cancel        # Cancel trip
│   ├── GET /:tripId/receipt        # Get receipt
│   └── POST /:tripId/rate          # Rate trip
│
├── /complaints
│   ├── POST /                      # Submit complaint
│   ├── GET /:complaintId           # Get complaint status
│   └── POST /:complaintId/evidence # Add evidence
│
├── /safety
│   ├── POST /panic                 # Trigger panic button
│   ├── POST /share-trip            # Share trip with contact
│   └── GET /emergency-contacts     # Get emergency contacts
│
├── /location
│   ├── PUT /driver                 # Update driver location (driver app)
│   └── GET /trip/:tripId           # Get live trip location (rider app)
│
└── /admin (internal)
    ├── /drivers
    │   ├── GET /pending            # Pending verifications
    │   ├── POST /:driverId/verify  # Verify driver
    │   ├── POST /:driverId/reject  # Reject driver
    │   └── POST /:driverId/suspend # Suspend driver
    ├── /vehicles
    │   └── ... (similar CRUD)
    ├── /complaints
    │   └── ... (management endpoints)
    └── /reports
        ├── POST /compliance        # Generate compliance report
        └── GET /export             # Export data
```

#### 2.4.2 Real-time Communication

WebSocket endpoints for real-time features:

```
ws://api.rideil.co.il/ws

Events:
├── driver:location_update      # Driver location broadcast
├── trip:status_changed         # Trip status updates
├── trip:driver_assigned        # Driver matched to trip
├── trip:eta_update             # ETA updates
├── message:new                 # In-app messaging
└── safety:alert                # Safety alerts
```

### 2.5 Security Architecture

#### 2.5.1 Authentication & Authorization

| Layer | Implementation |
|-------|----------------|
| User Authentication | Phone + OTP (primary), Email + Password (secondary) |
| Driver Authentication | Enhanced verification with document check |
| Admin Authentication | Multi-factor authentication (MFA) required |
| Token Management | JWT with short expiry (15 min), refresh tokens (7 days) |
| Authorization | Role-Based Access Control (RBAC) |
| API Security | Rate limiting, request signing, CORS policies |

#### 2.5.2 Data Encryption

| Data Type | At Rest | In Transit |
|-----------|---------|------------|
| Personal Identifiers | AES-256-GCM | TLS 1.3 |
| Location Data | AES-256-GCM (column-level) | TLS 1.3 |
| Payment Data | Tokenization (PCI DSS) | TLS 1.3 |
| Documents | AES-256 (file-level) | TLS 1.3 |
| Backups | AES-256 | Encrypted transfer |

#### 2.5.3 Network Security

```
┌─────────────────────────────────────────────────────────────────┐
│                          Internet                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     WAF (AWS WAF / Cloudflare)                   │
│                   - DDoS Protection                              │
│                   - SQL Injection Prevention                     │
│                   - Rate Limiting                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Load Balancer (ALB)                          │
│                   - SSL/TLS Termination                          │
│                   - Certificate Management                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Private VPC                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ App Subnet  │  │ App Subnet  │  │ App Subnet  │              │
│  │ (AZ-1)      │  │ (AZ-2)      │  │ (AZ-3)      │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│         │                │                │                      │
│         └────────────────┼────────────────┘                      │
│                          │                                       │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Data Subnet (Private)                   │    │
│  │   - RDS (Multi-AZ)                                       │    │
│  │   - ElastiCache                                          │    │
│  │   - Elasticsearch                                        │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### 2.6 Third-Party Integrations

| Integration | Provider | Purpose | Status |
|-------------|----------|---------|--------|
| Maps & Navigation | Google Maps Platform | Routing, ETA, geocoding | P0 |
| Payment Processing | Stripe Israel (primary), Isracard (backup) | Credit card processing | P0 |
| SMS Gateway | Twilio (primary), 019 (backup) | OTP and notifications | P0 |
| Push Notifications | Firebase Cloud Messaging | Real-time alerts | P0 |
| Document Storage | AWS S3 (encrypted) | Compliance documents | P0 |
| Email Service | Amazon SES | Receipts and communications | P0 |
| Identity Verification | Manual review (MVP) / Au10tix (Phase 5) | Document verification | P0 (manual) / P2 (automated) |
| Emergency Services | Israel Police (100), MDA (101) | Panic button routing | P0 |

### 2.7 Offline Mode Handling

The application must gracefully handle network connectivity loss to ensure safety and continuity of service.

#### 2.7.1 Rider App Offline Behavior

| Scenario | Behavior |
|----------|----------|
| **During ride request** | Queue request locally; show "Connecting..." indicator; retry with exponential backoff |
| **During matching** | Show last known status; continue matching server-side; reconnect to receive driver assignment |
| **During active trip** | Display last known driver location with "Offline" indicator; trip continues normally |
| **During payment** | Store encrypted payment intent locally; process automatically upon reconnection |

#### 2.7.2 Driver App Offline Behavior

| Scenario | Behavior |
|----------|----------|
| **While online/waiting** | Show offline warning; pause incoming requests until reconnected |
| **During active trip** | Continue GPS recording locally; store route data encrypted; sync upon reconnection |
| **At trip completion** | Allow meter entry and completion; queue payment request; sync when online |

#### 2.7.3 Data Synchronization

```typescript
interface OfflineQueue {
  locationUpdates: GeoPoint[];      // Batched for sync
  tripStateChanges: TripEvent[];    // Ordered by timestamp
  paymentIntents: PaymentIntent[];  // Encrypted, retry on sync
  maxOfflineDuration: number;       // 30 minutes before forcing re-auth
}

// Sync priority on reconnection
const SYNC_PRIORITY = [
  'safety_incidents',    // Highest priority
  'trip_state_changes',
  'payment_intents',
  'location_updates',    // Batch sync
];
```

#### 2.7.4 Offline Limitations

- Maximum offline duration: 30 minutes before requiring re-authentication
- Trip requests cannot be initiated offline (requires driver matching)
- Panic button requires connectivity to notify emergency services (falls back to native dialer)

---

## 3. Compliance Features

### 3.1 Driver Onboarding and Verification System

#### 3.1.1 Onboarding Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    DRIVER ONBOARDING FLOW                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 1: Basic Registration                                       │
│ - Full legal name                                                │
│ - National ID (encrypted storage)                                │
│ - Phone number (verified via OTP)                                │
│ - Email address                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 2: Taxi License Documentation                               │
│ - Upload taxi operating right/license                            │
│ - Enter license number                                           │
│ - Enter issue and expiry dates                                   │
│ - System validates format and date logic                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 3: Driver License Documentation                             │
│ - Upload valid driver's license                                  │
│ - Enter license number (encrypted)                               │
│ - Enter expiry date                                              │
│ - Verify appropriate license category                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 4: Additional Certifications                                │
│ - Medical fitness certificate (if required)                      │
│ - Background check clearance                                     │
│ - Professional training certificate                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 5: Vehicle Registration                                     │
│ - Vehicle details (make, model, year, color)                     │
│ - License plate number                                           │
│ - Taxi vehicle operating license                                 │
│ - Vehicle inspection certificate                                 │
│ - Meter certification                                            │
│ - Insurance policy document                                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 6: Admin Verification Queue                                 │
│ - Documents reviewed by compliance team                          │
│ - Cross-reference with MoT records (if API available)            │
│ - Verify document authenticity                                   │
│ - Approve, request additional info, or reject                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Step 7: Activation                                               │
│ - Driver activated on platform                                   │
│ - Welcome communication sent                                     │
│ - Compliance calendar entries created for renewals               │
│ - Audit log entry created                                        │
└─────────────────────────────────────────────────────────────────┘
```

#### 3.1.2 Document Verification Checklist

| Document | Verification Steps | Auto-Check | Manual Review |
|----------|-------------------|------------|---------------|
| Taxi Operating License | Format validation, date range check, number format | ✓ | ✓ |
| Driver's License | Format validation, expiry check, category verification | ✓ | ✓ |
| Taxi Vehicle License | Format validation, match to vehicle details | ✓ | ✓ |
| Vehicle Inspection | Date validation, vehicle match | ✓ | ✓ |
| Insurance Policy | Coverage dates, policy number format | ✓ | ✓ |
| Medical Certificate | Date validation | ✓ | ✓ |
| Background Check | Issue date, validity period | ✓ | ✓ |

#### 3.1.3 Expiry Tracking and Renewal System

```typescript
// Compliance Calendar Service
interface ExpiryAlert {
  entityType: 'driver' | 'vehicle';
  entityId: string;
  documentType: DocumentType;
  expiryDate: Date;
  alertDays: number[];  // Days before expiry to send alerts
  status: 'active' | 'expiring_soon' | 'expired';
}

// Alert schedule
const ALERT_SCHEDULE = {
  taxi_operating_license: [90, 60, 30, 14, 7, 1],
  driver_license: [90, 60, 30, 14, 7, 1],
  taxi_vehicle_license: [60, 30, 14, 7, 1],
  insurance_policy: [60, 30, 14, 7, 1],
  vehicle_inspection: [30, 14, 7, 1],
  medical_certificate: [60, 30, 14, 7, 1],
};

// Actions on expiry
const EXPIRY_ACTIONS = {
  taxi_operating_license: 'suspend_driver',
  driver_license: 'suspend_driver',
  taxi_vehicle_license: 'suspend_vehicle',
  insurance_policy: 'suspend_vehicle',
  vehicle_inspection: 'suspend_vehicle',
  medical_certificate: 'flag_for_review',
};

// Mid-trip expiration handling
const MID_TRIP_POLICY = {
  // If document expires during active trip:
  // 1. Driver may complete current trip (safety priority)
  // 2. Cannot accept new trips after completion
  // 3. 24-hour grace period for document renewal
  // 4. Full suspension if not renewed within grace period
  gracePeriodHours: 24,
  allowTripCompletion: true,
  blockNewTrips: true,
};
```

### 3.2 Driver-Rider Matching

#### 3.2.0 Matching Algorithm

The matching service pairs riders with available drivers using a weighted scoring algorithm.

##### Matching Criteria (Priority Order)

| Priority | Criterion | Weight | Description |
|----------|-----------|--------|-------------|
| 1 | Distance | 40% | Nearest available driver within search radius |
| 2 | Driver Rating | 25% | Minimum 4.0 stars required for matching |
| 3 | Acceptance Rate | 20% | Drivers with <70% acceptance rate deprioritized |
| 4 | Vehicle Match | 15% | Accessibility requirements, vehicle type |

##### Matching Process

```typescript
interface MatchingRequest {
  riderId: string;
  pickupLocation: GeoPoint;
  dropoffLocation: GeoPoint;
  vehicleRequirements?: {
    wheelchairAccessible?: boolean;
    minSeats?: number;
  };
}

interface MatchingConfig {
  searchRadiusKm: number;           // Default: 5km, expand to 10km if needed
  minDriverRating: number;          // Default: 4.0
  acceptanceTimeout: number;        // 30 seconds
  maxMatchAttempts: number;         // 5 drivers before "no drivers available"
  newDriverProtection: {
    enabled: boolean;
    tripThreshold: number;          // First 50 trips
    reducedRatingRequirement: number; // 3.5 instead of 4.0
  };
}

// Matching flow
async function matchDriver(request: MatchingRequest): Promise<MatchResult> {
  // 1. Query drivers within radius, status='online'
  // 2. Filter by vehicle requirements
  // 3. Filter by minimum rating (with new driver exception)
  // 4. Score remaining drivers by weighted criteria
  // 5. Send request to highest-scored driver
  // 6. Wait 30 seconds for acceptance
  // 7. If declined/timeout, move to next driver
  // 8. Repeat up to 5 attempts
  // 9. Return "no drivers available" if exhausted
}
```

##### Special Matching Cases

| Case | Handling |
|------|----------|
| **Wheelchair-accessible** | Only match to vehicles with `wheelchair_accessible = true` |
| **High demand** | Expand radius from 5km to 10km if no drivers found |
| **New drivers** | Protected period (first 50 trips) with rating requirement of 3.5 |
| **Premium riders** | Future: priority matching based on rider history |

##### Timeout Specifications

| Timeout | Duration | Action on Expiry |
|---------|----------|------------------|
| Driver acceptance | 30 seconds | Move to next driver |
| Driver arrival | ETA + 10 minutes | Rider can cancel free |
| Rider pickup | 5 minutes after arrival | No-show fee may apply |
| Trip start | 10 minutes after arrival | Auto-cancellation |

### 3.3 Metered Trip Flow

#### 3.2.1 Trip Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                    METERED TRIP FLOW                             │
└─────────────────────────────────────────────────────────────────┘

Rider App                    System                      Driver App
    │                           │                             │
    │ 1. Request Ride           │                             │
    │ ─────────────────────────>│                             │
    │   (pickup, dropoff)       │                             │
    │                           │                             │
    │ 2. Fare Estimate          │                             │
    │ <─────────────────────────│                             │
    │   (based on tariff)       │                             │
    │                           │                             │
    │ 3. Confirm Request        │                             │
    │ ─────────────────────────>│                             │
    │                           │ 4. Match Driver             │
    │                           │ ───────────────────────────>│
    │                           │                             │
    │                           │ 5. Accept                   │
    │                           │ <───────────────────────────│
    │                           │                             │
    │ 6. Driver Assigned        │                             │
    │ <─────────────────────────│                             │
    │   (driver info, ETA)      │                             │
    │                           │                             │
    │ ═══════════════════════════════════════════════════════ │
    │               REAL-TIME LOCATION TRACKING                │
    │ ═══════════════════════════════════════════════════════ │
    │                           │                             │
    │ 7. Driver Arrived         │ 8. Confirm Arrival          │
    │ <─────────────────────────│ <───────────────────────────│
    │                           │                             │
    │                           │ 9. Start Trip               │
    │ 10. Trip Started          │ <───────────────────────────│
    │ <─────────────────────────│   (meter_reading_start)     │
    │   (timestamp logged)      │                             │
    │                           │                             │
    │ ═══════════════════════════════════════════════════════ │
    │                 ROUTE RECORDING (encrypted)              │
    │ ═══════════════════════════════════════════════════════ │
    │                           │                             │
    │                           │ 11. Complete Trip           │
    │ 12. Trip Completed        │ <───────────────────────────│
    │ <─────────────────────────│   (meter_reading_end)       │
    │   (fare, receipt)         │                             │
    │                           │                             │
    │ 13. Payment Processing    │                             │
    │ ─────────────────────────>│                             │
    │                           │                             │
    │ 14. Receipt Generated     │                             │
    │ <─────────────────────────│                             │
    │                           │                             │
    │ 15. Rate Trip             │ 16. Rate Rider              │
    │ ─────────────────────────>│ <───────────────────────────│
    │                           │                             │
```

#### 3.2.2 Fare Calculation (Metered)

```typescript
interface MeteredFareCalculation {
  // Israeli taxi tariff structure (example - actual rates from MoT)
  tariffType: 'tariff_1' | 'tariff_2';  // Day/Night or special

  // Components
  flagDropFee: number;        // Starting fare (דמי פתיחה)
  distanceRate: number;       // Per km rate
  timeRate: number;           // Per minute waiting rate

  // Trip data
  meterReadingStart: number;
  meterReadingEnd: number;

  // Calculation
  calculateFare(): FareBreakdown;
}

interface FareBreakdown {
  baseFare: number;
  distanceCharge: number;
  timeCharge: number;
  waitingCharge: number;
  subtotal: number;
  vatRate: number;           // Current Israeli VAT rate
  vatAmount: number;
  totalAmount: number;
  currency: 'ILS';
}
```

#### 3.2.3 Receipt Generation

```typescript
interface TripReceipt {
  receiptNumber: string;        // Unique, sequential
  tripNumber: string;

  // Service Provider
  companyName: string;
  companyRegistration: string;
  companyVATNumber: string;

  // Trip Details
  date: Date;
  pickupAddress: string;
  dropoffAddress: string;
  tripDuration: number;         // Minutes
  tripDistance: number;         // Kilometers

  // Driver & Vehicle
  driverName: string;
  driverLicenseNumber: string;  // Masked
  vehicleLicensePlate: string;

  // Fare Breakdown
  fareBreakdown: FareBreakdown;

  // Payment
  paymentMethod: string;
  paymentStatus: string;

  // Compliance
  meterReadingStart: number;
  meterReadingEnd: number;

  // Verification
  receiptHash: string;          // SHA-256 for integrity
  issuedAt: Date;
}
```

### 3.3 Immutable Trip Ledger

#### 3.3.1 Ledger Design Principles

1. **Append-only**: Trip records are never modified, only new status entries added
2. **Cryptographic integrity**: Hash chains for tamper detection
3. **Timestamped**: All entries use synchronized server time
4. **Linked**: Clear relationships between trips, users, drivers, vehicles
5. **Exportable**: Can generate regulatory reports on demand

#### 3.3.2 Trip State Machine

```typescript
enum TripStatus {
  REQUESTED = 'requested',
  ACCEPTED = 'accepted',
  DRIVER_EN_ROUTE = 'driver_en_route',
  DRIVER_ARRIVED = 'driver_arrived',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
  DISPUTED = 'disputed'
}

// Valid state transitions
const VALID_TRANSITIONS: Record<TripStatus, TripStatus[]> = {
  [TripStatus.REQUESTED]: [TripStatus.ACCEPTED, TripStatus.CANCELLED],
  [TripStatus.ACCEPTED]: [TripStatus.DRIVER_EN_ROUTE, TripStatus.CANCELLED],
  [TripStatus.DRIVER_EN_ROUTE]: [TripStatus.DRIVER_ARRIVED, TripStatus.CANCELLED],
  [TripStatus.DRIVER_ARRIVED]: [TripStatus.IN_PROGRESS, TripStatus.CANCELLED],
  [TripStatus.IN_PROGRESS]: [TripStatus.COMPLETED, TripStatus.DISPUTED],
  [TripStatus.COMPLETED]: [TripStatus.DISPUTED],
  [TripStatus.CANCELLED]: [],
  [TripStatus.DISPUTED]: [TripStatus.COMPLETED],
};
```

#### 3.3.3 Compliance Report Generator

```typescript
interface ComplianceReportRequest {
  reportType:
    | 'trip_history'           // All trips in date range
    | 'driver_activity'        // Specific driver's trips
    | 'vehicle_activity'       // Specific vehicle's trips
    | 'complaint_summary'      // Complaints in date range
    | 'safety_incidents'       // Safety incidents
    | 'document_expiry';       // Upcoming document expirations

  dateRange: {
    start: Date;
    end: Date;
  };

  filters?: {
    driverId?: string;
    vehicleId?: string;
    status?: string[];
  };

  exportFormat: 'pdf' | 'csv' | 'json';
}

// Report includes
interface TripHistoryReport {
  generatedAt: Date;
  generatedBy: string;        // Admin user ID
  reportPeriod: DateRange;

  summary: {
    totalTrips: number;
    completedTrips: number;
    cancelledTrips: number;
    disputedTrips: number;
    totalFareCollected: number;
    totalVATCollected: number;
  };

  trips: TripRecord[];        // Full trip details

  // Audit
  reportHash: string;         // Integrity verification
}
```

### 3.4 Data Protection Implementation

#### 3.4.1 Privacy by Design Controls

| Control | Implementation |
|---------|----------------|
| **Data Minimization** | Collect only necessary fields; location stored only during active trip + 30-day dispute period |
| **Purpose Limitation** | Strict field-level access based on business function |
| **Storage Limitation** | Automated data lifecycle management with retention policies |
| **Accuracy** | User self-service profile management; regular data validation |
| **Integrity & Confidentiality** | Encryption at rest/transit; access logging; regular audits |
| **Accountability** | DPO appointed; privacy documentation; training records |

#### 3.4.2 Location Data Handling

```typescript
interface LocationDataPolicy {
  // Collection
  collectionPurpose: 'trip_matching' | 'trip_tracking' | 'safety';
  collectionFrequency: number;  // Seconds between updates

  // Storage tiers
  storageTiers: {
    realTime: {
      storage: 'redis';
      retention: 'until_trip_end';
      precision: 'full';        // Exact GPS coordinates
    };
    operational: {
      storage: 'postgresql';
      retention: '30_days';
      precision: 'full';
      encryption: 'column_level_aes256';
    };
    analytical: {
      storage: 'data_warehouse';
      retention: '2_years';
      precision: 'aggregated';  // Zone/area level only
      anonymization: true;
    };
  };

  // Access controls
  accessRoles: {
    rider: ['own_trip_history'];
    driver: ['own_trip_history'];
    support: ['trip_lookup_for_complaint'];
    compliance: ['audit_reports'];
    admin: ['all_with_logging'];
  };
}
```

#### 3.4.3 Data Subject Rights Implementation

| Right | Implementation | Response Time |
|-------|----------------|---------------|
| **Access** | Self-service data export in app; manual request for full data | 30 days |
| **Rectification** | Self-service profile editing; support ticket for locked fields | 14 days |
| **Erasure** | Automated process with retention override for legal holds | 30 days |
| **Restriction** | Account freeze capability with data retained but inaccessible | 72 hours |
| **Portability** | JSON/CSV export of personal data and trip history | 30 days |
| **Object** | Opt-out of analytics; cannot object to essential processing | Immediate |

### 3.5 Complaints and Safety System

#### 3.5.1 Complaint Handling Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                  COMPLAINT HANDLING WORKFLOW                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. Complaint Submission                                          │
│    - In-app form linked to trip_id                              │
│    - Category selection (fare, behavior, safety, etc.)          │
│    - Free-text description                                       │
│    - Evidence upload option (photos, recordings)                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. Automatic Triage                                              │
│    - Severity assessment (critical → immediate escalation)      │
│    - Category routing                                            │
│    - Response deadline assignment                                │
│    - Acknowledgment sent to reporter                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. Investigation                                                 │
│    - Trip data retrieval (route, timestamps, receipt)           │
│    - Driver/rider history review                                │
│    - Evidence review                                             │
│    - Contact parties if needed                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. Resolution                                                    │
│    - Decision documented                                         │
│    - Actions taken (refund, warning, suspension)                │
│    - Reporter notified of outcome                               │
│    - Appeal window opened                                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. Closure                                                       │
│    - Final status recorded                                       │
│    - Audit log completed                                         │
│    - Metrics updated                                             │
│    - Pattern analysis for systemic issues                       │
└─────────────────────────────────────────────────────────────────┘
```

#### 3.5.2 Response Time SLAs

| Severity | Response Time | Resolution Target |
|----------|--------------|-------------------|
| Critical (safety) | 1 hour | 24 hours |
| High (serious misconduct) | 4 hours | 72 hours |
| Medium (service quality) | 24 hours | 7 days |
| Low (minor issues) | 48 hours | 14 days |

#### 3.5.3 Safety Incident (Panic Button) System

```typescript
interface PanicButtonEvent {
  // Trigger
  triggeredAt: Date;
  triggeredBy: 'rider' | 'driver';
  tripId: string;

  // Location capture
  location: {
    latitude: number;
    longitude: number;
    accuracy: number;
    timestamp: Date;
  };

  // Automatic actions
  automaticActions: {
    tripFrozen: boolean;           // Prevent status changes
    locationTrackingIntensified: boolean;  // More frequent updates
    emergencyContactsNotified: boolean;
    supportAlerted: boolean;
    emergencyServicesPrompted: boolean;
  };

  // Emergency response
  emergencyResponse: {
    policeNotified: boolean;
    policeReferenceNumber?: string;
    mdaNotified: boolean;         // Magen David Adom
    mdaReferenceNumber?: string;
  };
}

// Panic button flow
async function handlePanicButton(event: PanicButtonTrigger): Promise<void> {
  // 1. Immediate trip freeze
  await freezeTrip(event.tripId);

  // 2. Capture and store location
  const location = await captureLocation(event);

  // 3. Alert support team
  await alertSupportTeam({
    priority: 'critical',
    tripId: event.tripId,
    location,
    triggeredBy: event.triggeredBy
  });

  // 4. Notify emergency contacts
  await notifyEmergencyContacts(event);

  // 5. Display emergency services option
  await displayEmergencyServicesUI(event);

  // 6. Begin recording (if consented)
  if (await hasRecordingConsent(event)) {
    await startAudioRecording(event.tripId);
  }

  // 7. Log incident
  await createSafetyIncident(event);
}
```

### 3.6 Admin and Compliance Tools

#### 3.6.1 Admin Portal Features

| Module | Capabilities |
|--------|-------------|
| **Driver Management** | View/approve/reject applications; document verification queue; suspension management |
| **Vehicle Management** | Vehicle registration review; inspection tracking; insurance verification |
| **Trip Monitoring** | Real-time trip oversight; historical trip lookup; dispute investigation |
| **Compliance Dashboard** | Document expiry alerts; compliance metrics; audit trail viewer |
| **Report Generator** | Regulatory report generation; data export; statistical analysis |
| **User Management** | Rider account management; complaint resolution; refund processing |
| **System Configuration** | Fare tariff updates; feature flags; notification templates |

#### 3.6.2 Audit Logging

All admin actions are logged with:

```typescript
interface AdminAuditEntry {
  timestamp: Date;
  adminUserId: string;
  adminEmail: string;
  action: string;
  entityType: string;
  entityId: string;
  previousState: any;
  newState: any;
  ipAddress: string;        // Hashed
  userAgent: string;
  sessionId: string;
  reason?: string;          // Required for sensitive actions
}

// Example logged actions
const LOGGED_ACTIONS = [
  'driver.verify',
  'driver.reject',
  'driver.suspend',
  'driver.reactivate',
  'vehicle.approve',
  'vehicle.suspend',
  'trip.refund',
  'complaint.resolve',
  'user.data_access',
  'report.generate',
  'report.export',
  'config.update',
];
```

### 3.7 Future-Ready Feature Flags

For the pending private-driver ride-hailing legislation:

```typescript
interface FeatureFlags {
  // Current model (taxi-dispatch)
  taxiDispatchMode: boolean;  // true (default)

  // Future private-driver model
  privateDriverMode: boolean;  // false until legislation

  // Private driver requirements (inactive until enabled)
  privateDriver: {
    enhancedScreening: boolean;      // Additional background checks
    insuranceVerification: boolean;  // Personal vehicle insurance
    vehicleConditionAttestation: boolean;  // Periodic self-reporting
    consumerDisclosures: boolean;    // Additional rider notices
    dynamicPricing: boolean;         // If permitted by law
  };
}

// Middleware to check feature availability
function requireFeature(flag: keyof FeatureFlags) {
  return async (req, res, next) => {
    const flags = await getFeatureFlags();
    if (!flags[flag]) {
      return res.status(403).json({
        error: 'Feature not available in current regulatory environment'
      });
    }
    next();
  };
}
```

### 3.8 Cash Payment Handling

To accommodate Israeli taxi regulations and user preferences, the application supports cash payments alongside card payments.

#### 3.8.1 Cash Payment Flow

##### Rider Flow

1. Before confirming ride, rider selects payment method: "Card" or "Cash"
2. If "Cash" selected, rider sees reminder: "Please have exact fare ready"
3. Fare estimate shown same as card payment
4. At trip end, final fare displayed with "Pay Driver in Cash" instruction

##### Driver Flow

1. Driver sees payment method during trip acceptance: "Payment: Cash"
2. At trip completion, driver enters meter reading
3. Driver confirms: "Cash Received" or "Cash Not Received"
4. If not received, trip flagged for support follow-up

#### 3.8.2 Business Rules

| Rule | Description |
|------|-------------|
| **No platform fee** | Cash trips initially exempt from platform commission (Phase 7: settlement) |
| **Receipt required** | Digital receipt generated regardless of payment method |
| **Rider block threshold** | Riders with >2 unpaid cash trips blocked from cash option |
| **Driver notification** | Clear indicator that trip is cash before acceptance |

#### 3.8.3 Cash Settlement (Future - Phase 7)

```typescript
interface CashSettlement {
  // Daily settlement process for cash trips
  settlementPeriod: 'daily';

  // Platform collects commission via:
  // 1. Deduction from driver's card earnings
  // 2. Weekly invoice if insufficient card earnings
  // 3. Direct bank transfer setup (optional)

  commissionRate: number;  // Percentage of fare
  minimumPayout: number;   // Minimum balance before payout
}
```

### 3.9 Rating System

#### 3.9.1 Rating Structure

| Attribute | Value |
|-----------|-------|
| Scale | 1-5 stars |
| Optional comment | Yes (after rating) |
| Anonymous | Yes (comments not attributed) |
| Visible after | 10 ratings received |

#### 3.9.2 Driver Rating Thresholds

| Rating Range | Action |
|--------------|--------|
| 4.0+ | Normal operation |
| 3.5 - 3.99 | Warning issued, coaching recommended |
| 3.0 - 3.49 | Account review, improvement plan required |
| Below 3.0 (2 weeks) | Temporary suspension pending review |

#### 3.9.3 Rating Calculation

```typescript
interface RatingCalculation {
  // Rolling average over last 100 trips
  windowSize: 100;

  // Minimum trips before rating affects matching
  minimumTrips: 10;

  // New driver protection period
  newDriverProtection: {
    tripCount: 50;
    reducedThreshold: 3.5;  // Instead of 4.0
  };
}
```

---

## 4. Development Roadmap

### 4.1 Overview

The development is organized into phases that prioritize regulatory compliance while building out functionality. Each phase delivers a usable increment.

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT PHASES                            │
├─────────────────────────────────────────────────────────────────┤
│ Phase 1: Foundation & Compliance Core                           │
│ Phase 2: Core Ride-Sharing Features                             │
│ Phase 3: Payment & Receipts                                      │
│ Phase 4: Safety & Support Systems                                │
│ Phase 5: Admin & Compliance Tooling                              │
│ Phase 6: Launch Preparation                                      │
│ Phase 7: Post-Launch Iteration                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Phase 1: Foundation & Compliance Core

**Objective:** Establish infrastructure and compliance-critical driver/vehicle onboarding

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Infrastructure Setup** | AWS/Kubernetes environment, CI/CD pipelines, monitoring | P0 |
| **Database Schema** | PostgreSQL with compliance tables, encryption at rest | P0 |
| **Auth Service** | Phone+OTP authentication, JWT tokens, session management | P0 |
| **Driver Onboarding API** | Registration, document upload, verification workflow | P0 |
| **Document Storage** | Encrypted S3 storage with access logging | P0 |
| **Admin API (basic)** | Driver verification queue, approve/reject functionality | P0 |
| **Audit Logging** | Immutable audit log for all compliance actions | P0 |

#### Acceptance Criteria

- [ ] Driver can register and upload all required documents
- [ ] Admin can review, approve, or reject driver applications
- [ ] Document encryption verified at rest and in transit
- [ ] Audit logs capture all verification actions
- [ ] Expiry tracking functional for all document types

### 4.3 Phase 2: Core Ride-Sharing Features

**Objective:** Implement core trip flow with location tracking

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Rider Mobile App (MVP)** | Registration, ride request, driver tracking | P0 |
| **Driver Mobile App (MVP)** | Online/offline status, trip acceptance, navigation | P0 |
| **Location Service** | Real-time location updates, ETA calculation | P0 |
| **Matching Service** | Driver-rider matching algorithm | P0 |
| **Trip Service** | Trip lifecycle management, state machine | P0 |
| **Maps Integration** | Google Maps / Waze for routing | P0 |
| **Notification Service** | Push notifications for trip events | P0 |

#### Acceptance Criteria

- [ ] Rider can request a ride and see driver location
- [ ] Driver can accept trips and navigate to pickup
- [ ] Trip status tracked through complete lifecycle
- [ ] Location data encrypted and access-logged
- [ ] Hebrew/Arabic language support functional

### 4.4 Phase 3: Payment & Receipts

**Objective:** Implement compliant payment processing and receipt generation

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Pricing Service** | Metered fare calculation per Israeli tariffs | P0 |
| **Payment Integration** | Israeli payment gateway integration | P0 |
| **Receipt Generation** | VAT-compliant digital receipts | P0 |
| **Trip Ledger** | Immutable trip and pricing records | P0 |
| **Payment Methods** | Credit card storage (PCI compliant) | P0 |
| **Rider Payment History** | Trip and payment history in app | P1 |
| **Driver Earnings** | Earnings dashboard for drivers | P1 |

#### Acceptance Criteria

- [ ] Fare calculated correctly per regulated tariffs
- [ ] Payment processed successfully with Israeli cards
- [ ] VAT calculated and displayed correctly
- [ ] Receipt generated with all required fields
- [ ] Trip ledger immutable and queryable

### 4.5 Phase 4: Safety & Support Systems

**Objective:** Implement safety features and customer support infrastructure

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Panic Button** | Emergency alert system with location capture | P0 |
| **Emergency Contacts** | Pre-set contacts for safety alerts | P0 |
| **Trip Sharing** | Share live trip with contacts | P1 |
| **Complaint System** | In-app complaint submission and tracking | P0 |
| **Support Ticketing** | Internal support ticket management | P0 |
| **Rating System** | Post-trip ratings for drivers and riders | P1 |

#### Acceptance Criteria

- [ ] Panic button triggers immediate support alert
- [ ] Complaints linked to trips with evidence support
- [ ] Support team can investigate trips efficiently
- [ ] Emergency services integration tested

### 4.6 Phase 5: Admin & Compliance Tooling

**Objective:** Build comprehensive admin portal for operations and compliance

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Admin Portal** | Web-based admin interface | P0 |
| **Compliance Dashboard** | Document expiry, driver status overview | P0 |
| **Report Generator** | Regulatory and operational reports | P0 |
| **Data Export** | Compliance data export functionality | P0 |
| **User Management** | Rider account management tools | P1 |
| **System Configuration** | Feature flags, tariff management | P1 |
| **Analytics Dashboard** | Operational metrics and KPIs | P2 |

#### Acceptance Criteria

- [ ] Admins can manage full driver/vehicle lifecycle
- [ ] Compliance reports exportable in required formats
- [ ] Audit trail viewable for all admin actions
- [ ] Document expiry alerts functional

### 4.7 Phase 6: Launch Preparation

**Objective:** Prepare for production launch with security hardening and testing

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **Security Audit** | Third-party penetration testing | P0 |
| **Privacy Audit** | Amendment 13 compliance verification | P0 |
| **Load Testing** | Performance validation under expected load | P0 |
| **App Store Preparation** | iOS/Android store listings (Hebrew) | P0 |
| **Legal Review** | Terms of service, privacy policy | P0 |
| **Operations Runbook** | Incident response procedures | P0 |
| **Support Training** | Customer support team training | P1 |

#### Acceptance Criteria

- [ ] Security audit passed with no critical findings
- [ ] Privacy audit confirmed Amendment 13 compliance
- [ ] System handles 10x expected peak load
- [ ] App store submissions approved
- [ ] Legal documents reviewed and published

### 4.8 Phase 7: Post-Launch Iteration

**Objective:** Continuous improvement based on user feedback and regulatory changes

#### Deliverables

| Component | Description | Priority |
|-----------|-------------|----------|
| **User Feedback Loop** | In-app feedback collection | P1 |
| **Performance Optimization** | Based on production metrics | P1 |
| **Feature Enhancements** | Based on user requests | P2 |
| **Regulatory Monitoring** | Track legislation changes | P0 |
| **Private Driver Module** | Ready for activation when legal | P1 |

### 4.9 Development Team Structure

| Role | Responsibility | Count |
|------|---------------|-------|
| Tech Lead | Architecture, technical decisions | 1 |
| Backend Engineers | API development, services | 4 |
| Mobile Engineers | React Native apps (iOS/Android) | 3 |
| Frontend Engineers | Admin portal, web interfaces | 2 |
| DevOps/SRE | Infrastructure, CI/CD, monitoring | 2 |
| QA Engineers | Testing, automation | 2 |
| Product Manager | Requirements, prioritization | 1 |
| UI/UX Designer | App and admin interface design | 1 |
| Security Engineer | Security review, compliance | 1 |

---

## 5. Risk Assessment

### 5.1 Regulatory Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Legislation changes before launch** | Medium | High | Modular architecture with feature flags; regular legal monitoring; flexible deployment |
| **Ministry of Transportation enforcement action** | Low | Critical | Strict compliance from day one; legal counsel engagement; transparent operations |
| **Privacy Authority enforcement (Amendment 13)** | Medium | High | Privacy by design; DPO appointment; regular audits; documented compliance |
| **Labor classification challenge** | Medium | Medium | Clear contractor agreements; legal review; monitor court rulings |
| **Payment regulation changes** | Low | Medium | Multiple payment provider options; PCI compliance maintained |

### 5.2 Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Real-time location accuracy issues** | Medium | High | Multiple location provider fallbacks; accuracy thresholds; user reporting |
| **Payment processing failures** | Low | High | Multiple payment provider integration; graceful degradation; retry logic |
| **System availability issues** | Low | High | Multi-AZ deployment; auto-scaling; comprehensive monitoring; incident runbook |
| **Data breach** | Low | Critical | Encryption at rest/transit; access controls; security audits; incident response plan |
| **Third-party API dependency** | Medium | Medium | Caching strategies; fallback providers; SLA monitoring |

### 5.3 Business Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Insufficient driver supply** | High | High | Aggressive driver onboarding; incentive programs; partnerships with taxi cooperatives |
| **Established competitor response (Gett)** | High | Medium | Focus on compliance differentiation; service quality; competitive pricing |
| **Negative public perception** | Medium | Medium | Transparent operations; responsive support; community engagement |
| **Economic downturn reducing demand** | Low | Medium | Flexible cost structure; operational efficiency |
| **Insurance cost increases** | Medium | Medium | Multiple insurer relationships; driver safety programs |

### 5.4 Operational Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Driver misconduct incidents** | Medium | High | Thorough screening; rating system; swift enforcement; insurance coverage |
| **Support overload at launch** | High | Medium | Scalable support team; self-service options; knowledge base |
| **Compliance document management errors** | Medium | Medium | Automated expiry tracking; multiple verification layers; audit trails |
| **Safety incident mishandling** | Low | Critical | Clear protocols; trained staff; emergency service integration; legal counsel |

### 5.5 Risk Monitoring and Response

```
┌─────────────────────────────────────────────────────────────────┐
│                    RISK MANAGEMENT FRAMEWORK                     │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   IDENTIFY    │   │    ASSESS     │   │   MITIGATE    │
│ - Regulatory  │   │ - Likelihood  │   │ - Controls    │
│ - Technical   │   │ - Impact      │   │ - Procedures  │
│ - Business    │   │ - Velocity    │   │ - Insurance   │
│ - Operational │   │               │   │ - Contingency │
└───────────────┘   └───────────────┘   └───────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                              ▼
                    ┌───────────────┐
                    │    MONITOR    │
                    │ - Dashboards  │
                    │ - Alerts      │
                    │ - Reviews     │
                    │ - Updates     │
                    └───────────────┘
```

---

## 6. Ongoing Compliance

### 6.1 Compliance Governance Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLIANCE ORGANIZATION                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │   Board/Executive │
                    │   Oversight       │
                    └─────────┬─────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Legal Counsel   │ │ Compliance      │ │ Data Protection │
│                 │ │ Officer         │ │ Officer (DPO)   │
│ - Regulatory    │ │ - Driver/vehicle│ │ - Privacy       │
│   interpretation│ │   compliance    │ │   compliance    │
│ - Contract      │ │ - Reporting     │ │ - Data subject  │
│   review        │ │ - Audit         │ │   requests      │
│ - Litigation    │ │   coordination  │ │ - Breach        │
│                 │ │                 │ │   response      │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

### 6.2 Regulatory Monitoring

| Activity | Frequency | Responsible |
|----------|-----------|-------------|
| Monitor Knesset transportation legislation | Weekly | Legal Counsel |
| Review Ministry of Transportation announcements | Weekly | Compliance Officer |
| Track Privacy Authority guidance | Monthly | DPO |
| Review industry news and competitor compliance | Weekly | Compliance Officer |
| Attend industry association meetings | Monthly | Executive |
| Engage with regulatory consultations | As needed | Legal Counsel |

### 6.3 Compliance Calendar

| Task | Frequency | System Support |
|------|-----------|----------------|
| Driver license expiry review | Daily (automated) | Automated alerts + dashboard |
| Vehicle license expiry review | Daily (automated) | Automated alerts + dashboard |
| Insurance renewal tracking | Daily (automated) | Automated alerts + dashboard |
| Compliance report generation | Monthly | Automated report |
| Privacy compliance audit | Quarterly | Checklist + documentation |
| Security audit | Annually | Third-party engagement |
| Penetration testing | Annually | Third-party engagement |
| Staff compliance training | Annually | Training records |
| Policy review and update | Annually | Document management |
| Data retention review | Quarterly | Automated + manual review |

### 6.4 Driver and Vehicle Compliance Maintenance

#### Automated Compliance Workflow

```typescript
// Daily compliance check job
async function dailyComplianceCheck(): Promise<void> {
  // 1. Check for expiring documents
  const expiringDocuments = await getExpiringDocuments({
    daysAhead: [90, 60, 30, 14, 7, 1]
  });

  for (const doc of expiringDocuments) {
    // Send appropriate notification based on days until expiry
    await sendExpiryNotification(doc);

    // Update driver/vehicle status if expired
    if (doc.daysUntilExpiry <= 0) {
      await handleExpiredDocument(doc);
    }
  }

  // 2. Verify active drivers have all required documents
  const activeDrivers = await getActiveDrivers();
  for (const driver of activeDrivers) {
    const complianceStatus = await checkDriverCompliance(driver.id);
    if (!complianceStatus.compliant) {
      await handleNonCompliantDriver(driver, complianceStatus);
    }
  }

  // 3. Verify active vehicles have all required documents
  const activeVehicles = await getActiveVehicles();
  for (const vehicle of activeVehicles) {
    const complianceStatus = await checkVehicleCompliance(vehicle.id);
    if (!complianceStatus.compliant) {
      await handleNonCompliantVehicle(vehicle, complianceStatus);
    }
  }

  // 4. Generate daily compliance summary
  await generateDailyComplianceSummary();
}

// Compliance status checks
interface DriverComplianceStatus {
  driverId: string;
  compliant: boolean;
  issues: ComplianceIssue[];
}

interface ComplianceIssue {
  documentType: string;
  issue: 'expired' | 'expiring_soon' | 'missing' | 'rejected';
  expiryDate?: Date;
  action: 'suspend' | 'warn' | 'notify';
}
```

### 6.5 Data Protection Ongoing Requirements

#### Amendment 13 Compliance Maintenance

| Requirement | Ongoing Activity |
|-------------|-----------------|
| **Lawful Basis Documentation** | Review and update processing records quarterly |
| **Privacy Notices** | Review annually; update for any processing changes |
| **Data Subject Requests** | Track SLA compliance; monthly reporting |
| **Data Retention** | Automated enforcement; quarterly audit |
| **Security Measures** | Continuous monitoring; annual audit |
| **Vendor Management** | Annual DPA review; ongoing monitoring |
| **Training** | Annual refresher; new employee onboarding |
| **Breach Response** | Tabletop exercises quarterly; procedure review |

#### Privacy Impact Assessments

Conduct PIAs for:
- New features involving personal data
- Changes to location data processing
- New third-party integrations
- Changes to data retention periods
- New analytical processing

### 6.6 Incident Response

#### Compliance Incident Types

| Incident Type | Response Lead | Escalation |
|--------------|---------------|------------|
| Driver operating with expired license | Compliance Officer | Immediate suspension |
| Vehicle operating without valid insurance | Compliance Officer | Immediate suspension |
| Data breach (personal data) | DPO | 72-hour regulatory notification |
| Safety incident (serious) | Operations + Legal | Police/MoT notification |
| Regulatory inquiry | Legal Counsel | Executive notification |
| Complaint escalation (regulatory) | Compliance Officer | Legal Counsel |

#### Data Breach Response Procedure

```
┌─────────────────────────────────────────────────────────────────┐
│                  DATA BREACH RESPONSE TIMELINE                   │
└─────────────────────────────────────────────────────────────────┘

T+0 hours: Breach Detected
├── Contain: Isolate affected systems
├── Assess: Determine scope and impact
└── Alert: Notify DPO and executive team

T+24 hours: Initial Assessment Complete
├── Document: Record all known facts
├── Classify: Determine if notification required
└── Plan: Develop remediation plan

T+72 hours: Regulatory Notification (if required)
├── Notify: Privacy Protection Authority
├── Prepare: Data subject notification (if required)
└── Continue: Investigation and remediation

T+30 days: Resolution
├── Complete: Root cause analysis
├── Implement: Preventive measures
├── Report: Final incident report
└── Review: Update security procedures
```

### 6.7 Compliance Reporting

#### Internal Reporting

| Report | Frequency | Audience |
|--------|-----------|----------|
| Driver/Vehicle Compliance Status | Daily | Operations |
| Compliance Issues Summary | Weekly | Compliance Officer, Operations |
| Privacy Metrics (DSR, retention) | Monthly | DPO, Executive |
| Safety Incident Summary | Monthly | Operations, Executive |
| Complaint Resolution Metrics | Monthly | Support, Operations |
| Compliance Dashboard | Real-time | All stakeholders |

#### External/Regulatory Reporting

| Report | Frequency | Recipient |
|--------|-----------|-----------|
| Ministry of Transportation (as required) | On request | MoT |
| Privacy Authority (breach notification) | As required | PPA |
| Tax Authority (VAT reporting) | Monthly/Quarterly | Tax Authority |
| Annual compliance attestation | Annually | As required |

### 6.8 Continuous Improvement

#### Compliance Review Cycle

```
┌─────────────────────────────────────────────────────────────────┐
│                  CONTINUOUS IMPROVEMENT CYCLE                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌───────────────┐
                    │    MEASURE    │
                    │ - Metrics     │
                    │ - Incidents   │
                    │ - Feedback    │
                    └───────┬───────┘
                            │
          ┌─────────────────┴─────────────────┐
          │                                   │
          ▼                                   ▼
┌─────────────────┐               ┌─────────────────┐
│     ANALYZE     │               │     IMPROVE     │
│ - Trends        │               │ - Procedures    │
│ - Root causes   │               │ - Training      │
│ - Gaps          │               │ - Technology    │
│ - Benchmarks    │               │ - Controls      │
└────────┬────────┘               └────────┬────────┘
         │                                 │
         └─────────────────┬───────────────┘
                           │
                           ▼
                 ┌───────────────┐
                 │    VERIFY     │
                 │ - Audit       │
                 │ - Testing     │
                 │ - Review      │
                 └───────────────┘
```

### 6.9 Documentation Requirements

| Document | Owner | Review Frequency |
|----------|-------|-----------------|
| Privacy Policy | DPO + Legal | Annually + as needed |
| Terms of Service | Legal | Annually + as needed |
| Driver Agreement | Legal | Annually + as needed |
| Data Processing Records | DPO | Quarterly |
| Security Policies | Security | Annually |
| Incident Response Plan | DPO + Security | Annually |
| Compliance Procedures | Compliance Officer | Annually |
| Training Materials | HR + Compliance | Annually |
| Vendor Agreements (DPAs) | Legal + DPO | On renewal |

---

## Appendix A: Glossary

| Term | Definition |
|------|------------|
| **MoT** | Ministry of Transportation (Israel) |
| **Amendment 13** | Amendment to the Protection of Privacy Law, effective August 14, 2025 |
| **DPO** | Data Protection Officer |
| **PPA** | Privacy Protection Authority (Israel) |
| **Taxi Operating Right** | License to operate as a taxi driver in Israel |
| **Taxi Vehicle License** | License for a vehicle to operate as a taxi |
| **VAT** | Value Added Tax (מע"מ) |
| **PCI DSS** | Payment Card Industry Data Security Standard |
| **DSR** | Data Subject Request |
| **PIA** | Privacy Impact Assessment |

## Appendix B: Reference Links

### Regulatory Sources

1. [Apply for Taxi Operating License](https://www.gov.il/en/service/taxi_operation_licence_request)
2. [Apply for Taxi Vehicle License](https://www.gov.il/en/service/taxi_vehicle_license_request)
3. [State Comptroller - Taxi Sector Report](https://library.mevaker.gov.il/sites/DigitalLibrary/Documents/2024/2024.11-75A-PartB/EN/2024.11-75A-PartB-205-Taxi-taktzir-EN.pdf)
4. [Knesset - Ride-sharing Arrangement](https://m.knesset.gov.il/EN/News/PressReleases/Pages/press22126r.aspx)
5. [Reuters - Ride-hailing Bill](https://www.reuters.com/business/autos-transportation/bill-allow-uber-lyft-israel-gains-committee-approval-2026-01-18/)
6. [Times of Israel - Uber/Lyft Progress](https://www.timesofisrael.com/israel-moves-a-step-closer-toward-allowing-uber-and-lyft-on-its-streets/)

### Privacy Law Sources

7. [IAPP - Amendment 13 Analysis](https://iapp.org/news/a/israel-marks-a-new-era-in-privacy-law-amendment-13-ushers-in-sweeping-reform)
8. [Tech Policy Institute - Amendment 13 Overview](https://techpolicy.org.il/wp-content/uploads/2024/10/Overview-of-Amendment-no-13-FINAL-FINAL-FOR-UPLOAD-FOR-WEBSITE-COLLATED-1.pdf)

### Practical Guidance

9. [Tel Aviv Taxi Information](https://visit.tel-aviv.gov.il/move/in-tel-aviv)

---

**Document Control**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | January 26, 2026 | Development Team | Initial release |
| 1.1 | January 26, 2026 | Technical Review | Resolved 15 conflicts/gaps; Added App Store compliance (1.6.1); Added Offline Mode (2.7); Added Matching Algorithm (3.2.0); Added Cash Payment (3.8); Added Rating System (3.9); Fixed database schema (riders table, trip timeouts); Updated infrastructure to AWS il-central-1 |

---

*This document is intended for planning purposes and should be reviewed by qualified legal counsel before implementation. Regulatory requirements may change; continuous monitoring is essential.*
