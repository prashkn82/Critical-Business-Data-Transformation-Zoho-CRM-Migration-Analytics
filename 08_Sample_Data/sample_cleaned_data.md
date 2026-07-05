# Sample Cleaned Data — Normalized Snapshot

Version: 1.0
Last Updated: 2026-07-05
Author: Data Engineering / Migration Team

## Purpose
This file provides a cleaned, normalized version of the raw legacy export. It shows representative cleaned rows, describes the cleaning rules applied, and provides sample SQL/transformations used to produce the cleaned output.

## Cleaning Principles Applied
- Schema normalization: consistent column names and datatypes
- Deduplication: remove exact and near-duplicate rows using business keys
- Format normalization: emails lowercased and validated; phones normalized to E.164 where possible; dates normalized to ISO 8601
- Referential repair: map or flag orphan references for manual review
- Deterministic auto-fixes where safe; otherwise, flag for manual resolution

## 1. Cleaned Customer Master (representative rows)

| Customer_ID | First_Name | Last_Name | Email                     | Phone          | Country | Created_On          | Status  | Notes                      |
|-------------|------------|-----------|---------------------------|----------------|---------|---------------------|---------|----------------------------|
| CUST001     | John       | Mathew    | john.mathew@gmail.com     | +1-987-654-3210| USA     | 2019-03-15T00:00:00Z| Active  | Trimmed whitespace         |
| CUST002     | Sushma     | M         | sushma.m@example.com      | +91-999-888-7770| India  | 2020-11-05T00:00:00Z| Active  | Duplicate rows consolidated|
| CUST003     | Prashanth  |           | prashanth@mail.com        | +91-888-777-6660| India  | 2020-08-12T00:00:00Z| Active  | Fixed email typo (@@ → @)  |

Cleaning notes for Customer Master:
- Full_Name split into First_Name / Last_Name using simple split heuristic (first token → first name, last token → last name). Manual review required for compound names.
- Email normalized to lowercase and validated using regex. Invalid emails flagged and attempted fixes applied for common issues (double-@ → single @).
- Phone normalized to E.164 where country can be inferred from Country; otherwise flagged. Example normalization rule: remove non-digit characters, prepend country code if missing using Country mapping.
- Duplicates identified by matching (email OR phone) OR exact Full_Name + country; resolved by merging non-null fields.

Sample SQL used to produce cleaned customers (examples):

-- Lowercase and validate emails
UPDATE staging.customers SET email = LOWER(TRIM(email));

-- Normalize dates
UPDATE staging.customers SET created_on = TO_CHAR(TO_DATE(created_on, 'YYYY-MM-DD'), 'YYYY-MM-DD"T"HH24:MI:SS"Z"') WHERE <date pattern match>;

-- Deduplicate (example):
WITH ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY COALESCE(email, phone) ORDER BY created_on ASC) rn
  FROM staging.customers
)
DELETE FROM staging.customers WHERE id IN (SELECT id FROM ranked WHERE rn > 1);

## 2. Cleaned Product/Item Master (representative rows)

| Item_ID | Item_Name        | Category  | Unit_Price | Currency | Last_Updated         | Notes                    |
|---------|------------------|-----------|------------|----------|----------------------|--------------------------|
| ITM001  | AC Unit 1.5 Ton  | HVAC      | 45000.00   | INR      | 2021-06-01T00:00:00Z | Price coerced to decimal |
| ITM005  | (UNKNOWN)        | Materials | 12.00      | USD      | 2022-01-01T00:00:00Z | Missing name flagged     |

Cleaning notes for Item Master:
- Unit_Price coerced to numeric with two decimal places.
- Missing item names flagged for manual enrichment; placeholder value `(UNKNOWN)` used where required by downstream loads.
- Duplicate rows consolidated by Item_ID or by Item_Name+Category when Item_ID missing.

Sample SQL/transform steps:
- CAST(unit_price AS DECIMAL(18,2))
- TRIM and NULLIF for empty strings: NULLIF(TRIM(item_name), '')

## 3. Cleaned Invoice Export (representative rows)

| Invoice_ID | Customer_ID | Invoice_Date          | Amount   | Currency | Payment_Status | Notes                           |
|------------|-------------|-----------------------|----------|----------|----------------|---------------------------------|
| INV001     | CUST001     | 2021-05-10T00:00:00Z  | 150.00   | USD      | Paid           | OK                              |
| INV002     | CUST003     | 2021-06-15T00:00:00Z  | 200.00   | USD      | Pending        | Corrected date format           |
| INV003     | NULL        | 2020-01-20T00:00:00Z  | 300.00   | USD      | Paid           | Customer_ID not found → NULL; flagged for reconciliation |
| INV004     | CUST002     | NULL                  | 100.00   | USD      | Paid           | Invalid date (2019-13-10) → NULL (flagged)

Cleaning notes for Invoices:
- Dates normalized to ISO 8601 where parsable. Unparseable dates set to NULL and flagged.
- Orphan Customer_IDs set to NULL and recorded in orphan_records table for manual mapping.
- Amount coerced to numeric with two decimals.

Sample SQL for FK checking and orphan handling:
-- Find orphans
SELECT i.invoice_id FROM staging.invoices i LEFT JOIN clean.customers c ON i.customer_id = c.customer_id WHERE c.customer_id IS NULL;

-- Record orphans to a table for manual reconciliation
INSERT INTO audit.orphan_invoices (invoice_id, customer_id, invoice_date) SELECT invoice_id, customer_id, invoice_date FROM staging.invoices WHERE customer_id NOT IN (SELECT customer_id FROM clean.customers);

## 4. Cleaned CSV export headers (examples)
Customers CSV (cleaned for import):
Customer_ID,First_Name,Last_Name,Email,Phone,Country,Created_On,Status

Products CSV (cleaned for import):
Item_ID,Item_Name,Category,Unit_Price,Currency,Last_Updated

Invoices CSV (cleaned for import):
Invoice_ID,Customer_ID,Invoice_Date,Amount,Currency,Payment_Status

## 5. Validation & QA
- Each cleaned run should produce: counts of rows processed, number of records auto-fixed, records flagged for manual review, and sample records for manual validation.
- Recommended DQ checks post-cleaning: email regex match, phone E.164 conformity, date ISO 8601, numeric amounts with 2 decimal places, referential completeness.

## 6. Next steps
- Use these cleaned CSVs to generate mapping outputs for Zoho import (see sample_mapping_output.md)
- Create tickets for records flagged during cleaning and track remediation
- Run reconciliation jobs after mapping & import to validate totals
