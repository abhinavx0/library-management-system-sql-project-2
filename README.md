# 📚 Library Management System using SQL 

## 🔎 Project Overview

**Title:** Library Management System  

This project is a hands-on implementation of a **Library Management System** using SQL.  
It covers **database design, table creation, CRUD operations, CTAS, and advanced SQL queries** to manage and analyze library data efficiently. The project highlights practical database management and query-writing skills.  

<img width="690" height="261" alt="Image" src="https://github.com/user-attachments/assets/f5aba886-e209-4158-8a84-41029174808a" />

---

## 🎯 Objectives

1. **Database Setup** – Create and populate tables for branches, employees, members, books, issued records, and returns.  
2. **CRUD Operations** – Perform **Create, Read, Update, Delete** actions on the database.  
3. **CTAS (Create Table As Select)** – Build new tables from existing query results.  
4. **Advanced Queries** – Write optimized SQL queries for analysis and reporting.  

---

## 🗂 Project Structure

- **Database Creation** – Setup of `library_project`.  
- **Table Design** – Branches, Employees, Members, Books, Issued Status, Return Status.  
- **Relationships** – Primary keys and foreign keys for data integrity.  
- **CRUD & CTAS** – Operations to manipulate and transform data.  
- **Queries** – Advanced queries to generate insights.  

---

## 1. Database & Table Creation
```sql
-- Create database
CREATE DATABASE Library_project;

-- Branch info
DROP TABLE IF EXISTS Branch;
CREATE TABLE Branch (
    branch_id VARCHAR(15) PRIMARY KEY,   -- Branch ID
    manager_id VARCHAR(15),              -- Manager of branch
    branch_address VARCHAR(15),          -- Address
    contact_no VARCHAR(15)               -- Contact number
);

-- Books info
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(25) PRIMARY KEY,        -- Book ISBN
    book_title VARCHAR(115),             -- Title
    category VARCHAR(25),                -- Category
    rental_price FLOAT,                  -- Rent price
    status VARCHAR(15),                  -- Availability
    author VARCHAR(50),                  -- Author
    publisher VARCHAR(50)                -- Publisher
);

-- Employee details
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(15) PRIMARY KEY,      -- Employee ID
    emp_name VARCHAR(50),                -- Name
    position VARCHAR(40),                -- Role
    salary INT,                          -- Salary
    branch_id VARCHAR(15)                -- Branch (FK)
);

-- Issued book records
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(15) PRIMARY KEY,   -- Issue ID
    issued_member_id VARCHAR(10),        -- Member (FK)
    issued_book_name VARCHAR(100),       -- Book name
    issued_date DATE,                    -- Date issued
    issued_book_isbn VARCHAR(50),        -- Book ISBN (FK)
    issued_emp_id VARCHAR(15)            -- Employee (FK)
);

-- Member details
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(15) PRIMARY KEY,   -- Member ID
    member_name VARCHAR(30),             -- Name
    member_address VARCHAR(30),          -- Address
    reg_date DATE                        -- Registration date
);

-- Returned book records
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(15) PRIMARY KEY,   -- Return ID
    issued_id VARCHAR(10),               -- Issued record (FK)
    return_book_name VARCHAR(100),       -- Book name
    return_date DATE,                    -- Return date
    return_book_isbn VARCHAR(50)         -- Book ISBN
);

-- Relationships (FKs)
ALTER TABLE issued_status ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id) REFERENCES members(member_id);

ALTER TABLE issued_status ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn);

ALTER TABLE issued_status ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id);

ALTER TABLE employees ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id) REFERENCES Branch(branch_id);

ALTER TABLE return_status ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id);
```

