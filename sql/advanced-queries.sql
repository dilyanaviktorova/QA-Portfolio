--1.1 Customers and Departments
SELECT DISTINCT  P.Customer AS CustomerName, D.DepName AS DepartmentName 
FROM Project AS P
INNER JOIN Employee AS E 
ON P.PrjManager = E.EmployeeID
INNER JOIN Department AS D
ON E.DepartmentID = D.DepartmentID
ORDER BY CustomerName, DepartmentName;
GO

--1.2 Employees with SSN pattern
SELECT E.SSN, E.FullName, YEAR(E.HireDate) AS HireYear, D.DepName,
Manager.FullName AS DepartmentManager,
R.BuildingAddress
FROM Employee AS E
INNER JOIN Department AS D
ON E.DepartmentID = D.DepartmentID
INNER JOIN Employee AS Manager 
ON Manager.EmployeeID = D.DepManager
LEFT JOIN Room AS R
ON E.RoomID = R.RoomID
WHERE E.SSN LIKE '5%'
ORDER BY E.SSN;
GO

--1.3 Rooms without employees
SELECT R.BuildingAddress AS OfficeAddress, R.RoomNumber, R.NumberOfPlaces
FROM Room AS R
LEFT JOIN Employee AS E
ON R.RoomID = E.RoomID
WHERE E.RoomID IS NULL
ORDER BY OfficeAddress, RoomNumber;
GO

--1.4 Employees by number of projects
SELECT  E.SSN, E.FullName,COUNT(EPL.ProjectID) AS ProjectNumbers
FROM Employee AS E
LEFT JOIN EmployeeProjectLink AS EPL 
ON E.EmployeeID = EPL.EmployeeID
GROUP BY E.SSN, E.FullName
ORDER BY ProjectNumbers DESC;
GO

--1.5 Employees with high workload
SELECT E.SSN, E.FullName, SUM(EPL.HoursPerDay) AS SumOfHours
FROM Employee AS E
LEFT JOIN EmployeeProjectLink AS EPL
ON E.EmployeeID = EPL.EmployeeID
GROUP BY E.SSN, E.FullName
HAVING SUM(EPL.HoursPerDay) > 6;
GO

--1.6 Projects with a single department
SELECT P.PrjName FROM Project AS P
INNER JOIN EmployeeProjectLink AS EPL
ON P.ProjectID = EPL.ProjectID
INNER JOIN Employee AS E
ON E.EmployeeID = EPL.EmployeeID
GROUP BY P.PrjName
HAVING COUNT(DISTINCT E.DepartmentID) = 1
ORDER BY P.PrjName;
GO

--1.7 Available workplaces in rooms
SELECT R.BuildingAddress AS RoomAddress, R.RoomNumber,
R.NumberOfPlaces - COUNT(E.EmployeeID) AS AvailableWorkplace 
FROM Room AS R
LEFT JOIN Employee AS E
ON E.RoomID = R.RoomID
GROUP BY  R.BuildingAddress, R.RoomNumber, R.NumberOfPlaces
ORDER BY AvailableWorkplace,RoomAddress,R.RoomNumber;
GO

--1.8 Customers: projects and employees
SELECT P.Customer, COUNT(DISTINCT P.ProjectID) AS NumberOfProjects, COUNT(DISTINCT EPL.EmployeeID) AS EmployeeNumber
FROM Project AS P
LEFT JOIN EmployeeProjectLink AS EPL 
ON P.ProjectID = EPL.ProjectID
GROUP BY P.Customer
ORDER BY NumberOfProjects, EmployeeNumber;
GO

--1.9 Employees working on projects
SELECT E.SSN, E.FullName
FROM Employee AS E
JOIN EmployeeProjectLink AS EPL
ON E.EmployeeID = EPL.EmployeeID
GROUP BY E.SSN, E.FullName;
GO

--1.10 Employees without projects
SELECT E.SSN, E.FullName
FROM Employee AS E
LEFT JOIN EmployeeProjectLink AS EPL
ON E.EmployeeID = EPL.EmployeeID
WHERE EPL.ProjectID IS NULL;
GO