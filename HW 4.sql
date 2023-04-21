/*
Trong database AdventureWorks2019:
Với các bảng, view: SalesOrderHeader, vEmployee
(Các cột mặc định cần có: Id, Firstname, lastname)
Lấy thông tin nhân viên và các đơn hàng họ từng bán.
Tìm 3 nhân viên bán được nhiều đơn hàng nhất.
Tìm 3 nhân viên có doanh số cao nhất(với cột doanh thu lấy 1 số sau dấu thập phân).

Thông tin nhân viên và doanh số của họ trong năm 2011
Tìm ra đơn hàng có khoảng cách từ ngày đặt hàng (OrderDate) và ngày khách nhận hàng (DueDate) lớn nhất
Tìm ra đơn hàng có khoảng cách từ ngày đặt hàng (OrderDate) và ngày khách nhận hàng (DueDate) nhỏ nhất
*/

--Với các bảng, view: SalesOrderHeader, vEmployee
--(Các cột mặc định cần có: Id, Firstname, lastname)
--Lấy thông tin nhân viên và các đơn hàng họ từng bán.

SELECT s.SalesPersonID, COUNT(s.SalesOrderID) as NumberOfOrders
FROM Sales.SalesOrderHeader s
JOIN HumanResources.vEmployee e
ON s.SalesPersonID = e.BusinessEntityID
GROUP BY s.SalesPersonID
ORDER BY NumberOfOrders Desc



--Tìm 3 nhân viên bán được nhiều đơn hàng nhất.
SELECT TOP 3 s.SalesPersonID, COUNT(s.SalesOrderID) as NumberOfOrders
FROM Sales.SalesOrderHeader s
JOIN HumanResources.vEmployee e
ON s.SalesPersonID = e.BusinessEntityID
GROUP BY s.SalesPersonID
ORDER BY NumberOfOrders Desc

--Tìm 3 nhân viên có doanh số cao nhất(với cột doanh thu lấy 1 số sau dấu thập phân).
SELECT TOP 3 s.SalesPersonID, e.FirstName, e.LastName, ROUND(SUM(s.TotalDue),1) as TotalRevenue
FROM Sales.SalesOrderHeader s
JOIN HumanResources.vEmployee e
ON s.SalesPersonID = e.BusinessEntityID
GROUP BY s.SalesPersonID, e.FirstName, e.LastName
ORDER BY TotalRevenue Desc

select TotalDue
from Sales.SalesOrderHeader

--Thông tin nhân viên và doanh số của họ trong năm 2011
SELECT s.SalesPersonID, e.FirstName, e.LastName, ROUND(SUM(s.SubTotal),1) as TotalOfRevenue2011
FROM Sales.SalesOrderHeader s
JOIN HumanResources.vEmployee e
ON s.SalesPersonID = e.BusinessEntityID
WHERE YEAR(OrderDate) = 2011
GROUP BY s.SalesPersonID, e.FirstName, e.LastName
ORDER BY TotalOfRevenue2011 Desc


select *
from Sales.SalesOrderHeader
--Tìm ra đơn hàng có khoảng cách từ ngày đặt hàng (OrderDate) và ngày khách nhận hàng (DueDate) lớn nhất
SELECT TOP 1 SalesOrderID, OrderDate, DueDate, DATEDIFF(day,OrderDate, DueDate)
FROM Sales.SalesOrderHeader
ORDER BY DATEDIFF(day,OrderDate, DueDate) desc


--Tìm ra đơn hàng có khoảng cách từ ngày đặt hàng (OrderDate) và ngày khách nhận hàng (DueDate) nhỏ nhất
SELECT TOP 1 SalesOrderID, DATEDIFF(day,OrderDate, DueDate)
FROM Sales.SalesOrderHeader
ORDER BY DATEDIFF(day,OrderDate, DueDate) 

----------------------------------------------------------------------------------------------------------
/*Từ các bảng SalesOrderDetail, Product, ProductSubcategory lấy ra các thông tin sau:

1. SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal từ bảng SalesOrderDetail  và StandardCost, ProductSubCategoryID từ bảng Product.
2. Tính tổng doanh thu theo các ProductSubCategoryID.
3. Từ những thông tin ở câu 1, lấy thêm cột ProductCategoryID từ bảng ProductSubcategory.
4. Tính tổng doanh thu, số lượng đơn hàng theo ProductSubcategory, sắp xếp theo thứ tự giảm dần theo doanh thu.

Với các bảng, view: SalesOrderHeader, vEmployee
(Các cột mặc định cần có: Id, Firstname, lastname)
5. Lấy thông tin về khách hàng và khoảng cách giữa ngày mua hàng gần nhất với hiện tại(giả sử hiện tại là max date của bảng dữ liệu).
*/

SELECT s.SalesOrderID, s.ProductID, s.OrderQty, s.UnitPrice, s.UnitPriceDiscount, s.LineTotal, p.StandardCost, p.ProductSubCategoryID
FROM Sales.SalesOrderDetail s
JOIN Production.Product p
ON s.ProductID = p.ProductID

--Tính tổng doanh thu theo các ProductSubCategoryID.
SELECT ps.ProductSubCategoryID, SUM(s.LineTotal) as TotalRevenue
FROM Production.Product p
JOIN Production.ProductSubcategory ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Sales.SalesOrderDetail s
ON p.ProductID = s.ProductID
GROUP BY ps.ProductSubcategoryID

--Từ những thông tin ở câu 1, lấy thêm cột ProductCategoryID từ bảng ProductSubcategory.
SELECT s.SalesOrderID, s.ProductID, s.OrderQty, s.UnitPrice, s.UnitPriceDiscount, s.LineTotal, 
p.StandardCost, p.ProductSubCategoryID, ps.ProductCategoryID
FROM Sales.SalesOrderDetail s
JOIN Production.Product p
ON s.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID

--Tính tổng doanh thu, số lượng đơn hàng theo ProductSubcategory, sắp xếp theo thứ tự giảm dần theo doanh thu.
SELECT ps.ProductSubCategoryID, SUM(s.LineTotal) as TotalRevenue, COUNT(s.OrderQty) as OrderQuantity
FROM Production.Product p
JOIN Production.ProductSubcategory ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Sales.SalesOrderDetail s
ON p.ProductID = s.ProductID
GROUP BY ps.ProductSubcategoryID
ORDER BY TotalRevenue DESC

--Với các bảng, view: SalesOrderHeader, vEmployee
--(Các cột mặc định cần có: Id, Firstname, lastname)
--5. Lấy thông tin về khách hàng và khoảng cách giữa ngày mua hàng gần nhất với hiện tại(giả sử hiện tại là max date của bảng dữ liệu).
SELECT TOP 1 CustomerID, DATEDIFF(day, '20140714', GETDATE())
FROM Sales.SalesOrderHeader 
ORDER BY DATEDIFF(day, '20140714', GETDATE()) DESC



