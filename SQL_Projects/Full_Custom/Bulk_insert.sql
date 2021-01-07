CREATE DATABASE Full_Custom;
GO
USE Full_Custom;
GO

CREATE TABLE Total_Data 
(
Transaction_ID INT NOT NULL,
OrderNumber INT,
QuantityOrdered INT,
PriceEach FLOAT,
OrderLineNumber INT,
Sales FLOAT,
OrderDate DATE,
StatusCode VARCHAR(30),
QTR_ID INT,
Month_ID INT,
Year_ID INT,
ProductLine VARCHAR(30),
MSRP INT,
ProductCode VARCHAR(10) NOT NULL,
CustomerName VARCHAR(50),
Phone VARCHAR(20),
AddressLine1 VARCHAR(50),
AddressLine2 VARCHAR(50),
City VARCHAR(30),
StateCode VARCHAR(20),
PostalCode VARCHAR(10),
Country VARCHAR(30),
Territory VARCHAR(10),
Contact_LName VARCHAR(30),
Contact_FName VARCHAR(30),
DealSize VARCHAR(10),
Customer_ID INT NOT NULL,
Shipping_ID INT NOT NULL
);

BULK INSERT Total_Data
FROM 'C:\Users\benit\Desktop\UNT Data Science\Fall 2019\INFO 5707\Final\sales_data_sample2.csv'
WITH
(
FIRSTROW = 2,
FORMAT = 'CSV',
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

SELECT *  FROM Total_Data;




SELECT
Transaction_ID,
Customer_ID,
ProductCode,
OrderNumber,
OrderLineNumber,
QuantityOrdered,
PriceEach,
ProductLine,
DealSize,
Sales
INTO Transactions
FROM Total_Data;

ALTER TABLE Transactions
  ADD PRIMARY KEY (Transaction_ID)

SELECT * FROM Transactions;


SELECT DISTINCT
Customer_ID,
CustomerName,
Contact_FName,
Contact_LName,
Phone,
AddressLine1,
AddressLine2,
City,
StateCode,
PostalCode,
Country,
Territory
INTO Customers
FROM Total_Data;

SELECT * FROM Customers;

ALTER TABLE Customers
  ADD PRIMARY KEY (Customer_ID);


SELECT DISTINCT Productcode, ProductLine, MSRP
INTO Products
FROM Total_Data;

ALTER TABLE Products
	ADD PRIMARY KEY (ProductCode);

SELECT * FROM Products;

SELECT
Shipping_ID,
Transaction_ID,
Customer_ID,
ProductCode,
OrderDate,
StatusCode,
QuantityOrdered
INTO Shipping
FROM Total_Data;


ALTER TABLE Shipping
Add PRIMARY KEY(Shipping_ID);

Alter Table Shipping
ADD CONSTRAINT FK_Shipping_Transactions_ID FOREIGN KEY (Transaction_ID)
    REFERENCES Transactions(Transaction_ID);

Alter Table Shipping
ADD CONSTRAINT FK_Shipping_Customers_ID FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID);

ALTER TABLE Shipping
	ADD CONSTRAINT FK_Shipping_Products_CODE FOREIGN KEY (ProductCode)
	REFERENCES Products(ProductCode);


SELECT * FROM Shipping;


SELECT SUM(Sales) AS Annual_Sales, Customer_ID, Year_ID
INTO Annual_Sales
FROM Total_Data
Group BY Customer_ID,Year_ID
Order BY Customer_ID;

ALTER TABLE Annual_Sales
	ADD CONSTRAINT FK_Customers_Annual_Sales_ID FOREIGN KEY (Customer_ID)
	REFERENCES Customers(Customer_ID);

SELECT * FROM Annual_Sales;


Alter Table Transactions
ADD CONSTRAINT FK_Transactions_Customer_ID FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID);

Alter Table Transactions
ADD CONSTRAINT FK_Transactions_ProductCode FOREIGN KEY (ProductCode)
    REFERENCES Products(ProductCode);




SELECT c.CustomerName, ProductLine, QuantityOrdered 
FROM Transactions t 
JOIN Customers c ON c.Customer_ID = t.Customer_ID
WHERE QuantityOrdered > 30;

SELECT c.CustomerName, ProductCode, OrderDate 
FROM Shipping s JOIN Customers c ON c.Customer_ID = s.Customer_ID
WHERE ProductCode = 'S18_3259' 
AND MONTH(OrderDate) = 11
AND YEAR(OrderDate) = 2004;


SELECT ROUND(SUM(t.QuantityOrdered), 0), p.ProductLine
FROM Transactions t JOIN Shipping s ON s.Transaction_ID = t.transaction_ID
JOIN Products p ON p.ProductCode = s.ProductCode
WHERE YEAR(OrderDate) = '2005'
AND p.ProductLine = 'Planes'
Group BY p.ProductLine;



SELECT c.CustomerName, p.ProductLine, Country FROM Customers c JOIN Shipping s on s.Customer_ID = c.Customer_ID
JOIN Products p ON p.ProductCode = s.ProductCode
WHERE p.ProductLine = 'Trains'
AND c.Country = 'France';


SELECT SUM(Sales) AS 'Total Customer Sales', c.CustomerName FROM Transactions t JOIN Customers c ON c.Customer_ID = t.Customer_ID
WHERE c.Country = 'France'
Group BY c.CustomerName;