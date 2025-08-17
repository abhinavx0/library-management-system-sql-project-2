-- Library Management System Project.
Create Database Library_project;

-- Creating Tables Branch for Data Importion
DROP Table if Exists Branch;
CREATE Table Branch
(
	branch_id VARCHAR(15) Primary key,
    manager_id	VARCHAR(15),
    branch_address	VARCHAR(15),
    contact_no VARCHAR(15)
);
-- Creating Tables books for Data Importion
DROP Table if Exists books;
CREATE Table books
(
	isbn VARCHAR(25) primary key,	
    book_title	VARCHAR(115),
    category	VARCHAR(25),
    rental_price FLOAT,
    status	VARCHAR(15),
    author	VARCHAR(50),
    publisher VARCHAR(50)
);
-- Creating Tables employees for Data Importion
DROP Table if Exists employees;
CREATE Table employees
(
	emp_id	VARCHAR (15) primary key,
    emp_name VARCHAR(50),	
    position VARCHAR(40),
    salary	INT,
    branch_id VARCHAR(15)
);
-- Creating Tables issued_status for Data Importion
DROP Table if Exists issued_status;
CREATE Table issued_status
(
	issued_id	VARCHAR(15) Primary Key,
    issued_member_id VARCHAR(10), -- FK
    issued_book_name VARCHAR(100),
    issued_date	DATE,
    issued_book_isbn VARCHAR(50), -- FK
    issued_emp_id VARCHAR(15) -- FK
);
-- Creating Tables members for Data Importion
DROP Table if Exists members;
CREATE Table members
(
	member_id	VARCHAR(15) Primary Key,
    member_name	VARCHAR(30),
    member_address VARCHAR(30),	
    reg_date DATE
);
-- Creating Tables return_status for Data Importion
DROP Table if Exists return_status;
CREATE Table return_status
(
	return_id VARCHAR(15) Primary Key,
    issued_id	VARCHAR(10),
    return_book_name	VARCHAR(100),
    return_date	DATE,
    return_book_isbn VARCHAR(50)
);


-- Checking the Table After Importing the Datas.
Select * from Library_project.Branch;
SELECT * FROM Library_project.books;
SELECT * FROM Library_project.employees;
SELECT * FROM Library_project.issued_status;
SELECT * FROM Library_project.members;
SELECT * FROM Library_project.return_status;

-- Adding Foregin key to the Tables.
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
foreign key (issued_member_id)
references members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
foreign key (issued_book_isbn)
references books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
foreign key (branch_id)
references Branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);

