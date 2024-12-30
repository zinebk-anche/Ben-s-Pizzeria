--Dashboard 1 - Order activity
----Total Orders
----Total Sales
----Total Items
----Average Order Values (Total Sales/Total Sales)
----Sales by Category
----Top Selling Items
----Orders by Hour
----Sales by Hour
----Orders by Address
----Orders by Delivery/pick up

SELECT
    o.order_id, -- for Total Orders
    i.item_price, -- for Total Sales
    o.quantity, -- for Total Items
    i.item_cat, -- for Sales by Category
    i.item_name, -- for Top Selling Items
    o.created_date,
    o.created_at, -- for Orders by Hour
    a.delivery_address1, -- for Orders by Address
    a.delivery_address2, -- for Orders by Address
    a.delivery_city, -- for Orders by Address
    a.delivery_zipcode, -- for Orders by Address
    o.delivery -- for Orders by Delivery
-- we must now join the 3 tables (o,i,a)
FROM
    orders o 
LEFT JOIN
    item i ON o.item_id = i.item_id
LEFT JOIN
    address a ON o.add_id = a.add_id;


/*Dashboard 2 - Inventory Management*/
/*Ben wants us to:

1. Identify how much inventory the pizzeria uses in a month.
2. Identify what inventory that needs reordering.
3. Calculate how much each pizza costs to make.ben wants to keep an eye on profit/loss (P/L)
---
For that we will need:
-1. Total Quantity by Ingredient (No. orders per item x ingredient quantity in recipe)
-2. Total Cost of Ingredients
-3. Cost of Each Pizza
-4. Percentage of Remaining Stock by Ingredient. 
-5. List of ingredients to re-order based on remaining inventory*/

-- we first fetch the number of orders per item
SELECT 
    o.item_id AS ordered_item_id,
    i.sku , -- the recipe_id
    i.item_name,
    SUM(o.quantity) AS order_quantity 
    -- To get the total quantity ordered from each item
FROM
    orders o
LEFT JOIN item i ON o.item_id = i.item_id
GROUP BY o.item_id, i.sku, i.item_name;

-- we join to the table above the recipe table to find out how much ingredients each pizza uses, and to the ingredient table to get the ingredients names

SELECT 
    o.item_id AS ordered_item_id,
    i.sku , -- the recipe_id
    i.item_name,
    re.ing_id,
    re.quantity AS ingredient_quantity,
    -- To get the total quantity ordered from each item
    SUM(o.quantity) AS order_quantity,
    -- To get the name and the cost of each ingredient we use
    ig.ing_name AS ingredient_name,
    ig.ing_weight,
    ig.ing_price

FROM
    orders o
LEFT JOIN item i ON o.item_id = i.item_id
LEFT JOIN recipe re ON re.recipe_id = i.sku
LEFT JOIN ingredient ig ON ig.ing_id = re.ing_id
GROUP BY 
    o.item_id,
    i.sku,
    i.item_name,
    re.ing_id,
    re.quantity, 
    ig.ing_name,
    ig.ing_weight,
    ig.ing_price;


-- we need to multiply the ordered quantity of each item by the recipe quantity. (we can't do that in the select statement above since the ordered quant is aggregated )

-- we turn into a subquery the block above
CREATE VIEW stock1 AS
SELECT 
    s1.item_name,
    s1.ing_id,
    s1.ingredient_name,
    s1.order_quantity,
    s1.recipe_quantity,
    s1.recipe_quantity*s1.order_quantity AS ordered_weight,
    s1.ing_price/s1.ing_weight AS unit_cost,
    (s1.recipe_quantity*s1.order_quantity)*(s1.ing_price/s1.ing_weight) AS ingredient_cost
FROM (
    SELECT 
        o.item_id AS ordered_item_id,
        i.sku , -- the recipe_id
        i.item_name,
        re.ing_id,
        re.quantity AS recipe_quantity,
        -- To get the total quantity ordered from each item
        SUM(o.quantity) AS order_quantity,
        -- To get the name and the cost of each ingredient we use
        ig.ing_name AS ingredient_name,
        ig.ing_weight,
        ig.ing_price
    FROM
        orders o
    LEFT JOIN item i ON o.item_id = i.item_id
    LEFT JOIN recipe re ON re.recipe_id = i.sku
    LEFT JOIN ingredient ig ON ig.ing_id = re.ing_id
    GROUP BY 
        o.item_id,
        i.sku,
        i.item_name,
        re.ing_id,
        re.quantity, 
        ig.ing_name,
        ig.ing_weight,
        ig.ing_price
    ) AS s1
-- as in select statement 1
;


/*We have created the query we needed for points 1,2 and 3, now we need one for points 4 and 5. This query will be based on the first one. To make things easier we are going to turn the previous query into a VIEW ( a way to save our previous table) by adding CREATE VIEW statement + name_view + AS, before the select statement.*/

/*our view is called stock1 , we will use it to calculate:
-1. Total weight ordered.
-2. Inventory amount.
-3. Inventory remaining per ingredient.*/

--- Total weight in stock = ing.quantity * ing.weight
--- Remaining weight = (ing.ing_weight * inv.quantity) - s2.ordered weight

SELECT 
    s2.ing_name,
    s2.ordered_weight,
    ing.ing_weight*inv.quantity AS total_inv_weight,
    (ing.ing_weight * inv.quantity) - s2.ordered_weight AS remaining_weight
FROM
    (SELECT 
        ing_id,
        ing_name,
        sum(ordered_weight) AS ordered_weight
    FROM
        stock1
    GROUP BY ing_name,ing_id) S2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN ingredient ing ON ing.ing_id = s2.ing_id;

---------------------------------------------------------

/* Dashboard 3 : Staff analysis 
    We want to calculate the staff cost (per row).
    To do that we need to calculate how many hours the staff's shift lasts and then multiply it by the hourly rate */

SELECT
    r.date,
    r.time_of_day,
    st.first_name,
    st.last_name,
    st.hourly_rate,
    sh.start_time,
    sh.end_time,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.end_time, sh.start_time)) / 3600, 1) AS shift_duration_hours,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.end_time, sh.start_time)) / 3600, 1)*st.hourly_rate AS staff_cost
FROM rota r
LEFT JOIN staff st ON r.staff_id = st.staff_id
LEFT JOIN shift sh ON sh.shift_id = r.shift_id;


SELECT
    start_time,
    end_time,
    ROUND(TIME_TO_SEC(TIMEDIFF(end_time, start_time)) / 3600, 1) AS shift_duration_hours
FROM
    shift;

-------------------------------------------------------------
SELECT
    inv.item_id,
    ing.ing_name,
    ing.ing_price,
    inv.quantity,
    re.recipe_id,
    re.quantity
FROM
    inventory inv
LEFT JOIN
    ingredient ing ON inv.item_id =ing.ing_id
LEFT JOIN
    recipe re ON inv.item_id = re.ing_id;





SELECT 
    s2.ing_name,
    s2.ordered_weight,
    ing.ing_weight*inv.quantity AS total_inv_weight,
    (ing.ing_weight * inv.quantity) - s2.ordered_weight AS remaining_weight
FROM
    order_weigh_of_ing AS s2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN ingredient ing ON ing.ing_id = s2.ing_id;