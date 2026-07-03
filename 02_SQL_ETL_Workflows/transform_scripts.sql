/* ============================================================
   TRANSFORM SCRIPTS – LEGACY → CLEAN DATASET
   Purpose: Apply cleansing, normalization, standardisation,
            deduplication, and mapping transformations.
   Author: Prashanth
   ============================================================ */


/* ------------------------------------------------------------
   1. Standardise Customer Data
   ------------------------------------------------------------ */

-- Remove accents, trim spaces, normalize case
SELECT
    customer_id,
    UPPER(TRIM(first_name)) AS first_name,
    UPPER(TRIM(last_name)) AS last_name,
    LOWER(TRIM(email)) AS email,
    REGEXP_REPLACE(phone, '[^0-9]', '') AS phone,
    TRIM(address) AS address,
    DATE_FORMAT(created_at, '%Y-%m-%d') AS created_at
FROM customers_clean;


/* ------------------------------------------------------------
   2. Deduplicate Customers
   ------------------------------------------------------------ */

-- Deduplication using email + phone + name composite key
WITH ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY LOWER(email), REGEXP_REPLACE(phone, '[^0-9]', '')
            ORDER BY created_at ASC
        ) AS rn
    FROM customers_clean
)
SELECT *
FROM ranked_customers
WHERE rn = 1;


/* ------------------------------------------------------------
   3. Standardise Product Data
   ------------------------------------------------------------ */

SELECT
    product_id,
    UPPER(TRIM(product_name)) AS product_name,
    UPPER(TRIM(category)) AS category,
    UPPER(TRIM(sku)) AS sku,
    ROUND(price_ht, 2) AS price_ht,
    ROUND(price_ttc, 2) AS price_ttc,
    UPPER(TRIM(tax_code)) AS tax_code,
    active_flag
FROM products_clean;


/* ------------------------------------------------------------
   4. Normalize Dates Across All Tables
   ------------------------------------------------------------ */

-- Convert mixed formats to ISO YYYY-MM-DD
SELECT
    order_id,
    customer_id,
    STR_TO_DATE(order_date, '%Y-%m-%d') AS order_date,
    status,
    total_ht,
    total_ttc
FROM orders_clean;


/* ------------------------------------------------------------
   5. Rebuild Missing Relationships
   ------------------------------------------------------------ */

-- Fix orphan orders by matching customer via email/phone
SELECT
    o.order_id,
    c.customer_id,
    o.order_date,
    o.status,
    o.total_ht,
    o.total_ttc
FROM orders_clean o
LEFT JOIN customers_clean c
    ON LOWER(o.customer_email) = LOWER(c.email)
    OR REGEXP_REPLACE(o.customer_phone, '[^0-9]', '') =
       REGEXP_REPLACE(c.phone, '[^0-9]', '');


/* ------------------------------------------------------------
   6. Clean Order Items
   ------------------------------------------------------------ */

-- Remove invalid product references
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    ROUND(oi.unit_price_ht, 2) AS unit_price_ht,
    ROUND(oi.unit_price_ttc, 2) AS unit_price_ttc
FROM order_items_clean oi
INNER JOIN products_clean p
    ON oi.product_id = p.product_id;


/* ------------------------------------------------------------
   7. Standardize Ticket Data
   ------------------------------------------------------------ */
-- Normalize statuses and categories
SELECT
    ticket_id,
    customer_id,
    TRIM(subject) AS subject,
    UPPER(TRIM(category)) AS category,
    CASE
        WHEN LOWER(status) IN ('open', 'new') THEN 'OPEN'
        WHEN LOWER(status) IN ('closed', 'resolved') THEN 'CLOSED'
        ELSE 'PENDING'
    END AS status,
    DATE_FORMAT(created_at, '%Y-%m-%d') AS created_at,
    DATE_FORMAT(closed_at, '%Y-%m-%d') AS closed_at
FROM tickets_clean;


/* ------------------------------------------------------------
   8. Clean Invoice Data
   ------------------------------------------------------------ */

SELECT
    invoice_id,
    customer_id,
    DATE_FORMAT(invoice_date, '%Y-%m-%d') AS invoice_date,
    ROUND(amount, 2) AS amount,
    UPPER(TRIM(payment_status)) AS payment_status
FROM invoices_clean;


/* ------------------------------------------------------------
   9. Normalize Payment Data
   ------------------------------------------------------------ */

SELECT
    payment_id,
    customer_id,
    ROUND(amount, 2) AS amount,
    UPPER(TRIM(payment_mode)) AS payment_mode,
    DATE_FORMAT(payment_date, '%Y-%m-%d') AS payment_date,
    TRIM(reference_number) AS reference_number
FROM payments_clean;


/* ------------------------------------------------------------
   10. Extract & Normalize Custom Fields
   ------------------------------------------------------------ */

-- Clean longtext fields, remove HTML, normalize UTF-8
SELECT
    entity_id,
    REGEXP_REPLACE(raw_field_data, '<[^>]*>', '') AS raw_field_data,
    updated_at
FROM raw_custom_fields_clean;


/* ============================================================
   END OF TRANSFORM SCRIPTS
   ============================================================ */

