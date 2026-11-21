-- Week 1 SQL practice on Superstore Sales: customer orders, revenue, product performance (PostgreSQL)

-- 1. SELECT + WHERE + ORDER BY: 10 biggest Technology order lines in 2012
SELECT order_id, order_date, customer_name, product_name, sales, profit
FROM sales
WHERE category = 'Technology' AND year = 2012
ORDER BY sales DESC
LIMIT 10;

-- 2. Aggregate functions: overall KPIs
SELECT COUNT(DISTINCT order_id) AS orders, SUM(sales) AS total_sales, SUM(profit) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct, SUM(quantity) AS units,
       COUNT(DISTINCT customer_name) AS customers
FROM sales;

-- 3. GROUP BY: sales, profit and margin by category
SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 4. GROUP BY + HAVING: loss-making sub-categories
SELECT sub_category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- 5. Monthly sales trend
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, SUM(sales) AS total_sales
FROM sales
GROUP BY 1
ORDER BY 1;

-- 6. JOIN: top 10 products by profit with their category from the product master
SELECT p.product_name, p.category, p.sub_category, SUM(s.quantity) AS units, SUM(s.profit) AS total_profit
FROM sales s
JOIN products p ON p.product_name = s.product_name
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_profit DESC
LIMIT 10;

-- 7. Customer orders: top 10 customers by sales
SELECT customer_name, COUNT(DISTINCT order_id) AS orders, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 8. Subquery: how many customers spend more than the average customer
SELECT COUNT(*) AS above_avg_customers
FROM (SELECT customer_name, SUM(sales) AS spent FROM sales GROUP BY customer_name) c
WHERE spent > (SELECT AVG(spent) FROM (SELECT SUM(sales) AS spent FROM sales GROUP BY customer_name) t);

-- 9. Subquery: orders whose value is above the average order value
SELECT order_id, customer_name, order_total
FROM (SELECT order_id, MIN(customer_name) AS customer_name, SUM(sales) AS order_total FROM sales GROUP BY order_id) o
WHERE order_total > (SELECT SUM(sales) / COUNT(DISTINCT order_id) FROM sales)
ORDER BY order_total DESC
LIMIT 20;

-- 10. Window function: rank sub-categories by sales within each category
SELECT category, sub_category, total_sales,
       RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category
FROM (SELECT category, sub_category, SUM(sales) AS total_sales FROM sales GROUP BY category, sub_category) t
ORDER BY category, rank_in_category;

-- 11. Window function: running total of monthly sales
SELECT month, monthly_sales, SUM(monthly_sales) OVER (ORDER BY month) AS running_total
FROM (SELECT month, SUM(sales) AS monthly_sales FROM sales GROUP BY month) t
ORDER BY month;

-- 12. Window function: top 3 customers per region
SELECT * FROM (
    SELECT region, customer_name, SUM(sales) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rn
    FROM sales
    GROUP BY region, customer_name
) t
WHERE rn <= 3
ORDER BY region, rn;

-- 13. Window function: year-over-year sales growth
SELECT year, total_sales,
       ROUND((total_sales - LAG(total_sales) OVER (ORDER BY year)) / LAG(total_sales) OVER (ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM (SELECT year, SUM(sales) AS total_sales FROM sales GROUP BY year) t
ORDER BY year;
