-- Add you solution queries below:
USE sakila;

/*1. How many copies of the film Hunchback Impossible exist in the inventory system?*/
SELECT COUNT(*) AS 'COPIES'
FROM inventory
WHERE film_id =(
	SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
    );

/*2. List all films whose length is longer than the average of all the films.*/
SELECT title, length
FROM film
WHERE length >(
	SELECT AVG(length)
    FROM film
    );

/*3. Use subqueries to display all actors who appear in the film Alone Trip.*/
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id =(
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);
/*4. Identify all movies categorized as family films.*/
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/*5. Get name and email from customers from Canada using subqueries and joins.*/
SELECT first_name, last_name, email
FROM customer 
WHERE address_id IN (
	SELECT address_id
    FROM address
    WHERE city_id IN (
		SELECT city_id
        FROM city
        WHERE country_id IN (
			SELECT country_id
			FROM country
			WHERE country = 'Canada')
		)
	);
/*6. Films starred by the most prolific actor - actor who acted in the most films.*/
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
	SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1);

/* 7. Films rented by the most profitable customer.*/
SELECT f.title
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id =f.film_id
WHERE p.customer_id = (
	SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1);

/*8. Get the client_id and the total amount spent of those clients who spent more than the average of the total amount spent by each client.*/
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
	SELECT AVG(total_spent)
    FROM (
		SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
	) AS avg_spent
);





		