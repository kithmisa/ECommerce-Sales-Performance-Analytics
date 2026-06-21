-- ===================================================================
-- 2. MONTH-OVER-MONTH (MoM) REVENUE GROWTH ANALYSIS
-- Purpose: Track macro sales momentum and growth trends across months
-- ===================================================================

USE EcommerceDB;
GO

WITH MonthlySales AS (
    SELECT 
        -- Format the date into Year-Month string (e.g., '2011-01')
        FORMAT(InvoiceDate, 'yyyy-MM') AS SalesMonth,
        -- Force the raw calculation directly to bypass the column error
        ROUND(SUM(CAST(Quantity AS FLOAT) * CAST(UnitPrice AS FLOAT)), 2) AS CurrentMonthRevenue,
        -- Count unique transactions
        COUNT(DISTINCT InvoiceNo) AS TotalOrders
    FROM 
       data
    GROUP BY 
        FORMAT(InvoiceDate, 'yyyy-MM')
)
SELECT 
    SalesMonth,
    CurrentMonthRevenue,
    TotalOrders,
    -- Fetch the previous month's revenue using LAG
    LAG(CurrentMonthRevenue, 1) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
    -- Calculate the MoM growth percentage
    ROUND(
        ((CurrentMonthRevenue - LAG(CurrentMonthRevenue, 1) OVER (ORDER BY SalesMonth)) 
        / NULLIF(LAG(CurrentMonthRevenue, 1) OVER (ORDER BY SalesMonth), 0)) * 100, 2) AS MoM_Growth_Percent
FROM 
    MonthlySales
ORDER BY 
    SalesMonth;
GO
