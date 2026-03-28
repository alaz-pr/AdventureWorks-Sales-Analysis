# AdventureWorks Sales Performance Analysis

🔗 **[View the Live Dashboard on Tableau Public](https://public.tableau.com/views/AdventureWorksSalesPerformanceDashboard_17747083501450/Dashboard1)**

---

## Executive Summary

This project analyzes sales performance for Adventure Works Cycles using three years of transactional data (June 2022 to September 2024). Starting from raw CSV files, I built a complete workflow covering data ingestion, database setup, SQL analysis, customer segmentation, and an interactive Tableau dashboard.

The analysis shows strong overall growth, but also highlights clear concentration risks. Revenue increased by 264% over the period, with Bikes accounting for 86% of total product revenue. Customer spend is similarly concentrated, with a small group of high-value customers driving most of the revenue.

The dashboard allows stakeholders to explore these patterns across products, regions, and sales channels, and quickly identify where performance is strong or lagging.

**Note on revenue metrics:**  
Two revenue measures are used depending on context. **Line Total** ($109.8M) reflects product revenue and is used for product and territory analysis. **Total Due** ($123.2M) includes tax and shipping and is used for customer-level analysis.

---

## Business Questions

- How is revenue evolving over time, and where are the seasonal peaks?  
- Which product categories and subcategories drive revenue?  
- Who are the most valuable customers, and which segments show risk?  
- Which territories over- or underperform relative to the average?  
- How does sales performance vary across representatives?  

---

## Methodology

**1. Data Ingestion**  
Imported ten AdventureWorks tables from CSV into a SQLite database using Python. The pipeline handles encoding issues and validates row counts to ensure data integrity.

**2. Data Preparation**  
Built a master table (`aw_master.csv`) by joining Sales, Product, and Territory data in SQL. This simplifies analysis and avoids duplication issues in Tableau.

**3. SQL Analysis**  
Developed five SQL scripts covering revenue trends, product performance, customer segmentation, sales rep performance, and territory analysis.

**4. RFM Segmentation**  
Scored customers on Recency, Frequency, and Monetary value using quartiles, then mapped them into business segments using CASE logic.

**5. Dashboard**  
Built a Tableau dashboard with cross-filtering, trend lines, and a global channel filter to support interactive analysis.


---

## Skills

**SQL**
- Window functions for ranking, growth analysis, and segmentation  
- CTEs for structuring multi-step queries  
- Complex joins across multiple tables  
- CASE statements for business logic  
- Date functions for time-based aggregation  

**Python**
- pandas for ingestion, cleaning, and exporting  
- sqlite3 for database setup and queries  
- Scripted data pipeline from raw files to analysis-ready datasets  

**Tableau**
- Data modeling with multiple sources  
- Calculated fields for classification and formatting  
- Dashboard actions and cross-filtering  
- Trend and reference lines for analysis  

---

## Results and Business Recommendations

**Revenue Growth**  
Monthly revenue grew from $1.4M to $5.1M, with a consistent upward trend and clear seasonal peaks in late spring and early summer.

**Product Mix**  
Bikes generate 86% of total revenue, indicating strong dependence on a single category.

**Customer Segmentation**  
A small group of high-value customers drives the majority of revenue, while most segments contribute marginally.

**Territory Performance**  
Southwest, Canada, and Northwest lead in revenue share. Germany and the Northeast underperform relative to the overall average.

**Sales Rep Performance**  
Top performers generate more than three times the revenue of the lowest performers, indicating uneven performance across the team.

**Recommendations**
- Prioritize retention of high-value customers due to revenue concentration  
- Expand lower-performing product categories through targeted upselling  
- Investigate underperformance in Germany and the Northeast  
- Standardize best practices based on top-performing sales reps  
- Align campaigns with seasonal demand peaks  

---

## Next Steps

- Extend the dataset with more recent data  
- Add a forecasting layer to project revenue trends  
- Track retention of high-value customers over time  
- Rebuild the dashboard in Power BI for comparison  
- Incorporate HR data to analyze sales performance in more detail  

---

## How to Reproduce

1. Clone the repository  
2. Download the AdventureWorks CSV files  
3. Run `import_data.py`  
4. Run `build_master.py`  
5. Run `export_rfm.py`  
6. Execute SQL queries in SQLite  
7. Connect outputs in Tableau to rebuild the dashboard  

---

*Dataset © Microsoft, licensed under MIT.*
