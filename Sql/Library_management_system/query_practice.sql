!------------QUERY PRACTICE OF LIBRARY MANAGEMENT SYSTEM---------------!


Q1 Retrieve the names and nationalities of all authors in the database.
Ans:

SELECT a.author_name, a.nationality 
FROM author as a;
        
output:-
  author_name  | nationality 
---------------+-------------
 J.K. Rowling  | British
 George Orwell | African
 MS chauhan    | Indian
 Amy Poehler   | American
 Stephan King  | American



Q2 Find out how many books are available in the Horror Section.
Ans: 

SELECT COUNT(available_quantity) 
FROM Book
WHERE section_id = (
    SELECT section_id
    FROM Section
    WHERE section_name = 'Horror Section'
) AND available_quantity > 0;

output:-
 count 
-------
     4



Q3 List all members who have borrowed books and their corresponding return dates.
Ans:

SELECT m.member_name , t.returndate 
FROM member m JOIN transaction t on m.member_id = t.member_id ;

output:-
 member_name | returndate 
-------------+------------
 Nishchay    | 2024-05-30
 Nishchay    | 2024-05-15
 Pragya      | 2024-05-19
 Deepin      | 2024-06-10
 Nishchay    | 2024-07-25
 Pragya      | 2024-06-26
 Deepin      | 2024-02-09
 Pragya      | 2024-07-11



Q4 Display the titles of books borrowed by a specific member.
Ans:

SELECT b.title
FROM Book b
JOIN Transaction t ON b.isbn = t.isbn
JOIN Member m ON t.member_id = m.member_id
WHERE m.member_name = 'Nishchay';

output:
                  title                  
-----------------------------------------
 Harry Potter and the Philosophers Stone
 1984



Q5 Calculate the total fine amount that has been paid by all members.
Ans: 

SELECT SUM(fine_amount) AS total_fine_paid
FROM Fine
WHERE payment_status = 'Paid';

output:
 total_fine_paid 
-----------------
           15.00



Q6 Identify the librarian who issued the most transactions.
Ans:

SELECT l.librarian_name, COUNT(t.transaction_id) AS transaction_count
FROM Librarian l
JOIN Transaction t ON l.librarian_id = t.librarian_id
GROUP BY l.librarian_name
ORDER BY transaction_count DESC
LIMIT 1;
 
OR

SELECT librarian_name 
FROM librarian 
WHERE librarian_id IN 
    (SELECT t.librarian_id 
     FROM transaction t 
     GROUP BY t.librarian_id 
     ORDER BY t.librarian_id DESC
     LIMIT 1);

output:
 librarian_name | transaction_count 
----------------+-------------------
 Kavita         |                 3



Q7 Show the titles of books with their corresponding authors and genres.
Ans:

SELECT b.title , g.genre_name, a.author_name 
FROM book b 
JOIN author a ON b.author_id = a.author_id 
JOIN genre g ON b.genre_id = g.genre_id ;

output:
                  title                  |   genre_name    |  author_name  
-----------------------------------------+-----------------+---------------
 Harry Potter and the Deathly Hallows    | Fantasy         | J.K. Rowling
 Harry Potter and the Philosophers Stone | Fantasy         | J.K. Rowling
 The Shining                             | Horror          | Stephan King
 Bird Box                                | Horror          | Stephan King
 Dracula                                 | Horror          | J.K. Rowling
 1984                                    | Horror          | George Orwell
 Pride and Prejudice                     | Literature      | MS chauhan
 Inception                               | Literature      | George Orwell
 Catch-22                                | Comedy          | Amy Poehler
 Bossypants                              | Comedy          | J.K. Rowling
 Yesplease                               | Comedy          | J.K. Rowling
 Enders Game                             | Science Fiction | J.K. Rowling



Q8 Find out which section has the highest capacity.
Ans:

SELECT * 
FROM Section 
ORDER BY capacity DESC 
LIMIT 1;

OR

SELECT *
FROM Section
WHERE capacity = (
    SELECT MAX(capacity)
    FROM Section
);

output:
 section_id |    section_name    | capacity 
------------+--------------------+----------
          3 | Literature Section |      500



Q9 List all transactions issued by a specific librarian.
Ans:

SELECT * 
FROM transaction 
WHERE librarian_id IN
    (SELECT l.librarian_id 
     FROM librarian l 
     WHERE l.librarian_name = 'Jitender'
    );

output:
 transaction_id | member_id |  isbn  | issuedate  | returndate | librarian_id 
