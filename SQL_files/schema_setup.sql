CREATE TABLE `address` (
  `add_id` int PRIMARY KEY NOT NULL,
  `delivery_address1` varchar(200) NOT NULL,
  `delivery_address2` varchar(200),  -- This can be NULL
  `delivery_city` varchar(50) NOT NULL,
  `delivery_zipcode` varchar(20) NOT NULL
);

CREATE TABLE `customers` (
  `cust_id` int PRIMARY KEY NOT NULL,
  `cust_firstname` varchar(50) NOT NULL,
  `cust_lastname` varchar(50) NOT NULL
);

CREATE TABLE `ingredient` (
  `ing_id` varchar(10) PRIMARY KEY NOT NULL,
  `ing_name` varchar(200) NOT NULL,
  `ing_weight` int NOT NULL,
  `ing_meas` varchar(20) NOT NULL,
  `ing_price` decimal(5,2) NOT NULL
);

CREATE TABLE `inventory` (
  `inv_id` int PRIMARY KEY NOT NULL,
  `item_id` varchar(10) NOT NULL,
  `quantity` int NOT NULL
);

CREATE TABLE `item` (
  `item_id` varchar(10) PRIMARY KEY NOT NULL,
  `sku` varchar(50) UNIQUE NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `item_cat` varchar(100) NOT NULL,
  `item_size` varchar(10) NOT NULL,
  `item_price` decimal(10,2) NOT NULL
);

CREATE TABLE `orders` (
  `row_id` int PRIMARY KEY NOT NULL,
  `order_id` varchar(10) NOT NULL,
  `created_at` time NOT NULL,
  `quantity` int NOT NULL,
  `delivery` tinyint(1) NOT NULL,
  `item_id` varchar(15) NOT NULL,
  `cust_id` int NOT NULL,
  `add_id` int NOT NULL,
  `rota_id` varchar(20) NOT NULL,
  `time_of_day` varchar(20) NOT NULL,
  `created_date` date NOT NULL,
  `shift_id` varchar(15) NOT NULL
);

CREATE TABLE `recipe` (
  `row_id` int PRIMARY KEY NOT NULL,
  `recipe_id` varchar(20) NOT NULL,
  `ing_id` varchar(10) NOT NULL,
  `quantity` int NOT NULL
);

CREATE TABLE `rota` (
  `row_id` int PRIMARY KEY NOT NULL,
  `rota_id` varchar(20) NOT NULL,
  `date` datetime NOT NULL,
  `shift_id` varchar(20) NOT NULL,
  `staff_id` varchar(20) NOT NULL,
  `time_of_day` varchar(20) NOT NULL
);

CREATE TABLE `shift` (
  `shift_id` varchar(20) PRIMARY KEY NOT NULL,
  `day_of_week` varchar(10) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
);

CREATE TABLE `staff` (
  `staff_id` varchar(20) PRIMARY KEY NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `position` varchar(100) NOT NULL,
  `hourly_rate` decimal(5,2) NOT NULL
);

ALTER TABLE `inventory` 
ADD FOREIGN KEY (`item_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `orders` 
ADD FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

ALTER TABLE `orders` 
ADD FOREIGN KEY (`cust_id`) REFERENCES `customers` (`cust_id`);

ALTER TABLE `orders` 
ADD FOREIGN KEY (`add_id`) REFERENCES `address` (`add_id`);

ALTER TABLE `orders` 
ADD FOREIGN KEY (`shift_id`) REFERENCES `shift` (`shift_id`);

ALTER TABLE `recipe` 
ADD FOREIGN KEY (`recipe_id`) REFERENCES `item` (`sku`);

ALTER TABLE `recipe` 
ADD FOREIGN KEY (`ing_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `rota` 
ADD FOREIGN KEY (`shift_id`) REFERENCES `shift` (`shift_id`);

ALTER TABLE `rota` 
ADD FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
