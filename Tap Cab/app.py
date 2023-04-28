from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import mysql.connector
import time

connection = mysql.connector.connect(host='localhost',
                                     database='demo5',
                                     user='root',
                                     password='*********')
cursor = connection.cursor()

app = Flask(__name__)
app.secret_key = 'your secret key'

#Home Page
@app.route('/')
def home():
    return render_template('home.html')

# Admin Interface

@app.route('/admin')
def admin():
    return render_template('adminlogin.html')


@app.route('/admin_dashboard')
def admin_dashboard():
    return render_template('admin_dashboard.html')

@app.route('/adminlogin', methods=['GET', 'POST'])
def adminlogin():
    msg = ''
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        cursor.execute('SELECT * FROM Admin WHERE email = %s AND password = %s', (email, password, ))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['email'] = account[2]
            msg = 'Logged in successfully !'
            return redirect(url_for('admin_dashboard'))
        else:
            msg = 'Incorrect email / password !'
    return render_template('adminlogin.html', msg = msg)

@app.route('/registering_driver', methods=['GET', 'POST'])
def registering_driver():
    return render_template('driverregister.html')













# Drivr Interface
@app.route('/driver')
def driver():
    return render_template('driverlogin.html')


@app.route('/driver_dashboard')
def driver_dashboard():
    return render_template('driver_dashboard.html', name = session['Name'])

@app.route('/driverlogin', methods=['GET', 'POST'])
def driverlogin():
    msg = ''
    if request.method == 'POST':
        phone = request.form['phone']
        password = request.form['password']
        cursor.execute(
            'SELECT * FROM Driver WHERE phone = %s AND password = %s', (phone, password, ))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['driver_id'] = account[0]
            session['Name'] = account[1]
            session['email'] = account[2]
            session['phone'] = account[3]
            session['address'] = account[4]
            msg = 'Logged in successfully !'
            return render_template('driver_dashboard.html', name = session['Name'])
        else:
            msg = 'Incorrect email / password !'
    return render_template('driverlogin.html', msg = msg)

@app.route('/driver_logout')
def driver_logout():
    session.pop('loggedin', None)
    session.pop('driver_id', None)
    session.pop('Name', None)
    session.pop('email', None)
    session.pop('phone', None)
    session.pop('address', None)
    return redirect(url_for('home'))

@app.route('/Available_bookings', methods=['GET', 'POST'])
def Available_bookings():
    driver_id = session['driver_id']
    cursor.execute(
            """
SELECT * FROM Booking WHERE cab_id IN (SELECT cab_id FROM Cab WHERE driver_id = %s) AND status = 'BOOKED';
""",(driver_id, ))
    account = cursor.fetchall()
    return render_template('Available_bookings.html', data=account)

@app.route('/confirm_booking', methods=['GET', 'POST'])
def confirm_booking():
    if request.method == 'POST':
        booking_id = request.form['booking_id']
        session['booking_id'] = booking_id
        cursor.execute(
            """
            update Booking
set status = 'CONFIRMED'
where booking_id = %s""",
            (booking_id, ))
        connection.commit()
        cursor.execute(
            """
            update Cab
set cab_status = 'BOOKED'
where cab_id = (SELECT cab_id FROM Booking WHERE booking_id = %s)""",
            (booking_id, ))
        connection.commit()
        cursor.execute(
            """select * from Booking where booking_id = %s""", (session['booking_id'], ))
    account = cursor.fetchone()
    return render_template('currentride.html', booking_id=account[0], cust_id=account[1], pick_up_loc=account[3], dest_loc=account[4], fare=account[5])

@app.route('/current_ride', methods=['GET', 'POST'])
def current_ride():
    if request.method == 'POST':
        booking_id = request.form['booking_id']
        session['booking_id'] = booking_id
        cursor.execute(
            """
            update Booking
set status = 'COMPLETED'
where booking_id = %s""",
            (booking_id, ))
        connection.commit()
        cursor.execute(
            """
            update Cab
set cab_status = 'free'
where cab_id = (SELECT cab_id FROM Booking WHERE booking_id = %s)""",
            (booking_id, ))
        connection.commit()
        return render_template('driver_dashboard.html')

@app.route('/driver_register', methods=['GET', 'POST'])
def driver_register():
    msg = ''
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        address = request.form['address']
        password = request.form['password']
        cursor.execute(
            'SELECT * FROM Driver WHERE email = %s', (email, ))
        account = cursor.fetchone()
        if account:
            msg = 'Account already exists !'
            return render_template('driverregister.html', msg=msg)
        else:
            cursor.execute(
                'insert into Driver (name, email, phone, address, password) VALUES (%s, %s, %s, %s, %s)', (name, email, phone, address, password, ))
            connection.commit()
            msg = 'You have successfully registered !'
            return render_template('driverlogin.html', msg=msg)
    return render_template('driverlogin.html', msg=msg)

