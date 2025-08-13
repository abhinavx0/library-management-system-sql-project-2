-- Project TASK

-- 2. CRUD Operations
-- Task 1. Create a New Book Record
-- "('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', '6.00', 'yes', 'Harper Lee','J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.
DELETE from Library_project.issued_status
Where issued_id = 'IS107';


-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM Library_project.issued_status
WHERE issued_emp_id ='E101';


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT 
    issued_member_id,
    count(issued_member_id) As No_of_book_issued
FROM Library_project.issued_status
Group by issued_member_id
Having count(issued_member_id)>1;


-- ### 3. CTAS (Create Table As Select)
-- Task 6: Create Summary Tables**:
-- Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_cnt as 
SELECT 
	b.isbn,
    b.book_title,
    Count(iss.issued_id) as no_issued
FROM books as b
LEFT JOIN issued_status as iss
ON b.isbn = iss.issued_book_isbn
Group by b.isbn, b.book_title;


-- ### 4. Data Analysis & Findings
-- Task 7. **Retrieve All Books in a Specific Category:
Select *
FROM books 
Where Category = 'Children';


-- Task 8: Find Total Rental Income by Category:
SELECT Category,
	Sum(rental_price) as Total_rental_income
FROM books as b 
LEFT JOIN issued_status as iss
ON b.isbn = iss.issued_book_isbn
GROUP BY Category;


-- Task 9. **List Members Who Registered in the Last 180 Days**:
SELECT *
FROM members 
WHERE reg_date between '2024-01-01' and '2024-12-31';


-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
SELECT 
	e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.branch_id,
    b.manager_id,
    e2.emp_name,
    b.branch_address,
    b.contact_no
FROM employees as e1
LEFT JOIN branch as b
ON b.branch_id = e1.branch_id
LEFT JOIN employees as e2
ON e2.emp_id = b.manager_id ;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
Create Table expensive_table as
Select * 
FROM books
Where rental_price >= 5;


-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM
(
	SELECT iss.issued_id,
		iss.issued_member_id,
        iss.issued_book_name,
		rs.return_id,
		rs.return_date
	FROM issued_status as iss
	LEFT JOIN return_status as rs
	ON iss.issued_id = rs.issued_id
)t
Where return_id is null;
    
