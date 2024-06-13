create database projecthr;

use projecthr;

alter table hr
change column ï»¿id emp_id varchar(20);

alter table hr
modify column emp_id varchar(20) not null;

update hr
set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end;

select birthdate from hr;

alter table hr
modify column birthdate date;

update hr
set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end;

select hire_date from hr;

alter table hr
modify column hire_date date;

select termdate from hr;

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate !="";

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';

SET sql_mode = 'ALLOW_INVALID_DATES';

alter table hr 
modify column termdate date;

describe hr;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr 
SET age = timestampdiff(YEAR,birthdate, CURDATE());

SELECT BIRTHDATE,AGE FROM hr;

select count(*) from hr where age<18;

select * from hr;

-- 1. Gender breakdown of the employees.

SELECT gender, 	count(*) AS count
from hr
where age >=18 and termdate = '0000-00-00'
group by gender;

-- 2 Race breakdown of the employees.

select race,count(*) as race_count
from hr 
where age >=18 and termdate = '0000-00-00'
group by race
order by count(*) desc;

-- 3 Age distribution of the employees.


select 
	min(age) as Youngest,
    max(age) as Oldest
from hr
where age >=18 and termdate = '0000-00-00';

select
	case
		when age >=18 and age <=24 then '18-24'
        when age >=25 and age <=34 then '25-34'
		when age >=35 and age <=44 then '35-44'
		when age >=45 and age <=54 then '45-54'
        else '55+'
	end as Age_group,
	count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by age_group
order by age_group;

select
	case
		when age >=18 and age <=24 then '18-24'
        when age >=25 and age <=34 then '25-34'
		when age >=35 and age <=44 then '35-44'
		when age >=45 and age <=54 then '45-54'
        else '55+'
	end as Age_group,gender,
	count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender;

-- 4 Employees work location (Headquartes vs Remote)

select location,count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by location;

-- 5 Average length of employement for employees who have been terminated.

select 
	round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employement
from hr
where termdate <=curdate() and age >=18 and termdate <> '0000-00-00';

-- 6 Gender distribution across department.

select department,gender,count(*) as count
from hr 
where age >=18 and termdate = '0000-00-00'
group by department,gender
order by department; 

-- 7 Distribution of Jobtitle across the company 

select jobtitle,count(*) as count
from hr 
where age >=18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

-- 8 Which department has the highest turnover rate

select 
	department,
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
from(
	select department,
    count(*) as total_count,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr
    where age >=18 
    group by department
    )as subquery
order by termination_rate desc;

-- 9 Distribution of employees across state.

select location_state, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by location_state
order by count desc;

-- 10 How company's employee count changed over time based on hire and term dates.

select
	year,
    hires,
    terminations,
	hires - terminations as net_change,
    round((hires - terminations)/hires * 100,2) as net_change_percent
from(
	select
		year(hire_date) as year,
        count(*) as hires,
        sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
        from hr
        where age >= 18
        group by year(hire_date)
        ) as subquery
order by year asc;

-- 11 Tenure distribution of each departmnet.

select department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age >= 18
group by department
order by avg_tenure desc;
    







        
