CREATE VIEW fullinfo 
AS select 
ddate_id AS ddate_id,
hours_id AS hours_id,
passangers AS passangers,
method_id AS method_id 
from bus union 
select ddate_id AS ddate_id,
hours_id AS hours_id,
passangers AS passangers,
method_id AS method_id 
from metro union 
select ddate_id AS ddate_id,
hours_id AS hours_id,
passangers AS passangers,
method_id AS method_id 
from cablecar;

CREATE VIEW max_capacity_per_day 
AS select 
ddate_id AS ddate_id,
(case when ((max(passangers) % 2) = 1) 
then (max(passangers) + 1) else 
max(passangers) end) AS capacity_per_day,
method_id AS method_id 
from bus 
group by ddate_id,
method_id union 
select ddate_id AS ddate_id,
(case when ((max(passangers) % 2) = 1) 
then (max(passangers) + 1) else 
max(passangers) end) AS capacity_per_day,
method_id AS method_id 
from metro 
group by ddate_id,
method_id union 
select ddate_id AS ddate_id,
(case when ((max(passangers) % 2) = 1) 
then (max(passangers) + 1) else 
max(passangers) end) AS capacity_per_day,
method_id AS method_id 
from cablecar 
group by ddate_id,
method_id;

CREATE VIEW max_capacity_per_hour 
AS select 
hours_id AS hours_id,
(case when ((max(passangers) % 2) = 1) 
then (max(passangers) + 1) else 
max(passangers) end) AS capacity_per_hour,
method_id AS method_id
from bus 
group by hours_id,
method_id union 
select hours_id AS hours_id,
(case when ((max(passangers) % 2) = 1)
then (max(passangers) + 1) else 
max(passangers) end) AS max_capacity,
method_id AS method_id 
from metro 
group by hours_id,
method_id union 
select hours_id AS hours_id,
(case when ((max(passangers) % 2) = 1)
then (max(passangers) + 1) else 
max(passangers) end) AS max_capacity,
method_id AS method_id 
from cablecar 
group by hours_id,
method_id