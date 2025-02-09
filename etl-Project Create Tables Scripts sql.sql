--STA UsStates Table
CREATE TABLE [UsStates] (
    [StateCD] nvarchar(255),
    [Name] nvarchar(255),
    [Region] nvarchar(255)
)
--STA Employees Table
CREATE TABLE [Employees] (
    [EmployeeID] nvarchar(255),
    [EmployeeName] nvarchar(255),
    [Site] nvarchar(255),
    [ManagerName] nvarchar(255)
)
--STA CallTypes Table
CREATE TABLE [CallTypes] (
    [CallTypeID] float,
    [CallTypeLabel] nvarchar(255)
)
--STA CallData Table
CREATE TABLE [CallData] (
    [CallTimestamp] varchar(50),
    [Call Type] varchar(50),
    [EmployeeID] varchar(50),
    [CallDuration] varchar(50),
    [WaitTime] varchar(50),
    [CallAbandoned] varchar(50)
)
--STA CallCharges Table
CREATE TABLE [CallCharges] (
    [Call Type ] nvarchar(255),
    [Call Charges (2018)] nvarchar(255),
    [Call Charges (2019)] nvarchar(255),
    [Call Charges (2020)] nvarchar(255),
    [Call Charges (2021)] nvarchar(255)
)

--ODS Employees Table
CREATE TABLE [Employees] (
    [EmployeeId] varchar(10),
    [EmployeeName] varchar(100),
    [ManagerName] varchar(100),
    [City] varchar(50),
    [StateName] varchar(50),
    [Region] varchar(50)
)
--ODS CallTypes Table
CREATE TABLE [CallTypes] (
    [CallTypeID] varchar(10),
    [CallTypeLabel] varchar(50)
)
--ODS CallTypes Table
CREATE TABLE [CallCharges] (
	[CallType] varchar(50),
	[CallTypeID] varchar(10),
    [Year] varchar(10),
    [Rate] varchar(10)
)
--ODS CallTypes Table
CREATE TABLE [CallData] (
	[Time] datetime,
	[Date] date,
	[Year] varchar(20),
	[CallType] varchar(50),
	[EmployeeID] varchar(20),
    [CallDuration] int,
    [WaitTime] int,
    [CallAbandoned] varchar(10),
    [SLAStatus] varchar(50)
)
--DWH_D Employees Table
CREATE TABLE [Employees] (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeId VARCHAR(10),
    EmployeeName VARCHAR(100),
    ManagerName VARCHAR(100),
    City VARCHAR(50),
    StateName VARCHAR(50),
    Region VARCHAR(50)
)


--DWH_D CallTypes Table
CREATE TABLE [CallTypes] (
    CallTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    CallTypeID VARCHAR(10),
    CallTypeLabel VARCHAR(50)
);


--DWH_D CallCharges Table

CREATE TABLE [CallCharges] (
    CallChargeKey INT IDENTITY(1,1) PRIMARY KEY,  
    CallType VARCHAR(50),
    CallTypeID VARCHAR(10),
    Year VARCHAR(10),
    Rate VARCHAR(10)
);

--DWH_F CallData Table

CREATE TABLE [DWH CallData] (
    [Time] time(0),
	[DateKey] int,
    [CallDuration] int,
    [WaitTime] int,
    [CallAbandoned] varchar(10),
    [SLAStatus] varchar(50),
    [EmployeeKey] int,
    [CallTypeKey] int,
    [CallChargeKey] int,
)


--DWH DimDate Table

SET LANGUAGE english

--DROP TABLE DimDate
GO

CREATE TABLE dbo.DimDate (
   DateKey INT NOT NULL PRIMARY KEY,
   [Date] DATE NOT NULL,
   [Day] TINYINT NOT NULL,
   [WeekdayNumber] TINYINT NOT NULL,
   [WeekDayName] VARCHAR(10) NOT NULL,
   [WeekDayNameShort] CHAR(3) NOT NULL,
   IsWeekend BIT NOT NULL,
   [WeekOfYear] TINYINT NOT NULL,
   [MonthNumber] TINYINT NOT NULL,
   [MonthName] VARCHAR(10) NOT NULL,
   [MonthNameShort] CHAR(3) NOT NULL,
   [Quarter] VARCHAR(2) NOT NULL,
   [Year] INT NOT NULL,
   [MonthYear] VARCHAR(20) NOT NULL,
   [MonthYearYYYYMM] INT,
   [QuarterYear] VARCHAR(20) NOT NULL,
   [QuarterYearYYYYQ] INT,
   )

  
   GO


   SET NOCOUNT ON

TRUNCATE TABLE DimDate

DECLARE @CurrentDate DATE = '2000-01-01'
DECLARE @EndDate DATE = '2024-12-31'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO [dbo].[DimDate] (
      [DateKey],
      [Date],
      [Day],
      [WeekdayNumber],
      [WeekDayName],
      [WeekDayNameShort],
	  [IsWeekend],
      [WeekOfYear],
      [MonthNumber],
      [MonthName],
      [MonthNameShort],
      [Quarter],
      [Year],
      [MonthYear],
	  [MonthYearYYYYMM],
      [QuarterYear],
      [QuarterYearYYYYQ]
      )
   SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      WEEKDAY = DATEPART(dw, @CurrentDate),
     [WeekdayNumber] = DATENAME(dw, @CurrentDate),
      WeekDayNameShort = LEFT(DATENAME(dw, @CurrentDate), 3),
	  [IsWeekend] = CASE WHEN DATENAME(dw, @CurrentDate) IN ('Saturday','Sunday') THEN 1 ELSE 0 END,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [MonthNumber] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = LEFT(DATENAME(mm, @CurrentDate), 3),
      [Quarter] = 'Q' + CAST(DATEPART(q, @CurrentDate) AS VARCHAR),
      [Year] = YEAR(@CurrentDate),
	  [MonthYear] = DATENAME(mm, @CurrentDate) + ' ' + CAST(YEAR(@CurrentDate) AS VARCHAR(4)), 
	  [MonthYearYYYYMM] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + FORMAT(@CurrentDate,'MM'),
      [QuarterYear] = 'Q' + CAST(DATEPART(q, @CurrentDate) AS VARCHAR) + ' ' + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [QuarterYearYYYYQ] =  CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + CAST(DATEPART(q, @CurrentDate) AS VARCHAR)   

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

SELECT *
FROM DimDate




--ADM TechnicalRejects Table

CREATE TABLE [TechnicalRejects] (
    [RejectDate] datetime,
    [RejectStep] nvarchar(255),
    [RejectMessage] nvarchar(255),
    [RejectColumn] nvarchar(255)
)

--ADM FunctionalRejects Table

CREATE TABLE [FunctionalRejects] (
    [COUNT ALL] numeric(20,0),
    [RejectDate] datetime,
    [RejectStep] nvarchar(255),
    [RejectMessage] nvarchar(255),
    [RejectColumn] nvarchar(255)
)
