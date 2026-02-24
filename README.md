#  Ocean View Resort – Online Room Reservation System

This repository contains the **Ocean View Resort – Online Room Reservation System**, a Java EE web-based hotel management application designed to manage room bookings, guest records, staff operations, and administrative tasks efficiently.

The system provides secure role-based access for **Admin** and **Staff** users and supports full reservation lifecycle management.

---

##  Technologies Used

| Technology        | Purpose |
|------------------|----------|
| Java (JDK 8+)     | Backend development |
| Java Servlets     | MVC web architecture |
| JSP               | Dynamic web pages |
| JDBC              | Database connectivity |
| MySQL             | Relational database |
| Apache Tomcat 9+  | Web application server |
| BCrypt            | Secure password hashing |
| JavaMail API      | Email notifications |
| Gson              | JSON handling for AJAX |
| Bootstrap         | Responsive UI design |
| HTML5 / CSS3      | Frontend development |

---

##  Key Features

### Admin Panel
-  Add / Update / Delete Staff Users
-  Add / Update / Delete Rooms
-  Upload Multiple Room Images
-  View All Reservations
-  Advanced Reservation Filtering
-  Dashboard Overview:
  - Total Users
  - Total Rooms
  - Total Reservations
  - Monthly Revenue

---

###  Staff Panel
-  2-Step Reservation Creation
-  Update Reservations
-  Cancel Reservations
-  Guest Check-in
-  Guest Check-out
-  View Room Availability
-  View Booked Dates (AJAX Calendar)
-  Staff Dashboard:
  - Today’s Check-ins
  - Today’s Check-outs
  - Available Rooms
  - Pending Reservations
  - Today’s Schedule

---



##  Security Features

- BCrypt password hashing
- Role-based authentication (ADMIN / STAFF)
- Session-based access control
- Secure reservation validation
- Transaction handling with rollback support
- Room availability double-check before booking

---

##  Email Notification System

When a reservation is confirmed:

-  Guest receives a professional HTML confirmation email
- Includes:
  - Reservation ID
  - Room details
  - Check-in & Check-out dates
  - Number of guests
  - Total amount (including tax)

---

##  Billing System

The system automatically calculates:

- Room rate × number of nights
- Extra guest fee
- 10% Tax

---

