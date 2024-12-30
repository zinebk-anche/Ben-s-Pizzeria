-- Dashboard 1 - Order activity
SELECT
    o.order_id, 
    i.item_price, 
    o.quantity, 
    i.item_cat, 
    i.item_name, 
    o.created_at, 
    a.delivery_address1, 
    a.delivery_address2, 
    a.delivery_city, 
    a.delivery_zipcode, 
    o.delivery 
FROM
    orders o 
LEFT JOIN
    item i ON o.item_id = i.item_id
LEFT JOIN
    address a ON o.add_id = a.add_id;

-- Dashboard 2 - Inventory Management
CREATE VIEW stock1 AS
SELECT 
    s1.item_name,
    s1.ing_id,
    s1.ingredient_name,
    s1.order_quantity,
    s1.recipe_quantity,
    s1.recipe_quantity * s1.order_quantity AS ordered_weight,
    s1.ing_price / s1.ing_weight AS unit_cost,
    (s1.recipe_quantity * s1.order_quantity) * (s1.ing_price / s1.ing_weight) AS ingredient_cost
FROM (
    SELECT 
        o.item_id AS ordered_item_id,
        i.sku,
        i.item_name,
        re.ing_id,
        re.quantity AS recipe_quantity,
        SUM(o.quantity) AS order_quantity,
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
) AS s1;

SELECT 
    s2.ingredient_name,
    s2.ordered_weight,
    ing.ing_weight * inv.quantity AS total_inv_weight,
    (ing.ing_weight * inv.quantity) - s2.ordered_weight AS remaining_weight
FROM
    (SELECT 
        ing_id,
        ingredient_name,
        SUM(ordered_weight) AS ordered_weight
    FROM
        stock1
    GROUP BY ingredient_name, ing_id) s2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN ingredient ing ON ing.ing_id = s2.ing_id;

-- Dashboard 3 - Staff analysis
SELECT
    r.date,
    r.time_of_day,
    st.first_name,
    st.last_name,
    st.hourly_rate,
    sh.start_time,
    sh.end_time,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.end_time, sh.start_time)) / 3600, 1) AS shift_duration_hours,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.end_time, sh.start_time)) / 3600, 1) * st.hourly_rate AS staff_cost
FROM rota r
LEFT JOIN staff st ON r.staff_id = st.staff_id
LEFT JOIN shift sh ON sh.shift_id = r.shift_id;
