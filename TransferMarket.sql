--How many different players made an appearance in the Premier League this season (2022)?

SELECT COUNT(DISTINCT player_id) [Players who made Appearances This Season] FROM [Transfer Market].dbo.appearances
WHERE competition_id = 'GB1' AND date BETWEEN '2022-08-05' AND '2023-05-28'

-- Show a list of all players who played in all 38 games in 2022-23 and the clubs they played for?

SELECT player_name, C.name [Club Name], COUNT(player_id) [Number of Premier League Appearances This Season] FROM [Transfer Market].dbo.appearances A
JOIN [Transfer Market].dbo.clubs C ON A.player_club_id = C.club_id
WHERE competition_id = 'GB1' AND date BETWEEN '2022-08-05' AND '2023-05-28'
GROUP BY player_name, C.name, player_club_id
HAVING COUNT(player_id) = 38
ORDER BY 2 ASC

--Show all the data for the most recent game where the total number of goals was above 5

SELECT TOP 1 * FROM [Transfer Market].dbo.games
WHERE home_club_goals + away_club_goals > 5
ORDER BY date DESC

----Who scored in this game?

SELECT name Name FROM [Transfer Market].dbo.players
WHERE player_id IN (SELECT DISTINCT player_id FROM [Transfer Market].dbo.game_events
WHERE game_id = (SELECT TOP 1 game_id FROM [Transfer Market].dbo.games
WHERE home_club_goals + away_club_goals > 5
ORDER BY date DESC)
AND type = 'Goals')

--What was the total attendance at each stadium for the whole Bundesliga season?

SELECT stadium, SUM(attendance) [Total Attendance] FROM [Transfer Market].dbo.games
WHERE competition_id = 'L1' AND date BETWEEN '2022-08-05' AND '2023-05-27'
GROUP BY stadium
ORDER BY [Total Attendance] DESC

-- I am the Chairman of Everton FC. Following our near relegation miss, we are looking to strengthen our team for the next few seasons.
-- I would like to bring in a star striker and have a budget of 30 million euros.
-- Suggest 5 strikers, currently playing in Europe, that we could potentially bring into our squad.

---- Important factors
--Not recently injured (appearances above 50 for the last 3 years)
--Below 26 years old
--Goals per 90 minutes is important for a striker
--Who do they currently play for?

SELECT TOP 5 P.name, SUM(A.goals) Goals, COUNT(DISTINCT A.appearance_id) Appearances,

ROUND(SUM(Cast(A.goals AS float))/(SUM(CAST(A.minutes_played AS float))/90), 2) [Goals Per 90],

ROUND(SUM(Cast(A.goals AS float))/COUNT(DISTINCT A.appearance_id), 2) [Goals Per Game],

P.market_value_in_eur [Market Value in Euros], DATEDIFF(YEAR, P.date_of_birth,

GETDATE()) Age, C.name [Current Club]

FROM [Transfer Market].dbo.players P

JOIN [Transfer Market].dbo.appearances A
ON P.player_id = A.player_id
JOIN [Transfer Market].dbo.competitions C
ON C.competition_id = A.competition_id
WHERE sub_position = 'Centre-Forward'
AND P.last_season = 2022 AND A.date BETWEEN '2020-07-01' AND '2023-07-01'
AND P.market_value_in_eur < 30000000 AND DATEDIFF(YEAR, P.date_of_birth, GETDATE()) < 26
GROUP BY P.name, P.date_of_birth, P.market_value_in_eur, C.name
HAVING COUNT(A.appearance_id) >= 50
AND ROUND(SUM(Cast(A.goals AS float))/(SUM(CAST(A.minutes_played AS float))/90), 2) > 0.3
ORDER BY [Goals Per 90] DESC

--Last 3 seasons for Haji Wright
SELECT G.season, SUM(A.goals) Goals, SUM(A.assists) Assists, SUM(A.goals) + SUM(A.assists) [Goal Contributions],

COUNT(DISTINCT A.appearance_id) Appearances, SUM(CAST(A.minutes_played AS float)) [Minutes Played],

ROUND(SUM(Cast(A.goals AS float))/(SUM(CAST(A.minutes_played AS float))/90), 2) [Goals Per 90], CL.name

FROM [Transfer Market].dbo.players P

JOIN [Transfer Market].dbo.appearances A
ON P.player_id = A.player_id
JOIN [Transfer Market].dbo.competitions C
ON C.competition_id = A.competition_id
JOIN [Transfer Market].dbo.games G
ON A.game_id = G.game_id
JOIN clubs CL
ON A.player_club_id = CL.club_id
WHERE A.date BETWEEN '2019-07-01' AND '2023-07-01' AND P.player_id = 315291 AND season IN (2020, 2021, 2022)
GROUP BY G.season, CL.name
ORDER BY G.season DESC

-- TOP 10 Goals Per 90 in Super Lig 22/23

SELECT TOP 10 P.name, SUM(A.goals) Goals, COUNT(DISTINCT A.appearance_id) Appearances,

SUM(CAST(A.minutes_played AS float)) [Minutes Played],

ROUND(SUM(Cast(A.goals AS float))/(SUM(CAST(A.minutes_played AS float))/90), 2) [Goals Per 90]

FROM [Transfer Market].dbo.players P

JOIN [Transfer Market].dbo.appearances A
ON P.player_id = A.player_id
JOIN [Transfer Market].dbo.competitions C
ON C.competition_id = A.competition_id
WHERE P.last_season = 2022 AND A.date BETWEEN '2022-07-01' AND '2023-07-01'
AND C.name = 'super-lig'
GROUP BY P.name, P.date_of_birth, P.market_value_in_eur, C.name
HAVING SUM(CAST(A.minutes_played AS float)) >=900
ORDER BY [Goals Per 90] DESC

--Market Value for last three seasons Haji Wright
SELECT DATEPART(YEAR, V.date) Year, ROUND(AVG(CAST(V.market_value_in_eur AS FLOAT)), 2) [Market Value] FROM player_valuations V
JOIN players P
ON V.player_id = P.player_id
WHERE P.player_id = 315291 AND DATE BETWEEN '2020' AND '2023'
GROUP BY DATEPART(YEAR, V.date)