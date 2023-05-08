/*The stores database contains 8 tables
customers: customer data
employees: all employee information
orderdetails: sales order line for each sales order
offices: sales office information
orders: customer sales orders
payments: payment records for each customer
productlines: a list of product line categories
products: a list of scale model cars.
The relations shown in the database are as follows:
1. productlines has 0 or many products while have 1 and only 1 productlines
2. products can have 0 to many order details while order details belong to 1 and only 1 product.
3. order details belong to 1 and only 1 order while orders can have 0 to 1 order details.
4. orders have 1 and only 1 customers while a customer can have 0 to many orders
5. employees table references itself
6. an employee has 1 and only 1 office while an office can have 0 to many employees
7. an employee has 0 to many customers while customers have 1 to 0 employees
8. payments have 1 and only 1 customer while customers can have 0 to many payments
*/
SELECT 'Customers' table_name ,
       13 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM customers 
UNION ALL
SELECT 'Employees' table_name ,
       8 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM employees 
UNION ALL
SELECT 'Offices' table_name ,
       9 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM offices 
UNION ALL
SELECT 'Order'||' '||'Details' table_name ,
       5 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM orderdetails 
UNION ALL
SELECT 'Orders' table_name ,
       7 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM orders 
UNION ALL
SELECT 'Payments' table_name ,
       4 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM payments 
UNION ALL
SELECT 'Product'||' '||'Lines' table_name ,
       4 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM productlines
UNION ALL
SELECT 'Products' table_name ,
       9 number_of_attributes, 
	   COUNT(*) number_of_rows
  FROM products ;
/*
Now that we know the db a little better, we can answwer the first question:
WHICH PRODUCTS SHOULD WE ORDER MORE OF OR LESS OF? 
This question refers to inventory reports, including low stock(product in demand) and product performance. This 
will optimize the supply and user experience by preventing the best-selling products from going out of stock.
*/
-- Query to compute the low stock for each product using a corelated subquerty
SELECT productCode, 
       ROUND(SUM(quantityOrdered)*1.0/(SELECT quantityInStock
	   FROM products p
	   WHERE 
	   o.productCode = p.productCode),2) low_stock
 FROM  orderdetails o
 GROUP BY 1
 ORDER BY low_stock DESC
 LIMIT 10;
 
-- Query to compute the product performance for each product
SELECT productCode,
       SUM(quantityOrdered * priceEach ) product_performance 
FROM orderdetails o
GROUP BY 1
ORDER BY 2 
LIMIT 10;

--	Combine the previous queries using a CTE to display priority products for restocking 

WITH 
table_lowstock AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered)*1.0/(SELECT quantityInStock
	   FROM products p
	   WHERE 
	   o.productCode = p.productCode),2) low_stock
 FROM  orderdetails o
 GROUP BY 1
 ORDER BY low_stock DESC
 LIMIT 10
)
SELECT productCode, 
	   SUM(quantityOrdered * priceEach ) product_performance  
 FROM  orderdetails o
 WHERE productCode IN(SELECT productCode
                       FROM table_lowstock)
GROUP BY 1
ORDER BY 2
LIMIT 10;

-- Question 2
--How should we match marketing and communication strategies to customer behaviour?
/*
This involves categorizing customers: finding VIP customers who bring in most profit for the store and 
the less engaged customers who  bring in less profit. For example, we could organize some events to drive loyalty for 
the VIPs and launch a campaign for the less engaged. We are going to need tables: products, orderdetails and orders.
*/
SELECT customerNumber ,
       SUM(quantityOrdered * (priceEach - buyPrice)) Profit
  FROM  products p
INNER JOIN orderdetails o
ON      p.productCode = o.productCode
INNER JOIN orders od 
ON      o.orderNumber = od.orderNumber
GROUP BY 1
ORDER BY 2 DESC;
-- Use the previous query as a CTE
WITH 
profits AS(
			SELECT customerNumber ,
				   SUM(quantityOrdered * (priceEach - buyPrice)) Profit
			  FROM  products p
			INNER JOIN orderdetails o
			ON      p.productCode = o.productCode
			INNER JOIN orders od 
			ON      o.orderNumber = od.orderNumber
			GROUP BY 1
			ORDER BY 2 DESC
			)
SELECT customers.contactLastName,
       customers.contactFirstName,
	   customers.city,
	   customers.country,
	   profits.profit 
FROM profits 
JOIN customers 
ON customers.customerNumber = profits.customerNumber
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 10;
-- Finding the least 5 customers
WITH 
profits AS(
			SELECT customerNumber ,
				   SUM(quantityOrdered * (priceEach - buyPrice)) Profit
			  FROM  products p
			INNER JOIN orderdetails o
			ON      p.productCode = o.productCode
			INNER JOIN orders od 
			ON      o.orderNumber = od.orderNumber
			GROUP BY 1
			ORDER BY 2 DESC
			)
SELECT customers.contactLastName,
       customers.contactFirstName,
	   customers.city,
	   customers.country,
	   profits.profit 
FROM profits 
JOIN customers 
ON customers.customerNumber = profits.customerNumber
GROUP BY 1,2
ORDER BY 5 
LIMIT 10;
/* QUESTION 3 
How much can we spend on new customers? 
To determine how much money we can spend acquiring new customers, we can compute the Customer Lifetime Value(LTV),
which represents the average amount of money a customer generates. We can then determine how much we can spend on marketing.
*/
WITH 
profits AS(
			SELECT customerNumber ,
				   SUM(quantityOrdered * (priceEach - buyPrice)) Profit
			  FROM  products p
			INNER JOIN orderdetails o
			ON      p.productCode = o.productCode
			INNER JOIN orders od 
			ON      o.orderNumber = od.orderNumber
			GROUP BY 1
			)
SELECT 
		AVG(profits.Profit ) LTV
FROM profits ;

	   
