
--As a part-time data analyst you are called in by the stakeholders of a supermarket, they have a dataset taking from the first week of the first and last quarter of the year 2000, they want to see how capable you are to draw insights from the data. 

--They send you the CSV file called "Local Sales" so you look through it then you get started 
--You create a table with the code below!

CREATE DATABASE supermarket

SELECT*
FROM salesinfo;


-- Which person bought the most fruits over the entire period?
SELECT customer, SUM(total_fruits) AS num_fruits
FROM salesinfo
GROUP BY customer
HAVING SUM(total_fruits) > 1
ORDER BY num_fruits DESC;

-- Insight: Hauwa is the person with the most fruits purchased with a total fruits of 2624 while the least is Isaac with a total fruits of 7

-- How many people purchased fruits?

SELECT COUNT(DISTINCT Purchase_Id) AS num_people_purchase
FROM salesinfo;

-- Insight: We have 1999 people that purchased fruits

-- Which of these fruits was purchased only in the Fruit_4?

SELECT DISTINCT fruit_4
FROM salesinfo;

-- Insight: Tangerine, Pineapple, Pawpaw, Apple, Orange, Papaya, and Guava where the only fruits purchase in fruit_4 shelf.

-- The supermarket is planning to throw a bonanza day, and they need to know the best day for it, a day when 
-- their sales are highest so which day do you think is best as analyst.
SELECT Day_of_Purchase, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
GROUP BY Day_of_Purchase
ORDER BY total_fruits DESC;

-- Insight: Thursday has the highest sales of fruits purchased, so a bonanza should be thrown on Sundays to increase sales on that day.

-- Which fruits were purchased the second most as Fruit_3 choice in the last quarter of the year?
SELECT Fruit_3, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
WHERE DATEPART(QUARTER, Date_of_Purchase) = 4
GROUP BY Fruit_3
ORDER BY total_fruits DESC;

-- OR

WITH cte AS (
    SELECT Fruit_3, SUM(Total_Fruits) AS total_fruits, ROW_NUMBER() OVER (ORDER BY SUM(Total_Fruits) DESC) AS fruit_rank
    FROM salesinfo
    WHERE DATEPART(QUARTER, Date_of_Purchase) = 4 
    GROUP BY Fruit_3
)
SELECT cte.Fruit_3, cte.total_fruits
FROM cte
ORDER BY cte.total_fruits DESC;


-- Insight: Strawberry was the second most purchased fruits in the last quarter of the year

-- Which month from your analysis should more goods be stocked for in order to avoid waste in the first few days ?
-- (Hint : Month with most Total_Fruit )

SELECT DATEPART(MONTH, Date_of_Purchase) AS Month, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
GROUP BY DATEPART(MONTH, Date_of_Purchase)
ORDER BY total_fruits DESC;

-- Insight: The month of March should be stocked more with goods to avoid waste in the first few days as it is the month 
-- with the most fruits purchased.

-- How many times were mixtures of the Four choices with the word “apple” bought 
-- (Hint: apple can be a word or a fruit, think carefully when applying your clauses)


SELECT COUNT(*) AS num_apple
FROM salesinfo
WHERE Fruit_1 LIKE '%Apple%' OR Fruit_2 LIKE '%Apple%' OR Fruit_3 LIKE '%Apple%' OR Fruit_4 LIKE '%Apple%';

-- Insight: The number of time the mixture of the four choices with the word "apple' was bought is 1561

-- Jamie told Ralph that he bought more fruits than him over the weekend in the first quarter. From your analysis did Jamie tell a lie ?

SELECT Customer, SUM(Total_Fruits) AS total_fruits
FROM salesinfo
WHERE Customer IN ('Jamie', 'Ralph') AND DATEPART(QUARTER, Date_of_Purchase) = 1 AND Day_of_Purchase IN ('Sat', 'Sun')
GROUP BY Customer
ORDER BY total_fruits DESC;

-- OR

WITH cte AS (
	SELECT Customer, SUM(Total_Fruits) AS total_fruits,
	ROW_NUMBER() OVER(ORDER BY SUM(Total_Fruits) DESC) AS fruit_rank
	FROM salesinfo
	WHERE Customer IN ('Jamie', 'Ralph') AND DATEPART(QUARTER, Date_of_Purchase) = 1 AND Day_of_Purchase IN ('Sat', 'Sun')
	GROUP BY Customer
)
SELECT cte.Customer, cte.total_fruits
FROM cte
ORDER BY cte.total_fruits DESC;

-- Insight: From the analysis, it is seen that Jamie told a lie because the total number of fruits purchased by Jamie in Weekends is 293
--			while that of Ralph is 315.

-- As the Supermarket's data analyst you run the code above to extract the average number of fruits sold in each sale every day of the week
-- in October, but you get errors. How many mistakes do you notice?

