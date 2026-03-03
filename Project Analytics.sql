use project1;

--          ----- Project Analytics -----

/* Question 1 — Project Size Classification
For each project return:
	project_name
	number of employees assigned
	size category:
	'Small' → 1–2 employees
	'Medium' → 3–5 employees
	'Large' → more than 5
	'No Team' → 0 employees */

select
	t.*,
	case
		when assigned_emps = 0 then 'No Team'
        when assigned_emps > 5 then 'Large'
        when assigned_emps between 1 and 2 then 'Small'
        else 'Medium'
	end as Category
from(
select
	p.project_id,
    p.project_name,
    count(ep.employee_id) as assigned_emps
from projects p
inner join employee_projects ep
	on p.project_id = ep.project_id
group by p.project_id,p.project_name
)t;
/*This query classifies projects by team size, helping evaluate
 resource allocation across initiatives. It highlights under-resourced,
 balanced, and heavily staffed projects to support workload planning decisions.*/

/*Question 2 — Project Cost Analysis
For each project return:
	project_name
	total project salary cost (sum of salaries of assigned employees)
	average salary on the project
	number of employees assigned
Include projects with zero employees.
Order by total project cost descending. */

select
	p.project_name,
    coalesce(sum(e.salary),0) as total_project_cost,
	coalesce(avg(e.salary),0) as avg_project_cost,
    count(ep.employee_id) assigned_emps
from projects p
left join employee_projects ep
	on p.project_id = ep.project_id
left join employees e
	on e.employee_id =  ep.employee_id
group by p.project_id,p.project_name
order by total_project_cost desc;
/*This query analyzes project-level payroll investment by calculating total
 and average salary cost per project. It helps identify high-cost initiatives and
 supports budget monitoring and resource allocation decisions.*/
 
/*Question 3 — High Budget Projects
Return projects where:
Total salary cost is above the average project cost
Include:
	project_name
	total_project_cost */
    
with project_costs as (
    select
        p.project_id,
        p.project_name,
        coalesce(sum(e.salary),0) as total_project_cost
    from projects p
    left join employee_projects ep
        on p.project_id = ep.project_id
    left join employees e
        on ep.employee_id = e.employee_id
    group by p.project_id, p.project_name
)
select
    project_name,
    total_project_cost
from project_costs
where total_project_cost >
      (select avg(total_project_cost) from project_costs);
/* This query identifies projects whose total salary cost exceeds the overall
 average project cost. It highlights high-budget initiatives and helps management
 monitor cost-intensive projects. */

/* Question 4 — Most Valuable Employee Per Project
For each project, return:
	project_name
	employee_id
	employee full name
	employee salary
Condition:
Return the employee with the highest salary within each project.
If multiple employees share the same highest salary, return all of them.*/

select
	t.project_name,
	t.employee_id,
	t.full_name,
	t.salary
from(
	select
		p.project_name,
		ep.employee_id,
		concat(e.first_name,' ',e.last_name) as full_name,
		e.salary,
		dense_rank() over(partition by ep.project_id 
						order by e.salary desc) as Sal_Rank
	from projects p
	inner join employee_projects ep
		on p.project_id = ep.project_id
	left join employees e
		on ep.employee_id = e.employee_id)t
where t.Sal_Rank = 1;
/* This query identifies the highest-paid employee within each project
 using ranking logic. It helps highlight key cost drivers per project
 and understand salary concentration across initiatives.*/

/*Question 5 — Cross-Project High Performers
Return employees who are:
Assigned to more than one project
And are the highest-paid employee in at least one project
Return:
	employee_id
	full_name
	number_of_projects_assigned */
    
with cte_1 as (
    select
        ep.employee_id,
        count(ep.project_id) as number_of_projects_assigned
    from employee_projects ep
    group by ep.employee_id
    having count(ep.project_id) > 1
),
cte_2 as (
    select
        e.employee_id,
        concat(e.first_name,' ',e.last_name) as full_name,
        dense_rank() over(
            partition by ep.project_id
            order by e.salary desc
        ) as emp_rank
    from employees e
    inner join employee_projects ep
        on ep.employee_id = e.employee_id
)
select distinct
    c2.employee_id,
    c2.full_name,
    c1.number_of_projects_assigned
from cte_2 c2
inner join cte_1 c1
    on c1.employee_id = c2.employee_id
where c2.emp_rank = 1;

	