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
CREATE TABLE fullinfo (
ddate_id BIGINT NOT NULL,
hour_id BIGINT NOT NULL,
pasajeros INT NOT NULL,
via_id BIGINT NOT NULL,
FOREIGN KEY(ddate_id) REFERENCES calendar(idx)
ON UPDATE CASCADE
ON DELETE RESTRICT,
FOREIGN KEY(hour_id) REFERENCES hours(idx)
ON UPDATE CASCADE
ON DELETE RESTRICT,
FOREIGN KEY(via_id) REFERENCES metodos(idx)
ON UPDATE CASCADE
ON DELETE RESTRICT);
-----------------------
CREATE TABLE capacidad (
hour_id BIGINT NOT NULL,
min_cap INT NOT NULL,
max_cap INT NOT NULL,
date_id BIGINT NOT NULL,
via_id BIGINT NOT NULL,
FOREIGN KEY (hour_id) REFERENCES hours (idx)
ON UPDATE CASCADE
ON DELETE RESTRICT,
FOREIGN KEY (date_id) REFERENCES calendar (idx)
ON UPDATE CASCADE
ON DELETE RESTRICT,
FOREIGN KEY (via_id) REFERENCES metodos (idx)
ON UPDATE CASCADE
ON DELETE RESTRICT);
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
DELIMITER //
CREATE TRIGGER check_passengers_before_insert
BEFORE INSERT ON fullinfo
FOR EACH ROW
BEGIN
    DECLARE v_min_cap INT;
    DECLARE v_max_cap INT;

    SELECT min_cap, max_cap INTO v_min_cap, v_max_cap
    FROM capacidad
    WHERE hour_id = NEW.hour_id AND via_id = NEW.via_id;

    IF NEW.pasajeros < v_min_cap OR NEW.pasajeros > v_max_cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passengers count is out of range.';
    END IF;
END;
//
DELIMITER ;
