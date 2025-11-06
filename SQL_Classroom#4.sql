use sakila;

select * from actor;

SELECT * from actor
where first_name like '%e%'
and first_name like 'e%'
and first_name not like '%e';

SELECT * from actor
where first_name like '%e%e%'
and first_name not like '%e%e%e';

select a.*
from actor a, address ad;

select first_name
, length(first_name) first_name_len
, replace(first_name, 'e','') first_name_repl
, length(replace(first_name, 'e','')) first_name_repl_len
from actor 
where (length(first_name) - length(replace(first_name, 'e',''))) = 2
order by first_name;

select first_name, 
length(first_name) first_name_length,
length(first_name) %2 length1
from actor
where length(first_name)%2 = 0;

select first_name, 
length(first_name) first_name_length
from actor
where length(first_name) > 4
order by length(first_name) ;

select first_name,
CASE WHEN first_name like 'a%' then 1 ELSE 0 END AS ind
from actor;

select actor_id, first_name,
CASE WHEN actor_id > 5 then 1 ELSE 
case when actor_id < 5 and actor_id> 2 then 2 else 0 end
 END AS ind
from actor
order by actor_id;

select * from actor;
