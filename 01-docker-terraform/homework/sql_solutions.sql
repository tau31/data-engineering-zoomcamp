-- ## Question 3. Count records 
-- How many taxi trips were totally made on September 18th 2019?
-- Tip: started and finished on 2019-09-18. 
-- Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.
-- - 15767
-- - 15612 
-- - 15859
-- - 89009
with travel_dates as (
    select lpep_pickup_datetime::date as pickup_date,
        lpep_dropoff_datetime::date as dropoff_date
    from green_taxi_data
),
target_trips as (
    select *
    from travel_dates
    where pickup_date = '2019-09-18'
        and dropoff_date = '2019-09-18'
)
select count(*)
from target_trips;
-- ## Question 4. Largest trip for each day
-- Which was the pick up day with the largest trip distance
-- Use the pick up time for your calculations.
-- - 2019-09-18
-- - 2019-09-16
-- - 2019-09-26 ****
-- - 2019-09-21
-- +-------------+--------+
-- | pickup_date | max    |
-- |-------------+--------|
-- | 2019-09-26  | 341.64 |
-- +-------------+--------+
with trips as (
    select lpep_pickup_datetime::date as pickup_date,
        trip_distance
    from green_taxi_data
),
max_dist as (
    select pickup_date,
        max(trip_distance)
    from trips
    group by pickup_date
)
select *
from max_dist
order by max desc
limit 1 -- ## Question 5. The number of passengers
    -- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
    -- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
    -- - "Brooklyn" "Manhattan" "Queens" ****
    -- - "Bronx" "Brooklyn" "Manhattan"
    -- - "Bronx" "Manhattan" "Queens" 
    -- - "Brooklyn" "Queens" "Staten Island"
    with tbl_selection as (
        select lpep_pickup_datetime::date as pickup_date,
            "PULocationID" as location_id,
            total_amount
        from green_taxi_data
        where lpep_pickup_datetime::date = '2019-09-18'
    ),
    tbl_with_loc as (
        select total_amount,
            z."Borough" as burough
        from tbl_selection as t1
            inner join zones as z on t1.location_id = z."LocationID"
    )
select *
from (
        select burough,
            sum(total_amount)
        from tbl_with_loc
        group by burough
        order by sum desc
    ) as tbl
where sum > 50000 -- ## Question 6. Largest tip
    -- For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip?
    -- We want the name of the zone, not the id.
    -- Note: it's not a typo, it's `tip` , not `trip`
    -- - Central Park
    -- - Jamaica
    -- - JFK Airport ****
    -- - Long Island City/Queens Plaza
    with raw_data as (
        select lpep_pickup_datetime::date as pickup_date,
            "PULocationID" as pu_id,
            "DOLocationID" as do_id,            
            tip_amount
        from green_taxi_data
    ),
    zones as (
        select "LocationID" as id,
            "Zone" as zone
        from zones
    ), tbl as (
        select pickup_date, pu_zone, do_zone, tip_amount
        from raw_data as r
            inner join (select id, zone as pu_zone from zones) as pu_z on r.pu_id = pu_z.id
            inner join (select id, zone as do_zone from zones) as do_z on r.do_id = do_z.id
        where pickup_date between '2019-09-01' and '2019-09-30'
        and pu_z.pu_zone = 'Astoria'
    ) 
    select do_zone, max(tip_amount) 
    from tbl 
    group by do_zone
    order by max desc
    limit 1
    