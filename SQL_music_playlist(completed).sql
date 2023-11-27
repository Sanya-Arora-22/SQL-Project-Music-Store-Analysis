#Question Set 1 - Easy
#1
SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;

#2
Select billing_country,COUNT(invoice_id) AS No_of_invoices from invoice
GROUP BY billing_country
ORDER BY No_of_invoices DESC;

#3
SELECT total 
FROM invoice
ORDER BY total DESC
limit 3;

#4Which city has the best customers? We would like to throw a promotional Music 
SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

#5
SELECT c.customer_id, first_name, last_name, SUM(total) AS total_money_spent
FROM customer c
JOIN invoice I ON c.customer_id = I.customer_id
GROUP BY c.customer_id
ORDER BY total_money_spent DESC
LIMIT 1;

#Question Set 2 - Moderate
#1 Write query to return he email, first name, last name, & Genre of all Rock Music listeners. 
#Return your list ordered alphabetically by email starting with A
SELECT DISTINCT email,first_name, last_name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id = g.genre_id
WHERE g.name LIKE 'Rock'
ORDER BY email;

#2Let's invite the artists who have written the most rock music in our dataset. Write a 
#query that returns the Artist name and total track count of the top 10 rock band

SELECT a.artist_id, a.name,COUNT(a.artist_id) AS number_of_songs
FROM artist a 
JOIN album2 al ON al.artist_id = a.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY a.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

#3
SELECT name,miliseconds as song_length
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track )
ORDER BY milliseconds DESC;


#3
Select name, milliseconds AS song_length from track 
WHERE milliseconds > (Select AVG(milliseconds) from track)
ORDER BY song_length DESC;

#Question Set 3 - Advance 

#1
WITH most_earned_artist AS (
	SELECT a.artist_id AS artist_id, a.name AS artist_name, SUM(il.unit_price*il.quantity) AS total_sales
	FROM artist a
	JOIN album2 al ON al.artist_id = a.artist_id
	JOIN track t ON al.album_id = t.album_id
	JOIN invoice_line il ON t.track_id = il.track_id 
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, m.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 al ON al.album_id = t.album_id
JOIN  most_earned_artist m ON m.artist_id = m.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

#2
WITH most_popular_genre AS 
(
    SELECT COUNT(il.quantity) AS purchases, c.country, g.name, g.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS rn 
    FROM invoice_line il
	JOIN invoice i ON i.invoice_id = il.invoice_id
	JOIN customer c ON c.customer_id = i.customer_id
	JOIN track t ON t.track_id = il.track_id
	JOIN genre g ON g.genre_id = t.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM most_popular_genre WHERE rn <= 1

#3
WITH most_spent_Customter_with_country AS (
		SELECT c.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS rn
		FROM invoice i
		JOIN customer c ON c.customer_id = i.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM most_spent_Customter_with_country  WHERE rn <= 1











