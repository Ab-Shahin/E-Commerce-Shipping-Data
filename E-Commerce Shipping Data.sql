-- Looking at the data

SELECT * 
FROM PortfoiloProject.dbo.E_Com_Shipping_Data



/* Identifying the percentage of shipments that arrived on time, where 1 Indicates that the product has NOT reached on time and 0 indicates it has reached on time. */

SELECT Reached_on_Time_Y_N ,
	   COUNT(Reached_on_Time_Y_N) Count,
	   COUNT(Reached_on_Time_Y_N) * 100.0 / (SELECT COUNT(Reached_on_Time_Y_N) FROM PortfoiloProject.dbo.E_Com_Shipping_Data) Reached_on_time_percentage
	   FROM PortfoiloProject.dbo.E_Com_Shipping_Data
	   GROUP BY Reached_on_Time_Y_N

SELECT * 
FROM PortfoiloProject.dbo.E_Com_Shipping_Data
WHERE Reached_on_Time_Y_N = 1
ORDER BY Customer_care_calls DESC



/* Identifying which warehouse where most of shipments haven't reached on time */

SELECT Warehouse_block,
		COUNT(Warehouse_block) Count,
	    COUNT(Warehouse_block) * 100.0 / (SELECT COUNT(Warehouse_block) FROM PortfoiloProject.dbo.E_Com_Shipping_Data WHERE Reached_on_Time_Y_N = 1) warehouse_percentage 
FROM PortfoiloProject.dbo.E_Com_Shipping_Data
WHERE Reached_on_Time_Y_N = 1
GROUP BY Warehouse_block
ORDER BY warehouse_percentage  DESC

-- Adding the mode_of_shipment to identify by which means of shipping has it's been affected 

SELECT Warehouse_block, mode_of_shipment, 
		COUNT(Warehouse_block) Count,
	    COUNT(Warehouse_block) * 100.0 / (SELECT COUNT(Warehouse_block) FROM PortfoiloProject.dbo.E_Com_Shipping_Data WHERE Reached_on_Time_Y_N = 1 AND Customer_care_calls = 7) warehouse_percentage 
FROM PortfoiloProject.dbo.E_Com_Shipping_Data
WHERE Reached_on_Time_Y_N = 1
AND Customer_care_calls = 7
GROUP BY Warehouse_block, mode_of_shipment
ORDER BY warehouse_percentage  DESC


/* Identifying which warehouse associated whith highest cost of discouned products */

SELECT SUM(Discount_offered) Total_discount, Warehouse_block
FROM PortfoiloProject.dbo.E_Com_Shipping_Data
GROUP BY  Warehouse_block
ORDER BY Total_discount DESC


/* Identifying which warehouse associated with low ratings */

WITH CTE_Rating AS
(SELECT *,
		 CASE
		 WHEN Customer_rating BETWEEN 4 AND 5 THEN 'High_rating'
		 WHEN Customer_rating = 3 THEN 'low_rating'
		 WHEN Customer_rating BETWEEN 1 AND 2 THEN 'Medium_rating'
		 END AS Rating_grouped 
FROM PortfoiloProject.dbo.E_Com_Shipping_Data)
SELECT  Rating_grouped ,
	   COUNT(Rating_grouped) Count, Warehouse_block,
	   COUNT(Rating_grouped) * 100.0 / (SELECT COUNT(Rating_grouped) FROM CTE_Rating) Rating_grouped_percentage
	   FROM CTE_Rating
	   GROUP BY Rating_grouped, Warehouse_block
	   HAVING Rating_grouped = 'low_rating'
	   ORDER BY Rating_grouped_percentage DESC