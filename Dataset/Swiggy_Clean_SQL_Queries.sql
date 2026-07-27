						-- ADVANCED ANALYTICS 

			-- SECTION 1 : TOP RESTAURANTS WITHIN EACH CITY

WITH RankedRestaurants AS (
   
   SELECT
        City,
        RestaurantName,
        EstimatedRevenue,

        RANK() OVER (
            PARTITION BY City
            ORDER BY EstimatedRevenue DESC
        ) AS RevenueRank

    FROM Restaurants_Clean
)

SELECT *
FROM RankedRestaurants
WHERE RevenueRank <= 5;


            -- SECTION 2 : CUSTOMER DEMAND SEGMENTATION


SELECT
    RestaurantName,
    City,
    EstimatedOrders,

    CASE

        WHEN EstimatedOrders >= 4000 THEN 'High Demand'

        WHEN EstimatedOrders >= 2000 THEN 'Medium Demand'

        ELSE 'Low Demand'

    END AS DemandCategory

FROM Restaurants_Clean;


            -- SECTION 3 : DELIVERY PERFORMANCE SEGMENTATION


SELECT
    RestaurantName,
    City,
    DeliveryTimeMinutes,

    CASE

        WHEN DeliveryTimeMinutes <= 30 THEN 'Fast Delivery'

        WHEN DeliveryTimeMinutes <= 50 THEN 'Moderate Delivery'

        ELSE 'Slow Delivery'

    END AS DeliveryCategory

FROM Restaurants_Clean;


            -- SECTION 4 : TOP CUISINES BY REVENUE


SELECT TOP 10
    CuisineTypes,
    SUM(EstimatedRevenue) AS Revenue
FROM Restaurants_Clean
GROUP BY CuisineTypes
ORDER BY Revenue DESC;


            -- SECTION 5 : REVENUE CONTRIBUTION %


SELECT
    City,

    SUM(EstimatedRevenue) AS Revenue,

    CAST(
        ROUND(
            100.0 * SUM(EstimatedRevenue)
            / SUM(SUM(EstimatedRevenue)) OVER (),
            2
        )
    AS DECIMAL(10,2)) AS RevenueContributionPercent

FROM Restaurants_Clean
GROUP BY City
ORDER BY Revenue DESC;


            -- SECTION 6 : BEST VALUE RESTAURANTS


SELECT TOP 10
    RestaurantName,
    City,
    AverageMealPrice,
    AverageRating,

    ROUND(
        AverageRating * 1.0 / AverageMealPrice,
        4
    ) AS ValueScore

FROM Restaurants_Clean
ORDER BY ValueScore DESC;


