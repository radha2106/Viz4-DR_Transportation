CREATE DATABASE transporte;
USE transporte;
-- Create the calendar table
CREATE TABLE calendar (
	idx BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	ddates DATE NOT NULL UNIQUE,
	years INT NOT NULL,
	months INT NOT NULL,
	months_name VARCHAR(3) NOT NULL,
	day_number INT NOT NULL,
	day_name VARCHAR(3) NOT NULL,
	week_day INT NOT NULL    
);
-- Set the date range for dates to be added
SET @Startdate = '2020-01-01';
SET @Enddate = '2020-12-31';
-- Use a single statement to handle the recursion
INSERT INTO calendar (ddates,years,months,months_name,day_number,day_name,week_day)
WITH RECURSIVE DateRange AS (
    SELECT @Startdate AS CalendarDate
    UNION ALL
    SELECT DATE_ADD(CalendarDate, INTERVAL 1 DAY)
    FROM DateRange
    WHERE CalendarDate < @Enddate
)
SELECT
    CalendarDate AS ddate,
    YEAR(CalendarDate) AS years,
    MONTH(CalendarDate) AS months,
    LEFT(MONTHNAME(CalendarDate),3) AS months_name,
    DAY(CalendarDate) AS day_number,
    LEFT(DAYNAME(CalendarDate),3) AS day_name,
    WEEKDAY(CalendarDate)+1 AS week_day
FROM 
    DateRange;
---------------------------------------------------
CREATE TABLE hours(
	idx INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	thours TIME NOT NULL UNIQUE
);

-- Set the start and end times
SET @StartTime = '06:00:00';
SET @EndTime = '22:00:00';

-- Use a single statement to handle the recursion
INSERT INTO hours (thours)
WITH RECURSIVE TimeRange AS (
    SELECT @StartTime AS thours
    UNION ALL
    SELECT ADDTIME(thours, '01:00:00') 
    FROM TimeRange
    WHERE ADDTIME(thours, '01:00:00') <= @EndTime
)
SELECT thours
FROM TimeRange;
--------------------------------------
CREATE TABLE metodos (
	idx INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	vias VARCHAR(8) NOT NULL UNIQUE)
--------------------
CREATE TABLE fullinfo(
	id_province BIGINT NOT NULL,
	id_date BIGINT NOT NULL,
	id_transp BIGINT NOT NULL,
	id_hour BIGINT NOT NULL,
	passangers INT NOT NULL,
		FOREIGN KEY(id_province) REFERENCES provincias(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_date) REFERENCES calendar(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_hour) REFERENCES hours(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_transp) REFERENCES metodos(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT);
-----------------------
 CREATE TABLE capacidad(
 	id_province BIGINT NOT NULL,
	id_transp BIGINT NOT NULL,
	id_hour BIGINT NOT NULL,
	min_cap INT NOT NULL,
  	max_cap INT NOT NULL,
		FOREIGN KEY(id_province) REFERENCES provincias(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_date) REFERENCES calendar(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_hour) REFERENCES hours(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
		FOREIGN KEY(id_transp) REFERENCES metodos(idx)
		ON UPDATE CASCADE
		ON DELETE RESTRICT);
-----------------------------
CREATE TABLE provincias (
	idx INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idx_province VARCHAR(5) NOT NULL,
	province VARCHAR(25) NOT NULL,
	region VARCHAR(5) NOT NULL);
----------------------
LOAD DATA INFILE '' -- file path
INTO TABLE --table name
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(col1,col2..colN)
--------------
CREATE INDEX months_names
ON calendar (months,months_name)
------------------------
--Trigger
DELIMITER //
CREATE TRIGGER check_passengers_before_insert
BEFORE INSERT ON fullinfo
FOR EACH ROW
BEGIN
    DECLARE v_min_cap INT;
    DECLARE v_max_cap INT;

    SELECT min_cap, max_cap INTO v_min_cap, v_max_cap
    FROM capacidad
    WHERE id_transp = NEW.id_transp 
        AND id_province = NEW.id_province;

    IF NEW.passangers < v_min_cap AND NEW.passangers > v_max_cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passengers count is out of range.';
    END IF;
END;
//
DELIMITER ;
---------------------------------
-- Views Tables
CREATE OR REPLACE VIEW v_bus AS(
SELECT *
FROM fullinfo
WHERE id_transp=1);

CREATE OR REPLACE VIEW v_metro AS(
SELECT *
FROM fullinfo
WHERE id_transp=2);

CREATE OR REPLACE VIEW v_cablecar AS(
SELECT *
FROM fullinfo
WHERE id_transp=3);
