-- Add you solution queries below:

use sakila;

select film_id, title from film where title = 'HUNCHBACK IMPOSSIBLE';

/* Answer 1*/
select count(inventory.film_id) as copies, film.title
from inventory
inner join film on inventory.film_id = film.film_id
where film.title = 'HUNCHBACK IMPOSSIBLE'
group by film.title;

/* Answer 2*/

select AVG(length) from film;

select *
from film
where length > (select AVG(length) from film);

/* Answer 3*/

select * from actor;
select * from film;

select actor.first_name, actor.last_name, film.title
from film_actor
inner join film on film.film_id = film_actor.film_id
inner join actor on actor.actor_id = film_actor.actor_id
where film.title = 'ALONE TRIP';

/* Answer 4*/

select * from film_category;
select * from category;

select film.title, category.name
from film_category
inner join film on film.film_id = film_category.film_id
inner join category on category.category_id = film_category.category_id
where film_category.category_id = (select category_id from category where category.name = 'Family');

/* Answer 5*/

select customer_id, first_name, email 
from customer 
where address_id in (
    select address_id 
    from address 
    where city_id in (
        select city_id 
        from city 
        where country_id = (
            select country_id 
            from country 
            where country = 'Canada'
        )
    )
);

select customer.customer_id, customer.first_name, customer.email
from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where country.country = 'Canada';

/* Answer 6*/

select * from film;

select actor.actor_id from film_actor
inner join actor on actor.actor_id = film_actor.actor_id
group by film_actor.actor_id
order by count(film_id) desc limit 1;

select film.title from film
inner join film_actor on film_actor.film_id = film.film_id
where film_actor.actor_id = (select actor.actor_id from film_actor
							 inner join actor on actor.actor_id = film_actor.actor_id
							 group by film_actor.actor_id
							 order by count(film_id) desc limit 1);
                             
/* Answer 7*/
select * from payment;
select customer_id from payment group by customer_id order by count(payment_id) desc limit 1;

select inventory_id from rental where customer_id = (select customer_id from payment group by customer_id order by count(payment_id) desc limit 1);

select film_id from inventory where inventory_id in (select inventory_id from rental where customer_id = (select customer_id from payment group by customer_id order by count(payment_id) desc limit 1));

select film.title
from film
where film_id in (select film_id from inventory where inventory_id in (select inventory_id from rental where customer_id = (select customer_id from payment group by customer_id order by count(payment_id) desc limit 1)));

/* Answer 8*/

create temporary table total_amount as
select customer_id, sum(amount) as total_amount
from payment
group by customer_id;

create temporary table avg_total_amount as
select avg(total_amount) as avg_total
from total_amount;

select customer_id, total_amount
from total_amount
where total_amount > (SELECT avg_total FROM avg_total_amount);





