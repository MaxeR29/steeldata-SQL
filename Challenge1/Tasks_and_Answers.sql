/**1. What are the details of all cars purchased in the year 2022?**/
SELECT group_concat(sale_id) as 'Sale_id', t2.make, t2.type, t2.style, t2.cost_$ 
FROM sales t1 LEFT JOIN cars t2 on t1.car_id = t2.car_id
where strftime('%Y', t1.purchase_date) = '2022'
group by t2.make, t2.type, t2.style, t2.cost_$

/**2. What is the total number of cars sold by each salesperson?**/
SELECT t1.salesman_id, t2.name, COUNT(t1.sale_id) as 'Total_number_of_sales'
FROM sales t1 left join salespersons t2 on t1.salesman_id=t2.salesman_id
group by t1.salesman_id, t2.name;

/**3. What is the total revenue generated by each salesperson?**/
SELECT t1.salesman_id, t2.name, SUM(t3.cost_$) as 'Total Revenue'
FROM sales t1 left join salespersons t2 on t1.salesman_id=t2.salesman_id
			left join cars t3 on t1.car_id=t3.car_id
group by t1.salesman_id, t2.name

/**4. What are the details of the cars sold by each salesperson?**/
SELECT t1.salesman_id, t2.name, t3.make, t3.type, t3.style, t3.cost_$ 
FROM sales t1 left join salespersons t2 on t1.salesman_id=t2.salesman_id
			left join cars t3 on t1.car_id=t3.car_id
group by t1.salesman_id, t2.name, t3.make, t3.type, t3.style, t3.cost_$

/**5. What is the total revenue generated by each car type?**/
SELECT group_concat(t1.sale_id), t2.type, SUM(t2.cost_$) as 'Total_Revenue_by_car_type'
FROM sales t1 left join cars t2 on t1.car_id = t2.car_id
group by t2.type order by SUM(t2.cost_$) DESC

/**6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?**/
SELECT t2.name, t1.purchase_date, t3.make, t3.type, t3.style, t3.cost_$ 
FROM sales t1 LEFT join salespersons t2 on t1.salesman_id = t2.salesman_id
			LEFT JOIN cars t3 on t1.car_id = t3.car_id
where strftime('%Y', t1.purchase_date) = '2021'
	AND t2.name = 'Emily Wong'

/**7. What is the total revenue generated by the sales of hatchback cars?**/
/**8. What is the total revenue generated by the sales of SUV cars in the year 2022?**/
/**9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?**/
/**10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?**/