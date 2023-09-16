/**1. What are the details of all cars purchased in the year 2022?**/

SELECT group_concat(sale_id) as 'Sale_id', t2.make, t2.type, t2.style, t2.cost_$ 
FROM sales t1 LEFT JOIN cars t2 on t1.car_id = t2.car_id
where strftime('%Y', t1.purchase_date) = '2022'
group by t2.make, t2.type, t2.style, t2.cost_$