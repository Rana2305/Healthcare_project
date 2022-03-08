create database healthcare;
use healthcare;
CREATE TABLE life_expecancy (
    country CHAR(3),
    y15 FLOAT,
    y16 FLOAT,
    y17 FLOAT,
    y18 FLOAT,
    y19 FLOAT
);
CREATE TABLE hospital_beds (
    country CHAR(3),
    y15 FLOAT,
    y16 FLOAT,
    y17 FLOAT,
    y18 FLOAT,
    y19 FLOAT
);
CREATE TABLE health_exp (
    country CHAR(3),
    y15 FLOAT,
    y16 FLOAT,
    y17 FLOAT,
    y18 FLOAT,
    y19 FLOAT
);
CREATE TABLE Physicians (
    country CHAR(3),
    y15 FLOAT,
    y16 FLOAT,
    y17 FLOAT,
    y18 FLOAT,
    y19 FLOAT
);
use healthcare;


CREATE TABLE life_exp_mean (
    country CHAR(3) PRIMARY KEY,
    life_expectancy FLOAT
);
CREATE TABLE hosp_beds_mean (
    country CHAR(3) PRIMARY KEY,
    hospital_beds FLOAT
);
CREATE TABLE health_exp_mean (
    country CHAR(3) PRIMARY KEY,
    health_expenditure FLOAT
);
CREATE TABLE physicians_mean (
    country CHAR(3) PRIMARY KEY,
    physicians FLOAT
);
select * from life_exp_mean;
select * from hosp_beds_mean;
select * from health_exp_mean;
select * from physicians_mean;

CREATE TABLE all_indicators SELECT life_exp_mean.country,
    life_exp_mean.average AS life_expectancy,
    hosp_beds_mean.average AS hospital_beds,
    health_exp_mean.health_expenditure,
    physicians_mean.average AS physicians FROM
    life_exp_mean
        LEFT JOIN
    hosp_beds_mean ON life_exp_mean.country = hosp_beds_mean.country
        LEFT JOIN
    health_exp_mean ON hosp_beds_mean.country = health_exp_mean.country
        LEFT JOIN
    physicians_mean ON hosp_beds_mean.country = physicians_mean.country;

select * from all_indicators;
SELECT 
    MIN(life_expectancy),
    MAX(life_expectancy),
    MIN(hospital_beds),
    MAX(hospital_beds),
    MIN(health_expenditure),
    MAX(health_expenditure),
    MIN(physicians),
    MAX(physicians)
FROM
    all_indicators;

CREATE TEMPORARY TABLE summary
SELECT min(life_expectancy) min_life, max(life_expectancy) max_life, min(hospital_beds) min_hospital_beds, max(hospital_beds) max_hospital_beds, min(health_expenditure) min_health_exp, max(health_expenditure) max_health_exp, min(physicians) min_physicians, max(physicians) max_physicians
FROM all_indicators;

ALTER TABLE all_indicators ADD COLUMN min_life char(50);
ALTER TABLE all_indicators ADD COLUMN max_life char(50);
ALTER TABLE all_indicators ADD COLUMN min_hospital_beds char(50);
ALTER TABLE all_indicators ADD COLUMN max_hospital_beds char(50);
ALTER TABLE all_indicators ADD COLUMN min_health_exp char(50);
ALTER TABLE all_indicators ADD COLUMN max_health_exp char(50);
ALTER TABLE all_indicators ADD COLUMN min_physicians char(50);
ALTER TABLE all_indicators ADD COLUMN max_physicians char(50);

select * from all_indicators;
select * from summary;

set sql_safe_updates = 0;    
UPDATE all_indicators 
SET 
    min_life = (SELECT 
            min_life
        FROM
            summary);
UPDATE all_indicators 
SET 
    max_life = (SELECT 
            max_life
        FROM
            summary);
UPDATE all_indicators 
SET 
    min_hospital_beds = (SELECT 
            min_hospital_beds
        FROM
            summary);
UPDATE all_indicators 
SET 
    max_hospital_beds = (SELECT 
            max_hospital_beds
        FROM
            summary);
UPDATE all_indicators 
SET 
    min_health_exp = (SELECT 
            min_health_exp
        FROM
            summary);
UPDATE all_indicators 
SET 
    max_health_exp = (SELECT 
            max_health_exp
        FROM
            summary);
UPDATE all_indicators 
SET 
    min_physicians = (SELECT 
            min_physicians
        FROM
            summary);
UPDATE all_indicators 
SET 
    max_physicians = (SELECT 
            max_physicians
        FROM
            summary);
select * from all_indicators;

alter table all_indicators add column life_expectancy_normal float
generated always as ((life_expectancy-min_life)/(max_life-min_life)) stored;
alter table all_indicators add column hospital_beds_normal float
generated always as ((hospital_beds-min_hospital_beds)/(max_hospital_beds-min_hospital_beds)) stored;
alter table all_indicators add column health_expenditure_normal float
generated always as ((health_expenditure - min_health_exp)/(max_health_exp - min_health_exp)) stored;
alter table all_indicators add column physicians_normal float
generated always as ((physicians - min_physicians)/(max_physicians -min_physicians)) stored;

alter table all_indicators add column comp_index float
generated always as ( life_expectancy_normal + hospital_beds_normal + health_expenditure_normal +physicians_normal) stored;
select * from all_indicators;

SELECT 
    country,
    life_expectancy,
    hospital_beds,
    health_expenditure,
    physicians,
    comp_index
FROM
    all_indicators
ORDER BY comp_index DESC;








