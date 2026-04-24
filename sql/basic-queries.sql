-- Task 1.
IF DB_ID(N'Company') IS NOT NULL
BEGIN
    ALTER DATABASE Company SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Company;
END;
GO

CREATE DATABASE Company;
GO

-- Switch the current context to the new database.
USE Company;
GO

-- Table Department:
-- stores company departments and the employee who manages each department.
CREATE TABLE dbo.Department
(
    DepartmentID TINYINT IDENTITY(1,1) NOT NULL,
    DepName      NVARCHAR(60)          NOT NULL,
    DepManager   INT                   NULL,

    CONSTRAINT PK_Department PRIMARY KEY (DepartmentID),
    CONSTRAINT UQ_Department_DepName UNIQUE (DepName),
    CONSTRAINT CK_Department_DepName CHECK (LEN(TRIM(DepName)) > 0)
);
GO

-- Table Room:
-- stores office rooms and the number of workplaces available in each room.
CREATE TABLE dbo.Room
(
    RoomID          SMALLINT IDENTITY(1,1) NOT NULL,
    RoomNumber      SMALLINT               NOT NULL,
    BuildingAddress NVARCHAR(200)          NOT NULL,
    [Floor]         TINYINT                NOT NULL,
    NumberOfPlaces  TINYINT                NOT NULL CONSTRAINT DF_Room_NumberOfPlaces DEFAULT 4,

    CONSTRAINT PK_Room PRIMARY KEY (RoomID),
    CONSTRAINT UQ_Room_Number_Address UNIQUE (RoomNumber, BuildingAddress),
    CONSTRAINT CK_Room_All CHECK
    (
        RoomNumber > 0 AND
        LEN(TRIM(BuildingAddress)) > 0 AND
        [Floor] >= 1 AND
        NumberOfPlaces >= 0
    )
);
GO

-- Table Employee:
-- stores employees, their contact data, hire date, department, and office room.
CREATE TABLE dbo.Employee
(
    EmployeeID   INT IDENTITY(1,1) NOT NULL,
    SSN          CHAR(11)          NOT NULL,
    FullName     NVARCHAR(100)     NOT NULL,
    EMail        NVARCHAR(150)     NULL,
    HireDate     DATE              NOT NULL,
    RoomID       SMALLINT          NULL,
    DepartmentID TINYINT           NOT NULL,

    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT UQ_Employee_SSN UNIQUE (SSN),
    CONSTRAINT CK_Employee_SSN CHECK
    (
        SSN LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
    ),
    CONSTRAINT CK_Employee_FullName CHECK (LEN(TRIM(FullName)) > 0),
    CONSTRAINT CK_Employee_HireDate CHECK (HireDate >= '2015-01-01'),
    CONSTRAINT FK_Employee_Room FOREIGN KEY (RoomID)
        REFERENCES dbo.Room (RoomID),
    CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Department (DepartmentID)
);
GO

-- Table Project:
-- stores projects, customers, start dates, project managers, and project status.
CREATE TABLE dbo.Project
(
    ProjectID   INT IDENTITY(1,1) NOT NULL,
    PrjName     NVARCHAR(80)      NOT NULL,
    StartDate   DATE              NOT NULL,
    PrjManager  INT               NOT NULL,
    Customer    NVARCHAR(150)     NOT NULL,
    Status      VARCHAR(12)       NOT NULL CONSTRAINT DF_Project_Status DEFAULT 'Active',
    BudgetKUSD  INT               NULL,

    CONSTRAINT PK_Project PRIMARY KEY (ProjectID),
    CONSTRAINT UQ_Project_PrjName UNIQUE (PrjName),
    CONSTRAINT CK_Project_PrjName CHECK (LEN(TRIM(PrjName)) > 0),
    CONSTRAINT CK_Project_Customer CHECK (LEN(TRIM(Customer)) > 0),
    CONSTRAINT CK_Project_Status CHECK (Status IN ('Planned', 'Active', 'Done')),
    CONSTRAINT CK_Project_Budget CHECK (BudgetKUSD IS NULL OR BudgetKUSD > 0)
);
GO