@app.route('/booking_history')
def booking_history():
    driver_id = session['driver_id']
    cursor.execute(
            """
           SELECT Booking.*, Payment.payment_status
FROM Booking
JOIN Payment ON Booking.booking_id = Payment.booking_id
WHERE Booking.cab_id IN (SELECT cab_id FROM Cab WHERE driver_id = %s) and Booking.status = 'PAYMENT DONE';
            """, (driver_id, ))
    account = cursor.fetchall()
    return render_template('booking_history.html', data=account)

@app.route('/Add_Payment')
def Add_Payment():
    driver_id = session['driver_id']
    cursor.execute(
        """
            select * from booking where cab_id in (select cab_id from cab where driver_id = %s) and status='CONFIRMED';
            """, (driver_id, ))
    account = cursor.fetchall()
    return render_template('Add_Payment.html', data=account)

@app.route('/Payment_Added', methods=['GET', 'POST'])
def Payment_Added():
    if request.method == 'POST':
        booking_id = request.form['booking_id']
        amount = request.form['amount']
        cursor.execute(
            """
            insert into Payment (booking_id, amount, payment_time) values (%s, %s,%s);
            """, (booking_id, amount, time.strftime('%Y-%m-%d %H:%M:%S'),))
        cursor.execute(
            """
            update Booking
            set status = 'PAYMENT PENDING' where booking_id = %s""",
            (booking_id, ))
        connection.commit()
        return render_template('driver_dashboard.html')








# Customer Interface
@app.route('/customer')
def customer():
    return render_template('customerlogin.html')

@app.route('/registering_customer')
def registering_customer():
    return render_template('customerregister.html')


@app.route('/customer_register', methods=['GET', 'POST'])
def customer_register():
    msg = ''
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        address = request.form['address']
        password = request.form['password']
        cursor.execute(
            'SELECT * FROM Customer WHERE email = %s', (email, ))
        account = cursor.fetchone()
        if account:
            msg = 'Account already exists !'
            return render_template('customerregister.html', msg=msg)
        else:
            cursor.execute(
                'insert into Customer (name, email, phone, address, password) VALUES (%s, %s, %s, %s, %s)', (name, email, phone, address, password, ))
            connection.commit()
            msg = 'You have successfully registered !'
            return render_template('customerlogin.html', msg=msg)
    return render_template('customerlogin.html', msg=msg)


@app.route('/customer_dashboard')
def customer_dashboard():
    cursor.execute(
        'SELECT * FROM Customer WHERE phone = %s', (session['phone'], ))
    account = cursor.fetchone()
    name = account[1]
    return render_template('customer_dashboard.html', name=name)


@app.route('/customerlogin', methods=['GET', 'POST'])
def customerlogin():
    msg = ''
    if request.method == 'POST':
        phone = request.form['phone']
        password = request.form['password']
        cursor.execute(
            'SELECT * FROM Customer WHERE phone = %s AND password = %s', (phone, password, ))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['customer_id'] = account[0]
            session['Name'] = account[1]
            session['email'] = account[2]
            session['phone'] = account[3]
            session['profile'] = account[4]
            name = session['Name']
            msg = 'Logged in successfully !'
            return render_template('customer_dashboard.html', name=name)
        else:
            msg = 'Incorrect email / password !'
    return render_template('customerlogin.html', msg=msg)

@app.route('/customerlogout')
def customerlogout():
    session.pop('loggedin', None)
    session.pop('customer_id', None)
    session.pop('Name', None)
    session.pop('email', None)
    session.pop('phone', None)
    session.pop('profile', None)
    return redirect(url_for('home'))

@app.route('/avaialable_cabs', methods=['GET', 'POST'])
def avaialable_cabs():
    msg = ''
    if request.method == 'POST':
        pick_up_loc = request.form['pick_up_loc']
        dest_loc = request.form['dest_loc']
        session['pick_up_loc'] = pick_up_loc
        session['dest_loc'] = dest_loc
        cursor.execute(
            """
            SELECT Driver.*, Cab.*
FROM dri_current
JOIN Driver ON dri_current.driver_id = Driver.driver_id
JOIN Cab ON Cab.driver_id = Driver.driver_id
WHERE dri_current.dri_loc = %s
AND Cab.cab_status = 'free'
            """, (pick_up_loc, ))
        account = cursor.fetchall()
        cursor.execute(
            """
            SELECT fare FROM Location WHERE start_location=%s AND end_location=%s
            """, (pick_up_loc, dest_loc, ))
        fare = cursor.fetchone()
        amt = fare[0]
        session['fare'] = amt
        if account:
            session['loggedin'] = True
            session['Name'] = account[3]
            msg = 'Logged in successfully !'
            return render_template('Available_cabs.html', data=account, pick_up_loc=pick_up_loc, dest_loc=dest_loc, fare=amt)
        
