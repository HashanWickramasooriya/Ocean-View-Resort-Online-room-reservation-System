<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.entity.ReservationDetails" %>
<%@ page import="com.oceanview.dao.ReservationDAO" %>
<%@ page import="com.oceanview.dao.ReservationDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    User staff = (User) session.getAttribute("user");
    if (staff == null || !"STAFF".equals(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("manageReservations.jsp");
        return;
    }

    String error = request.getParameter("error");

    ReservationDetails r = null;
    try(Connection conn = DBConnection.getConnection()){
        ReservationDAO dao = new ReservationDAOImpl(conn);
        r = dao.getReservationDetailsById(id);
    } catch(Exception e){ e.printStackTrace(); }

    if (r == null) {
        response.sendRedirect("manageReservations.jsp?error=Reservation not found");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Reservation</title>
<style>
body{font-family:Arial;background:#f2f5f9;padding:20px;}
.container{max-width:650px;margin:auto;background:white;padding:20px;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.12);}
label{font-weight:bold;display:block;margin-top:12px;}
input,select,textarea{width:100%;padding:10px;margin-top:6px;border:1px solid #ccc;border-radius:6px;}
button{margin-top:18px;padding:12px;width:100%;background:#0059b3;color:white;border:none;border-radius:8px;font-weight:bold;cursor:pointer;}
button:hover{background:#003366;}
.alert{padding:10px;border-radius:8px;margin:10px 0;font-weight:bold;}
.error{background:#fdecea;color:#c62828;}
.small{color:#64748b;font-size:13px;}
.back{display:block;text-align:center;margin-top:14px;text-decoration:none;color:#0059b3;font-weight:bold;}
</style>
</head>
<body>

<div class="container">
    <h2>Edit Reservation: <%= r.getReservationId() %></h2>

    <% if(error != null){ %>
        <div class="alert error"><%= error %></div>
    <% } %>

    <p class="small">
        Guest: <b><%= r.getGuestName() %></b> | Room: <b><%= r.getRoomNumber() %></b> (<%= r.getRoomType() %>)<br>
        Rate per night: LKR <%= String.format("%,.2f", r.getRatePerNight()) %>
    </p>

    <form action="<%=request.getContextPath()%>/staff/update-reservation" method="post">

        <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">

        <label>Check-in Date</label>
        <input type="date" name="checkIn" value="<%= r.getCheckInDate() %>" required>

        <label>Check-out Date</label>
        <input type="date" name="checkOut" value="<%= r.getCheckOutDate() %>" required>

        <label>Guests</label>
        <input type="number" name="guests" min="1" value="<%= r.getNumberOfGuests() %>" required>

        <label>Special Requests</label>
        <textarea name="specialRequests" rows="3"><%= r.getSpecialRequests()==null?"":r.getSpecialRequests() %></textarea>

        <label>Status</label>
        <select name="status">
            <option value="CONFIRMED" <%= "CONFIRMED".equals(r.getStatus()) ? "selected" : "" %>>CONFIRMED</option>
            <option value="PENDING" <%= "PENDING".equals(r.getStatus()) ? "selected" : "" %>>PENDING</option>
            <option value="CHECKED_IN" <%= "CHECKED_IN".equals(r.getStatus()) ? "selected" : "" %>>CHECKED_IN</option>
            <option value="CHECKED_OUT" <%= "CHECKED_OUT".equals(r.getStatus()) ? "selected" : "" %>>CHECKED_OUT</option>
            <option value="CANCELLED" <%= "CANCELLED".equals(r.getStatus()) ? "selected" : "" %>>CANCELLED</option>
        </select>

        <button type="submit">Update Reservation</button>
    </form>

    <a class="back" href="manageReservations.jsp">← Back to Manage Reservations</a>
</div>

</body>
</html>
