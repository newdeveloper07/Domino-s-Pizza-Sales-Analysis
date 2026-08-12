DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS pizza_types;



-- 1. Customers
CREATE TABLE customers (
    custid INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(100),
    city VARCHAR(35),
    state VARCHAR(50),
    postal_code VARCHAR(10)
);


-- 2. Pizza Types
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(30) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(30),
    ingredients VARCHAR(255)
);


-- 3. Pizzas
CREATE TABLE pizzas (
    pizza_id VARCHAR(35) PRIMARY KEY,
    pizza_type_id VARCHAR(30) NOT NULL,
    size VARCHAR(10),
    price NUMERIC(8,2),

    FOREIGN KEY (pizza_type_id)
        REFERENCES pizza_types(pizza_type_id)
);


-- 4. Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    custid INT NOT NULL,
    order_date DATE,
    order_time TIME,
    status VARCHAR(30),

    FOREIGN KEY (custid)
        REFERENCES customers(custid)
);


-- 5. Order Details
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(35) NOT NULL,
    quantity INT,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (pizza_id)
        REFERENCES pizzas(pizza_id)
);



SELECT *FROM customers;
SELECT *FROM order_details;
SELECT *FROM orders;
SELECT *FROM pizzas;
SELECT *FROM pizza_types;

SELECT custid, email,
ROW_NUMBER() OVER(PARTITION BY email ORDER BY custid) AS verification
FROM customers;

SELECT custid, email
FROM customers
WHERE email IS NULL;

--check email validation
SELECT email
FROM customers
WHERE email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

SELECT 
    email,
    CASE
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Missing'
        WHEN email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
            THEN 'Invalid'
        ELSE 'Valid'
    END AS email_status
FROM customers;


--check quantity is negative or not
SELECT quantity,
  CASE
     WHEN quantity<0 THEN 'Invalid'
	   ELSE 'VALID'

  END AS quantityStatus
 FROM order_details;

 UPDATE order_details
 SET quantity = 0
 WHERE quantity<0;

--total price of pizzas type
SELECT name,
  ROUND(SUM(price)) AS total_price
  FROM  pizza_types t
  JOIN 
  pizzas p
  ON t.pizza_type_id = p.pizza_type_id
  GROUP BY name;

--1.total number of unique order 
--2.how has this order volume changed month-over-month and year-over-year
--3.can we identify peak and off peak ordering days
--4.how do order volumes vary by day of the weekend
--5.avearge number of orders per customer
--6.who are our top brepeat customers driving the order volume
--7.can you also project the expected order growth trend based on historical data

1.
SELECT order_id,
COUNT(DISTINCT order_id)
FROM orders
GROUP BY order_id;



  


  2.
  WITH monthly_order AS (
     SELECT DATE_TRUNC('month',order_date) as month,
	
 COUNT(order_id) as order_count
 FROM orders
 GROUP BY month

  )
  SELECT month
  order_count,
  LAG(order_count) OVER(ORDER BY month) AS
  prev_month,
 
  ROUND(100.0 *(order_count-LAG(order_count) OVER(ORDER BY month))/NULLIF(LAG(order_count) OVER(ORDER BY month),0),2) mom_groth_percent
  
 
  FROM monthly_order,
  ORDER BY month;
  --or only for monthly count data
       SELECT DATE_TRUNC('month',order_date) as month,
 COUNT(order_id) as order_count
 FROM orders
 GROUP BY month;
--year by
       SELECT DATE_TRUNC('year',order_date) as year,
 COUNT(order_id) as order_count
 FROM orders
 GROUP BY year;

 WITH yearly_order AS(
       SELECT DATE_TRUNC('year',order_date) as year,
 COUNT(order_id) as order_count
 FROM orders
 GROUP BY year

 )
 SELECT year,order_count,
 LAG(order_count) OVER(ORDER BY year) AS prev_year
 FROM yearly_order
 ORDER BY year;
--order day count
SELECT 
TO_CHAR(order_date,'Day') AS  weekend,

COUNT( DISTINCT order_id) AS total_order
FROM orders
GROUP BY weekend;

--by month
SELECT 
TO_CHAR(order_date,'Month') AS monthly_day,
COUNT(DISTINCT order_id) AS total_order
FROM orders
GROUP BY monthly_day;

