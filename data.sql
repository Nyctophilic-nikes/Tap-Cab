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



-- Customer
insert into Customer (name, email, phone, address, password) values ('Llywellyn', 'lbendson0@unblog.fr', '956-831-7956', 'Suite 88', 'mzRjyw0b');
insert into Customer (name, email, phone, address, password) values ('Marga', 'mwhines1@virginia.edu', '944-311-7286', 'Room 161', 'gpt1xsP3Ve');
insert into Customer (name, email, phone, address, password) values ('Lillis', 'loreilly2@nasa.gov', '321-445-1619', 'Room 1686', 'L0s5vrpc686');
insert into Customer (name, email, phone, address, password) values ('Winnie', 'whitzmann3@gizmodo.com', '375-191-5103', 'PO Box 54599', 'g67zNuD');
insert into Customer (name, email, phone, address, password) values ('Jayme', 'jvamplew4@desdev.cn', '185-205-1355', 'Room 621', 'WFBsws0');
insert into Customer (name, email, phone, address, password) values ('Vitia', 'vrama5@diigo.com', '852-893-5875', 'PO Box 4989', 'WJBI6She');
insert into Customer (name, email, phone, address, password) values ('Killian', 'kblacklidge6@disqus.com', '656-706-3115', 'Suite 91', 'H9zo9cl');
insert into Customer (name, email, phone, address, password) values ('Delila', 'dgini7@barnesandnoble.com', '909-977-9857', 'Suite 72', '9puwpyIjRJfp');
insert into Customer (name, email, phone, address, password) values ('Mame', 'mfaers8@discuz.net', '290-494-6874', 'Apt 706', 'FqqsTz');
insert into Customer (name, email, phone, address, password) values ('Anica', 'asmitten9@google.com.au', '832-968-5128', 'PO Box 56739', 'ldw32QQrTn');




-- Driver
insert into Driver (name, email, phone, address, password) values ('Gerri', 'goleszczak0@google.es', '253-313-5451', 'Suite 78', '1HzLquw');
insert into Driver (name, email, phone, address, password) values ('Korrie', 'klait1@oracle.com', '724-382-9005', '15th Floor', 'UyUWbHee');
insert into Driver (name, email, phone, address, password) values ('Dulsea', 'dpogosian2@amazon.co.jp', '827-310-3526', 'Apt 1655', 'myHhM1c');
insert into Driver (name, email, phone, address, password) values ('Reidar', 'rmabbutt3@tiny.cc', '809-524-8669', 'Room 46', 'CyYOEXfQjVVR');
insert into Driver (name, email, phone, address, password) values ('Christian', 'cyakolev4@ezinearticles.com', '102-791-9618', 'Suite 45', 'BQzWZ3Usf5oJ');
insert into Driver (name, email, phone, address, password) values ('Annabal', 'aandino5@edublogs.org', '333-554-7045', 'Apt 477', 'bI5vRAUA');
insert into Driver (name, email, phone, address, password) values ('Milt', 'modo6@ehow.com', '633-882-9576', 'Room 1862', 'qpbDKEADPKNi');
insert into Driver (name, email, phone, address, password) values ('Cherey', 'crate7@fda.gov', '431-857-1770', '18th Floor', 'uzKgVjCOX0nE');
insert into Driver (name, email, phone, address, password) values ('Paolina', 'pleall8@flavors.me', '363-183-0649', 'Apt 580', 'YFZJ9BO');
insert into Driver (name, email, phone, address, password) values ('Rufe', 'rbaglin9@house.gov', '452-877-2585', 'Suite 68', '92MPD6');


-- Cab 
insert into Cab (type, registration_number, driver_id) values ('Crown Victoria', '1G4CU541134484254', 1);
insert into Cab (type, registration_number, driver_id) values ('Corvette', 'WBSBR93452P002475', 2);
insert into Cab (type, registration_number, driver_id) values ('Crown Victoria', '5J8TB4H39FL831485', 3);
insert into Cab (type, registration_number, driver_id) values ('Corvette', 'WBABN53431J000119', 4);
insert into Cab (type, registration_number, driver_id) values ('Corvette', '3FADP4AJ0FM439416', 5);
insert into Cab (type, registration_number, driver_id) values ('ES', '5J8TB18227A785789', 6);
insert into Cab (type, registration_number, driver_id) values ('Grand Marquis', 'WAUSH78E96A168603', 7);
insert into Cab (type, registration_number, driver_id) values ('Crown Victoria', 'WDDGF4HB4CF883487', 8);
insert into Cab (type, registration_number, driver_id) values ('DES', '3VW1K7AJ8BM985983', 9);
insert into Cab (type, registration_number, driver_id) values ('Corvette', '2T1BU4EE7DC659312', 10);

