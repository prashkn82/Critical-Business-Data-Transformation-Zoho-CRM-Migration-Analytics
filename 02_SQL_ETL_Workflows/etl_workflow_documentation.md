# ETL Workflow Documentation

## Table of Contents
1. [Overview](#overview)
2. [ETL Architecture](#etl-architecture)
3. [Extract Phase](#extract-phase)
4. [Transform Phase](#transform-phase)
5. [Load Phase](#load-phase)
6. [Data Quality Rules](#data-quality-rules)
7. [Error Handling & Logging](#error-handling--logging)
8. [Final Output](#final-output)
9. [ETL Workflow Diagram](#etl-workflow-diagram)
10. [Conclusion](#conclusion)

---

## Overview

This document explains the complete **ETL (Extract–Transform–Load) workflow** used to migrate legacy system data into Zoho CRM, Books, Desk, and Analytics.

### Key Objectives
- Ensure clean, standardized, validated data migration
- Preserve data integrity throughout the pipeline
- Enable accurate reporting and CRM functionality

### The Three Major Phases

| Phase | Action | Input | Output |
|-------|--------|-------|--------|
| **Extract** | Pull raw data from legacy tables | Legacy DB | Raw Staging Tables |
| **Transform** | Clean, normalize, deduplicate, rebuild relationships | Raw Staging | Clean Staging Tables |
| **Load** | Insert clean data into Zoho-ready staging tables | Clean Staging | Zoho Import Files |

---

## ETL Architecture

### High-Level Flow

```
Legacy DB
   ↓
Extract Scripts (extract_scripts.sql)
   ↓
Raw Staging Tables
   ↓
Transform Scripts (transform_scripts.sql)
   ↓
Clean Staging Tables
   ↓
Load Scripts (load_scripts.sql)
   ↓
Zoho Import Files
   ↓
Zoho CRM / Books / Desk / Analytics
```

### Modules Involved

- 👥 **Customer domain**
- 📞 **Contact domain**
- 📦 **Product catalog**
- 📋 **Orders & order items**
- 🎫 **Tickets (support)**
- 💰 **Invoices & payments**
- 🏷️ **Custom longtext fields**

---

## Extract Phase

### Purpose
Pull raw data from legacy systems **without modification**, preserving original values for audit and debugging.

### Key Actions
- ✅ Select all relevant fields
- ✅ Trim whitespace from text fields
- ✅ Preserve original values (no transformations)
- ✅ Export into raw staging tables
- ✅ Maintain referential relationships

### Reference
📄 **See:** [`extract_scripts.sql`](./extract_scripts.sql)

### Extracted Entities
1. **Customers** - Core customer records
2. **Contacts** - Customer contact persons
3. **Products** - Product catalog
4. **Orders** - Order headers
5. **Order Items** - Order line items
6. **Tickets** - Support tickets
7. **Invoices** - Invoice records
8. **Payments** - Payment transactions
9. **Raw Custom Fields** - Longtext custom data
10. **Lookup Tables** - Tax codes, categories, statuses, payment methods

---

## Transform Phase

### Purpose
Clean, normalize, standardize, deduplicate, and reconstruct relationships.

### Transform Operations

#### Data Cleaning & Normalization
- 🔤 Remove accents and special characters
- 📝 Normalize case (UPPER/lowercase)
- 📅 Standardize date formats (`YYYY-MM-DD`)
- 📞 Normalize phone numbers using regex (numeric only)
- 💵 Convert monetary values to decimals (2 places)

#### Deduplication & Relationships
- 🔍 Deduplicate customers using composite keys
- 🔗 Rebuild missing relationships (orders → customers)
- ✔️ Validate product references
- 🧹 Clean longtext custom fields

#### Quality Checks
- Validate referential integrity
- Check for null mandatory fields
- Flag invalid formats

### Reference
📄 **See:** `transform_scripts.sql` (In Development)

---

## Load Phase

### Purpose
Insert clean, validated data into **Zoho-ready staging tables**.

### Load Actions
- ✅ Insert customers and contacts
- ✅ Insert products
- ✅ Insert orders and order items
- ✅ Insert tickets, invoices, and payments
- ✅ Validate referential integrity
- ✅ Prepare final CSVs for Zoho import
- ✅ Generate import metadata

### Reference
📄 **See:** `load_scripts.sql` (In Development)

---

## Data Quality Rules

### Standardization Rules

| Data Type | Rule | Example |
|-----------|------|---------|
| **Emails** | Lowercase | `JOHN@EXAMPLE.COM` → `john@example.com` |
| **Names** | Uppercase | `john smith` → `JOHN SMITH` |
| **Dates** | ISO format | `01/15/2024` → `2024-01-15` |
| **Phone Numbers** | Numeric only | `+1 (555) 123-4567` → `15551234567` |
| **Monetary Values** | 2 decimal places | `100.1` → `100.10` |

### Deduplication Rules

**Customers**
- Composite Key: `email + phone + last_name`
- Keep: Latest record by `created_at`

**Products**
- Composite Key: `SKU + product_name`
- Keep: First record (stable reference)

**Tickets**
- Composite Key: `subject + created_at + customer_id`
- Keep: Original ticket (earliest `created_at`)

### Validation Rules

#### Referential Integrity
- ❌ **No orphan orders** - Every order must reference a valid customer
- ❌ **No orphan order items** - Every order item must reference a valid order & product
- ❌ **No tickets without customers** - Every ticket must reference a valid customer
- ❌ **No invoices without customers** - Every invoice must reference a valid customer
- ❌ **No payments without customers** - Every payment must reference a valid customer

#### Data Completeness
- ❌ **No null mandatory fields** - Core fields (ID, names, emails) must be populated
- ❌ **No invalid formats** - All formatted fields (email, phone, date) must match standards

---

## Error Handling & Logging

### Error Categories

| Category | Description | Example |
|----------|-------------|---------|
| **Missing Foreign Keys** | Referenced entity doesn't exist | Order references non-existent customer |
| **Invalid Formats** | Data doesn't match expected pattern | Invalid email format |
| **Null Mandatory Fields** | Required field is empty | Missing customer name |
| **Duplicate Primary Keys** | Duplicate ID in same dataset | Two orders with ID `12345` |
| **Failed Relationship Reconstruction** | Cannot rebuild parent-child link | Orphaned order item |

### Logging Strategy

All ETL events are logged to three tables:

```sql
etl_error_log        -- Critical errors that block processing
etl_skipped_records  -- Records excluded due to validation failures
etl_warnings         -- Non-critical issues (e.g., missing optional fields)
```

**Log Entry Format:**
```json
{
  "timestamp": "2024-01-15 14:30:45",
  "phase": "transform",
  "entity_type": "orders",
  "record_id": "ORD-12345",
  "error_code": "MISSING_FK",
  "severity": "error",
  "message": "Order ORD-12345 references non-existent customer C-99999"
}
```

---

## Final Output

### Zoho-Ready Files Generated

The ETL pipeline produces the following CSV files for import:

| File | Purpose | Records | Format |
|------|---------|---------|--------|
| `customers.csv` | Customer master | Clean customer records | ID, Name, Email, Phone, Address |
| `contacts.csv` | Contact persons | Customer contacts | ID, Customer_ID, Name, Email, Role |
| `products.csv` | Product catalog | Active products | ID, Name, Category, SKU, Price |
| `orders.csv` | Order headers | Customer orders | ID, Customer_ID, Date, Total, Status |
| `order_items.csv` | Order line items | Order details | ID, Order_ID, Product_ID, Qty, Price |
| `tickets.csv` | Support tickets | Support cases | ID, Customer_ID, Subject, Status |
| `invoices.csv` | Invoice records | Invoices | ID, Customer_ID, Date, Amount |
| `payments.csv` | Payment records | Payments | ID, Customer_ID, Amount, Date |
| `custom_fields.csv` | Custom field data | Custom attributes | Entity_ID, Field_Data |

### Destination Systems

These files are imported into:

- 🎯 **Zoho CRM** - Customer & sales data
- 📚 **Zoho Books** - Invoices & financial records
- 🎧 **Zoho Desk** - Tickets & support data
- 📊 **Zoho Analytics** - Reporting & dashboards

---

## ETL Workflow Diagram

### Visual Process Flow

```
┌─────────────────┐
│   Legacy DB     │
│  Raw Tables     │
└────────┬────────┘
         │
         ▼
    ┌─────────────┐
    │   EXTRACT   │
    │  Scripts    │
    └──────┬──────┘
           │
           ▼
    ┌─────────────────────┐
    │  Raw Staging Tables │
    │  (No transforms)    │
    └──────┬──────────────┘
           │
           ▼
    ┌─────────────┐
    │ TRANSFORM   │
    │  Scripts    │
    └──────┬──────┘
           │
           ▼
    ┌──────────────────────┐
    │ Clean Staging Tables │
    │ (Validated, Deduped) │
    └──────┬───────────────┘
           │
           ▼
    ┌─────────────┐
    │    LOAD     │
    │  Scripts    │
    └──────┬──────┘
           │
           ▼
    ┌──────────────────┐
    │ Zoho Import CSVs │
    └──────┬───────────┘
           │
           ▼
    ┌──────────────────────────────────┐
    │  Zoho One Platform              │
    │  ├─ CRM                          │
    │  ├─ Books                        │
    │  ├─ Desk                         │
    │  └─ Analytics                    │
    └──────────────────────────────────┘
```

---

## Conclusion

This ETL workflow ensures a **complete, accurate, and validated migration** from legacy systems into Zoho One.

### Key Benefits

✅ **Zero data loss** - All records accounted for with logging

✅ **Clean standardized datasets** - Consistent formatting & normalization

✅ **Rebuilt relationships** - Referential integrity enforced

✅ **Accurate reporting** - High-quality data for analytics

✅ **Seamless integration** - Ready for CRM, Books, and Desk functionality

### Maintenance

This documentation serves as the foundation for:
- 📖 Understanding the ETL pipeline architecture
- 🔧 Maintaining and debugging the scripts
- 🚀 Extending the pipeline with new modules
- 📊 Monitoring data quality and error rates

---

**Last Updated:** January 2024  
**Author:** Prashanth  
**Status:** Active
