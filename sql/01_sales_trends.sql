-- ============================================
-- 01_sales_trends.sql
-- Monthly and quarterly revenue trends
-- SQLite-compatible, cleaned version
-- ============================================

-- Monthly revenue
SELECT
    strftime('%Y', OrderDate) AS Year,
    strftime('%m', OrderDate) AS Month,
    COUNT(SalesOrderID) AS TotalOrders,
    ROUND(SUM(TotalDue), 2) AS TotalRevenue,
    ROUND(AVG(TotalDue), 2) AS AvgOrderValue
FROM SalesOrderHeader
GROUP BY
    strftime('%Y', OrderDate),
    strftime('%m', OrderDate)
ORDER BY
    Year,
    Month;


-- Quarterly revenue
SELECT
    strftime('%Y', OrderDate) AS Year,
    CASE
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    COUNT(SalesOrderID) AS TotalOrders,
    ROUND(SUM(TotalDue), 2) AS TotalRevenue
FROM SalesOrderHeader
GROUP BY
    strftime('%Y', OrderDate),
    CASE
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END
ORDER BY
    Year,
    Quarter;


-- Revenue growth month over month
WITH monthly_revenue AS (
    SELECT
        strftime('%Y', OrderDate) AS Year,
        strftime('%m', OrderDate) AS Month,
        ROUND(SUM(TotalDue), 2) AS TotalRevenue
    FROM SalesOrderHeader
    GROUP BY
        strftime('%Y', OrderDate),
        strftime('%m', OrderDate)
)
SELECT
    Year,
    Month,
    TotalRevenue,
    LAG(TotalRevenue) OVER (ORDER BY Year, Month) AS PrevMonthRevenue,
    ROUND(
        (TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY Year, Month))
        * 100.0
        / NULLIF(LAG(TotalRevenue) OVER (ORDER BY Year, Month), 0),
        2
    ) AS MoM_Growth_Pct
FROM monthly_revenue
ORDER BY
    Year,
    Month;