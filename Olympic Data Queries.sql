-- 1. How many olympics games have been held?
SELECT COUNT(DISTINCT(Games)) FROM athlete_events;

-- 2. List down all Olympics games held so far
SELECT DISTINCT Year, Season, City FROM athlete_events
order by Year;

-- 3. Mention the total no of nations who participated in each olympics game
select Games, count(distinct NOC) FROM athlete_events
group by Games;

-- 4. how many gold medals where won at the 2012 summer olympics
select count(medal) from athlete_events
where medal = 'Gold' and season = 'summer' and year = 2012;

-- 5. Average Height of an olympic gold winning basketball player in cm
select concat(round(avg(height), 0), " cm") as 'Average Basketball player Height' from athlete_events
where name in
(select distinct name from athlete_events
where Sport='Basketball' and Medal="Gold");

-- 6. How many atheletes have competed at olympic games in total?
select count(distinct ID) from athlete_events;

-- 7. Find the 10 most successful 100m sprinters of all time and rank them from most successful to least successful.
select RANK() OVER(ORDER BY count(medal) DESC, count(case when medal = 'Gold' then 1 end) DESC, count(case when medal = 'Silver' then 1 end) DESC, count(case when medal = 'Bronze' then 1 end) DESC) as 'rank', name, count(case when medal = 'Gold' then 1 end) as 'Gold Medals',
count(case when medal = 'Silver' then 1 end) as 'Silver Medals',
count(case when medal = 'Bronze' then 1 end) as 'Bronze Medals', count(medal) 'Total Medals' from athlete_events
where medal in ('Gold', 'Silver', 'Bronze') and event = 'Athletics Men''s 100 metres'
group by name
order by 'rank'
limit 10;

-- 8. List eqch participating team in the 1992 Winter Olympics and the corresponding number of teammates
select NOC, count(distinct ID) 'teamsize' from athlete_events
where Games = '1992 Winter'
group by NOC
order by teamsize DESC;

-- 9. For all the athletes who have taken part in more than one sport at the Olympics, list them and the sports they've competed in.
select * from athlete_events
where name in (select name from athlete_events
group by name
HAVING count(distinct sport) > 1);

-- 10. Find the 20 most "overweight" event teams (more than 4 member) since 1960.
-- List the number of team mates, average weight of each member, total weight and average BMI for the team .
select Team, Event, Games, count(Name) "Team Size", concat(round(avg(Weight), 2), "kg") as "Average Weight",
concat(sum(weight), "kg") as "Total Weight", avg(Weight/(power(Height/100,2))) "Average BMI" from athlete_events
where height is not null and weight is not null and year >= 1960
group by Team, Event, Games
having count(Name) > 4 and avg(weight) > 30
order by avg(Weight/(power(Height/100,2))) desc, sum(weight) desc
limit 20;