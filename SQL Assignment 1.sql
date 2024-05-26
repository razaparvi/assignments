CREATE TABLE employees (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    First_name VARCHAR(50) NOT NULL,
    age INT,
    job_title VARCHAR(100),
    date_of_birth DATE,
    phone_number VARCHAR(15),
    insurance_id VARCHAR(15)
);
select * from employees;

INSERT INTO employees (last_name, First_name, age, job_title, date_of_birth, phone_number, insurance_id)
VALUES 
('Smith', 'John', 32, 'Manager', '1989-05-12', '5551234567', 'INS736'),
('Johnson', 'Sarah', 28, 'Analyst', '1993-09-20', '5559876543', 'INS832'),
('Davis', 'David', 45, 'HR', '1976-02-03', '5550555995', 'INS007'),
('Brown', 'Emily', 37, 'Lawyer', '1984-11-15', '5551112022', 'INS035'),
('Wilson', 'Michael', 41, 'Accountant', '1980-07-28', '5554403003', 'INS943'),
('Anderson', 'Lisa', 22, 'Intern', '1999-03-10', '5556667777', 'INS332'),
('Thompson', 'Alex', 29, 'Sales Representative', '1995-06-15', '5552120111', 'INS433');

select * from employees;

ALTER TABLE employees
RENAME COLUMN ID TO employee_ID;

ALTER TABLE employees
MODIFY COLUMN phone_number VARCHAR(10);

CREATE TABLE employee_insurance (
    insurance_id VARCHAR(15) PRIMARY KEY,
    insurance_info VARCHAR(100)
);

INSERT INTO employee_insurance (insurance_id, insurance_info)
VALUES 
("INS736", "unavailable"),
("INS832", "unavailable"),
("INS007", "unavailable"),
("INS035", "unavailable"),
("INS943", "unavailable"),
("INS332", "unavailable"),
("INS433", "unavailable");

ALTER TABLE employees
ADD CONSTRAINT fk_insurance_id
FOREIGN KEY (insurance_id)
REFERENCES employee_insurance(insurance_id);

ALTER TABLE employees
ADD COLUMN email VARCHAR(255);

set sql_safe_update = 0;
UPDATE employees
SET email = 'unavailable';

select * from employee_insurance;

select* from employees;

set sql_safe_update = 0;