# 📊 Dashboard Documentation

**Version:** 1.0  
**Last Updated:** 2024  
**Status:** Active

---

## Table of Contents
1. [Overview](#overview)
2. [Dashboard Architecture](#dashboard-architecture)
3. [Sales Dashboard](#sales-dashboard)
4. [Finance Dashboard](#finance-dashboard)
5. [Support Dashboard](#support-dashboard)
6. [Customer 360 Dashboard](#customer-360-dashboard)
7. [Product Performance Dashboard](#product-performance-dashboard)
8. [KPI Definitions](#kpi-definitions)
9. [Dashboard Validation](#dashboard-validation)
10. [Implementation & Operations](#implementation--operations)
11. [Appendix](#appendix)

---

## Overview

This document describes the structure, metrics, data sources, and functional behavior of the dashboards built in **Zoho Analytics** for the migration project.

### 🎯 Goal
Ensure stakeholders can monitor sales, finance, support, and customer performance using clean, validated, and reconciled data.

### 📈 Available Dashboards
| Dashboard | Purpose |
|-----------|---------|
| **Sales Dashboard** | Track revenue, pipeline health, and sales trends |
| **Finance Dashboard** | Monitor invoices, payments, and financial metrics |
| **Support Dashboard** | Track ticket volume and agent performance |
| **Customer 360 Dashboard** | Unified customer view across all touchpoints |
| **Product Performance Dashboard** | Analyze product sales and revenue contribution |

---

## Dashboard Architecture

### 2.1 Data Sources

```
Zoho CRM
├── Accounts
├── Contacts
└── Deals

Zoho Books
├── Invoices
├── Payments
└── Products

Zoho Desk
└── Tickets

Custom Layer
├── ETL Staging Tables
└── Derived KPI Tables
```

### 2.2 Data Refresh Frequency

| Data Source | Refresh Interval | Notes |
|---|---|---|
| Zoho CRM | Hourly | Real-time deal updates |
| Zoho Books | Hourly | Invoice and payment tracking |
| Zoho Desk | Hourly | Support ticket sync |
| Analytics Warehouse | Daily | Aggregated KPI tables |

> ⚠️ **Note:** Review refresh frequencies periodically to balance data freshness with API quota limits and performance impact.

---

## Sales Dashboard

### Purpose
Track revenue, pipeline health, product performance, and sales trends across the organization.

### Key Metrics (KPI Bar)
- **Total Sales** (MTD, QTD, YTD options)
- **Win Rate %** (conversion metric)
- **Average Deal Size** (trend indicator)
- **Pipeline Value** (forecast metric)

### Visual Components

| Chart | Type | Purpose |
|-------|------|---------|
| Monthly Sales Trend | Line Chart | Visualize sales progression over time |
| Pipeline Breakdown | Funnel Chart | Show deal progression through stages |
| Top Products by Revenue | Horizontal Bar | Identify top-performing products |
| Win/Loss Analysis | Pie Chart | Show sales conversion rates |
| Sales by Region | Map Chart | Geographic performance view |

### Interactive Features
- **Filters:** Date Range, Salesperson, Region, Product Category, Deal Stage
- **Tables:** Deal List with drill-down, Salesperson Performance Leaderboard
- **Drill-Down:** Click on region/product to see underlying deals

### Data Sources
- Deals table
- Accounts table
- Products table
- Salesperson dimension table

---

## Finance Dashboard

### Purpose
Monitor invoices, payments, outstanding amounts, tax summaries, and revenue trends.

### Key Metrics (KPI Bar)
- **Total Invoices** (count and amount)
- **Total Payments** (received)
- **Outstanding Amount** (aging)
- **Tax Collected** (compliance tracking)

### Visual Components

| Chart | Type | Purpose |
|-------|------|---------|
| Invoice Trend | Line Chart | Track invoice volume and value |
| Payment Collection Trend | Bar Chart | Monitor payment patterns |
| Outstanding Amount Breakdown | Stacked Bar | Analyze aging buckets |
| Revenue by Category | Pie Chart | Show revenue distribution |
| Tax Summary | Donut Chart | Tax liability overview |

### Interactive Features
- **Filters:** Date Range, Customer, Product Category, Payment Mode, Invoice Status
- **Tables:** Invoice Aging Report, Payment Ledger, Customer Outstanding Summary
- **Alerts:** Overdue invoice highlights and payment deadline warnings

### Data Sources
- Invoices table
- Payments table
- Products table
- Tax configuration table

---

## Support Dashboard

### Purpose
Track ticket volume, resolution efficiency, agent performance, and customer support load.

### Key Metrics (KPI Bar)
- **Total Tickets** (open and closed)
- **Avg Resolution Time** (SLA metric)
- **Open Tickets** (current backlog)
- **SLA Breaches** (compliance indicator)

### Visual Components

| Chart | Type | Purpose |
|-------|------|---------|
| Ticket Status Distribution | Pie Chart | Show ticket lifecycle status |
| Priority Breakdown | Bar Chart | Visualize priority distribution |
| Resolution Time Trend | Line Chart | Track performance over time |
| Agent Performance | Leaderboard | Compare agent metrics |
| Tickets by Category | Treemap | Show issue types |

### Interactive Features
- **Filters:** Date Range, Agent, Priority, Category, Status
- **Tables:** Ticket List with SLA indicators, Agent Workload Summary
- **Drill-Down:** Click agent name to see their ticket details
- **Color Coding:** Red for SLA breaches, green for on-time

### Data Sources
- Tickets table
- Contacts table
- Agents dimension
- SLA configuration table

---

## Customer 360 Dashboard

### Purpose
Provide a unified view of customer revenue, support load, lifetime value, and engagement patterns.

### Key Metrics (KPI Bar)
- **Lifetime Value (LTV)** (cumulative revenue)
- **Total Revenue** (account-level)
- **Total Tickets** (support interactions)
- **Avg Ticket Resolution Time** (support quality)

### Visual Components

| Chart | Type | Purpose |
|-------|------|---------|
| Customer Revenue | Bar Chart | Rank customers by revenue |
| Customer Support Load | Heatmap | Identify high-touch accounts |
| Lifetime Value Trend | Line Chart | Show customer growth trajectory |
| Customer Category Distribution | Pie Chart | Segment by customer type |

### Interactive Features
- **Filters:** Customer, Region, Category, Revenue Range
- **Tables:** Customer Profile Summary, Customer Interaction Timeline
- **Drill-Down:** Click customer to see related deals, invoices, and tickets
- **Search:** Full-text search for customer name/ID

### Data Sources
- Accounts table (customers)
- Deals table (revenue)
- Tickets table (support)
- Invoices table (payment history)

---

## Product Performance Dashboard

### Purpose
Analyze product sales, revenue contribution, category performance, and identify top sellers.

### Key Metrics (KPI Bar)
- **Total Product Revenue** (sum across all products)
- **Total Units Sold** (volume metric)
- **Top Product** (by revenue)
- **Category Contribution %** (top category)

### Visual Components

| Chart | Type | Purpose |
|-------|------|---------|
| Sales Volume Trend | Line Chart | Track units sold over time |
| Revenue by Product | Bar Chart | Rank products by revenue |
| Category Performance | Pie Chart | Show category contribution |
| Top 10 Products | Leaderboard | Quick reference for top sellers |

### Interactive Features
- **Filters:** Product, Category, Date Range, Region
- **Tables:** Product Sales Summary, Category Breakdown Table
- **Drill-Down:** Click product to see related deals and customers

### Data Sources
- Products table
- Deals table
- Order Items table
- Regional mapping table

---

## KPI Definitions

### 8.1 Sales KPIs

```
Total Sales = SUM(Deal Amount)
              where Deal Status = "Won"

Win Rate = COUNT(Won Deals) / COUNT(Total Deals)
           × 100

Average Deal Size = SUM(Deal Amount) / COUNT(Deals)
```

### 8.2 Finance KPIs

```
Outstanding Amount = SUM(Invoice Amount) - SUM(Payment Amount)

Tax Summary = SUM(Tax Amount)
              by Tax Category

Revenue by Category = SUM(Amount) 
                      grouped by Product Category
```

### 8.3 Support KPIs

```
Average Resolution Time = AVG(Closed_Time - Created_Time)
                           (in hours or days)

Ticket Load = COUNT(Tickets) / COUNT(Customers)
              (per customer ratio)

SLA Compliance = COUNT(On-Time Tickets) / COUNT(Total Tickets)
                 × 100
```

### 8.4 Customer KPIs

```
Lifetime Value (LTV) = SUM(Revenue per Customer)
                       over chosen period
                       (MTD / QTD / YTD)

Customer Engagement Score = Function of:
  • Number of deals
  • Total revenue
  • Support interactions
  • Contract value
```

---

## Dashboard Validation

### 9.1 Data Accuracy Checks ✅

- [ ] Validate dashboard totals against reconciliation report (record counts and financial totals)
- [ ] Validate row counts against source systems (CRM, Books, Desk)
- [ ] Verify date format compliance (ISO: `YYYY-MM-DD`)
- [ ] Verify currency format (decimals to 2 places minimum)
- [ ] Ensure ETL staging tables include audit fields:
  - `source_id` — original PK from source
  - `source_updated_at` — source timestamp
  - `etl_run_id` — ETL execution ID
  - `etl_status` — success/skipped/corrected

### 9.2 Functional Checks ✅

- [ ] Filter behavior — verify filters apply across all charts consistently
- [ ] Drill-down functionality — ensure drill paths return correct records
- [ ] Cross-module linking — verify account → deal → invoice → ticket paths work
- [ ] Null value handling — confirm missing data is displayed appropriately

### 9.3 Performance Checks ⚡

- [ ] Dashboard load time — target **< 5 seconds** for key views
- [ ] Query optimization — add indexes where needed
- [ ] Cache refresh validation — verify cache invalidation aligns with data refresh
- [ ] Monitor concurrent user load

### 9.4 Evidence & Test Artifacts 📋

Maintain a **validation log** with:
- Test case ID
- Expected result
- Observed result
- Tester name
- Timestamp
- Screenshots/snapshots

---

## Implementation & Operations

### Access Control
- ✋ Restrict dashboard **editing** to analytics team leads only
- 👁️ Restrict sensitive KPIs (revenue, costs) by role
- 🔐 Enforce row-level security for customer/region data

### Data Governance
- 📋 Document data lineage for each KPI
  - Source fields
  - Transformation logic
  - Aggregation rules
- 🏷️ Tag dashboards by confidentiality level (Public / Internal / Restricted)

### Error Handling & Monitoring
- 🚨 Alert on ETL failures (email/Slack/Teams)
- 📊 Link alerts to `etl_error_log` table
- 📈 Monitor dashboard load times and query performance

### Backups & Retention
- 💾 Retain ETL logs for **30 days** minimum
- 📦 Archive raw extracts per retention policy
- 🔄 Weekly backup of Zoho Analytics workspace configuration

---

## Appendix

### 11.1 Recommended ETL Audit Fields

| Field | Type | Purpose |
|-------|------|---------|
| `source_id` | VARCHAR | Original PK from source system |
| `etl_run_id` | VARCHAR | Unique ETL execution identifier |
| `source_updated_at` | TIMESTAMP | Last update time in source |
| `loaded_at` | TIMESTAMP | Load time into warehouse |
| `etl_status` | VARCHAR | success / skipped / corrected |
| `correction_reason` | VARCHAR | Notes on any corrections applied |

### 11.2 Validation Checklist (Sample)

1. **Record Count Reconciliation**
   - [ ] Compare CRM deal count with dashboard
   - [ ] Compare Books invoice count with dashboard
   - [ ] Compare Desk ticket count with dashboard

2. **Financial Validation**
   - [ ] Validate top 10 invoices by amount
   - [ ] Reconcile total revenue (Deals vs. Books)
   - [ ] Compare outstanding amounts with aging report

3. **Sample Testing**
   - [ ] Select 50 random deals
   - [ ] Verify related account and invoice links
   - [ ] Check all drill-down paths from each dashboard

4. **User Acceptance**
   - [ ] Test filter interactions for each dashboard
   - [ ] Verify drill-down returns expected records
   - [ ] Confirm KPI calculations match business rules

### 11.3 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Dashboard loads slowly | Add pre-aggregated staging table; check query complexity |
| Filters not applying | Verify join relationships; test filter column names |
| Mismatched totals | Check ETL deduplication logic; review null handling |
| Outdated data | Verify ETL scheduler is running; check API quotas |

---

## Conclusion

These dashboards provide **consolidated visibility** across sales, finance, support, and customer operations. They are built on validated, reconciled data and serve as the primary reporting layer for business intelligence.

  



*This documentation ensures clarity, consistency, and maintainability for all dashboard components across the Zoho ecosystem.*