----------------+-----------+--------+------------+------------+--------------
              4 |         4 | 978076 | 2024-05-13 | 2024-06-10 |            3
              6 |         3 | 978076 | 2024-05-22 | 2024-06-26 |            3
              7 |         4 | 978077 | 2024-01-26 | 2024-02-09 |            3



Q10 Display the names and email addresses of all members who have unpaid fines.
Ans:

SELECT m.member_name, m.email
FROM Member m
JOIN Transaction t ON m.member_id = t.member_id
JOIN Fine f ON t.transaction_id = f.transaction_id
WHERE f.payment_status = 'Unpaid';

output:
 member_name |            email             
-------------+------------------------------
 Nishchay    | nishugupta123gupta@gmail.com



Q11 Retrieve the names of authors who have written more than one book.
Ans:

SELECT a.author_name
FROM Author a
JOIN Book b ON a.author_id = b.author_id
GROUP BY a.author_id
HAVING COUNT(b.author_id) > 1;

output:
  author_name  
---------------
 Stephan King
 George Orwell
 J.K. Rowling



Q12 Find the name and email of the member who has the earliest issued book.
Ans: 

SELECT m.member_name, m.email
FROM Member m
JOIN Transaction t ON m.member_id = t.member_id
ORDER BY t.issuedate ASC
LIMIT 1;

output:
 member_name |      email       
-------------+------------------
 Deepin      | deepin@gmail.com



Q13 Display the section names that have books by 'George Orwell'.
Ans:

SELECT s.section_name
FROM Section s
JOIN Book b ON s.section_id = b.section_id
JOIN Author a ON b.author_id = a.author_id
WHERE a.author_name = 'George Orwell';

output:
    section_name    
--------------------
 Horror Section
 Literature Section



Q14 Calculate the total number of books in each genre.
Ans:

SELECT g.genre_name, SUM(b.quantity) AS quantity
FROM Book b
JOIN Genre g ON g.genre_id = b.genre_id
GROUP BY g.genre_id, g.genre_name;

output:
   genre_name    | sum 
-----------------+-----
 Literature      |   9
 Science Fiction |   1
 Comedy          |  48
 Horror          |  18
 Fantasy         |   8



Q15 List all the members who have never borrowed a book.
Ans:

SELECT m.member_name
FROM Member m
LEFT JOIN Transaction t ON m.member_id = t.member_id
WHERE t.member_id IS NULL;

output:
 member_name 
-------------
 Naman



Q16 Show the most popular genre based on the number of books borrowed.
Ans:

SELECT g.genre_name                                 
FROM Genre g
JOIN Book b ON g.genre_id = b.genre_id
GROUP BY g.genre_id              
HAVING (MAX(b.quantity - b.available_quantity)) = 
    (SELECT MAX(quantity - available_quantity) FROM Book);

OR

SELECT g.genre_name, COUNT(t.isbn) AS books_borrowed
FROM Genre g
JOIN Book b ON g.genre_id = b.genre_id
JOIN Transaction t ON b.isbn = t.isbn
GROUP BY g.genre_name
ORDER BY books_borrowed DESC
LIMIT 1;

output:
 genre_name | books_borrowed 
------------+----------------
 Comedy     |              4



Q17 Display the details of the book with the highest quantity.
Ans:

SELECT * 
FROM Book
ORDER BY quantity DESC
LIMIT 1;

output:
  isbn  |  title   | author_id | genre_id | quantity | available_quantity | section_id 
--------+----------+-----------+----------+----------+--------------------+------------
 975987 | Catch-22 |         4 |        4 |       19 |                 19 |          4



Q18 Retrieve the names of members who have fines that were issued in the last 30 days.
Ans:

SELECT DISTINCT m.member_name
FROM Member m
JOIN Transaction t ON m.member_id = t.member_id
JOIN Fine f ON t.transaction_id = f.transaction_id
WHERE f.fine_date >= CURRENT_DATE - INTERVAL '30 days';
 member_name 

output:
 member_name 
-------------
 Nishchay



Q19 List all the unique genres available in the library.
Ans:

SELECT DISTINCT genre_name
FROM Genre;

output:
   genre_name    
-----------------
 Comedy
 Literature
 Fantasy
 Horror
 Science Fiction



Q20 Find the average capacity of sections in the library.
Ans: 

SELECT AVG(capacity) AS Avg_capacity 
FROM section ;

output:
     avg_capacity     
----------------------
 159.0000000000000000



Q21 Find the age of the member from dob.
Ans:

