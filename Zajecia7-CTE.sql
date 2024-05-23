/*
1.Wykorzystuj¹c wyra¿enie CTE zbuduj zapytanie, które znajdzie informacje na temat stawki 
pracownika oraz jego danych, a nastêpnie zapisze je do tabeli tymczasowej 
TempEmployeeInfo. Rozwi¹¿ w oparciu o AdventureWorks.
*/
USE AdventureWorks2022;

WITH EmployeeCTE AS (
    SELECT
        eph.BusinessEntityID,
        p.FirstName,
        p.LastName,
        MAX(eph.Rate) as HourlyRate
    FROM
        HumanResources.EmployeePayHistory eph
    JOIN
        Person.Person p ON p.BusinessEntityID = eph.BusinessEntityID
    GROUP BY
        eph.BusinessEntityID, p.FirstName, p.LastName
)

SELECT *
INTO #TempEmployeeInfo --tymczasowa tabela
FROM EmployeeCTE;

SELECT * FROM #TempEmployeeInfo;


--2.Uzyskaj informacje na temat przychodów ze sprzeda¿y wed³ug firmy i kontaktu (za pomoc¹ CTE i bazy AdventureWorksL).
USE AdventureWorksLT2019;

WITH Coandrev AS (
SELECT
    CONCAT(c.CompanyName, ' (', c.FirstName, ' ', c.LastName, ')') AS CompanyContact,
    soh.TotalDue as Revenue
FROM 
    SalesLT.Customer c
JOIN
    SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
)

SELECT *
INTO #Companyinfo
FROM Coandrev;

SELECT * FROM #Companyinfo;


--3.Napisz zapytanie, które zwróci wartoœæ sprzeda¿y dla poszczególnych kategorii produktów
WITH CategoryValue AS (
	SELECT
		pc.Name AS Category,
		SUM(s.LineTotal) as SalecValue
	FROM
		SalesLT.ProductCategory pc
	JOIN
		SalesLT.Product p ON pc.ProductCategoryID = p.ProductCategoryID
	JOIN
		Saleslt.SalesOrderDetail s ON p.ProductID = s.ProductID
	GROUP BY
		pc.Name
)

SELECT *
INTO #CategoryValueInfo
FROM CategoryValue;

SELECT * FROM #CategoryValueInfo;