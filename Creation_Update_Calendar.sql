-- create date list
CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Date_Ranges AS (
	WITH RECURSIVE Date_Ranges AS (
        SELECT DATE('year-month-day') AS Date -- range date min
        UNION ALL
        SELECT Date + INTERVAL 1 DAY
        FROM Date_Ranges
        WHERE Date < 'year-month-day' -- range date max
    )
    SELECT Date
    FROM Date_Ranges
);
INSERT INTO calendar(ddates) -- calendar table
SELECT Date
FROM Temp_Date_Ranges;
DROP TEMPORARY TABLE IF EXISTS Temp_Date_Ranges;

-- update calendar list
CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Date_Ranges AS (
    WITH RECURSIVE Date_Ranges AS (
        SELECT MAX(dates) AS Dates -- max date
        FROM calendar
        UNION ALL
        SELECT Dates + INTERVAL 1 DAY
        FROM Date_Ranges
        WHERE Date < 'year-month-day' -- range max date
    )
    SELECT Dates
    FROM Date_Ranges
);
INSERT INTO calendar (dates)
SELECT Dates
FROM Temp_Date_Ranges
WHERE Date NOT IN (SELECT dates FROM calendar);
DROP TEMPORARY TABLE IF EXISTS Temp_Date_Ranges;
