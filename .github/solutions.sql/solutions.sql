use sakila;
select* from sakila.film;
/*1 How many copies of the film Hunchback Impossible exist in the inventory system?*/
SELECT COUNT(*) AS total_copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

/*2 List all films whose length is longer than the average of all the films.*/
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

/*3-Use subqueries to display all actors who appear in the film Alone Trip.*/
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor
    INNER JOIN film  ON film_id = film_id
    WHERE f.title = 'Alone Trip'
);

/*4. Identify all movies categorized as family films.*/
SELECT f.title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/*5. Get name and email of customers from Canada using subqueries and joins.*/
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);
SELECT c.first_name, c.last_name, c.email
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

/*6. Films starred by the most prolific actor.*/
SELECT actor_id, COUNT(film_id) AS film_count
FROM film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT f.title
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = most_prolific_actor_id;

/*7. Films rented by the most profitable customer.*/
SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;

SELECT f.title
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = most_profitable_customer_id;

/*8. Get client_id and total_amount_spent of those clients who spent more than the average total amount spent by each client.*/
SELECT AVG(total_spent) AS avg_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals;

SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS avg_table);




