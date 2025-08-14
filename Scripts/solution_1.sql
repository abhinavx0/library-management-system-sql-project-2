-- ================================
-- Project TASK: Library Management SQL Operations
-- ================================

-- Task 1: Create a New Book Record
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', '6.00', 'yes', 'Harper Lee','J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table
DELETE FROM Library_project.issued_status
WHERE issued_id = 'IS107';

-- Task 4: Retrieve All Books Issued by a Specific Employee
SELECT *
FROM Library_project.issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book
SELECT 
    issued_member_id,
    COUNT(issued_member_id) AS No_of_book_issued
FROM Library_project.issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_member_id) > 1; -- HAVING is used instead of WHERE because it filters after aggregation

-- Task 6: Create Summary Table of Each Book and Total Issued Count
CREATE TABLE book_cnt AS 
SELECT 
    b.isbn,
    b.book_title,
    COUNT(iss.issued_id) AS no_issued
FROM books AS b
LEFT JOIN issued_status AS iss
    ON b.isbn = iss.issued_book_isbn  -- LEFT JOIN ensures books with zero issues are also included
GROUP BY b.isbn, b.book_title;

-- Task 7: Retrieve All Books in a Specific Category
SELECT *
FROM books 
WHERE Category = 'Children';

-- Task 8: Find Total Rental Income by Category
SELECT 
    Category,
    SUM(rental_price) AS Total_rental_income
FROM books AS b 
LEFT JOIN issued_status AS iss
    ON b.isbn = iss.issued_book_isbn -- Joining issued records to calculate rental income per category
GROUP BY Category;

-- Task 9: List Members Who Registered in the Last 180 Days
SELECT *
FROM members 
WHERE reg_date BETWEEN '2024-01-01' AND '2024-12-31'; -- Could use CURRENT_DATE - INTERVAL for dynamic results

-- Task 10: List Employees with Their Branch Manager's Name and Branch Details
SELECT 
    e1.emp_id,
    e1.emp_name AS employee_name,
    e1.position,
    e1.salary,
    b.branch_id,
    b.manager_id,
    e2.emp_name AS manager_name,
    b.branch_address,
    b.contact_no
FROM employees AS e1
LEFT JOIN branch AS b
    ON b.branch_id = e1.branch_id
LEFT JOIN employees AS e2
    ON e2.emp_id = b.manager_id; -- Self-join on employees to get manager details

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE expensive_table AS
SELECT * 
FROM books
WHERE rental_price >= 5;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * 
FROM (
    SELECT 
        iss.issued_id,
        iss.issued_member_id,
        iss.issued_book_name,
        rs.return_id,
        rs.return_date
    FROM issued_status AS iss
    LEFT JOIN return_status AS rs
        ON iss.issued_id = rs.issued_id -- LEFT JOIN ensures issued books without return record are included
) t
WHERE return_id IS NULL; -- NULL return_id means the book hasn't been returned
