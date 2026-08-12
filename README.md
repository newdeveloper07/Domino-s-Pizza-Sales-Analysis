# 🍕 Domino's Pizza Sales Analysis

## 📌 Project Overview

This project analyzes **Domino's pizza sales data using PostgreSQL and SQL** to extract meaningful business insights from customer, order, pizza, and transaction data.

The project focuses on understanding **sales performance, revenue contribution, customer behavior, pizza popularity, order trends, and product performance** using SQL queries.

---

## 🎯 Project Objectives

The main objectives of this project are:

* Analyze overall pizza sales performance
* Calculate total revenue generated
* Identify the most popular pizzas
* Analyze revenue by pizza size
* Identify the best-performing pizza categories
* Analyze customer ordering behavior
* Calculate total orders and pizzas sold
* Identify top-performing pizzas
* Analyze daily and monthly order trends
* Generate actionable business insights using SQL

---

## 🗃️ Dataset

The project contains the following datasets:

### 👥 Customers

Contains information about customers.

| Column        | Description           |
| ------------- | --------------------- |
| `custid`      | Unique customer ID    |
| `first_name`  | Customer first name   |
| `last_name`   | Customer last name    |
| `email`       | Customer email        |
| `phone`       | Customer phone number |
| `address`     | Customer address      |
| `city`        | Customer city         |
| `state`       | Customer state        |
| `postal_code` | Customer postal code  |

### 🧾 Orders

Contains information about customer orders.

| Column       | Description     |
| ------------ | --------------- |
| `order_id`   | Unique order ID |
| `custid`     | Customer ID     |
| `order_date` | Date of order   |
| `order_time` | Time of order   |

### 🍕 Order Details

Contains individual pizza items included in each order.

| Column             | Description            |
| ------------------ | ---------------------- |
| `order_details_id` | Unique order-detail ID |
| `order_id`         | Order ID               |
| `pizza_id`         | Pizza ID               |
| `quantity`         | Quantity ordered       |

### 🍕 Pizza Types

Contains information about pizza names, categories, and ingredients.

| Column          | Description          |
| --------------- | -------------------- |
| `pizza_type_id` | Unique pizza type ID |
| `name`          | Pizza name           |
| `category`      | Pizza category       |
| `ingredients`   | Pizza ingredients    |

### 💰 Pizzas

Contains pizza size and pricing information.

| Column          | Description     |
| --------------- | --------------- |
| `pizza_id`      | Unique pizza ID |
| `pizza_type_id` | Pizza type ID   |
| `size`          | Pizza size      |
| `price`         | Pizza price     |

---

## 📁 Project Structure

```text
dominos-pizza-sales-analysis/
│
├── data/
│   ├── customers.csv
│   ├── order_details.csv
│   ├── orders.csv
│   ├── pizza_types.csv
│   └── pizzas.csv
│
├── sql/
│   ├── dominos_analysis.sql
│   └── relation_btw_tables.png
│
└── README.md
```

### 📂 Folder Description

#### `data/`

Contains the raw CSV datasets used in the project.

* `customers.csv` — Customer information
* `orders.csv` — Order information
* `order_details.csv` — Order and pizza quantity details
* `pizza_types.csv` — Pizza names, categories, and ingredients
* `pizzas.csv` — Pizza sizes and prices

#### `sql/`

Contains the SQL analysis and database relationship diagram.

* `dominos_analysis.sql` — PostgreSQL queries used for data analysis
* `relation_btw_tables.png` — Database table relationship diagram

#### `README.md`

Contains the documentation for the project, including objectives, dataset information, SQL concepts, analysis questions, and business insights.

---

## 🛠️ Tools & Technologies

* **PostgreSQL**
* **SQL**
* **Git**
* **GitHub**
* **VS Code**
* **pgAdmin**

---

## 🧠 SQL Concepts Used

This project demonstrates practical SQL concepts including:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `INNER JOIN`
* `LEFT JOIN`
* Aggregate Functions
* Subqueries
* Common Table Expressions (`CTE`)
* Window Functions
* `ROW_NUMBER()`
* `LAG()`
* `DATE_TRUNC()`
* `CASE`
* `SUM()`
* `COUNT()`
* `AVG()`
* `MAX()`
* `MIN()`

