SELECT * from nchan.IC_BP_v2_csv
EXEC sp_rename 'nchan.IC_BP_v2_csv.BPAlerts', 'BPStatus', 'COLUMN'


alter table nchan.IC_BP_v2_csv drop column blood_pressure

update nchan.IC_BP_v2_csv 
set BPStatus = case BPStatus
	when 'Hypo1' then 'Controlled'
	when 'Normal' then 'Controlled'
	when 'Hypo2' then 'Uncontrolled'
	when 'HTN1' then 'Uncontrolled'
	when 'HTN2' then 'Uncontrolled'
	when 'HTN3' then 'Uncontrolled'
	else NULL
end

alter table nchan.IC_BP_v2_csv
add BP_Outcomes as (
case [BPStatus]
	when 'Controlled' then 1
	when 'Uncontrolled' then 0
	else NULL
end)

select * from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID

select avg(BP_Outcomes) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
GROUP BY ID

select DATEDIFF(week, cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL' and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'


select DATEDIFF(week, cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) from dbo.Demographics d
where d.tri_enrollmentcompletedate not like 'NULL' and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'

-- 1d
select cast(sum(BP_Outcomes) as float)/ cast(count(BP_Outcomes) as float) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and DATEDIFF(week, cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) >= 12
group by ID


-- entries with 12 or more weeks
select * from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and DATEDIFF(week, cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) >= 12

-- trying to get exactly 12 weeks, but another way to do 1d
select cast(sum(BP_Outcomes) as float)/ cast(count(BP_Outcomes) as float) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and cast(tri_enrollmentcompletedate as datetime) > DATEADD(week, 12, cast(tri_imaginecareenrollmentemailsentdate as datetime)) 
group by ID


-- 1e attempt
select cast(sum(BP_Outcomes) as float)/ cast(count(BP_Outcomes) as float) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and cast(tri_enrollmentcompletedate as datetime) = DATEADD(week, 1, cast(tri_imaginecareenrollmentemailsentdate as datetime))
group by ID

select cast(sum(BP_Outcomes) as float)/ cast(count(BP_Outcomes) as float) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and DATEDIFF(week,cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) >= 12
and cast(tri_enrollmentcompletedate as datetime) > DATEADD(week, 2, cast(tri_imaginecareenrollmentemailsentdate as datetime))
group by ID



select cast(sum(BP_Outcomes) as float)/ cast(count(BP_Outcomes) as float) from dbo.Demographics d
inner join 
nchan.IC_BP_v2_csv ibvc
on 
d.contactid = ibvc.ID
where d.tri_enrollmentcompletedate not like 'NULL'
and d.tri_imaginecareenrollmentemailsentdate not like 'NULL'
and DATEDIFF(week,cast(tri_imaginecareenrollmentemailsentdate as datetime), cast(tri_enrollmentcompletedate as datetime)) >= 12
and DATEADD(week, 1, cast(tri_imaginecareenrollmentemailsentdate as datetime)) <= cast(tri_enrollmentcompletedate as datetime)
group by ID


-- question 2


select * into nchan.mergedCDT from dbo.Conditions c
inner join
dbo.Demographics d
on 
c.tri_patientid = d.contactid
inner join
dbo.[Text] t
on 
d.contactid = t.tri_contactId


select * from nchan.mergedCDT cdt
where cdt.TextSentDate = (SELECT MAX(TextSentDate) from dbo.[Text] t where t.tri_contactId = cdt.tri_contactId)



SELECT * from nchan.mergedCDT
