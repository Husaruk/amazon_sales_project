SELECT 
	*
FROM 
	Amazon.dbo.ReportSales
where 
	amount = 0

SELECT 
	*
FROM 
	#temp_Sales_Shipped


-- CLEANING		
-- Drop column Unnamed_22,						#Completed
-- Clean ship_postal_code column				#In process , change method for different command
-- Clean Courier_Status column					#Completed
-- Clean ship_city column						#Completed
-- Clean ship_state column						#Completed

-- Working on null values
--		33 rows have null in ship_city, ship_state, ship_postal_code and ship_country. Basicly I can delete them, it wouldn't have much impact on over all result
--		Column promotion_ids has null instead of 'without promotion', to fix these null values I can replace null with 'without promotion'
--		In fulfilled_by we have 2 values, method for delivery from amazon and null. I will change null value to unknown.
--		Column Amount have 8 000 null values, I noticed that it is because order was cancelled. But when I check by Status, it has 18 000. Replace all Amounts for this condition with null
--		Where Status = 'Cancelled', I must currency = INR, promotion_ids = null, Amount = null



-- Drop column Unnamed_22

ALTER TABLE 
	Amazon.dbo.ReportSales
DROP COLUMN 
	Unnamed_22


-- Clean ship_postal_code column


UPDATE
	ReportSales
SET 
	ship_postal_code = CAST(ship_postal_code AS float)


-- Clean Courier_Status column

--		Only rows where Fulfilment = Merchant and Status = Cancelled, have null values in Courier_Status
--		I need to change nulls to Cancelled

SELECT 
	*
FROM 
	Amazon.dbo.ReportSales
WHERE 
	Courier_Status IS NULL


UPDATE 
	ReportSales
SET 
	Courier_Status = 'Cancelled'
WHERE 
	Courier_Status IS NULL


-- Clean ship_city column

UPDATE 
	Amazon.dbo.ReportSales
SET 
	ship_city = TRIM(UPPER(SUBSTRING(ship_city,1,1)) + LOWER(SUBSTRING(ship_city,2,LEN(ship_city))))


-- Clean ship_state column

UPDATE 
	Amazon.dbo.ReportSales
SET 
	ship_state = TRIM(UPPER(SUBSTRING(ship_state, 1, 1)) + LOWER(SUBSTRING(ship_state, 2, LEN(ship_state))))



-- Working on null values
-- 1		33 rows have null in ship_city, ship_state, ship_postal_code and ship_country. Basicly I can delete them, it wouldn't have much impact on over all result
-- 2		Column promotion_ids has null instead of 'without promotion', to fix these null values I can replace null with 'without promotion'
-- 3		In fulfilled_by we have 2 values, method for delivery from amazon and null. I will change null value to unknown.
-- 4		Column Amount have 8 000 null values, I noticed that it is because order was cancelled. But when I check by Status, it has 18 000. Replace all Amounts for this condition with null
-- 5	  	Where Status = 'Cancelled', I must currency = INR, promotion_ids = null, Amount = null


-- 1

DELETE
FROM Amazon.dbo.ReportSales
WHERE ship_city is null


-- 2

UPDATE Amazon.dbo.ReportSales
SET promotion_ids = 'without promotion'
WHERE promotion_ids is null


-- 3

UPDATE Amazon.dbo.ReportSales
SET fulfilled_by = 'unknown'
WHERE fulfilled_by is null


-- 4,5

UPDATE Amazon.dbo.ReportSales
SET promotion_ids = 'without promotion',  Amount = 0
WHERE 'Status' = 'Cancelled'


UPDATE Amazon.dbo.ReportSales
SET currency = 'INR'
WHERE currency is null


-- For some cases during exploration I will need table where I only have rows that contain only  Courier_Status = 'Shipped'

DROP TABLE IF EXISTS #temp_Sales_Shipped
CREATE TABLE #temp_Sales_Shipped
( 
[index] int,
[Order_ID] nvarchar(50),
[Date] datetime2,
[Status] nvarchar(50),
[Fulfilment] nvarchar(50),
[Sales_Channel] nvarchar(50),
[ship_service_level] nvarchar(50),
[Category] nvarchar(50),
[Size] nvarchar(50),
[ASIN] nvarchar(50),
[Courier_Status] nvarchar(50),
[Qty] int,
[currency] nvarchar(50),
[Amount] float,
[ship_city] nvarchar(50),
[ship_state] nvarchar(50),
[ship_postal_code] nvarchar(50),
[ship_country] nvarchar(50),
[promotion_ids] nvarchar(max),
[B2B] bit
)


