-- 1. Create and select the database
DROP DATABASE IF EXISTS quickbites_db;
CREATE DATABASE if not exists quickbites_db;
USE quickbites_db;

-- 2. Create Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) DEFAULT 'New York',
    join_date DATE
);

-- 3. Create Restaurants Table
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50),
    rating DECIMAL(2,1)
);

-- 4. Create Orders Table (with Foreign Keys)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    total_amount DECIMAL(6,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);



--Sample Data Insertion


-- Insert Sample Customers
INSERT INTO customers (first_name, last_name, city, join_date) VALUES
('Alice', 'Smith', 'New York', '2025-01-15'),
('Bob', 'Jones', 'Los Angeles', '2025-02-20'),
('Charlie', 'Brown', 'New York', '2025-03-10'),
('Diana', 'Prince', 'Chicago', '2025-05-12'),
('Evan', 'Wright', 'Los Angeles', '2025-06-01');

-- Insert Sample Restaurants
INSERT INTO restaurants (name, cuisine_type, rating) VALUES
('Pizza Planet', 'Italian', 4.5),
('Burger Shack', 'American', 4.2),
('Taco Fiesta', 'Mexican', 3.9),
('Wok Express', 'Asian', 4.7),
('Green Garden', 'Salads', 4.1);

-- Insert Sample Orders
INSERT INTO orders (customer_id, restaurant_id, order_date, total_amount, status) VALUES
(1, 1, '2026-05-01', 25.50, 'Delivered'),
(2, 2, '2026-05-02', 18.75, 'Delivered'),
(3, 1, '2026-05-02', 42.00, 'Delivered'),
(1, 4, '2026-05-03', 15.00, 'Cancelled'),
(4, 3, '2026-05-04', 22.10, 'Delivered'),
(2, 4, '2026-05-05', 35.40, 'Delivered'),
(5, 2, '2026-05-06', 12.50, 'Pending'),
(3, 5, '2026-05-06', 28.00, 'Delivered'),
(1, 2, '2026-05-07', 19.50, 'Delivered'),
(4, 1, '2026-05-08', 55.00, 'Delivered');



-- 10 Practice Queries
-- 1. Find all restaurants that have a rating of 4.5 or higher.

SELECT name, cuisine_type, rating 
FROM restaurants 
WHERE rating >= 4.5;

-- 2.List all orders from most expensive to least expensive.
SELECT order_id, total_amount, status 
FROM orders 
ORDER BY total_amount DESC;

-- 3.Find orders that were delivered and cost more than $20

SELECT order_id, total_amount, status 
FROM orders 
WHERE status = 'Delivered' AND total_amount > 20;
select * from orders;

-- 4.Get the total revenue and the average order amount from all completed orders.

SELECT SUM(total_amount) AS total_revenue, AVG(total_amount) AS average_order_value
FROM orders
WHERE status = 'Delivered';


-- 5.Count how many customers live in each city.

SELECT city, COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city;

-- 6.Find the total amount spent at each restaurant, ordered from highest sales to lowest.

SELECT restaurant_id, SUM(total_amount) AS total_sales
FROM orders
GROUP BY restaurant_id
ORDER BY total_sales DESC;


-- 7.Find all orders that are more expensive than the overall average order amount.
SELECT order_id, total_amount 
FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- 8.Find the names of customers who have placed at least one 'Cancelled' order.

SELECT first_name, last_name 
FROM customers 
WHERE customer_id IN (SELECT customer_id FROM orders WHERE status = 'Cancelled');

-- 9.See the customer's name alongside their order details.

SELECT o.order_id, c.first_name, c.last_name, o.total_amount, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 10.Get a complete picture of who ordered what, from where, and how much it cost.

SELECT o.order_id, c.first_name AS customer, r.name AS restaurant, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_id;
