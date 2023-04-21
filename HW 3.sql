/* Với bảng SalesPerson:
1. Tìm giá trị trung bình SalesYTD, tổng SalesQuota, total SalesYTD theo TerritoryID
2. Tạo cột ComYTD = commissionPct*SalesYTD và cột spreadRev = SalesYTD - SalesLastYear
3. Select TerritoryID, average SalesQuota, total SalesYTD, total SalesLastYear, % tăng trưởng doanh thu theo TerritoryID
và sắp xếp dữ liệu theo % tăng trưởng doanh thu tăng dần.
*/
-- Tìm giá trị trung bình SalesYTD, tổng SalesQuota, total SalesYTD theo TerritoryID
SELECT avg(SalesYTD) as AvgSalesYTD, sum(SalesQuota) as TotalSalesQuota, sum(SalesYTD) as TotalSalesYTD
FROM Sales.SalesPerson
GROUP BY TerritoryID

--Tạo cột ComYTD = commissionPct*SalesYTD và cột spreadRev = SalesYTD - SalesLastYear
SELECT (CommissionPct*SalesYTD) as ComYTD, (SalesYTD - SalesLastYear) as SpreadRev
FROM Sales.SalesPerson

--Select TerritoryID, average SalesQuota, total SalesYTD, total SalesLastYear, % tăng trưởng doanh thu theo TerritoryID
--và sắp xếp dữ liệu theo % tăng trưởng doanh thu GIẢM dần.
SELECT TerritoryID, avg(SalesQuota) as AverageSalesQuota, sum(SalesYTD) as TotalSalesYTD 
, sum(SalesLastYear) as TotalSalesLastYear
,  Sum(SalesYTD - SalesLastYear)/sum(SalesLastYear) asGrown
FROM Sales.SalesPerson
WHERE TerritoryID is not NULL
GROUP BY TerritoryID
ORDER BY Sum(SalesYTD - SalesLastYear)/sum(SalesLastYear) DESC

/*Với bảng SalesOrderDetail
1. Lấy các cột SalesOrderID và tổng sản phẩm bán được đơn đó.
2. Lấy các cột productID, tổng sản phẩm, 
tổng doanh thu theo sản phẩm với những sản phẩm có số lượng bán được trên 500 sản phẩm
3. Lấy thông tin SalesOrderID và tổng số tiền giảm giá theo đơn hàng
*/
-- Lấy các cột SalesOrderID và tổng sản phẩm bán được đơn đó.
SELECT SalesOrderID, COUNT(OrderQty) as TotalProductSell
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

--Lấy các cột productID, tổng sản phẩm, tổng doanh thu theo sản phẩm 
--với những sản phẩm có số lượng bán được trên 500 sản phẩm
SELECT ProductID, COUNT(OrderQty) as TotalProductSell, SUM(LineTotal) as TotalRevenue
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(OrderQty) > 500


--Lấy thông tin SalesOrderID và tổng số tiền giảm giá theo đơn hàng
SELECT SalesOrderID, sum(OrderQty)*sum(UnitPriceDiscount) as TotalDiscount
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount <> 0
GROUP BY SalesOrderID
--------------------------------------------------------------------------------------
/* Homework
1.Lấy thông tin về mã khóa học, tên khóa học với các khóa học thuộc subcategory D4E
2. Lấy danh sách học viên từ 20-29 tuổi
3. Giáo viên Heidepriem vừa thay đổi địa chỉ sinh sống, hãy giúp bạn ấy đổi địa chỉ thành 'Quang Ninh'
4. Đếm số lớp học với subcategory = BI hoặc subcategory = DA 
5. Lấy danh sách 5 giáo viên có nhiều học sinh đăng ký học nhất
6. Lấy danh sách 3 thành phố có ít học viên theo học nhất
7. Lấy mã khóa học, tên khóa học và số học viên đăng ký khóa đó
8. Lấy thông tin về học viên và số khóa học họ đăng ký
9. enrollmentID, studentID, teacherID, courseID, teacherName và thay thế giáo viên 'Mohan’ bởi giáo viên 'Lugo'
*/

--Lấy thông tin về mã khóa học, tên khóa học với các khóa học thuộc subcategory D4E
SELECT courseID, courseName
FROM Course
WHERE subcategory = 'D4E'

-- Lấy danh sách học viên từ 20-29 tuổi
SELECT *
FROM Student
WHERE  YEAR(GETDATE()) - YEAR(DoB) BETWEEN 20 AND 29

--Giáo viên Heidepriem vừa thay đổi địa chỉ sinh sống, hãy giúp bạn ấy đổi địa chỉ thành 'Quang Ninh'
UPDATE Teacher
SET taddress = 'Quang Ninh'
WHERE teacherName = 'Heidepriem'

--Đếm số lớp học với subcategory = BI hoặc subcategory = DA 
SELECT subcategory, COUNT(subcategory)
FROM Course
WHERE subcategory IN ('BI', 'DA')
GROUP BY subcategory

--Lấy danh sách 5 giáo viên có nhiều học sinh đăng ký học nhất
SELECT TOP 5 t.teacherID, COUNT(courseID) as TotalEnrollment
FROM Teacher t
INNER JOIN enrollment e
ON t.teacherID = e.teacherID
GROUP BY t.teacherID

--Lấy danh sách 3 thành phố có ít học viên theo học nhất
SELECT top 3 saddress, COUNT(studentID) as NumberOfStudents
FROM Student
GROUP BY saddress
ORDER BY NumberOfStudents 

--Lấy mã khóa học, tên khóa học và số học viên đăng ký khóa đó
SELECT e.courseID, c.courseName, COUNT(e.studentID) AS NumberOfStudents
FROM Course c
JOIN enrollment e
ON c.courseID = e.courseID
GROUP BY e.courseID, c.courseName

--Lấy thông tin về học viên và số khóa học họ đăng ký
SELECT s.studentID, COUNT(e.courseID) AS NumberOfCourses
FROM Student s
JOIN enrollment e
ON s.studentID = e.studentID
GROUP BY s.studentID

--enrollmentID, studentID, teacherID, courseID, teacherName và thay thế giáo viên 'Mohan’ bởi giáo viên 'Lugo'
SELECT e.enrollmentID, e.studentID, e.teacherID, e.courseID, t.teacherName,
(
CASE	
	WHEN t.teacherName = 'Mohan' THEN 'Lugo'
	ELSE t.teacherName
END 
) AS new_teacherName
FROM enrollment e
JOIN Teacher t
ON e.teacherID = t.teacherID


