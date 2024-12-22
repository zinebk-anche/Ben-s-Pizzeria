USE pizzeria_project;
select count(*) from recipe;
select * FROM orders;









SHOW CREATE TABLE orders;

ALTER TABLE `rota`
ADD COLUMN `time_of_day` varchar(20) NOT NULL;


ALTER TABLE `orders`
MODIFY COLUMN `created_at` TIME NOT NULL;

ALTER TABLE `orders`
ADD COLUMN `created_date` DATE NOT NULL;
