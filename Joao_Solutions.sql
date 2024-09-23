# 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT 
    COUNT(inventory_id) as quantity
FROM 
	film
JOIN
	inventory ON inventory.film_id = film.film_id
WHERE 
	title LIKE 'Hunchback Impossible'

# 2. List all films whose length is longer than the average of all the films.
SELECT
	title
FROM
	film
WHERE length > (
SELECT
	AVG(length)
FROM film
)



# 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT 
	first_name,
    last_name
FROM
	actor
WHERE 
	actor_id IN (

SELECT
	actor_id
FROM 
	film_actor
WHERE 
	film_id = (
SELECT
	film_id
FROM 
	film
WHERE
	title LIKE "Alone Trip"
)
)

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT
	title
FROM 
	film
WHERE
	film_id IN (
SELECT
	film_id
FROM
	film_category
WHERE
	category_id = (

SELECT category_id
FROM
	category
WHERE
	name LIKE 'Family'
)
)
# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
# Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

# Doing it with subqueries:
SELECT 
	first_name,
    last_name,
    email
FROM 
	customer
WHERE
	address_id IN (
SELECT address_id FROM address WHERE city_id IN (
SELECT city_id FROM city WHERE country_id = (
SELECT country_id FROM country WHERE country = 'Canada')))

# Doing it with joins
SELECT 
	customer.first_name,
    customer.last_name,
    customer.email
FROM 
	customer
JOIN 
	address ON customer.address_id = address.address_id
JOIN 
	city ON address.city_id = city.city_id
JOIN 
	country ON city.country_id = country.country_id
WHERE
	country.country = 'Canada'
	

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
	first_name,
    last_name
FROM 
	actor
WHERE actor_id = (
SELECT 
	actor_id
FROM (
SELECT
	actor_id,
    COUNT(film_id) as number_of_films
FROM
	film_actor
GROUP BY 
	actor_id
ORDER BY 
	number_of_films DESC
LIMIT 1
) as actor_films
)

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT
	title
FROM 
	film
WHERE 
	film_id IN (
SELECT 
	film_id
FROM 
	inventory
WHERE 
	inventory_id IN (
SELECT 
	inventory_id
FROM 
	rental
WHERE 
	customer_id = (
SELECT 
	customer_id
FROM (
SELECT
	customer_id,
    SUM(amount) as profit
FROM 
	payment
GROUP BY
	customer_id
ORDER BY
	profit DESC
LIMIT 1
) as profit_id
) 
)
)

# 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

SELECT 
	customer_id as client_id, 
	total_amount_spent
FROM (    
SELECT
	customer_id,
    sum(amount) as total_amount_spent
FROM
	payment
GROUP BY
	customer_id
    ) as client_list
WHERE 
	total_amount_spent > (
SELECT
	AVG(total_amount_spent)
FROM (    
SELECT
	customer_id,
    sum(amount) as total_amount_spent
FROM
	payment
GROUP BY
	customer_id) as revenue
) 



    