-- Admin
insert into Admin (name, email, password) values ('Grady', 'gsokill0@mtv.com', 'jzOMmjW');
insert into Admin (name, email, password) values ('Rosabella', 'rrugg1@walmart.com', 'Redm4IX');
insert into Admin (name, email, password) values ('Dolley', 'dgeorgelin2@facebook.com', 'qrYJWJWvHHF');
insert into Admin (name, email, password) values ('Binni', 'bharsnep3@lycos.com', 'w0OrKbDM93');
insert into Admin (name, email, password) values ('Early', 'evial4@ft.com', 'FHVyFbp8JBz');
insert into Admin (name, email, password) values ('Packston', 'pdybald5@discovery.com', 'ggPNCYpqrY');
insert into Admin (name, email, password) values ('Marylee', 'mwestley6@list-manage.com', 'cJ71WXIEKc');
insert into Admin (name, email, password) values ('Arie', 'aklugel7@ted.com', 'pQ5cinaKMPOg');
insert into Admin (name, email, password) values ('Nickolaus', 'nmichell8@domainmarket.com', 'FInYTViG');
insert into Admin (name, email, password) values ('Kelvin', 'kpillington9@discovery.com', 'G0L7695nHfDS');

-- Location
insert into Location (start_location, end_location, distance, fare) values ('Room 1908', 'Room 485', '26', '899');
insert into Location (start_location, end_location, distance, fare) values ('11th Floor', 'PO Box 34715', '23', '359');
insert into Location (start_location, end_location, distance, fare) values ('Room 734', 'Room 460', '30', '609');
insert into Location (start_location, end_location, distance, fare) values ('20th Floor', 'PO Box 42673', '75', '985');
insert into Location (start_location, end_location, distance, fare) values ('8th Floor', 'Room 1853', '22', '134');
insert into Location (start_location, end_location, distance, fare) values ('8th Floor', 'PO Box 97578', '42', '070');
insert into Location (start_location, end_location, distance, fare) values ('Room 1748', 'Apt 322', '24', '385');
insert into Location (start_location, end_location, distance, fare) values ('Suite 47', '16th Floor', '20', '714');
insert into Location (start_location, end_location, distance, fare) values ('Room 1387', 'Room 550', '89', '380');
insert into Location (start_location, end_location, distance, fare) values ('Suite 88', 'Room 1845', '19', '774');

insert into Location (start_location, end_location, distance, fare) values ('Room 485', 'Room 1908',  '26', '899');
insert into Location (start_location, end_location, distance, fare) values ('PO Box 34715', '11th Floor',  '23', '359');
insert into Location (start_location, end_location, distance, fare) values ('Room 460', 'Room 734',  '30', '609');
insert into Location (start_location, end_location, distance, fare) values ('PO Box 42673', '20th Floor',  '75', '985');
insert into Location (start_location, end_location, distance, fare) values ('Room 1853', '8th Floor',  '22', '134');
insert into Location (start_location, end_location, distance, fare) values ('PO Box 97578', '8th Floor', '42', '070');
insert into Location (start_location, end_location, distance, fare) values ('Apt 322', 'Room 1748',  '24', '385');
insert into Location (start_location, end_location, distance, fare) values ('16th Floor', 'Suite 47',  '20', '714');
insert into Location (start_location, end_location, distance, fare) values ('Room 550', 'Room 1387',  '89', '380');
insert into Location (start_location, end_location, distance, fare) values ('Room 1845', 'Suite 88',  '19', '774');
insert into Location (start_location, end_location, distance, fare) values ('PO Box 10099', 'Suite 56', '19', '899');
insert into Location (start_location, end_location, distance, fare) values ('Suite 5', 'Room 1908',  '26', '899');



-- Booking
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (1, 1, 'PO Box 10099', 'Suite 56', '899', '2023-01-25 10:22:38');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (2, 2, '11th Floor', 'PO Box 34715', '359', '2023-01-06 09:03:12');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (3, 3, '8th Floor', 'PO Box 97578', '609', '2023-01-02 03:24:30');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare,  booking_time) values (4, 4, 'Room 485', 'Room 1908','899', '2023-01-09 08:27:28');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (5, 5, '8th Floor', 'PO Box 97578','070', '2023-01-06 19:52:56');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (1, 1, 'Room 460', 'Room 734', '609', '2023-01-26 11:26:05');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (2, 2, 'PO Box 42673', '20th Floor','985', '2023-01-20 04:15:06');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (3, 3, 'Suite 88', 'Room 1845','774', '2023-01-17 22:48:07');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (4, 4, 'Room 1748', 'Apt 322', '385', '2023-01-30 09:35:06');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (5, 5, 'Room 1387', 'Room 550', '380', '2023-01-06 09:44:56');
insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (1, 1, 'Room 1748', 'Apt 322','385', '2023-01-06 15:08:08');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (2, 2, 'Suite 88', 'Room 1845', '774', '2023-01-15 16:29:04');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (3, 3, 'Room 485', 'Room 1908', '899', '2023-01-28 05:59:22');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (4, 4, 'Room 550', 'Room 1387', '380', '2023-01-11 09:33:05');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (5, 5, 'Room 1853', '8th Floor', '134', '2023-01-07 19:53:22');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (1, 1, 'Suite 47', '16th Floor', '714', '2023-01-16 11:25:16');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (2, 2, '16th Floor', 'Suite 47', '714', '2023-01-18 01:56:56');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (3, 3, 'Room 550', 'Room 1387', '380', '2023-01-05 00:04:58');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (4, 4, 'Room 1853', '8th Floor',  '134', '2023-01-30 09:22:58');
insert into Booking (customer_id, cab_id, pickup_location, destination,fare,  booking_time) values (5, 5, 'Room 1853', '8th Floor',  '134', '2023-01-26 11:38:54');