---

## 📊 Business Questions

The analysis answers several important business questions:

1. What is the total number of orders?
2. What is the total quantity of pizzas sold?
3. What is the total revenue generated?
4. What is the average order value?
5. Which pizza is the most popular?
6. Which pizza generates the highest revenue?
7. What is the revenue contribution of each pizza size?
8. Which pizza category generates the highest revenue?
9. What are the top 10 best-selling pizzas?
10. Which days have the highest number of orders?
11. What are the monthly sales trends?
12. Which customers place the most orders?
13. Which customers generate the highest revenue?
14. What is the average number of pizzas per order?
15. Which pizza sizes are ordered most frequently?

---

## 💰 Revenue Analysis

Revenue is calculated using:

```text
Revenue = Quantity × Pizza Price
```

Example SQL query:

```sql
SELECT
    p.size,
    SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;
```

This analysis helps determine how much revenue is generated by each pizza size.

---

## 🔗 Database Relationships

The project uses a relational database structure connecting customers, orders, order details, pizzas, and pizza types.

The relationship diagram is available here:

```text
sql/relation_btw_tables.png
```

The main relationships are:

```text
Customers
    │
    │ custid
    ▼
Orders
    │
    │ order_id
    ▼
Order Details
    │
    │ pizza_id
    ▼
Pizzas
    │
    │ pizza_type_id
    ▼
Pizza Types
```

---

## 🔍 Project Workflow

```text
Raw CSV Data
      ↓
Data Validation & Cleaning
      ↓
PostgreSQL Database
      ↓
Table Relationships
      ↓
SQL Queries
      ↓
Data Analysis
      ↓
Business Insights
```

---

## 📈 Key Analysis Areas

### 1. Sales Analysis

Analyze:

* Total orders
* Total pizzas sold
* Total revenue
* Average order value

### 2. Product Analysis

Identify:

* Best-selling pizzas
* Highest-revenue pizzas
* Popular pizza sizes
* Top pizza categories

### 3. Customer Analysis

Analyze:

* Most frequent customers
* Highest-spending customers
* Customer order behavior

### 4. Time-Based Analysis

Analyze:

* Daily order trends
* Monthly order trends
* Revenue trends over time
* Peak ordering periods

---

## 💡 Business Insights

The analysis can help answer questions such as:

* Which pizza sizes contribute the most revenue?
* Which pizzas should receive more promotional attention?
* Which pizza categories are most profitable?
* When do customers place the most orders?
* Which customers contribute the most revenue?
* Which products have high sales volume?
* Which products may require inventory planning?

These insights can support:

* **Menu optimization**
* **Marketing campaigns**
* **Inventory management**
* **Sales planning**
* **Customer targeting**
* **Revenue optimization**

---

## 🚀 How to Run the Project

### Step 1: Install PostgreSQL

Install PostgreSQL and pgAdmin on your system.

### Step 2: Create the Database

Create a database:

```sql
CREATE DATABASE dominos_pizza_store;
```

### Step 3: Create the Tables

Open:

```text
sql/dominos_analysis.sql
```

Run the table creation queries in PostgreSQL.

### Step 4: Import the CSV Files

Import the files from the `data/` folder into their respective PostgreSQL tables.

### Step 5: Run the SQL Analysis

Execute the analysis queries from:

```text
sql/dominos_analysis.sql
```

Review the query results and extract business insights.

---

## 📌 Skills Demonstrated

This project demonstrates practical skills in:

* SQL Data Analysis
* PostgreSQL
* Relational Database Design
* Data Cleaning
* Data Validation
* Data Transformation
* Complex SQL Joins
* Aggregation & Grouping
* Subqueries
* CTEs
* Window Functions
* Time-Series Analysis
* Business Analysis
* Data-Driven Decision Making

---

## 👨‍💻 Author

**Sahil Kumar Vishvas**

B.Tech Computer Science & Engineering

This project was created as a **SQL/Data Analytics portfolio project** to demonstrate practical PostgreSQL, SQL, and business analysis skills.

---

## ⭐ Project Goal

The goal of this project is to demonstrate how **SQL can transform raw transactional data into meaningful business insights** that can support better business decisions.

If you find this project useful, consider giving the repository a ⭐ on GitHub.
