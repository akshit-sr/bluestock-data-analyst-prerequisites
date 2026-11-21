-- PostgreSQL: create tables and load the cleaned data.
-- Run from the project folder:  psql -U postgres -d postgres -f sql/schema.sql
DROP TABLE IF EXISTS sales, products;

CREATE TABLE sales (
    row_id INT PRIMARY KEY, order_id INT, order_date DATE, order_priority TEXT, quantity INT,
    sales NUMERIC, discount NUMERIC, ship_mode TEXT, profit NUMERIC, unit_price NUMERIC,
    shipping_cost NUMERIC, customer_name TEXT, province TEXT, region TEXT, segment TEXT,
    category TEXT, sub_category TEXT, product_name TEXT, container TEXT, base_margin NUMERIC,
    ship_date DATE, ship_days INT, is_outlier BOOLEAN, year INT, month TEXT
);
\copy sales FROM 'data/cleaned_sales.csv' CSV HEADER

-- Product master derived from the sales lines (used for JOIN practice)
CREATE TABLE products AS
SELECT DISTINCT product_name, category, sub_category, container FROM sales;
