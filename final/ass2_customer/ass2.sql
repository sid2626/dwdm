create database ass2;
use ass2;

create table customer_dimension(
    customer_id int primary key,
    customer_name varchar(20),
    ShippingAddress varchar(100),
    Billingaddress varchar(100)
    );
    
create table product_dimension(
    product_id int primary key,
    product_name varchar(20),
    category varchar(20),
    price decimal(10,2)
    );
    
  CREATE TABLE Promotion_Dimension (
    PromotionID INT PRIMARY KEY,
    Description VARCHAR(255),
    Discount DECIMAL(5, 2) -- Percentage discount, e.g., 10.00 for 10%
);  

CREATE TABLE SalesRep_Dimension (
    SalesRepID INT PRIMARY KEY,
    Name VARCHAR(100),
    PerformanceRating VARCHAR(50)
);

CREATE TABLE Date_Dimension (
    Date DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT
);

CREATE TABLE Order_Facts (
    OrderID INT PRIMARY KEY,
    customer_ID INT,
    product_ID INT,
    PromotionID INT,
    SalesRepID INT,
    OrderDate DATE,
    ShipDate DATE,
    GrossAmount DECIMAL(15, 2),
    NetAmount DECIMAL(15, 2),
    Currency VARCHAR(10),
    FOREIGN KEY (customer_ID) REFERENCES customer_Dimension(Customer_ID),
    FOREIGN KEY (product_ID) REFERENCES product_Dimension(Product_ID),
    FOREIGN KEY (PromotionID) REFERENCES Promotion_Dimension(PromotionID),
    FOREIGN KEY (SalesRepID) REFERENCES SalesRep_Dimension(SalesRepID),
    FOREIGN KEY (OrderDate) REFERENCES Date_Dimension(Date),
    FOREIGN KEY (ShipDate) REFERENCES Date_Dimension(Date)
);


-- Insert into Customer_Dimension
INSERT INTO Customer_Dimension (customer_ID, customer_name, ShippingAddress, BillingAddress)
VALUES (2, 'John Doe', '123 Maple Street', '456 Oak Avenue');

-- Insert into Product_Dimension
INSERT INTO Product_Dimension (product_ID, product_name, Category, Price)
VALUES (1, 'Laptop', 'Electronics', 1000.00);

-- Insert into Promotion_Dimension
INSERT INTO Promotion_Dimension (PromotionID, Description, Discount)
VALUES (1, 'Black Friday Deal', 10);

-- Insert into SalesRep_Dimension
INSERT INTO SalesRep_Dimension (SalesRepID, Name, PerformanceRating)
VALUES (1, 'Alice Johnson', 'Excellent');

-- Insert into Date_Dimension
INSERT INTO Date_Dimension (Date, Year, Month, Day)
VALUES ('2024-11-27', 2024, 11, 27);

-- Insert into Order_Facts
INSERT INTO Date_Dimension (Date, Year, Month, Day)
VALUES ('2024-11-26', 2024, 11, 26),
       ('2024-12-01', 2024, 12, 1);
       
       INSERT INTO Order_Facts (OrderID, Customer_ID, Product_ID, PromotionID, SalesRepID, OrderDate, ShipDate, GrossAmount, NetAmount, Currency)
VALUES (1, 1, 1, 1, 1, '2024-11-26', '2024-12-01', 1000.00, 900.00, 'USD');


SELECT 
    C.Customer_name AS Customer_name,
    P.product_name AS Product_name,
    PR.Description AS PromotionDescription,
    S.Name AS SalesRepName,
    SUM(O.NetAmount) AS TotalNetAmount,
    O.Currency
FROM 
    Order_Facts O
JOIN 
    Customer_Dimension C ON O.Customer_ID = C.Customer_ID
JOIN 
    Product_Dimension P ON O.Product_ID = P.Product_ID
JOIN 
    Promotion_Dimension PR ON O.PromotionID = PR.PromotionID
JOIN 
    SalesRep_Dimension S ON O.SalesRepID = S.SalesRepID
GROUP BY 
    C.customer_name, P.product_name, PR.Description, S.Name, O.Currency;
