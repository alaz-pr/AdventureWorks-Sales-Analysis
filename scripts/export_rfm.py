import sqlite3, pandas as pd

db_path = r"C:\Users\alazp\Desktop\Adventure_Works\adventureworks.db"
output_path = r"C:\Users\alazp\Desktop\Adventure_Works\data_clean\rfm_segments.csv"

conn = sqlite3.connect(db_path)

query = """
WITH rfm_base AS (
    SELECT
        CustomerID,
        CAST(julianday(MAX(OrderDate)) - julianday('2022-05-01') AS INTEGER) AS Recency,
        COUNT(SalesOrderID) AS Frequency,
        ROUND(SUM(TotalDue), 2) AS Monetary
    FROM SalesOrderHeader
    GROUP BY CustomerID
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
)
SELECT
    CustomerID,
    Recency,
    Frequency,
    ROUND(Monetary, 2) AS Monetary,
    R_Score,
    F_Score,
    M_Score,
    CASE
        WHEN (R_Score + F_Score + M_Score) >= 10 THEN 'Champion'
        WHEN (R_Score + F_Score + M_Score) >= 8 THEN 'Loyal'
        WHEN (R_Score + F_Score + M_Score) >= 6 THEN 'Potential'
        WHEN R_Score >= 3 AND (F_Score + M_Score) <= 4 THEN 'New Customer'
        WHEN R_Score <= 2 AND (F_Score + M_Score) >= 4 THEN 'At Risk'
        ELSE 'Lost'
    END AS Segment
FROM rfm_scores
"""

df = pd.read_sql(query, conn)
df.to_csv(output_path, index=False)
conn.close()
print(f"Done — {len(df)} rows exported to rfm_segments.csv")
