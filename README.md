# 📚 Library Management System – SQL Project

This project is a **Library Management System** built using SQL.  
It demonstrates the use of **DDL (Data Definition Language), DML (Data Manipulation Language), CRUD operations, CTAS (Create Table As Select), Stored Procedures, and Analytical Queries**.  

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
---
## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

Hi there! I'm Abhinav Om, currently a 3rd-year undergraduate student at the Indian Institute of Information Technology (IIIT) Ranchi.
I'm passionate about turning raw data into meaningful insights and am actively working toward a career as a Data Analyst or Business Analyst.

I enjoy solving real-world problems through data, exploring trends, and drawing actionable conclusions that drive decision-making.
I'm constantly improving my skills in SQL, Excel, Python, and data visualization tools like Power BI and Tableau.
With hands-on project experience in data warehousing and analytics, I'm building a strong foundation for a future in analytics and consulting.
