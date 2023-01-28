--- SQL ASSIGNMENT 3

/*
Discount Effects

Generate a report including product IDs and discount effects on whether the increase in the 
discount rate positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL with a logical approach. */

WITH disc AS
	(SELECT	product_id, 
            COALESCE((COUNT(order_id) - LAG(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY discount)), 0) as order_count_change
    FROM sale.order_item oi
    GROUP BY product_id, discount
    HAVING COUNT(product_id) > 1 ),
	
	disc_eff AS
	(SELECT disc.product_id, SUM(disc.order_count_change) as total_diff,
		CASE 
			WHEN SUM(disc.order_count_change) = 0 THEN 'neutral'
			WHEN SUM(disc.order_count_change) > 0 THEN 'positive'
			WHEN SUM(disc.order_count_change) < 0 THEN 'negative'
		END AS discount_effect
	FROM disc
	GROUP BY disc.product_id)

SELECT product_id, discount_effect
FROM disc_eff