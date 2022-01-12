-- Show table schema 
\d+ retail;

-- 1. Show first 10 rows
SELECT * FROM retail
LIMIT 10;

-- 2. Check # of records
SELECT COUNT(*) FROM retail;

-- 3. Number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT customer_id) FROM retail;

-- Note: COUNT function in PSQL counts non-null values in the column
-- additionally DISTINCT counts unique values in the column

-- 4. Invoice date range (e.g. max/min dates)
SELECT MAX(public.retail.invoice_date) as max,
       MIN(invoice_date) as min
FROM retail;

-- 5. Number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(DISTINCT stock_code)
FROM retail;

-- 6. Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled
-- orders have negative amount)
-- Note: amount refers to quantity * unit_price
-- 1. Calculate amount first
-- 2. Filter out negative amounts
-- 3. Take the average of the amounts

CREATE VIEW amount_table AS
SELECT invoice_no, SUM(quantity * unit_price) AS amount
FROM retail
GROUP BY invoice_no
HAVING SUM(quantity * unit_price) > 0;

SELECT AVG(amount) FROM amount_table;

-- 7. Calculate total revenue (e.g. sum of unit_price * quantity)
CREATE VIEW total_rev_table AS
SELECT invoice_no, SUM(quantity * unit_price) AS amount
FROM retail
GROUP BY invoice_no;

SELECT SUM(amount) FROM total_rev_table;

-- 8. Calculate total revenue by YYYYMM
CREATE VIEW total_rev_table2 AS
SELECT EXTRACT(YEAR FROM invoice_date) AS year,
       EXTRACT(MONTH FROM invoice_date) AS month,
       SUM(quantity * unit_price) AS sum
FROM retail
GROUP BY year, month
ORDER BY year, month;

SELECT ((year * 1000) + month) AS yyyymm, sum
FROM total_rev_table2;