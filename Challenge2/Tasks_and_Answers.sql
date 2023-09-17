/**1. What are the names of the players whose salary is greater than 100,000?**/
SELECT player_name, salary 
FROM Players
WHERE Salary > 100000

/**2. What is the team name of the player with player_id = 3?**/
SELECT t1.player_id, t1.team_id, t2.team_name 
FROM players t1 left join teams t2 on t1.team_id=t2.team_id
WHERE t1.player_id = 3

/**3. What is the total number of players in each team?**/
SELECT t2.team_name, COUNT(t1.player_id) as 'Number_of_players'
FROM Players t1 left join Teams t2 on t1.team_id=t2.team_id
group by t2.team_name

/**4. What is the team name and captain name of the team with team_id = 2?**/


/**5. What are the player names and their roles in the team with team_id = 1?**/


/**6. What are the team names and the number of matches they have won?**/


/**7. What is the average salary of players in the teams with country 'USA'?**/


/**8. Which team won the most matches?**/


/**9. What are the team names and the number of players in each team whose salary is greater than 100,000?**/


/**10. What is the date and the score of the match with match_id = 3?**/
