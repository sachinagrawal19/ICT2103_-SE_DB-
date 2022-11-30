-- Active: 1668179042838@@127.0.0.1@3306@2103project

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS vaccination(
    vaccination_date DATE,
    vaccinated INT(11),
    fully_vaccinated INT(11),
    total_boosters INT(11),
    PRIMARY KEY (vaccination_date)
);

CREATE TABLE IF NOT EXISTS cases(
    case_date DATE,
    total_cases INT(11),
    new_cases INT(11),
    PRIMARY KEY (case_date)
);

CREATE TABLE IF NOT EXISTS influences(
    vaccination_date DATE,
    case_date DATE,
    PRIMARY KEY (vaccination_date, case_date),
    FOREIGN KEY (vaccination_date) REFERENCES vaccination,
    FOREIGN KEY (case_date) REFERENCES cases
);

CREATE TABLE IF NOT EXISTS death(
       death_date DATE,
       case_date DATE,      
       total_deaths INT(11),
       new_deaths INT(11),
       PRIMARY KEY (death_date, case_date),
       FOREIGN KEY (case_date) REFERENCES cases ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hospitalization(
       hospitalization_date DATE,
       case_date DATE,
       hospitalization INT(11),
       PRIMARY KEY (hospitalization_date, case_date),
       FOREIGN KEY (case_date) REFERENCES cases ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS icu(
       icu_date DATE,
       case_date DATE,
       icu INT(11),
       PRIMARY KEY (icu_date, case_date),
       FOREIGN KEY (case_date) REFERENCES cases ON DELETE CASCADE
);



LOAD DATA INFILE
'C:/Users/rylan/OneDrive/Desktop/ICT2103_project_sourcecode_SE_DB (SQL)/owid-covid-data.csv'
INTO TABLE vaccination
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, vaccination_date, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @one, @two, @three, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)

SET
vaccinated = NULLIF(@one, ""),
fully_vaccinated = NULLIF(@two, ""),
total_boosters = NULLIF(@three, "");


ALTER TABLE vaccination
ADD non_vaccinated INT(11);

UPDATE vaccination 
SET non_vaccinated = 5975689 - (vaccinated);


LOAD DATA INFILE
'C:/Users/rylan/OneDrive/Desktop/ICT2103_project_sourcecode_SE_DB (SQL)/owid-covid-data.csv'
INTO TABLE cases
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, case_date, total_cases, new_cases, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy);

LOAD DATA INFILE
'C:/Users/rylan/OneDrive/Desktop/ICT2103_project_sourcecode_SE_DB (SQL)/new-covid-19-hospital-admissions.csv'
INTO TABLE hospitalization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS
(hospitalization_date, hospitalization);

UPDATE hospitalization 
SET case_date = hospitalization_date;

LOAD DATA INFILE
'C:/Users/rylan/OneDrive/Desktop/ICT2103_project_sourcecode_SE_DB (SQL)/new-covid-19-icu-admissions.csv'
INTO TABLE icu
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS
(icu_date, icu);

UPDATE icu
SET case_date = icu_date;

LOAD DATA INFILE
'C:/Users/rylan/OneDrive/Desktop/ICT2103_project_sourcecode_SE_DB (SQL)/owid-covid-data.csv'
INTO TABLE death
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, death_date, @dummy, @dummy, @dummy, @four, @five, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)

SET
total_deaths = NULLIF(@four, ""),
new_deaths = NULLIF(@five, "");

UPDATE death
SET case_date = death_date;