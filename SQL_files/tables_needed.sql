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

CREATE VIEW ingredient_usage_per_order AS
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
        ig.ing_price;

CREATE VIEW stock1 AS
SELECT 
    item_name,
    ing_id,
    ingredient_name,
    order_quantity,
    recipe_quantity,
    recipe_quantity * order_quantity AS ordered_weight,
    ing_price / ing_weight AS unit_cost,
    (recipe_quantity * order_quantity) * (ing_price / ing_weight) AS ingredient_cost
FROM ingredient_usage_per_order;

CREATE VIEW ordered_weight_of_ing AS
SELECT 
        ing_id,
        ingredient_name,
        SUM(ordered_weight) AS ordered_weight
    FROM
        stock1
    GROUP BY ingredient_name, ing_id;

CREATE VIEW stock2 AS
SELECT 
    ow.ingredient_name,
    ow.ordered_weight,
    ing.ing_weight * inv.quantity AS total_inv_weight,
    (ing.ing_weight * inv.quantity) - ow.ordered_weight AS remaining_weight
FROM
    ordered_weight_of_ing ow
LEFT JOIN inventory inv ON inv.item_id = ow.ing_id
LEFT JOIN ingredient ing ON ing.ing_id = ow.ing_id;

-- Dashboard 3 - Staff analysis
CREATE VIEW staff_data AS
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
