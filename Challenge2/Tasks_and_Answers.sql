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
SELECT t1.team_name, t2.player_name
FROM Teams t1 left join Players t2 on t1.team_id = t2.team_id and t1.captain_id = t2.player_id
WHERE t1.team_id = 2

/**5. What are the player names and their roles in the team with team_id = 1?**/
SELECT t1.team_id, t2.player_name, t2.role
FROM Teams t1 left join Players t2 on t1.team_id = t2.team_id 
WHERE t1.team_id = 1

/**6. What are the team names and the number of matches they have won?**/
SELECT t2.team_name, t1.match_id
FROM Matches t1 left join Teams t2 on t1.winner_id=t2.team_id
order by t1.match_id

/**7. What is the average salary of players in the teams with country 'USA'?**/
SELECT t1.team_name, Round(AVG(t2.salary), 2)
FROM Teams t1 left join Players t2 on t1.team_id = t2.team_id
WHERE t1.country = 'USA'
GROUP BY t1.team_name

/**8. Which team won the most matches?**/
with winner as 
(
  SELECT winner_id, count(match_id) as 'Amount_win', 
ROW_NUMBER() over (order by count(match_id) desc, winner_id) as 'Top_winner'
FROM Matches
group by winner_id
  )
Select t1.*, t2.amount_win
from Teams t1 left join winner t2 on t1.Team_id = t2.winner_id
WHERE t2.top_winner = 1

/**9. What are the team names and the number of players in each team whose salary is greater than 100,000?**/


/**10. What is the date and the score of the match with match_id = 3?**/
