DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(150),
    name VARCHAR(150),
    mrp NUMERIC(10,2),
    discount_percent NUMERIC(5,2),
    available_quantity INTEGER,
    discounted_selling_price NUMERIC(10,2),
    weight_in_gms INTEGER,
    out_of_stock BOOLEAN,
    quantity INTEGER
);

--data exploration
--count of rows
select count(*) from zepto;

--sample data
select * from zepto limit 10;

-- nul values
select * from zepto where name is NULL 
or
mrp is NULL
or
discount_percent is NULL
or
out_of_stock is NULL;

--different product categories
select distinct category
from zepto order by category;

--products in stock vs out of stocks
select out_of_stock, count(sku_id) from zepto 
group by out_of_stock;

--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto group by name
having count(sku_id)>1
order by count(sku_id) DESC;


-- data cleaning
-- products with price zero
select * from zepto where mrp = 0 or discounted_selling_price = 0;

--deleting the row
delete from zepto where mrp = 0;

-- convert paise to rupess
Update zepto
Set mrp = mrp/100.0,
discounted_selling_price = discounted_selling_price/100.0;

-- checking
select mrp,discounted_selling_price from zepto;


--1. Find the top10 best-value products based on the discount percentage.
Select distinct name, mrp, discount_percent from zepto
order by  discount_percent desc
limit 10;

--2. WHat are the Products with High MRP but Out of Stock
select distinct name,mrp from zepto where out_of_stock = true and mrp >300
 order by mrp desc;
 
-- 3. Calculate Estimated Revenue for each category

select category , 
sum(discounted_selling_price * available_quantity) as total_revenue
from zepto group by category
order by total_revenue;

-- .4. Find all products where MRP is greater than 500 and discountpercent is less than 10"
select distinct name, mrp, discount_percent from zepto
where mrp > 500 and discount_percent <10
order by mrp desc, discount_percent desc;

-- 5.Identify the top 5 categories offering the highest average discount percentage.
select category, ROUND(avg(discount_percent),2 )as avg_discount from zepto 
group by category
order by avg_discount DESC
LIMIT 5;

-- . 6.Find the price per gram for products above 100g and sort by best value.
select distinct name, weight_in_gms,discounted_selling_price,
ROUND(discounted_selling_price/weight_in_gms,2) AS price_per_gram
from zepto where weight_in_gms >=100
order by price_per_gram;

-- 7.Group the products into categories like LOw,medium, Bulk.
select distinct name, weight_in_gms, CASE WHEN weight_in_gms <1000 then 'low'
when weight_in_gms < 5000 then 'Medium'
else 'bulk'
end as weight_category
from zepto;

-- .8. what is the Total Inventory weight Ped Category
select category, sum(weight_In_gms* available_Quantity) as total_weight
from zepto
group by category
order by total_weight;

