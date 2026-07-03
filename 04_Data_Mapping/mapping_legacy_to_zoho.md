Mapping Legacy to Zoho

1. Overview

This document defines the complete field‑mapping strategy used to migrate data from legacy systems into Zoho CRM, Books, Desk, and Analytics. The mapping ensures that every legacy field is correctly aligned with its corresponding Zoho module and field, preserving business logic and relational integrity.

This mapping was created after analyzing legacy tables, cleansing rules, and Zoho module requirements.

2. Mapping Principles

2.1 Standardization Before Mapping

All fields undergo cleansing and normalization before mapping:

Uppercase names

Lowercase emails

ISO date formats

Numeric‑only phone numbers

Standardized product SKUs

2.2 One‑to‑One Mapping

Direct field mapping where legacy fields match Zoho fields.

2.3 One‑to‑Many Mapping

Legacy fields split into multiple Zoho fields (e.g., phone numbers).

2.4 Many‑to‑One Mapping

Multiple legacy fields combined into a single Zoho field (e.g., address components).

2.5 Derived Fields

Fields created using business logic (e.g., status normalization).

3. Customer Module Mapping (Zoho CRM)

Legacy Field

Zoho Field

Notes

customer_id

Customer ID

Primary key

first_name

First Name

Uppercase

last_name

Last Name

Uppercase

email

Email

Lowercase, validated

phone

Phone

Numeric only

address

Address

Cleaned & standardized

created_at

Created Time

ISO format

4. Contact Module Mapping (Zoho CRM)

Legacy Field

Zoho Field

Notes

contact_id

Contact ID

Primary key

customer_id

Account Name

FK → Customers

first_name

First Name

Uppercase

last_name

Last Name

Uppercase

email

Email

Lowercase

phone

Phone

Cleaned

role

Designation

Normalized

is_primary

Primary Contact

Boolean

5. Product Module Mapping (Zoho CRM / Books)

Legacy Field

Zoho Field

Notes

product_id

Product ID

Primary key

product_name

Product Name

Uppercase

category

Category

Standardized

sku

SKU

Normalized

price_ht

Price (HT)

Decimal

price_ttc

Price (TTC)

Decimal

tax_code

Tax Code

Mapped to Zoho tax rules

6. Deals / Orders Mapping (Zoho CRM)

Legacy Field

Zoho Field

Notes

order_id

Deal ID

Primary key

customer_id

Account Name

FK → Customers

order_date

Closing Date

ISO format

status

Stage

Normalized

total_ht

Amount (HT)

Decimal

total_ttc

Amount (TTC)

Decimal

payment_mode

Payment Mode

Standardized

7. Order Items Mapping (Zoho Books)

Legacy Field

Zoho Field

Notes

order_item_id

Line Item ID

Primary key

order_id

Invoice / Order Reference

FK

product_id

Item Name

FK → Products

quantity

Quantity

Numeric

unit_price_ht

Rate (HT)

Decimal

unit_price_ttc

Rate (TTC)

Decimal

discount

Discount

Numeric

8. Ticket Mapping (Zoho Desk)

Legacy Field

Zoho Field

Notes

ticket_id

Ticket ID

Primary key

customer_id

Contact / Account

FK

subject

Subject

Cleaned

category

Category

Normalized

status

Status

OPEN / CLOSED / PENDING

priority

Priority

Standardized

created_at

Created Time

ISO format

closed_at

Closed Time

ISO format

9. Invoice Mapping (Zoho Books)

Legacy Field

Zoho Field

Notes

invoice_id

Invoice ID

Primary key

customer_id

Customer Name

FK

invoice_date

Invoice Date

ISO format

amount

Total Amount

Decimal

payment_status

Payment Status

Normalized

10. Payment Mapping (Zoho Books)

Legacy Field

Zoho Field

Notes

payment_id

Payment ID

Primary key

customer_id

Customer Name

FK

amount

Amount

Decimal

payment_mode

Payment Mode

Standardized

payment_date

Payment Date

ISO format

reference_number

Reference Number

Cleaned

11. Custom Fields Mapping

11.1 Longtext → Structured Fields

Remove HTML tags

Normalize UTF‑8

Extract key‑value pairs

Map to Zoho custom fields

11.2 Derived Custom Fields

Examples:

Legacy status → Zoho Stage

Legacy category → Zoho Category

Legacy flags → Boolean fields

12. Mapping Validation Rules

12.1 Referential Integrity

All orders must reference valid customers

All order items must reference valid products

All tickets must reference valid customers

12.2 Mandatory Fields

Email

Phone

Product name

Order date

Ticket subject

12.3 Format Validation

Email format

Numeric phone

Valid dates

13. Conclusion

This mapping ensures that all legacy data is accurately aligned with Zoho CRM, Books, Desk, and Analytics. By applying standardized rules, cleansing logic, and relationship reconstruction, the migration achieves:

Zero data loss

Accurate field alignment

Clean relational structure

Seamless functionality across Zoho modules

This document serves as the master reference for all mapping operations in the ETL workflow.
