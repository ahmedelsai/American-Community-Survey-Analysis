-------------------------------------------------------data cleaning process---------------------------------------------------
------------------------------------------------------------ltcosmos table--------------------------------------------------

--cleaning strings
UPDATE [dbo].[ltcosmos]
SET ["BUSINESS NAME"] = ["BUSINESS ADDRESS-LINE1"] +',' + ["BUSINESS ADDRESS-LINE2"]

UPDATE [ltcosmos]
SET ["BUSINESS COUNTY CODE"] = ["BUSINESS COUNTY"]

UPDATE [ltcosmos]
SET ["LICENSE SUBTYPE"] = LEFT(["CONTINUING EDUCATION FLAG"],CHARINDEX(',',["CONTINUING EDUCATION FLAG"])-1)

UPDATE [ltcosmos]
SET ["CONTINUING EDUCATION FLAG"] = left(REVERSE(["CONTINUING EDUCATION FLAG"]),CHARINDEX(',',["CONTINUING EDUCATION FLAG"])-1)

update [ltcosmos]
set ["LICENSE TYPE"] = left(["LICENSE TYPE"],len(["LICENSE TYPE"])-1)

update [ltcosmos]
set ["LICENSE TYPE"] = right(["LICENSE TYPE"],len(["LICENSE TYPE"])-1)

update [ltcosmos]
set ["COUNTY"] = left(["COUNTY"],len(["COUNTY"])-1)

update [ltcosmos]
set ["COUNTY"] = right(["COUNTY"],len(["COUNTY"])-1)

update [ltcosmos]
set ["BUSINESS NAME"] = left(["BUSINESS NAME"],len(["BUSINESS NAME"])-1)

update [ltcosmos]
set ["BUSINESS NAME"] = right(["BUSINESS NAME"],len(["BUSINESS NAME"])-1)

update [ltcosmos]
set ["CONTINUING EDUCATION FLAG"] = left(["CONTINUING EDUCATION FLAG"],1)

update [ltcosmos]
set ["CONTINUING EDUCATION FLAG"] = right(["CONTINUING EDUCATION FLAG"],len(["CONTINUING EDUCATION FLAG"])-1)

update [ltcosmos]
set  ["LICENSE SUBTYPE"]= left(["LICENSE SUBTYPE"],len(["LICENSE SUBTYPE"])-1)
where ["LICENSE NUMBER"] != 1470462

update [ltcosmos]
set ["LICENSE SUBTYPE"] = right(["LICENSE SUBTYPE"],len(["LICENSE SUBTYPE"])-1)
where ["LICENSE NUMBER"] != 1470462
--fixing data types

UPDATE [dbo].[ltcosmos]
set ["BUSINESS COUNTY CODE"] = null
where ["BUSINESS COUNTY CODE"]  not like '%[1-9]%';

update [ltcosmos]
set ["BUSINESS COUNTY CODE"] = SUBSTRING(["BUSINESS COUNTY CODE"],2,4)
where ["BUSINESS COUNTY CODE"] is not null

SELECT ["CONTINUING EDUCATION FLAG"]
FROM [ltcosmos]
WHERE ["BUSINESS NAME"] = 'NGUYEN, NGA THUY'

--lower county names

update [dbo].[ltcosmos]
set ["COUNTY"] = LOWER(["COUNTY"])

---checking for null values : ["COUNTY"] 's null values has been handled by replacing their values to their nearest values
select *
from [dbo].[ltcosmos]
where len(["COUNTY"])<1

select * into #temb
from [ltcosmos]

