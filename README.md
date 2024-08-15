# Supermarket Sales Analysis

## Overview

This project involves analyzing a supermarket's sales data to draw insights and help stakeholders make informed decisions. The data covers the first week of the first and last quarters of the year 2000. The goal is to answer specific business questions using SQL queries, uncover patterns, and provide actionable insights. 

## Skills and Technologies Used

### Skills
- **SQL**: Used for data querying, data manipulation, and generating insights.
- **Data Analysis**: Techniques applied to interpret the dataset and derive actionable insights.
- **Problem Solving**: Breaking down business questions into SQL queries to find the answers.

### Technologies
- **Microsoft SQL Server (MSSQL)**: The database management system used for storing and querying the data.
- **Flat File (CSV)**: The original dataset was provided as a CSV file.
- **MSSQL Management Studio (SSMS)**: The IDE used for managing and querying the database.

## Database Creation and Setup

### Step 1: Creating the Database
First, a new database called `supermarket` was created to store all the necessary tables and data.

```sql
CREATE DATABASE supermarket;
```

### Step 2: Importing Data from CSV to Create `salesinfo` Table
The stakeholders provided a CSV file named "Local Sales," which was imported into the database to create the `salesinfo` table.

```sql
-- Import the CSV data into a table called salesinfo
CREATE TABLE salesinfo (
    Purchase_Id INT PRIMARY KEY,
    Customer VARCHAR(50),
    Date_of_Purchase DATE,
    Day_of_Purchase VARCHAR(10),
    Total_Fruits INT,
    Fruit_1 VARCHAR(50),
    Fruit_2 VARCHAR(50),
    Fruit_3 VARCHAR(50),
    Fruit_4 VARCHAR(50)
);

-- Bulk insert or import the data from the CSV into the salesinfo table
-- (Note: This step may require using the Import/Export Wizard in SSMS or a BULK INSERT statement)
```

### Step 3: Creating the `gender` Table and Establishing a Relationship
A new table called `gender` was created to store the gender of customers. A foreign key relationship was established between the `salesinfo.customer` and `gender.customer_name` columns to link the two tables.

```sql
CREATE TABLE gender (
    Customer_Name VARCHAR(50) PRIMARY KEY,
    Gender VARCHAR(10)
);

-- Insert customer names and their respective genders
INSERT INTO gender (Customer_Name, Gender)
VALUES
    ('Esther', 'Female'),
    ('Hauwa', 'Female'),
    ('Isaac', 'Male'),
    ('Jamie', 'Male'),
    ('Jerry', 'Male'),
    ('Joe', 'Male'),
    ('Juliet', 'Female'),
    ('Pauline', 'Female'),
    ('Philip', 'Male'),
    ('Ralph', 'Male'),
    ('Sam', 'Male'); -- Corrected name and gender
```

## SQL Analysis and Insights

### 1. Who Bought the Most Fruits?
```sql
SELECT Customer, SUM(Total_Fruits) AS num_fruits
FROM salesinfo
GROUP BY Customer
ORDER BY num_fruits DESC;
```
**Insight**: Hauwa is the top buyer with a total of 2,624 fruits purchased.

### 2. How Many People Purchased Fruits?
```sql
SELECT COUNT(DISTINCT Purchase_Id) AS num_people_purchase
FROM salesinfo;
```
**Insight**: 1,999 people made fruit purchases.

### 3. Which Fruits Were Purchased Only as `Fruit_4`?
```sql
SELECT DISTINCT Fruit_4
FROM salesinfo;
```
**Insight**: Fruits such as Tangerine, Pineapple, Pawpaw, and Apple were purchased only in the `Fruit_4` shelf.

### 4. Best Day for a Bonanza
```sql
SELECT Day_of_Purchase, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
GROUP BY Day_of_Purchase
ORDER BY total_fruits DESC;
```
**Insight**: Thursday had the highest sales, suggesting a bonanza should be on Sunday to boost sales.

### 5. Second Most Purchased `Fruit_3` in the Last Quarter
```sql
WITH cte AS (
    SELECT Fruit_3, SUM(Total_Fruits) AS total_fruits,
    ROW_NUMBER() OVER (ORDER BY SUM(Total_Fruits) DESC) AS fruit_rank
    FROM salesinfo
    WHERE DATEPART(QUARTER, Date_of_Purchase) = 4
    GROUP BY Fruit_3
)
SELECT Fruit_3, total_fruits
FROM cte
WHERE fruit_rank = 2;
```
**Insight**: Strawberry was the second most purchased fruit in the last quarter as `Fruit_3`.

