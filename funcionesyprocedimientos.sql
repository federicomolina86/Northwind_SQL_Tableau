-- En este archivo se incluyen las 14 consultas realizadas, 7 como funciones y 7 como procedimientos almacenados.
-- Las funciones permiten ejecutar cada consulta como una función independiente y llamarlas según sea necesario.

- Función 1: Top 7 de productos comprados
CREATE FUNCTION dbo.TopProductsSold()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 7 p.ProductName AS Producto, SUM(od.Quantity) AS [Unidades Vendidas]
    FROM [Order Details] AS od
    INNER JOIN [Products] AS p ON od.ProductID = p.ProductID
    GROUP BY p.ProductName
    ORDER BY [Unidades Vendidas] DESC
)

- Función 2: Producto con segundo precio más alto
CREATE FUNCTION dbo.SecondHighestPriceProduct()
RETURNS TABLE
AS
RETURN
(
    SELECT p.ProductName AS Producto, od.UnitPrice AS Precio
    FROM Products AS p
    INNER JOIN [Order Details] AS od ON p.ProductID = od.ProductID
    GROUP BY p.ProductName, od.UnitPrice
    ORDER BY Precio DESC
    OFFSET 2 ROWS
    FETCH NEXT 1 ROWS ONLY
)

- Función 3: RANK de productos vendidos en USA por ciudad
CREATE FUNCTION dbo.ProductsSoldRankByCityInUSA()
RETURNS TABLE
AS
RETURN
(
    SELECT p.ProductName AS [Nombre de Producto], c.city AS Ciudad, od.quantity AS Cantidad,
    DENSE_RANK () OVER (PARTITION BY c.City ORDER BY od.Quantity DESC) AS Rank
    FROM [products] AS p
    INNER JOIN [order details] AS od ON p.productID = od.productID
    INNER JOIN [orders] AS o ON od.orderID = o.orderID
    INNER JOIN [customers] AS c ON o.CustomerID = c.CustomerID 
    WHERE country = 'USA'
)

- Función 4: Órdenes que tardaron más de 2 días en entregarse y valor mayor a 10,000
CREATE FUNCTION dbo.OrdersDelayedAndHighValue()
RETURNS TABLE
AS
RETURN
(
    SELECT o.OrderDate AS [Fecha de la orden], o.CustomerID AS [ID de cliente], o.ShipCountry AS [País de envío],
    DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS [Numero de días],
    SUM(od.Quantity*od.UnitPrice) AS [Total de orden]
    FROM Orders AS o
    INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
    WHERE DATEDIFF(DAY, o.OrderDate, o.ShippedDate) > 2
    GROUP BY o.OrderDate, o.ShippedDate, o.CustomerID, o.ShipCountry
    HAVING SUM(od.Quantity*od.UnitPrice) > 10000
)

- Función 5: TOP 5 de clientes más valiosos
CREATE FUNCTION dbo.TopValuableCustomers()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 5 c.CompanyName AS [Nombre de la Compañía], SUM(od.Quantity*od.UnitPrice) AS [Venta Total]
    FROM Customers AS c
    INNER JOIN orders o ON o.customerID =  c.CustomerID
    INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
    GROUP BY c.CompanyName
    ORDER BY [Venta Total] DESC
)

- Función 6: Productos con monto total de venta mayor o igual a $30,000 y unidades vendidas en 2018
CREATE FUNCTION dbo.HighValueProducts2018()
RETURNS TABLE
AS
RETURN
(
    SELECT p.ProductName AS [Nombre de Producto], SUM(od.quantity) AS Cantidad,
    SUM(od.Quantity*od.UnitPrice) AS [Venta por Producto]
    FROM products p
    INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
    INNER JOIN orders o ON od.orderID = o.orderID
    WHERE YEAR(o.OrderDate) = '2018'
    GROUP BY p.ProductName
    HAVING SUM(od.Quantity*od.UnitPrice) >= 30000
)

- Función 7: Clasificación de clientes según el total de ventas
CREATE FUNCTION dbo.ClassifyCustomersBySales()
RETURNS TABLE
AS
RETURN
(
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
)

