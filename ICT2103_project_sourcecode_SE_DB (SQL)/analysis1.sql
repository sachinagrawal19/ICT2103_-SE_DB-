-- Active: 1668179042838@@127.0.0.1@3306@2103project
SELECT c.case_date, c.total_cases, v.vaccinated, v.non_vaccinated, v.fully_vaccinated, d.total_deaths,
(((LAG(c.total_cases, 0) OVER(ORDER BY c.total_cases)) - (LAG(c.total_cases, 1) OVER(ORDER BY c.total_cases))) / (LAG(c.total_cases, 1) OVER(ORDER BY c.total_cases))) * 100 as percentageincreaseoftotalcasepermonth,
(((LAG(v.vaccinated, 0) OVER(ORDER BY v.vaccinated)) - (LAG(v.vaccinated, 1) OVER(ORDER BY v.vaccinated))) / (LAG(v.vaccinated, 1) OVER(ORDER BY v.vaccinated))) * 100 as percentageincreaseofvaccinatedpermonth,
(((LAG(v.fully_vaccinated, 0) OVER(ORDER BY v.fully_vaccinated)) - (LAG(v.fully_vaccinated, 1) OVER(ORDER BY v.fully_vaccinated))) / (LAG(v.fully_vaccinated, 1) OVER(ORDER BY v.fully_vaccinated))) * 100 as percentageincreaseoffullyvaccinatedpermonth,
(((LAG(d.total_deaths, 0) OVER(ORDER BY d.total_deaths)) - (LAG(d.total_deaths, 1) OVER(ORDER BY d.total_deaths))) / (LAG(d.total_deaths, 1) OVER(ORDER BY d.total_deaths))) * 100 as percentageoftotaldeath
FROM cases c INNER JOIN vaccination v
ON c.case_date = v.vaccination_date
LEFT JOIN death d
ON v.vaccination_date = d.case_date
WHERE c.case_date IN (
SELECT  c.case_date
FROM cases c 
WHERE c.case_date LIKE '202%-%%-01'AND  case_date >= "2020-12-31" AND case_date <= "2021-12-31")