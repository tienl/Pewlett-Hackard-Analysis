-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL, 
	title VARCHAR(22) NOT NULL,
	from_date DATE NOT NULL,
	to_date  DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);
CREATE TABLE dept_emp (
	emp_no INT NOT NULL, 
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date  DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM titles
SELECT first_name, last_name, birth_date
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31' 

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
	
	
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

select * from current_emp;


-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO newopenings 
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no 

select * from newopenings

SELECT * FROM salaries
ORDER BY to_date DESC;


SELECT emp_no,
	first_name,
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

drop table emp_info

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
		  
		  
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT re.emp_no, 
	re.first_name,
	re.last_name,
	d.dept_name
--INTO drill
FROM retirement_info AS re
INNER JOIN dept_emp AS de
ON (re.emp_no = de.emp_no)
--sales = d007 development = d005
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_no IN ('d007','d005')




select * from departments
	
	select *from dept_emp
drop table deliv1

--deliverable 1 number of retiring employee by title 
-- retiring = 1952-1955 
-- group by title 
-- inner join 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	ti.title, 
	ti.to_date,
	s.salary	
--INTO deliv1  commented out after table is formed, for usage in pgadmin on screen
FROM employees as e
INNER JOIN titles as ti 
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries as s 
ON (e.emp_no = s.emp_no)
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
group by ti.title, e.emp_no, ti.to_date, s.salary
;



-- finding duplicates from deliv1 - internet method
select emp_no, first_name, count(*) 
from deliv1 
group by emp_no, first_name
having count (*) > 1


-- Partition the data to show only most recent title per employee
-- deliverable 1.2
SELECT emp_no,
 first_name,
 last_name,
 title,
 to_date,
 salary
INTO deliv1_2  -- after table is created comment out to view in pgadmin
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 to_date,
 salary,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM deliv1
 ) tmp WHERE rn = 1
ORDER BY emp_no;


--deliverable 2 mentorship eligibility 
-- Birthdate = 1965
-- 2x inner join 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	ti.title, 
	d.from_date,
	d.to_date
INTO deliv2  --commenting out once table is built for pgadmin view
FROM employees as e
INNER JOIN dept_emp as d 
ON (e.emp_no = d.emp_no)
INNER JOIN titles as ti 
ON (e.emp_no = ti.emp_no)
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
--order by emp_no  -- while there are dups the rubik did not specifically call out to remove them.  Discussion over slack confirmed additional data should be useful to have, and no need to remove dupes



select * from deliv2 order by emp_no


	



select * from titles ORDER BY emp_no

INNER JOIN titles as ti 
ON (e.emp_no = ti.emp_no)

--find and remove duplicate for deliverable 2 
SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 to_date
INTO deliv2_2  -- after table is created comment out to view in pgadmin
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
  to_date,
   ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM deliv2
 ) tmp WHERE rn = 1
ORDER BY emp_no;

select * from titles where emp_no = 10291
