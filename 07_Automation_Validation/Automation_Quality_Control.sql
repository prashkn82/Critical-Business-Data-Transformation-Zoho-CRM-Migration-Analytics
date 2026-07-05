-- ============================================================================
-- Automation Quality Control - Automated Data Quality Checks (SQL)
-- Repository : prashkn82/Data-Analytics-in-Zoho
-- Path       : 07_Automation_Validation/Automation_Quality_Control.sql
-- Purpose    : SQL checks to validate, standardize and log issues during ETL
-- Notes      : These queries are intended as templates — adapt dialect-specific
--              functions (REGEXP, TIMESTAMPDIFF, etc.) to your target engine.
-- ============================================================================

-- ============================================================================
-- 0. Table of Contents
--   1. Overview
--   2. Duplicate Detection
--   3. Missing / NULL Value Checks
--   4. Invalid Format Checks
--   5. Referential Integrity Checks
--   6. Business Rule Validation
--   7. Standardization Checks
--   8. Anomaly Detection
--   9. Error Logging Templates
-- ============================================================================

-- ============================================================================
-- 1. OVERVIEW
-- ============================================================================

-- Automated data-quality checks for staging tables used in the ETL pipeline.
-- These checks cover:
--   - duplicates
--   - missing/null values
--   - invalid formats
--   - referential integrity
--   - business-rule validation
--   - standardization
--   - anomaly detection
--
-- Use these queries in your validation job, capture results, and insert into
-- an error/logging table for remediation and auditing.

-- ============================================================================
-- 2. DUPLICATE DETECTION
-- ============================================================================

-- 2.1 Duplicate Customers by Email + Phone
SELECT
    Email,
    Phone,
    COUNT(*) AS duplicate_count
FROM staging_customers
GROUP BY Email, Phone
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 2.2 Duplicate Products by SKU
SELECT
    SKU,
    COUNT(*) AS duplicate_count
FROM staging_products
GROUP BY SKU
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 2.3 Duplicate Tickets by Subject + Created_Time
SELECT
    Subject,
    Created_Time,
    COUNT(*) AS duplicate_count
FROM staging_tickets
GROUP BY Subject, Created_Time
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- ============================================================================
-- 3. MISSING OR NULL VALUE CHECKS
-- ============================================================================

-- 3.1 Missing Customer Emails
SELECT *
FROM staging_customers
WHERE Email IS NULL OR Email = '';

-- 3.2 Missing Product Names
SELECT *
FROM staging_products
WHERE Product_Name IS NULL OR Product_Name = '';

-- 3.3 Missing Order Dates
SELECT *
FROM staging_orders
WHERE Order_Date IS NULL;

-- ============================================================================
-- 4. INVALID FORMAT CHECKS
-- ============================================================================

-- 4.1 Invalid Email Format (simple check - adapt regex per dialect)
SELECT *
FROM staging_customers
WHERE Email IS NOT NULL
  AND Email NOT LIKE '%@%';

-- 4.2 Invalid Phone Numbers (non-numeric characters)
-- Use a strict numeric check: phone should consist only of digits (one or more)
SELECT *
FROM staging_customers
WHERE Phone IS NOT NULL
  AND Phone NOT REGEXP '^[0-9]+$';

-- 4.3 Invalid Dates (ISO yyyy-mm-dd)
SELECT *
FROM staging_orders
WHERE Order_Date IS NOT NULL
  AND Order_Date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- ============================================================================
-- 5. REFERENTIAL INTEGRITY CHECKS
-- ============================================================================

-- 5.1 Orders without valid Customers
SELECT o.*
FROM staging_orders o
LEFT JOIN staging_customers c
  ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- 5.2 Order Items without valid Products
SELECT oi.*
FROM staging_order_items oi
LEFT JOIN staging_products p
  ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

-- 5.3 Tickets without valid Contacts
SELECT t.*
FROM staging_tickets t
LEFT JOIN staging_contacts c
  ON t.Contact_ID = c.Contact_ID
WHERE c.Contact_ID IS NULL;

-- ============================================================================
-- 6. BUSINESS RULE VALIDATION
-- ============================================================================

