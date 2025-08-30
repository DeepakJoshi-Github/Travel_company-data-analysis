SHOW DATABASES;
USE portfolioproject;
SHOW TABLES;
CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);

INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business)
VALUES ('b1','2022-03-23','u1','Flight'),
       ('b2','2022-03-27','u2','Flight'),
       ('b3','2022-03-28','u1','Hotel'),
       ('b4','2022-03-31','u4','Flight'),
       ('b5','2022-04-02','u1','Hotel'),
       ('b6','2022-04-02','u2','Flight'),
       ('b7','2022-04-06','u5','Flight'),
       ('b8','2022-04-06','u6','Hotel'),
       ('b9','2022-04-06','u2','Flight'),
       ('b10','2022-04-10','u1','Flight'),
       ('b11','2022-04-12','u4','Flight'),
       ('b12','2022-04-16','u1','Flight'),
       ('b13','2022-04-19','u2','Flight'),
       ('b14','2022-04-20','u5','Hotel'),
       ('b15','2022-04-22','u6','Flight'),
       ('b16','2022-04-26','u4','Hotel'),
       ('b17','2022-04-28','u2','Hotel'),
       ('b18','2022-04-30','u1','Hotel'),
       ('b19','2022-05-04','u4','Hotel'),
       ('b20','2022-05-06','u1','Flight');
       
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);

INSERT INTO user_table(User_id, Segment)
VALUES ('u1','s1'),
       ('u2','s1'),
       ('u3','s1'),
       ('u4','s2'),
       ('u5','s2'),
       ('u6','s3'),
       ('u7','s3'),
       ('u8','s3'),
       ('u9','s3'),
       ('u10','s3');
 
SELECT * FROM booking_table;
SELECT * FROM user_table;
 
 
# Q1: Write an SQL query that gives the below output.
# |Segments|Total_user_count|User_Who_booked_flight_in_apr2022|
# |s1      |3               |2                                |
# |s2      |2               |2                                |
# |s3      |5               |1                                |

SELECT u.segment,COUNT(DISTINCT u.User_id) AS Total_user_count, 
COUNT(DISTINCT CASE WHEN b.Line_of_business = 'Flight' AND b.Booking_date BETWEEN '2022-04-01' AND '2022-04-30' THEN b.User_id ELSE NULL END) AS User_Who_booked_flight_in_apr2022
FROM user_table u
LEFT JOIN booking_table b on u.User_id = b.User_id
GROUP BY u.Segment

# Q2: Write a query to identify users whose first booking was a hotel booking ?

-- Method 1

SELECT * FROM (
SELECT *,RANK() OVER (PARTITION BY User_id ORDER BY Booking_date ASC) AS RN
FROM booking_table) A
WHERE RN = 1 AND Line_of_business = 'Hotel'

-- Method 2

SELECT DISTINCT USER_ID FROM (
SELECT *,FIRST_VALUE(line_of_business) OVER (PARTITION BY User_id ORDER BY Booking_date ASC) AS First_booking
FROM booking_table) A
WHERE First_booking = 'Hotel'

# Q3: Write a query to calculate the days beetween the first and last booking of each user ?

SELECT USER_ID, MIN(Booking_date) as Min_date , MAX(Booking_date) AS MAX_DATE,
DATEDIFF(MAX(Booking_date), MIN(Booking_date)) AS NO_OF_DAYS
FROM booking_table
GROUP BY USER_ID

# Q4: Write a query to count the numbers of flight and hotel booking in each of the user segments for the year 2022 ?

SELECT u.segment,
SUM(CASE WHEN Line_of_business= 'Flight' THEN 1 ELSE 0 END) AS Flight_bookings, 
SUM(CASE WHEN Line_of_business = 'Hotel' THEN 1 ELSE 0 END) AS Hotel_bookings
FROM booking_table b
INNER JOIN user_table u ON b.User_id = u.User_id
GROUP BY u.segment
