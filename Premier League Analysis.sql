--Who won the league and how many points did they finish with?
SELECT Team, Points FROM weeklyrank
WHERE Points = (SELECT MAX(Points) FROM weeklyrank);

--How many points did Man United finish with?
SELECT DISTINCT Team, Points FROM weeklyrank
WHERE Points = (SELECT MAX(Points) FROM weeklyrank WHERE Team = 'Man United') AND Team = 'Man United';

--After which game did Chelsea surpass 50 points?
SELECT TOP 1 * FROM [soccer21-22] [s22]
JOIN weeklyrank wr
ON [s22].Week = wr.Week
WHERE Team = 'Chelsea' AND Points > 50 AND HomeTeam = 'Chelsea' OR Team = 'Chelsea' AND Points > 50 AND AwayTeam = 'Chelsea';

--Who were the top 5 Teams in shot conversion in the league?
SELECT TOP 5 AwayTeam, ROUND(SUM(CAST((FTAG + FTHG) as float))*100/SUM(CAST(([AS] + HS)  as float)), 2) as 'Shot Conversion Percentage' FROM [soccer21-22]
GROUP BY AwayTeam
ORDER BY 2 desc;

--What was Burnley's Goal Difference when they played Liverpool at Turf Moor?
SELECT Team, GD FROM weeklyrank wr
JOIN [soccer21-22] [s22]
ON [s22].Week = wr.Week
WHERE HomeTeam = 'Burnley' AND AwayTeam = 'Liverpool' AND Team = 'Burnley';

--Which Team conceded the fewest number of goals at home? What was this number?
SELECT TOP 1 HomeTeam, SUM(FTAG) 'Goals Conceded at Home' FROM [soccer21-22]
GROUP BY HomeTeam
ORDER BY 2;

--Show each team's goal difference and points at the end of the season. Rank by points
SELECT Team, MAX(GD) GD, MAX(Points) Points FROM weeklyrank
GROUP BY Team
ORDER BY 3 desc;

--Show data from all of Newcastle's games and use this to create a view
CREATE VIEW Newcastle AS
SELECT Date, [soccer21-22].Week, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, [AS], HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, GD, Points, Rank FROM [soccer21-22]
JOIN weeklyrank
ON [soccer21-22].Week = weeklyrank.Week
WHERE HomeTeam LIKE 'Newcastle%' AND Team = 'Newcastle'
OR AwayTeam LIKE 'Newcastle%' AND Team = 'Newcastle';