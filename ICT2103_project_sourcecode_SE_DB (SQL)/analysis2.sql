-- Active: 1668179042838@@127.0.0.1@3306@2103project
SELECT DISTINCT LAST_DAY(c.case_date) AS case_date, SUM(new_cases) AS newcasepermth, SUM(new_deaths) AS newdeathspermth, 
vaccinated, fully_vaccinated, total_boosters,((SUM(new_cases) - LAG(SUM(new_cases)) 
OVER(ORDER BY case_date))/LAG(SUM(new_cases)) OVER(ORDER BY case_date))*100 AS percentageincreaseofnewcasespermonth,
((SUM(new_deaths) - LAG(SUM(new_deaths)) OVER(ORDER BY case_date))/LAG(SUM(new_deaths))
OVER(ORDER BY case_date))*100 AS percentageincreaseofdeathspermonth,(((LAG(total_boosters, 0) 
OVER(ORDER BY c.case_date)) - (LAG(total_boosters, 1)OVER(ORDER BY c.case_date))) / (LAG(total_boosters, 1) 
OVER(ORDER BY c.case_date))) * 100 AS percentageincreaseofboosterpermonth 

FROM vaccination v 
INNER JOIN cases c 
ON v.vaccination_date = c.case_date 
LEFT JOIN death d 
ON c.case_date = d.death_date 
WHERE c.case_date >= "2022-01-01" AND c.case_date <= "2022-12-31" 
GROUP BY LAST_DAY(c.case_date)