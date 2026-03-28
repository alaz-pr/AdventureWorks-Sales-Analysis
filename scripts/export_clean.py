import sqlite3, pandas as pd, os

db_path = r"C:\Users\alazp\Desktop\Adventure_Works\adventureworks.db"
output_path = r"C:\Users\alazp\Desktop\Adventure_Works\data_clean"

os.makedirs(output_path, exist_ok=True)

tables = [
    "ProductCategory",
    "ProductSubcategory", 
    "Product",
    "Customer",
    "Person",
    "SalesTerritory",
    "SalesPerson",
    "SalesPersonQuotaHistory",
    "SalesOrderHeader",
    "SalesOrderDetail"
]

conn = sqlite3.connect(db_path)

for table in tables:
    df = pd.read_sql(f"SELECT * FROM {table}", conn)
    out = os.path.join(output_path, f"{table}.csv")
    df.to_csv(out, index=False, encoding="utf-8")
    print(f"✓ {table} — {len(df)} rows exported")

conn.close()
print("\nAll done! Files saved to data_clean folder.")