SELECT member_name , dob , EXTRACT(YEAR FROM AGE(CURRENT_DATE ,dob)) AS age 
FROM member;

OR

SELECT member_name , dob , EXTRACT(YEAR FROM AGE(dob)) AS age 
FROM member;

output:
 member_name |    dob     | age 
-------------+------------+-----
 Nishchay    | 2002-10-16 |  21
 Naman       | 2002-11-06 |  21
 Pragya      | 2004-01-24 |  20
 Deepin      | 2002-06-15 |  21



Q22 Find the name of the member who has borrowed the most books.
Ans: 

SELECT m.member_name
FROM Member m
JOIN Transaction t ON m.member_id = t.member_id
JOIN Book b ON t.isbn = b.isbn
GROUP BY m.member_id, m.member_name
ORDER BY COUNT(b.isbn) DESC
LIMIT 1;

OR

SELECT m.member_name 
FROM member m 
JOIN transaction t ON m.member_id = t.member_id 
GROUP BY m.member_id 
ORDER BY count(t.transaction_id) DESC 
LIMIT 1;

output:
 member_name 
-------------
 Pragya



Q23  Retrieve the title of book that have been borrowed the most.
Ans:  

SELECT b.title 
FROM book b 
JOIN transaction t ON t.isbn = b.isbn
GROUP BY b.isbn
ORDER BY COUNT(t.transaction_id) DESC
LIMIT 1;

output:
   title   
-----------
 Yesplease



Q24 List the member names who have borrowed books from the 'Horror Section'.
Ans:

SELECT m.member_name
FROM Member m
JOIN Transaction t ON m.member_id = t.member_id
JOIN Book b ON t.isbn = b.isbn
JOIN Section s ON b.section_id = s.section_id
WHERE s.section_name = 'Horror Section';

output:
 member_name 
-------------
 Nishchay



Q25 Display the genre names along with the average quantity of books available in each genre.
Ans:

SELECT g.genre_name, AVG(b.available_quantity) AS avg_available_quantity
FROM genre g
JOIN book b ON g.genre_id = b.genre_id
GROUP BY g.genre_id;

output:
   genre_name    | avg_available_quantity 
-----------------+------------------------
 Comedy          |    14.0000000000000000
 Literature      |     3.5000000000000000
 Fantasy         |     3.5000000000000000
 Horror          |     3.7500000000000000
 Science Fiction | 0.00000000000000000000



Q26 List all the books that have been borrowed only once.
Ans:

SELECT b.*
FROM book b
JOIN transaction t on b.isbn = t.isbn
GROUP BY b.isbn
HAVING COUNT(t.transaction_id) = 1;

output:
  isbn  |                  title                  | author_id | genre_id | quantity | available_quantity | section_id 
--------+-----------------------------------------+-----------+----------+----------+--------------------+------------
 978077 | Bossypants                              |         1 |        4 |       14 |                 13 |          4
 978055 | Harry Potter and the Philosophers Stone |         1 |        1 |        5 |                  4 |          1
 978014 | 1984                                    |         2 |        2 |        7 |                  7 |          2


Q27 Show the names of members who have borrowed books in the last 30 days and have fines.
Ans:

SELECT DISTINCT m.member_name
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN fine f on f.transaction_id = t.transaction_id
where t.issuedate >= CURRENT_DATE - INTERVAL '30 days';

output:
 member_name 
-------------
 Nishchay



Q28 Display the librarian names along with the total fine amount they have collected.
Ans:

SELECT l.librarian_name, SUM(f.fine_amount) AS total_fine
FROM librarian l
JOIN transaction t ON l.librarian_id = t.librarian_id
JOIN fine f ON t.transaction_id = f.transaction_id
GROUP BY l.librarian_name;

output:
 librarian_name | total_fine 
----------------+------------
 Dinesh         |      40.00



Q29 Display the author detials whose books have been borrowed from the library.
Ans:

SELECT DISTINCT a.*
FROM author a
JOIN book b ON a.author_id = b.author_id
JOIN transaction t ON b.isbn = t.isbn;

output:
 author_id |  author_name  | nationality 
-----------+---------------+-------------
         2 | George Orwell | African
         1 | J.K. Rowling  | British

  

Q30 List the books details that have never been borrowed.
Ans:

SELECT b.*
FROM book b
LEFT JOIN transaction t ON b.isbn = t.isbn
WHERE t.transaction_id IS NULL;

output:
  isbn  |                title                 | author_id | genre_id | quantity | available_quantity | section_id 
