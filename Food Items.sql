--- Creates a view where i have combined different types of biryanis except vegetable biryani into single 'Biryanis'---------
CREATE VIEW Liked_Foods_View AS
(
	SELECT [Restaurant_Name]
      ,[Ratings]
      ,[location],
	  CASE
		WHEN [liked_dish] LIKE '%BIRYANI%' AND liked_dish NOT LIKE '%VEGETABLE BIRYANI%' THEN 'Biryanis'
		ELSE liked_dish
	  END AS Liked_dish
	FROM Foods_Liked
)
--------------X----------------------
------ Finding popular dishes------------
SELECT 
	Liked_dish,
	COUNT(Liked_dish) AS POPULARITY 
FROM Liked_Foods_View
GROUP BY Liked_dish
ORDER BY POPULARITY DESC
------------X------------------
----------- Find top rated restaurants for most popular dishes------------------
CREATE VIEW Popular_Food AS
(
	SELECT TOP (5)
	Liked_dish,
	COUNT(Liked_dish) AS POPULARITY 
FROM Liked_Foods_View
GROUP BY Liked_dish
ORDER BY POPULARITY DESC
)
-------- As my foods_liked table doesnt have approx_cost of 2 column i will add it using joins
ALTER TABLE [Foods_Liked]
ADD Cost_for_2 INT

UPDATE F
SET	
	F.Cost_for_2 = R.Approx#Cost_for_two
FROM [Foods_Liked] AS F
INNER JOIN Restaurants AS R
ON F.[Restaurant_Name] = R.Restaurant_Name
--------------------X----------------------------------
---------- MAIN QUERY------------------
WITH FOOD_CTE_1 AS
(
	SELECT
		 [Restaurant_Name]
		  ,[Ratings]
		  ,[location]
		  ,Cost_for_2
		  ,[liked_dish] AS Food_item
	FROM Foods_Liked
	WHERE liked_dish IN (SELECT Liked_dish FROM Popular_Food) AND Ratings IS NOT NULL
)
,FOOD_CTE_2 AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Food_item ORDER BY RATINGS DESC) AS Rank
FROM FOOD_CTE_1 
)
SELECT * FROM FOOD_CTE_2 
WHERE Rank < 6
ORDER BY FOOD_ITEM ,Rank
