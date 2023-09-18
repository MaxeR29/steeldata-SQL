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
/**7. Which customer has made the most transactions in the Transactions table?**/
/**8.Which branch has the highest total balance across all of its accounts?**/
/**9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?**/
/**10. Which branch has the highest number of transactions in the Transactions table?**/