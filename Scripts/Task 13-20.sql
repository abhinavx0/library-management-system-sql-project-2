-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's id, member's name, book title, issue date, and days overdue.
SELECT
	m.member_id,
    m.member_name,
    b.book_title,
    ist.issued_date,
    rs.return_date,
    datediff(current_date(),ist.issued_date) as Days_left
FROM issued_status as ist
LEFT JOIN members as m 
ON m.member_id = ist.issued_member_id
LEFT JOIN books as b
ON  ist.issued_book_isbn = b.isbn 
LEFT JOIN return_status as rs
ON rs.issued_id =ist.issued_id
Where rs.return_date is Null AND datediff(current_date(),ist.issued_date) > 30
ORDER BY 1;

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "available" when they are returned 
-- (based on entries in the return_status table).

-- Stored Procedure.
DELIMITER $$

DROP PROCEDURE IF EXISTS add_return_records $$

CREATE PROCEDURE add_return_records(IN p_return_id VARCHAR(50),IN p_issued_id VARCHAR(50))
BEGIN
    DECLARE v_isbn VARCHAR(50);

    -- Insert return record
    INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE());

    -- Get the book ISBN for the returned book
    SELECT issued_book_isbn
    INTO v_isbn
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status to available
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Thank you message
    SELECT CONCAT('Thanks for returning the book: ', v_isbn) AS message;
END $$

DELIMITER ;

CALL add_return_records('RS125','IS130');



-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued,
-- the number of books returned, and the total revenue generated from book rentals.
CREATE Table Report_branch as
SELECT 
	br.branch_id,
	br.manager_id,
	COUNT(ist.issued_id) as total_book_issued,
	COUNT(rs.return_id) as total_book_returned,
	SUM(b.rental_price) as total_revenue
FROM issued_status as ist
LEFT JOIN employees as e
ON e.emp_id = ist.issued_emp_id
LEFT JOIN branch as br
ON br.branch_id = e.branch_id
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
LEFT JOIN books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1,2; 

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members
--  who have issued at least one book in the last 6 months.
CREATE TABLE active_members as
SELECT * FROM members
WHERE member_id in (
SELECT distinct m.member_id
FROM members as m
JOIN issued_status as ist
ON m.member_id = ist.issued_member_id 
Where issued_date between '2024-01-01' AND current_date()
);


-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name,
    count(ist.issued_emp_id) as no_of_books_issued,
    e.branch_id
FROM issued_status as ist 
LEFT JOIN employees as e
ON e.emp_id = ist.issued_emp_id
GROUP BY ist.issued_emp_id
ORDER BY count(ist.issued_emp_id) DESC
limit 3;



-- Task 19: Stored Procedure
-- Objective: Create a stored procedure to manage the status of books in a library system.
--    Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
--    If a book is issued, the status should change to 'no'.
--    If a book is returned, the status should change to 'yes'.

-- FOR ISSUEING THE BOOKS.
DELIMITER $$

DROP PROCEDURE if exists issue_book $$
CREATE PROCEDURE issue_book(IN p_issued_id VARCHAR(15),
							   p_issued_member_id VARCHAR(10),
                               p_issued_book_isbn VARCHAR(50),
                               p_issued_emp_id VARCHAR(15))
BEGIN 
	-- declaring all the variable here.
    DECLARE v_status VARCHAR(15);
	
	-- all the code is here.
		-- checking if book is available 'yes'.
	SELECT status into v_status
    from books 
    where isbn = p_issued_book_isbn;

	-- Writing all the logical code here.
    IF v_status = 'yes' THEN
		INSERT INTO issued_status(issued_id,issued_member_id,issued_date,issued_book_isbn,issued_emp_id)
        VALUES (p_issued_id,p_issued_member_id,CURRENT_DATE(),p_issued_book_isbn,p_issued_emp_id);
        
        SELECT CONCAT('Books records added successfully for book isbn:',p_issued_book_isbn);
        
        UPDATE books
			SET status = 'No'
        WHERE isbn = p_issued_book_isbn;
        
	ELSE SELECT CONCAT('Sorry the book that you are requested is unavailable book_isbn:',p_issued_book_isbn);
    END if;
    
END $$
DELIMITER ;

-- Calling the stored Procedure.
CALL issue_book('IS142','C120','978-0-06-025492-6','E110');

-- FOR returning the books.
DELIMITER $$

DROP PROCEDURE if exists return_book $$
CREATE PROCEDURE return_book(IN p_return_id VARCHAR(15),
							   p_issued_id VARCHAR(10),
                               p_return_book_isbn VARCHAR(50))
BEGIN 
	-- declaring all the variable here.
    DECLARE v_status VARCHAR(15);
	
	-- all the code is here.
		-- checking if book is available 'yes'.
	SELECT status into v_status
    from books 
    where isbn = p_return_book_isbn;

	-- Writing all the logical code here.
    IF v_status = 'no' THEN
		INSERT INTO return_status(return_id,issued_id,return_date,return_book_isbn)
        VALUES (p_return_id,p_issued_id,CURRENT_DATE(),p_return_book_isbn);
        
        SELECT CONCAT('Return Books records added successfully for book isbn:',p_return_book_isbn);
        
        UPDATE books
			SET status = 'yes'
        WHERE isbn = p_return_book_isbn;
        
	ELSE SELECT CONCAT('Sorry  Invalid Entry the book is not issued book_isbn:',p_return_book_isbn);
    END if;
    
END $$
DELIMITER ;

-- Calling the stored Procedure.
CALL return_book('RS126','IS 141','978-0-06-025492-6');



-- Task 20: Create Table As Select (CTAS)
-- Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days.
-- The table should include:
--    The number of overdue books.
 --   The total fines, with each day's fine calculated at $0.50.
--    The number of books issued by each member.
--    The resulting table should show:
--    Member ID
--    Number of overdue books
--    Total fines

-- Task 20: Create Table As Select (CTAS)
-- Create a summary table showing overdue books and fines for each member
CREATE TABLE overdue_summary AS
SELECT 
    iss.issued_member_id AS member_id,  -- Member ID
    COUNT(CASE 
              WHEN rs.return_id IS NULL 
                   AND DATEDIFF(CURRENT_DATE, iss.issued_date) > 30 
              THEN 1 
         END) AS overdue_books,  -- Count of overdue books
         
    SUM(CASE 
            WHEN rs.return_id IS NULL 
                 AND DATEDIFF(CURRENT_DATE, iss.issued_date) > 30 
            THEN (DATEDIFF(CURRENT_DATE, iss.issued_date) - 30) * 0.50 
            ELSE 0 
        END) AS total_fines,  -- Fine = (days overdue * $0.50)
        
    COUNT(iss.issued_id) AS total_books_issued  -- Total books issued by the member
FROM issued_status AS iss
LEFT JOIN return_status AS rs
    ON iss.issued_id = rs.issued_id  -- Include issued books whether returned or not
GROUP BY iss.issued_member_id;
