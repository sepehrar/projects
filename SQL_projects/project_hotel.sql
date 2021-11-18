use project



SELECT *
  INTO  Hotels 
FROM
(
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']
) a


select h.adr,h.arrival_date_day_of_month,h.arrival_date_week_number,h.arrival_date_year,h.hotel,h.market_segment,h.meal,h.stays_in_week_nights,h.stays_in_weekend_nights,h.required_car_parking_spaces,h.country,ms.Discount,ma.Cost
from Hotels h 
left join dbo.market_segment$ ms
on h.market_segment = ms.market_segment
left join dbo.meal_cost$ ma
on ma.meal=h.meal





