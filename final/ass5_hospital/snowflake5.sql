create database a5;
use a5;

-- dim&subdim--
CREATE TABLE DimPatient (
    PatientKey INT PRIMARY KEY AUTO_INCREMENT,
    PatientName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Age INT NOT NULL,
    RegionKey INT NOT NULL,
    InsuranceProvider VARCHAR(100),
    FOREIGN KEY (RegionKey) REFERENCES DimRegion(RegionKey)
);
CREATE TABLE DimRegion (
    RegionKey INT PRIMARY KEY AUTO_INCREMENT,
    RegionName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

-- dim&subdim--
CREATE TABLE DimSpecialization (
    SpecializationKey INT PRIMARY KEY AUTO_INCREMENT,
    SpecializationName VARCHAR(50) NOT NULL
);
CREATE TABLE DimDoctor (
    DoctorKey INT PRIMARY KEY AUTO_INCREMENT,
    DoctorName VARCHAR(100) NOT NULL,
    SpecializationKey INT NOT NULL,
    ExperienceYears INT,
    FOREIGN KEY (SpecializationKey) REFERENCES DimSpecialization(SpecializationKey)
);

-- dim&subdim--
CREATE TABLE DimLocation (
    LocationKey INT PRIMARY KEY AUTO_INCREMENT,
    LocationName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);
CREATE TABLE DimDepartment (
    DepartmentKey INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    LocationKey INT NOT NULL,
    FOREIGN KEY (LocationKey) REFERENCES DimLocation(LocationKey)
);

-- onlydim --
CREATE TABLE DimTreatment (
    TreatmentKey INT PRIMARY KEY AUTO_INCREMENT,
    TreatmentName VARCHAR(100) NOT NULL,
    TreatmentType VARCHAR(50),
    Cost DECIMAL(10, 2)
);

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY AUTO_INCREMENT,
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
    DayOfWeek VARCHAR(15),
    IsWeekend BOOLEAN
);


CREATE TABLE FactPatientVisit (
    VisitKey INT PRIMARY KEY AUTO_INCREMENT,
    PatientKey INT NOT NULL,
    DoctorKey INT NOT NULL,
    DepartmentKey INT NOT NULL,
    TreatmentKey INT NOT NULL,
    DateKey INT NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    TotalRevenue DECIMAL(10, 2) NOT NULL,
    TreatmentDuration INT NOT NULL, -- in hours
    
    FOREIGN KEY (PatientKey) REFERENCES DimPatient(PatientKey),
    FOREIGN KEY (DoctorKey) REFERENCES DimDoctor(DoctorKey),
    FOREIGN KEY (DepartmentKey) REFERENCES DimDepartment(DepartmentKey),
    FOREIGN KEY (TreatmentKey) REFERENCES DimTreatment(TreatmentKey),
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
);

INSERT INTO DimRegion (RegionName, Country) VALUES
('North', 'USA'),
('South', 'USA'),
('East', 'USA'),
('West', 'USA');

INSERT INTO DimPatient (PatientName, Gender, Age, RegionKey, InsuranceProvider) VALUES
('John Doe', 'Male', 45, 1, 'HealthCare Inc.'),
('Jane Smith', 'Female', 32, 2, 'MediLife'),
('Alice Johnson', 'Female', 29, 3, 'WellnessCare'),
('Mark Spencer', 'Male', 40, 4, 'SecureHealth');

INSERT INTO DimSpecialization (SpecializationName) VALUES
('Cardiology'),
('Orthopedics'),
('Pediatrics'),
('General Medicine');

INSERT INTO DimDoctor (DoctorName, SpecializationKey, ExperienceYears) VALUES
('Dr. Emily Carter', 1, 15),
('Dr. Michael Lee', 2, 10),
('Dr. Sarah Brown', 3, 8),
('Dr. Robert King', 4, 20);

INSERT INTO DimLocation (LocationName, City, Country) VALUES
('Building A', 'New York', 'USA'),
('Building B', 'Los Angeles', 'USA'),
('Building C', 'Chicago', 'USA'),
('Building D', 'Houston', 'USA');

INSERT INTO DimDepartment (DepartmentName, LocationKey) VALUES
('Cardiology', 1),
('Orthopedics', 2),
('Pediatrics', 3),
('General Medicine', 4);

INSERT INTO DimTreatment (TreatmentName, TreatmentType, Cost) VALUES
('Heart Surgery', 'Surgery', 5000.00),
('Fracture Repair', 'Surgery', 2000.00),
('Vaccination', 'Preventive Care', 50.00),
('General Checkup', 'Consultation', 100.00);

INSERT INTO DimDate (FullDate, Year, Month, Day, DayOfWeek, IsWeekend) VALUES
('2024-11-01', 2024, 11, 1, 'Friday', FALSE),
('2024-11-02', 2024, 11, 2, 'Saturday', TRUE),
('2024-11-03', 2024, 11, 3, 'Sunday', TRUE),
('2024-11-04', 2024, 11, 4, 'Monday', FALSE);

INSERT INTO FactPatientVisit (PatientKey, DoctorKey, DepartmentKey, TreatmentKey, DateKey, TotalCost, TotalRevenue, TreatmentDuration) VALUES
(1, 1, 1, 1, 1, 5000.00, 7000.00, 4),
(2, 2, 2, 2, 2, 2000.00, 3000.00, 3),
(3, 3, 3, 3, 3, 50.00, 100.00, 1),
(4, 4, 4, 4, 4, 100.00, 150.00, 1);

-- avg treatment duration by specialisation --
SELECT 
    S.SpecializationName,
    AVG(F.TreatmentDuration) AS AvgTreatmentDuration
FROM 
    FactPatientVisit F
JOIN 
    DimDoctor D ON F.DoctorKey = D.DoctorKey
JOIN 
    DimSpecialization S ON D.SpecializationKey = S.SpecializationKey
GROUP BY 
    S.SpecializationName;

-- total revenue / cost --
SELECT 
    R.RegionName,
    SUM(F.TotalCost) AS TotalCost,
    SUM(F.TotalRevenue) AS TotalRevenue
FROM 
    FactPatientVisit F
JOIN 
    DimPatient P ON F.PatientKey = P.PatientKey
JOIN 
    DimRegion R ON P.RegionKey = R.RegionKey
GROUP BY 
    R.RegionName;