-- Table EmployeeProjectLink:
-- links employees to projects and stores how many hours per day they work on each project.
CREATE TABLE dbo.EmployeeProjectLink
(
    EmployeeID   INT     NOT NULL,
    ProjectID    INT     NOT NULL,
    HoursPerDay  TINYINT NOT NULL,

    CONSTRAINT PK_EmployeeProjectLink PRIMARY KEY (EmployeeID, ProjectID),
    CONSTRAINT CK_EmployeeProjectLink_Hours CHECK (HoursPerDay BETWEEN 1 AND 11),
    CONSTRAINT FK_EmployeeProjectLink_Employee FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employee (EmployeeID),
    CONSTRAINT FK_EmployeeProjectLink_Project FOREIGN KEY (ProjectID)
        REFERENCES dbo.Project (ProjectID)
);
GO

-- Insert departments.
INSERT INTO dbo.Department (DepName)
VALUES (N'QA'),
       (N'.NET'),
       (N'MOBILE'),
       (N'DATA');
GO

-- Insert office rooms.
INSERT INTO dbo.Room (RoomNumber, BuildingAddress, [Floor], NumberOfPlaces)
VALUES (101, N'15 Pine Street', 1, 4),
       (102, N'15 Pine Street', 1, 3),
       (201, N'15 Pine Street', 2, 4),
       (301, N'15 Pine Street', 3, 2),
       (110, N'2200 Lake Avenue', 1, 3),
       (210, N'2200 Lake Avenue', 2, 5);
GO

-- Insert employees.
-- Some employees have no email or no assigned room on purpose.
-- This makes the homework data more realistic and supports NULL-related tasks.
INSERT INTO dbo.Employee (SSN, FullName, EMail, HireDate, RoomID, DepartmentID)
VALUES ('512-14-1001', N'Sarah Coleman',  N'sarah.coleman@company.com',  '2018-03-12', 1,    1),
       ('533-22-1045', N'Michael Torres', N'michael.torres@company.com', '2020-01-15', 2,    1),
       ('601-11-2099', N'Nina Patel',     N'nina.patel@company.com',     '2019-07-01', 3,    2),
       ('602-18-2201', N'Bred Kern',      NULL,                          '2021-09-23', 3,    2),
       ('541-36-3302', N'Olivia Chen',    N'olivia.chen@company.com',    '2020-10-18', 5,    3),
       ('451-09-3377', N'Daniel Brooks',  N'daniel.brooks@company.com',  '2022-02-14', 5,    3),
       ('710-33-4408', N'Emma Price',     N'emma.price@company.com',     '2020-10-28', NULL, 4),
       ('711-28-4412', N'Victor Stone',   NULL,                          '2020-11-03', NULL, 4),
       ('389-65-5520', N'Laura Kim',      N'laura.kim@company.com',      '2022-06-06', NULL, 1),
       ('567-07-3072', N'Jason Reed',     N'jason.reed@company.com',     '2020-05-10', 2,    2),
       ('488-24-9686', N'Helen Moore',    N'helen.moore@company.com',    '2024-01-09', 5,    3),
       ('003-40-1966', N'Omar Diaz',      N'omar.diaz@company.com',      '2018-10-22', NULL, 4);
GO

-- Fill in department managers after employees already exist.
-- We cannot reference employee IDs earlier, because those rows were not created yet.
UPDATE dbo.Department
SET DepManager = CASE DepartmentID
                    WHEN 1 THEN 1
                    WHEN 2 THEN 3
                    WHEN 3 THEN 5
                    WHEN 4 THEN 7
                 END;
GO

-- Make the manager column mandatory after every department has a manager.
ALTER TABLE dbo.Department
ALTER COLUMN DepManager INT NOT NULL;
GO

-- Add extra constraints after the data is ready.
-- A department manager must be unique, and the value must reference an existing employee.
ALTER TABLE dbo.Department
ADD CONSTRAINT UQ_Department_DepManager UNIQUE (DepManager),
    CONSTRAINT FK_Department_DepManager FOREIGN KEY (DepManager)
        REFERENCES dbo.Employee (EmployeeID);
GO

