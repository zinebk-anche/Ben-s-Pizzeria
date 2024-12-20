
-- Creating Orders Table
CREATE TABLE `orders` (
  `row_id` INT PRIMARY KEY,
  `order_id` VARCHAR(10) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `quantity` INT NOT NULL,
  `delivery` BOOLEAN NOT NULL,
  `item_id` VARCHAR(15) NOT NULL,
  `cust_id` INT NOT NULL,
  `add_id` INT NOT NULL
);

-- Creating Customers Table
CREATE TABLE `customers` (
  `cust_id` INT PRIMARY KEY,
  `cust_firstname` VARCHAR(50) NOT NULL,
  `cust_lastname` VARCHAR(50) NOT NULL
);

-- Creating Address Table
CREATE TABLE `address` (
  `add_id` INT PRIMARY KEY,
  `delivery_address1` VARCHAR(200) NOT NULL,
  `delivery_address2` VARCHAR(200),  -- This remains nullable
  `delivery_city` VARCHAR(50) NOT NULL,
  `delivery_zipcode` VARCHAR(20) NOT NULL
);

-- Creating Item Table
CREATE TABLE `item` (
  `item_id` VARCHAR(10) PRIMARY KEY,
  `sku` VARCHAR(50) UNIQUE NOT NULL,
  `item_name` VARCHAR(100) NOT NULL,
  `item_cat` VARCHAR(100) NOT NULL,
  `item_size` VARCHAR(10) NOT NULL,
  `item_price` DECIMAL(10,2) NOT NULL
);

-- Creating Ingredient Table
CREATE TABLE `ingredient` (
  `ing_id` VARCHAR(10) PRIMARY KEY,
  `ing_name` VARCHAR(200) NOT NULL,
  `ing_weight` INT NOT NULL,
  `ing_meas` VARCHAR(20) NOT NULL,
  `ing_price` DECIMAL(5,2) NOT NULL
);

-- Creating Recipe Table
CREATE TABLE `recipe` (
  `row_id` INT PRIMARY KEY,
  `recipe_id` VARCHAR(20) NOT NULL,
  `ing_id` VARCHAR(10) NOT NULL,
  `quantity` INT NOT NULL
);

-- Creating Inventory Table
CREATE TABLE `inventory` (
  `inv_id` INT PRIMARY KEY,
  `item_id` VARCHAR(10) NOT NULL,
  `quantity` INT NOT NULL
);

-- Creating Shift Table
CREATE TABLE `shift` (
  `shift_id` VARCHAR(20) PRIMARY KEY,
  `day_of_week` VARCHAR(10) NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL
);

-- Creating Staff Table
CREATE TABLE `staff` (
  `staff_id` VARCHAR(20) PRIMARY KEY,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `position` VARCHAR(100) NOT NULL,
  `hourly_rate` DECIMAL(5,2) NOT NULL
);

-- Creating Rota Table
CREATE TABLE `rota` (
  `row_id` INT PRIMARY KEY,
  `rota_id` VARCHAR(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `shift_id` VARCHAR(20) NOT NULL,
  `staff_id` VARCHAR(20) NOT NULL,
  CONSTRAINT `unique_rota` UNIQUE (`shift_id`, `staff_id`, `date`)
);

-- Adding Foreign Key Constraints
ALTER TABLE `orders` ADD FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);
ALTER TABLE `orders` ADD FOREIGN KEY (`cust_id`) REFERENCES `customers` (`cust_id`);
ALTER TABLE `orders` ADD FOREIGN KEY (`add_id`) REFERENCES `address` (`add_id`);

ALTER TABLE `recipe` ADD FOREIGN KEY (`recipe_id`) REFERENCES `item` (`sku`);
ALTER TABLE `recipe` ADD FOREIGN KEY (`ing_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `inventory` ADD FOREIGN KEY (`item_id`) REFERENCES `ingredient` (`ing_id`);

ALTER TABLE `rota` ADD FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `rota` ADD FOREIGN KEY (`shift_id`) REFERENCES `shift` (`shift_id`);

-- Linking the rotations table to the orders table
ALTER TABLE `orders`
ADD COLUMN `rota_id` VARCHAR(20) NULL;

-- Adding the foreign key constraint to reference `row_id` in `rota`

ALTER TABLE `orders`
MODIFY COLUMN `rota_id` INT NULL;

ALTER TABLE `orders`
ADD CONSTRAINT `fk_orders_rota` FOREIGN KEY (`rota_id`) REFERENCES `rota` (`row_id`);


