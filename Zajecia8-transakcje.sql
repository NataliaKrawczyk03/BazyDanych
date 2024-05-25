--1. Napisz zapytanie, które wykorzystuje transakcjê (zaczyna j¹), a nastêpnie 
--aktualizuje cenê produktu o ProductID równym 680 w tabeli Production.Product
 --o 10%inastêpnie zatwierdza transakcjê.

USE AdventureWorks2022;
 
SELECT 
	ProductID,
	ListPrice,
	Name
FROM Production.Product
WHERE ProductID = 680;

BEGIN TRANSACTION; --rozpoczecie transjacji

UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductID = 680;

COMMIT TRANSACTION; --zatwierdzenie transakcji

SELECT 
	ProductID,
	ListPrice,
	Name
FROM Production.Product
WHERE ProductID = 680;

--2.Napisz zapytanie, które zaczyna transakcjê, usuwa produkt o ProductID równym
 --707 z tabeli Production. Product, ale nastêpnie wycofuje transakcjê.

SELECT * FROM Production.Product
WHERE ProductID = 707;

BEGIN TRANSACTION;

-- Usuniêcie 
DELETE FROM Production.Product
WHERE ProductID = 707;

-- Sprawdzenie
SELECT * FROM Production.Product
WHERE ProductID = 707;

-- Wycofanie
ROLLBACK TRANSACTION;

--3.Napisz zapytanie, które zaczyna transakcjê, dodaje nowy produkt do tabeli Production.Product, a nastêpnie zatwierdza transakcjê.

BEGIN TRANSACTION;

SELECT *
FROM Production.Product
WHERE Name = 'New Product';

INSERT INTO Production.Product (
    Name,
    ProductNumber,
    MakeFlag,
    FinishedGoodsFlag,
    Color,
    SafetyStockLevel,
    ReorderPoint,
    StandardCost,
    ListPrice,
    Size,
    SizeUnitMeasureCode,
    WeightUnitMeasureCode,
    Weight,
    DaysToManufacture,
    ProductLine,
    Class,
    Style,
    ProductSubcategoryID,
    ProductModelID,
    SellStartDate,
    SellEndDate,
    DiscontinuedDate,
    rowguid,
    ModifiedDate
) VALUES (
    'New Product',  
    'NP-001',  
    1, 
	1,
    'Red',   
    100,           
    50,                 
    10.00,              
    20.00,             
    'L',         
    'CM',         
    'G',         
    1.00,    
    5,    
    'T', 
    'H',  
    'M', 
    1,  
    1,                  
    GETDATE(),           
    NULL,                
    NULL,
    NEWID(),
    GETDATE()

);

SELECT *
FROM Production.Product
WHERE Name = 'New Product';

COMMIT TRANSACTION;

--4.Napisz zapytanie, które zaczyna transakcjê i aktualizuje StandardCost wszystkich
 --produktów w tabeli Production.Product o 10%, je¿eli suma wszystkich
 --StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
 --powinno wycofaæ transakcjê.

 BEGIN TRANSACTION;


UPDATE Production.Product
SET StandardCost = StandardCost * 1.10;

DECLARE @TotalStandardCost MONEY;

SELECT @TotalStandardCost = SUM(StandardCost) FROM Production.Product;

IF @TotalStandardCost <= 50000
BEGIN
    COMMIT;
    PRINT 'Transakcja siê powiod³a, ³¹czny koszt to:'+ CAST(@TotalStandardCost AS NVARCHAR(50));
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Transakcja siê nie powiod³a, ³¹czny koszt to: ' + CAST(@TotalStandardCost AS NVARCHAR(50));
END;


--5.Napisz zapytanie SQL, które zaczyna transakcjê i próbuje dodaæ nowy produkt do
 --tabeli Production.Product. Jeœli ProductNumber ju¿ istnieje w tabeli, zapytanie
 --powinno wycofaæ transakcjê.

BEGIN TRANSACTION;

DECLARE @ProductNumber NVARCHAR(25);
SET @ProductNumber = 'AR-5381'; 


IF EXISTS (SELECT * FROM Production.Product WHERE ProductNumber = @ProductNumber)
BEGIN
    
    ROLLBACK;
    PRINT 'Transakcja siê nie powiod³a: ProductNumber ju¿ istnieje.';
END
ELSE
BEGIN
    INSERT INTO Production.Product (
        Name,
        ProductNumber,
        MakeFlag,
        FinishedGoodsFlag,
        Color,
        SafetyStockLevel,
        ReorderPoint,
        StandardCost,
        ListPrice,
        Size,
        SizeUnitMeasureCode,
        WeightUnitMeasureCode,
        Weight,
        DaysToManufacture,
        ProductLine,
        Class,
        Style,
        ProductSubcategoryID,
        ProductModelID,
        SellStartDate,
        SellEndDate,
        DiscontinuedDate,
        rowguid,
        ModifiedDate
    ) VALUES (
        'New Product',  
		@ProductNumber,  
		1, 
		1,
		'Red',   
		100,           
		50,                 
		10.00,              
		20.00,             
		'L',         
		'CM',         
		'G',         
		1.00,    
		5,    
		'T', 
		'H',  
		'M', 
		1,  
		1,                  
		GETDATE(),           
		NULL,                
		NULL,
		NEWID(),
		GETDATE()     
    );
   
    ROLLBACK;
    PRINT 'Transakcja siê powiod³a: Produkt zosta³ dodany.';
END;


--6.Napisz zapytanie SQL, które zaczyna transakcjê i aktualizuje wartoœæ OrderQty
 --dla ka¿dego zamówienia w tabeli Sales.SalesOrderDetail. Je¿eli którykolwiek z
 --zamówieñ maOrderQty równ¹ 0, zapytanie powinno wycofaæ transakcjê.

BEGIN TRANSACTION;

IF EXISTS (SELECT * FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK;
    PRINT 'Transakcja siê nie powiod³a: Jeden z rekordów ma OrderQty równ¹ 0.';
END
ELSE
BEGIN
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1  ; -- przyk³adowa aktualizacja

    COMMIT;
    PRINT 'Transakcja siê powiod³a: OrderQty zosta³y zaktualizowane.';
END;


--7.Napisz zapytanie SQL, które zaczyna transakcjê i usuwa wszystkie produkty,
 --których StandardCost jest wy¿szy ni¿ œredni koszt wszystkich produktów w tabeli
 --Production.Product. Je¿eli liczba produktów do usuniêcia przekracza 10,
 --zapytanie powinno wycofaæ transakcjê.

BEGIN TRANSACTION;

DECLARE @AverageStandardCost MONEY;
SELECT @AverageStandardCost = AVG(StandardCost) FROM Production.Product;

DECLARE @ProductsToDeleteCount INT;
SELECT @ProductsToDeleteCount = COUNT(*) --zliczenie wszystkich 
FROM Production.Product
WHERE StandardCost > @AverageStandardCost;

IF @ProductsToDeleteCount > 10
BEGIN
    ROLLBACK;
    PRINT 'Transakcja siê nie powiod³a: Liczba produktów do usuniêcia przekracza 10. Wynosi:'+ CAST(@ProductsToDeleteCount AS NVARCHAR(50));
END
ELSE
BEGIN
    DELETE FROM Production.Product
    WHERE StandardCost > @AverageStandardCost;

    COMMIT;
    PRINT 'Transakcja siê powiod³a: Produkty zosta³y usuniête.';
END;
