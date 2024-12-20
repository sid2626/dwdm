create database a4snow;

use a4snow;

-- Create Sub-dimension Tables
CREATE TABLE DimCustomerLocations (
    location_id INT PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE DimBranchLocations (
    branch_location_id INT PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

-- Create Dimension Tables
CREATE TABLE DimCustomers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    gender CHAR(1),
    dob DATE,
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(255),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES DimCustomerLocations(location_id)
);

CREATE TABLE DimAccounts (
    account_id INT PRIMARY KEY,
    account_type VARCHAR(50),
    open_date DATE,
    interest_rate DECIMAL(5, 2)
);

CREATE TABLE DimBranches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(255),
    branch_location_id INT,
    FOREIGN KEY (branch_location_id) REFERENCES DimBranchLocations(branch_location_id)
);

CREATE TABLE DimTime (
    time_id INT PRIMARY KEY,
    date DATE,
    day VARCHAR(10),
    month VARCHAR(20),
    year INT,
    quarter VARCHAR(10)
);

-- Create Fact Table
CREATE TABLE FactTransactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    account_id INT,
    branch_id INT,
    time_id INT,
    transaction_type VARCHAR(50),
    amount DECIMAL(15, 2),
    balance_after_transaction DECIMAL(15, 2),
    currency VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES DimCustomers(customer_id),
    FOREIGN KEY (account_id) REFERENCES DimAccounts(account_id),
    FOREIGN KEY (branch_id) REFERENCES DimBranches(branch_id),
    FOREIGN KEY (time_id) REFERENCES DimTime(time_id)
);

-- Insert data into Sub-dimensions
INSERT INTO DimCustomerLocations VALUES
(1, 'New York', 'NY', 'USA'),
(2, 'San Francisco', 'CA', 'USA');

INSERT INTO DimBranchLocations VALUES
(1, 'New York', 'NY', 'USA'),
(2, 'San Francisco', 'CA', 'USA');

-- Insert data into Customers
INSERT INTO DimCustomers VALUES
(1, 'John Doe', 'M', '1990-05-15', '123 Elm Street', '1234567890', 'john.doe@example.com', 1),
(2, 'Jane Smith', 'F', '1985-03-22', '456 Maple Street', '0987654321', 'jane.smith@example.com', 2);

-- Insert data into Accounts
INSERT INTO DimAccounts VALUES
(1, 'Savings', '2015-06-01', 1.5),
(2, 'Checking', '2017-08-15', 0.5);

-- Insert data into Branches
INSERT INTO DimBranches VALUES
(1, 'Downtown Branch', 1),
(2, 'Uptown Branch', 2);

-- Insert data into Time
INSERT INTO DimTime VALUES
(1, '2024-11-01', 'Friday', 'November', 2024, 'Q4'),
(2, '2024-11-02', 'Saturday', 'November', 2024, 'Q4');

-- Insert data into Transactions
INSERT INTO FactTransactions VALUES
(1, 1, 1, 1, 1, 'Deposit', 1000.00, 2000.00, 'USD'),
(2, 2, 2, 2, 2, 'Withdrawal', 500.00, 1500.00, 'USD');


SELECT 
    bl.city AS branch_city,
    bl.state AS branch_state,
    cl.city AS customer_city,
    cl.state AS customer_state,
    a.account_type,
    f.transaction_type,
    SUM(f.amount) AS total_amount,
    COUNT(f.transaction_id) AS transaction_count
FROM 
    FactTransactions f
JOIN 
    DimBranches b ON f.branch_id = b.branch_id
JOIN 
    DimBranchLocations bl ON b.branch_location_id = bl.branch_location_id
JOIN 
    DimCustomers c ON f.customer_id = c.customer_id
JOIN 
    DimCustomerLocations cl ON c.location_id = cl.location_id
JOIN 
    DimAccounts a ON f.account_id = a.account_id
GROUP BY 
    bl.city, bl.state, cl.city, cl.state, a.account_type, f.transaction_type
ORDER BY 
    total_amount DESC;

