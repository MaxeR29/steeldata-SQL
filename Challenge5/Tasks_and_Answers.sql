/**1. How many pubs are located in each country?**/
SELECT Country, COUNT(pub_id) as 'Amount of pubs'
FROM Pubs
GROUP BY Country;

/**2. What is the total sales amount for each pub, including the beverage price and quantity sold?**/
select t3.pub_name,  SUM(t2.price_per_unit * t1.quantity)
from sales t1 left join beverages t2 on t1.beverage_id=t2.beverage_id
			left join pubs t3 on t1.pub_id = t3.pub_id
GROUP BY t3.pub_name
ORDER BY t1.pub_id

/**3. Which pub has the highest average rating?**/
with top_ratings as
(
SELECT pub_id, AVG(rating) as 'Rating',
row_number () over (order by AVG(rating) DESC) as 'Top_rating'
from ratings
group by pub_id
  )
 SELECT t1.pub_name, t2.rating
 FROM Pubs t1 join top_ratings t2 on t1.pub_id=t2.pub_id
 WHERE t2.top_rating = 1

/**4. What are the top 5 beverages by sales quantity across all pubs?**/
select row_number() over (order by SUM(t1.quantity) desc, t1.beverage_id) as 'Place',
t2.beverage_name, SUM(t1.quantity) as 'Beverages sales quantity'
from sales t1 join beverages t2 on t1.beverage_id=t2.beverage_id
group by t2.beverage_name
order by sum(quantity) DESC
LIMIT 5

/**5. How many sales transactions occurred on each date?**/
select transaction_date, COUNT(sale_id) as 'Transactions Amount'
from sales
group by transaction_date

/**6. Find the name of someone that had cocktails and which pub they had it in.**/
with transactions_for_coctails as
(
  select t1.pub_id, t2.beverage_name, t1.transaction_date from 
sales t1 left join beverages t2 on t1.beverage_id = t2.beverage_id
where pub_id = '3' and t2.category = 'Cocktail'
  )
select t2.pub_name, t1.customer_name, t3.beverage_name, t3.transaction_date
from ratings t1 join pubs t2 on t1.pub_id=t2.pub_id
			left join transactions_for_coctails t3 on t1.pub_id = t3.pub_id
where t1.review like '%cocktail%';
--Added extra information, because on first look for me it was hard task, 
--but after analyzing it becomes much easier

/**7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?**/
SELECT Category, AVG(price_per_unit) as 'Average Price'
FROM Beverages 
WHERE Category != 'Spirit'
group by category

/**8. Which pubs have a rating higher than the average rating of all pubs?**/
with ranked as 
(
SELECT pub_id, AVG(rating) as 'Average_rating'
FROM ratings
GROUP BY pub_id
  )
  SELECT t1.pub_name, t2.Average_rating
  FROM pubs t1 join ranked t2 on t1.pub_id=t2.pub_id
  WHERE t2.Average_rating > (SELECT AVG(rating) FROM ratings)
  
/**9. What is the running total of sales amount for each pub, ordered by the transaction date?**/
SELECT t2.pub_name, SUM(t1.quantity * t3.price_per_unit), t1.transaction_date
FROM Sales t1 join pubs t2 on t1.pub_id=t2.pub_id
			join beverages t3 on t1.beverage_id=t3.beverage_id
group by t2.pub_name, t1.transaction_date
order by t1.transaction_date

/**10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?**/
with pubs_beverages as 
(
SELECT pub_id, beverage_id
from Sales 
group by pub_id, beverage_id 
order by pub_id
 )
SELECT t1.country, t3.category, AVG(t3.price_per_unit) as 'Average_Per_Unit',
ROUND((SELECT AVG(t6.price_per_unit) 
FROM pubs t4 right join pubs_beverages t5 on t4.pub_id=t5.pub_id
left join beverages t6 on t5.beverage_id = t6.beverage_id
 WHERE t1.country = t4.country
group by t4.country), 2) as 'Average_Per_Country'
 FROM pubs t1 right join pubs_beverages t2 on t1.pub_id=t2.pub_id
 left join beverages t3 on t2.beverage_id = t3.beverage_id
 group by t1.country, t3.category
order by t1.country

/**11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?**/
SELECT t4.pub_id, t4.category, 
ROUND((t4.overall_per_category * 100 / t3.overall_sales), 2) as 'Percentage_Contribution'
, t3.overall_sales FROM 
(
SELECT t1.pub_id, ROUND(SUM(t1.quantity * t2.price_per_unit),2) as 'Overall_sales'
FROM Sales t1 left join Beverages t2 on t1.beverage_id = t2.beverage_id
GROUP BY t1.pub_id
  ) t3 RIGHT JOIN
  (
SELECT t1.pub_id, t2.category, ROUND(SUM(t1.quantity * t2.price_per_unit),2) as 'Overall_per_category'
FROM Sales t1 left join Beverages t2 on t1.beverage_id = t2.beverage_id
GROUP BY t1.pub_id, t2.category
   ) t4 on t3.pub_id = t4.pub_id