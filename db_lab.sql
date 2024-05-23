
----------------------- COMPANY ----------------------------------
CREATE TABLE company(
	serial_no SERIAL UNIQUE NOT NULL,
	company_id INT PRIMARY KEY,
	company_code VARCHAR(100) NOT NULL,
	company_name VARCHAR(200) NOT NULL,
	company_desc TEXT
);

SELECT * FROM company;

INSERT INTO company (company_id, company_code, company_name, company_desc)
VALUES (1011, 'lst', 'Luminous Sun LTD', 'A software company');

UPDATE company SET company_name = 'Luminous Sun Tech LTD';

DELETE FROM company WHERE company_id = 1011;
----------------------- COMPANY ----------------------------------

----------------------- DEPARTMENT ----------------------------------
CREATE TABLE department(
	serial_no SERIAL UNIQUE NOT NULL,
	dept_code VARCHAR(100) PRIMARY KEY,
	dept_name VARCHAR(100) NOT NULL,
	dept_desc TEXT,
	company_id INT,

	FOREIGN KEY (company_id)
		REFERENCES company(company_id) ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT * FROM department;

INSERT INTO department(dept_code, dept_name, dept_desc, company_id)
VALUES
	('fnc', 'Finance & Accounting', 'For finanace related', 1011),
	('it', 'Information & Technology', 'For IT related', 1011),
	('ntw', 'Networking', 'For finanace related', 1011);

UPDATE department SET dept_desc = 'Only for finance' WHERE dept_code = 'fnc';
DELETE FROM department WHERE dept_code = 'fnc';
----------------------- DEPARTMENT ----------------------------------

----------------------- EMPLOYEES ----------------------------------
CREATE TABLE employees(
	serial_no SERIAL UNIQUE NOT NULL,
	emp_code VARCHAR(100) PRIMARY KEY,
	dept_code VARCHAR(100),
	company_id INT,

	FOREIGN KEY (dept_code)
		REFERENCES department(dept_code) ON UPDATE CASCADE ON DELETE CASCADE,

	FOREIGN KEY (company_id)
		REFERENCES company(company_id) ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT * FROM employees;

INSERT INTO employees(emp_code, dept_code, company_id)
VALUES
	('IT5055', 'it', 1011),
	('IT5056', 'it', 1011),
	('FNC33', 'fnc', 1011),
	('NTW78', 'ntw', 1011);

UPDATE employees SET emp_code = 'IT5054' WHERE emp_code = 'IT5055';
DELETE FROM employees WHERE emp_code = 'IT5054';
----------------------- EMPLOYEES ----------------------------------

----------------------- EMPLOYEE DETAILS ----------------------------------
CREATE TABLE employee_detail(
	serial_no SERIAL UNIQUE NOT NULL,
	emp_code VARCHAR(100),
	emp_name VARCHAR(100) NOT NULL,
	emp_email VARCHAR(100),
	emp_phone VARCHAR(100) NOT NULL,
	emp_address VARCHAR(100) NOT NULL DEFAULT 'Dhaka, Bangladesh',
	emp_age INT CHECK (emp_age >= 20),

	FOREIGN KEY (emp_code)
		REFERENCES employees(emp_code) ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT * FROM employee_detail;

INSERT INTO employee_detail(emp_code, emp_name, emp_email, emp_phone, emp_address, emp_age)
VALUES
	('IT5055', 'Akash', '', '01548798856', 'Chittagong', 24),
	('IT5056', 'Ruhan', 'ruhan@gmail.com', '01578895689', 'Dhaka', 28),
	('FNC33', 'Nayeef', 'nayeef@gmail.com', '0141417445', 'Dhaka', 21),
	('NTW78', 'Kader', 'kader@gmail.com', '01877898956', 'Barishal', 35);

UPDATE employee_detail SET emp_email = 'akash@yahoo.com' WHERE emp_code = 'IT5055';
DELETE FROM employee_detail WHERE emp_code = 'IT5055';
----------------------- EMPLOYEE DETAILS ----------------------------------

--------------------------- CREATING VIEW -----------------------------------------
-- Create a view with company employee count
CREATE VIEW company_with_emp_count AS
SELECT c.company_id, c.company_name, COUNT(e.*) AS total_emp
FROM company c JOIN employees e ON c.company_id = e.company_id
GROUP BY c.company_id;

SELECT * FROM company_with_emp_count;

-- Create a view with full employee detail
CREATE VIEW emp_full AS
SELECT ed.*
FROM employees e JOIN employee_detail ed ON e.emp_code = ed.emp_code;

SELECT * FROM emp_full;

-- Create a view with employee working in a department
CREATE VIEW emp_working_dept AS
SELECT e.emp_code, ed.emp_name, d.dept_code, d.dept_name
FROM employees e 
	JOIN employee_detail ed ON e.emp_code = ed.emp_code
	JOIN department d ON e.dept_code = d.dept_code;

SELECT * FROM emp_working_dept;
--------------------------- CREATING VIEW -----------------------------------------