INSERT INTO #temp_Sales_Shipped (
[index],[Order_ID],[Date],[Status],[Fulfilment],[Sales_Channel],[ship_service_level],
[Category],[Size],[ASIN],[Courier_Status],[Qty],[currency],[Amount],[ship_city],
[ship_state],[ship_postal_code],[ship_country],[promotion_ids],[B2B])
SELECT [index],[Order_ID],[Date],[Status],[Fulfilment],[Sales_Channel],[ship_service_level],
[Category],[Size],[ASIN],[Courier_Status],[Qty],[currency],[Amount],[ship_city],
[ship_state],[ship_postal_code],[ship_country],[promotion_ids],[B2B]
FROM 
	Amazon.dbo.ReportSales
WHERE 
	Courier_Status = 'Shipped'


SELECT 
	*
FROM 
	#temp_Sales_Shipped



-- 

--Exploration

-- #Completed Distribution in column Fulfilment 
-- #Completed Distribution in ship_service_level   # FIXED(FORMAT(, 'N2'))
-- #Completed Distribution in Courier_Status	   # FIXED(FORMAT(, 'N2'))

--Items

-- #Completed Distribution of sizes. Understand what will be the best number of 
-- #In progress every item sizes our warehouse should have. #EXPLORE WITH COURIER_STATUS
-- #Completed What are the best selling products.
-- #In progress How likely client going to buy qty more than 1? #EXPLORE WITH COURIER_STATUS
--	B2B
--	#Completed What role b2b play in this distribution.
--	#Completed How many orders are by b2b
--  #Completed Top orders by B2B 
--  #Completed top times when customer spent a lot of money 

--Items and Amount

--#In progress Find out which items are less likely to be cancelled. #Need more statistical knowledge
--		Propose what store can do to help customers order right size
--	#Completed Distribution of items by Amount
--	#Completed What items people more likely to buy? Cheap or expensive? #Answer will be in viz

--Earnings

--	#Completed How many items(qty) were sold per month?
--	#Completed How many items(qty) were sold per week?
--	#Completed How many items(qty) were sold per day?
--	#Completed How much did the store earn per month?
--	#Completed How much did the store earn per week?
--	#Completed How much did the store earn per day?
--	#In progress How differ profit each month?					# I will answer by viz
--	#In progress How differ the number of sales each month		# I will answer by viz

--Promotions

--	#Completed What are the most popular promotions
--	#Completed What is distribution of orders with and without promotion

--Location

--	#Completed Which cities, states, are the most popular
--	#Completed Are there any orders from other countries



--Distribution in column Fulfilment

SELECT
    Fulfilment,
    SUM(COUNT(*)) OVER ()	AS 'sum_fulfilment',
    COUNT(*)				AS 'sum_per_value',
    FORMAT(
		CAST(COUNT(*) AS DECIMAL) / CAST(SUM(COUNT(*)) OVER () AS DECIMAL) * 100,
	'N2')				AS 'percentage'
FROM 
	Amazon.dbo.ReportSales
GROUP BY 
	Fulfilment

		-- Percentage is 70/30



--Distribution in ship_service_level

SELECT 
	Fulfilment,
	ship_service_level, 
	SUM(COUNT(*)) OVER ()	AS 'sum_fulfilment',
	COUNT(*)				AS 'sum_per_value',
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N2')					AS 'percentage'
FROM 
	Amazon.dbo.ReportSales
GROUP BY 
	Fulfilment,
	ship_service_level

		-- For my surpise Expedited delivery is more spread than Standard. 




--Distribution in Courier_Status

SELECT 
	Courier_Status,
	SUM(COUNT(*)) OVER()	AS sum_courier_status,
	COUNT(*)				AS count_num,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N2')					AS 'percentage'
FROM 
	Amazon.dbo.ReportSales
GROUP BY
	Courier_Status




--Items

--Distribution of sizes. Understand what will be the best number of 
--every item sizes our warehouse should have. #EXPLORE WITH COURIER_STATUS


SELECT 
	DISTINCT Category,
	Size,
	SUM(COUNT(*)) OVER()	AS sum_sizes, 
	COUNT(*)				AS count_each_size,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N2')					AS 'percentage'
FROM 
	#temp_Sales_Shipped
GROUP BY 
	Category, Size
ORDER BY 
	COUNT_EACH_SIZE DESC

		--	first 20/57 Categories have 80 percent of all orders. 
		-- My advice will be for him to start selling these 20 categories to find his clients and start 
		-- receiving first orders.

