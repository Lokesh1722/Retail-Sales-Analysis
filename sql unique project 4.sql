-- SQL Retail Sales Analysis - P4
CREATE DATABASE IF NOT EXISTS sql_project_p4;
USE sql_project_p4;

drop table Product;
-- Create Product Table
CREATE TABLE Product 
(
    transactions_ID INT PRIMARY KEY,
    Category VARCHAR(100),
    COGS DECIMAL(10,2) -- Cost of Goods Sold
);
-- After this you can import Product cleaned.xlsx into this table
SELECT * FROM  Product;

-- Create Customer Table
CREATE TABLE Customer 
(
    Customer_ID INT PRIMARY KEY,
    Gender ENUM('Male','Female','Other'),
    Age INT
);

-- After this you can import Customer cleaned.xlsx into this table
SELECT * FROM  Customer;

-- Create Sales Table
CREATE TABLE Sales 
(
    transactions_ID INT,
    Quantity INT,
    Sale_Date DATE,
    Sale_Time TIME,
    Price_per_unit DECIMAL(10,2),
    Total_Sale DECIMAL(10,2),
    FOREIGN KEY (transactions_ID) REFERENCES Product(transactions_ID),
	FOREIGN KEY (Customer_ID) REFERENCES Product(Customer_ID)
);


-- After this you can import Product cleaned.xlsx into this table
SELECT * FROM  Product;


-- Data Cleaning
SELECT * FROM Product WHERE transactions_id IS NULL;


-- Data Exploration
SELECT COUNT(*) as total_sale FROM Product;
SELECT COUNT(*) as total_sale FROM Customer;
SELECT COUNT(*) as total_sale FROM Sales;
SELECT COUNT(DISTINCT customer_id) as total_customers FROM Customer;
SELECT DISTINCT category FROM Product;

-- -- Data Analysis & Business Key Problems & Answers

-- Q1 What is the total sales amount across all transactions?
SELECT SUM(total_sale) AS total_sales_amount FROM Sales;

-- Q2 How many transactions have been recorded in total Product?
SELECT COUNT(*) AS total_transactions FROM Product;

-- Q3. List all customers above the age of 30.
SELECT * FROM Customer
WHERE Age > 30;


-- Q4. Find the total sales amount by each product category.
SELECT p.Category, SUM(s.Total_Sale) AS Total_Sales
FROM Sales s
JOIN Product p ON s.transactions_ID = p.transactions_ID
GROUP BY p.Category;

-- Q5. Show the top 5 highest-value sales transactions.
SELECT * FROM Sales
ORDER BY Total_Sale DESC
LIMIT 5;

-- Q6. Get the total number of sales made by each gender.
SELECT c.Gender, COUNT(s.transactions_ID) AS Total_Transactions
FROM Sales s
JOIN Customer c ON s.transactions_ID = c.Customer_ID
GROUP BY c.Gender;

-- Q7. Find the average price per unit by product category.
SELECT p.Category, AVG(s.Price_per_unit) AS Avg_Price
FROM Sales s
JOIN Product p ON s.transactions_ID = p.transactions_ID
GROUP BY p.Category;

-- Q8. Show sales trends by date (total sale per day).
SELECT Sale_Date, SUM(Total_Sale) AS Daily_Total
FROM Sales
GROUP BY Sale_Date
ORDER BY Sale_Date;

-- Q9. Find the peak sale time (hour of the day with most sales).
SELECT HOUR(Sale_Time) AS Hour_Of_Day, SUM(Total_Sale) AS Total_Sales
FROM Sales
GROUP BY HOUR(Sale_Time)
ORDER BY Total_Sales DESC;

-- Q10 What is the average age of customers broken down by gender (ignoring any records with missing age data)?
SELECT Gender, AVG(Age) AS Avg_Age
FROM  Customer
WHERE Age IS NOT NULL
GROUP BY Gender;


-- --Q11 What are the monthly sales totals for the years 2024 and 2025?
SELECT YEAR(sale_date) AS year, MONTH(sale_date) AS month, SUM(total_sale) AS monthly_sales
FROM Sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;


-- Q12 What is the average number of items sold per transaction?
SELECT AVG(quantity) AS avg_quantity_per_transaction
FROM Sales;


-- Q13 How many unique customers have made purchases?
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM Customer;

-- Q14  What is the total sales amount for the period from July 1, 2024, to September 30, 2024?
SELECT SUM(Total_Sale) AS Total_sales_in_2024
FROM Sales
WHERE Sale_Date BETWEEN '2024-07-01' AND '2024-09-30';

-- --> End of Project