2. CRUD Operations
Task 1: Insert a New Book
```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```
Task 2: Update a Member’s Address
```sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
```
Task 3: Delete an Issued Record
```sql
DELETE FROM Library_project.issued_status
WHERE issued_id = 'IS107';
```
Task 4: Retrieve Books Issued by a Specific Employee
```sql
SELECT * FROM Library_project.issued_status
WHERE issued_emp_id = 'E101';
```
Task 5: Find Members Who Issued More Than One Book
```sql
SELECT issued_member_id,
       COUNT(issued_member_id) AS No_of_book_issued
FROM Library_project.issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_member_id) > 1;  -- HAVING filters after aggregation
```
3. CTAS (Create Table As Select)
Task 6: Create a Book Issue Count Table
```sql
CREATE TABLE book_cnt AS
SELECT b.isbn, b.book_title,
       COUNT(iss.issued_id) AS no_issued
FROM books AS b
LEFT JOIN issued_status AS iss
ON b.isbn = iss.issued_book_isbn   -- LEFT JOIN keeps books with zero issues
GROUP BY b.isbn, b.book_title;
```
Task 11: Expensive Books Table
```sql
CREATE TABLE expensive_table AS
SELECT * FROM books
WHERE rental_price >= 5;
```
4. Data Analysis & Queries
Task 7: Books in a Specific Category
```sql
SELECT * FROM books
WHERE category = 'Children';
```
Task 8: Total Rental Income by Category
```sql
SELECT b.category,
       SUM(b.rental_price) AS total_rental_income
FROM books AS b
LEFT JOIN issued_status AS iss
ON b.isbn = iss.issued_book_isbn
GROUP BY b.category;
```
Task 9: Members Registered in the Last 180 Days
```sql
SELECT * FROM members
WHERE reg_date BETWEEN '2024-01-01' AND '2024-12-31';
-- NOTE: Replace with CURRENT_DATE - INTERVAL for dynamic reporting
```
Task 10: Employees with Branch Manager Info
```sql
SELECT e1.emp_id, e1.emp_name AS employee_name,
       e1.position, e1.salary,
       b.branch_id, b.manager_id,
       e2.emp_name AS manager_name,
       b.branch_address, b.contact_no
FROM employees AS e1
LEFT JOIN branch AS b ON b.branch_id = e1.branch_id
LEFT JOIN employees AS e2 ON e2.emp_id = b.manager_id;  -- Self join for manager
```
Task 12: Books Not Yet Returned
```sql
SELECT *
FROM (
    SELECT iss.issued_id, iss.issued_member_id,
           iss.issued_book_name,
           rs.return_id, rs.return_date
    FROM issued_status AS iss
    LEFT JOIN return_status AS rs
    ON iss.issued_id = rs.issued_id
) t
WHERE return_id IS NULL; -- NULL means not returned
```
5. Advanced Tasks (13–20)
Task 13: Identify Members with Overdue Books
```sql
SELECT m.member_id, m.member_name,
       b.book_title, ist.issued_date,
       rs.return_date,
       DATEDIFF(CURRENT_DATE(), ist.issued_date) AS days_overdue
FROM issued_status AS ist
LEFT JOIN members AS m ON m.member_id = ist.issued_member_id
LEFT JOIN books AS b ON ist.issued_book_isbn = b.isbn
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
  AND DATEDIFF(CURRENT_DATE(), ist.issued_date) > 30
ORDER BY m.member_id;
```
Task 14: Stored Procedure – Update Book Status on Return
```sql
DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(50),
    IN p_issued_id VARCHAR(50)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);

    -- Insert into return_status
    INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE());

    -- Fetch ISBN for the returned book
    SELECT issued_book_isbn INTO v_isbn
    FROM issued_status WHERE issued_id = p_issued_id;

    -- Update book status back to available
    UPDATE books SET status = 'yes'
    WHERE isbn = v_isbn;
END $$

DELIMITER ;
```
Task 15: Branch Performance Report
```sql
CREATE TABLE report_branch AS
SELECT br.branch_id, br.manager_id,
       COUNT(ist.issued_id) AS total_books_issued,
       COUNT(rs.return_id) AS total_books_returned,
       SUM(b.rental_price) AS total_revenue
FROM issued_status AS ist
LEFT JOIN employees AS e ON e.emp_id = ist.issued_emp_id
LEFT JOIN branch AS br ON br.branch_id = e.branch_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
LEFT JOIN books AS b ON b.isbn = ist.issued_book_isbn
GROUP BY br.branch_id, br.manager_id;
```
Task 16: Active Members (Last 6 Months)
```sql
CREATE TABLE active_members AS
SELECT * FROM members
WHERE member_id IN (
    SELECT DISTINCT m.member_id
    FROM members AS m
    JOIN issued_status AS ist
    ON m.member_id = ist.issued_member_id
    WHERE issued_date BETWEEN '2024-01-01' AND CURRENT_DATE()
);
```
Task 17: Employees with Most Issues Processed
```sql
SELECT e.emp_name,
       COUNT(ist.issued_emp_id) AS no_of_books_issued,
       e.branch_id
FROM issued_status AS ist
LEFT JOIN employees AS e ON e.emp_id = ist.issued_emp_id
GROUP BY ist.issued_emp_id
ORDER BY no_of_books_issued DESC
LIMIT 3;
```
Task 19: Stored Procedures for Issuing & Returning Books
-- Issue Book
```sql
DELIMITER $$
CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(15),
    IN p_issued_member_id VARCHAR(10),
    IN p_issued_book_isbn VARCHAR(50),
    IN p_issued_emp_id VARCHAR(15)
)
BEGIN
    DECLARE v_status VARCHAR(15);
    SELECT status INTO v_status FROM books WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE(), p_issued_book_isbn, p_issued_emp_id);

        UPDATE books SET status = 'no'
        WHERE isbn = p_issued_book_isbn;
    END IF;
END $$
DELIMITER ;

-- Return Book
DELIMITER $$
CREATE PROCEDURE return_book(
    IN p_return_id VARCHAR(15),
    IN p_issued_id VARCHAR(10),
    IN p_return_book_isbn VARCHAR(50)
)
BEGIN
    DECLARE v_status VARCHAR(15);
    SELECT status INTO v_status FROM books WHERE isbn = p_return_book_isbn;

    IF v_status = 'no' THEN
        INSERT INTO return_status(return_id, issued_id, return_date, return_book_isbn)
        VALUES (p_return_id, p_issued_id, CURRENT_DATE(), p_return_book_isbn);

        UPDATE books SET status = 'yes'
        WHERE isbn = p_return_book_isbn;
    END IF;
END $$
DELIMITER ;
```
Task 20: Overdue Books & Fines (CTAS)
```sql 
CREATE TABLE overdue_summary AS
SELECT iss.issued_member_id AS member_id,
       COUNT(CASE 
              WHEN rs.return_id IS NULL 
                   AND DATEDIFF(CURRENT_DATE, iss.issued_date) > 30 
              THEN 1 END) AS overdue_books,
       SUM(CASE 
              WHEN rs.return_id IS NULL 
                   AND DATEDIFF(CURRENT_DATE, iss.issued_date) > 30 
              THEN (DATEDIFF(CURRENT_DATE, iss.issued_date) - 30) * 0.50 
              ELSE 0 END) AS total_fines,
       COUNT(iss.issued_id) AS total_books_issued
FROM issued_status AS iss
LEFT JOIN return_status AS rs
ON iss.issued_id = rs.issued_id
GROUP BY iss.issued_member_id;
```
## 🔑 Key Concepts Covered

- **CRUD Operations** → Insert, Update, Delete, Select  
- **CTAS** → Create summary tables from queries  
- **JOINs** → Using INNER JOIN and LEFT JOIN for combining data across tables  
- **Aggregation** → Applying `COUNT`, `SUM`, and `HAVING` for grouped analysis  
- **Stored Procedures** → Automating issuing and returning book processes  
- **Business Logic** → Implementing overdue fine calculation & branch performance reports  


🚀 This project demonstrates how SQL can be used to model, manage, and analyze a Library Management System with real-world business logic.
---
## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

Hi there! I'm Abhinav Om, currently a 3rd-year undergraduate student at the Indian Institute of Information Technology (IIIT) Ranchi.
I'm passionate about turning raw data into meaningful insights and am actively working toward a career as a Data Analyst or Business Analyst.

I enjoy solving real-world problems through data, exploring trends, and drawing actionable conclusions that drive decision-making.
I'm constantly improving my skills in SQL, Excel, Python, and data visualization tools like Power BI and Tableau.
With hands-on project experience in data warehousing and analytics, I'm building a strong foundation for a future in analytics and consulting.
