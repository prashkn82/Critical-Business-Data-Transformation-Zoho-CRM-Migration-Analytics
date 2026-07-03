/* ============================================================
   LOAD SCRIPTS – CLEAN DATA → ZOHO STAGING TABLES
   Purpose: Insert transformed data into staging tables
            used for Zoho CRM, Books, Desk, Analytics imports.
   Author: Prashanth
   ============================================================ */


/* ------------------------------------------------------------
   1. Load Customers
   ------------------------------------------------------------ */

INSERT INTO staging_customers (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    address,
    created_at
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    address,
    created_at
FROM customers_transformed;


/* ------------------------------------------------------------
   2. Load Contacts
   ------------------------------------------------------------ */

INSERT INTO staging_contacts (
    contact_id,
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    role,
    is_primary
)
SELECT
    contact_id,
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    role,
    is_primary
FROM contacts_transformed;


/* ------------------------------------------------------------
   3. Load Products
   ------------------------------------------------------------ */

INSERT INTO staging_products (
    product_id,
    product_name,
    category,
    sku,
    price_ht,
    price_ttc,
    tax_code,
    active_flag
)
SELECT
    product_id,
    product_name,
    category,
    sku,
    price_ht,
    price_ttc,
    tax_code,
    active_flag
FROM products_transformed;


/* ------------------------------------------------------------
   4. Load Orders
   ------------------------------------------------------------ */

INSERT INTO staging_orders (
    order_id,
    customer_id,
    order_date,
    status,
    total_ht,
    total_ttc,
    payment_mode
)
SELECT
    order_id,
    customer_id,
    order_date,
    status,
    total_ht,
    total_ttc,
    payment_mode
FROM orders_transformed;


/* ------------------------------------------------------------
   5. Load Order Items
   ------------------------------------------------------------ */

INSERT INTO staging_order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price_ht,
    unit_price_ttc,
    discount
)
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price_ht,
    unit_price_ttc,
    discount
FROM order_items_transformed;


/* ------------------------------------------------------------
   6. Load Tickets
   ------------------------------------------------------------ */

INSERT INTO staging_tickets (
    ticket_id,
    customer_id,
    subject,
    category,
    status,
    priority,
    created_at,
    closed_at
)
SELECT
    ticket_id,
    customer_id,
    subject,
    category,
    status,
    priority,
    created_at,
    closed_at
FROM tickets_transformed;


/* ------------------------------------------------------------
   7. Load Invoices
   ------------------------------------------------------------ */

INSERT INTO staging_invoices (
    invoice_id,
    customer_id,
    invoice_date,
    amount,
    payment_status
)
SELECT
    invoice_id,
    customer_id,
    invoice_date,
    amount,
    payment_status
FROM invoices_transformed;


/* ------------------------------------------------------------
   8. Load Payments
   ------------------------------------------------------------ */

INSERT INTO staging_payments (
    payment_id,
    customer_id,
    amount,
    payment_mode,
    payment_date,
    reference_number
)
SELECT
    payment_id,
    customer_id,
    amount,
    payment_mode,
    payment_date,
    reference_number
FROM payments_transformed;


/* ------------------------------------------------------------
   9. Load Custom Fields
   ------------------------------------------------------------ */

INSERT INTO staging_custom_fields (
    entity_id,
    raw_field_data,
    updated_at
)
SELECT
    entity_id,
    raw_field_data,
    updated_at
FROM custom_fields_transformed;


/* ------------------------------------------------------------
   10. Referential Integrity Validation
   ------------------------------------------------------------ */

-- Ensure all orders reference valid customers
SELECT o.order_id
FROM staging_orders o
LEFT JOIN staging_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Ensure all order items reference valid products
SELECT oi.order_item_id
FROM staging_order_items oi
LEFT JOIN staging_products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


/* ============================================================
   END OF LOAD SCRIPTS
   ============================================================ */
