# Sample Validation Reports — ETL, Mapping & Migration

**Version:** 1.0  
**Last Updated:** 2026-07-05  
**Author:** Data Engineering / Migration Team

---

## 1. Purpose

This document provides representative validation report samples generated during ETL, cleansing, mapping, and CRM/Books migration workflows. These samples help demonstrate:

- How validation rules detect issues
- How exceptions are logged
- How remediation steps are tracked
- How final acceptance criteria are verified

These reports are used by **Data Engineers**, **QA**, and **Business Data Owners**.

---

## 2. Validation Report — Customer Master

**File Name:** `validation_customer_master_report.csv`

| Record_ID | Issue_Type | Legacy_Value | Expected_Value | Severity | Status |
|-----------|-----------|--------------|-----------------|----------|--------|
| CUST002 | Duplicate Record | CUST002 | Unique | High | Flagged |
| CUST003 | Invalid Email | prashanth@@mail.com | Valid email format | Medium | Pending Review |
| CUST004 | Missing Name | (blank) | Non-empty | High | Flagged |
| CUST005 | Missing Phone | (blank) | Valid phone | Medium | Pending Review |

### Summary
- **4 issues detected**
- **2 high severity**
- **2 medium severity**
- **1 auto-correct attempted (failed)**

---

## 3. Validation Report — Product/Item Master

**File Name:** `validation_item_master_report.csv`

| Item_ID | Issue_Type | Legacy_Value | Expected_Value | Severity | Status |
|---------|-----------|--------------|-----------------|----------|--------|
| ITM002 | Duplicate Item | ITM002 | Unique | High | Flagged |
| ITM005 | Missing Item Name | (blank) | Non-empty | High | Flagged |
| ITM003 | Mixed Date Format | 2020/12/11 | YYYY-MM-DD | Low | Auto-Corrected |

### Summary
- **3 issues detected**
- **2 high severity**
- **1 low severity (auto-corrected)**

---

## 4. Validation Report — Invoice Export

**File Name:** `validation_invoice_report.csv`

| Invoice_ID | Issue_Type | Legacy_Value | Expected_Value | Severity | Status |
|-----------|-----------|--------------|-----------------|----------|--------|
| INV002 | Customer Email Invalid | prashanth@@mail.com | Valid email | Medium | Pending Review |
| INV003 | Orphan Customer_ID | CUST999 | Existing Customer_ID | High | Flagged |
| INV004 | Invalid Date | 2019-13-10 | Valid date | High | Rejected |

### Summary
- **3 issues detected**
- **2 high severity**
- **1 medium severity**
- **1 record rejected**

---

## 5. Mapping Validation Report — Legacy → Zoho

**File Name:** `mapping_validation_report.csv`

| Legacy_Field | Issue | Resolution | Status |
|-------------|-------|-----------|--------|
| Full_Name | Missing value | Default placeholder applied | Completed |
| Email | Invalid format | Manual correction required | Pending |
| Invoice_Date | Invalid date | Rejected | Completed |
| Customer_ID | Orphan reference | Business decision required | Pending |

### Summary
- **4 mapping issues detected**
- **2 completed**
- **2 pending business approval**

---

## 6. ETL Pipeline Validation Summary

**File Name:** `etl_validation_summary.md`

| Phase | Checks Performed | Issues Found | Status |
|-------|-----------------|--------------|--------|
| Extraction | Null checks, duplicates, referential checks | 9 | Completed |
| Transformation | Standardization, mapping, cleansing | 7 | Completed |
| Load (Zoho) | CRM/Books import validation | 5 | Completed |
| Reconciliation | Record counts, field-level comparison | 3 | Completed |

### Overall Status
✅ **All ETL phases validated**

---

## 7. Usage in Migration Workflow

These validation reports are used to:

- Support QA and audit trails
- Provide evidence for business sign-off
- Track remediation progress
- Ensure data quality before CRM/Books import
- Train new team members on validation patterns

---

## 8. File Location

```
08_Sample_Data/
└── sample_validation_reports.md
```

---

## 9. Next Steps

You have one file left to complete the folder:

- **`sample_cleaned_data.md`** — cleaned and normalized sample output ready for import

---

*Prepared by Data Engineering / Migration Team*
