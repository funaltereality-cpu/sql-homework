use sakila;

select * from actor;

SELECT a.actor_id, count(*) as film_count, last_name
FROM actor a left JOIN film_actor fa ON (a.actor_id = fa.actor_id)
left JOIN film f ON (fa.film_id = f.film_id)
group by a.actor_id, last_name
order by film_count desc;

SELECT a.actor_id, a.first_name, a.last_name
, count(fa.film_id) AS film_count
FROM actor a LEFT JOIN film_actor fa ON (a.actor_id = fa.actor_id)
-- LEFT JOIN film f ON (fa.film_id = f.film_id)
GROUP BY a.actor_id, a.first_name, a.last_name
having film_count > 10
ORDER BY film_count desc, first_name, last_name desc
limit 10;

select * from film_category, category;

select f.film_id, title, rating, count(fa.actor_id)
from film as f
join film_actor as fa on fa.film_id=f.film_id
join film_category as fc on f.film_id=fc.film_id
where f.rating = 'R'
group by f.film_id, title, rating
having count(fa.actor_id) > 2
order by f.film_id;

use world;


SELECT c.name, ct.name, group_concat (ct.name ORDER BY ct.population desc separator ',') region_cities
FROM country as c
INNER JOIN city AS ct ON (ct.CountryCode = c.code)
							and ct.name = ct.district or ct.district = 'Horad Minsk'
WHERE code = 'BLR';