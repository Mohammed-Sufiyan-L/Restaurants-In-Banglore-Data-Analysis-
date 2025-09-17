-- ONLY ONLINE ORDER RESTAURANTS VS ONLY BOOK TABLES RESTAURANTS VS BOTH RESTAURANTS VS NO ONLINE ORDER AND BOOKINGS
   ---- WE CAN DO THIS USING CTE,VIEWS,SUBQUERIES AND TEMPORARY TABLES

SELECT
-- FOR ONLY ONLINE ORDERS
    (SELECT 
    COUNT(*) AS [COUNT OF ONLY ONLINE RESTAURANTS]
    FROM (
        SELECT DISTINCT
              [Restaurant_Name]
              ,[online_order]
              ,[book_table]
              ,AVG(Ratings) OVER (PARTITION BY [Restaurant_Name],[location] ) AS [Average_Rating]
              ,[Contact_info]
              ,[location]
        FROM Restaurants
        WHERE [online_order] = 'YES' AND [book_table] = 'NO') 
    AS T) AS [COUNT OF ONLY ONLINE RESTAURANTS],

    ---- ONLY BOOKING RESTAURANTS

    (SELECT 
    COUNT(*) AS [COUNT OF ONLY BOOKING RESTAURANTS]
    FROM (
        SELECT DISTINCT
              [Restaurant_Name]
              ,[online_order]
              ,[book_table]
              ,AVG(Ratings) OVER (PARTITION BY [Restaurant_Name],[location] ) AS [Average_Rating]
              ,[Contact_info]
              ,[location]
        FROM Restaurants
        WHERE [online_order] = 'NO' AND [book_table] = 'YES') 
    AS T) AS [COUNT OF ONLY BOOKING RESTAURANTS],

    --- RESTAURANTS WITH BOTH OPTIONS
    (SELECT 
    COUNT(*) AS [COUNT OF RESTAURANTS WITH BOTH OPTION]
    FROM (
        SELECT DISTINCT
              [Restaurant_Name]
              ,[online_order]
              ,[book_table]
              ,AVG(Ratings) OVER (PARTITION BY [Restaurant_Name],[location] ) AS [Average_Rating]
              ,[Contact_info]
              ,[location]
        FROM Restaurants
        WHERE [online_order] = 'YES' AND [book_table] = 'YES')
    AS T) AS [COUNT OF RESTAURANTS WITH BOTH OPTION],

    ---- RESTAURANTS WHICH DON'T HAVE BOTH ONLINE AND BOOKING OPTIONS

    (SELECT 
    COUNT(*) AS [COUNT OF NO ONLINE ORDERS AND BOOKING RESTAURANTS]
    FROM (
        SELECT DISTINCT
              [Restaurant_Name]
              ,[online_order]
              ,[book_table]
              ,AVG(Ratings) OVER (PARTITION BY [Restaurant_Name],[location] ) AS [Average_Rating]
              ,[Contact_info]
              ,[location]
        FROM Restaurants
        WHERE [online_order] = 'NO' AND [book_table] = 'NO') 
    AS T) AS [COUNT OF NO ONLINE ORDERS AND BOOKING RESTAURANTS] 

--------  TOP 10 LOCATION WITH HIGH NUMBER OF RESTAURANTS
SELECT DISTINCT TOP(10)
    Rank() OVER (ORDER BY [Count Of Restaurants] desc) as Rank,
    [location],
    [Count Of Restaurants],
    [Average Rating],
    [MAXIMUM COST FOR 2],
    [AVERAGE COST FOR 2]
FROM (
    SELECT
    DISTINCT
        [location],
        COUNT(Restaurant_Name) OVER(PARTITION BY [location]) AS [Count Of Restaurants],
        ROUND(AVG(Ratings) OVER(PARTITION BY [location]), 2) AS [Average Rating],
        ROUND(MAX([Approx#Cost_for_two]) OVER (PARTITION BY [location]), 2) AS [MAXIMUM COST FOR 2],
        ROUND(AVG([Approx#Cost_for_two]) OVER (PARTITION BY [location]), 2) AS [AVERAGE COST FOR 2]
    FROM Restaurants
    WHERE location IS NOT NULL) 
AS T
ORDER BY  Rank;
----- TOTAL NO. OF LOCATIONS -------------
SELECT 
COUNT(DISTINCT location) AS NO_OF_RESTAURANTS
FROM Restaurants;
------------------X------------------------------------

---------Location with Top rated Restaurants which are above average rating
 SELECT
 AVG([Ratings])
 FROM Restaurants

 SELECT DISTINCT TOP (10) *
 FROM (
     SELECT 
        [location],
            COUNT(Restaurant_Name) OVER(PARTITION BY [location]) AS [Count Of Restaurants],
            ROUND(AVG(Ratings) OVER(PARTITION BY [location]), 2) AS [Average Rating],
            ROUND(MAX([Approx#Cost_for_two]) OVER (PARTITION BY [location]), 2) AS [MAXIMUM COST FOR 2],
            ROUND(AVG([Approx#Cost_for_two]) OVER (PARTITION BY [location]), 2) AS [AVERAGE COST FOR 2]
    FROM Restaurants
) AS T
WHERE [Average Rating] >(SELECT
                    AVG([Ratings])
                    FROM Restaurants) AND location IS NOT NULL
ORDER BY [Average Rating] DESC

------  Costliest restaurant and its location based on cost for 2 people to eat----------

SELECT TOP(25)
Restaurant_Name,
LOCATION,
AVG([Approx#Cost_for_two]) AS Cost_for_2
FROM Restaurants
GROUP BY Restaurant_Name,LOCATION
ORDER BY AVG([Approx#Cost_for_two]) DESC

-------------- Do restaurants with higher ratings have a higher or lower average cost for two?

SELECT
    Ratings,
    ROUND(AVG([Approx#Cost_for_two]),2 ) AS average_cost
FROM
    Restaurants
WHERE
    Ratings IS NOT NULL AND [Approx#Cost_for_two] IS NOT NULL
GROUP BY
    Ratings
ORDER BY
    Ratings DESC;