select a.* ,   coalesce(b.le, b.la ) as final into #temb1
from #temb a
join (select * , lead(["COUNTY"]) over(order by ["LICENSE NUMBER"]) as le , LAG(["COUNTY"]) over(order by ["LICENSE NUMBER"]) as la
from #temb)b
on a.["LICENSE NUMBER"] = b.["LICENSE NUMBER"] and a.["COUNTY"] is null


update [ltcosmos] 
set [ltcosmos].["COUNTY"] = #temb1.final
from [ltcosmos]
join  #temb1
on [ltcosmos].["LICENSE NUMBER"] = #temb1.["LICENSE NUMBER"]

---checking for null values : ["CONTINUING EDUCATION FLAG"] 's null values has been handled by replacing the most repeated value
update [ltcosmos]
set ["CONTINUING EDUCATION FLAG"] = 'N'
where len(["CONTINUING EDUCATION FLAG"]) <1

select * from [ltcosmos] where len(["CONTINUING EDUCATION FLAG"]) <1
select * from [ltcosmos] where ["CONTINUING EDUCATION FLAG"] is null

--- checking for  duplicated data

select ["LICENSE NUMBER"]
from [dbo].[ltcosmos]
group by ["LICENSE NUMBER"]
having count(*)>1
/*there were duplicated values for ["BUSINESS NAME"] only , ["BUSINESS NAME"] and ["COUNTY"] both but there weren't duplicated values 
for the combination of ["BUSINESS NAME"] , ["COUNTY"] , ["LICENSE NUMBER"] and that's the required */
select ["BUSINESS NAME"] , ["COUNTY"] , ["LICENSE NUMBER"]
from [dbo].[ltcosmos]
group by ["BUSINESS NAME"] , ["COUNTY"] , ["LICENSE NUMBER"]
having count(*)>1

/*  duplicated ["LICENSE NUMBER"] have been found and the way selected to handle them is to change one of these
LICENSE NUMBERS' values with related random value */
select *
from [dbo].[ltcosmos]
where ["LICENSE NUMBER"] = 1801418

select max(["LICENSE NUMBER"])
from [ltcosmos]

update [ltcosmos]
set ["LICENSE NUMBER"] =1908515
where ["LICENSE NUMBER"] = 1801418 and ["COUNTY"] = 'harris'


--------------------------------------------------------- ---------[dbo].[economics] table---------------------------------------------------
---removing first row which contained the dublicated title
delete top(1)
from [dbo].[economics]

--converting varchar data type to float manually cause there are blank characters 
update  [dbo].[economics]
set [PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IS BELOW THE POVERTY _LEVEL!!All families] = TRIM([PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IS BELOW THE POVERTY _LEVEL!!All families])


update [dbo].[economics]
set [PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IS BELOW THE POVERTY _LEVEL!!All families] = left([PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IS BELOW THE POVERTY _LEVEL!!All families],len([PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IS BELOW THE POVERTY _LEVEL!!All families])-1)

--extracting county name from [Geographic Area _Name] column which was cobination of county and state names
update [dbo].[economics]
set [county] = left([county],CHARINDEX(' ',[county])-1)

--lower county names

update [dbo].[economics]
set [county] = LOWER([county])

---there is no column with null values 

--- checking for  duplicated data

select [county]
from [dbo].[economics]
group by [county]
having count(*)>1

select *
from [economics]
where [county] = 'jim' or  [county] = 'san'


------i found two different duplicated counties 'jim' and 'san'
select *
from [dbo].[ltcosmos]
where ["COUNTY"] = 'jim' or  ["COUNTY"] = 'san'
---when i searched table [dbo].[ltcosmos] i didn't find them there
select *
from [dbo].[population]
where [county] = 'jim' or  [county] = 'san'
---when i searched table [population] i  found them there
-- when i googled them i found that there are actually counties with these names with a little difference in title
select distinct(["COUNTY"]) 
from [dbo].[ltcosmos]
where ["COUNTY"] like '%jim%' or  ["COUNTY"] like '%san%'
/* AND when i searched [ltcosmos] table i actually found 6 counties like these duplicated counties
so this is obvious now they aren't duplicates but they have been wronglyinserted ,,,,it's time to fix this*/ 
---we need to defferentiate between them ,,, by some help of google i found population of each single one of them in 2018
update [population]
set [county] = 'jim wells'
where [county] = 'jim' and [Total population] = 41192

update [population]
set [county] = 'jim hogg'
where [county] = 'jim'

update [population]
set [county] = 'san jacinto'
where [county] = 'san' and [Total population] = 27819

update [population]
set [county] = 'san augustine'
where [county] = 'san' and [Total population] = 8327

update [population]
set [county] = 'san patricio'
where [county] = 'san' and [Total population] = 67046

update [population]
set [county] = 'san saba'
where [county] = 'san' 

/*now after we found the correct values for these duplicates in [population] table ,,it's time to correct them in the [economics] table
we will compare between values from total population column in population table and assign the county 
to the nearst value of total households in economics table */
update [dbo].[economics]
set [county] = 'jim wells'
where [county] = 'jim' and [Total households] = 13043

update [dbo].[economics]
set [county] = 'jim hogg'
where [county] = 'jim'

update [economics]
set [county] = 'san patricio'
where [county] = 'san' and [Total households] = 23121

update [economics]
set [county] = 'san jacinto'
where [county] = 'san' and [Total households] = 9487

update [economics]
set [county] = 'san augustine'
where [county] = 'san' and [Total households] = 3356

update [economics]
set [county] = 'san saba'
where [county] = 'san'
---correcting these duplicates in [educational level]
---we can sum [Population 18 to 24 years] and [Population 25 years and over] to get the total poulation per every county 
select county , [Population 18 to 24 years] + [Population 25 years and over] as total_population
from [dbo].[educational level]
where [county] = 'jim' or  [county] = 'san'

update [educational level]
set [county] = 'jim wells'
where [county] = 'jim' and  [Population 18 to 24 years] + [Population 25 years and over] = 29601

update [dbo].[educational level]
set [county] = 'jim hogg'
where [county] = 'jim'

update [educational level]
set [county] = 'san patricio'
where [county] = 'san' and  [Population 18 to 24 years] + [Population 25 years and over] = 48848

update [educational level]
set [county] = 'san jacinto'
where [county] = 'san' and  [Population 18 to 24 years] + [Population 25 years and over] = 21697

update [educational level]
set [county] = 'san augustine'
where [county] = 'san' and  [Population 18 to 24 years] + [Population 25 years and over] = 6659

update [educational level]
set [county] = 'san saba'
where [county] = 'san'
---[dbo].[educational level] table
--cleaning strings
update [dbo].[educational level]
set [Geographic Area Name] = substring([Geographic Area Name],1,CHARINDEX(' ',[Geographic Area Name])-1)

--lower county names

update [dbo].[educational level]
set [Geographic Area Name] = LOWER([Geographic Area Name])

---there is no column with null values

---[dbo].[population]table
--cleaning strings
update [dbo].[population]
set [Geographic Area Name] = substring([Geographic Area Name],1,CHARINDEX(' ',[Geographic Area Name])-1)

--lower county names

update [dbo].[population]
set [Geographic Area Name] = LOWER([Geographic Area Name])

---there is no column with null values





