-- Create 'departments' table
CREATE TABLE departments (
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(255) NOT NULL
);

-- Create 'titles' table
CREATE TABLE titles (
    title_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Create 'employees' table
CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    emp_title_id VARCHAR(5) REFERENCES titles(title_id),
    birth_date DATE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F')),
    hire_date DATE NOT NULL
);

-- Create 'salaries' table
CREATE TABLE salaries (
    emp_no INT REFERENCES employees(emp_no),
    salary INT NOT NULL,
    PRIMARY KEY (emp_no, salary)
);

-- Create 'dept_emp' table
CREATE TABLE dept_emp (
    emp_no INT REFERENCES employees(emp_no),
    dept_no VARCHAR(4) REFERENCES departments(dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Create 'dept_manager' table
CREATE TABLE dept_manager (
    emp_no INT REFERENCES employees(emp_no),
    dept_no VARCHAR(4) REFERENCES departments(dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

\copy departments FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/departments.csv' DELIMITER ',' CSV HEADER;
\copy titles FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/titles.csv' DELIMITER ',' CSV HEADER;
\copy employees FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/employees.csv' DELIMITER ',' CSV HEADER;
\copy salaries FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/salaries.csv' DELIMITER ',' CSV HEADER;
\copy dept_emp FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/dept_emp.csv' DELIMITER ',' CSV HEADER;
\copy dept_manager FROM 'C:\Users\Jonathan Gonzalez\Documents\BootCamp\9SQL\Challenge/dept_manager.csv' DELIMITER ',' CSV HEADER;

-- List employee details including salary
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;

-- List employees hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- List managers for each department
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
JOIN employees e ON dm.emp_no = e.emp_no;

-- List department number and details for each employee
SELECT de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

-- List employees named Hercules and last name starts with 'B'
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- List each employee in the Sales department
SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE de.dept_no = 'd007'; -- assuming 'd007' is the Sales department number

-- List each employee in Sales and Development departments
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

-- Frequency count of employee last names in descending order
SELECT last_name, COUNT(*) as frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;