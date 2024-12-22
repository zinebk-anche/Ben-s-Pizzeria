CREATE TABLE `address` (
  `add_id` int PRIMARY KEY,
  `delivery_address1` varchar(200),
  `delivery_address2` varchar(200),
  `delivery_city` varchar(50),
  `delivery_zipcode` varchar(20)
);

CREATE TABLE `customers` (
  `cust_id` int PRIMARY KEY,
  `cust_firstname` varchar(50),
  `cust_lastname` varchar(50)
);

CREATE TABLE `ingredient` (
  `ing_id` varchar(10) PRIMARY KEY,
  `ing_name` varchar(200),
  `ing_weight` int,
  `ing_meas` varchar(20),
  `ing_price` decimal(5,2)
);

CREATE TABLE `inventory` (
  `inv_id` int PRIMARY KEY,
  `item_id` varchar(10),
  `quantity` int
);

CREATE TABLE `item` (
  `item_id` varchar(10) PRIMARY KEY,
  `sku` varchar(50) UNIQUE,
  `item_name` varchar(100),
  `item_cat` varchar(100),
  `item_size` varchar(10),
  `item_price` decimal(10,2)
);

CREATE TABLE `orders` (
  `row_id` int PRIMARY KEY,
  `order_id` varchar(10),
  `created_at` time,
  `quantity` int,
  `delivery` tinyint(1),
  `item_id` varchar(15),
  `cust_id` int,
  `add_id` int,
  `rota_id` varchar(20),
  `time_of_day` varchar(20),
  `created_date` date
);

CREATE TABLE `recipe` (
  `row_id` int PRIMARY KEY,
  `recipe_id` varchar(20),
  `ing_id` varchar(10),
  `quantity` int
);

CREATE TABLE `rota` (
  `row_id` int PRIMARY KEY,
  `rota_id` varchar(20),
  `date` datetime,
  `shift_id` varchar(20),
  `staff_id` varchar(20),
  `time_of_day` varchar(20)
);

CREATE TABLE `shift` (
  `shift_id` varchar(20) PRIMARY KEY,
  `day_of_week` varchar(10),
  `start_time` time,
  `end_time` time
);

CREATE TABLE `staff` (
  `staff_id` varchar(20) PRIMARY KEY,
  `first_name` varchar(50),
  `last_name` varchar(50),
  `position` varchar(100),
  `hourly_rate` decimal(5,2)
);

ALTER TABLE `inventory` ADD FOREIGN KEY (`item_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`cust_id`) REFERENCES `customers` (`cust_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`add_id`) REFERENCES `address` (`add_id`);

ALTER TABLE `recipe` ADD FOREIGN KEY (`recipe_id`) REFERENCES `item` (`sku`);

ALTER TABLE `recipe` ADD FOREIGN KEY (`ing_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `rota` ADD FOREIGN KEY (`shift_id`) REFERENCES `shift` (`shift_id`);

ALTER TABLE `rota` ADD FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
