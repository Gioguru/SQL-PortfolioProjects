-- create a join table

Select * 
from Absenteeism_at_work a
left join compensation b
ON a.ID = b.ID
left join Reasons r
ON a.Reason_for_absence = r.Number;

---find the healthiest employees for the bonus
select *
from Absenteeism_at_work
Where Social_drinker = 0 and Social_smoker = 0
and Body_mass_index < 25 
and Absenteeism_time_in_hours < (Select AVG(Absenteeism_time_in_hours) from Absenteeism_at_work)


--- compensation rate increase for non-smokers/ budget $983,221 so .68 increase per hour/ 1,414.4 per year

select COUNT(*) as nonsmokers from Absenteeism_at_work
where Social_smoker = 0

--optimize this query
Select 
a.ID, 
r.reason,
Month_of_absence,
Body_mass_index,
CASE WHEN Body_mass_index < 18.5 then 'Underweight'
	 WHEN Body_mass_index Between 18.5 and 25 then 'Healthy Weight'
	 WHEN Body_mass_index Between 25 and 30 then 'Overweight'
	 WHEN Body_mass_index > 30 then 'Obese'
	 ELSE 'Unknown' end as BMI_Category,
CASE WHEN Month_of_absence In (12,1,2) Then 'Winter'
	 WHEN Month_of_absence In (3,4,5) Then 'Spring'
	 WHEN Month_of_absence In (6,7,8) Then 'Summer'
	 WHEN Month_of_absence In (9,10,11) Then 'Fall'
	 ELSE 'Unknown' END as Season_Names,
Month_of_absence,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
pet,
Disciplinary_failure,
Age,
Work_load_Average_day,
Absenteeism_time_in_hours
from Absenteeism_at_work a
left join compensation b
ON a.ID = b.ID
left join Reasons r
ON a.Reason_for_absence = r.Number;
