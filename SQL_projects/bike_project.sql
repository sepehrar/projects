--merging tables into one Table
DROP TABLEIF EXISTS bike_trip;
SELECT *
INTO   bike_trip
FROM   (
              SELECT *
              FROM   dbo.['202009-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202010-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202011-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202012-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202101-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202102-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202103-divvy-tripdata$']
              UNION
              SELECT *
              FROM   dbo.['202104-divvy-tripdata$'] )a ;



--changing null values into not available
UPDATE dbo.bike_trip
SET    [start_station_name] = 'Not Available'
WHERE  [start_station_name] IS NULL;

UPDATE dbo.bike_trip
SET    [start_station_id] = 'Not Avalilable'
WHERE  [start_station_id] IS NULL;

UPDATE dbo.bike_trip
SET    [end_station_name] = 'Not Avalilable'
WHERE  [end_station_name] IS NULL;

UPDATE dbo.bike_trip
SET    [end_station_id] = 'Not Avalilable'
WHERE  [end_station_id] IS NULL;

UPDATE dbo.bike_trip
SET    [end_lat] = 'Not Avalilable'
WHERE  [end_lat] IS NULL;

UPDATE dbo.bike_trip
SET    [end_lng] = 'Not Avalilable'
WHERE  [end_lng] IS NULL;

--Deviding Time and date column
ALTER TABLE dbo.bike_trip
  ADD start_date

AS (Cast(started_at AS DATE))
ALTER TABLE dbo.bike_trip
  ADD end_date

AS (Cast(ended_at AS DATE))
--getting year month and day seperatly
--geeting month
--ALTER TABLE dbo.bike_trip
--drop column MONTH;
ALTER TABLE dbo.bike_trip
  ADD month INT;

UPDATE dbo.bike_trip
SET    month = ( Month(start_date) );

--getting year
ALTER TABLE dbo.bike_trip
  ADD year INT;

UPDATE dbo.bike_trip
SET    year = ( Year(start_date) );

--Renaming member_casual column into Membershiptype
EXEC Sp_rename
  'dbo.bike_trip.member_casual',
  'membership_type',
  'COLUMN'; 


  --Combining start and end station into one column Route
--calculating ride length by subtracting column started at from ended at
--Adding names and numbers of weekdays and routes to the table
SELECT *,
       Concat(start_station_name, ' to ', end_station_name)     AS Route,
       Datepart(weekday, bike_trip.started_at)                  AS weekday,
       Datename(weekday, bike_trip.started_at)                  AS weekname,
       Cast (bike_trip.ended_at - bike_trip.started_at AS TIME) ride_length
FROM   dbo.bike_trip 