--SELECT Day_of_Purchase, AVG(Total_Fruits) AS avg_no_fruits
--FROM salesinfo
--WHERE Date_of_Purchase >=  '2000-09-01' AND Date_of_Purchase = '2000-10-08';
--GROUP BY Day_of_Purchase;

SELECT Day_of_Purchase, AVG(Total_Fruits) AS avg_no_fruits
FROM salesinfo
WHERE Date_of_Purchase BETWEEN  '2000-10-01' AND '2000-10-31'
GROUP BY Day_of_Purchase
ORDER BY avg_no_fruits DESC;

-- Insight: From the analysis, it is observed that there was a semicolon after the date, the date range is wrong, the operator used is wrong,
-- no predicate used like BETWEEN, no sorting was done, and the semicolon should be after the query. In total, we have six mistakes.

-- The Supermarket feels the data set contains too much unnecessary information, they just need to see a few columns on display 
-- Day_Of_Purchase, Total_Fruits and the highest purchasing customer on each day. 
-- You use the Select Clause to type some code and get the image below.


WITH cte AS (
	SELECT Day_of_Purchase, Customer, SUM(Total_Fruits) AS total_fruits, 
		RANK() OVER (PARTITION BY Day_of_Purchase ORDER BY SUM(Total_Fruits) DESC) AS fruit_order_rank
	FROM salesinfo
	GROUP BY Day_of_Purchase, Customer
)
SELECT cte.Day_of_Purchase, cte.total_fruits AS Total_Fruits, cte.Customer
FROM cte
WHERE cte.fruit_order_rank =1;

-- What is the average number of fruits sold everyday approximately ?  (Hint: there are 42 days) 

SELECT AVG(total_fruits) AS avg_fruits
FROM (
	SELECT Day_of_Purchase, SUM(Total_Fruits) AS total_fruits
	FROM salesinfo
	GROUP BY Day_of_Purchase
) AS daily_total;


-- Fetch the number of purchase by customer except for purchases made by 'Joe'
SELECT Customer, COUNT(Day_of_Purchase) AS num_purchase
FROM salesinfo
WHERE Customer !='Joe'
GROUP BY Customer;

--HAPPY CUSTOMER BUT MORE WORK
--After everything the supermarket stakeholders are elated with your work, they've gotten some useful insight because of your good work, 
--they now know their best customer, 
--which mixtures to push more, even the days which sales are made the most, and when to stock up just to mention a few. 
--But they have more work for you, they are interested in knowing the diversity of their customers specifically the gender, 
--to know if they have more males or females buying their product.

--They provide the dataset of the customers they have, and you write a query from it to create a new gender table setting 
--the primary key to be the name of the customers.

CREATE TABLE gender (
    Customer_Name VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(20)
);

INSERT INTO gender
VALUES
    ('Esther','Female'),
    ('Hauwa','Female'),
    ('Isaac','Male'),
    ('Jamie','Male'),
    ('Jerry','Male'),
    ('Joe','Male'),
    ('Juliet','Female'),
    ('Pauline','Female'),
    ('Philip','Male'),
    ('Ralph','Male'),
    ('Sm','Mle');


--A name has been misspelt as Sm and there's definetly no gender like Mle, you check around and 
--find out that Sm is meant to be Sam and he is a Man

-- So you update the dataset with the code below
UPDATE gender
SET Customer_Name = 'Sam', Gender='Male'
WHERE Customer_Name= 'Sm';

SELECT * 
FROM gender

-- Judging from the table you've created are there more men or women buying from the supermarket?
SELECT Gender, COUNT(Customer_Name) AS num_customer
FROM gender
GROUP BY Gender;

-- Insight: There are more male customers than females.

--You are done with the creation but the stakeholders want more,  they need to go on a massive marketing campaign 
--(gender based ) on total purchases over a week so they need you to figure out if women or men more likely to purchase a product 
--on a specific day.

--So you go back to your original table and add a FOREIGN KEY so it can be linked to the gender table.

ALTER TABLE salesinfo
ADD CONSTRAINT Customer_Gender_FK
FOREIGN KEY (Customer) REFERENCES gender(Customer_Name);

-- So after writing the code, you are asked to check for who is more likely to buy the product on a Tuesday.
SELECT Gender, SUM(Total_Fruits) AS total_fruits
FROM salesinfo s
INNER JOIN gender g
ON g.Customer_Name = s.Customer
WHERE Day_of_Purchase = 'Tue'
GROUP BY Gender;

-- Insight: Based on Analysis, Females are the most likely to buy fruits on a Tuesday compare to the Males.

--The stakeholders are happy because now they can choose any day to bring out ads for a specific gender, but they are also curious to know the 
--total fruits men and women buy.

SELECT Gender, SUM(Total_Fruits) AS total_fruits
FROM salesinfo s
INNER JOIN gender g
ON s.Customer = g.Customer_Name
GROUP BY Gender;

-- Insight: Men are purchasing fruits more as compared to the Women, Men has 11,642 total fruits purchased while Women has 9,752 total fruits
-- purchased in any of the day.

