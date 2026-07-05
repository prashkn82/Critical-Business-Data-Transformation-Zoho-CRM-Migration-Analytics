# Sample Mapping Output — Legacy → Zoho Mapping

Version: 1.0
Last Updated: 2026-07-05
Author: Data Engineering / Migration Team

## Purpose
This file documents the field-level mapping and transformation logic from the cleaned legacy dataset to Zoho modules (CRM, Books, Desk, Analytics). It includes mapping tables, transformation rules, sample import headers, and example mapping configuration for automation.

## 1. Mapping Summary (key entities)

Customers → Zoho CRM Contacts/Accounts
- Legacy entity: Customer Master
- Target modules: Zoho CRM (Contacts/Accounts), Zoho Books (Customers)

Products/Items → Zoho Books Items
- Legacy entity: Item/Product Master
- Target modules: Zoho Books (Items), Zoho Inventory (if used)

Invoices → Zoho Books Invoices
- Legacy entity: Invoices
- Target module: Zoho Books (Invoices), link to CRM via customer reference

Tickets → Zoho Desk (if present)

## 2. Field-level mapping (representative)

| Legacy Field     | Target Module | Target Field (Zoho)       | Transform / Rules                                                                 | Notes |
|------------------|---------------|---------------------------|------------------------------------------------------------------------------------|-------|
| Customer_ID      | CRM/Books     | Customer/Contact External ID | Pass-through (use as external_id)                                                 | Ensure uniqueness; prefix if colliding with existing IDs |
| Full_Name        | CRM           | First Name / Last Name    | Split by space: first token → First Name, last token → Last Name; preserve middle names in Last Name if needed | Review for compound names |
| Email            | CRM/Books     | Email                     | Lowercase, validate by regex; if invalid, attempt common fixes; else leave blank & flag | Use email as de-duplication key where available |
| Phone            | CRM/Books     | Phone                     | Normalize to E.164 using Country mapping; store formatted phone and raw_phone in notes | If ambiguous, keep raw and flag for review |
| Country          | CRM/Books     | Country                   | Map country synonyms to ISO names (e.g., "USA" → "United States")              | Use lookup table |
| Created_On       | CRM/Books     | Created Time              | Convert to ISO 8601 (YYYY-MM-DDTHH:MM:SSZ). If time missing, set 00:00:00Z          | Preserve timezone if present |
| Status           | CRM/Books     | Status / Custom Status    | Map legacy statuses to Zoho equivalents (see status mapping table)                | Document exceptions |
| Item_ID          | Books         | Item External ID          | Pass-through; ensure unique per org                                                |       |
| Item_Name        | Books         | Item Name                 | Trim, title-case if required                                                        | If missing, use placeholder `(UNKNOWN)` and flag |
| Unit_Price       | Books         | Rate                      | Decimal(18,2)                                                                      | Currency must be explicit |
| Invoice_ID       | Books         | Invoice Number            | Pass-through; ensure uniqueness                                                    |       |
| Invoice_Date     | Books         | Invoice Date              | ISO 8601 conversion                                                                |       |
| Amount           | Books         | Total                     | Decimal(18,2)                                                                      |       |

## 3. Status mapping example
- Legacy: Active → Zoho: Active
- Legacy: Inactive / Closed → Zoho: Inactive
- Legacy: Pending Verification → Zoho: Needs Verification (custom)

## 4. De-duplication & Merge Strategy
- Primary dedupe keys (ordered): email, phone, Customer_ID
- If email absent: fallback to phone + country
- Merge rule: prefer non-null fields from the most recently updated record (created_on or last_updated)

## 5. Sample mapping config (YAML) for automation
```yaml
customers:
  target: zoho.crm.contacts
  id_field: Customer_ID
  mappings:
    - source: Full_Name
      target: [First_Name, Last_Name]
      transform: split_name
    - source: Email
      target: Email
      transform: lower_trim_validate_email
    - source: Phone
      target: Phone
      transform: normalize_phone_e164
    - source: Country
      target: Country
      transform: map_country_name
    - source: Created_On
      target: Created_Time
      transform: to_iso8601
```

## 6. Sample transformation functions (pseudocode)
- split_name(full_name):
  parts = split(trim(full_name), ' ')
  return {first: parts[0], last: parts[-1]}

- lower_trim_validate_email(email):
  e = lower(trim(email))
  if regex_match(e, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'):
    return e
  else:
    return attempt_common_fixes(e) or NULL

- normalize_phone_e164(phone, country):
  digits = remove_non_digits(phone)
  country_code = lookup_country_code(country)
  if starts_with(digits, country_code):
    return '+' + digits
  if length(digits) between plausible range:
    return '+' + country_code + digits
  else:
    return NULL (flag)

## 7. Example CSV headers for Zoho imports
Customers CSV (Zoho CRM Contacts):
External_ID,First_Name,Last_Name,Email,Phone,Country,Created_Time,Status

Products CSV (Zoho Books Items):
External_ID,Item_Name,Description,Rate,Currency,Unit,Tax

Invoices CSV (Zoho Books):
Invoice_Number,Customer_External_ID,Date,Due_Date,Line_Items_JSON,Total,Currency,Status

## 8. Reconciliation & Post-import checks
- After import, reconcile counts and financial totals between source cleaned data and Zoho reports.
- Validate referential links: Invoices → Customer mapping exists for >99.9% of invoices; orphans reported to ticketing system.
- Run sample lookups in CRM/Books to confirm field mapping correctness (emails, phone display, date formatting).

## 9. Notes & Operational Guidance
- Always run mapping in a sandbox/test Zoho organization first.
- Maintain mapping configuration under version control (YAML/JSON) so changes are auditable.
- Keep transformation functions centralized in an ETL library for reusability.

---

If you want, I can now: 
- produce example cleaned CSV files (customers.csv, products.csv, invoices.csv) based on the cleaned dataset above, or
- create a mapping script (Python) to apply the YAML mapping and transformations.
