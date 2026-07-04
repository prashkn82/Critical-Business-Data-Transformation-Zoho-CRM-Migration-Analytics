# Zoho Field Dictionary

**Master reference for all Zoho modules involved in the migration.**

---

## Table of Contents

1. [Overview](#overview)
2. [Zoho CRM – Accounts](#zoho-crm--accounts)
3. [Zoho CRM – Contacts](#zoho-crm--contacts)
4. [Zoho CRM – Deals](#zoho-crm--deals)
5. [Zoho CRM – Products](#zoho-crm--products)
6. [Zoho Books – Invoices](#zoho-books--invoices)
7. [Zoho Books – Payments](#zoho-books--payments)
8. [Zoho Desk – Tickets](#zoho-desk--tickets)
9. [Zoho Analytics – Data Model](#zoho-analytics--data-model)
10. [Custom Fields Dictionary](#custom-fields-dictionary)
11. [Validation Rules](#validation-rules)

---

## Overview

This document serves as the **master Zoho Field Dictionary** for all modules used in the migration:

- **Zoho CRM** (Accounts, Contacts, Deals, Products)
- **Zoho Books** (Invoices, Payments)
- **Zoho Desk** (Tickets)
- **Zoho Analytics** (Data Model)

This dictionary ensures consistency across:
- ETL processes
- Field mapping
- Data cleansing
- Migration workflows

---

## Zoho CRM – Accounts

**Module:** Customers/Organizations

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Account Name | Text | Customer's commercial name | **Required** |
| Customer ID | Number | Unique identifier | **Required, Unique** |
| Phone | Text | Primary phone number | Numeric only |
| Email | Text | Primary email | Lowercase, valid format |
| Billing Address | Text | Customer billing address | Cleaned |
| Shipping Address | Text | Customer shipping address | Cleaned |
| Created Time | Date | Record creation date | ISO format |

---

## Zoho CRM – Contacts

**Module:** Individual contact persons linked to accounts

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Contact ID | Number | Unique identifier | **Required** |
| First Name | Text | Contact first name | Uppercase |
| Last Name | Text | Contact last name | Uppercase |
| Email | Text | Contact email | Lowercase |
| Phone | Text | Contact phone | Numeric only |
| Designation | Text | Contact role/title | Standardized |
| Account Name | Lookup | Linked customer | **Required** |
| Primary Contact | Boolean | Marks main contact | TRUE/FALSE |

---

## Zoho CRM – Deals

**Module:** Orders/Opportunities

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Deal ID | Number | Unique identifier | **Required** |
| Account Name | Lookup | Linked customer | **Required** |
| Closing Date | Date | Order date | ISO format |
| Stage | Picklist | Deal status | Normalized |
| Amount (HT) | Decimal | Pre-tax amount | Rounded to 2 decimals |
| Amount (TTC) | Decimal | Tax-included amount | Rounded to 2 decimals |
| Payment Mode | Picklist | Payment method | Standardized |

---

## Zoho CRM – Products

**Module:** Product catalog

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Product ID | Number | Unique identifier | **Required** |
| Product Name | Text | Name of product | Uppercase |
| Category | Text | Product category | Standardized |
| SKU | Text | Stock keeping unit | Normalized |
| Price (HT) | Decimal | Pre-tax price | Rounded to 2 decimals |
| Price (TTC) | Decimal | Tax-included price | Rounded to 2 decimals |
| Tax Code | Picklist | Tax classification | Mapped |

---

## Zoho Books – Invoices

**Module:** Financial documents

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Invoice ID | Number | Unique identifier | **Required** |
| Customer Name | Lookup | Linked customer | **Required** |
| Invoice Date | Date | Date of invoice | ISO format |
| Total Amount | Decimal | Invoice total | Rounded to 2 decimals |
| Payment Status | Picklist | Paid / Unpaid / Overdue | Normalized |

---

## Zoho Books – Payments

**Module:** Payment records

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Payment ID | Number | Unique identifier | **Required** |
| Customer Name | Lookup | Linked customer | **Required** |
| Amount | Decimal | Payment amount | Rounded to 2 decimals |
| Payment Mode | Picklist | Cash / Card / Transfer | Standardized |
| Payment Date | Date | Date of payment | ISO format |
| Reference Number | Text | External reference | Cleaned |

---

## Zoho Desk – Tickets

**Module:** Customer support tickets

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Ticket ID | Number | Unique identifier | **Required** |
| Subject | Text | Ticket subject | Cleaned |
| Category | Picklist | Ticket category | Normalized |
| Status | Picklist | OPEN / CLOSED / PENDING | Standardized |
| Priority | Picklist | Low / Medium / High | Standardized |
| Created Time | Date | Ticket creation date | ISO format |
| Closed Time | Date | Ticket closure date | ISO format |
| Contact Name | Lookup | Linked contact | **Required** |
| Account Name | Lookup | Linked customer | **Required** |

---

## Zoho Analytics – Data Model

**Module:** Dimensional/analytical data layer

| Zoho Field | Data Type | Description | Validation |
|:---|:---|:---|:---|
| Customer Key | Number | Unique customer reference | **Required** |
| Product Key | Number | Unique product reference | **Required** |
| Order Key | Number | Unique order reference | **Required** |
| Ticket Key | Number | Unique ticket reference | **Required** |
| Invoice Key | Number | Unique invoice reference | **Required** |
| Payment Key | Number | Unique payment reference | **Required** |
| Created Date | Date | Record creation date | ISO format |
| Updated Date | Date | Last update date | ISO format |

---

## Custom Fields Dictionary

### 10.1 Legacy Field Transformations

**Longtext → Structured Fields**

| Legacy Raw Field | Zoho Field | Notes |
|:---|:---|:---|
| `raw_field_data` | Custom Field JSON | Cleaned, parsed |
| `legacy_status` | Zoho Stage | Normalized |
| `legacy_category` | Zoho Category | Standardized |
| `legacy_flag` | Boolean Field | TRUE/FALSE |

### 10.2 Derived Fields

**Calculated or transformed fields**

| Derived Field | Zoho Field | Notes |
|:---|:---|:---|
| `normalized_phone` | Phone | Cleaned & formatted |
| `iso_date` | Date | Converted to ISO 8601 |
| `composite_key` | Internal Key | Used for deduplication |

---

## Validation Rules

### 11.1 Mandatory Fields

The following fields **must** be populated:

- ✓ Customer Name
- ✓ Email
- ✓ Phone
- ✓ Product Name
- ✓ Order Date
- ✓ Ticket Subject

### 11.2 Format Rules

| Format | Rule |
|:---|:---|
| **Email** | Must contain `@` and valid domain |
| **Phone** | Must be numeric only |
| **Dates** | Must be valid ISO 8601 format (YYYY-MM-DD) |
| **Decimal** | Round to 2 decimal places |
| **Text** | Trim whitespace, standardize case as noted |

### 11.3 Referential Integrity

- ✓ All lookups must reference **valid, existing records**
- ✓ No orphaned orders or tickets without linked accounts
- ✓ All contacts must be linked to valid accounts
- ✓ All deals must be linked to valid customers

---

## Key Points for ETL & Migration

- **Data Type Consistency:** Follow specified types across all modules
- **Field Validation:** Apply all validation rules before loading into Zoho
- **Lookup Integrity:** Ensure all foreign key relationships are maintained
- **Picklist Values:** Normalize and standardize all picklist selections
- **Case Sensitivity:** Follow uppercase/lowercase conventions as noted
- **Date Format:** Always use ISO 8601 (YYYY-MM-DD) format

---

## Conclusion

This Zoho Field Dictionary provides a **unified, authoritative reference** for all modules involved in the migration. It ensures:

✓ **Consistent field usage** across all systems  
✓ **Accurate mapping** during ETL processes  
✓ **Clean data structure** free of inconsistencies  
✓ **Reliable reporting** in Zoho Analytics  

**This dictionary is essential for maintaining clarity and consistency across the entire ETL and migration workflow.**

---

**Last Updated:** 2026-07-04  
**Status:** Active  
**Document Owner:** Data Analytics Team
