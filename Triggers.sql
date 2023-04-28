DELIMITER $$
CREATE TRIGGER fill_trip_table
AFTER update ON Booking
FOR EACH ROW
BEGIN
    IF NEW.status = 'CONFIRMED' THEN
        SET @distance_value := (SELECT distance FROM Location WHERE start_location = NEW.pickup_location AND end_location = NEW.destination);
        SET @fare_value := (SELECT fare FROM Location WHERE start_location = NEW.pickup_location AND end_location = NEW.destination);
        INSERT INTO Trip (booking_id, driver_id, start_time, distance, fare)
        VALUES (NEW.booking_id, (SELECT driver_id FROM Confirm WHERE booking_id = NEW.booking_id), NOW(), @distance_value, @fare_value);
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_driver_rating
AFTER INSERT ON Review
FOR EACH ROW
BEGIN
    UPDATE Driver
    SET rating = (SELECT AVG(rating) FROM Review WHERE driver_id = NEW.driver_id)
    WHERE driver_id = NEW.driver_id;
END$$
DELIMITER ;



