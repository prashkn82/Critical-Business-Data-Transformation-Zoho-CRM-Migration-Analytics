ETL Workflow Documentation

1. Overview

This document explains the complete ETL (Extract–Transform–Load) workflow used to migrate legacy system data into Zoho CRM, Books, Desk, and Analytics. The workflow ensures clean, standardized, validated, and relationally consistent data with zero loss.

The ETL pipeline consists of three major phases:

Extract – Pull raw data from legacy tables

Transform – Clean, normalize, deduplicate, and rebuild relationships

Load – Insert clean data into Zoho‑ready staging tables

2. ETL Architecture

High‑Level Flow

Legacy DB → Extract Scripts → Raw Staging → Transform Scripts → Clean Staging → Load Scripts → Zoho Import

Modules Involved

Customer domain

Contact domain

Product catalog

Orders & order items

Tickets (support)

Invoices & payments

Custom longtext fields

3. Extract Phase

Purpose

Pull raw data from legacy systems without modification.

Key Actions

Select all relevant fields

Trim whitespace

Preserve original values

Export into raw staging tables

Reference Script

See: extract_scripts.sql

4. Transform Phase

Purpose

Clean, normalize, standardize, deduplicate, and reconstruct relationships.

Transform Operations

Remove accents and special characters

Normalize case (UPPER, lower)

Standardize date formats (YYYY-MM-DD)

Deduplicate customers using composite keys

Rebuild missing relationships (orders → customers)

Validate product references

Clean longtext custom fields

Normalize phone numbers using regex

Convert monetary values to decimals

Reference Script

See: transform_scripts.sql

5. Load Phase

Purpose

Insert clean, validated data into Zoho‑ready staging tables.

Load Actions

Insert customers, contacts, products

Insert orders and order items

Insert tickets, invoices, payments

Validate referential integrity

Prepare final CSVs for Zoho import

Reference Script

See: load_scripts.sql

6. Data Quality Rules

Standardization Rules

All emails → lowercase

All names → uppercase

All dates → ISO format

All phone numbers → numeric only

All monetary values → rounded to 2 decimals

Deduplication Rules

Customer dedupe: email + phone + name

Product dedupe: SKU + product name

Ticket dedupe: subject + created_at

Validation Rules

No orphan orders

No orphan order items

No tickets without customers

No invoices without customers

7. Error Handling & Logging

Error Categories

Missing foreign keys

Invalid formats

Null mandatory fields

Duplicate primary keys

Failed relationship reconstruction

Logging Strategy

Store errors in etl_error_log

Store skipped records in etl_skipped_records

Store warnings in etl_warnings

8. Final Output

Zoho‑Ready Files Generated

customers.csv

contacts.csv

products.csv

orders.csv

order_items.csv

tickets.csv

invoices.csv

payments.csv

custom_fields.csv

These files are then imported into:

Zoho CRM

Zoho Books

Zoho Desk

Zoho Analytics

9. ETL Workflow Diagram (Text)

[Extract]
   ↓
Raw Staging Tables
   ↓
[Transform]
   ↓
Clean Staging Tables
   ↓
[Load]
   ↓
Zoho Import Files
   ↓
Zoho CRM / Books / Desk / Analytics

10. Conclusion

This ETL workflow ensures a complete, accurate, and validated migration from legacy systems into Zoho One. By following structured extraction, transformation, and loading steps, the project achieves:

Zero data loss

Clean standardized datasets

Rebuilt relationships

Accurate reporting in Zoho Analytics

Seamless CRM, Books, and Desk functionality

This documentation serves as the foundation for understanding and maintaining the ETL pipeline.

