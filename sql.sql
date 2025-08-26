use orders;
SET SQL_SAFE_UPDATES = 0;
describe df_orders;
select * from df_orders limit 10;

alter table df_orders 
modify column order_date date;

SELECT order_id, ship_mode, LENGTH(ship_mode) AS len
FROM df_orders
WHERE order_id = 6;

UPDATE df_orders
SET ship_mode = NULL
WHERE ship_mode = '';

/////////////////////////////////////////////////////////////////////////////////////////////////--

select product_id,sum(sale_price) as Sales
from df_orders
group by product_id
order by sales desc
limit 10;

describe df_orders;

with a as(
select region,product_id,sum(sale_price) as Sales
from df_orders
group by region,product_id
)
select * from(
select * ,row_number() over (partition by region order by sales desc) as r
from a)bg
where r<6;



SELECT region, product_id, sales
FROM (
    SELECT 
        region,
        product_id,
        sales,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) AS rn
    FROM (
        SELECT 
            region,
            product_id,
            SUM(sale_price) AS sales
        FROM df_orders
        GROUP BY region, product_id
    ) agg
) ranked
WHERE rn <= 10;


select product_id,city,quantity from (
		select product_id,city,
        quantity ,row_number() over (partition by city order by  quantity desc) as rn
        from(
			select
			product_id,city,sum(quantity) as quantity
            from df_orders
            group by city, product_id
        )at
)mk
where rn<10;


select year(order_date), month(order_date) , sum(sale_price) as sales 
from df_orders
group by year(order_date),month(order_date)
order by month(order_date);

with tc as(
select year(order_date) as order_year, month(order_date) as order_month , sum(sale_price) as sales from df_orders
group by year(order_date), month(order_date))

select order_month
, sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from tc 
group by order_month
order by order_month 
;










