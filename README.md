# Proyecto Análisis de la Base de Datos Northwind 

![](https://github.com/federicomolina86/Northwind_SQL_Tableau/blob/main/src/MSQLS.png) ![](https://github.com/federicomolina86/Northwind_SQL_Tableau/blob/main/src/Tableau.jpg)

Este proyecto utiliza la base de datos Northwind para realizar análisis de datos utilizando `Microsoft SQL Server` y crea visualizaciones interactivas con `Tableau`.

## Descripción del Proyecto
La base de datos `Northwind` es una muestra clásica de base de datos relacional que contiene información sobre productos, clientes, proveedores y órdenes. Este proyecto se centra en explorar y analizar datos clave dentro de la base de datos utilizando consultas SQL y representando los resultados a través de visualizaciones claras y comprensibles utilizando Tableau. Para poder usar la base de datos Northwind, debe ejecutar el archivo `instnwnd.sql` para volver a crear la base de datos en una instancia de SQL Server.

## Consultas Destacadas
El proyecto incluye una serie de consultas SQL que proporcionan información valiosa sobre el rendimiento del negocio, los productos más vendidos, clientes destacados, entre otros. Algunas de las consultas destacadas son:
- Análisis de los productos.
- Análisis de compras.
- Análisis de clientes.
- Análisis de empleados.

Puedes encontrar las consultas SQL utilizadas en el archivo `consultas.sql` y otro archivo llamado `funcionesyprocedimientos.sql` que incluye funciones y preocedimientos (para usuarios más avanzados).

## Visualizaciones con Tableau
Se han creado visualizaciones interactivas utilizando Tableau para representar de manera intuitiva los resultados de las consultas SQL. Las visualizaciones incluyen:
- Mapa que muestra ventas por país.
- Gráfico de barras horizontales que muestra las ventas por país y por año.
- Gráfico de burbujas con ventas por categoría (en %).
- Gráfico combinado de líneas y de barras que muestra la cantidad de productos vendidos y la ganancia obtenida respectivamente por mes.

Las visualizaciones están disponibles en el archivo `visualizaciones.twbx`.

## Insights obtenidos del análisis
- Estados Unidos y Alemania son los países que representan la mayor cantidad de ventas.
- Las categorías de productos más vendidas son "bebidas" y "productos de uso diario".
- 

#### Los archivos que puedes encontrar en este repositorio son:
- `instnwnd.sql`: archivo ejecutable para crear y cargar el dataset Northwind.
- `consultas.sql`: archivo sql con las consultas realizadas.
- `funcionesyprocedimientos.sql`: archivo sql con funciones y procedimientos.
- `visualizaciones.twbx`: visualizaciones en Tableau.
- `Northwind.xls`: archivo de Excel con los datos que se van a visualizar.
- `DER.png`: imagen con el Diagrama de Entidad-Relación
- `README.md`: archivo README del repositorio.
- `src`: carpeta con imágenes del repositorio.

![](https://github.com/federicomolina86/Northwind_SQL_Tableau/blob/main/src/visualizaciones.png)
![](https://github.com/federicomolina86/Northwind_SQL_Tableau/blob/main/DER.png)
