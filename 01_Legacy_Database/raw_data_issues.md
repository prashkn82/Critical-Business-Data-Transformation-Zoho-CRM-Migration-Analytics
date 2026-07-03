Raw Data Issues

Overview

This document outlines the primary issues identified in the raw datasets extracted from legacy systems during the data migration projects at CoperBee. These issues impacted data quality, consistency, and the overall ETL workflow, requiring extensive cleansing and transformation before integration into Zoho CRM, Books, Desk, and Analytics.

1. Dirty and Inconsistent Data

Raw data contained numerous inconsistencies that required correction:

Special characters, accents, and malformed text entries

Mixed data formats (dates, phone numbers, currency values)

Inconsistent naming conventions across tables

Duplicate records for customers, contacts, and products

2. Missing Field Information

Several fields lacked complete or accurate information:

Null values in mandatory fields (email, phone, product codes)

Missing foreign key references

Incomplete address and contact details

Hidden or undocumented fields in legacy tables

3. No Documentation for Legacy Scripts

Legacy systems lacked proper documentation:

SQL scripts were not commented or structured

Table relationships were unclear

Business logic was embedded inside scripts without explanation

Required reverse engineering to understand data flow

4. Data Fragmentation Across Multiple Tables

Data was spread across disconnected tables:

Customer information split across multiple modules

Sales and product data stored in separate, non-linked tables

Ticket and support data isolated from CRM records

5. Incorrect or Outdated Values

Several fields contained outdated or incorrect values:

Old CRM IDs no longer valid

Deprecated product codes

Incorrect tax or pricing information

Legacy status fields not aligned with Zoho modules

6. Time Consumption Due to Data Complexity

The complexity of raw data increased processing time:

Large datasets (40–400+ tables)

Multiple joins required to reconstruct business logic

Manual validation needed for critical fields

7. Junk Data and Irrelevant Records

Raw datasets included unnecessary or irrelevant entries:

Test records created by previous developers

Obsolete customer accounts

Unused product categories

8. Data Quality Issues Affecting Migration

These issues directly impacted migration accuracy:

Skipped records during import due to invalid formats

Incorrect field mapping due to inconsistent naming

Loss of referential integrity without proper cleansing

Conclusion

Addressing raw data issues was a critical step in ensuring a successful migration to Zoho One. Through systematic cleansing, validation, and transformation, high-quality datasets were prepared to support CRM, Books, Desk, and Analytics modules with zero data loss and complete functional continuity.
