**/* ============================================================
   EXTRACT SCRIPTS – LEGACY DATABASE
   Purpose: Extract raw data from legacy tables for ETL pipeline
   Author: Prashanth
   ============================================================ */**

/* ------------------------------------------------------------
   1. Extract Customers
   ------------------------------------------------------------ */
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(email) AS email,
    TRIM(phone) AS phone,
    address,
    created_at
FROM customers
WHERE customer_id IS NOT NULL;


/* ------------------------------------------------------------
   2. Extract Contacts
   ------------------------------------------------------------ */
SELECT
    contact_id,
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(email) AS email,
    TRIM(phone) AS phone,
    role,
    is_primary
FROM customer_contacts
WHERE contact_id IS NOT NULL;


/* ------------------------------------------------------------
   3. Extract Products
   ------------------------------------------------------------ */
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    category,
    sku,
    price_ht,
    price_ttc,
    tax_code,
    active_flag
FROM products
WHERE product_id IS NOT NULL;


/* ------------------------------------------------------------
   4. Extract Orders
   ------------------------------------------------------------ */
SELECT
    order_id,
    customer_id,
    order_date,
    status,
    total_ht,
    total_ttc,
    payment_mode
FROM orders
WHERE order_id IS NOT NULL;


/* ------------------------------------------------------------
   5. Extract Order Items
   ------------------------------------------------------------ */
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price_ht,
    unit_price_ttc,
    discount
FROM order_items
WHERE order_item_id IS NOT NULL;


/* ------------------------------------------------------------
   6. Extract Tickets (Support)
   ------------------------------------------------------------ */
SELECT
    ticket_id,
    customer_id,
    subject,
    category,
    status,
    priority,
    created_at,
    closed_at
FROM tickets
WHERE ticket_id IS NOT NULL;


/* ------------------------------------------------------------
   7. Extract Invoices
   ------------------------------------------------------------ */
SELECT
    invoice_id,
    customer_id,
    invoice_date,
    amount,
    payment_status
FROM invoices
WHERE invoice_id IS NOT NULL;


/* ------------------------------------------------------------
   8. Extract Payments
   ------------------------------------------------------------ */
SELECT
    payment_id,
    customer_id,
    amount,
    payment_mode,
    payment_date,
    reference_number
FROM payments
WHERE payment_id IS NOT NULL;


/* ------------------------------------------------------------
   9. Extract Raw Custom Fields (Longtext)
   ------------------------------------------------------------ */
SELECT
    entity_id,
    raw_field_data,
    updated_at
FROM raw_custom_fields
WHERE raw_field_data IS NOT NULL;


/* ------------------------------------------------------------
   10. Extract Lookup Tables
   ------------------------------------------------------------ */
SELECT * FROM tax_codes;
SELECT * FROM product_categories;
SELECT * FROM ticket_status;
SELECT * FROM payment_methods;

/* ============================================================
   END OF EXTRACT SCRIPTS
   ============================================================ */

