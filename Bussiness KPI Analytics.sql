use project1;

--       --- Business KPI Analytics (Window + Advanced Aggregations) ---

/*Challenge 1 — Top Earners Per Department (With Ties)
	department_name
	employee_id
	full_name
	salary
Rules:
Show the top 2 highest paid employees per department
If there is a tie in salary, include all tied employees
Departments with no employees should not appear*/
select
	t.department_name,
	t.employee_id,
	t.full_name,
	t.salary
from(
	select
		d.department_name,
		e.employee_id,
        e.salary,
        concat(e.first_name,' ',e.last_name) as full_name,
		dense_rank() over(partition by d.department_id
						order by e.salary desc) as sal_rank
	from employees e
	inner join departments d
		on e.department_id = d.department_id
)t
where t.sal_rank <= 2;
/* This query identifies the top two highest-paid employees per department,
 including salary ties. It helps analyze compensation hierarchy and detect
 salary concentration within teams.*/

/*	 Challenge 2 — Salary Above Department Average
Return employees whose salary is above their department's average salary.
Columns:
	employee_id
	full_name
	department_name
	salary
	department_avg_salary
This tests:
Window functions vs GROUP BY
Analytical thinking*/
with cte_1 as 
(
select
	e.employee_id,
	concat(e.first_name,' ',e.last_name) as full_name,
	d.department_name,
	e.salary,
    avg(e.salary) over(partition by d.department_id) as dept_avg
from employees e
inner join departments d
	on e.department_id = d.department_id
)
select
	c1.employee_id,
	c1.full_name,
	c1.department_name,
	c1.salary
from cte_1 as c1
where c1.salary > c1.dept_avg;
/*This query identifies employees earning above their department’s average
 salary using window functions. It helps detect high performers or
 premium-paid roles within each team.*/

/* Challenge 3 — Second Highest Salary Company-wide
Return the second highest salary in the company.
Handle edge cases:
What if there is no second highest?
What if multiple employees share that salary? */
select
	t.employee_id,
	concat(t.first_name,' ',t.last_name) as full_name,
	t.department_id,
	t.salary
from(
select
	*,
    dense_rank() over(order by salary desc) sal_rank
from employees
)t
where t.sal_rank = 2;
/* This query retrieves employees earning the second-highest salary
 company-wide, including ties. It helps analyze executive pay tiers and
 overall salary distribution structure. */
