-- Add you solution queries below:
USE sakila;

/* How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT film.title,count(film.title) AS film_copies
FROM inventory
LEFT JOIN film
ON inventory.film_id = film.film_id
WHERE film.title = "Hunchback Impossible"
GROUP BY film.title;

/* List all films whose length is longer than the average of all the films.? */
SELECT AVG(length)
FROM film;

SELECT *
FROM Film
WHERE film.length > 115.2720;

/* Use subqueries to display all actors who appear in the film Alone Trip.? */
SELECT actor_film_actor.actor_id, actor_film_actor.first_name, actor_film_actor.last_name, actor_film_actor.film_id, film.title
FROM(SELECT actor.actor_id, actor.first_name, actor.last_name, film_actor.film_id
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = film_actor.actor_id) AS actor_film_actor
LEFT JOIN film
ON actor_film_actor.film_id = film.film_id
WHERE film.title = "Alone Trip";

/* Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. */
SELECT film_film_category.title, category.name
FROM (SELECT film.film_id, film.title, film_category.category_id
FROM film
LEFT JOIN film_category
ON film.film_id = film_category.film_id) AS film_film_category
LEFT JOIN category
ON film_film_category.category_id = category.category_id
WHERE category.name = "Family";

/* Get name and email from customers from Canada using subqueries. Do the same with joins. */
SELECT customer_address_city.first_name, customer_address_city.last_name, customer_address_city.email, country.country
FROM (SELECT customer_address.first_name, customer_address.last_name, customer_address.email, city.country_id
FROM(SELECT customer.first_name, customer.last_name, customer.email, address.city_id
FROM customer
LEFT JOIN address
ON customer.address_id = address.address_id) AS customer_address
LEFT JOIN city
ON customer_address.city_id = city.city_id) AS customer_address_city
LEFT JOIN country
ON customer_address_city.country_id = country.country_id
WHERE country = "canada";

/* Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. */

-- Step 1: Identify the most prolific actor
WITH prolific_actor AS (
    SELECT 
        actor.actor_id, 
        actor.first_name, 
        actor.last_name, 
        COUNT(film_actor.film_id) AS No_of_films
    FROM 
        film_actor
    LEFT JOIN 
        actor ON film_actor.actor_id = actor.actor_id
    GROUP BY 
        actor.actor_id, actor.first_name, actor.last_name
    ORDER BY 
        No_of_films DESC
    LIMIT 1 -- Get only the most prolific actor
)

-- Step 2: Retrieve films of the most prolific actor
SELECT 
    film.title, 
    prolific_actor.first_name, 
    prolific_actor.last_name, 
    prolific_actor.No_of_films
FROM 
    prolific_actor
LEFT JOIN 
    film_actor ON prolific_actor.actor_id = film_actor.actor_id
LEFT JOIN 
    film ON film_actor.film_id = film.film_id;

/* Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer */
-- Step 1: Find the most profitable customer
WITH most_profitable_customer AS (
    SELECT 
        customer.customer_id, 
        customer.first_name, 
        customer.last_name, 
        SUM(payment.amount) AS total_spent
    FROM 
        customer
    LEFT JOIN 
        payment ON customer.customer_id = payment.customer_id
    GROUP BY 
        customer.customer_id, customer.first_name, customer.last_name
    ORDER BY 
        total_spent DESC
    LIMIT 1  -- Get only the customer with the highest spending
)

-- Step 2: Get the films rented by the most profitable customer
SELECT 
    film.title, 
    most_profitable_customer.first_name, 
    most_profitable_customer.last_name, 
    most_profitable_customer.total_spent
FROM 
    most_profitable_customer
LEFT JOIN 
    rental ON most_profitable_customer.customer_id = rental.customer_id
LEFT JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN 
    film ON inventory.film_id = film.film_id;


/* Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. */
-- Step 1: Calculate total amount spent by each client
WITH client_spending AS (
    SELECT 
        customer_id AS client_id, 
        SUM(amount) AS total_amount_spent
    FROM 
        payment
    GROUP BY 
        customer_id
),
-- Step 2: Calculate the average total amount spent by all clients
average_spending AS (
    SELECT 
        AVG(total_amount_spent) AS avg_total_spent
    FROM 
        client_spending
)
-- Step 3: Get clients who spent more than the average total amount
SELECT 
    client_spending.client_id, 
    client_spending.total_amount_spent
FROM 
    client_spending, average_spending
WHERE 
    client_spending.total_amount_spent > average_spending.avg_total_spent;
