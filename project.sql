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
  FROM products 

