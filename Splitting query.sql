
SELECT DISTINCT
    f.Restaurant_Name,
    f.Ratings,
    f.location,
    TRIM(value) AS liked_dish,
    
INTO Foods_Liked
FROM
    Foods AS f
CROSS APPLY
    STRING_SPLIT(f.dish_liked, ',') AS s
    order by Restaurant_Name
    
ALTER TABLE FOODS
ADD ID INT UNIQUE IDENTITY(1,1)

ALTER TABLE FOODS
DROP TABLE Foods_liked
SELECT * FROM FOODS 
SELECT * FROM FOODS

ALTER TABLE FOODS
DROP COLUMN ID

SELECT 
 f.Restaurant_Name,
    f.Ratings,
    f.location,
    FL.liked_dish
FROM FOODS AS F
left JOIN Foods_Liked AS FL
ON F.RESTAURANT_NAME = FL.[Restaurant_Name]
WHERE f.Restaurant_Name = 'JALSA'



SELECT 
    C.[Restaurant_Name]
      ,C.[Ratings]
      ,C.[location]
      ,C.[Approx#Cost_for_two],
      TRIM(VALUE) AS [Cuisine]
--INTO CUISINES
FROM [Cusines] AS C
CROSS APPLY
STRING_SPLIT([cuisines],',') AS S

EXEC sp_rename 'CUISINES', 'Cuisines';