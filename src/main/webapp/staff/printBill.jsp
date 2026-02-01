<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.dao.*,com.oceanview.database.DBConnection,com.oceanview.entity.*"%>
<%
String id = request.getParameter("id");
ReservationDAO resDAO = new ReservationDAOImpl(DBConnection.getConnection());
GuestDAO guestDAO = new GuestDAOImpl(DBConnection.getConnection());
RoomDAO roomDAO = new RoomDAOImpl(DBConnection.getConnection());

Reservation r = resDAO.getReservationById(id);
Guest g = guestDAO.getGuestById(r.getGuestId());
Room room = roomDAO.getRoomById(r.getRoomId());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill - <%= id %></title>
<style>
.bill{max-width:700px;margin:20px auto;background:#fff;padding:20px;border:1px solid #ddd;}
h2{text-align:center;}
.row{display:flex;justify-content:space-between;margin:6px 0;}
hr{margin:15px 0;}
button{padding:10px 14px;background:#0059b3;color:#fff;border:none;border-radius:6px;cursor:pointer;}
@media print { button{display:none;} }
</style>
</head>
<body>
<div class="bill">
<h2>Ocean View Resort - Bill</h2>
<div class="row"><span><b>Reservation ID:</b> <%= r.getReservationId() %></span><span><b>Date:</b> <%= r.getCreatedAt() %></span></div>
<hr>
<h3>Guest</h3>
<div class="row"><span>Name:</span><span><%= g.getGuestName() %></span></div>
<div class="row"><span>Contact:</span><span><%= g.getContactNumber() %></span></div>
<div class="row"><span>Email:</span><span><%= g.getEmail() == null ? "-" : g.getEmail() %></span></div>
<hr>
<h3>Room</h3>
<div class="row"><span>Room:</span><span><%= room.getRoomNumber() %> (<%= room.getRoomType() %>)</span></div>
<div class="row"><span>Rate/Night:</span><span>LKR <%= String.format("%,.2f", room.getRatePerNight()) %></span></div>
<hr>
<h3>Booking</h3>
<div class="row"><span>Check-in:</span><span><%= r.getCheckInDate() %></span></div>
<div class="row"><span>Check-out:</span><span><%= r.getCheckOutDate() %></span></div>
<div class="row"><span>Guests:</span><span><%= r.getNumberOfGuests() %></span></div>
<hr>
<div class="row"><span><b>Total Amount</b></span><span><b>LKR <%= String.format("%,.2f", r.getTotalAmount()) %></b></span></div>
<br>
<button onclick="window.print()">Print</button>
</div>
</body>
</html>