-- Insert projects.
INSERT INTO dbo.Project (PrjName, StartDate, PrjManager, Customer, Status, BudgetKUSD)
VALUES (N'Atlas Portal', '2019-06-01', 2,  N'NordWay',     'Done',    900),
       (N'Mercury Shop', '2020-11-01', 1,  N'Mercury',     'Done',    650),
       (N'Orion Tests',  '2021-02-15', 5,  N'Company',     'Active',  300),
       (N'Nova Mobile',  '2020-06-01', 3,  N'NordWay',     'Done',    780),
       (N'Insight BI',   '2022-03-10', 7,  N'BrightSoft',  'Active', 1200),
       (N'Cloud Hub',    '2023-09-01', 10, N'Mercury',     'Active',  850),
       (N'Support Desk', '2024-01-20', 1,  N'GreenRetail', 'Active',  250),
       (N'Data Lake',    '2024-06-15', 7,  N'BrightSoft',  'Active', 1500),
       (N'Mercury API',  '2025-02-01', 3,  N'Mercury',     'Planned', 500),
       (N'NordVision',   '2024-04-10', 10, N'NordWay',     'Active',  950);
GO

-- Add the foreign key for project managers after employee data is present.
ALTER TABLE dbo.Project
ADD CONSTRAINT FK_Project_PrjManager FOREIGN KEY (PrjManager)
    REFERENCES dbo.Employee (EmployeeID);
GO

-- Link employees to projects.
INSERT INTO dbo.EmployeeProjectLink (EmployeeID, ProjectID, HoursPerDay)
VALUES (1,  1, 2),
       (1,  2, 2),
       (1,  7, 1),
       (1, 10, 2),
       (2,  1, 4),
       (2,  3, 3),
       (3,  2, 4),
       (3,  4, 5),
       (3,  9, 2),
       (4,  4, 2),
       (5,  1, 4),
       (5,  3, 3),
       (6,  7, 4),
       (7,  5, 5),
       (7,  8, 2),
       (8,  3, 2),
       (9,  7, 2),
       (10, 4, 2),
       (10, 6, 3),
       (10, 9, 3),
       (11, 6, 2),
       (11, 8, 2),
       (12, 5, 3);
GO

-- Task 2.1 Employees with email and hire date range.

SELECT EmployeeID, FullName, EMail, HireDate FROM Employee
WHERE EMail IS NOT NULL
AND HireDate BETWEEN '2020-01-01' AND '2020-11-01' 
ORDER BY HireDate;
GO
-- Task 2.2 Employees hired in specific years

SELECT EmployeeID, FullName, HireDate FROM Employee
WHERE YEAR(HireDate) IN (2018,2020,2022)
ORDER BY HireDate;
GO

-- Task 2.3 Employees hired before a given date

SELECT SSN, FullName, HireDate FROM Employee
WHERE HireDate < '2020-11-01'
ORDER BY HireDate;
GO

-- Task 2.4 Employees without a workplace

SELECT EmployeeID, FullName, RoomID FROM Employee 
WHERE RoomID IS NULL
ORDER BY FullName;
GO

-- 2.5 Employees from a specific department

SELECT FullName, DepartmentID FROM Employee
WHERE DepartmentID = '2'
ORDER BY FullName;
GO

--2.6 Employees with specific name pattern

SELECT FullName FROM Employee
WHERE FullName LIKE '[A]%'
ORDER BY FullName;
GO

-- 2.7 Employees with missing email

SELECT FullName, EMail FROM Employee
WHERE EMail IS NULL
ORDER BY FullName;
GO

-- 2.8 Employees hired after a specific date

SELECT FullName, HireDate FROM Employee
WHERE HireDate > '2021-01-01'
ORDER BY HireDate DESC;
GO

-- 2.9 Employees working in specific rooms

SELECT FullName,RoomID FROM Employee
WHERE RoomID IN (1,2,3)
ORDER BY FullName;
GO

-- 2.10 Employees with combined conditions

SELECT FullName, EMail, HireDate FROM Employee
WHERE Email IS NOT NULL 
AND HireDate > '2019-01-01'
ORDER BY HireDate;
GO