-- Los procedimientos almacenados son conjuntos de instrucciones SQL que se almacenan en la base de datos y se pueden ejecutar con un nombre específico. 
-- Son como scripts o funciones predefinidas que realizan una serie de operaciones o consultas en la base de datos.

- Procedimiento 1: Clientes con ventas por encima del promedio en 2018
CREATE PROCEDURE SP_ClientesVentasPorEncimaPromedio
AS
BEGIN
    SELECT c.CompanyName AS [Nombre de la Compañía], SUM(od.Quantity*od.UnitPrice) AS Venta
    FROM customers AS c
    INNER JOIN [Orders] AS o ON c.customerID = o.CustomerID
    INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = '2018'
    GROUP BY c.CompanyName
    HAVING SUM(od.Quantity*od.UnitPrice) > (SELECT AVG(Quantity*UnitPrice) FROM [Order Details])
    ORDER BY Venta DESC
END

-- Procedimiento 2: Clientes que no han comprado en los últimos 80 meses
CREATE PROCEDURE SP_ClientesSinComprasUltimos80Meses
AS
BEGIN
    SELECT c.CompanyName AS [Nombre de la Compañía], MAX(o.orderDate) AS [Última compra],
    DATEDIFF(month, MAX(o.OrderDate), GETDATE()) AS [Meses sin comprar]
    FROM customers AS c
    INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CompanyName
    HAVING DATEDIFF(month, MAX(o.OrderDate), GETDATE()) > 80
    ORDER BY o.OrderDate DESC
END

-- Procedimiento 3: Número de órdenes por clientes
CREATE PROCEDURE SP_NumeroOrdenesPorCliente
AS
BEGIN
    SELECT c.CompanyName AS [Nombre de la Compañía],
    (SELECT COUNT(o.orderID) FROM Orders AS o WHERE c.CustomerID = o.CustomerID) AS [Órdenes]
    FROM Customers AS c
    ORDER BY [Órdenes] DESC
END

-- Procedimiento 4: Empleados con más ventas y bonos
CREATE PROCEDURE SP_EmpleadosMasVentas
AS
BEGIN
    SELECT TOP 5 e.FirstName + ' ' + e.LastName AS [Nombre Completo],
    SUM(od.Quantity*od.UnitPrice) AS Venta,
    SUM((od.Quantity*od.UnitPrice)*0.02) AS Bonus,
    SUM(od.Quantity * od.UnitPrice) + SUM((od.Quantity * od.UnitPrice) * 0.02) AS Total
    FROM Employees AS e
    INNER JOIN Orders AS o ON o.EmployeeID = e.EmployeeID
    INNER JOIN [Order Details] AS od ON od.OrderID = o.OrderID
    GROUP BY e.FirstName + ' ' + e.LastName
    ORDER BY [Venta] DESC
END

-- Procedimiento 5: Cantidad de empleados por posición y ciudad
CREATE PROCEDURE SP_CantidadEmpleadosPorPosicionCiudad
AS
BEGIN
    SELECT title AS Puesto, city AS Ciudad, COUNT(employeeID) AS Empleados
    FROM employees
    GROUP BY title, city
END

-- Procedimiento 5: Cantidad de empleados por posición y ciudad

CREATE PROCEDURE SP_CantidadEmpleadosPorPosicionCiudad
AS
BEGIN
    SELECT title AS Puesto, city AS Ciudad, COUNT(employeeID) AS Empleados
    FROM employees
    GROUP BY title, city
END

-- Procedimiento 6: Tiempo de trabajo de empleados
CREATE PROCEDURE SP_TiempoTrabajoEmpleados
AS
BEGIN
    SELECT FirstName + ' ' + LastName AS [Nombre Completo],
    DATEDIFF(YEAR, HireDate, GETDATE()) AS [Años trabajando]
    FROM Employees
END

-- Procedimiento 7: Empleados mayores de 70 años
CREATE PROCEDURE SP_EmpleadosMayores70Anios
AS
BEGIN
    SELECT FirstName + ' ' + LastName AS [Nombre Completo],
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS [Edad]
    FROM employees
    WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 70
    ORDER BY Edad DESC
END
