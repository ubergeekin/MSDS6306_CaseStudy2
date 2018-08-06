-- STEPS TO RESET PASSWORD TO MYSQL SERVER
-- -------------------------
-- sudo /usr/local/mysql/support-files/mysql.server stop
-- sudo /usr/local/mysql/bin/mysqld_safe --skip-grant-tables

-- sudo /usr/local/mysql/bin/mysql -u root  
-- UPDATE mysql.user SET authentication_string=PASSWORD('my-new-password') WHERE User='root';  
-- FLUSH PRIVILEGES;  
-- \q


-- Annual average daily traffic, abbreviated AADT, is a measure used primarily in transportation planning and transportation engineering. 
-- Traditionally, it is the total volume of vehicle traffic of a highway or road for a year divided by 365 days

-- VHD, VMT, (back and ahead) AADT, 
-- -------------------------
SET SQL_SAFE_UPDATES = 0;
use smu;

DROP TEMPORARY TABLE IF EXISTS volumes;
CREATE TEMPORARY TABLE volumes ( 
id int,
caltrans_district numeric,
route_number numeric,
route_suffix varchar(12),
county varchar(12),
postmile_prefix varchar(12),
postmile_number numeric,
postmile_suffix varchar(12),
location varchar(200),
back_peak_hour numeric,
back_peak_month numeric,
back_AADT numeric,
ahead_peak_hour numeric,
ahead_peak_month numeric,
ahead_AADT numeric,
latitude numeric,
longitude numeric,
period varchar(12)
);
LOAD DATA LOCAL INFILE '/users/rfarrow/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/traffic_volumes.csv'
INTO TABLE volumes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
-- LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


select * from volumes limit 10;

-- select count(*) from tmp_import where 

DROP TEMPORARY TABLE IF EXISTS delays;
CREATE TEMPORARY TABLE delays ( 
id int,
stamp varchar(30),
station numeric,
district numeric,
route_number numeric,
direction_travel varchar(12),
lane_type varchar(12),
station_length varchar(20),
samples numeric,
percent_observed numeric,
total_flow varchar(20),
delay_35 varchar(12),
delay_40 varchar(12),
delay_45 varchar(12),
delay_50 varchar(12),
delay_55 varchar(12),
delay_60 varchar(12),
period varchar(12)
);
LOAD DATA LOCAL INFILE '/users/rfarrow/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/traffic_delays.csv'
INTO TABLE delays
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
-- LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


select * from delays WHERE period ='2011' 
limit 10;

/*update delays
set county = 'Los Angeles' 
where county = 'LA';

select d.id as 'did' , v.id as 'vid', d.county as 'd_county', v.county as 'v_county', d.route_number as 'd_route', v.route_number as 'v_route', d.*,v.* 
-- select sum(d.annual_vmt) as 'total_vmt'
from delays d 
join volumes v on d.route_number = v.route_number and  d.year_ = v.year_
where d.county = 'Los Angeles' and v.county = 'LA'
and d.year_ in ('2016')
order by d.year_ desc;


select * from delays where county = 'Los Angeles' and year_ = '2016';

select * from volumes where county = 'LA' and year_ = '2016' */