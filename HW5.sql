--HW5
/*
Với Database mindX:
StudentID, StudentName, email, phoneNumber và số giáo viên họ từng học
StudentID, StudentName, số khóa học họ từng học, số subcategory họ từng học và số giáo viên họ từng học.
teacherID, teacherName, số khóa học họ từng dạy, số subcategory họ từng dạy và số học viên họ từng dạy
*/
USE mindX
GO

SELECT s.studentID, s.studentName, s.email, s.phoneNumber, a.SoGV
FROM Student s
JOIN
	(SELECT studentID, COUNT(teacherID) AS SoGV
	FROM enrollment
	GROUP BY studentID) as a
ON s.studentID = a.studentID

--StudentID, StudentName, số khóa học họ từng học, số subcategory họ từng học và số giáo viên họ từng học.

SELECT s.studentID, studentName, a.CoursesQty, a.SubcategoryQty, a.teacherQty
FROM Student s
JOIN
	(SELECT e.studentID, COUNT(DISTINCT(e.courseID)) as CoursesQty, COUNT(DISTINCT(c.Subcategory)) as SubcategoryQty,
		COUNT(DISTINCT(e.teacherID)) as teacherQty
	FROM enrollment e
	JOIN Course c
	ON e.courseID = c.courseID
	GROUP BY e.studentID) AS a
ON s.studentID = a.studentID

--teacherID, teacherName, số khóa học họ từng dạy, số subcategory họ từng dạy và số học viên họ từng dạy
SELECT t.teacherID, t.teacherName, a.CoursesQty, a.SubcategoryQty, a.studentQty
FROM Teacher t
JOIN 
	(SELECT e.teacherID, COUNT(DISTINCT(e.courseID)) as CoursesQty, COUNT(DISTINCT(c.Subcategory)) as SubcategoryQty,
		COUNT(DISTINCT(e.studentID)) as studentQty
	FROM enrollment e
	JOIN Course c
	ON e.courseID = c.courseID
	GROUP BY e.teacherID) as a
ON t.teacherID = a.teacherID


USE AdventureWorks2019
GO

/*Với database AdventureWorks 2019(SalesOrderHeader):
1. Lấy thông tin khách hàng và khoảng cách giữa ngày gần nhất mua hàng với hiện tại(là ngày max(OrderDate).
2. Lấy thông tin khách hàng và tổng số lần mua hàng của khác hàng.
3. Lấy thông tin khách hàng và tổng số tiền khách hàng đã giao dịch.
4. Lấy thông tin khách hàng và khoảng cách giữa ngày mua gần nhất và hiện tại, tổng số lần mua hàng, tổng số tiền đã giao dịch của khách hàng
*/

--1. 
WITH CTE_Customer as
(
SELECT s.CustomerID, MAX(s.OrderDate) as MaxOrderDate
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c
ON s.CustomerID = c.CustomerID
GROUP BY s.CustomerID
)

SELECT cte.CustomerID, b.LastName, DATEDIFF(day, MaxOrderDate, GETDATE())
FROM CTE_Customer cte
JOIN Person.Person b
ON cte.CustomerID = b.BusinessEntityID

--2. Lấy thông tin khách hàng và tổng số lần mua hàng của khách hàng.
SELECT a.CustomerID, p.LastName, TotalOrder
FROM Person.Person p
JOIN
	(SELECT s.CustomerID, COUNT(SalesOrderID) as TotalOrder
	FROM Sales.SalesOrderHeader s
	JOIN Sales.Customer c
	ON s.CustomerID = c.CustomerID
	GROUP BY s.CustomerID) AS a
ON a.CustomerID = p.BusinessEntityID

--3. Lấy thông tin khách hàng và tổng số tiền khách hàng đã giao dịch.
SELECT a.CustomerID, p.LastName, TotalMoney
FROM Person.Person p
JOIN
	(SELECT s.CustomerID, SUM(TotalDue) as TotalMoney
	FROM Sales.SalesOrderHeader s
	JOIN Sales.Customer c
	ON s.CustomerID = c.CustomerID
	GROUP BY s.CustomerID) AS a
ON a.CustomerID = p.BusinessEntityID

--4. Lấy thông tin khách hàng và khoảng cách giữa ngày mua gần nhất và hiện tại, tổng số lần mua hàng, tổng số tiền đã giao dịch của khách hàng
SELECT a.CustomerID, p.LastName, DATEDIFF(day, MaxOrderDate, GETDATE()) as Dategap, TotalMoney, TotalOrder
FROM Person.Person p
JOIN
	(SELECT s.CustomerID, MAX(s.OrderDate) as MaxOrderDate, COUNT(SalesOrderID) as TotalOrder, SUM(TotalDue) as TotalMoney
	FROM Sales.SalesOrderHeader s
	JOIN Sales.Customer c
	ON s.CustomerID = c.CustomerID
	GROUP BY s.CustomerID) AS a
ON a.CustomerID = p.BusinessEntityID
ORDER BY a.CustomerID, p.LastName

-----------------------------------------------------------------------------------------------------
/*
Với database AdventureWorks 2019 viết câu truy vấn để lấy những thông tin sau:
SalesPersonID, số lượng khách hàng bán được, số đơn hàng bán được, số sản phẩm bán được, tổng doanh số.
SalesPersonID, subcategory, số đơn hàng bán được theo subcategory, doanh số theo subcategory, lợi nhuận theo subcategory
*/

USE AdventureWorks2019
GO


SELECT 
    soh.SalesPersonID,
    COUNT(DISTINCT c.CustomerID) AS NumberOfCustomers,
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfOrders,
    SUM(sod.OrderQty) AS NumberOfProductsSold,
    SUM(soh.TotalDue) AS TotalSalesAmount
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY soh.SalesPersonID

----------------------------------------
SELECT 
    sp.BusinessEntityID AS SalesPersonID,
    psc.Name AS Subcategory,
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfOrders,
    SUM(sod.OrderQty * sod.UnitPrice) AS TotalSalesAmount,
    SUM(sod.OrderQty * (sod.UnitPrice - sod.UnitPriceDiscount - p.StandardCost)) AS Profit
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY sp.BusinessEntityID, psc.Name


SELECT CustomerID, MAX(OrderDate), datediff(day, MAX(OrderDate), GETDATE()) INTO #CustomerMaxDistance
FROM Sales.SalesOrderHeader
GROUP BY CustomerID 
	 

SELECT * FROM #CustomerMaxDistance

Fix
SELECT CustomerID, MAX(OrderDate) X, datediff(day, MAX(OrderDate), GETDATE()) Y
INTO #CustomerMaxDistance
FROM Sales.SalesOrderHeader
GROUP BY CustomerID