--What are the best selling products.

SELECT 
	DISTINCT Category,
	SUM(COUNT(*)) OVER()	AS sum_category, 
	COUNT(*)				AS count_each_category,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N2')					AS 'percentage'
FROM 
	#temp_Sales_Shipped
GROUP BY 
	Category
ORDER BY 
	count_each_category DESC


--How likely client going to buy qty more than 1?

SELECT 
	DISTINCT Qty,
	COUNT(*)				AS total,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N3')					AS 'percentage'
FROM 
	Amazon.dbo.ReportSales
WHERE 
	Qty <> 0 AND Courier_Status = 'Shipped'
GROUP BY
	Qty
ORDER BY 
	total DESC

SELECT 
	DISTINCT Qty,
	COUNT(*)				AS total,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N3')					AS 'percentage'
FROM 
	Amazon.dbo.ReportSales
WHERE 
	Qty <> 0 AND Courier_Status <> 'Shipped'
GROUP BY
	Qty
ORDER BY 
	total DESC


--		chance that someone will buy more than 1 item per order is 0.33%
--		I noticed that orders with qty bigger than 1, also were cancelled but only where qty = 2
--		I think it is because people tend to order by mistake 2 instead of 1.




--	B2B

--	What role b2b play in this distribution.

SELECT 
	DISTINCT Qty,
	B2B,
	COUNT(*)				AS num_total,
	FORMAT(
		CAST(COUNT(*) AS DECIMAL) / SUM(COUNT(*)) OVER () * 100,
	'N4')					AS 'percentage'
FROM 
	#temp_Sales_Shipped
WHERE 
	Qty <> 0 
GROUP BY
	Qty, B2B
ORDER BY 
	Qty, B2B DESC

	--		B2B doesn't play a huge role in our sales.


--	How many orders are by b2b

SELECT 
	DISTINCT B2B, 
	COUNT(Qty)				AS total,
	FORMAT(
		CAST(COUNT(Qty) AS DECIMAL) / SUM(COUNT(Qty)) OVER () * 100,
	'N2')					AS 'percentage'
FROM 
	#temp_Sales_Shipped
WHERE 
	Qty <> 0 
GROUP BY 
	B2B
ORDER BY total


	-- Only 793 orders from all were ordered by b2b


-- top times when b2b spent a lot of money 

SELECT 
	Category, Qty, Amount, B2B
FROM 
	#temp_Sales_Shipped
WHERE 
	B2B = 1 
ORDER BY
	Amount DESC


-- top times when customer spent a lot of money 

SELECT 
	Category, Qty, Amount, B2B
FROM 
	#temp_Sales_Shipped
WHERE 
	B2B = 0 
ORDER BY
	Amount DESC


--Items and Amount

--Find out which items are less likely to be cancelled. 
--		Propose what store can do to help customers order right size
--Distribution of items by Amount
--What items people more likely to buy? Cheap or expensive?




--Find out which items are less likely to be cancelled. #Require more knowledge about statistics.
-- It's wrong to compare categories with different sample sizes, that is why I need to find method
-- that fixes this problem.

SELECT 
	Category, Courier_Status
FROM 
	Amazon.dbo.ReportSales
GROUP BY
	Category, Courier_Status
ORDER BY 
	Category 


DROP TABLE IF EXISTS #Temp_category_delivery_result
CREATE TABLE #Temp_category_delivery_result (
Category varchar(50),
order_status varchar(50),
sum_category int,
count_category int,
percentage_from_total float)


INSERT INTO #Temp_category_delivery_result
SELECT 
	Category, 
	Order_sub.order_status, 
	SUM(COUNT(Category)) OVER()		AS sum_category,
	COUNT(Category)					AS count_category, 
	CAST(COUNT(Category) AS DECIMAL) / CAST(SUM(COUNT(Category)) OVER () AS DECIMAL) * 100
									AS 'percentage_from_total'	
FROM 
	Amazon.dbo.ReportSales
INNER JOIN 
	(
	SELECT 
		Order_ID,
		CASE 
			WHEN Courier_Status = 'Shipped' THEN 'Shipped'
			ELSE 'Cancelled'
		END AS order_status
	FROM
		Amazon.dbo.ReportSales
	) Order_sub
ON 
	Amazon.dbo.ReportSales.Order_ID = Order_sub.Order_ID
GROUP BY 
	Category, Order_sub.order_status
ORDER BY 
	Category, count_category desc




