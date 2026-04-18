--Nova-Retail-Analysis.SQL

SELECT 'Products' AS TableName, COUNT(*) AS 
Records FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv') UNION ALL SELECT 
'Customers', COUNT(*) FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv') UNION 
ALL SELECT 'Sales', COUNT(*) FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv') UNION 
ALL SELECT 'CustomerFeedback', COUNT(*) FROM 
read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv');


SELECT *
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv');

SELECT *
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv');

SELECT *
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv');

SELECT *
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv');




--- Part 1: Basic SQL Queries

--1.1 -- List all products in the Electronic category. Show ProductID, ProductName, and UnitPrice. Order by price from highest to lowest.
SELECT ProductID, ProductName, UnitPrice, Category
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv')
WHERE Category = 'Electronics'
GROUP BY ProductID, ProductName, UnitPrice, Category
ORDER BY UnitPrice DESC;

--1.2 -- How many customers are in each region? Show Region and count of customers.
SELECT Region, COUNT(*) AS CustomerCount
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv')
GROUP BY Region
ORDER BY CustomerCount DESC;

--1.3 -- Show the 10 most recent orders. Display OrderID, OrderDate, and TotalSales
SELECT OrderID, OrderDate, SUM(Quantity * UnitPrice) AS TotalSales
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true)
GROUP BY OrderID, OrderDate
ORDER BY OrderDate DESC
LIMIT 10;

--1.4 -- Find all products with a UnitPrice less than R1000. Show ProductName, Category and UnitPrice.
SELECT ProductName, Category, UnitPrice
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv')
WHERE UnitPrice < 1000
ORDER BY UnitPrice DESC;

--1.5 -- Count how many feedback responses exist for each Satisfaction level. Order by the count in descending.
SELECT Satisfaction, COUNT(*) AS FeedbackCount
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv')
GROUP BY Satisfaction
ORDER BY FeedbackCount DESC;


--- Part 2: Intermediate SQL Queries

--2.1 -- Calculate total sales revenue for each product category. Show Category, Total Revenue, and Total Profit. Order by revenue descending.
WITH sales AS (SELECT * FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv')),
products AS (SELECT * FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv'))
SELECT p.Category, ROUND(SUM(s.TotalSales), 2) AS TotalRevenue, ROUND(SUM(s.Profit), 2)     AS TotalProfit
FROM sales s
JOIN products p 
  ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

--2.2 -- Find the top 5 customers by total purchase amount. Show CustomerID, Customer Name (FirstName + LastName), and Total Spent. Hint: Use CONCAT or + to combine names.
SELECT s.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, SUM(s.Quantity * s.UnitPrice) AS TotalSpent
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true) s
JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv', format => 'csv', header => true) c
  ON s.CustomerID = c.CustomerID
GROUP BY s.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpent DESC
LIMIT 5;

--2.3 -- Show total sales by month for 2024. Disply Year, Month (as number), and Total Sales. Order chronologically.
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(Quantity * UnitPrice) AS TotalSales
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv')
WHERE YEAR (OrderDate) = 2024
GROUP BY Year, Month
ORDER BY Year, Month;

--2.4 -- Compare Online vs Store performance. Show Channel, Number of Orders, Average Order Value, and Total Revenue.
SELECT Channel, COUNT(*) AS NumberOfOrders, AVG(Quantity * UnitPrice) AS AvgOrderValue, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv')
GROUP BY Channel
ORDER BY TotalRevenue DESC;

--2.5 -- For each product category, show the average customer rating. Include Category, Average Rating, and Number of Reviews. Only show categories with at least 50 reviews. 
SELECT ProductCategory, AVG(Rating) AS AvgRating, COUNT(*) AS NumberOfReviews
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv')
GROUP BY ProductCategory
HAVING COUNT(*) >= 50
ORDER BY AvgRating DESC;


--- Part 3: Advanced SQL Queries

--3.1 -- Find the product with the highest total sales in each category. Show Category, ProductName, and Total Revenue for that product. Use a window function or subquery.
SELECT Category, ProductName, TotalRevenue
FROM (
  SELECT p.Category, p.ProductName, SUM(s.Quantity * s.UnitPrice) AS TotalRevenue, ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY SUM(s.Quantity * s.UnitPrice) DESC) AS rn
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true) s
  JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv', format => 'csv', header => true) p
    ON s.ProductID = p.ProductID
  GROUP BY p.Category, p.ProductName)
WHERE rn = 1;

--3.2 -- Create query showing each customer's total puchases, number of orders, and average order value. Also include heir region and primary channel. Only show customers with more than 3 orders. Order by total purchases descending.
SELECT c.CustomerID, c.FirstName, c.LastName, c.Region, c.Channel, SUM(s.Quantity * s.UnitPrice) AS TotalPurchases, COUNT(DISTINCT s.OrderID) AS NumberOfOrders, AVG(s.Quantity * s.UnitPrice) AS AvgOrderValue
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true) s
JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv', format => 'csv', header => true) c
  ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Region, c.Channel
HAVING COUNT(DISTINCT s.OrderID) > 3
ORDER BY TotalPurchases DESC;

--3.3 -- Calculate the profit margin percentage for each product. Show ProductName, Category, Total Sales, Total Profit, and Profit Margin %. Order by Profit Margin descending. Formula: (Profit / Sales)*100
SELECT p.ProductName, p.Category, SUM(s.Quantity * s.UnitPrice) AS TotalSales, SUM(s.Profit) AS TotalProfit, ROUND((SUM(s.Profit) / SUM(s.Quantity * s.UnitPrice)) * 100, 2) AS ProfitMarginPercentage
FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true) s
JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv', format => 'csv', header => true) p
  ON s.ProductID = p.ProductID
