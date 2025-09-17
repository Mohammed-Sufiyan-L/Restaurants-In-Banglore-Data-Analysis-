----- Find what are all the different types of cuisines are served in banglore------------
SELECT DISTINCT
[Cuisine]
FROM Cuisines;
------X--------
SELECT 
COUNT(CUISINE) COUNT
	FROM (
	SELECT DISTINCT
	[Cuisine]
	FROM Cuisines) AS T

------ Which cuisine type of restaurants are more OR Popular cuisine in banglore---------

SELECT TOP(10)
CUISINE,
COUNT([Restaurant_Name]) AS Count_Of_Restaurant
FROM Cuisines
GROUP BY [CUISINE]
ORDER BY Count_Of_Restaurant DESC

--- I am going to create view for this query so we can use it in our future queries -----

CREATE VIEW Popular_Cuisines AS
(
	SELECT TOP(10)
	[Type_Of_Cuisine],
	COUNT([Restaurant_Name]) AS Count_Of_Restaurant
	FROM Cuisines
	GROUP BY [Type_Of_Cuisine]
	ORDER BY Count_Of_Restaurant DESC
)
------------------X----------------------

------------ Now using view we created ---- Finding best rated restaurants for popular cuisines
WITH RANKING_CTE AS
(
	SELECT  [Type_Of_Cuisine]
		  ,[Restaurant_Name]
		  ,[Ratings]
		  ,[location]
		  ,[Approx#Cost_for_two]
		  ,ROW_NUMBER() OVER(PARTITION BY [Type_Of_Cuisine] ORDER BY [Ratings] DESC) AS RANK
	FROM Cuisines
	WHERE [Type_Of_Cuisine] IN (SELECT [Type_Of_Cuisine] FROM Popular_Cuisines)
) 

SELECT 
*
FROM RANKING_CTE
WHERE RANK < 6

----------------X-------------------
--Classifying some restaurants with good ratings and being in three budget categories 'high,,'budget friendly','low'

SELECT 
* ,
ROW_NUMBER() OVER(PARTITION BY BUDGET_CATEGORY ORDER BY [Approx#Cost_for_two] ASC,[Ratings] DESC) AS ID
FROM(
	SELECT DISTINCT
			   [Restaurant_Name]
			  ,[Ratings]
			  ,[location]
			  ,[Approx#Cost_for_two]
			  ,[Type_Of_Cuisine],
		CASE 
			WHEN [Approx#Cost_for_two] > 1000 THEN 'COSTLY'
			WHEN [Approx#Cost_for_two] BETWEEN 500 AND 1000 THEN 'BUDGET_FRIENLY'
			WHEN [Approx#Cost_for_two] <500 THEN 'LOW_BUDGET'
			ELSE 'N/A'
		END AS BUDGET_CATEGORY
	FROM Cuisines
	WHERE [Type_Of_Cuisine] IN (SELECT [Type_Of_Cuisine] FROM Popular_Cuisines)
) AS ID_TABLE
WHERE RATINGS IS NOT NULL
     ------------------------> Can use this query with separate filters like specific location,
	 -------------------------specific budget,specific cuisine