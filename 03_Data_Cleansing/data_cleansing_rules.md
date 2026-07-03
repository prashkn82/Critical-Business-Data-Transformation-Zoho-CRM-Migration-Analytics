# Data Cleansing Rules

Last Updated: January 2024  
Author: Prashanth

---

## Table of Contents
1. [Overview](#overview)  
2. [Standardization Rules](#standardization-rules)  
   - [Text Standardization](#text-standardization)  
   - [Phone Number Standardization](#phone-number-standardization)  
   - [Address Standardization](#address-standardization)  
3. [Date Normalization Rules](#date-normalization-rules)  
4. [Deduplication Rules](#deduplication-rules)  
5. [Relationship Reconstruction Rules](#relationship-reconstruction-rules)  
6. [Data Type Correction Rules](#data-type-correction-rules)  
7. [Validation Rules](#validation-rules)  
8. [Junk Data Removal Rules](#junk-data-removal-rules)  
9. [Custom Field Cleansing Rules](#custom-field-cleansing-rules)  
10. [Conclusion](#conclusion)

---

## 1. Overview

This document defines the data cleansing rules applied during the ETL process to prepare legacy datasets for migration into Zoho CRM, Books, Desk, and Analytics. These rules ensure data consistency, correctness, and import-readiness.

Goals:
- Standardize formats (names, emails, phones, dates)
- Remove junk / test data
- Deduplicate records using reliable composite keys
- Rebuild or validate relationships (orders → customers, etc.)
- Convert types to target-safe formats (DECIMAL, BOOLEAN, DATE)

---

## 2. Standardization Rules

### 2.1 Text Standardization
- Convert names to UPPERCASE (e.g., "john smith" → "JOHN SMITH").  
- Convert emails to lowercase (e.g., "JOHN@EXAMPLE.COM" → "john@example.com").  
- Trim leading/trailing whitespace and normalize internal whitespace (collapse multiple spaces).  
- Remove accents and non-essential special characters (normalize to ASCII when required).  
- Strip control characters.

Examples:
- " José  López " → "JOSE LOPEZ"  
- " Alice+Sales@Example.COM " → "alice+sales@example.com"

---

### 2.2 Phone Number Standardization
- Keep only digits (strip "+", "(", ")", "-", spaces).  
- Ensure consistent length; prefer including country code when available.  
- Split multi-value phone fields into separate columns (phone_1, phone_2, ...).  
- Validate final length rules per country when possible.

Example:
- "+1 (555) 123-4567" → "15551234567"

---

### 2.3 Address Standardization
- Trim and normalize spacing.  
- Strip HTML tags / encoded entities.  
- Standardize common abbreviations (Street → St, Road → Rd, Avenue → Ave).  
- Apply Title Case or agreed case convention for address components.  

Example:
- "<p>123 Main Street</p>" → "123 Main St"

---

## 3. Date Normalization Rules

### 3.1 Accepted Input Formats
- DD/MM/YYYY, MM-DD-YYYY, YYYY/MM/DD  
- Text-based months (e.g., "15 Jan 2024", "January 15, 2024")

### 3.2 Output Format
- Convert all dates to ISO format: `YYYY-MM-DD` (or `YYYY-MM-DDTHH:MM:SSZ` for timestamps).

Example:
- "01/15/2024" → "2024-01-15"

### 3.3 Timezone Handling
- Convert timestamps to a unified timezone (document chosen timezone, e.g., UTC).  
- If timezone is missing and cannot be inferred, treat as local business timezone and flag ambiguous entries.

---

## 4. Deduplication Rules

### 4.1 General Method
- Use window functions (ROW_NUMBER() OVER (PARTITION BY <composite_key> ORDER BY <keep_criteria>)) to rank duplicates.  
- Keep the record determined by business rule (earliest created_at, or latest, as specified).

Example SQL pattern:
```sql
WITH ranked AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY LOWER(email), numeric_phone
    ORDER BY created_at DESC
  ) rn
  FROM staging.customers
)
SELECT * FROM ranked WHERE rn = 1;
```

### 4.2 Customer Deduplication
- Composite key:
  - LOWER(email)
  - numeric(phone)
  - UPPER(first_name || ' ' || last_name)
- Keep: latest record by `created_at` (or specify business preference).

### 4.3 Product Deduplication
- Composite key:
  - UPPER(product_name)
  - UPPER(sku)
- Keep: first stable record (use created_at or canonical SKU mapping).

### 4.4 Ticket Deduplication
- Composite key:
  - UPPER(subject)
  - created_at (timestamp)
- Keep: original (earliest created_at)

---

## 5. Relationship Reconstruction Rules

### 5.1 Customer → Orders
- When `customer_id` is missing, match by normalized `email` or `phone`.  
- If multiple matches exist, flag for manual review and log the decision.

### 5.2 Orders → Order Items
- Remove or flag order items referencing invalid product IDs.  
- Attempt re-link by SKU or product name; if ambiguous, mark for review.

### 5.3 Tickets → Customers
- Match ticket customer references using normalized email or phone when direct foreign key is missing.

### 5.4 Invoices → Customers
- Verify customer existence before loading. Orphan invoices must be logged and routed to manual remediation.

---

## 6. Data Type Correction Rules

### 6.1 Numeric Fields
- Cast numeric strings to DECIMAL with two decimal places for monetary fields.  
- Example: "100.1" → 100.10

### 6.2 Boolean Fields
- Convert 0/1 flags to TRUE/FALSE or the target system boolean type.

### 6.3 Date Fields
- Convert text dates into `DATE` or `TIMESTAMP` types in ISO format and aligned timezone.

---

## 7. Validation Rules

### 7.1 Mandatory Fields
Ensure these fields are not null prior to load:
- Customer: email, phone  
- Product: product_name  
- Order: order_date  
- Ticket: subject

### 7.2 Referential Integrity
- No orphan orders (each order must reference a valid customer).  
- No orphan order items (each item must reference a valid order & product).  
- No tickets, invoices, or payments without a valid customer.

### 7.3 Format Validation
- Email: contains '@' and matches basic pattern; consider more thorough regex or third-party validation for high-confidence checks.  
- Phone: digits-only after normalization and matches country-specific length rules.  
- Dates: valid calendar dates (e.g., reject "2024-02-30").

Invalid or non-compliant records should be routed to:
- `etl_skipped_records` for non-blocking issues, or
- `etl_error_log` for blocking errors.

---

## 8. Junk Data Removal Rules

### 8.1 Remove Garbage Characters
- Strip non-UTF-8 characters, stray control characters, and emojis unless explicitly required.

### 8.2 Remove HTML Tags
- Use an HTML sanitizer or safe regex to remove tags (`<[^>]+>`), avoiding broken content.

### 8.3 Remove Test Records
- Detect and exclude test/dummy records (names like "Test", "Dummy", emails containing "example", etc.).  
- Keep detection rules auditable and provide manual review for ambiguous cases.

---

## 9. Custom Field Cleansing Rules

### 9.1 Longtext Fields
- Strip HTML and normalize UTF-8 encoding.  
- Extract key-value pairs where the longtext contains structured data (store as JSON when possible).

### 9.2 Mapping Preparation
- Convert custom fields into structured JSON/CSV per Zoho import requirements.  
- Document expected data types and target field mappings.

---

## 10. Conclusion

Applying these rules will produce standardized, validated, and import-ready datasets for Zoho One (CRM, Books, Desk, Analytics). Key outcomes:
- Minimized data loss via explicit logging and review workflows.  
- Improved data quality through normalization, validation, and deduplication.  
- Smooth, auditable imports into target systems.

---

## Appendix / Implementation Notes (optional)
- Logging tables:
  - `etl_error_log` — critical blocking errors  
  - `etl_skipped_records` — records excluded due to validation failures  
  - `etl_warnings` — non-critical issues
- Example log payload:
```json
{
  "timestamp":"2024-01-15 14:30:45",
  "phase":"transform",
  "entity_type":"orders",
  "record_id":"ORD-12345",
  "error_code":"MISSING_FK",
  "severity":"error",
  "message":"Order ORD-12345 references non-existent customer C-99999"
}
```

---

If you'd like, I can:
- Commit this formatted file to the repository, or  
- Generate a concise ETL checklist and sample SQL snippets for applying these rules.
Tell me which you'd prefer.
