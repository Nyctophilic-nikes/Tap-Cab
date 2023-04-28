-- Query 1
SELECT c.name AS customer_name, 
       d.name AS driver_name, 
       b.booking_time, 
       t.start_time, 
       r.rating, 
       r.comment
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Confirm cf ON b.booking_id = cf.booking_id
JOIN Driver d ON cf.driver_id = d.driver_id
JOIN Cab cb ON b.cab_id = cb.cab_id
JOIN Trip t ON b.booking_id = t.booking_id AND d.driver_id = t.driver_id
JOIN Review r ON b.booking_id = r.booking_id AND d.driver_id = r.driver_id AND c.customer_id = r.customer_id
WHERE b.booking_time BETWEEN '2023-01-01 00:00:00' AND '2023-03-29 23:30:00'
  AND t.distance > 10
  AND r.rating >= 4
  AND d.rating >= (
        SELECT AVG(rating) 
        FROM Driver 
        WHERE rating > 0
    )
ORDER BY t.start_time DESC;

-- Query 2
SELECT c.name AS customer_name, d.name AS driver_name, b.pickup_location, b.destination, b.fare,
CASE
  WHEN b.status = 'CANCELLED' THEN 'Cancelled'
  WHEN b.status = 'BOOKED' AND b.confirm_time IS NULL THEN 'Pending'
  WHEN b.status = 'BOOKED' AND b.confirm_time IS NOT NULL THEN 'Confirmed'
  WHEN t.trip_id IS NOT NULL AND r.rating IS NULL THEN 'Completed - Pending Review'
  WHEN t.trip_id IS NOT NULL AND r.rating IS NOT NULL THEN 'Completed - Reviewed'
  ELSE 'Unknown'
END AS booking_status
FROM Booking b
INNER JOIN Customer c ON b.customer_id = c.customer_id
LEFT JOIN Confirm cf ON b.booking_id = cf.booking_id
LEFT JOIN Driver d ON cf.driver_id = d.driver_id
LEFT JOIN Trip t ON b.booking_id = t.booking_id
LEFT JOIN Review r ON b.booking_id = r.booking_id
WHERE b.booking_time BETWEEN '2023-01-01' AND '2023-03-29'
AND b.status != 'CANCELLED'
ORDER BY b.booking_time DESC;


-- OLAP queries
-- Query 1
SELECT 
    YEAR(Booking.booking_time) AS Year,
    Cab.type AS CabType,
    SUM(Payment.amount) AS TotalRevenue
FROM 
    Booking 
    JOIN Cab ON Booking.cab_id = Cab.cab_id 
    JOIN Payment ON Booking.booking_id = Payment.booking_id 
WHERE 
    YEAR(Booking.booking_time) = 2023
GROUP BY 
    YEAR(Booking.booking_time), 
    Cab.type WITH ROLLUP;
    
-- Query 2
SELECT 
    Cab.type AS CabType, 
    YEAR(Booking.booking_time) AS Year, 
    QUARTER(Booking.booking_time) AS Quarter, 
    SUM(Payment.amount) AS TotalRevenue,
    AVG(SUM(Payment.amount)) OVER (PARTITION BY Cab.type, YEAR(Booking.booking_time) ORDER BY QUARTER(Booking.booking_time) ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) AS SixMonthMovingAverage,
    RANK() OVER (PARTITION BY Cab.type, YEAR(Booking.booking_time) ORDER BY SUM(Payment.amount) DESC) AS Ranking
FROM 
    Booking 
    JOIN Cab ON Booking.cab_id = Cab.cab_id 
    JOIN Payment ON Booking.booking_id = Payment.booking_id 
GROUP BY 
    Cab.type, 
    YEAR(Booking.booking_time), 
    QUARTER(Booking.booking_time);
    
  -- Query 3
  SELECT 
    Cab.type AS CabType, 
    MONTH(Payment.payment_time) AS Month, 
    COUNT(DISTINCT Booking.customer_id) AS UniqueCustomers,
    SUM(Payment.amount) AS TotalRevenue
FROM 
    Booking 
    JOIN Cab ON Booking.cab_id = Cab.cab_id 
    JOIN Payment ON Booking.booking_id = Payment.booking_id 
WHERE 
    YEAR(Payment.payment_time) = 2023
GROUP BY 
    Cab.type, 
    MONTH(Payment.payment_time);
    
  --Query 4
  SELECT 
    Driver.driver_id AS DriverId, 
    Driver.name AS DriverName,
    YEAR(Booking.booking_time) AS Year, 
    SUM(Booking.fare) AS Fare
FROM 
    Booking 
    JOIN Cab ON Booking.cab_id = Cab.cab_id 
    JOIN Driver ON Cab.driver_id = Driver.driver_id
GROUP BY 
    Driver.driver_id,
    Driver.name,
    YEAR(Booking.booking_time)
    WITH ROLLUP
HAVING 
    DriverId IS NOT NULL 
    AND Year IS NOT NULL;
    
  -- Query 5
  SELECT 
    Customer.customer_id AS CustomerId, 
    Customer.name AS CustomerName,
    Driver.driver_id AS DriverId, 
    Driver.name AS DriverName,
    YEAR(Booking.booking_time) AS Year, 
    COUNT(*) AS Bookings
FROM 
    Booking 
    JOIN Cab ON Booking.cab_id = Cab.cab_id 
    JOIN Driver ON Cab.driver_id = Driver.driver_id 
    JOIN Customer ON Booking.customer_id = Customer.customer_id 
GROUP BY 
    Customer.customer_id,
    Customer.name,
    Driver.driver_id,
    Driver.name,
    YEAR(Booking.booking_time)
    WITH ROLLUP
HAVING 
    CustomerId IS NOT NULL 
    AND DriverId IS NOT NULL 
    AND Year IS NOT NULL;
