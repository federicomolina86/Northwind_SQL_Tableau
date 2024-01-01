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



- Función 5: TOP 5 de clientes más valiosos
