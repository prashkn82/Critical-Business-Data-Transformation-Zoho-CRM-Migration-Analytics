# System Architecture Overview
## Legacy → Zoho (CRM, Books, Desk, Analytics)

**Version:** 1.0  
**Last Updated:** 2026-07-06  
**Author:** Data Engineering / Migration Team

---

## Table of Contents

1. [Purpose](#purpose)
2. [Architecture Diagram](#architecture-diagram)
3. [Components Overview](#components-overview)
4. [Data Flow Summary](#data-flow-summary)
5. [Technology Stack](#technology-stack)
6. [Security & Access Controls](#security--access-controls)
7. [File Location](#file-location)
8. [Next Steps](#next-steps)

---

## Purpose

This document provides a high-level architecture overview of the complete data migration and analytics system implemented during the internship project. It explains how data flows from legacy systems through ETL pipelines into Zoho applications and finally into analytics dashboards.

### Key Objectives

This architecture ensures:

- ✅ Standardized and validated data movement
- ✅ Modular ETL workflows
- ✅ Automated quality checks
- ✅ Seamless integration across Zoho applications
- ✅ Scalable analytics and reporting

---

## Architecture Diagram

### High-Level System Flow

```
┌────────────────────────────────────┐
│       Legacy Systems               │
│  (DB, Excel, CSV, Spreadsheets)    │
└─────────────────┬──────────────────┘
                  │
                  │ Extraction
                  ▼
┌────────────────────────────────────┐
│     Staging Layer (Raw Data)       │
│  (MySQL / PostgreSQL)              │
│  • Raw data storage                │
│  • Intermediate tables             │
│  • Validation logs                 │
└─────────────────┬──────────────────┘
                  │
                  │ Cleansing & Standardization
                  ▼
┌────────────────────────────────────┐
│    ETL Layer (Transformation)      │
│  (SQL Scripts & Stored Procedures) │
│  • Data deduplication              │
│  • Format standardization          │
│  • Referential integrity checks    │
└─────────────────┬──────────────────┘
                  │
                  │ Mapping & Rules Engine
                  ▼
┌────────────────────────────────────┐
│    Mapping Engine                  │
│  (Legacy → Zoho Field Rules)       │
│  • Field mapping                   │
│  • Lookup resolution               │
│  • Business rule enforcement       │
└─────────────────┬──────────────────┘
                  │
                  │ Load & Import
                  ▼
┌─────────────────────────────────────────────────┐
│       Zoho Applications                         │
│  ┌──────────┬──────────┬──────────┬──────────┐  │
│  │   CRM    │  Books   │  Desk    │Analytics │  │
│  └──────────┴──────────┴──────────┴──────────┘  │
└─────────────────┬───────────────────────────────┘
                  │
                  │ Analytics & Reporting
                  ▼
┌────────────────────────────────────┐
│    Analytics & Dashboards          │
│  • KPI monitoring                  │
│  • Sales dashboards                │
│  • Inventory reports               │
│  • Migration reconciliation        │
└────────────────────────────────────┘
```

---

## Components Overview

### 3.1 Legacy Systems

| Component | Description |
|-----------|-------------|
| **SQL Database** | Customer, Item, Invoice tables |
| **Excel/CSV Files** | Unstructured data exports |
| **Other Sources** | Spreadsheets, manual records |

### 3.2 Staging Layer

| Component | Purpose |
|-----------|---------|
| **Raw Data Storage** | Stores extracted data as-is |
| **Intermediate Tables** | Holds data during cleansing |
| **Validation Logs** | Tracks issues and exceptions |

### 3.3 ETL Layer (SQL Workflows)

| Function | Activities |
|----------|-----------|
| **Standardization** | Dates, names, currency, formats |
| **Deduplication** | Identify and flag duplicate records |
| **Cleansing** | Null value handling, invalid data removal |
| **Validation** | Referential integrity, data quality checks |
| **Transformation** | Apply business rules and mappings |

### 3.4 Mapping Engine

| Component | Function |
|-----------|----------|
| **Field Mapping Rules** | Legacy → Zoho field translations |
| **Lookup Resolution** | Link customer, item, account records |
| **Business Rules** | Enforce organizational logic |
| **Exception Handling** | Flag unmapped or invalid data |

### 3.5 Zoho Applications

| Application | Modules | Purpose |
|-------------|---------|---------|
| **CRM** | Leads, Contacts, Accounts | Customer relationship management |
| **Books** | Items, Invoices, Payments | Financial & inventory management |
| **Desk** | Tickets, Customer Interactions | Customer support & service |
| **Analytics** | Dashboards, KPIs, Reports | Business intelligence |

### 3.6 Automation & Validation Layer

| Component | Role |
|-----------|------|
| **SQL Validation Scripts** | Automated data quality checks |
| **Quality Gates** | Block invalid data from proceeding |
| **Exception Reporting** | Alert team to issues |
| **Audit Logging** | Track all migration activities |

### 3.7 Analytics Layer

| Output | Content |
|--------|---------|
| **Zoho Analytics Dashboards** | Real-time KPI monitoring |
| **Custom Reports** | Business-specific insights |
| **Reconciliation Reports** | Before/after migration comparison |

---

## Data Flow Summary

### Step 1: Extraction

```
Legacy DB (SQL)           ──┐
Excel/CSV Files           ──┼──→ Staging Database
Spreadsheets & Other      ──┘
```

**Activities:**
- Extract raw data from all sources
- Load into staging layer
- Preserve original values for audit trail

---

### Step 2: Cleansing & Standardization

```
Raw Staged Data  ──→  [Null Checks]      ──┐
                      [Deduplication]     ──┼──→  Cleaned Data
                      [Format Std.]       ──┘
```

**Activities:**
- Handle null/empty values
- Remove duplicate records
- Standardize formats (dates, phone, email)

---

### Step 3: Mapping & Transformation

```
Cleaned Data  ──→  [Apply Mapping Rules]  ──→  [Apply Business Rules]  ──→  Transformed Data
```

**Activities:**
- Apply legacy-to-Zoho field mappings
- Resolve lookups (customer, item, account)
- Enforce organizational business logic

---

### Step 4: Load into Zoho

```
Transformed Data  ──→  [Import Templates]  ──┐
                                            ├──→  Zoho CRM
                                            ├──→  Zoho Books
                                            ├──→  Zoho Desk
                                            └──→  Zoho Analytics
```

**Activities:**
- Generate Zoho-compatible import files
- Load data via API or bulk import
- Track import success/failure

---

### Step 5: Validation & QA

```
Zoho Data  ──→  [Automated SQL Checks]  ──────┐
                [Manual Review]         ──────┼──→  Validation Report
                [Exception Handling]    ──────┘
```

**Activities:**
- Run automated validation scripts
- Manual review of flagged records
- Generate validation reports
- Track remediation progress

---

### Step 6: Analytics & Reporting

```
Zoho Data  ──→  Zoho Analytics  ──→  ┌─────────────────────────┐
                                    │  Customer Master Reports │
                                    │  Sales Dashboards       │
                                    │  Inventory Reports      │
                                    │  Migration Summary      │
                                    └─────────────────────────┘
```

**Activities:**
- Create KPI dashboards
- Generate business reports
- Monitor data quality post-migration
- Track migration success metrics

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Source Systems** | SQL Database, Excel, CSV | Legacy data storage |
| **Staging** | MySQL / PostgreSQL | Intermediate data repository |
| **ETL Processing** | SQL Scripts, Stored Procedures | Data transformation |
| **Mapping Engine** | Rule-based Logic Engine | Field mapping & validation |
| **Target Systems** | Zoho CRM, Books, Desk, Analytics | Cloud applications |
| **Automation** | SQL, Batch Scripts | Validation & quality checks |
| **Analytics** | Zoho Analytics | Dashboards & reporting |
| **Version Control** | Git / GitHub | Document & code versioning |

---

## Security & Access Controls

### Authentication & Authorization

| Control | Implementation |
|---------|----------------|
| **Role-Based Access** | Admin, Engineer, Analyst roles |
| **Data Staging** | Restricted write access to production |
| **API Keys** | Secure storage of Zoho credentials |
| **Audit Logging** | Track all migration activities |

### Data Protection

| Measure | Details |
|---------|---------|
| **Data Masking** | Sensitive PII masked in non-prod |
| **Backup & Recovery** | Maintain staging backups |
| **Version Control** | All scripts tracked in Git |
| **Logging & Monitoring** | Comprehensive activity logs |

---

## File Location

```
09_Architecture/
└── system_architecture_overview.md
```

### Related Documentation

- `08_Sample_Data/sample_validation_reports.md` — Validation report examples
- `sample_cleaned_data.md` — (Coming soon) Cleaned dataset samples

---

## Next Steps

### Choose the Next Architecture Document to Generate

- [ ] **`data_flow_end_to_end.md`** — Detailed step-by-step data flow walkthrough
- [ ] **`integration_points.md`** — API endpoints, system connections, integration details
- [ ] **`environment_setup.md`** — Development, staging, production environment configurations
- [ ] **`security_and_access_controls.md`** — Comprehensive security policies and procedures

---

**Prepared by Data Engineering / Migration Team**  
For questions or updates, contact the Data Engineering team.
