create table [portifolio project].[dbo].[economic_data]
(      [id] varchar(100)
      ,[Geographic Area _Name] varchar(100)
      ,[Estimate!!INCOME AND BENEFITS (_IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households] varchar(100)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$10,000 to $14,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$15,000 to $24,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$25,000 to $34,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$35,000 to $49,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$50,000 to $74,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$75,000 to $99,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$100,000 to $149,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$150,000 to $199,999] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$200,000 or more] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!Mean household income (dollars)] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!_With earnings] varchar(200)
      ,[Margin _of Error!!INCOME AND BENEFITS!!Total households!!_With earnings!!Mean earnings (dollars)] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Families] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS !!Families!!Mean family income (dollars)] varchar(200)
      ,[Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Per capita income (dollars)] varchar(200)
      ,[Percent Estimate!!PERCENTAGE_OF FAMILIES AND PEOPLE WHOSE INCOME IN THE PAST 12 MONTHS IS BELOW THE POVERTY _LEVEL!!All families] varchar(200)
	  )
DROP TABLE [economic_data]
BULK INSERT [economic_data]
FROM 'H:\bi-iti\portifolio project\economic data.csv'
WITH (FORMAT = 'CSV'
      , FIELDTERMINATOR = ','
      , ROWTERMINATOR = '0x0a');


