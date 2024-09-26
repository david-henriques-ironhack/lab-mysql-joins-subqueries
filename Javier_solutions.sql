-- Add you solution queries below:

/* 1 - How many copies of the film Hunchback Impossible exist in the inventory system?*/
SELECT sakila.film.film_id AS FILM_ID, sakila.film.title AS TITLE, COUNT(sakila.film.film_id) AS NUMBER_OF_COPIES
FROM sakila.film
INNER JOIN sakila.inventory
ON sakila.film.film_id = sakila.inventory.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY sakila.film.film_id, sakila.film.title
ORDER BY sakila.film.title;

/* 2 - List all films whose length is longer than the average of all the films.*/
SELECT sakila.film.title AS TITLE, sakila.film.length
FROM sakila.film
WHERE sakila.film.length > (SELECT AVG(sakila.film.length) FROM sakila.film);




/* 3 - Use subqueries to display all actors who appear in the film Alone Trip.*/
SELECT sakila.actor.first_name, sakila.actor.last_name
FROM sakila.actor
WHERE sakila.actor.actor_id IN (
    SELECT sakila.film_actor.actor_id
    FROM sakila.film_actor
    WHERE sakila.film_actor.film_id = (
        SELECT sakila.film.film_id
        FROM sakila.film
        WHERE sakila.film.title = 'Alone Trip'
    )
);

/* 4 - Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. */
SELECT sakila.film.title, sakila.film.rating
FROM sakila.film
WHERE sakila.film.rating IN ('G', 'PG', 'PG-13');

/* 5 - Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.*/
SELECT sakila.customer.first_name, sakila.customer.last_name, sakila.customer.email
FROM sakila.customer
WHERE sakila.customer.address_id IN (
SELECT sakila.address.address_id 
FROM sakila.address 
WHERE sakila.address.city_id IN (
SELECT sakila.city.city_id 
FROM sakila.city 
WHERE sakila.city.country_id = (
SELECT sakila.country.country_id 
FROM sakila.country 
WHERE sakila.country.country = 'Canada'
)
)
);

/* 6 - Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.*/
SELECT sakila.actor.first_name, sakila.actor.last_name
FROM sakila.actor
WHERE sakila.actor.actor_id = (
SELECT most_film_actor.actor_id
FROM (
SELECT sakila.film_actor.actor_id, COUNT(sakila.film_actor.actor_id) AS number_of_films
FROM sakila.film_actor
GROUP BY sakila.film_actor.actor_id
ORDER BY number_of_films DESC
LIMIT 1) AS most_film_actor
);

/* 7 - Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments*/
SELECT sakila.film.title
FROM sakila.film
WHERE sakila.film.film_id IN (
SELECT sakila.inventory.film_id
FROM sakila.inventory
WHERE sakila.inventory.inventory_id IN (
SELECT sakila.rental.inventory_id
FROM sakila.rental
WHERE sakila.rental.customer_id = (
SELECT sakila.profit_id.customer_id
FROM (
SELECT sakila.payment.customer_id,
SUM(sakila.payment.amount) AS profit
FROM sakila.payment
GROUP BY sakila.payment.customer_id
ORDER BY profit DESC
LIMIT 1
) AS profit_id
)
)
);

/* 8 - Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.*/
SELECT sakila.client_list.customer_id AS client_id, akila.client_list.total_amount_spent
FROM (SELECT sakila.payment.customer_id,SUM(sakila.payment.amount) AS total_amount_spent
FROM sakila.payment
GROUP BY sakila.payment.customer_id) AS client_list
WHERE client_list.total_amount_spent > (
SELECT AVG(revenue.total_amount_spent)
FROM (SELECT sakila.payment.customer_id, SUM(sakila.payment.amount) AS total_amount_spent
FROM sakila.payment
GROUP BY sakila.payment.customer_id) AS revenue
)
