Analytics SQL Queries

1. Overview

This file contains core SQL queries used in Zoho Analytics to build KPIs, dashboards, and cross‑module reports. These queries are optimized for the unified data model created during the ETL process.

2. Sales Queries

2.1 Monthly Sales Trend

SELECT 
    DATE_FORMAT(Closing_Date, '%Y-%m') AS Month,
    SUM(Amount) AS Total_Sales
FROM Deals
WHERE Stage = 'Closed Won'
GROUP BY DATE_FORMAT(Closing_Date, '%Y-%m')
ORDER BY Month;

2.2 Win Rate Calculation

SELECT 
    (SUM(CASE WHEN Stage = 'Closed Won' THEN 1 ELSE 0 END) * 100.0) /
    COUNT(*) AS Win_Rate
FROM Deals;

2.3 Pipeline Value

SELECT 
    SUM(Amount) AS Pipeline_Value
FROM Deals
WHERE Stage NOT IN ('Closed Won', 'Closed Lost');

2.4 Top Products by Revenue

SELECT 
    P.Product_Name,
    SUM(OI.Quantity * OI.Unit_Price) AS Revenue
FROM Order_Items OI
JOIN Products P ON OI.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY Revenue DESC
LIMIT 10;

3. Finance Queries

3.1 Invoice Trend

SELECT 
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS Month,
    SUM(Total) AS Total_Invoice_Amount
FROM Invoices
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY Month;

3.2 Outstanding Amount

SELECT 
    SUM(I.Total) - SUM(P.Amount) AS Outstanding_Amount
FROM Invoices I
LEFT JOIN Payments P ON I.Invoice_ID = P.Invoice_ID;

3.3 Tax Summary

SELECT 
    Tax_Code,
    SUM(Tax_Amount) AS Total_Tax
FROM Invoices
GROUP BY Tax_Code;

3.4 Payment Collection Trend

SELECT 
    DATE_FORMAT(Payment_Date, '%Y-%m') AS Month,
    SUM(Amount) AS Total_Payments
FROM Payments
GROUP BY DATE_FORMAT(Payment_Date, '%Y-%m')
ORDER BY Month;

4. Support Queries

4.1 Ticket Status Distribution

SELECT 
    Status,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Status;

4.2 Average Resolution Time

SELECT 
    AVG(TIMESTAMPDIFF(HOUR, Created_Time, Closed_Time)) AS Avg_Resolution_Hours
FROM Tickets
WHERE Closed_Time IS NOT NULL;

4.3 Agent Performance

SELECT 
    Agent_Name,
    COUNT(*) AS Tickets_Handled
FROM Tickets
GROUP BY Agent_Name
ORDER BY Tickets_Handled DESC;

5. Customer 360 Queries

5.1 Lifetime Value (LTV)

SELECT 
    Customer_ID,
    SUM(Total) AS Lifetime_Value
FROM Invoices
GROUP BY Customer_ID;

5.2 Customer Support Load

SELECT 
    Customer_ID,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY Customer_ID;

5.3 Customer Revenue Trend

SELECT 
    Customer_ID,
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS Month,
    SUM(Total) AS Monthly_Revenue
FROM Invoices
GROUP BY Customer_ID, DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY Customer_ID, Month;

6. Product Performance Queries

6.1 Total Product Revenue

SELECT 
    P.Product_Name,
    SUM(OI.Quantity * OI.Unit_Price) AS Total_Revenue
FROM Order_Items OI
JOIN Products P ON OI.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY Total_Revenue DESC;

6.2 Units Sold by Product

SELECT 
    Product_ID,
    SUM(Quantity) AS Units_Sold
FROM Order_Items
GROUP BY Product_ID;

6.3 Category Contribution

SELECT 
    P.Category,
    SUM(OI.Quantity * OI.Unit_Price) AS Category_Revenue
FROM Order_Items OI
JOIN Products P ON OI.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Category_Revenue DESC;

7. Cross‑Module Queries

7.1 Customer → Deals → Invoices → Payments Flow

SELECT 
    A.Account_Name,
    D.Deal_ID,
    I.Invoice_ID,
    P.Payment_ID,
    I.Total AS Invoice_Total,
    P.Amount AS Payment_Amount
FROM Accounts A
LEFT JOIN Deals D ON A.Customer_ID = D.Customer_ID
LEFT JOIN Invoices I ON D.Deal_ID = I.Deal_ID
LEFT JOIN Payments P ON I.Invoice_ID = P.Invoice_ID
ORDER BY A.Account_Name;

7.2 Customer 360 Summary

SELECT 
    A.Account_Name,
    SUM(I.Total) AS Total_Revenue,
    COUNT(T.Ticket_ID) AS Total_Tickets,
    COUNT(D.Deal_ID) AS Total_Deals
FROM Accounts A
LEFT JOIN Invoices I ON A.Customer_ID = I.Customer_ID
LEFT JOIN Tickets T ON A.Customer_ID = T.Customer_ID
LEFT JOIN Deals D ON A.Customer_ID = D.Customer_ID
GROUP BY A.Account_Name;

8. Conclusion

These SQL queries form the foundation of Zoho Analytics dashboards and KPIs. They support Sales, Finance, Support, Customer 360, and Product Performance reporting using clean, reconciled, and standardized data.
