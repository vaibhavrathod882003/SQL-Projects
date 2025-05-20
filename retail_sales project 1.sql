create database sql_project;
use sql_project;

select * from retail_sales;
#calculate how many rows in dataset
select count(*) from retail_sales;

#show only the 10 rows in dataset
-- select * from retail_sales
-- limit 10;

#cheak null values in all culumns in dataset
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;
-- select * from retail_sales;

# you can check one time of all columns in your dataset
select * from retail_sales
where
    transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or 
    gender is null
    or 
    category is null
    or 
    quantiy is null
    or 
    cogs is null
    or 
    total_sale is null;

#if we have null records for in dataset so you can delete the null records
delete from retail_sales
where
    transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or 
    gender is null
    or 
    category is null
    or 
    quantiy is null
    or 
    cogs is null
    or 
    total_sale is null;
 
set sql_safe_updates=0;
#now data exploration is done & data cleaning also done
#Q).How many sales we have?
-- select * from retail_sales;
select count(*) as "total_Sales" from retail_sales;


#Data analysis & business key problem & answer
#Q1).Write a SQL query to retrieve all columns for sales mode on '2022-11-05'
select * from retail_sales
where sale_date = '05-11-2022';
#Q2).Write a SQL query to retrieve all transactions where the category is "Clothing"
# and the quantiy sold is more than 10/4 in the month of nov-2022
select * from retail_sales
where category = "Clothing"
and 
quantiy >= 4
and
sale_date = '09-11-2022';

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 2.5
  AND sale_date >= '2022-11-01'
  AND sale_date <= '2022-11-30';
  
  
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 2.5
  AND STR_TO_DATE(sale_date, '%d-%m-%Y') >= '2022-11-01'
  AND STR_TO_DATE(sale_date, '%d-%m-%Y') < '2022-12-01';


#Q3).Write a sql query to calculate the total_sales?
select category,sum(total_sale) as 'net_sale',
count(*) as "total_orders"
from retail_sales 
group by category;

#Q4).Write a sql query to find the average age
#of customers who purchased items from "Beauty" category
select avg(age) as "avg_age"
from retail_sales
where category = "Beauty";

#Q5).Write a sql query to find all transaction
#where the total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000;

#Q6).Write a SQL query to find the total number
#of transactions (transaction_id) made by each gender in each category
select category,gender, count(transactions_id)
from retail_sales
group by category,gender;

#Q8).Write a sql query to find the top 5 customer
# based on the highest total sales
select * from retail_sales;
select customer_id,sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc limit 5;

