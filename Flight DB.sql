--Review Sample Data
select * from flights
limit 5;
select * from airlines
limit 5;
select * from airports
limit 5;
--Total Row Count
SELECT COUNT(*) FROM flights;
SELECT COUNT(*) FROM airlines;
SELECT COUNT(*) FROM airports;
--Year,Month,Date Formatting
ALTER TABLE flights
ADD COLUMN flight_date DATE;
UPDATE flights
SET flight_date = MAKE_DATE(year, month, day);
--DATE-TIME Formatting
alter table flights
add column scheduled_departure_dt Timestamp;
update flights
SET scheduled_departure_dt =
TO_TIMESTAMP(
    year || '-' ||
    LPAD(month::TEXT,2,'0') || '-' ||
    LPAD(day::TEXT,2,'0') || ' ' ||
    LPAD(scheduled_departure::TEXT,4,'0'),
    'YYYY-MM-DD HH24MI'
);
alter table flights
add column scheduled_arrival_dt Timestamp;
update flights
SET scheduled_arrival_dt =
TO_TIMESTAMP(
    year || '-' ||
    LPAD(month::TEXT,2,'0') || '-' ||
    LPAD(day::TEXT,2,'0') || ' ' ||
    LPAD(scheduled_arrival::TEXT,4,'0'),
    'YYYY-MM-DD HH24MI'
);
alter table flights
add column scheduled_arrival_dt Timestamp;
update flights
SET scheduled_arrival_dt =
TO_TIMESTAMP(
    year || '-' ||
    LPAD(month::TEXT,2,'0') || '-' ||
    LPAD(day::TEXT,2,'0') || ' ' ||
    LPAD(scheduled_arrival::TEXT,4,'0'),
    'YYYY-MM-DD HH24MI'
);
-- Numbers of Nulls
SELECT
SUM(CASE WHEN departure_delay IS NULL THEN 1 ELSE 0 END) AS dep_delay_nulls,
SUM(CASE WHEN arrival_delay IS NULL THEN 1 ELSE 0 END) AS arr_delay_nulls,
SUM(CASE WHEN cancellation_reason IS NULL THEN 1 ELSE 0 END) AS cancel_reason_nulls
FROM flights;
--Changes the Nulls to 0
UPDATE flights
SET
    departure_delay = COALESCE(departure_delay, 0),
    arrival_delay = COALESCE(arrival_delay, 0),
    airline_delay = COALESCE(airline_delay, 0),
    weather_delay = COALESCE(weather_delay, 0),
    air_system_delay = COALESCE(air_system_delay, 0),
    security_delay = COALESCE(security_delay, 0),
    late_aircraft_delay = COALESCE(late_aircraft_delay, 0);
	
alter table flights
add column Cancellation_reason_desc varchar(50);
--Cancellation Reason desc
update flights
set Cancellation_reason_desc = 
CASE
    when Cancellation_reason ='A' then 'Airline/Carrier'
    when Cancellation_reason ='B' then 'Weather'
    when Cancellation_reason ='C' then 'National Air System'
    when cancellation_reason ='D' then 'Security'
    Else 'Not Cancelled'
End;
--Flight Date
alter table flights
add column Flight_Dates date;
UPDATE flights
SET Flight_dates = MAKE_DATE(year, month, day);
-- Joining the tables
CREATE VIEW flight_analysis_view AS
SELECT
    f.*,
    a.logo,
    ao.city AS origin_city,
    ad.city AS destination_city

FROM flights f

LEFT JOIN airlines a
ON f.airline = a.iata_code

LEFT JOIN airports ao
ON f.origin_airport = ao.iata_code

LEFT JOIN airports ad
ON f.destination_airport = ad.iata_code;