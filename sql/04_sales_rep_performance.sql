-- ============================================
-- 04_sales_rep_performance.sql
-- Sales representative performance analysis
-- SQLite-compatible, cleaned version
-- ============================================

WITH rep_sales AS (
            SELECT
                CAST(soh.SalesPersonID AS INTEGER) AS BusinessEntityID,
                'Rep ' || CAST(soh.SalesPersonID AS TEXT) AS RepName,
                st.Name AS Territory,
                COUNT(soh.SalesOrderID) AS TotalOrders,
                ROUND(SUM(soh.TotalDue), 2) AS TotalRevenue,
                ROUND(AVG(soh.TotalDue), 2) AS AvgOrderValue
            FROM SalesOrderHeader soh
            JOIN SalesPerson sp
                ON CAST(soh.SalesPersonID AS INTEGER) = sp.BusinessEntityID
            JOIN SalesTerritory st
                ON sp.TerritoryID = st.TerritoryID
            WHERE soh.SalesPersonID IS NOT NULL
            GROUP BY
                CAST(soh.SalesPersonID AS INTEGER),
                st.Name
        )
        SELECT
            BusinessEntityID,
            RepName,
            Territory,
            TotalOrders,
            TotalRevenue,
            AvgOrderValue,
            ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (), 2) AS RevenueSharePct,
            RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
        FROM rep_sales
        ORDER BY
            TotalRevenue DESC;