--------+--------------------------------------+-----------+----------+----------+--------------------+------------
 975987 | Catch-22                             |         4 |        4 |       19 |                 19 |          4
 978990 | The Shining                          |         5 |        2 |        1 |                  0 |          2
 978090 | Enders Game                          |         1 |        5 |        1 |                  0 |          5
 990208 | Pride and Prejudice                  |         3 |        3 |        2 |                  2 |          3
 977101 | Dracula                              |         1 |        2 |        3 |                  2 |          2
 978054 | Harry Potter and the Deathly Hallows |         1 |        1 |        3 |                  3 |          1
 977000 | Bird Box                             |         5 |        2 |        7 |                  6 |          2



Q31 Calculate the average fine amount per member.
Ans:

SELECT m.member_name, AVG(f.fine_amount) AS avg_fine_amount
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN fine f ON t.transaction_id = f.transaction_id
GROUP BY m.member_id;

output:
 member_name |   avg_fine_amount   
-------------+---------------------
 Nishchay    | 20.0000000000000000



Q32  Find the average time (in days) members take to return books.
Ans:

SELECT m.member_name, AVG(AGE(t.returndate, t.issuedate)) AS avg_borrow_duration
FROM member m
JOIN transaction t ON m.member_id = t.member_id
GROUP BY m.member_name;

output:
 member_name | avg_borrow_duration 
-------------+---------------------
 Pragya      | 1 mon 27 days
 Nishchay    | 1 mon 23 days
 Deepin      | 21 days



Q33 Find the authors who have the highest number of books in the library
Ans: 

SELECT a.author_name, COUNT(b.isbn) AS book_count
FROM author a
JOIN book b ON a.author_id = b.author_id
GROUP BY a.author_name
ORDER BY book_count DESC
LIMIT 1;

output:
 author_name  | book_count 
--------------+------------
 J.K. Rowling |          6



Q34 List the members who have borrowed the same book more than once.
Ans:

SELECT m.member_name, b.title, COUNT(t.isbn) AS borrow_count
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN book b ON t.isbn = b.isbn
GROUP BY m.member_name, b.title
HAVING COUNT(t.isbn) > 1;

output:
 member_name |   title   | borrow_count 
-------------+-----------+--------------
 Pragya      | Inception |            2



Q35 Find the genres that have the highest number of available books
Ans

SELECT g.genre_name, SUM(b.available_quantity) AS total_available_books
FROM genre g
JOIN book b ON g.genre_id = b.genre_id
GROUP BY g.genre_name
ORDER BY total_available_books DESC
LIMIT 1;

output:
 genre_name | total_available_books 
------------+-----------------------
 Comedy     |                    42



Q36 Find the details of books that are currently available for borrowing:
Ans:

SELECT b.*
FROM book b
WHERE b.available_quantity > 0;

output:
  isbn  |                  title                  | author_id | genre_id | quantity | available_quantity | section_id 
--------+-----------------------------------------+-----------+----------+----------+--------------------+------------
 978055 | Harry Potter and the Philosophers Stone |         1 |        1 |        5 |                  4 |          1
 978054 | Harry Potter and the Deathly Hallows    |         1 |        1 |        3 |                  3 |          1
 978014 | 1984                                    |         2 |        2 |        7 |                  7 |          2
 978076 | Yesplease                               |         1 |        4 |       15 |                 10 |          4
 978077 | Bossypants                              |         1 |        4 |       14 |                 13 |          4
 978009 | Inception                               |         2 |        3 |        7 |                  5 |          3
 977101 | Dracula                                 |         1 |        2 |        3 |                  2 |          2
 977000 | Bird Box                                |         5 |        2 |        7 |                  6 |          2
 990208 | Pride and Prejudice                     |         3 |        3 |        2 |                  2 |          3
 975987 | Catch-22                                |         4 |        4 |       19 |                 19 |          4



Q37 Calculate the age of each member and display it in years and months.
Ans:

SELECT member_name, dob,
       EXTRACT(YEAR FROM AGE(dob)) AS years,
       EXTRACT(MONTH FROM AGE(dob)) AS months
FROM member;

OR

SELECT member_name,
       dob,
       DATE_PART('year', age(dob)) AS years,
       DATE_PART('month', age(dob)) AS months
FROM member;

output:
 member_name |    dob     | years | months 
-------------+------------+-------+--------
 Nishchay    | 2002-10-16 |    21 |      7
 Naman       | 2002-11-06 |    21 |      6
 Pragya      | 2004-01-24 |    20 |      4
 Deepin      | 2002-06-15 |    21 |     11



