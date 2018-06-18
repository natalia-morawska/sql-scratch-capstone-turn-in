SELECT *
FROM subscriptions
LIMIT 100;

----------------------

select min(subscription_start) as start_date,
max(subscription_start) as end_date
from subscriptions;


----------------------

with months as (
select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
)

Select *
From months;

----------------------

with months as (
select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
),

cross_join as (
select *
  from subscriptions
   cross join months
)

select *
from cross_join;

----------------------


with months as (
  select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
),

cross_join as (
  select *
  from subscriptions
  cross join months
),

status as (
  select
  id as id,
  month_start as month,
  case when ( 
    segment = 87
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_87,
  case when (
    segment = 30
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_30
  from cross_join
)

select *
from status
;

----------------------

with months as (
  select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
),

cross_join as (
  select *
  from subscriptions
  cross join months
),

status as (
  select
  id as id,
  month_start as month,
  case when ( 
    segment = 87
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_87,
  case when (
    segment = 30
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_30,
  case when (
    segment = 87
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_87,
  case when (
    segment = 30
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_30
  from cross_join
)

select *
from status;

----------------------

with months as (
  select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
),

cross_join as (
  select *
  from subscriptions
  cross join months
),

status as (
  select
  id as id,
  month_start as month,
  case when ( 
    segment = 87
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_87,
  case when (
    segment = 30
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_30,
  case when (
    segment = 87
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_87,
  case when (
    segment = 30
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_30
  from cross_join
),

status_aggregate as (
  select 
  sum(is_active_87) as sum_active_87,
  sum(is_active_30) as sum_active_30,
  sum(is_canceled_87) as sum_canceled_87,
  sum(is_canceled_30) as sum_canceled_30
  from status
)

select *
from status_aggregate;

------------------------


with months as (
  select
  '2017-01-01' as month_start,
  '2017-01-31' as month_end
  union
  select
  '2017-02-01'as month_start,
  '2017-02-28'as month_end
  union
  select
  '2017-03-01'as month_start,
  '2017-03-31'as month_end
),

cross_join as (
  select *
  from subscriptions
  cross join months
),

status as (
  select
  id as id,
  month_start as month,
  case when ( 
    segment = 87
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_87,
  case when (
    segment = 30
    and subscription_start < month_start
  ) then 1
  else 0
  end as is_active_30,
  case when (
    segment = 87
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_87,
  case when (
    segment = 30
    and subscription_end >= month_start
    and subscription_end <= month_end
  ) then 1
  else 0
  end as is_canceled_30
  from cross_join
),

status_aggregate as (
  select 
  sum(is_active_87) as sum_active_87,
  sum(is_active_30) as sum_active_30,
  sum(is_canceled_87) as sum_canceled_87,
  sum(is_canceled_30) as sum_canceled_30
  from status
)

select 
1.0 * sum_canceled_87 / sum_active_87 as churn_87,
1.0 * sum_canceled_30 / sum_active_30 as churn_30
from status_aggregate;


