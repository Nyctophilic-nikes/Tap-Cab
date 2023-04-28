-- Table for storing customer information
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL unique,
    phone VARCHAR(20) NOT NULL unique,
    address VARCHAR(200) NOT NULL,
    password VARCHAR(50) NOT NULL
);

-- Table for storing driver information
CREATE TABLE Driver (
    driver_id INT PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL unique,
    phone VARCHAR(20) NOT NULL unique,
    address VARCHAR(200) NOT NULL,
    password VARCHAR(50) NOT NULL,
    rating FLOAT DEFAULT 0.0
);


-- Table for storing cab information
CREATE TABLE Cab (
    cab_id INT PRIMARY KEY auto_increment,
    type VARCHAR(20) NOT NULL,
    registration_number VARCHAR(20) NOT NULL,
    cab_status varchar(20) DEFAULT 'free',
    driver_id INT,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

-- Table for storing admin information
CREATE TABLE Admin (
    admin_id INT PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL unique,
    password VARCHAR(50) NOT NULL
);

-- Table for storing distance and fare information between two locations
CREATE TABLE Location (
location_id INT PRIMARY KEY auto_increment,
start_location VARCHAR(200) NOT NULL,
end_location VARCHAR(200) NOT NULL,
distance FLOAT NOT NULL,
fare FLOAT NOT NULL
);

-- Table for storing booking information
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY auto_increment,
    customer_id INT,
    cab_id INT,
    pickup_location VARCHAR(200) NOT NULL,
    destination VARCHAR(200) NOT NULL,
    fare FLOAT NOT NULL,
    status VARCHAR(20) DEFAULT 'BOOKED',
    booking_time DATETIME NOT NULL,
    confirm_time DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (cab_id) REFERENCES Cab(cab_id),
    
    check (fare >=0)
);

-- Table for storing confirm booking information
CREATE TABLE Confirm (
    booking_id INT PRIMARY KEY,
    driver_id INT,
    confirm_time DATETIME,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);



-- Table for storing payment information
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY auto_increment,
    booking_id INT,
    amount FLOAT NOT NULL,
    payment_time DATETIME NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    
    check (amount >= 0)
);

-- Table for storing final trip information
CREATE TABLE Trip (
    trip_id INT PRIMARY KEY auto_increment,
    booking_id INT,
    driver_id INT,
    start_time DATETIME NOT NULL,
    distance FLOAT NOT NULL,
    fare FLOAT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    
    check (fare >= 0)
);

-- Table for storing customer reviews
CREATE TABLE Review (
    review_id INT PRIMARY KEY auto_increment,
    booking_id INT,
    driver_id INT,
    customer_id INT,
    rating FLOAT NOT NULL,
    comment VARCHAR(200),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

create table dri_current(
	driver_id INT,
    dri_loc VARCHAR(200) NOT NULL,
    
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);