GROUP BY p.ProductName, p.Category
ORDER BY ProfitMarginPercentage DESC;

--3.4 -- Compare sales between 2023 and 2024.Show the total sales for each year and calculate the growth percentage. Use a CTE or subquery.
WITH sales AS (
  SELECT * 
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv')),sales_2023 AS (
  SELECT SUM(TotalSales) AS TotalSales2023
  FROM sales
  WHERE YEAR(CAST(OrderDate AS DATE)) = 2023), sales_2024 AS (
  SELECT SUM(TotalSales) AS TotalSales2024
  FROM sales
  WHERE YEAR(CAST(OrderDate AS DATE)) = 2024)
SELECT ROUND(s3.TotalSales2023, 2) AS TotalSales2023, ROUND(s4.TotalSales2024, 2) AS TotalSales2024, ROUND(((s4.TotalSales2024 - s3.TotalSales2023) / s3.TotalSales2023) * 100, 2) AS GrowthPercentage
FROM sales_2023 s3, sales_2024 s4;

--3.5 -- Rank regions by total sales. Use the RANK() or ROW_NUMBER() window function. Show Region, Total Sales, Total Orders, and Rank.
WITH sales AS (
  SELECT * 
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv',
                  format => 'csv', header => true)), customers AS (
  SELECT *
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Customers.csv', format => 'csv', header => true)), regional_summary AS (
  SELECT c.Region, ROUND(SUM(s.TotalSales), 2) AS TotalSales, COUNT(DISTINCT s.OrderID) AS TotalOrders
  FROM sales s
  JOIN customers c ON s.CustomerID = c.CustomerID
  GROUP BY c.Region)
SELECT Region, TotalSales, TotalOrders, RANK() OVER (ORDER BY TotalSales DESC) AS Rank
FROM regional_summary
ORDER BY Rank ASC;


-- Part 4: Business Intelligence Questions

--4.1 -- Analyze whether highly satisfied customers (rating 4-5) make more repeat purchases than less satisfied customers (rating 1-3). Show satisfaction level groups, average number of orders per customer, and total customers in each group.
WITH sales AS (
  SELECT *
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv',format => 'csv', header => true)), feedback AS (
  SELECT *
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv',format => 'csv', header => true)), orders_per_customer AS (
  SELECT CustomerID, COUNT(DISTINCT OrderID) AS NumberOfOrders
  FROM sales
  GROUP BY CustomerID), customer_satisfaction AS (
  SELECT f.CustomerID,
    CASE
      WHEN f.Rating BETWEEN 4 AND 5 THEN 'Highly Satisfied'
      WHEN f.Rating BETWEEN 1 AND 3 THEN 'Less Satisfied'
    END AS SatisfactionLevel
  FROM feedback f)
SELECT cs.SatisfactionLevel, ROUND(AVG(o.NumberOfOrders), 2) AS AvgOrdersPerCustomer, COUNT(DISTINCT cs.CustomerID)   AS TotalCustomers
FROM customer_satisfaction cs
JOIN orders_per_customer o ON cs.CustomerID = o.CustomerID
WHERE cs.SatisfactionLevel IS NOT NULL
GROUP BY cs.SatisfactionLevel
ORDER BY AvgOrdersPerCustomer DESC;

--4.2 -- Examine the relationship between discount percentage and profit. Create discount bands (0%, 1-10%, 11-20%, 21-30%) and show total sales, total profit, and profit margin for each band.
WITH sales AS (
  SELECT *
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true)), discount_bands AS (
  SELECT *,
    CASE
      WHEN DiscountPercent = 0            THEN '0%'
      WHEN DiscountPercent BETWEEN 1 AND 10 THEN '1-10%'
      WHEN DiscountPercent BETWEEN 11 AND 20 THEN '11-20%'
      WHEN DiscountPercent BETWEEN 21 AND 30 THEN '21-30%'
    END AS DiscountBand
  FROM sales)
SELECT DiscountBand, ROUND(SUM(TotalSales), 2) AS TotalSales, ROUND(SUM(Profit), 2) AS TotalProfit, ROUND((SUM(Profit) / SUM(TotalSales)) * 100, 2)  AS ProfitMarginPercentage
FROM discount_bands
WHERE DiscountBand IS NOT NULL
GROUP BY DiscountBand
ORDER BY ProfitMarginPercentage DESC;

--4.3 -- Identify underperforming products (bottom 5 by total revenue) and analyze whether they should be discontinued. Consider sales volume, profit margin, and customer ratings.
WITH product_performance AS (
  SELECT p.ProductID, p.ProductName, p.Category, SUM(s.Quantity) AS TotalUnitsSold, SUM(s.TotalSales) AS TotalRevenue, SUM(s.Profit) AS TotalProfit, ROUND(SUM(s.Profit) / SUM(s.TotalSales) * 100, 2) AS ProfitMargin, AVG(f.Rating) AS AvgRating
  FROM read_files('/Volumes/workspace/april2026/witle_sql_project/Sales.csv', format => 'csv', header => true) s
  JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/Products.csv', format => 'csv', header => true) p 
    ON s.ProductID = p.ProductID
  LEFT JOIN read_files('/Volumes/workspace/april2026/witle_sql_project/CustomerFeedback.csv', format => 'csv', header => true) f 
    ON s.OrderID = f.OrderID
  GROUP BY p.ProductID, p.ProductName, p.Category)
SELECT *
FROM product_performance
ORDER BY TotalRevenue ASC
LIMIT 5;