-- 6.1 Negative Invoice Amounts
SELECT *
FROM staging_invoices
WHERE Total < 0;

-- 6.2 Invalid Deal Stages (allowed set)
SELECT *
FROM staging_deals
WHERE Stage IS NOT NULL
  AND Stage NOT IN ('New', 'In Progress', 'Closed Won', 'Closed Lost');

-- 6.3 Invalid Ticket Status (allowed set)
SELECT *
FROM staging_tickets
WHERE Status IS NOT NULL
  AND Status NOT IN ('OPEN', 'CLOSED', 'PENDING');

-- ============================================================================
-- 7. STANDARDIZATION CHECKS
-- ============================================================================

-- 7.1 Non-lowercase emails (email should be stored lowercase)
SELECT *
FROM staging_customers
WHERE Email IS NOT NULL
  AND Email <> LOWER(Email);

-- 7.2 Non-uppercase product names (if your standard is UPPERCASE)
SELECT *
FROM staging_products
WHERE Product_Name IS NOT NULL
  AND Product_Name <> UPPER(Product_Name);

-- 7.3 Non-ISO date formats (duplicate of 4.3; kept for clarity)
SELECT *
FROM staging_orders
WHERE Order_Date IS NOT NULL
  AND Order_Date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- ============================================================================
-- 8. ANOMALY DETECTION
-- ============================================================================

-- Note: These queries produce history and counts. Follow-up logic is needed to
-- detect "sudden drop" or "spike" by comparing rolling averages or thresholds.

-- 8.1 Daily orders time series (use to calculate drops)
SELECT
    Order_Date,
    COUNT(*) AS daily_orders
FROM staging_orders
GROUP BY Order_Date
ORDER BY Order_Date;

-- 8.2 Spike in refunds (daily)
SELECT
    Refund_Date,
    COUNT(*) AS refund_count
FROM staging_refunds
GROUP BY Refund_Date
ORDER BY Refund_Date;

-- 8.3 Missing transactions for a day
-- Note: GROUP BY ... HAVING COUNT(*) = 0 will not return any rows.
-- To detect days with zero transactions, compare against a calendar table or
-- generate a date series and LEFT JOIN to staging_orders.
-- Example (pseudo-SQL; adapt to your engine if you have a calendar table `calendar_dates`):
-- SELECT d.calendar_date
-- FROM calendar_dates d
-- LEFT JOIN (
--   SELECT Order_Date, COUNT(*) AS cnt FROM staging_orders GROUP BY Order_Date
-- ) o ON d.calendar_date = o.Order_Date
-- WHERE d.calendar_date BETWEEN '2023-01-01' AND '2023-01-31'
--   AND COALESCE(o.cnt, 0) = 0;

-- ============================================================================
-- 9. ERROR LOGGING TEMPLATES
-- ============================================================================

-- 9.1 Insert an error into the ETL error log (parameterize values)
-- Replace :record_id and :error_description with bind parameters in your ETL tool.
INSERT INTO etl_error_log (
    Record_ID,
    Module,
    Error_Type,
    Error_Description,
    Detected_At
) VALUES (
    :record_id,           -- e.g. primary key or composite identifier
    'Customers',          -- Module name
    'Invalid Email',      -- Error type (categorize as needed)
    :error_description,   -- e.g. 'Email missing @ symbol'
    CURRENT_TIMESTAMP
);

-- 9.2 Insert skipped records (parameterized)
INSERT INTO etl_skipped_records (
    Record_ID,
    Module,
    Reason,
    Skipped_At
) VALUES (
    :record_id,
    'Orders',
    'Missing Customer Reference',
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- 10. CONCLUSION & NEXT STEPS
-- ============================================================================

-- These queries provide a comprehensive baseline of checks to include in your
-- automated validation stage. Recommended next steps:
--   - Hook these into your ETL orchestration (Airflow, dbt, stored proc, etc.)
--   - Capture output into error tables and build dashboards for remediation
--   - Add thresholds and anomaly detection logic (rolling averages, z-scores)
--   - Add indexes on staging join keys for faster referential queries
-- ============================================================================
