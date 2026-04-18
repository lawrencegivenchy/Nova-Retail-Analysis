# Nova Retail Group — Sales Performance Analysis

## Project Overview

This project delivers a full end-to-end data analysis of Nova Retail Group's sales, customer, product, and feedback data spanning 2023 and 2024. The analysis was conducted using **Databricks SQL** for data transformation and querying, and **Microsoft Power BI** for interactive dashboard visualisation. The goal was to uncover revenue trends, identify top and underperforming products, understand customer behaviour across regions and channels, and evaluate customer satisfaction patterns.

---

## Business Context

Nova Retail Group operates across multiple regions in South Africa, selling products across three categories — Electronics, Home Appliances, and Lifestyle Goods — through both Online and Store channels. Leadership required a data-driven view of sales performance to support strategic decisions around product stocking, regional investment, and customer retention.

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Databricks SQL | Data exploration, transformation, and view creation |
| Microsoft Power BI | Interactive dashboard and visualisation |
| GitHub | Version control and portfolio hosting |

---

## Dataset

The analysis is based on four datasets:

| Table | Records | Key Columns |
|---|---|---|
| Sales | 2,500 orders | OrderID, OrderDate, ProductID, CustomerID, Quantity, UnitPrice, DiscountPercent, DiscountAmount, TotalSales, TotalCost, Profit, Channel |
| Customers | 500 customers | CustomerID, FirstName, LastName, Region, Channel, JoinDate |
| Products | 30 products | ProductID, ProductName, Category, UnitPrice, CostPrice |
| Customer Feedback | 1,000 responses | FeedbackID, OrderID, CustomerID, FeedbackDate, Rating, Satisfaction, RecommendLikelihood, ProductCategory, Comments |

---

## Key Business Metrics

| Metric | Value |
|---|---|
| Total Revenue | R16,878,317.40 |
| Total Profit | R5,915,087.40 |
| Total Orders | 2,500 |
| YoY Revenue Growth | 9.63% |
| Online Revenue | R11,044,639.40 |
| Store Revenue | R5,833,678.00 |

---

## SQL Analysis — Databricks

All queries were written in Databricks SQL and saved as permanent views under the schema `workspace.april2026_15`. The analysis was structured into four parts:

### Part 1 — Basic Queries
- Listed all Electronics products ordered by price
- Counted customers per region
- Retrieved the 10 most recent orders
- Identified products priced under R1,000
- Counted feedback responses by satisfaction level

### Part 2 — Intermediate Queries
- Calculated total revenue and profit by product category
- Identified top 5 customers by total spend
- Analysed monthly sales trends for 2024
- Compared Online vs Store channel performance
- Calculated average customer rating by product category

### Part 3 — Advanced Queries
- Used window functions (`ROW_NUMBER`) to find the top product per category
- Built a full customer purchase profile including region, channel, order count, and average order value
- Calculated profit margin percentage per product
- Compared 2023 vs 2024 revenue using CTEs and calculated YoY growth
- Ranked regions by total sales using `RANK()` window function

### Part 4 — Business Intelligence Questions
- Analysed whether highly satisfied customers make more repeat purchases
- Examined the relationship between discount bands and profit margin
- Identified the bottom 5 underperforming products by revenue, with profit margin and average rating

---

## Power BI Dashboard

The dashboard consists of 4 pages with full navigation buttons between pages.

### Page 1 — Sales Overview
- KPI Cards: Total Revenue, Total Profit, YoY Growth %, Total Orders
- Monthly Revenue Trend — 2024 (Line Chart)
- Revenue by Product Category (Bar Chart)
- Revenue by Region (Bar Chart)
- Online vs Store Performance (Bar Chart)

### Page 2 — Customer & Channel Analysis
- Top 5 Customers by Revenue (Bar Chart)
- Channel Performance: Revenue Comparison (Bar Chart)
- Customer Distribution by Region (Bar Chart)
- Revenue by Customer Join Year (Bar Chart)

### Page 3 — Products & Profitability
- Revenue by Product Category (Bar Chart)
- Profit Margin % by Category (Bar Chart)
- Top 5 Products by Revenue (Bar Chart)
- Bottom 5 Products by Revenue (Bar Chart)

### Page 4 — Customer Satisfaction
- Orders by Satisfaction Level (Bar Chart)
- Average Rating by Product Category (Bar Chart)
- Average Recommend Likelihood by Satisfaction (Bar Chart)
- Feedback Volume by Year (Bar Chart)

---

## Key Findings

- **Electronics dominates revenue**, generating R12,543,376 — 74% of total revenue — while Lifestyle Goods contributes only R952,040.
- **Online channel outperforms Store** by nearly 2x in revenue (R11M vs R5.8M), suggesting the business should prioritise its digital channel.
- **Revenue grew 9.63% from 2023 to 2024**, indicating healthy business growth year on year.
- **North region leads** in customer count with 154 customers, while West has the lowest at 106.
- **Very Satisfied and Satisfied customers** account for 696 out of 1,000 feedback responses (69.6%), indicating strong overall customer sentiment.
- **Home Appliances has the highest profit margin %** despite being second in revenue, making it a strategically valuable category.
- **Bottom 5 products** (Water Bottle, Scented Candles, Yoga Mat, Electric Kettle, Sunglasses) are all Lifestyle Goods with low revenue — candidates for discontinuation or repositioning.

---

## Project Structure

```
nova-retail-group-analysis/
│
├── README.md
├── SQL/
│   └── nova_retail_queries.sql
├── Dashboard/
│   └── nova_retail_dashboard.pbix
└── Data/
    ├── Sales.csv
    ├── Customers.csv
    ├── Products.csv
    └── CustomerFeedback.csv
```

---

## Author

**Lawrence T. Makhafola**
BSc Mathematical Sciences — Sefako Makgatho Health Sciences University
Witle Academy Data Analytics Bootcamp
📍 Pretoria, South Africa
🔗 [LinkedIn](www.linkedin.com/in/lawrence-makhafola-8b0075249) | 🌐 [GitHub Portfolio](https://github.com/lawrencegivenchy) | [Personal Website](https://lawrence-makhafola.vercel.app/#home)

---

*This project was completed as part of the Witle Academy Data Analytics Bootcamp — Nova Retail Group scenario.*
