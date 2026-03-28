-- ============================================
-- 03_rfm_segmentation.sql
-- RFM segmentation analysis
-- SQLite-compatible, cleaned version
-- ============================================

-- RFM scores by customer
WITH params AS (
            SELECT date('2022-05-01') AS analysis_date
        ),
        rfm_base AS (
            SELECT
                soh.CustomerID,
                CAST(julianday((SELECT analysis_date FROM params)) - julianday(MAX(soh.OrderDate)) AS INTEGER) AS Recency,
                COUNT(soh.SalesOrderID) AS Frequency,
                ROUND(SUM(soh.TotalDue), 2) AS Monetary
            FROM SalesOrderHeader soh
            WHERE soh.CustomerID IS NOT NULL
            GROUP BY soh.CustomerID
        ),
        rfm_scores AS (
            SELECT
                CustomerID,
                Recency,
                Frequency,
                Monetary,
                NTILE(4) OVER (ORDER BY Recency ASC) AS R_Score,
                NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
                NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score
            FROM rfm_base
        ),
        rfm_segments AS (
            SELECT
                CustomerID,
                Recency,
                Frequency,
                Monetary,
                R_Score,
                F_Score,
                M_Score,
                (R_Score + F_Score + M_Score) AS RFM_Total,
                CASE
                    WHEN (R_Score + F_Score + M_Score) >= 10 THEN 'Champion'
                    WHEN (R_Score + F_Score + M_Score) >= 8 THEN 'Loyal'
                    WHEN (R_Score + F_Score + M_Score) >= 6 THEN 'Potential'
                    WHEN R_Score >= 3 AND (F_Score + M_Score) <= 4 THEN 'New Customer'
                    WHEN R_Score <= 2 AND (F_Score + M_Score) >= 4 THEN 'At Risk'
                    ELSE 'Lost'
                END AS Segment
            FROM rfm_scores
        )
        SELECT
            Segment,
            COUNT(CustomerID) AS CustomerCount,
            ROUND(AVG(Recency), 0) AS AvgRecencyDays,
            ROUND(AVG(Frequency), 1) AS AvgOrders,
            ROUND(AVG(Monetary), 2) AS AvgRevenue,
            ROUND(SUM(Monetary), 2) AS TotalRevenue
        FROM rfm_segments
        GROUP BY
            Segment
        ORDER BY
            TotalRevenue DESC;
