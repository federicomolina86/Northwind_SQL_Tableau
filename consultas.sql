USE Northwind
GO
--Análisis de productos
--Top 7 de productos comprados por nombre, orden descendente por unidades vendidas
SELECT TOP 7 p.ProductName AS Producto, sum(od.Quantity) AS [Unidades Vendidas]
FROM [Order Details] AS od
INNER JOIN [Products] AS p
ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY [Unidades Vendidas] DESC
GO


--Producto que tiene el segundo precio más alto en la compañía
SELECT p.ProductName AS Producto, od.UnitPrice AS Precio
FROM Products AS p
INNER JOIN [Order Details] AS od 
ON p.ProductID = od.ProductID
GROUP BY p.ProductName, od.UnitPrice
ORDER BY Precio DESC
OFFSET 2 ROWS
FETCH NEXT 1 ROWS ONLY;
GO


--Crear un RANK de productos vendidos ordenado por ciudad y cantidad en USA
SELECT p.ProductName as [Nombre de Producto], c.city as Ciudad, od.quantity as Cantidad,
DENSE_RANK () OVER (PARTITION BY c.City ORDER BY od.Quantity DESC) as Rank
FROM [products] as p
INNER JOIN [order details] as od ON p.productID = od.productID
INNER JOIN [orders] as o ON od.orderID = o.orderID
INNER JOIN [customers] as c ON o.CustomerID = c.CustomerID 
WHERE country = 'USA';
GO


--Encontrar las ordenes que tardaron mas de 2 dias en entregarse despues de ser realizadas por el usuario, donde el valor sea mayor de 10,000
--Mostrar numero de dias, fecha de la orden, customer ID y pais de envío

SELECT o.OrderDate as [Fecha de la orden], o.CustomerID as [ID de cliente], o.ShipCountry AS [País de envío],
DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS [Numero de días],
SUM(od.Quantity*od.UnitPrice) AS [Total de orden]
FROM Orders as o
INNER JOIN [Order Details] as od ON o.OrderID = od.OrderID
WHERE DATEDIFF(DAY, o.OrderDate, o.ShippedDate) > 2
GROUP BY o.OrderDate, o.ShippedDate, o.CustomerID, o.ShipCountry
HAVING SUM(od.Quantity*od.UnitPrice) > 10000
ORDER BY [Numero de días] DESC;
GO


--Encontrar el TOP 5 de clientes más valiosos para darles un presente
SELECT TOP 5 c.CompanyName AS [Nombre de la Compañía],
SUM(od.Quantity*od.UnitPrice) AS [Venta Total]
FROM Customers AS c
INNER JOIN orders o ON o.customerID =  c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CompanyName
ORDER BY [Venta Total] DESC;
GO


--Muestra los productos que generaron un monto total de venta mayor o igual $30,000 y muestra las unidades vendidas de cada producto en 2018
SELECT p.ProductName AS [Nombre de Producto],
SUM(od.quantity) AS Cantidad,
SUM(od.Quantity*od.UnitPrice) AS [Venta por Producto]
FROM products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN orders o ON od.orderID = o.orderID
WHERE YEAR(o.OrderDate) = '2018'
GROUP BY p.ProductName
HAVING SUM(od.Quantity*od.UnitPrice) >= 30000
GO


--Clasifica a los clientes de acuerdo al total de ventas
-- >= 30000 Nivel A
-- >= 20000 y < 30000 Nivel B
-- <  20000 Nivel C
SELECT c.CompanyName AS [Nombre de la Compañía], SUM(od.Quantity*od.UnitPrice) AS Venta,
CASE
	WHEN SUM(od.Quantity*od.UnitPrice) >= 30000 THEN 'A'
	WHEN SUM(od.Quantity*od.UnitPrice) < 30000 AND SUM(od.Quantity*od.UnitPrice) >= 20000 THEN 'B'
	ELSE 'C'
	END AS Nivel
FROM customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
ORDER BY Venta DESC
GO


--¿Qué clientes generaron ventas por arriba del promedio del total de ventas? Filtrar por año 2018
SELECT c.CompanyName AS [Nombre de la Compañía],
SUM(od.Quantity*od.UnitPrice) AS Venta
FROM customers AS c
INNER JOIN [Orders] AS o ON c.customerID = o.CustomerID
INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
WHERE year(o.OrderDate) = '2018'
GROUP BY c.CompanyName
HAVING SUM(od.Quantity*od.UnitPrice) > (SELECT AVG(Quantity*UnitPrice) FROM [Order Details])
ORDER BY Venta DESC
GO


--¿Qué clientes no han comprado en los ultimos 80 meses? (La Base de Datos es de 2016-2018)
SELECT c.CompanyName AS [Nombre de la Compañía], MAX(o.orderDate) AS [Última compra],
DATEDIFF(month, MAX(o.OrderDate), GETDATE()) AS [Meses sin comprar]
FROM customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName, o.OrderDate
HAVING DATEDIFF(month, MAX(o.OrderDate), GETDATE()) > 80
ORDER BY o.OrderDate DESC
GO


--Número de ordenes por clientes
SELECT c.CompanyName AS [Nombre de la Compañía],
(SELECT COUNT(o.orderID) FROM Orders AS o
WHERE c.CustomerID = o.CustomerID) AS [Órdenes]
FROM Customers AS c
ORDER BY [Órdenes] DESC
GO


--Empleados con más ventas (Bonos por sus ventas del 2% a los 5 primeros)
SELECT TOP 5 e.FirstName + ' ' + e.LastName AS [Nombre Completo],
SUM(od.Quantity*od.UnitPrice) AS Venta,
SUM((od.Quantity*od.UnitPrice)*0.02) AS Bonus,
SUM(od.Quantity * od.UnitPrice) + SUM((od.Quantity * od.UnitPrice) * 0.02) AS Total
FROM Employees AS e
INNER JOIN Orders AS o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] AS od ON od.OrderID = o.OrderID
GROUP BY e.FirstName + ' ' + e.LastName
ORDER BY [Venta] DESC
GO


--¿Cuantos empleados tienes por posicion y por ciudad?
SELECT title AS Puesto, city AS Ciudad, COUNT(employeeID) AS Empleados
FROM employees
GROUP BY title, city
GO


--¿Cuánto tiempo llevan trabajando tus empleados?
SELECT FirstName + ' ' + LastName AS [Nombre Completo],
DATEDIFF(YEAR, HireDate, GETDATE()) AS [Años trabajando]
FROM Employees
GO


--¿Cuántos empleados son mayores de 70 años?
SELECT FirstName + ' ' + LastName AS [Nombre Completo],
DATEDIFF(YEAR, BirthDate, GETDATE()) AS [Edad]
FROM employees
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 70
ORDER BY Edad DESC