Q38 List the titles of books along with the number of times they have been borrowed, only for books borrowed more than twice.
Ans:

SELECT b.title, 
       COUNT(t.transaction_id) AS borrow_count
FROM book b
JOIN transaction t ON b.isbn = t.isbn
GROUP BY b.title
HAVING COUNT(t.transaction_id) > 2;

output:
 title     | borrow_count 
-----------+---------------
 Yesplease |             3



Q39 Display the average fine amount collected per day.
Ans:

SELECT DATE_TRUNC('day', fine_date) AS day, 
       AVG(fine_amount) AS average_fine
FROM fine
GROUP BY DATE_TRUNC('day', fine_date)
ORDER BY day;

output:
            day            |    average_fine     
---------------------------+---------------------
 2024-05-20 00:00:00+05:30 | 25.0000000000000000
 2024-05-23 00:00:00+05:30 | 15.0000000000000000

OR

SELECT Extract(day from fine_date) AS day, 
       AVG(fine_amount) AS average_fine
FROM fine
GROUP BY Extract(day from fine_date)
ORDER BY day;

output:
 day |    average_fine     
-----+---------------------
  20 | 25.0000000000000000
  23 | 15.0000000000000000



Q39 Retrieve the details of the member who have a fine amount greater than the average fine;
Ans:

SELECT DISTINCT m.*
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN fine f ON t.transaction_id = f.transaction_id
WHERE f.fine_amount > (SELECT AVG(fine_amount) FROM fine);

output:
 member_id | member_name |    dob     |  phone_no  |            email             |       address        | occupation 
-----------+-------------+------------+------------+------------------------------+----------------------+------------
         1 | Nishchay    | 2002-10-16 | 9588169118 | nishugupta123gupta@gmail.com | #494 sector-6 karnal | student

  

Q40 Find the most recent book borrowed by each member.
Ans: 

SELECT DISTINCT ON (m.member_id) m.member_name, b.title, t.issuedate
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN book b ON t.isbn = b.isbn
ORDER BY m.member_id, t.issuedate DESC;

output:
 member_name |                  title                  | issuedate  
-------------+-----------------------------------------+------------
 Nishchay    | Harry Potter and the Deathly Hallows    | 2024-05-30
 Pragya      | Inception                               | 2024-05-19
 Deepin      | Yesplease                               | 2024-05-13



Q41 Find the total quantity of books in each genre.
Ans:

SELECT g.genre_name, 
       SUM(b.quantity) AS total_quantity
FROM genre g
JOIN book b ON g.genre_id = b.genre_id
JOIN transaction t ON b.isbn = t.isbn
GROUP BY g.genre_id;

output:
   genre_name    | total_quantity 
-----------------+----------------
 Literature      |              9
 Science Fiction |              1
 Comedy          |             48
 Horror          |             18
 Fantasy         |              8



Q42 List the names of members who have not borrowed any book in the last 6 months.
Ans:

SELECT DISTINCT m.member_name
FROM member m
LEFT JOIN transaction t ON m.member_id = t.member_id 
    AND t.issuedate >= CURRENT_DATE - INTERVAL '6 months'
WHERE t.transaction_id IS NULL;

OR

SELECT DISTINCT m.member_name
FROM member m
WHERE m.member_id NOT IN (
    SELECT DISTINCT t.member_id
    FROM transaction t
    WHERE t.issuedate >= CURRENT_DATE - INTERVAL '6 months'
);

output:
 member_name 
-------------
 Naman



Q43 Retrieve the titles of books borrowed by members whose age is more than 20 years.
Ans:

SELECT DISTINCT b.title
FROM book b
JOIN transaction t ON b.isbn = t.isbn
JOIN member m ON t.member_id = m.member_id
WHERE EXTRACT(YEAR FROM AGE(m.dob)) > 20;

output:
                  title                  
-----------------------------------------
 Bossypants
 Harry Potter and the Philosophers Stone
 1984
 Yesplease



Q44  Find the total number of distinct genres borrowed by each member
Ans:

SELECT m.member_name, COUNT(DISTINCT b.genre_id) AS genres_borrow
FROM member m
JOIN transaction t ON m.member_id = t.member_id
JOIN book b ON t.isbn = b.isbn
GROUP BY m.member_name;

output:
 member_name | genres_borrow 
-------------+---------------
 Deepin      |             1
 Nishchay    |             3
 Pragya      |             2



