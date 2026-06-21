USE EcommerceDB;
GO

WITH ProductRanks AS (
    SELECT 
        StockCode,
        Description,
        -- Force raw calculation directly to prevent alias errors
        ROUND(SUM(CAST(Quantity AS FLOAT) * CAST(UnitPrice AS FLOAT)), 2) AS TotalProductRevenue,
        COUNT(DISTINCT InvoiceNo) AS UniqueTimesPurchased,
        -- Rank products seamlessly without skipping numbers
        DENSE_RANK() OVER (ORDER BY SUM(CAST(Quantity AS FLOAT) * CAST(UnitPrice AS FLOAT)) DESC) AS ProductRank
    FROM 
        data
    GROUP BY 
        StockCode, Description
)
SELECT 
    ProductRank,
    StockCode,
    Description,
    TotalProductRevenue,
    UniqueTimesPurchased
FROM 
    ProductRanks
WHERE 
    ProductRank <= 10
ORDER BY 
    ProductRank;
GO
