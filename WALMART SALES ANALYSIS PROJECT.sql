-- PROJECT:WALMART SALES DATA ANALYSIS 
-- DATABASE:walmart_sales
-- TABLE:WalmartSales

--DATABASE SELECTION
USE walmart_sales;

SELECT * from WalmartSales

--SECTION 1:ALTERING QUESTIONS

-- Q1:Can we categorize transaction time into Morning, Afternoon, and Evening to analyze the time of day when most sales occur?
ALTER TABLE WalmartSales ADD
time_of_day VARCHAR(20);
GO
UPDATE WalmartSales
SET time_of_day = CASE
When time BETWEEN '06:00:00' AND '12:00:00' then 'Morning'
When time BETWEEN '12:01:00' AND '16:00:00' then 'Afternoon'
Else 'Evening'
END;
GO
SELECT * from WalmartSales


-- Analyze the time of day when most sales occur
SELECT 
time_of_day,
Count(*) As
total_transactions,
SUM(Total) AS
total_sales
From WalmartSales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Q2:On which day of the week did each transaction take place to understand daily sales trends?
ALTER TABLE WalmartSales ADD day_name VARCHAR(20);
GO
UPDATE WalmartSales
SET day_name = DATENAME(dw, Date);
GO

-- Q3:In which month did each transaction occur to determine monthly sales and profit performance?
ALTER TABLE WalmartSales ADD month_name VARCHAR(20);
GO
UPDATE WalmartSales
SET month_name = DATENAME(mm, Date);
GO

-- SECTION 2:GENERIC QUESTIONS

-- Q1: How many unique cities are present in the dataset?
SELECT 
COUNT(DISTINCT City) AS unique_cities_count
FROM WalmartSales;

-- Q2:Which city is associated with each store branch?
SELECT DISTINCT 
Branch,
City
FROM WalmartSales;

-- SECTION 3:PRODUCT ANALYSIS QUESTIONS

-- Q1:How many unique product lines are available in the dataset?
SELECT
COUNT(DISTINCT[Product_line]) AS unique_product_lines
FROM WalmartSales;

-- Q2: What is the most commonly used payment method?
SELECT TOP 1
Payment,
COUNT(*) AS transaction_count
FROM WalmartSales
GROUP BY Payment
ORDER BY transaction_count DESC;

-- Q4: Which product line has the highest number of units sold?
SELECT 
Product_line,
SUM(Quantity) AS total_units_sold
FROM WalmartSales
GROUP BY Product_line
ORDER BY total_units_sold DESC;

--Q4:What is the total revenue generated in each month?
SELECT
month_name as Month,
SUM(Total) AS total_revenue
FROM WalmartSales
GROUP BY month_name
ORDER BY total_revenue DESC;

SELECT * from WalmartSales

-- Q5:In which month the cost of goods sold(COGS) the highest?
SELECT 
month_name, 
SUM(cogs) as total_cogs 
FROM WalmartSales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- Q6:Which product line generated the most revenue?
SELECT
Product_line,
SUM(Total) AS Total_Revenue
FROM WalmartSales
GROUP BY Product_line
ORDER BY Total_Revenue DESC;

-- Q7:Which city recorded the highest total revenue?
SELECT
City,
SUM(Total) As total_revenue
FROM WalmartSales
GROUP BY City
ORDER BY total_revenue DESC;

-- Q8:Which product line had the highest average VAT percentage?
SELECT TOP 1
Product_line,
AVG(Tax_5) AS avg_vat_percentage
FROM WalmartSales
GROUP BY Product_line
ORDER BY avg_vat_percentage DESC;

-- Q9:Can we classify each product line as "Good" or "Bad" based on whether its sales volume is above or below the average?
With ProductSales AS
(
SELECT
Product_line,
SUM(Quantity) AS Total_Quantity
FROM WalmartSales
GROUP BY Product_line
)

SELECT
Product_line,
Total_Quantity,

CASE 
When Total_Quantity > (SELECT AVG(Total_Quantity) FROM ProductSales)
THEN 'GOOD'
ELSE 'BAD' 
END as Performance
FROM ProductSales;

