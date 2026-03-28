-- ============================================
-- 02_product_performance.sql
-- Product and category revenue analysis
-- SQLite-compatible, cleaned version
-- ============================================

-- Revenue by product category
SELECT
    COALESCE(pc.Name, 'Uncategorized') AS Category,
    COUNT(DISTINCT sod.SalesOrderID) AS TotalOrders,
    SUM(sod.OrderQty) AS UnitsSold,
    ROUND(SUM(sod.LineTotal), 2) AS TotalRevenue
FROM SalesOrderDetail sod
JOIN Product p
    ON sod.ProductID = p.ProductID
LEFT JOIN ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    COALESCE(pc.Name, 'Uncategorized')
ORDER BY
    TotalRevenue DESC;


-- Revenue by subcategory
SELECT
    COALESCE(pc.Name, 'Uncategorized') AS Category,
    COALESCE(ps.Name, 'No Subcategory') AS Subcategory,
    COUNT(DISTINCT sod.SalesOrderID) AS TotalOrders,
    SUM(sod.OrderQty) AS UnitsSold,
    ROUND(SUM(sod.LineTotal), 2) AS TotalRevenue
FROM SalesOrderDetail sod
JOIN Product p
    ON sod.ProductID = p.ProductID
LEFT JOIN ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    COALESCE(pc.Name, 'Uncategorized'),
    COALESCE(ps.Name, 'No Subcategory')
ORDER BY
    TotalRevenue DESC;


-- Top 10 products by revenue
SELECT
    p.Name AS Product,
    COALESCE(ps.Name, 'No Subcategory') AS Subcategory,
    COALESCE(pc.Name, 'Uncategorized') AS Category,
    SUM(sod.OrderQty) AS UnitsSold,
    ROUND(AVG(sod.UnitPrice), 2) AS AvgUnitPrice,
    ROUND(SUM(sod.LineTotal), 2) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(sod.LineTotal) DESC) AS RevenueRank
FROM SalesOrderDetail sod
JOIN Product p
    ON sod.ProductID = p.ProductID
LEFT JOIN ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    p.ProductID,
    p.Name,
    COALESCE(ps.Name, 'No Subcategory'),
    COALESCE(pc.Name, 'Uncategorized')
ORDER BY
    TotalRevenue DESC
LIMIT 10;