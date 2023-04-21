/*Trong bảng salesperson:
1. Lấy toàn bộ thông tin 10 nhân viên kinh doanh có doanh thu cao nhất theo năm hiện tại
2. Lấy danh sách ID các vùng kinh doanh (TerritoryID) có trong bảng
3. Lấy các thông tin BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear của những nhân viên có doanh thu trong khoảng từ 1.000.000 đến 3.000.000
4. Lấy ra danh sách những nhân viên chưa được đặt quota
5. Lấy các thông tin BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear của những nhân viên bị trống TerritoryID thì thay thế bằng 11, SalesQuota trống thì thay thế bằng 500.000
6. Tính sự chênh lệch giữa SalesYTD và SalesLastYear

Trong bảng SalesOrderHeader:
1. Lấy danh sách các đơn hàng được đặt hàng từ năm 2013 đến nay.
2. Lấy danh sách các đơn hàng được mua bởi nhóm khách hàng có mã KH(CustomerID) từ 10000 đến 19999
*/

USE AdventureWorks2019
GO

SELECT * FROM Sales.SalesPerson
--Lấy toàn bộ thông tin 10 nhân viên kinh doanh có doanh thu cao nhất theo năm hiện tại
SELECT top 10 *
FROM Sales.SalesPerson
ORDER BY SalesYTD 

--Lấy danh sách ID các vùng kinh doanh (TerritoryID) có trong bảng
SELECT TerritoryID
FROM Sales.SalesPerson

--Lấy các thông tin BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear 
--của những nhân viên có doanh thu trong khoảng từ 1.000.000 đến 3.000.000
SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear
FROM Sales.SalesPerson
WHERE SalesLastYear BETWEEN 1000000 AND 3000000

--Lấy ra danh sách những nhân viên chưa được đặt quota
SELECT *
FROM Sales.SalesPerson
WHERE SalesQuota is null

--Lấy các thông tin BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear 
--của những nhân viên bị trống TerritoryID thì thay thế bằng 11, SalesQuota trống thì thay thế bằng 500.000
SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear, 
ISNULL(TerritoryID,11) as new_TerritoryID, ISNULL(SalesQuota,500000) as new_SalesQuota
FROM Sales.SalesPerson

--Tính sự chênh lệch giữa SalesYTD và SalesLastYear
SELECT SalesYTD, SalesLastYear, ABS(SalesYTD - SalesLastYear)
FROM Sales.SalesPerson

--Trong bảng SalesOrderHeader:
-- Lấy danh sách các đơn hàng được đặt hàng từ năm 2013 đến nay.
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2013-01-01 00:00:00' AND '2023-03-16 00:00:00'

--Lấy danh sách các đơn hàng được mua bởi nhóm khách hàng có mã KH(CustomerID) từ 10000 đến 19999
SELECT *
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 10000 AND 19999

--------------------------------------------------------------------------------------------------------
/*Trong bảng SalesOrderDetail:
1.Giai thích ý nghĩa các cột trong bảng
2. Lấy ra toàn bộ thông tin các đơn hàng và:
	a. sắp xếp chúng theo thứ tự giảm dần theo LineTotal
	b. có sản phẩm được giảm, sắp xếp theo thứ tự tăng dần của UnitPriceDiscount
	c. có sản phẩm được đặt với số lượng trong khoảng 10-15 sản phẩm
	d. có sản phẩm với ProductID bắt đầu bằng số 8 (vd:800,812, 836, ...)

Trong bảng Product:
1. giải thích ý nghĩa các cột trong bảng
2. lấy thông tin: ProductID, Name, Color, StandardCost, ListPrice
và thay thế giá trị null ở cột color bằng N/A
*/
--Trong bảng SalesOrderDetail:
--1.Giai thích ý nghĩa các cột trong bảng
SELECT *
FROM Sales.SalesOrderDetail
/*
SalesOrderID: mã đơn đặt hàng của khách
SalesOrderDetailID:mã đơn hàng chi tiết của khách
CarrierTrackingNumber: mã số theo dõi nhà vận chuyển
OrderQty: số lượng sản phẩm đã đặt
ProductID: mã số sản phẩm
SpecialOfferID: mã khuyến mãi đặt biệt
UnitPrice: giá của sản phẩm
UnitPriceDiscount: giảm giá của sản phẩm
LineTotal: tổng giá tiền
rowguid: ROWGUIDCOL xác định duy nhất trong record. Được sử dụng để hỗ trợ mẫu sao chép khi gộp lại.
ModifiedDate: Ngày và thời gian hồ sơ được cập nhật lần cuối
*/

--2.Lấy ra toàn bộ thông tin các đơn hàng và:
	--a. sắp xếp chúng theo thứ tự giảm dần theo LineTotal
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY LineTotal DESC

--b. có sản phẩm được giảm, sắp xếp theo thứ tự tăng dần của UnitPriceDiscount
SELECT *
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount <> 0
ORDER BY UnitPriceDiscount ASC

--c. có sản phẩm được đặt với số lượng trong khoảng 10-15 sản phẩm
SELECT *
FROM Sales.SalesOrderDetail
WHERE OrderQty BETWEEN  10 AND 15

--d. có sản phẩm với ProductID bắt đầu bằng số 8 (vd:800,812, 836, ...)
SELECT *
FROM Sales.SalesOrderDetail
WHERE ProductID BETWEEN 800 AND 899

--Trong bảng Product:
--1. giải thích ý nghĩa các cột trong bảng
SELECT *
FROM Production.Product
/*
ProductID: mã số sản phẩm
Name: họ tên
ProductNumber: mã số sản phẩm
MakeFlag: 0 = Sản phẩm được mua, 1 = Sản phẩm được sản xuất trong nhà.
FinishedGoodsFlag: 0 = Sản phẩm không phải là mặt hàng có thể bán được. 1 = Sản phẩm có thể bán được.
Color: màu sắc
SafetyStockLevel: Số lượng hàng tồn kho tối thiểu
ReorderPoint: Mức tồn kho kích hoạt đơn đặt hàng hoặc lệnh sản xuất.
StandardCost: Chi phí tiêu chuẩn của sản phẩm
ListPrice: giá bán
Size: kích thước
SizeUnitMeasureCode: Đơn vị đo cho cột kích thước
WeightUnitMeasureCode: Đơn vị đo cho cột khối lượng
Weight: khối lượng
DaysToManufacture: Số ngày cần thiết để sản xuất sản phẩm.
ProductLine: R = Road, M = Mountain, T = Touring, S = Standard
Class: 	H = High, M = Medium, L = Low
Style: W = Womens, M = Mens, U = Universal
ProductSubcategoryID: Sản phẩm là cột của danh mục phụ sản phẩm. Khóa ngoại để ProductSubCategory.ProductSubCategoryID.
ProductModelID: Sản phẩm là một cột của mô hình sản phẩm. Khóa nước ngoại cho ProductModel.ProductModelID.
SellStartDate: Ngày sản phẩm có sẵn để bán
SellEndDate: Ngày sản phẩm không còn có sẵn để bán
DiscontinuedDate: Ngày sản phẩm đã bị ngừng
rowguid: ROWGUIDCOL xác định duy nhất trong record. Được sử dụng để hỗ trợ mẫu sao chép khi gộp lại.
ModifiedDate: Ngày và thời gian hồ sơ được cập nhật lần cuối
*/

--lấy thông tin: ProductID, Name, Color, StandardCost, ListPrice
--và thay thế giá trị null ở cột color bằng N/A
SELECT ProductID, Name, Color, StandardCost, ListPrice, ISNULL(Color, 'N/A') as new_color
FROM Production.Product
