import sqlite3, pandas as pd, os

db_path = r"C:\Users\alazp\Desktop\Adventure_Works\adventureworks.db"
data_path = r"C:\Users\alazp\Desktop\Adventure_Works\data"

table_columns = {
    "ProductCategory": ["ProductCategoryID", "Name", "rowguid", "ModifiedDate"],
    "ProductSubcategory": ["ProductSubcategoryID", "ProductCategoryID", "Name", "rowguid", "ModifiedDate"],
    "Product": ["ProductID", "Name", "ProductNumber", "MakeFlag", "FinishedGoodsFlag", "Color", "SafetyStockLevel", "ReorderPoint", "StandardCost", "ListPrice", "Size", "SizeUnitMeasureCode", "WeightUnitMeasureCode", "Weight", "DaysToManufacture", "ProductLine", "Class", "Style", "ProductSubcategoryID", "ProductModelID", "SellStartDate", "SellEndDate", "DiscontinuedDate", "rowguid", "ModifiedDate"],
    "Customer": ["CustomerID", "PersonID", "StoreID", "TerritoryID", "AccountNumber", "rowguid", "ModifiedDate"],
    "Person": ["BusinessEntityID", "PersonType", "NameStyle", "Title", "FirstName", "MiddleName", "LastName", "Suffix", "EmailPromotion", "AdditionalContactInfo", "Demographics", "rowguid", "ModifiedDate"],
    "SalesTerritory": ["TerritoryID", "Name", "CountryRegionCode", "Group", "SalesYTD", "SalesLastYear", "CostYTD", "CostLastYear", "rowguid", "ModifiedDate"],
    "SalesPerson": ["BusinessEntityID", "TerritoryID", "SalesQuota", "Bonus", "CommissionPct", "SalesYTD", "SalesLastYear", "rowguid", "ModifiedDate"],
    "SalesPersonQuotaHistory": ["BusinessEntityID", "QuotaDate", "SalesQuota", "rowguid", "ModifiedDate"],
    "SalesOrderHeader": ["SalesOrderID", "RevisionNumber", "OrderDate", "DueDate", "ShipDate", "Status", "OnlineOrderFlag", "SalesOrderNumber", "PurchaseOrderNumber", "AccountNumber", "CustomerID", "SalesPersonID", "TerritoryID", "BillToAddressID", "ShipToAddressID", "ShipMethodID", "CreditCardID", "CreditCardApprovalCode", "CurrencyRateID", "SubTotal", "TaxAmt", "Freight", "TotalDue", "Comment", "rowguid", "ModifiedDate"],
    "SalesOrderDetail": ["SalesOrderID", "SalesOrderDetailID", "CarrierTrackingNumber", "OrderQty", "ProductID", "SpecialOfferID", "UnitPrice", "UnitPriceDiscount", "LineTotal", "rowguid", "ModifiedDate"],
}

conn = sqlite3.connect(db_path)
for table, columns in table_columns.items():
    file_path = os.path.join(data_path, f"{table}.csv")
    if os.path.exists(file_path):
        try:
            df = pd.read_csv(file_path, sep="\t", header=None, names=columns, encoding="utf-8")
            df.to_sql(table, conn, if_exists="replace", index=False)
            print(f"✓ {table} — {len(df)} rows")
        except Exception as e:
            print(f"✗ {table} — ERROR: {e}")
    else:
        print(f"✗ {table}.csv not found")
conn.close()
print("\nAll done!")
