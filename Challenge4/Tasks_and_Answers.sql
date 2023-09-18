/**1. What are the names of all the customers who live in New York?**/
SELECT FirstName || ' ' || LastName as 'Full Name'
FROM Customers
WHERE City = 'New York'

/**2. What is the total number of accounts in the Accounts table?**/
Select COUNT(AccountID) as 'Number of Accounts'
from Accounts

/**3. What is the total balance of all checking accounts?**/
Select SUM(Balance) as 'Total Balance'
from Accounts
WHERE AccountType = 'Checking'

/**4. What is the total balance of all accounts associated with customers who live in Los Angeles?**/
Select SUM(BALANCE) as 'Total Balance'
from Accounts t1 left join Customers t2 on t1.CustomerID = t2.CustomerID
WHERE t2.City = 'Los Angeles'

/**5. Which branch has the highest average account balance?**/
with top_average_branch as
(
SELECT BranchID, ROUND(AVG(Balance), 2) as 'Average',
ROW_NUMBER() OVER (order by ROUND(AVG(Balance), 2) DESC, BranchID) as 'Top_Average'
FROM Accounts
GROUP BY BranchID
  )
 SELECT t1.BranchID, t1.BranchName FROM Branches t1 join top_average_branch t2 on t1.BranchID = t2.BranchID
 WHERE t2.Top_Average = 1

/**6. Which customer has the highest current balance in their accounts?**/
with customer_balance as
(
SELECT CustomerID,
row_number() over (Order by SUM(Balance) DESC, CustomerID) as 'Top_Balance'
FROM Accounts
GROUP BY CustomerID
ORDER BY SUM(Balance) DESC
  )
  SELECT t1.FirstName || ' ' || t1.LastName as 'Full Name' 
  from Customers t1 join customer_balance t2 on t1.CustomerID = t2.CustomerID
  WHERE t2.Top_Balance = 1

/**7. Which customer has made the most transactions in the Transactions table?**/
with top_transactions as 
(
  SELECT t1.CustomerID, COUNT(t2.TransactionID) as 'count_transactions'
from Accounts t1 join Transactions t2 on t1.AccountID = t2.AccountID
GROUP BY t1.CustomerID
HAVING COUNT(t2.TransactionID) = 
(SELECT MAX(_count) FROM 
 (
  SELECT t1.CustomerID, COUNT(t2.TransactionID) as '_count'
from Accounts t1 join Transactions t2 on t1.AccountID = t2.AccountID
GROUP BY t1.CustomerID
   )
 )
)
SELECT t3.CustomerID, t3.FirstName || ' ' || t3.LastName as 'Full Name', t4.count_transactions 
FROM Customers t3 join top_transactions t4 on t3.CustomerID = t4.CustomerID

/**8.Which branch has the highest total balance across all of its accounts?**/
with highest_balance as
(
SELECT BranchID, ROUND(SUM(Balance), 2) as 'Total',
ROW_NUMBER() OVER (order by ROUND(SUM(Balance), 2) DESC, BranchID) as 'Top_Total'
FROM Accounts
GROUP BY BranchID
 )
 SELECT t1.BranchID, t1.BranchName 
 FROM Branches t1 join highest_balance t2 on t1.BranchID = t2.BranchID
 WHERE t2.Top_Total = 1

/**9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?**/
with highest_balance as
(
SELECT CustomerID, ROUND(SUM(Balance), 2) as 'Total',
ROW_NUMBER() OVER (order by ROUND(SUM(Balance), 2) DESC, CustomerID) as 'Top_Total'
FROM Accounts
GROUP BY CustomerID
 )
 SELECT t1.CustomerID, t1.FirstName || ' ' || t1.LastName as 'Full Name', t2.Total
 FROM Customers t1 join highest_balance t2 on t1.CustomerID = t2.CustomerID
 WHERE t2.Top_Total = 1

/**10. Which branch has the highest number of transactions in the Transactions table?**/
with top_transactions as 
(
  SELECT t1.BranchID, COUNT(t2.TransactionID) as 'count_transactions'
from Accounts t1 join Transactions t2 on t1.AccountID = t2.AccountID
GROUP BY t1.BranchID
HAVING COUNT(t2.TransactionID) = 
(SELECT MAX(_count) FROM 
 (
  SELECT t1.BranchID, COUNT(t2.TransactionID) as '_count'
from Accounts t1 join Transactions t2 on t1.AccountID = t2.AccountID
GROUP BY t1.BranchID
   )
 )
)
SELECT t3.BranchID, t3.BranchName, t4.count_transactions 
FROM Branches t3 join top_transactions t4 on t3.BranchID = t4.BranchID
