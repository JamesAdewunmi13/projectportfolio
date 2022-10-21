--SHOW THE SCHOOL SEX AGE AND STUDENT ID OF THE HIGHEST SCORER IN THE G3 TEST
SELECT school, sex, age, studentid FROM Maths$
WHERE G3 = (SELECT MAX(G3) FROM Maths$);

--Which students underperformed on the third test?

SELECT studentid, G1 as '1st Term Score', G2 as '2nd Term Score', G3 as 'Final Test Score' FROM Maths$
WHERE G3 < G1 AND G3 < G2;

--Was study time correlated to Final Test performance?

SELECT studytime, ROUND(AVG(G3), 2) FROM Maths$
GROUP BY studytime;

--Did Men or Women Score Higher on Average?

SELECT sex, ROUND(AVG(G3), 2) 'Average Score' FROM Maths$
GROUP BY sex;

--Did travel time have any effect on students scores?

SELECT traveltime, ROUND(AVG(G3), 2) FROM Maths$
GROUP BY traveltime;

--Find all students who beat the score from their previous two tests

SELECT * FROM Maths$
WHERE G3 > G1 AND G3 > G2;


--Did going out clearly affect test scores?
SELECT goout, ROUND(AVG(G1), 2), ROUND(AVG(G2), 2), AVG(G3) FROM Maths$
GROUP BY goout;

--How many Students had only one parent go through higher education?
SELECT COUNT(*) FROM Maths$
WHERE Medu = 'Higher Education' AND Fedu <> 'Higher Education'
OR Fedu = 'Higher Education' AND Medu <> 'Higher Education';

--SHOW Final Test results as a percentage for each studentthat lives in an Rural Neighbourhood
SELECT studentid, ROUND((G3*100)/20, 2) AS 'Percentage' FROM Maths$
WHERE address = 'Rural'
ORDER BY Percentage desc

--How did students with past failures fair?
SELECT studentid, G1, G2, G3, studytime FROM Maths$
WHERE failures > 0
ORDER BY studytime;
