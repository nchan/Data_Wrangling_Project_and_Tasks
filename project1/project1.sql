select Age, Gender, ID, State, EmailSentDate, CompleteDate from nchan.Demographics

EXEC sp_rename 'nchan.Demographics.tri_age', 'Age', 'COLUMN'
EXEC sp_rename 'nchan.Demographics.gendercode', 'Gender', 'COLUMN'
EXEC sp_rename 'nchan.Demographics.contactid', 'ID', 'COLUMN'
EXEC sp_rename 'nchan.Demographics.address1_stateorprovince', 'State', 'COLUMN'
EXEC sp_rename 'nchan.Demographics.tri_imaginecareenrollmentemailsentdate', 'EmailSentDate', 'COLUMN'
EXEC sp_rename 'nchan.Demographics.tri_enrollmentcompletedate', 'CompleteDate', 'COLUMN'


alter table nchan.Demographics
alter column EmailSentDate date [NULL | NOT NULL]
alter table nchan.Demographics
alter column CompleteDate date [NULL | NOT NULL]

select DATEDIFF(day, EmailSentDate, CompleteDate) from nchan.Demographics

drop table nchan.Demographics


select * into nchan.Demographics from dbo.Demographics

select * from nchan.Demographics

alter table nchan.Demographics
add EnrollmentStatus as (
case [tri_imaginecareenrollmentstatus]
	when 167410011 then 'Complete'
	when 167410001 then 'Email Sent'
	when 167410004 then 'Nonresponder'
	when 167410005 then 'Facilitated Enrollment'
	when 167410002 then 'Incomplete Enrollments'
	when 167410003 then 'Opted out'
	when 167410000 then 'Unprocessed'
	when 167410006 then 'Second email sent'
	else NULL
end)

alter table nchan.Demographics
drop column gender

alter table nchan.Demographics
add Gender as (
case [gendercode]
	when '2' then 'female'
	when '1' then 'male'
	when '167410000' then 'other'
	when 'NULL' then 'Unknown'
	else NULL
end)


select *,
CASE
	when Age between 0 and 25 then '0-25'
	when Age between 26 and 50 then '26-50'
	when Age between 51 and 75 then '51-75'
	when Age between 76 and 100 then '76-100'
	else '100+'
end as AgeGroup
from nchan.Demographics

alter table nchan.Demographics
add AgeGroup as (
	CASE
	when Age between 0 and 25 then '0-25'
	when Age between 26 and 50 then '26-50'
	when Age between 51 and 75 then '51-75'
	when Age between 76 and 100 then '76-100'
	else '100+'
end)
