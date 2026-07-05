Overview
This document defines the complete Validation Workflow used during the ETL and migration process.
It ensures that all data extracted from legacy systems is accurate, complete, standardized, and ready for loading into Zoho CRM, Books, Desk, and Analytics.

The workflow is divided into sequential phases, each with clear objectives, checks, and outputs.

2. Validation Workflow Summary
The validation workflow follows this sequence:

Raw Data Integrity Validation

Structural Validation

Format & Standardization Validation

Business Rule Validation

Referential Integrity Validation

Cross‑Module Validation

Exception Logging & Reporting

Final Approval & Sign‑off

Each phase is described in detail below.

3. Raw Data Integrity Validation
Objective:
Ensure extracted legacy data is complete and uncorrupted.

Checks:
Row count comparison (Legacy vs Staging)

Column completeness

Null value detection

Corrupted record detection

Encoding validation (UTF‑8 normalization)

Outputs:
Raw integrity report

Missing/invalid record list

4. Structural Validation
Objective:
Ensure all tables and fields match the expected schema.

Checks:
Field existence

Data type validation

Length validation (e.g., phone length, SKU length)

Mandatory field presence

Outputs:
Structural validation report

Schema mismatch list

5. Format & Standardization Validation
Objective:
Ensure all fields follow standardized formats required by Zoho.

Checks:
Email format (%@%)

Phone numeric‑only

Date ISO format (YYYY-MM-DD)

Uppercase names

Lowercase emails

Decimal monetary fields

Outputs:
Format error report

Standardization summary

6. Business Rule Validation
Objective:
Ensure data follows business logic and domain rules.

Checks:
Valid deal stages

Valid ticket statuses

Positive invoice amounts

Valid payment modes

Product category normalization

Boolean flag normalization

Outputs:
Business rule violation report

Corrected values list

7. Referential Integrity Validation
Objective:
Ensure relationships between modules are valid.

Checks:
Orders → Customers

Order Items → Products

Tickets → Contacts

Invoices → Deals

Payments → Invoices

Outputs:
Orphan record report

Reconstructed relationship list

8. Cross‑Module Validation
Objective:
Ensure consistency across CRM, Books, Desk, and Analytics.

Checks:
Customer ID consistency

Product SKU consistency

Deal → Invoice → Payment chain

Ticket → Contact → Customer chain

Analytics totals vs CRM/Books/Desk totals

Outputs:
Cross‑module consistency report

Reconciliation summary

9. Exception Logging & Reporting
Objective:
Capture all errors, warnings, and skipped records.

Logs:
etl_error_log

etl_warning_log

etl_skipped_records

etl_repair_actions

Outputs:
Exception summary

Corrective action list

10. Final Approval & Sign‑Off
Objective:
Confirm that all validation steps are complete and data is ready for migration.

Steps:
Review validation reports

Review reconciliation report

Stakeholder approval (Ops, Finance, Support)

Migration readiness confirmation

Outputs:
Signed validation checklist

Approval certificate for migration execution

11. Conclusion
This validation workflow ensures that all data entering Zoho CRM, Books, Desk, and Analytics is clean, standardized, accurate, and fully reconciled.
It forms the backbone of a reliable ETL process and guarantees high‑quality data for business operations and reporting.
