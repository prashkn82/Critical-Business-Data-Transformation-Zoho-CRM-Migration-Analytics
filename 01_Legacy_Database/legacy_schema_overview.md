**Legacy Schema Overview**

**1. Purpose**

This document provides a structured overview of the legacy database schema used in the Apixis and JDC migration projects. It summarizes the original data architecture, key entities, relationships, and structural issues identified before ETL development and migration into Zoho CRM, Books, Desk, and Analytics.

The legacy systems lacked documentation, contained inconsistent structures, and required reverse‑engineering to build a reliable migration pipeline.

2. Legacy System Background

Both Apixis and JDC operated on fragmented, non‑standardized database environments:

Multiple disconnected tools

No unified data model

Limited or no documentation

Tables created by different teams over several years

Inconsistent naming conventions

These issues made schema analysis a critical first step in the migration process.

3. High‑Level Schema Structure

The legacy databases contained several functional domains:

Customer Domain

customers

customer_contacts

customer_addresses

customer_notes

Sales Domain

products

orders

order_items

invoices

Support Domain (JDC)

tickets

ticket_status

ticket_comments

Finance Domain

payments

payment_methods

transaction_logs

Operational Domain

employees

departments

roles

Each domain contained structural inconsistencies and missing relationships.

4. Key Tables and Their Roles

Below is a simplified description of the most critical tables used during migration.

customers

Stores core customer identity information.

customer_id (PK)

first_name

last_name

email

phone

created_at

products

Defines items sold by the business.

product_id (PK)

product_name

category

price

tax_code

orders

Represents customer purchases.

order_id (PK)

customer_id (FK)

order_date

status

order_items

Line‑item details for each order.

order_item_id (PK)

order_id (FK)

product_id (FK)

quantity

unit_price

tickets

Tracks customer support interactions.

ticket_id (PK)

customer_id (FK)

subject

status

created_at

5. ERD Summary

The legacy ERD followed a partial relational model:

CUSTOMERS (1) ────────< (∞) ORDERS ────────< (∞) ORDER_ITEMS >──────── (1) PRODUCTS

CUSTOMERS (1) ────────< (∞) TICKETS

However, several issues were identified:

Missing foreign keys

Incorrect cardinality

Orphan records

Duplicate customer entries

Non‑standard date formats

These issues required extensive cleansing and validation before migration.

6. Structural Issues Identified

1. Inconsistent Naming Conventions

Examples:

Cust_ID, customerId, id_customer

Prod_Name, productname, name_prod

2. Missing Documentation

Many tables had no description or business context.

3. Duplicate Records

Especially in customer and product tables.

4. Null or Incorrect Values

Empty phone numbers

Invalid email formats

Wrong tax codes

5. Hidden Relationships

Some relationships were implied but not enforced with foreign keys.

7. Impact on Migration

These schema issues directly impacted:

ETL logic complexity

Data cleansing workload

Field mapping accuracy

Migration timelines

The ETL pipeline was designed to reconstruct missing relationships, standardize fields, and prepare clean, validated datasets for Zoho CRM, Books, Desk, and Analytics.

8. Files in This Folder

This folder contains:

legacy_schema_overview.md (this file)

raw_data_issues.md

legacy_ERD.md

Each file provides deeper insight into the legacy system and supports the full migration documentation.

9. Conclusion

The legacy schema was functional but inconsistent, requiring significant transformation before integration into Zoho One. This overview provides the foundation for understanding the ETL, cleansing, and mapping processes documented in the rest of the repository.
