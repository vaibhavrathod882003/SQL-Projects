create database pizzahut;

use pizzahut;

-- 1).Retrieve the total mumber of orders placed?
select  count(order_id) as total_orders  from orders;

-- 2).Calculate the total revenue generated from pizza sales?
SELECT 
    ROUND(SUM(orders_type.quantity * pizza.price),
            2) AS total_revenue_sales
FROM
    orders_type
        JOIN
    pizza ON orders_type.pizza_id = pizza.pizza_id;
    
-- the total revenue sales in pizza is 817860.05

-- 3).Identify the highest-priced pizza?
SELECT 
    pizza_type.name, pizza.price
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- The highest Price pizza name the Greek Pizza and price is 35.95

-- 4).Identify the most common Pizza size orderd?
SELECT 
    pizza.size,
    COUNT(orders_type.order_details_id) AS order_count
FROM
    pizza
        JOIN
    orders_type ON pizza.pizza_id = orders_type.pizza_id
GROUP BY pizza.size
ORDER BY COUNT(orders_type.order_details_id) DESC;

-- The most pizza size orderd in L size and order count is 18526

-- 5).List the top 5 most orderd pizza types along with their quantites?
SELECT 
    pizza_type.name, SUM(orders_type.quantity)
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type_id
        JOIN
    orders_type ON pizza.pizza_id = orders_type.pizza_id 
GROUP BY pizza_type.name
ORDER BY SUM(orders_type.quantity) DESC
LIMIT 5;

-- the top 5 most ordered pizza name is the classic Deluxe Pizza & there quantity is 2453 
-- and the second is the Barbecue chicken pizza & there quantity is 2432
-- third is The Hawailian Pizza there quantity is 2422
-- fourth is The Pepperoni Pizza & there quantity is 2418
-- last is The Thai Chicken Pizza & there quantity is 2371

#Intermediate Que
-- 1).Join the necessary tables to find the total quantity of each pizza orderd?
SELECT 
    pizza_type.category,
    SUM(orders_type.quantity) AS total_quantity
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type_id
        JOIN
    orders_type ON pizza.pizza_id = orders_type.pizza_id
GROUP BY pizza_type.category
ORDER BY total_quantity DESC;
-- The total quantity of each pizza orderd frist is Classic category and total quantity is 14888
-- and second Supreme category and quantity 11987 third is Veggie category and quantity 11649 then last is 
-- Chicken category 11050

-- 2).Determine the distribution of orders by hour of the day?
SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS count_order
FROM
    orders
GROUP BY HOUR(time);

-- 3).Join helevant tables to find the category wise distribution of pizzas?
SELECT 
    category, COUNT(name)
FROM
    pizza_type
GROUP BY category;

-- 4).Group the orders by date and  
-- calculate the average number of pizza orderd per day?
select date, avg(order_id) from orders
group by date;

SELECT 
    ROUND(AVG(quantity), 0) as avg_pizza_per_orderd
FROM
    (SELECT 
        orders.date, SUM(orders_type.quantity) AS quantity
    FROM
        orders
    JOIN orders_type ON orders.order_id = orders_type.order_id
    GROUP BY orders.date) AS order_quantity;
    
-- The avg quantity per day order 138.4749


-- 5).Determine the top 3 most orderd pizza type based on revenue?
SELECT 
    pizza_type.name,
    SUM(orders_type.quantity * pizza.price) AS revenue
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type_id
        JOIN
    orders_type ON pizza.pizza_id = orders_type.pizza_id
GROUP BY pizza_type.name
ORDER BY revenue DESC
LIMIT 3;

-- The top 3 most order by pizza by revenue 1st is the thai chicken pizza revenue is 43434.25
-- and 2nd is the barbecue chicken pizza revenue is 42768 and 
-- the last one is the california chicken pizza revenue is 41409.5

-- Advanced que
-- 1).Calculate the percentage contribution of each pizza type to total revenue?
SELECT 
    pizza_type.category,
    ROUND((SUM(orders_type.quantity * pizza.price) / (SELECT 
                    ROUND(SUM(orders_type.quantity * pizza.price),
                                2) AS total_revenue_sales
                FROM
                    orders_type
                        JOIN
                    pizza ON orders_type.pizza_id = pizza.pizza_id)) * 100,
            2) AS revenue
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type_id
        JOIN
    orders_type ON pizza.pizza_id = orders_type.pizza_id
GROUP BY pizza_type.category
ORDER BY revenue DESC;

-- The classic pizza revenue is the top of percetange of the data sets


-- 2).Analyze the cumutative revenue generated over time?
select date, sum(revenue) over(order by date) as cum_revenue
from
(select orders.date, sum(orders_type.quantity*pizza.price) as revenue
from orders_type join pizza
on orders_type.pizza_id=pizza.pizza_id 
join orders
on orders.order_id=orders_type.order_id group by orders.date) as sales;


-- 3).Determine the top 3 most ordered pizza 
-- types based on revenue for each pizza category?
select name,revenue
from
(select category,name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_type.category,pizza_type.name,
sum((orders_type.quantity) * pizza.price) as revenue
from pizza_type
join pizza
on pizza_type.pizza_type_id=pizza.pizza_type_id 
join orders_type
on orders_type.pizza_id=pizza.pizza_id
group by pizza_type.category,pizza_type.name) as a) as b
where rn<=3;

