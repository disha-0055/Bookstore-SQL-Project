CREATE DATABASE OnlineBookStore;

CREATE TABLE book(
	book_id INT PRIMARY KEY,
	title VARCHAR(100),
	author VARCHAR(100),
	genre VARCHAR(100),
	published_year INT,
	price NUMERIC,
	stock INT
);
SELECT * FROM book;
 
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR(100),
	city VARCHAR(100),
	country VARCHAR(100)
);
SELECT * FROM customer;

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customer(customer_id),
	book_id INT REFERENCES book(book_id) ,
	order_date DATE,
	quantity INT,
	total_amount NUMERIC
);
SELECT * FROM orders;


--BASIC QUERIES:-

--1) Retrieve all books from fiction genre
SELECT * FROM book WHERE genre = 'Fiction';

--2) Find books published after the year 1950
SELECT * FROM book WHERE published_year > 1950;

--3) List all customers from the canada
SELECT * FROM customer WHERE country = 'Canada';

--4) Show orders placed in november 2023
SELECT * FROM orders WHERE order_date BETWEEN '2023-11-1' AND '2023-11-30';

--5) Retrieve total stock of books available
SELECT SUM(stock) AS total_stocks FROM book;

--6) Find the details of the most expensive book
SELECT * FROM book ORDER BY price DESC LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of book
SELECT * FROM orders WHERE quantity > 1;

--8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM orders WHERE total_amount > 20;

--9) List all genres available in the book table
SELECT DISTINCT genre FROM book;

--10) Find the book with the lowest stock
SELECT * FROM book ORDER BY stock LIMIT 1;

--11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS revenue FROM orders;


--ADVANCE QUERIES:-

--1) Retrieve the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity)
FROM book b
JOIN orders o
ON b.book_id = o.book_id
GROUP BY genre;

--2) Find the average price of books in the fantasy genre
SELECT AVG(price) FROM book WHERE genre='Fantasy';

--3) List customers who have placed at least 2 orders
SELECT o.customer_id,c.name, COUNT(o.order_id) as order_count 
FROM orders o
JOIN customer c
ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >= 2;

--4) Find the most frequently ordered book
SELECT o.book_id, b.title, COUNT(o.order_id) as order_count
FROM orders o
JOIN book b
ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;

--5) Show the top 3 most expensive books of fantasy genre
SELECT * FROM book
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) as total_quantity
FROM orders o
JOIN book b
ON o.book_id = b.book_id
GROUP BY b.author;

--7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, o.total_amount
FROM orders o
JOIN customer c
ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;

--8) Find the customer who spent the most on orders
SELECT c.customer_id, c.name,SUM(o.total_amount) as most_spent
FROM orders o
JOIN customer c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY most_spent DESC 
LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0) as total_quantity,
	b.stock - COALESCE(SUM(quantity),0) as remaining_quantity
FROM book b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;