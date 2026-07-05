# Sample Legacy Export — Raw Data Snapshot

**Version:** 1.0  
**Last Updated:** 2026-07-05  
**Author:** Data Engineering / Migration Team

---

## 1. Purpose

This document provides a **representative sample** of raw data exported from the legacy system before cleansing, mapping, and transformation. It is used for:

- ETL pipeline testing
- Data quality assessment
- Validation rule development
- CRM / Books migration planning

This sample reflects **realistic structural patterns**, including missing values, inconsistent formats, duplicates, and legacy-specific field naming.

---

## 2. Sample: Customer Master Export (Raw)

Below is a mock dataset extracted from the legacy Customer Master table. The table shows cleaned rows and a separate code block that preserves an example of raw, malformed/duplicate lines as they appeared in the export.

| Customer_ID | Full_Name     | Email                    | Phone       | Country | Created_On | Status  | Notes       |
|-------------|---------------|--------------------------|-------------|---------|------------|---------|-------------|
| CUST001     | John Mathew   | john.mathew@gmail.com    | 9876543210  | USA     | 2019/03/15 | Active  |             |
| CUST002     | Sushma M      | sushma.m@example.com     | 9998887770  | India   | 2020-11-05 | Active  |             |
| CUST003     | Prashanth     | prashanth@@mail.com      | 8887776660  | India   | 2021-02-22 | Active  | Invalid email format |

Raw export fragment (example of messy/concatenated line):

```text
| CUST002     | Sushma M         | sushma.m@example.com      | 9998887770   | India   | 2020-11-05 | Active | (Duplicate) | CUST003     | Prashanth        | prashanth@@mail.com       | 8887776660   | ...
```

Notes:
- CUST002 appears as a duplicate in the raw extract.
- CUST003 contains an invalid email (`prashanth@@mail.com`) which needs validation and correction during cleansing.

---

## 3. Sample: Product / Item Master Export (Raw)

| Item_ID | Item_Name          | Category   | Unit_Price | Currency | Last_Updated | Notes                    |
|---------|--------------------|------------|------------|----------|--------------|--------------------------|
| ITM001  | AC Unit 1.5 Ton    | HVAC       | 45000      | INR      | 2021-06-01   |                          |
| ITM002  | AC Unit 1.5 Ton    | HVAC       | 45000      | INR      | 2021-06-01   | (Duplicate)              |
| ITM005  |                    | Materials  | 12.00      | USD      | 2022-01-01   | (Missing item name)      |

Raw export fragment showing corrupted / missing fields:

```text
| ITM005  |                  | Materials    | 12.00      | USD      | 2022-01-01   | (Missing item name)
```

Notes:
- Some rows have missing Item_Name or duplicated records. Currency normalization is required for downstream processing.

---

## 4. Sample: Invoice Export (Raw)

| Invoice_ID | Customer_ID | Invoice_Date | Amount | Currency | Payment_Status | Notes                      |
|------------|-------------|--------------|--------|----------|----------------|----------------------------|
| INV001     | CUST001     | 2021-05-10   | 150.00 | USD      | Paid           |                            |
| INV002     | CUST003     | 2021/06/15   | 200.00 | USD      | Pending        | Wrong email in customer master |
| INV003     | CUST999     | 2020-01-20   | 300.00 | USD      | Paid           | (Invalid Customer_ID)      |
| INV004     | CUST002     | 2019-13-10   | 100.00 | USD      | Paid           | (Invalid date format)      |

Notes:
- Dates appear in mixed formats and some contain invalid values (e.g., month 13).
- There are orphan references (Customer_IDs not present in the Customer Master) that require reconciliation.

---

## 5. Common Issues Observed in Legacy Export

- Duplicate records (Customer, Item)
- Invalid email formats (e.g., `prashanth@@mail.com`)
- Missing mandatory fields (Name, Phone, Item_Name)
- Mixed / inconsistent date formats (YYYY/MM/DD, YYYY-MM-DD, invalid values)
- Orphan references (Invoice referencing non-existent Customer_ID)
- Inconsistent currency usage

---

## 6. Usage in ETL Workflow

This sample dataset is used to:

- Build validation rules (SQL and code) to catch format and referential issues
- Test cleansing scripts (normalize dates, emails, currencies)
- Verify mapping logic for CRM/Books imports
- Simulate import scenarios and produce sample error reports
- Train new team members on legacy data patterns and common fixes

---

## 7. File Location

```
08_Sample_Data/
└── sample_legacy_export.md
```

---

## 8. Next Steps

Proceed with generating these next sample files (pick one to generate next):

- `sample_cleaned_data.md` — cleaned and normalized sample output ready for import
- `sample_mapping_output.md` — mapping table from legacy fields to target schema
- `sample_crm_import_files.md` — sample files formatted for CRM import (CSV / JSON)
- `sample_validation_reports.md` — example validation / error reports produced by ETL

---

*Prepared by Data Engineering / Migration Team*