-- Q10:Which branch sold more products than the overall average number of products sold?
SELECT
Branch,
SUM(Quantity) AS total_products_sold
FROM WalmartSales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(branch_total)
FROM(SELECT SUM(Quantity) AS branch_total
FROM WalmartSales
GROUP BY Branch 
) AS BranchSales
);

-- Q11:For each gender, which product line is purchased the most?
With Ranked_Products AS 
(
SELECT 
Gender,
Product_line,
SUM(Quantity) AS total_purchased,
ROW_NUMBER() OVER (Partition BY Gender ORDER BY SUM(Quantity) DESC) AS rn
FROM WalmartSales
GROUP BY Gender, Product_line
)
SELECT
Gender,
Product_line,
total_purchased
FROM Ranked_Products
where rn = 1;

-- Q12:What is the average customer rating for each prodct line?
SELECT
Product_line,
AVG(Rating) AS avg_rating
FROM WalmartSales
GROUP BY Product_line
ORDER BY avg_rating DESC;

--SECTION 3:SALES ANALYSIS QUESTIONS

SELECT * from WalmartSales

--Q1:How many sales were made during each time of day(Morning, Afternoon, Evening) for every day of the week?
SELECT
day_name,
time_of_day,
COUNT(*) AS total_sales
FROM WalmartSales
GROUP BY day_name, time_of_day
ORDER BY COUNT(*) DESC ;

-- Q2:Which customer type contributes the most to the company's total revenue?
SELECT 
Customer_type,
SUM(Total) AS total_revenue
FROM WalmartSales
GROUP BY Customer_type
ORDER BY total_revenue DESC;

-- Q3:Which city has the highest average VAT percentage?
SELECT
City,
AVG(Tax_5) AS avg_vat
FROM WalmartSales
GROUP BY City
ORDER BY avg_vat DESC;

-- Q4: Which customer type pays the most VAT on average?
SELECT
Customer_type,
AVG(Tax_5) AS avg_vat
FROM WalmartSales
GROUP BY Customer_type
ORDER BY avg_vat DESC;

-- SECTION 4:CUSTOMER ANALYSIS QUESTIONS

-- Q1:How many unique customer types are present in the dataset?
SELECT
COUNT(DISTINCT Customer_type) AS unique_customer_types
FROM WalmartSales

-- Q2:How many different payment methods are used by customers?
SELECT
COUNT(DISTINCT Payment) AS unique_payment_methods
FROM WalmartSales;

-- Q3:What is the most common customer type?
SELECT
Customer_type,
COUNT(*) AS count
FROM WalmartSales
GROUP BY Customer_type
ORDER BY count DESC;

-- Q4:Which customer type makes the most purchases?
SELECT
Customer_type,
COUNT(*) AS total_purchases
FROM WalmartSales
GROUP BY Customer_type
ORDER BY total_purchases DESC;

-- Q5:What is the gender distribution among the customers?
SELECT
Gender,
COUNT(*) AS gender_count
FROM WalmartSales
GROUP BY Gender;

-- Q6:How does the gender distribution vary across different store branches?
SELECT
Branch,
Gender,
COUNT(*) AS gender_count
FROM WalmartSales
GROUP BY Branch,Gender
ORDER BY Branch,gender_count DESC;

--Q7:During which time of the day do customer give the highest average ratings?
SELECT
time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Q8:During which time of the day do customers in each branch give the best ratings?
SELECT
Branch,
time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSales
GROUP BY Branch,time_of_day
ORDER BY Branch, avg_rating DESC;

-- Q9:On which day of the week do customers provide the best average ratings?
SELECT
day_name,
AVG(Rating) AS avg_rating
FROM WalmartSales
GROUP BY day_name
Order by avg_rating DESC;

-- Q10:For each branch, which day of the week receives the highest number of sales?
With RankedSales AS 
(
SELECT
Branch,
day_name,
COUNT(*) AS total_sales,
ROW_NUMBER() OVER (PARTITION BY BRANCH ORDER BY COUNT(*) DESC) AS RANK
FROM WalmartSales
GROUP BY Branch, day_name
)
SELECT 
Branch,
total_sales,
day_name
FROM RankedSales 
WHERE rank = 1;