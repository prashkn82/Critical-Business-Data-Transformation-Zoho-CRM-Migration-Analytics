# Legacy Schema Overview

## 1. Purpose

This document provides a structured overview of the legacy database schema used in the Apixis and JDC migration projects. It summarizes the original data architecture, key entities, relationships, and issues that were encountered during the reverse-engineering process.

The legacy systems lacked documentation, contained inconsistent structures, and required reverse-engineering to build a reliable migration pipeline.

---

## 2. Legacy System Background

Both Apixis and JDC operated on fragmented, non-standardized database environments:

- **Multiple disconnected tools** - Systems were not integrated
- **No unified data model** - Each department maintained separate databases
- **Limited or no documentation** - Data dictionary was missing or incomplete
- **Tables created by different teams over several years** - No governance
- **Inconsistent naming conventions** - Different prefixes and patterns

These issues made schema analysis a critical first step in the migration process.

---

## 3. High-Level Schema Structure

The legacy databases contained several functional domains:

### Customer Domain
- `customers`
- `customer_contacts`
- `customer_addresses`
- `customer_notes`

### Sales Domain
- `products`
- `orders`
- `order_items`
- `invoices`

### Support Domain (JDC)
- `tickets`
- `ticket_status`
- `ticket_comments`

### Finance Domain
- `payments`
- `payment_methods`
- `transaction_logs`

### Operational Domain
- `employees`
- `departments`
- `roles`

Each domain contained structural inconsistencies and missing relationships.

---

## 4. Key Tables and Their Roles

Below is a simplified description of the most critical tables used during migration.

### customers
**Purpose:** Stores core customer identity information.

| Column | Type | Notes |
|--------|------|-------|
| `customer_id` | INT | Primary Key |
| `first_name` | VARCHAR | Customer first name |
| `last_name` | VARCHAR | Customer last name |
| `email` | VARCHAR | Contact email |
| `phone` | VARCHAR | Contact phone number |
| `created_at` | DATETIME | Record creation timestamp |

### products
**Purpose:** Defines items sold by the business.

| Column | Type | Notes |
|--------|------|-------|
| `product_id` | INT | Primary Key |
| `product_name` | VARCHAR | Product description |
| `category` | VARCHAR | Product category |
| `price` | DECIMAL | Selling price |
| `tax_code` | VARCHAR | Tax classification |

### orders
**Purpose:** Represents customer purchases.

| Column | Type | Notes |
|--------|------|-------|
| `order_id` | INT | Primary Key |
| `customer_id` | INT | Foreign Key to customers |
| `order_date` | DATETIME | Order placement date |
| `status` | VARCHAR | Order state (pending, shipped, completed, etc.) |

### order_items
**Purpose:** Line-item details for each order.

| Column | Type | Notes |
|--------|------|-------|
| `order_item_id` | INT | Primary Key |
| `order_id` | INT | Foreign Key to orders |
| `product_id` | INT | Foreign Key to products |
| `quantity` | INT | Items ordered |
| `unit_price` | DECIMAL | Price at time of order |

### tickets
**Purpose:** Tracks customer support interactions.

| Column | Type | Notes |
|--------|------|-------|
| `ticket_id` | INT | Primary Key |
| `customer_id` | INT | Foreign Key to customers |
| `subject` | VARCHAR | Issue description |
| `status` | VARCHAR | Ticket state (open, in-progress, resolved, closed) |
| `created_at` | DATETIME | Ticket creation timestamp |

---

## 5. ERD Summary

The legacy ERD followed a partial relational model:

```
CUSTOMERS (1) ────────< (∞) ORDERS ────────< (∞) ORDER_ITEMS >──────── (1) PRODUCTS

CUSTOMERS (1) ────────< (∞) TICKETS
```

However, several issues were identified:

- ❌ **Missing foreign keys** - Relationships not enforced at database level
- ❌ **Incorrect cardinality** - One-to-many relationships not properly defined
- ❌ **Orphan records** - Child records with invalid parent references
- ❌ **Duplicate customer entries** - Same customer in database multiple times
- ❌ **Non-standard date formats** - Mix of DATETIME, VARCHAR, and UNIX timestamps

These issues required extensive cleansing and validation before migration.

---

## 6. Structural Issues Identified

### 1. Inconsistent Naming Conventions
**Examples:**
- Customer ID: `Cust_ID`, `customerId`, `id_customer`
- Product Name: `Prod_Name`, `productname`, `name_prod`

### 2. Missing Documentation
Many tables had no description or business context. Field meanings had to be inferred from usage patterns.

### 3. Duplicate Records
Especially prevalent in customer and product tables, sometimes with slight variations in spelling or formatting.

### 4. Null or Incorrect Values
- Empty or invalid phone numbers
- Malformed email addresses
- Wrong or missing tax codes
- Zero-padded or leading/trailing spaces

### 5. Hidden Relationships
Some relationships were implied in application code but not enforced with foreign keys, making them invisible at the database level.

---

## 7. Impact on Migration

These schema issues directly impacted:

| Area | Impact |
|------|--------|
| **ETL Logic Complexity** | Multiple data validation rules and transformations required |
| **Data Cleansing Workload** | 30-40% of effort spent on data quality remediation |
| **Field Mapping Accuracy** | Manual review needed for ambiguous or inconsistent fields |
| **Migration Timelines** | Extended project duration for testing and validation |

The ETL pipeline was designed to:
1. **Reconstruct missing relationships** - Identify and establish proper foreign keys
2. **Standardize fields** - Normalize naming conventions and data formats
3. **Prepare clean, validated datasets** - For integration into Zoho CRM, Books, Desk, and Analytics

---

## 8. Files in This Folder

This folder contains supporting documentation:

| File | Purpose |
|------|---------|
| `legacy_schema_overview.md` | Overview of legacy database structure (this file) |
| `raw_data_issues.md` | Detailed catalog of data quality issues |
| `legacy_ERD.md` | Entity relationship diagram and table definitions |

Each file provides deeper insight into the legacy system and supports the full migration documentation.

---

## 9. Conclusion

The legacy schema was functional but inconsistent, requiring significant transformation before integration into Zoho One. This overview provides the foundation for understanding the ETL, cleansing strategies, and validation rules that underpin the entire migration project.

For detailed information on specific tables, relationships, or data quality issues, refer to the supporting documentation listed above.

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Status:** Active Reference