select * from booking join Cab where booking.Cab_id = Cab.cab_id order by booking_id;


-- Confirm
insert into Confirm (booking_id, driver_id, confirm_time) values (1, 1, '2023-01-06 19:55:56');
insert into Confirm (booking_id, driver_id, confirm_time) values (2, 2, '2023-01-26 11:28:05');
insert into Confirm (booking_id, driver_id, confirm_time) values (3, 3, '2023-01-20 04:20:06');
insert into Confirm (booking_id, driver_id, confirm_time) values (4, 4, '2023-01-17 22:50:07');
insert into Confirm (booking_id, driver_id, confirm_time) values (5, 5, '2023-01-30 09:37:06');
insert into Confirm (booking_id, driver_id, confirm_time) values (6, 1, '2023-01-06 09:48:56');
insert into Confirm (booking_id, driver_id, confirm_time) values (7, 2, '2023-01-06 15:12:08');
insert into Confirm (booking_id, driver_id, confirm_time) values (8, 3, '2023-01-15 16:30:04');
insert into Confirm (booking_id, driver_id, confirm_time) values (9, 4, '2023-01-28 05:59:50');
insert into Confirm (booking_id, driver_id, confirm_time) values (10, 5, '2023-01-11 09:39:05');
insert into Confirm (booking_id, driver_id, confirm_time) values (11, 1, '2023-01-07 19:55:22');
insert into Confirm (booking_id, driver_id, confirm_time) values (12, 2, '2023-01-16 11:30:16');
insert into Confirm (booking_id, driver_id, confirm_time) values (13, 3, '2023-01-18 01:57:56');
insert into Confirm (booking_id, driver_id, confirm_time) values (14, 4, '2023-01-05 00:20:58');
insert into Confirm (booking_id, driver_id, confirm_time) values (15, 5, '2023-01-30 10:22:58');


-- Payment
insert into Payment (booking_id, amount, payment_time) values (1, 899, '2023-01-06 20:55:56');
insert into Payment (booking_id, amount, payment_time) values (2, 359, '2023-01-26 11:59:05');
insert into Payment (booking_id, amount, payment_time) values (3, 609, '2023-01-20 05:20:06');
insert into Payment (booking_id, amount, payment_time) values (4, 899, '2023-01-17, 23:50:07');
insert into Payment (booking_id, amount, payment_time) values (5, 70, '2023-01-30 10:37:06');
insert into Payment (booking_id, amount, payment_time) values (6, 609, '2023-01-06 09:48:56');
insert into Payment (booking_id, amount, payment_time) values (7, 985, '2023-01-06 16:12:08');
insert into Payment (booking_id, amount, payment_time) values (8, 774, '2023-01-15 15:30:04' );
insert into Payment (booking_id, amount, payment_time) values (9, 385, '2023-01-28 06:59:50');
insert into Payment (booking_id, amount, payment_time) values (10, 380, '2023-01-11 10:39:05');
insert into Payment (booking_id, amount, payment_time) values (11, 385, '2023-01-07 20:55:22');
insert into Payment (booking_id, amount, payment_time) values (12, 774, '2023-01-16 12:30:16');
insert into Payment (booking_id, amount, payment_time) values (13, 899, '2023-01-18 02:57:56');
insert into Payment (booking_id, amount, payment_time) values (14, 380, '2023-01-18 02:57:56');
insert into Payment (booking_id, amount, payment_time) values (15, 134, '2023-01-30 10:22:58');

select * from booking;
select * from payment;

-- Review
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (1, 1, 1, '0.5', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (2, 2, 2, '3.0', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (3, 3, 3, '8.8', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (4, 4, 4, '1.9', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (5, 5, 5, '1.8', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (6, 1, 1, '6.7', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (7, 2, 2, '4.2', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (8, 3, 3, '9.3', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (9, 4, 4, '0.3', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (10, 5, 5, '4.0', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (11, 1, 1, '4.0', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (12, 2, 2, '8.2', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (13, 3, 3, '7.5', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (14, 4, 4, '8.3', 'good');
insert into Review (booking_id, driver_id, customer_id, rating, comment) values (15, 5, 5, '5.4', 'good');

insert into dri_current(driver_id, dri_loc) value (1,'Suite 5');
insert into dri_current(driver_id, dri_loc) value (2,'Suite 5');
insert into dri_current(driver_id, dri_loc) value (3,'Suite 5');
insert into dri_current(driver_id, dri_loc) value (4,'Suite 5');
insert into dri_current(driver_id, dri_loc) value (5,'Suite 5');
