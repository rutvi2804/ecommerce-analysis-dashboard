# ecommerce-analysis-dashboard
Brazilian E-Commerce Analytics Dashboard built with Power BI, and BigQuery

# E-Commerce Analytics Dashboard
### Brazilian E-Commerce (Olist) · Power BI · BigQuery · SQL

![Dashboard Preview](page1_executive_summary.png)

---

## Project Overview
End-to-end analytics dashboard analyzing **96,134 orders** from the 
Brazilian Olist e-commerce platform (Jan 2017 – Aug 2018).

Built as a portfolio project to demonstrate skills in SQL, data 
modeling, and business intelligence visualization.

---

## Tools and Technologies
| Tool | Purpose |
|------|---------|
| Google BigQuery | Data storage and SQL transformation |
| SQL | Data cleaning, aggregation, RFM analysis |
| Power BI | 5-page interactive dashboard |
| DAX | Calculated measures and KPIs |

---

## Dashboard Pages

### Page 1 — Executive Summary
![Executive Summary](page1_executive_summary.png)
- Total Revenue: $15.4M · Total Orders: 96K · Total Customers: 93K
- Monthly revenue trend with average reference line
- Revenue by State (Top 5) · Orders by Month · Review Distribution
- Late Delivery Breakdown · Date Range and State slicers

### Page 2 — Category Performance
![Category Performance](page2_category_performance.png)
- Revenue by Category (Top 10)
- Avg Review Score by Category — conditional green/amber/red colouring
- Avg Days Late by Category — identifies logistics bottlenecks
- Scatter plot: Days Late vs Review Score — proves delivery impacts satisfaction

### Page 3 — Customer Segment Analysis
![Customer Segments](page3_customer_segments.png)
- RFM Segmentation — Champions, Loyal, New, At Risk, Lost
- Revenue, Customer Count and Avg Order Value by Segment
- Frequency vs Monetary scatter plot
- Retention Rate by Segment

### Page 4 — Retention Rate Analysis
![Retention Analysis](page4_retention_analysis.png)
- Cohort Retention Heatmap — green to red colour scale
- Retention by Month line chart — tracks drop-off curve
- Cohort Size by Month bar chart
- Active Customers area chart

### Page 5 — Segment Revenue Analysis
![Segment Revenue](page5_segment_revenue.png)
- Revenue Share donut chart by segment
- Total Revenue, Avg Order Value, Avg Revenue per Customer
- Revenue vs Customers scatter plot

---

## Key Business Insights

1. **Revenue grew 112% YoY** — strongest growth in Jul–Sep 2018
2. **Late delivery drives bad reviews** — categories with highest 
   avg days late consistently score lowest on reviews
3. **Champions segment** (15K customers) generates 19% of total 
   revenue despite being the smallest group
4. **Later cohorts retain better** — Month 1 retention improved 
   from 8.5% (Jan 2017) to 12.4% (May 2018)
5. **São Paulo dominates** — SP state accounts for 38% of total revenue

---

## Data Pipeline
Kaggle — 9 raw CSV files (47MB)
↓
Google BigQuery — uploaded as raw tables
↓
SQL Cleaning and Transformation
(Data Cleaning File.sql)
↓
Aggregated tables created:
· master_orders_agg
· category_performance
· customer_segment
· retention_rate
· segment_revenue
↓
Power BI Desktop — connected to BigQuery
↓
5-page interactive dashboard (Project.pbix)

---

## 📋 Dataset Information

Source: Olist Brazilian E-Commerce Public Dataset
Available at: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

| File | Description | Rows |
|------|-------------|------|
| olist_orders_dataset.csv | Order headers | 99,441 |
| olist_order_items_dataset.csv | Order line items | 112,650 |
| olist_customers_dataset.csv | Customer details | 99,441 |
| olist_products_dataset.csv | Product catalogue | 32,951 |
| olist_order_reviews_dataset.csv | Customer reviews | 99,224 |
| olist_order_payments_dataset.csv | Payment details | 103,886 |
| olist_sellers_dataset.csv | Seller details | 3,095 |
| olist_geolocation_dataset.csv | Geographic data | 1,000,163 |
| product_category_name_translation.csv | Category translations | 71 |

Final clean dataset: 96,134 orders · Jan 2017 – Aug 2018

---

## 🚀 How to Reproduce

1. Download Olist dataset from Kaggle link above
2. Create a Google BigQuery project
3. Upload all 9 CSV files as raw tables
4. Run Data Cleaning File.sql in BigQuery
5. Open Project.pbix in Power BI Desktop
6. Update BigQuery connection to your project ID
7. Refresh data — all 5 pages load automatically

---

## 👩‍💻 About the Author

**Rutvi Patel**
Computer Engineering Student · Carleton University · Ottawa, Canada
Specializing in Data Analytics — SQL · Power BI · Tableau · Python · BigQuery

LinkedIn: https://www.linkedin.com/in/rutvi-patel-2b8493217/

---

## 📄 License

This project uses publicly available data from Kaggle under the
CC BY-NC-SA 4.0 license.
