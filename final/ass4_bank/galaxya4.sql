create database a4galaxy;

use a4galaxy;

-- Shared Dimension Tables
CREATE TABLE DimCustomers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    gender CHAR(1),
    dob DATE,
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(255)
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
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE DimTime (
    time_id INT PRIMARY KEY,
    date DATE,
    day VARCHAR(10),
    month VARCHAR(20),
    year INT,
    quarter VARCHAR(10)
);

-- Fact Table: Transactions
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

-- Fact Table: Loans
CREATE TABLE FactLoans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    time_id INT,
    loan_amount DECIMAL(15, 2),
    interest_rate DECIMAL(5, 2),
    loan_duration_months INT,
    loan_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES DimCustomers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES DimBranches(branch_id),
    FOREIGN KEY (time_id) REFERENCES DimTime(time_id)
);

-- Insert data into Dimensions
INSERT INTO DimCustomers VALUES
(1, 'John Doe', 'M', '1990-05-15', '123 Elm Street', '1234567890', 'john.doe@example.com'),
(2, 'Jane Smith', 'F', '1985-03-22', '456 Maple Street', '0987654321', 'jane.smith@example.com');

INSERT INTO DimAccounts VALUES
(1, 'Savings', '2015-06-01', 1.5),
(2, 'Checking', '2017-08-15', 0.5);

INSERT INTO DimBranches VALUES
(1, 'Downtown Branch', 'New York', 'NY', 'USA'),
(2, 'Uptown Branch', 'San Francisco', 'CA', 'USA');

INSERT INTO DimTime VALUES
(1, '2024-11-01', 'Friday', 'November', 2024, 'Q4'),
(2, '2024-11-02', 'Saturday', 'November', 2024, 'Q4');

-- Insert data into FactTransactions
INSERT INTO FactTransactions VALUES
(1, 1, 1, 1, 1, 'Deposit', 1000.00, 2000.00, 'USD'),
(2, 2, 2, 2, 2, 'Withdrawal', 500.00, 1500.00, 'USD');

-- Insert data into FactLoans
INSERT INTO FactLoans VALUES
(1, 1, 1, 1, 10000.00, 5.5, 60, 'Approved'),
(2, 2, 2, 2, 5000.00, 6.0, 36, 'Pending');

SELECT 
    c.customer_name,
    b.branch_name,
    SUM(t.amount) AS total_transaction_amount
FROM 
    FactTransactions t
JOIN 
    DimCustomers c ON t.customer_id = c.customer_id
JOIN 
    DimBranches b ON t.branch_id = b.branch_id
GROUP BY 
    c.customer_name, b.branch_name
ORDER BY 
    total_transaction_amount DESC;

