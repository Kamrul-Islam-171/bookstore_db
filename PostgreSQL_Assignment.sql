-- Active: 1743833652149@@127.0.0.1@5432@bookstore_db

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    author VARCHAR(250) NOT NULL,
    price NUMERIC(10, 2) CHECK (price >= 0),
    stock INT DEFAULT 0,
    published_year INT
);

DROP TABLE books;

INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

SELECT * FROM books;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

drop TABLE customers;

INSERT INTO customers ("name", email, joined_date) VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20');
INSERT INTO customers ("name", email) VALUES
('Alita', 'alita@email.com');


SELECT * FROM customers;

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) on DELETE CASCADE,
    book_id INT REFERENCES books(id) on DELETE CASCADE,
    quantity INT CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT current_timestamp
);

DROP TABLE orders;

INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');


SELECT * FROM orders;

--  Find books that are out of stock.
SELECT title FROM books WHERE stock = 0;

-- Retrieve the most expensive book in the store.
SELECT * FROM books ORDER BY price Desc LIMIT 1;

-- Find the total number of orders placed by each customer.

SELECT customers."name", COUNT(*) as total_orders FROM orders 
JOIN customers ON orders.customer_id = customers.id
GROUP BY customers."name";


-- Calculate the total revenue generated from book sales.
select sum(books.price * orders.quantity) as total_revenue
from books
join orders on books.id = orders.book_id;

-- List all customers who have placed more than one order.
select customers."name", COUNT(*) as orders_count
from orders
join customers on orders.customer_id = customers.id
GROUP BY customers."name" HAVING COUNT(*) > 1;

-- Find the average price of books in the store.
select round(avg(price),2) as avg_book_price from books;

-- Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price + (price * 0.1)
WHERE published_year < 2000;

select * from books ORDER BY id ASC;

-- Delete customers who haven't placed any orders.
-- SELECT customer_id FROM orders GROUP BY customer_id;
-- SELECT * FROM customers 
-- WHERE id NOT IN (SELECT customer_id FROM orders GROUP BY customer_id);

DELETE FROM customers 
WHERE id NOT IN 
(SELECT customer_id FROM orders GROUP BY customer_id);

SELECT * FROM customers;