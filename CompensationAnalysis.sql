use project1;

--             ----- COMPENSATION ANALYSIS -----

/* 1.Show the average salary per department.
Exclude NULL salaries from the calculation.
Sort by highest average salary first. */
select
	d.department_name,
    avg(e.salary) as avg_sal
FROM departments d
inner join employees e
	on d.department_id = e.department_id
group by d.department_name
order by avg_sal desc;
/*This query compares average salaries across departments to identify high-cost business units.
 It helps assess payroll distribution and supports compensation planning decisions. */

/* 2.Show departments whose average salary 
is above the company-wide average salary. */
select
	d.department_name,
    avg(e.salary) as avg_sal
FROM departments d
inner join employees e
	on d.department_id = e.department_id
group by d.department_name
having avg(e.salary) > (select avg(salary) from employees);
/* This query identifies departments paying above the company average salary.
 It highlights higher-cost teams and supports compensation benchmarking.*/
 
/* 3.Show employees who earn more than
the average salary of their own department. */
select
	*
from(
	select
		e.employee_id,
		concat(e.first_name,' ',e.last_name) as emp_name,
		d.department_name,
		e.salary,
		avg(e.salary) 
			over(partition by d.department_id) as dept_avg_sal
	from employees e
	inner join departments d
		on e.department_id = d.department_id
)t
where salary > dept_avg_sal;

# 4.Show the top-paid employee in each department.
select
	t.employee_id,
    t.emp_name,
    t.department_name,
    t.salary
from(
select
	e.employee_id,
	concat(e.first_name,' ',e.last_name) as emp_name,
    d.department_name,
    e.salary,
    dense_rank() over(partition by d.department_id 
			order by e.salary desc) as emp_rank
from employees e
inner join departments d
	on e.department_id = d.department_id
)t
where emp_rank = 1;
/* This query identifies the highest-paid employee in each department
 using ranking logic. It helps analyze pay leadership,detect salary outliers,
 and understand compensation hierarchy within teams. */