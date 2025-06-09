use AdventureWorks2022;

/*--- 1. List of all customers ---*/
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID;


/*--- 2. List of all customers where company name ending in N */
SELECT c.CustomerID, s.Name AS CompanyName
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';


/*--- 3. List of all customers who live in Berlin or London ---*/
SELECT 
    p.FirstName,
    p.LastName,
    a.City
FROM Person.Person p
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');


/*--- 4. List of all customers who live in UK or USA ---*/
SELECT 
    p.FirstName,
    p.LastName,
    cr.Name AS CountryRegion
FROM Person.Person p
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');


/*--- 5. List of all products sorted by product name ---*/
SELECT *
FROM Production.Product
ORDER BY Name;


/*--- 6. List of all products where product name starts with an A ---*/
SELECT *
FROM Production.Product
WHERE Name LIKE 'A%';


/*--- 7. List of customers who ever placed an order ---*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;


/*--- 8. List of Customers who live in London and have bought chai ---*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName, a.City
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City = 'London'
  AND pr.Name = 'Chai';


/*--- 9. List of customers who never place an order ---*/
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM Sales.SalesOrderHeader
);


/*--- 10. List of customers who ordered Tofu ---*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE pr.Name = 'Tofu';


/*--- 11. Details of first order of the system ---*/
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;


/*--- 12. Find the details of most expensive order date ---*/
SELECT TOP 1 SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


/*--- 13. For each order get the OrderID and Average quantity of items in that order ---*/
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


/*--- 14. For each order get the OrderID, minimum quantity and maximum quantity for that order ---*/
SELECT SalesOrderID, MIN(OrderQty) AS MinQuantity, MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


/*--- 15. Get a list of all managers and total number of employees who report to them ---*/
SELECT 
    manager.BusinessEntityID AS ManagerID,
    p.FirstName,
    p.LastName,
    COUNT(emp.BusinessEntityID) AS TotalEmployees
FROM HumanResources.Employee emp
JOIN HumanResources.Employee manager
    ON emp.OrganizationNode.GetAncestor(1) = manager.OrganizationNode
JOIN Person.Person p
    ON manager.BusinessEntityID = p.BusinessEntityID
GROUP BY manager.BusinessEntityID, p.FirstName, p.LastName
ORDER BY TotalEmployees DESC;


/*--- 16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300 ---*/
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;


/*--- 17. List of all orders placed on or after 1996/12/31 ---*/
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';


/*--- 18. List of all orders shipped to Canada ---*/
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Canada';


/*--- 19. List of all orders where total > 200 ---*/
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;


/*--- 20. List of customers based on their country ---*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName, cr.Name AS Country
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
ORDER BY cr.Name;


/*--- 21. List of Customer ContactName and number of orders they placed ---*/
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName AS ContactName,
       COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName;


/*--- 22. List of customer contact names who have placed more than 3 orders ---*/
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName AS ContactName,
       COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;


/*--- 23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998 ---*/
SELECT DISTINCT pr.ProductID, pr.Name
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE pr.SellEndDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';


/*--- 24. List of employee FirstName, LastName, Supervisor FirstName, LastName ---*/
SELECT emp.BusinessEntityID AS EmployeeID,
       eper.FirstName AS EmpFirst, eper.LastName AS EmpLast,
       mper.FirstName AS SupFirst, mper.LastName AS SupLast
FROM HumanResources.Employee emp
LEFT JOIN HumanResources.Employee sup
  ON emp.OrganizationNode.GetAncestor(1) = sup.OrganizationNode
LEFT JOIN Person.Person eper ON emp.BusinessEntityID = eper.BusinessEntityID
LEFT JOIN Person.Person mper ON sup.BusinessEntityID = mper.BusinessEntityID;


/*--- 25. List of Employee IDs and total sales conducted by employee ---*/
SELECT SalesPersonID AS EmployeeID,
       SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;


/*--- 26. List of employees whose FirstName contains character a ---*/
SELECT p.BusinessEntityID, p.FirstName, p.LastName
FROM Person.Person p
WHERE p.FirstName LIKE '%a%';


/*--- 27. List of managers who have more than four people reporting to them ---*/
SELECT manager.BusinessEntityID AS ManagerID,
       per.FirstName, per.LastName,
       COUNT(emp.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee emp
JOIN HumanResources.Employee manager
  ON emp.OrganizationNode.GetAncestor(1) = manager.OrganizationNode
JOIN Person.Person per ON manager.BusinessEntityID = per.BusinessEntityID
GROUP BY manager.BusinessEntityID, per.FirstName, per.LastName
HAVING COUNT(emp.BusinessEntityID) > 4;


/*--- 28. List of Orders and Product Names ---*/
SELECT soh.SalesOrderID, pr.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID;


/*--- 29. List of orders placed by the best customer ---*/
SELECT TOP 1 WITH TIES soh.SalesOrderID, soh.CustomerID, soh.OrderDate
FROM Sales.SalesOrderHeader soh
GROUP BY soh.SalesOrderID, soh.CustomerID, soh.OrderDate
ORDER BY COUNT(*) OVER (PARTITION BY soh.CustomerID) DESC;


/*--- 30. List of orders placed by customers who do not have a Fax number ---*/
SELECT soh.SalesOrderID, soh.CustomerID
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON pp.BusinessEntityID = p.BusinessEntityID AND pp.PhoneNumberTypeID = (
    SELECT PhoneNumberTypeID FROM Person.PhoneNumberType WHERE Name = 'Fax'
)
WHERE pp.PhoneNumber IS NULL;


/*--- 31. List of Postal codes where the product Tofu was shipped ---*/
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE pr.Name = 'Tofu';


/*--- 32. List of product names that were shipped to France ---*/
SELECT DISTINCT pr.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';


/*--- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.' ---*/
SELECT pr.Name AS ProductName, pc.Name AS CategoryName
FROM Production.Product pr
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON pr.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';


/*--- 34. List of products that were never ordered ---*/
SELECT pr.ProductID, pr.Name
FROM Production.Product pr
LEFT JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
WHERE sod.SalesOrderDetailID IS NULL;


/*--- 35. List of products where units in stock is less than 10 ---*/
SELECT p.ProductID, p.Name, pi.Quantity AS UnitsInStock
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE pi.Quantity < 10;


/*--- 36. List of top 10 countries by sales ---*/
SELECT TOP 10 cr.Name AS Country,
       SUM(soh.TotalDue) AS CountrySales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY CountrySales DESC;


/*--- 37. Number of orders each employee has taken for customers with CustomerIDs between A and AO ---*/
SELECT soh.SalesPersonID AS EmployeeID,
       COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE p.LastName >= 'A' AND p.LastName <= 'AO'
GROUP BY soh.SalesPersonID;


/*--- 38. Order date of most expensive order ---*/
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


/*--- 39. Product name and total revenue from that product ---*/
SELECT pr.ProductID, pr.Name,
       SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
GROUP BY pr.ProductID, pr.Name
ORDER BY TotalRevenue DESC;


/*--- 40. Supplier ID and number of products offered ---*/
SELECT pv.BusinessEntityID AS SupplierID,
       COUNT(DISTINCT pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;


/*--- 41. Top ten customers based on their business ---*/
SELECT TOP 10 c.CustomerID, p.FirstName + ' ' + p.LastName AS CustomerName,
       SUM(soh.TotalDue) AS TotalPurchase
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalPurchase DESC;


/*--- 42. What is the total revenue of the company? ---*/
SELECT SUM(TotalDue) AS TotalCompanyRevenue
FROM Sales.SalesOrderHeader;