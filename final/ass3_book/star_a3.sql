create database a3;
use a3;


CREATE TABLE DimBookType (
    BookTypeKey INT PRIMARY KEY AUTO_INCREMENT,
    BookType VARCHAR(100) NOT NULL
);

CREATE TABLE DimLocation (
    LocationKey INT PRIMARY KEY AUTO_INCREMENT,
    LocationName VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL
);

CREATE TABLE DimAuthor (
    AuthorKey INT PRIMARY KEY AUTO_INCREMENT,
    AuthorName VARCHAR(150) NOT NULL,
    AuthorAge INT NOT NULL,
    Country VARCHAR(100) NOT NULL
);

CREATE TABLE DimPublication (
    PublicationKey INT PRIMARY KEY AUTO_INCREMENT,
    PublicationName VARCHAR(150) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    YearEstablished INT NOT NULL
);

CREATE TABLE FactSales (
    FactID INT PRIMARY KEY AUTO_INCREMENT,
    BookTypeKey INT NOT NULL,
    LocationKey INT NOT NULL,
    AuthorKey INT NOT NULL,
    PublicationKey INT NOT NULL,
    Quantity INT NOT NULL,
    Profit DECIMAL(10, 2) NOT NULL,
    TransactionDate DATE NOT NULL,

    FOREIGN KEY (BookTypeKey) REFERENCES DimBookType(BookTypeKey),
    FOREIGN KEY (LocationKey) REFERENCES DimLocation(LocationKey),
    FOREIGN KEY (AuthorKey) REFERENCES DimAuthor(AuthorKey),
    FOREIGN KEY (PublicationKey) REFERENCES DimPublication(PublicationKey)
);

INSERT INTO DimBookType (BookType) VALUES 
('Fiction'), 
('Non-Fiction'), 
('Biography'), 
('Science Fiction'), 
('Fantasy');

INSERT INTO DimLocation (LocationName, Country) VALUES 
('New York', 'USA'), 
('London', 'UK'), 
('Mumbai', 'India'), 
('Tokyo', 'Japan'), 
('Sydney', 'Australia');

INSERT INTO DimAuthor (AuthorName, AuthorAge, Country) VALUES 
('J.K. Rowling', 55, 'UK'), 
('George R.R. Martin', 72, 'USA'), 
('Chetan Bhagat', 49, 'India'), 
('Haruki Murakami', 73, 'Japan'), 
('J.R.R. Tolkien', 81, 'UK');

INSERT INTO DimPublication (PublicationName, Country, YearEstablished) VALUES 
('Penguin Books', 'UK', 1935), 
('HarperCollins', 'USA', 1989), 
('Hachette Book Group', 'France', 1826), 
('Bloomsbury', 'UK', 1986), 
('Random House', 'USA', 1927);

INSERT INTO FactSales (BookTypeKey, LocationKey, AuthorKey, PublicationKey, Quantity, Profit, TransactionDate) VALUES 
(1, 1, 1, 4, 500, 7500.00, '2024-11-01'),
(2, 2, 2, 2, 300, 4500.00, '2024-11-02'),
(3, 3, 3, 1, 150, 2500.00, '2024-11-03'),
(4, 4, 4, 5, 200, 6000.00, '2024-11-04'),
(5, 5, 5, 3, 100, 4000.00, '2024-11-05');

select *from DimBookType;
select *from DimLocation;
select *from DimAuthor;
select *from DimPublication;
select *from FactSales;

-- quantitative profit by booktype--
SELECT 
    B.BookType AS BookType,
    SUM(F.Quantity) AS TotalQuantity,
    SUM(F.Profit) AS TotalProfit
FROM 
    FactSales F
JOIN 
    DimBookType B ON F.BookTypeKey = B.BookTypeKey
GROUP BY 
    B.BookType
ORDER BY 
    TotalProfit DESC;

-- quantitative profit by location--
SELECT 
    L.LocationName AS Location,
    L.Country AS Country,
    SUM(F.Quantity) AS TotalQuantity,
    SUM(F.Profit) AS TotalProfit
FROM 
    FactSales F
JOIN 
    DimLocation L ON F.LocationKey = L.LocationKey
GROUP BY 
    L.LocationName, L.Country
ORDER BY 
    TotalProfit DESC;


-- quantitative by author --
SELECT 
    A.AuthorName AS Author,
    A.Country AS AuthorCountry,
    SUM(F.Quantity) AS TotalQuantity,
    SUM(F.Profit) AS TotalProfit
FROM 
    FactSales F
JOIN 
    DimAuthor A ON F.AuthorKey = A.AuthorKey
GROUP BY 
    A.AuthorName, A.Country
ORDER BY 
    TotalProfit DESC;
