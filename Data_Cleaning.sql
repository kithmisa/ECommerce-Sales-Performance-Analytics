USE EcommerceDB;
GO


SELECT  * 
FROM data;



-- Create a clean analysis table 
SELECT 
    InvoiceNo,
    StockCode,
    Description,
    CAST(Quantity AS INT) AS Quantity,
    -- Converts the Kaggle date text format to an official, usable DateTime type
    TRY_CAST(InvoiceDate AS DATETIME) AS InvoiceDate,
    CAST(UnitPrice AS FLOAT) AS UnitPrice,
    CustomerID,
    Country,
    -- Calculate total sales revenue per line item
    (CAST(Quantity AS FLOAT) * CAST(UnitPrice AS FLOAT)) AS TotalSales
INTO cleaned_retail_data
FROM 
   data
WHERE 
    CustomerID IS NOT NULL        -- Removes anonymous traffic
    AND Quantity > 0              -- Filters out canceled/returned orders
    AND UnitPrice > 0;            -- Removes free samples or system errors
GO