@app.route('/book_cab', methods=['GET', 'POST'])
def book_cab():
    msg = ''
    if request.method == 'POST':
        cab_id = request.form['cab_id']
        cust_id = session['customer_id']
        pick_up_loc = session['pick_up_loc']
        dest_loc = session['dest_loc']
        fare = session['fare']
        cursor.execute(
            """
            insert into Booking (customer_id, cab_id, pickup_location, destination, fare, booking_time) values (%s, %s, %s, %s, %s, %s)
            """, (cust_id, cab_id, pick_up_loc, dest_loc, fare, time.strftime('%Y-%m-%d %H:%M:%S')))
        connection.commit()
        cursor.execute(
            """
            select * from Cab where cab_id=%s
            """, (cab_id, ))
        cab_info = cursor.fetchone()
        session['cab_id'] = cab_info[0]
        session['cab_type'] = cab_info[1]
        session['cab_number'] = cab_info[2]
        session['cab_status'] = cab_info[3]
        session['driver_id'] = cab_info[4]
        cursor.execute(
            """
            select * from Driver where driver_id=%s
            """, (session['driver_id'], ))
        driver_info = cursor.fetchone()
        session['driver_name'] = driver_info[1]
        session['driver_phone'] = driver_info[3]
    return render_template('Booking.html', pick_up_loc=pick_up_loc, dest_loc=dest_loc, fare=fare, cab_id=cab_id, cust_id=cust_id,cab_type = session['cab_type'],  driver_name=session['driver_name'], driver_phone=session['driver_phone'], cab_number=session['cab_number'])

@app.route('/your_booking')
def your_booking():
    cursor.execute(
        """
        SELECT Driver.name AS driver_name, Driver.phone AS driver_phone, Cab.cab_id, Cab.type AS cab_type, 
Cab.registration_number, Booking.booking_id, Booking.pickup_location, Booking.destination, Booking.fare, 
Booking.status, Booking.booking_time
FROM Booking
JOIN Cab ON Booking.cab_id = Cab.cab_id
JOIN Driver ON Cab.driver_id = Driver.driver_id
WHERE Booking.customer_id = %s
ORDER BY Booking.booking_id DESC;
"""
    , (session['customer_id'], ))
    booking_info = cursor.fetchall()
    return render_template('yourbookings.html', data=booking_info)

@app.route('/Payment_option', methods=['GET', 'POST'])
def Payment_option():
    return render_template('Payment_option.html')

@app.route('/Payment_done', methods=['GET', 'POST'])
def Payment_done():
    if request.method == 'POST':
        booking_id = request.form['booking_id']
        amount = request.form['amount']
        cursor.execute(
            """
            update Booking
            set status = 'PAYMENT DONE' where booking_id = %s""",
            (booking_id, ))
        cursor.execute(
            """
            update Payment
            set payment_status = 'PAYMENT DONE' where booking_id = %s""",
            (booking_id, ))
        connection.commit()
        return render_template('customer_dashboard.html')
    

@app.route('/Review')
def Review():
    cursor.execute(
        """
        SELECT Driver.name AS ddriver_name, Driver.driver_id AS driver_id, Driver.phone AS driver_phone, Cab.cab_id, Cab.type AS cab_type, 
Cab.registration_number, Booking.booking_id, Booking.pickup_location, Booking.destination, Booking.fare, 
Booking.status, Booking.booking_time
FROM Booking
JOIN Cab ON Booking.cab_id = Cab.cab_id
JOIN Driver ON Cab.driver_id = Driver.driver_id
WHERE Booking.customer_id = %s and Booking.status = 'COMPLETED'
ORDER BY Booking.booking_id DESC;
""", (session['customer_id'], ))
    account = cursor.fetchall()
    return render_template('Review.html', data = account)


@app.route('/Review_done', methods=['GET', 'POST'])
def Review_done():
    if request.method == 'POST':
        booking_id = request.form['booking_id']
        driver_id = request.form['driver_id']
        rating = request.form['rating']
        comment = request.form['comment']
        cursor.execute(
            """
            insert into Review (booking_id, driver_id, rating, comment) values (%s, %s, %s, %s)
            """, (booking_id, driver_id, rating, comment))
        connection.commit()
        return render_template('customer_dashboard.html')





if (__name__ == '__main__'):
    app.run(debug=True)
