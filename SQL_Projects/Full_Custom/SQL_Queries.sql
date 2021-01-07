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