-- ============================================
-- 05_territory_analysis.sql
-- Sales territory performance analysis
-- SQLite-compatible, cleaned version
-- ============================================

-- Revenue by territory
WITH territory_revenue AS (
    SELECT
        st.Name AS Territory,
        st."Group" AS Region,
        COUNT(soh.SalesOrderID) AS TotalOrders,
        ROUND(SUM(soh.TotalDue), 2) AS TotalRevenue,
        ROUND(AVG(soh.TotalDue), 2) AS AvgOrderValue
    FROM SalesOrderHeader soh
    JOIN SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY
        st.Name,
        st."Group"
)
SELECT
    Territory,
    Region,
    TotalOrders,
    TotalRevenue,
    AvgOrderValue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (), 2) AS RevenueSharePct
FROM territory_revenue
ORDER BY
    TotalRevenue DESC;


-- Online vs in-store revenue by territory
SELECT
    st.Name AS Territory,
    CASE
        WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'In-Store'
    END AS Channel,
    COUNT(soh.SalesOrderID) AS TotalOrders,
    ROUND(SUM(soh.TotalDue), 2) AS TotalRevenue
FROM SalesOrderHeader soh
JOIN SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name,
    CASE
        WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'In-Store'
    END
ORDER BY
    st.Name,
    Channel;