SELECT 
	Category, 
	order_status, 
	SUM(SUM(count_category)) OVER (PARTITION BY Category)	AS sum_per_category,
	SUM(count_category)										AS sum_per_category_status,
	FORMAT(
		CAST(SUM(count_category) AS DECIMAL) / SUM(SUM(count_category)) OVER (PARTITION BY Category) * 100,
	'N2')													AS 'percentage_per_category'
FROM
	#Temp_category_delivery_result
GROUP BY 
	Category, order_status
ORDER BY 
	Category


--Distribution of items by Amount

SELECT 
	DISTINCT(ROUND(Amount, -1))
FROM 
	Amazon.dbo.ReportSales


SELECT 
	DISTINCT(Category),
	ROUND(Amount, -1),
	COUNT(Amount) as count_category
	 -- OVER (PARTITION BY ROUND(Amount, -1)) 
FROM	
	#temp_Sales_Shipped
GROUP BY
	Category, Amount
ORDER BY 
	count_category DESC


--Earnings

--How many items(qty) were sold per month?
--How much did the store earn per month?
--How many items(qty) were sold per week?
--How much did the store earn per week?
--How many items(qty) were sold per day?
--How much did the store earn per day?
--How differ profit each month?					# I will answer by viz
--How differ the number of sales each month		# I will answer by viz




--How many items(qty) were sold per month?

SELECT 
	MONTH(Date)	AS Month, 
	SUM(Qty)			AS Monthly_sales
FROM 
	#temp_Sales_Shipped
GROUP BY
	MONTH(Date) 
ORDER BY 
	MONTH(Date) 


--How much did the store earn per month?

SELECT 
	MONTH(Date)	AS Month, 
	SUM(Amount)			AS Monthly_earnings
FROM 
	#temp_Sales_Shipped
GROUP BY
	MONTH(Date) 
ORDER BY 
	MONTH(Date) 


--How many items(qty) were sold per week?

SELECT 
	DATEPART(WEEK, Date)	AS Week, 
	SUM(Qty)					AS Weekly_sales
FROM 
	#temp_Sales_Shipped
GROUP BY
	DATEPART(WEEK, Date)
ORDER BY 
	DATEPART(WEEK, Date)


--How much did the store earn per week?

SELECT 
	DATEPART(WEEK, Date)	AS Week, 
	SUM(Amount)					AS Weekly_earnings
FROM 
	#temp_Sales_Shipped
GROUP BY
	DATEPART(WEEK, Date)
ORDER BY 
	DATEPART(WEEK, Date)


--How many items(qty) were sold per day?

SELECT 
	Date	AS Day, 
	SUM(Qty)	AS Day_sales
FROM 
	#temp_Sales_Shipped
GROUP BY
	Date
ORDER BY 
	Date


--How much did the store earn per day?

SELECT 
	Date	AS Day, 
	SUM(Amount)	AS Day_earnings
FROM 
	#temp_Sales_Shipped
GROUP BY
	Date
ORDER BY 
	Date





--Promotions

--What are the most popular promotions

SELECT 
	DISTINCT(SUBSTRING(promotion_ids,1,70)) AS promotion_ids, 
	COUNT(*)								AS count_promotion
FROM 
	#temp_Sales_Shipped
GROUP BY
	SUBSTRING(promotion_ids,1,70)
ORDER BY
	COUNT(*) DESC


--What is distribution of orders with and without promotion

SELECT
	COUNT(*) AS with_promo
FROM 
	#temp_Sales_Shipped
WHERE
	promotion_ids <> 'without promotion'


SELECT
	COUNT(*) AS without_promo
FROM 
	#temp_Sales_Shipped
WHERE
	promotion_ids = 'without promotion'


select *
from Amazon.dbo.ReportSales


--Location

--Which cities, states are the most popular


SELECT 
	ship_city,
	COUNT(ship_city)	AS count_ship_city		
FROM 
	#temp_Sales_Shipped
GROUP BY
	ship_city
ORDER BY
	COUNT(ship_city) DESC


			-- NEW DELHI - this city has only 250k of population, while in in compeats by Amount 
			-- of orders with cities that has more than 5million population, unexpected result

SELECT 
	ship_state,
	COUNT(ship_state)																		AS orders_per_state
FROM 
	#temp_Sales_Shipped
GROUP BY
	ship_state
ORDER BY
	COUNT(ship_state) DESC


--Are there any orders from other countries

SELECT
	DISTINCT ship_country
FROM
	#temp_Sales_Shipped


		-- All orders were made to India