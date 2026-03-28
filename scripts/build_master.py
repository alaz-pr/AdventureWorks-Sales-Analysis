import sqlite3, pandas as pd

db_path = r"C:\Users\alazp\Desktop\Adventure_Works\adventureworks.db"
output_path = r"C:\Users\alazp\Desktop\Adventure_Works\data_clean\aw_master.csv"

conn = sqlite3.connect(db_path)

query = """
SELECT
    soh.SalesOrderID,
    substr(soh.OrderDate, 1, 10) AS OrderDate,
    CAST(substr(soh.OrderDate, 1, 4) AS INTEGER) AS OrderYear,
    CAST(substr(soh.OrderDate, 6, 2) AS INTEGER) AS OrderMonth,
    soh.TotalDue AS OrderRevenue,
    soh.OnlineOrderFlag,
    CAST(soh.SalesPersonID AS INTEGER) AS SalesPersonID,
    st.Name AS Territory,
    st."Group" AS Region,
    sod.SalesOrderDetailID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal,
    p.Name AS ProductName,
    ps.Name AS Subcategory,
    pc.Name AS Category
FROM SalesOrderHeader soh
LEFT JOIN SalesTerritory st ON soh.TerritoryID = st.TerritoryID
LEFT JOIN SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
LEFT JOIN Product p ON sod.ProductID = p.ProductID
LEFT JOIN ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
"""

df = pd.read_sql(query, conn)
df.to_csv(output_path, index=False)
conn.close()
print(f"Done - {len(df)} rows")
print(df[['OrderDate','OrderYear','OrderMonth']].head(3))