Q45 List members who have borrowed more books than the average number of books borrowed by all members.
Ans:

WITH avg_borrowed AS (
    SELECT AVG(book_count) 
    FROM (
        SELECT COUNT(*) AS book_count
        FROM transaction
        GROUP BY member_id
    ) 
)
SELECT m.member_name
FROM member m
JOIN transaction t ON m.member_id = t.member_id
GROUP BY m.member_name
HAVING COUNT(*) > (SELECT * FROM avg_borrowed);

OR

SELECT m.member_name
FROM member m
JOIN transaction t ON m.member_id = t.member_id
GROUP BY m.member_name
HAVING COUNT(*) > (
  SELECT AVG(book_count) 
  FROM (
    SELECT COUNT(*) AS book_count
    FROM transaction
    GROUP BY member_id
      )
  )
;

output:
 member_name 
-------------
 Pragya
 Nishchay



Q46 List members who have not borrowed any books from a particular section (e.g., 'Comedy Section').
Ans:

SELECT DISTINCT m.member_name
FROM member m
LEFT JOIN (
    SELECT t.member_id
    FROM transaction t
    JOIN book b ON t.isbn = b.isbn
    JOIN section s ON b.section_id = s.section_id
    WHERE s.section_name = 'Comedy Section'
) AS tr ON m.member_id = tr.member_id
WHERE tr.member_id IS NULL;

output:
 member_name 
-------------
 Naman



Q47 List the genres and the average age of members who have borrowed books in those genres.
Ans:

SELECT g.genre_id ,g.genre_name, AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.dob))) AS avg_age
FROM genre g
JOIN book b ON g.genre_id = b.genre_id
JOIN transaction t ON b.isbn = t.isbn
JOIN member m ON t.member_id = m.member_id
GROUP BY g.genre_id 
ORDER BY avg_age DESC;

output:
 genre_id | genre_name |       avg_age       
----------+------------+---------------------
        2 | Horror     | 21.0000000000000000
        1 | Fantasy    | 21.0000000000000000
        4 | Comedy     | 20.7500000000000000
        3 | Literature | 20.0000000000000000



Q48 SQL query to find the average fine amount paid by members who have borrowed books from the 'Fantasy'  genre.
Ans:

SELECT AVG(f.fine_amount) AS average_fine_amount
FROM fine f
JOIN transaction t ON f.transaction_id = t.transaction_id
JOIN book b ON t.isbn = b.isbn
JOIN genre g ON b.genre_id = g.genre_id
JOIN member m ON t.member_id = m.member_id
WHERE g.genre_name IN ('Fantasy')
GROUP BY m.member_id
HAVING COUNT(DISTINCT g.genre_id) = 1;

output:
 average_fine_amount 
---------------------
 20.0000000000000000



Q49 SQL query to identify the most common day of the week for book returns, along with the total number of returns on that day.
Ans:

SELECT EXTRACT(DOW FROM t.returndate) AS return_day_of_week, COUNT(*) AS return_count
FROM transaction t
GROUP BY return_day_of_week
ORDER BY return_count DESC
LIMIT 1;

output:
 return_day_of_week | return_count 
--------------------+--------------
                  4 |            3



Q50 SQL query to retrieve the names of members who have borrowed books from both the 'Fantasy Section', 'Comedy Section' and  'Horror Section'. 
    Display the member names along with the titles of the books borrowed from each section.
Ans:

SELECT m.member_name, b1.title AS fantasy_book, b2.title AS sci_fi_book, b3.title AS comedy_book
FROM member m
JOIN transaction t1 ON m.member_id = t1.member_id
JOIN book b1 ON t1.isbn = b1.isbn
JOIN section s1 ON b1.section_id = s1.section_id
JOIN transaction t2 ON m.member_id = t2.member_id
JOIN book b2 ON t2.isbn = b2.isbn
JOIN section s2 ON b2.section_id = s2.section_id
JOIN transaction t3 ON m.member_id = t3.member_id
JOIN book b3 ON t3.isbn = b3.isbn
JOIN section s3 ON b3.section_id = s3.section_id
WHERE s1.section_name = 'Fantasy Section'
AND s2.section_name = 'Horror Section'
AND s3.section_name = 'Comedy Section';

output:
 member_name |              fantasy_book               | sci_fi_book | comedy_book 
-------------+-----------------------------------------+-------------+-------------
 Nishchay    | Harry Potter and the Philosophers Stone | 1984        | Yesplease