--average order per customers
SELECT
ROUND(COUNT(DISTINCT order_id) *1.0/
COUNT(DISTINCT custid),2) AS average_order_per_customer
FROM orders;

--top order by customers
SELECT custid,
COUNT(DISTINCT order_id) AS customer_total_order
FROM orders
GROUP BY custid
ORDER BY customer_total_order DESC;

--Running total order
SELECT order_date,
 COUNT(order_id) AS daily_order,
 SUM(COUNT(order_id)) OVER(ORDER BY order_date) AS running_total_order
 FROM orders
 GROUP BY order_date
 ORDER BY order_date;


 --revenue of pizzas selling
 SELECT  SUM(od.quantity *p.price) AS total_revenue FROM
 order_details od
 JOIN
 pizzas p
 ON od.pizza_id = p.pizza_id;

 --CATEGORY BY PRICE
 SELECT pt.name,pt.category,p.size,
 CONCAT('$',p.price ) AS price
 FROM
 pizzas p
 JOIN
 pizza_types pt
 ON pt.pizza_type_id = p.pizza_type_id
 ORDER BY p.price DESC;

 --most common pizza
 SELECT p.size, COUNT(*) AS total_order
 FROM
 order_details od
 JOIN
 pizzas p ON od.pizza_id = p.pizza_id
 JOIN 
 pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY p.size
 ORDER BY total_order DESC;

 --TOP 5 most order pizza_type
 SELECT * FROM pizza_types;
 SELECT *FROM order_details;
 SELECT *FROM pizzas;

 SELECT  pt.pizza_type_id ,SUM(od.quantity) AS pizza_total
 FROM pizzas p
 JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
 JOIN order_details od ON p.pizza_id = od.pizza_id
 GROUP BY pt.pizza_type_id
 ORDER BY pizza_total DESC
 LIMIT 5;


 SELECT  p.pizza_id ,SUM(od.quantity) AS pizza_total
 FROM pizzas p
 JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
 JOIN order_details od ON p.pizza_id = od.pizza_id
 GROUP BY p.pizza_id
 ORDER BY pizza_total DESC
 LIMIT 5;

 --orders by hour of the day
 SELECT 
 TO_CHAR(order_time::time, 'HH24:00') AS order_hour,
 COUNT(*) AS order_count FROM 
 orders
 GROUP  BY order_hour
 ORDER BY order_hour;
 --which category (like veggie,chicken,supreme) dominate our menu
 --sales?can you prepare a breakdown of orders per category with percentage share?



 --average pizza order per day
 SELECT ROUND(AVG(daily_order_total),2 )AS avg_pizzas_per_day FROM
     (SELECT o.order_date, SUM(od.quantity) AS daily_order_total FROM
   orders o
 JOIN 
 order_details od
 ON
 o.order_id = od.order_id
 GROUP BY o.order_date) skv;


 --PIZZAS BY REVENUE
 WITH pizza_revenue AS (
    SELECT pt.name,
	  SUM(od.quantity * p.price) AS revenue,
	  DENSE_RANK() OVER(ORDER BY  SUM(od.quantity * p.price) DESC)
	FROM
	 order_details od
	 JOIN pizzas p ON od.pizza_id = p.pizza_id
	 JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
	 GROUP BY pt.name
	 
 )
 SELECT name,revenue
 FROM pizza_revenue;


--divide revenue of each pizza by total revenue,express in %
SELECT 
 pt.name ,
 CONCAT(
    ROUND(
        100.0 * SUM(od.quantity * p.price)
        / SUM(SUM(od.quantity * p.price)) OVER(),
        2
    ),
    '%'
) AS pct_contribution
 FROM