### 6. Month with Most Purchases (To Avoid Waste)
```sql
SELECT DATEPART(MONTH, Date_of_Purchase) AS Month, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
GROUP BY DATEPART(MONTH, Date_of_Purchase)
ORDER BY total_fruits DESC;
```
**Insight**: March had the most fruit purchases, indicating the need for stock adjustments in the first few days.

### 7. Count of Purchases Containing "Apple"
```sql
SELECT COUNT(*) AS num_apple
FROM salesinfo
WHERE Fruit_1 LIKE '%Apple%' OR Fruit_2 LIKE '%Apple%' OR Fruit_3 LIKE '%Apple%' OR Fruit_4 LIKE '%Apple%';
```
**Insight**: The word "Apple" appeared in 1,561 purchases.

### 8. Did Jamie Lie About Buying More Fruits Than Ralph on Weekends?
```sql
WITH cte AS (
    SELECT Customer, SUM(Total_Fruits) AS total_fruits
    FROM salesinfo
    WHERE Customer IN ('Jamie', 'Ralph') AND DATEPART(QUARTER, Date_of_Purchase) = 1 AND Day_of_Purchase IN ('Sat', 'Sun')
    GROUP BY Customer
)
SELECT Customer, total_fruits
FROM cte
ORDER BY total_fruits DESC;
```
**Insight**: Jamie lied; Ralph purchased more fruits (315) than Jamie (293) on weekends.

### 9. Average Number of Fruits Sold Daily in October
```sql
SELECT Day_of_Purchase, AVG(Total_Fruits) AS avg_no_fruits
FROM salesinfo
WHERE Date_of_Purchase BETWEEN '2000-10-01' AND '2000-10-31'
GROUP BY Day_of_Purchase
ORDER BY avg_no_fruits DESC;
```
**Insight**: Analysis showed correct SQL syntax for calculating daily averages in October.

### 10. Highest Purchasing Customer on Each Day
```sql
WITH cte AS (
    SELECT Day_of_Purchase, Customer, SUM(Total_Fruits) AS total_fruits,
    RANK() OVER (PARTITION BY Day_of_Purchase ORDER BY SUM(Total_Fruits) DESC) AS fruit_order_rank
    FROM salesinfo
    GROUP BY Day_of_Purchase, Customer
)
SELECT Day_of_Purchase, total_fruits AS Total_Fruits, Customer
FROM cte
WHERE fruit_order_rank = 1;
```
**Insight**: Displays the top customer by fruit purchases for each day.

### 11. Number of Purchases (Excluding "Joe")
```sql
SELECT Customer, COUNT(Day_of_Purchase) AS num_purchase
FROM salesinfo
WHERE Customer != 'Joe'
GROUP BY Customer;
```
**Insight**: Lists the number of purchases by each customer, excluding "Joe".

## Further Analysis on Gender-Based Purchases

### 1. Gender with More Total Purchases
```sql
SELECT Gender, SUM(Total_Fruits) AS total_fruits
FROM salesinfo s
INNER JOIN gender g ON s.Customer = g.Customer_Name
GROUP BY Gender;
```
**Insight**: Males purchased more fruits (11,642) compared to females (9,752).

### 2. Likely Gender to Purchase on Tuesday
```sql
SELECT Gender, SUM(Total_Fruits) AS total_fruits
FROM salesinfo s
INNER JOIN gender g ON g.Customer_Name = s.Customer
WHERE Day_of_Purchase = 'Tue'
GROUP BY Gender;
```
**Insight**: Females are more likely to purchase fruits on Tuesday.

## Conclusion

This analysis provided key insights into customer behavior and sales patterns for the supermarket, such as identifying top customers, the most popular days and fruits, and gender-based purchasing trends. The stakeholders can use these insights to make data-driven decisions, such as planning promotions, managing inventory, and targeting specific customer segments.

## Acknowledgments

- Special thanks to the supermarket stakeholders for providing the dataset and the opportunity to conduct this analysis.
- All analyses were conducted using Microsoft SQL Server and SQL queries were crafted to answer the business questions effectively.

---

This README file serves as comprehensive documentation for the work done on the supermarket dataset.
