create database churnTELEData;
use churnTELEData;
create table churn_data(
customer_id int primary key,          
telecom_partner varchar(70),       
gender varchar(10),                 
age  varchar(10),                   
state varchar(70),                
city varchar(70),                 
pincode int,              
date_of_registration date,
num_dependents int,         
estimated_salary int,      
calls_made int,            
sms_sent int,              
data_used int ,            
churn int
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/telecom_churn.csv' into table churn_data
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(customer_id,telecom_partner,gender ,age,
state,city,pincode,date_of_registration,
num_dependents, estimated_salary,calls_made, sms_sent,data_used,      
churn); 
select * from churn_data;
-- distribution of customers across states ,total 
select state,count(*) as customers from churn_data group by state order by customers desc;-- uttrakhand 

--  number of customer in each telecom_partner in highest customers
select telecom_partner,count(*) as customers from churn_data group by telecom_partner order by customers desc;-- reliance jio have most customers 

SELECT telecom_partner, COUNT(*) AS customers,ROUND(AVG(churn)*100,2) AS churn_rate_pct FROM churn_data
GROUP BY telecom_partner
ORDER BY churn_rate_pct DESC;-- Airtel 20.37%, Reliance Jio 20.02%, Vodafone 19.95%, BSNL 19.86%.

SELECT gender, COUNT(*) AS customers, ROUND(AVG(churn)*100,2) AS churn_rate_byg FROM churn_data
GROUP BY gender;-- f:20.30%,m:19.88% 

SELECT CASE WHEN estimated_salary<50000 THEN 'Low (<50k)'
WHEN estimated_salary<100000 THEN 'Mid (50-100k)'
ELSE 'High (100k+)' END AS salary_band,
COUNT(*) AS customers, ROUND(AVG(churn)*100,2) AS churn_rate_pct FROM churn_data GROUP BY salary_band ORDER BY MIN(estimated_salary);

SELECT year(date_of_registration) AS regis_year,COUNT(*) AS registrations FROM churn_data GROUP BY regis_year ORDER BY regis_year;

SELECT month(date_of_registration) AS regis_month,COUNT(*) AS registrations FROM churn_data GROUP BY  regis_month ORDER BY regis_month;

SELECT COUNT(*) AS rows_with_negatives FROM churn_data WHERE calls_made < 0 OR sms_sent < 0 OR data_used < 0;

SELECT telecom_partner, ROUND(AVG(churn)*100,2) AS churn_rate_pct,
RANK() OVER (ORDER BY AVG(churn) DESC) AS churn_rank FROM churn_data GROUP BY telecom_partner;

SELECT telecom_partner, ROUND(AVG(data_used),0) AS avg_data FROM churn_data
WHERE data_used >= 0 GROUP BY telecom_partner ORDER BY avg_data DESC;

SELECT telecom_partner, ROUND(AVG(churn)*100,2) AS churn_rate_pct,
       RANK() OVER (ORDER BY AVG(churn) DESC) AS churn_rank FROM churn_data GROUP BY telecom_partner;
       
 SELECT CASE WHEN age<=25 THEN '18-25' WHEN age<=35 THEN '26-35'
            WHEN age<=45 THEN '36-45' WHEN age<=55 THEN '46-55'
            WHEN age<=65 THEN '56-65' ELSE '66+' END AS age_group,
COUNT(*) AS customers, ROUND(AVG(churn)*100,2) AS churn_rate_pct
FROM churn_data GROUP BY age_group ORDER BY age_group;      