order_details od
JOIN 
pizzas p ON od.pizza_id = p.pizza_id
JOIN
pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pct_contribution DESC;


 --cummulative trend by order_date
 SELECT order_date, daily_revenue,
 SUM(daily_revenue) OVER(ORDER BY order_date ) AS cummulative_revenue
 FROM
 
 (SELECT o.order_date,
 SUM(od.quantity*p.price) AS daily_revenue
  FROM
 orders o
 JOIN 
 order_details od ON o.order_id = od.order_id
 JOIN
 pizzas p ON  od.pizza_id = p.pizza_id
 GROUP BY o.order_date
 ) t;

 --TOP 3 PIZZAS BY CATEGORY(REVENUE)
 SELECT *FROM pizza_types;
 SELECT pt.name,pt.category,
 SUM(od.quantity *p.price) AS category_revenue,
 RANK()OVER(PARTITION BY pt.category ORDER BY SUM(od.quantity *p.price)) AS rnk
 FROM
 order_details od
 JOIN
 pizzas p ON od.pizza_id = p.pizza_id
 JOIN
 pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY pt.category,pt.name
 ORDER BY rnk
 LIMIT 3;
--category by revenue
 WITH cat_rank AS
 ( 
    SELECT pt.name,pt.category,
 SUM(od.quantity *p.price) AS category_revenue,
 RANK()OVER(PARTITION BY pt.category ORDER BY SUM(od.quantity *p.price) desc) AS rnk
 FROM
 order_details od
 JOIN
 pizzas p ON od.pizza_id = p.pizza_id
 JOIN
 pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY pt.category,pt.name
 

 )
 SELECT category,name,category_revenue
 FROM cat_rank
 WHERE rnk<=3

 --TOP 10 CUSTOMERS BY SPENDING
 SELECT *FROM customers;
 SELECT 
 c.custid ,c.first_name || ' ' || c.last_name AS name,
 SUM (od.quantity * p.price) AS total_revenue
 FROM
 customers c
 JOIN
 orders o ON c.custid = o.custid
 JOIN
 order_details od ON o.order_id = od.order_id
 JOIN
 pizzas p ON od.pizza_id = p.pizza_id
 GROUP BY c.custid,name
 ORDER BY total_revenue DESC;

 --which days of the week are busiest for orders? do customer order more on weekend
 SELECT 
 o.order_date,
 TO_CHAR(o.order_date,'Day') AS week_day,
 SUM(od.quantity) AS total_order FROM
 orders o
 JOIN 
 order_details od ON
 o.order_id = od.order_id
 GROUP BY o.order_date,week_day
 ORDER BY total_order DESC;


 --avg pizza order per size
 SELECT ROUND(AVG(total_quant),0) AS avg_size
 FROM
 (SELECT 
 o.order_id,
 SUM(od.quantity) AS total_quant
 FROM
 orders o
 JOIN 
 order_details od ON o.order_id = od.order_id
 GROUP BY  o.order_id) t;

 --MONTLY SALES
 SELECT EXTRACT(Month FROM order_date) AS month,
 COUNT(*) AS total_orders
 FROM orders
 GROUP BY EXTRACT(Month FROM order_date)
 ORDER BY month;

 --WHAT is the revenue contribution of each pizza size
 SELECT *FROM pizzas;
 SELECT 
 p.size,SUM(od.quantity*p.price) AS revenue, CONCAT(
        ROUND(
            100.0 * SUM(od.quantity * p.price)
            / SUM(SUM(od.quantity * p.price)) OVER(),
            2
        ),
        '%'
    ) AS pct_contribution
 FROM
 order_details od
 JOIN 
 pizzas p ON od.pizza_id = p.pizza_id
 GROUP BY p.size
 ORDER BY revenue DESC;

 --CUSTOMER SPEND BY CLASS
 WITH customer_spend AS(
  SELECT 
  c.custid,
  SUM(od.quantity * p.price) AS revenue
  
  FROM
  customers c
  JOIN 
  orders o ON c.custid = o.custid
  JOIN
  order_details od ON o.order_id = od.order_id
  JOIN 
  pizzas p ON od.pizza_id = p.pizza_id
  GROUP BY c.custid
 )
 SELECT 
  CASE 
    WHEN revenue>100500 THEN 'HIGH VALUE'
	ELSE 'REGULAR'
  END AS segment,
  COUNT(*) AS customer_count
 FROM customer_spend
 GROUP BY segment;


--calculate the % of repeat customers
WITH cust_orders AS
(SELECT custid,COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY custid)
SELECT ROUND(100.0 *SUM(CASE WHEN order_count>1 THEN 1 ELSE 0 END)/COUNT(*),2) AS repeat_rate
FROM cust_orders;









 






