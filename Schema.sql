create database project1;
use project1;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    department_id INT,
    
    FOREIGN KEY (department_id) 
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    department_id INT,
    
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);

CREATE TABLE employee_projects (
    emp_proj_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    project_id INT,
    allocation_percentage INT,
    
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON DELETE CASCADE,
        
    FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE
);

INSERT INTO departments (department_name, location) VALUES
('Engineering', 'Hyderabad'),
('Human Resources', 'Mumbai'),
('Finance', 'Delhi'),
('Marketing', 'Bangalore'),
('Operations', 'Chennai'),
('Research', 'Pune');

INSERT INTO employees 
(first_name, last_name, email, hire_date, salary, department_id) VALUES

-- Engineering (1)
('Aarav','Sharma','aarav.sharma@company.com','2019-03-15',85000,1),
('Isha','Reddy','isha.reddy@company.com','2020-07-10',92000,1),
('Karan','Mehta','karan.mehta@company.com','2021-01-05',78000,1),
('Sneha','Iyer','sneha.iyer@company.com','2022-09-18',NULL,1),
('Rahul','Verma','rahul.verma@company.com','2018-11-25',105000,1),
('Neha','Kapoor','neha.kapoor@company.com','2023-02-14',72000,1),

-- HR (2)
('Priya','Nair','priya.nair@company.com','2020-06-01',60000,2),
('Rohan','Das','rohan.das@company.com','2019-08-20',58000,2),
('Meera','Joshi','meera.joshi@company.com','2022-04-11',NULL,2),
('Ankit','Rao','ankit.rao@company.com','2021-12-01',62000,2),

-- Finance (3)
('Vikram','Singh','vikram.singh@company.com','2017-05-17',95000,3),
('Pooja','Malhotra','pooja.malhotra@company.com','2019-10-10',88000,3),
('Arjun','Patel','arjun.patel@company.com','2023-01-09',73000,3),

-- Marketing (4)
('Simran','Gill','simran.gill@company.com','2021-03-03',67000,4),
('Aditya','Kulkarni','aditya.kulkarni@company.com','2020-11-19',71000,4),
('Nisha','Bansal','nisha.bansal@company.com','2022-07-22',69000,4),

-- Operations (5)
('Manoj','Kumar','manoj.kumar@company.com','2018-02-14',80000,5),
('Divya','Menon','divya.menon@company.com','2019-09-30',76000,5),
('Siddharth','Jain','siddharth.jain@company.com','2021-05-25',NULL,5),
('Kavya','Shetty','kavya.shetty@company.com','2022-12-12',74000,5),

-- Research (6)
('Tanvi','Chopra','tanvi.chopra@company.com','2023-06-01',90000,6),
('Harsh','Agarwal','harsh.agarwal@company.com','2022-01-15',87000,6),
('Alok','Mishra','alok.mishra@company.com','2020-03-27',82000,6),
('Ritika','Saxena','ritika.saxena@company.com','2019-04-04',NULL,6),
('Dev','Tiwari','dev.tiwari@company.com','2021-08-18',91000,6),
('Ananya','Gupta','ananya.gupta@company.com','2024-01-02',68000,6);

INSERT INTO projects 
(project_name, start_date, end_date, department_id) VALUES

('AI Platform Upgrade','2023-01-01',NULL,1),
('Cloud Migration','2022-05-01','2023-12-31',1),

('HR Automation','2023-03-15',NULL,2),

('Financial Forecast 2024','2023-07-01',NULL,3),

('Brand Revamp','2022-02-01','2023-02-01',4),

('Supply Chain Optimization','2023-06-01',NULL,5),

('Quantum Research Initiative','2024-01-01',NULL,6),
('Data Innovation Lab','2023-04-01',NULL,6);

INSERT INTO employee_projects 
(employee_id, project_id, allocation_percentage) VALUES

-- Engineering
(1,1,100),
(2,1,80),
(3,2,60),
(5,1,100),
(6,2,70),

-- HR
(7,3,100),
(8,3,60),

-- Finance
(11,4,100),
(12,4,80),

-- Marketing
(14,5,100),
(15,5,70),

-- Operations
(17,6,100),
(18,6,60),

-- Research
(21,7,100),
(22,7,70),
(23,8,80),
(25,8,90);
