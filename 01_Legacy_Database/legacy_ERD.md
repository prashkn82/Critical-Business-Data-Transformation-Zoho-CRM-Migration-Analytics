# Legacy ERD (Entity Relationship Diagram)

## Overview

This document provides a reconstructed Entity Relationship Diagram (ERD) of the legacy databases used in the Apixis and JDC integration projects at CoperBee. The original systems lacked proper documentation, requiring reverse engineering from database schemas and ETL specifications.

The ERD serves as the foundation for ETL workflows, data cleansing, mapping, and migration into Zoho CRM, Books, Desk, and Analytics.

---

## 1. Core Entities

Below are the major entities identified across legacy systems. Names may differ between Apixis and JDC, but the functional structure remains similar.

### Customers

| Field | Type | Notes |
|-------|------|-------|
| `customer_id` | PK | Primary Key |
| `first_name` | VARCHAR | |
| `last_name` | VARCHAR | |
| `email` | VARCHAR | |
| `phone` | VARCHAR | |
| `address` | TEXT | |
| `created_at` | TIMESTAMP | |

### Products

| Field | Type | Notes |
|-------|------|-------|
| `product_id` | PK | Primary Key |
| `product_name` | VARCHAR | |
| `category` | VARCHAR | |
| `price` | DECIMAL | |
| `tax_code` | VARCHAR | |
| `description` | TEXT | |

### Orders / Sales

| Field | Type | Notes |
|-------|------|-------|
| `order_id` | PK | Primary Key |
| `customer_id` | FK | Foreign Key → `customers.customer_id` |
| `order_date` | DATE | |
| `status` | VARCHAR | |
| `total_amount` | DECIMAL | |

### Order Items

| Field | Type | Notes |
|-------|------|-------|
| `order_item_id` | PK | Primary Key |
| `order_id` | FK | Foreign Key → `orders.order_id` |
| `product_id` | FK | Foreign Key → `products.product_id` |
| `quantity` | INT | |
| `unit_price` | DECIMAL | |

### Tickets (Support Desk)

| Field | Type | Notes |
|-------|------|-------|
| `ticket_id` | PK | Primary Key |
| `customer_id` | FK | Foreign Key → `customers.customer_id` |
| `subject` | VARCHAR | |
| `status` | VARCHAR | |
| `created_at` | TIMESTAMP | |
| `assigned_to` | VARCHAR | User or team assignment |

### Invoices (Books)

| Field | Type | Notes |
|-------|------|-------|
| `invoice_id` | PK | Primary Key |
| `customer_id` | FK | Foreign Key → `customers.customer_id` |
| `invoice_date` | DATE | |
| `amount` | DECIMAL | |
| `payment_status` | VARCHAR | |

---

## 2. Relationships

### Customer → Orders
- One customer can have **multiple orders**
- Orders must reference a valid customer

### Orders → Order Items
- One order can contain **multiple items**
- Items must reference valid products

### Customer → Tickets
- One customer can have **multiple support tickets**

### Customer → Invoices
- One customer can have **multiple invoices**

### Product → Order Items
- One product can appear in **many order items**

---

## 3. ERD Diagram

### Visual Representation

```
CUSTOMERS (1) ────────< (∞) ORDERS ────────< (∞) ORDER_ITEMS >──────── (1) PRODUCTS
                │
                ├─────────────< (∞) TICKETS
                │
                └─────────────< (∞) INVOICES
```

### Cardinality Legend
- **(1)** = One (parent side)
- **(∞)** = Many (child side)
- **<** or **>** = Direction of relationship

---

## 4. ERD Issues Identified

During analysis of the legacy systems, several structural issues were discovered:

### 4.1 Missing Foreign Keys
- Legacy databases did not enforce FK constraints
- Resulted in orphan records unable to be validated

### 4.2 Orphan Records
- ❌ Orders without valid customer IDs
- ❌ Order items referencing missing products
- ❌ Tickets not linked to customers

### 4.3 Duplicate Entities
- Customers appearing multiple times with different IDs
- Products with identical names but different IDs
- Inconsistent product categorization

### 4.4 Inconsistent Naming Conventions

| Entity | Variations Found |
|--------|-----------------|
| Customer ID | `Cust_ID`, `customerId`, `id_customer` |
| Product Name | `Prod_Name`, `productname`, `name_prod` |
| Order Date | `order_date`, `OrderDate`, `date_order` |
| Invoice Amount | `amount`, `inv_amount`, `total` |

### 4.5 Mixed Data Types
- 📅 Dates stored as text instead of DATE/TIMESTAMP
- 🔢 Numeric fields stored as VARCHAR
- ✓ Boolean fields stored as integers (0/1) instead of BOOLEAN
- 💱 Currency values with inconsistent decimal precision

---

## 5. ERD Impact on Migration

The ERD reconstruction was essential for:

- ✅ **Designing accurate ETL workflows** - Understanding source structure
- ✅ **Mapping fields to Zoho** - CRM, Books, Desk, Analytics alignment
- ✅ **Rebuilding relationships** - Using SQL joins and lookups
- ✅ **Ensuring referential integrity** - Validating all FK relationships during migration
- ✅ **Preventing data loss** - Identifying and handling orphan records
- ✅ **Data cleansing** - Removing duplicates and fixing inconsistencies

---

## 6. Conclusion

The legacy ERD provided a structural blueprint for transforming fragmented, undocumented datasets into a unified Zoho One environment. Understanding entity relationships was critical for building SQL migration scripts, validating data quality, and ensuring successful integration across all Zoho modules.

### Next Steps
1. **Data Audit** - Validate all FK relationships against identified issues
2. **ETL Design** - Build transformation logic based on ERD structure
3. **Testing** - Verify data integrity post-migration
4. **Documentation** - Update mapping documents with new Zoho schema

---

*Last Updated: 2026-07-03*
