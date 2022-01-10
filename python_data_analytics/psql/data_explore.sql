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
-- Note: negative amount refers to negative `quantity` column
SELECT AVG(quantity)
FROM retail
WHERE quantity > 0;

SELECT invoice_no, AVG(quantity)
FROM retail
GROUP BY invoice_no
HAVING AVG(quantity) > 0;

CREATE VIEW sample AS
SELECT invoice_no, COUNT(invoice_no)
from retail
GROUP BY invoice_no
HAVING MIN(quantity) > 0;

SELECT AVG(sample.count) FROM sample;

-- 7. Calculate total revenue (e.g. sum of unit_price * quantity)
-- 8. Calculate total revenue by YYYYMM