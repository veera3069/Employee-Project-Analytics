use project1;

--     ----- WorkForce Analytics -----

/* 1. Show the total number of employees in each department.
Include departments that currently have zero employees.
Sort by employee count in descending order.
How is workforce distributed across departments? */
select
	d.department_id,
    d.department_name,
    count(e.employee_id) as total_employees
from departments d
left join employees e
on d.department_id = e.department_id
group by department_id,
		department_name
order by total_employees desc;
# INSIGHT : Research and Engineering have the largest workforce, while HR and Finance operate with leaner teams.

/* 2.List departments that currently have no employees.
Are there inactive or underutilized departments? */
select
    department_name
from departments d
left join employees e
on d.department_id = e.department_id
where e.employee_id is null;
# INSIGHT : Any department appearing here may require hiring or restructuring review.

/* 3.Is hiring accelerating or slowing ?
Show number of employees hired per year.
Sort by year ascending. */
select
	year(hire_date) as hire_year,
    count(employee_id) as No_of_emps
from employees
group by year(hire_date)
order by hire_year asc;
# INSIGHT : Recent years show an increase in hiring, indicating expansion phase.

/* 4.Show number of employees hired per department per year.
   Sort by department name, then by year ascending. */
select
	d.department_name,
	year(e.hire_date) as hire_year,
    count(e.employee_id) as No_of_emps
from departments d
inner join employees e
on d.department_id = e.department_id
group by d.department_name,year(e.hire_date)
order by department_name asc, hire_year asc;
/* INSIGHT: Analyzing department-level hiring trends over time and identify growth patterns, 
which helps in workforce planning and understanding organizational expansion.*/

#per month
SELECT
    DATE_FORMAT(hire_date, '%Y-%m') AS hire_month,
    COUNT(employee_id) AS employees_hired
FROM employees
GROUP BY DATE_FORMAT(hire_date, '%Y-%m')
ORDER BY hire_month;

/* 5.Employees Without Project Allocation (Risk Indicator)
*/
select
	e.employee_id,
    concat(e.first_name,' ',e.last_name) as emp_name,
    d.department_name,
    e.hire_date
from employees e
inner join departments d
	on e.department_id = d.department_id
left join employee_projects ep
	on e.employee_id = ep.employee_id
where ep.employee_id is null;
#INSIGHT : Employees without project allocation may indicate bench strength or underutilization risk.

/* Show departments where more than 2 employees
 are currently not assigned to any project.*/
select
	d.department_name,
    count(e.employee_id) as no_emps
from departments d
inner join employees e
	on e.department_id = d.department_id
left join employee_projects ep
	on e.employee_id = ep.employee_id
where ep.employee_id is null
group by d.department_name
having count(e.employee_id) > 2;
/*INSIGHT: There are no departments which has 2 employees without active project allocation,
 indicating potential workforce utilization.*/

select *
from(
	select
		d.department_name,
		e.employee_id,
		count(e.employee_id) 
			over(partition by d.department_name) as no_emps
	from departments d
	inner join employees e
		on e.department_id = d.department_id
	left join employee_projects ep
		on e.employee_id = ep.employee_id
	where ep.employee_id is null)t
where t.no_emps >2;

with cte_emp as
(
	select
		d.department_name,
		e.employee_id,
		count(e.employee_id) 
			over(partition by d.department_name) as no_emps
	from departments d
	inner join employees e
		on e.department_id = d.department_id
	left join employee_projects ep
		on e.employee_id = ep.employee_id
	where ep.employee_id is null
)
select * from cte_emp ce
where ce.no_emps > 2;

/* 6.Low Salary Employees (Potential Attrition Risk)
Define low salary as below company average. */
select
	employee_id,
    concat(first_name,' ',last_name) as emp_name,
    salary
from employees
where salary < (select avg(salary) from employees);
/* INSIGHT: 
*/

/* 7.Show the department with the highest percentage of employees
 who are not assigned to any project. */
SELECT
    d.department_name,
    (
        SUM(CASE 
                WHEN ep.employee_id IS NULL THEN 1 
                ELSE 0 
            END) * 100.0
        / COUNT(e.employee_id)
    ) AS unassigned_percentage
FROM departments d
INNER JOIN employees e
    ON d.department_id = e.department_id
LEFT JOIN employee_projects ep
    ON e.employee_id = ep.employee_id
GROUP BY d.department_name
ORDER BY unassigned_percentage DESC
LIMIT 1;
/* INSIGHT:Identified the department with the highest idle workforce percentage
 using conditional aggregation and ratio KPIs to evaluate operational efficiency. */
 
with cte_empCount as
(
select
	d.department_name,
    count(*) as emps_per_dept
from departments d
inner join employees e
	on d.department_id = e.department_id
group by d.department_name
), cte_unassigned as
(select
	d.department_name,
    count(e.employee_id) as no_emps
from departments d
inner join employees e
	on e.department_id = d.department_id
left join employee_projects ep
	on e.employee_id = ep.employee_id
where ep.employee_id is null
group by d.department_name
)
, cte_percent as(
select
	cua.department_name,
	(cast(cua.no_emps as float) / 
		case when cec.emps_per_dept = 0 then null 
			else cec.emps_per_dept end) * 100 as Percentage
from cte_empCount as cec
left join cte_unassigned cua
on cec.department_name = cua.department_name
), cte_rank as(
select
	cp.department_name,
    cp.Percentage,
    rank() over(order by cp.Percentage desc) as high_rank
from cte_percent cp
)
select
	cr.department_name,
    cr.Percentage,
    cr.high_rank
from cte_rank cr
where cr.high_rank = 1;


