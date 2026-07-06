Sample CRM Import Files — Zoho CRM (Leads, Contacts, Accounts)

Version: 1.0Last Updated: 2026-07-05Author: Data Engineering / Migration Team

1. Purpose

This document provides sample CRM import file structures used during Zoho CRM migration. These samples help validate:

Field mappings

Data cleansing rules

Mandatory field requirements

Import readiness

The samples below represent CSV templates for the three core CRM modules:

Leads

Contacts

Accounts

2. Sample: Leads Import File (CSV Structure)

File Name: leads_import_sample.csv

Lead_ID

Lead_Name

Company

Email

Phone

Lead_Source

Country

Created_Time

L001

John Mathew

ACME Corp

john.mathew@gmail.com

+1 987-654-3210

Website

United States

2021-05-10

L002

Sushma M

Global HVAC

sushma.m@example.com

+91 99988 87770

Referral

India

2020-11-05

L003

Prashanth

—

prashanth@mail.com

+1 888-777-6660

Event

United States

2019-07-22

Notes:

Lead_Name and Email are mandatory.

Company can be blank.

Phone numbers standardized with country codes.

3. Sample: Contacts Import File (CSV Structure)

File Name: contacts_import_sample.csv

Contact_ID

First_Name

Last_Name

Email

Phone

Account_Name

Country

Created_Time

C001

John

Mathew

john.mathew@gmail.com

+1 987-654-3210

ACME Corp

United States

2021-05-10

C002

Sushma

Mahadevan

sushma.m@example.com

+91 99988 87770

Global HVAC

India

2020-11-05

C003

Prashanth

—

prashanth@mail.com

+1 888-777-6660

—

United States

2019-07-22

Notes:

Account_Name is optional but recommended.

Email must be unique.

Missing Last_Name allowed but flagged.

4. Sample: Accounts Import File (CSV Structure)

File Name: accounts_import_sample.csv

Account_ID

Account_Name

Phone

Country

Industry

Created_Time

A001

ACME Corp

+1 987-654-3210

United States

HVAC

2021-05-10

A002

Global HVAC

+91 99988 87770

India

HVAC

2020-11-05

A003

Prashanth Holdings

+1 888-777-6660

United States

Services

2019-07-22

Notes:

Account_Name is mandatory.

Industry standardized based on mapping rules.

5. Import File Validation Rules

These rules were applied before generating final CRM import files:

Mandatory fields must be present.

Email format must be valid.

Phone numbers must include country codes.

Country names standardized (United States, India, UK, etc.).

Duplicate emails removed.

Account lookup resolved for Contacts.

6. Usage in Migration Workflow

These sample files are used to:

Test CRM import functionality

Validate mapping logic

Train team members

Demonstrate correct CSV formatting

Support reconciliation reports

7. File Location

08_Sample_Data/
   └── sample_crm_import_files.md

8. Next Steps

Choose the next file to generate:

sample_cleaned_data.md

sample_validation_reports.md
