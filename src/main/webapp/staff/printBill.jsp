<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

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
        out.print("Invalid reservation");
        return;
    }

    ReservationDetails r = null;
    try(Connection conn = DBConnection.getConnection()){
        ReservationDAO dao = new ReservationDAOImpl(conn);
        r = dao.getReservationDetailsById(id);
    } catch(Exception e){ e.printStackTrace(); }

    if (r == null) {
        out.print("Reservation not found");
        return;
    }

    LocalDate in = LocalDate.parse(r.getCheckInDate().toString());
    LocalDate outD = LocalDate.parse(r.getCheckOutDate().toString());
    long nights = ChronoUnit.DAYS.between(in, outD);
    if(nights <= 0) nights = 1;

    // simple breakdown (optional)
    double roomBase = r.getRatePerNight() * nights;
    double total = r.getTotalAmount();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Print Bill - <%= r.getReservationId() %></title>
<style>
body{font-family:Arial;background:#f4f6f8;padding:20px;}
.bill{max-width:750px;margin:auto;background:white;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.12);padding:20px;}
.header{display:flex;justify-content:space-between;align-items:center;border-bottom:2px solid #e5e7eb;padding-bottom:10px;margin-bottom:15px;}
h2{margin:0;color:#003366;}
.small{color:#64748b;font-size:13px;}
table{width:100%;border-collapse:collapse;margin-top:12px;}
th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left;}
th{background:#003366;color:white;}
.total{font-size:18px;font-weight:bold;text-align:right;padding-top:10px;}
.btns{margin:15px 0;text-align:right;}
button{padding:10px 14px;border:none;border-radius:6px;background:#0059b3;color:white;font-weight:bold;cursor:pointer;}
button:hover{background:#003366;}
@media print{
  .btns{display:none;}
  body{background:white;}
  .bill{box-shadow:none;}
}
</style>
</head>
<body>

<div class="bill">
    <div class="btns">
        <button onclick="window.print()">🖨 Print</button>
    </div>

    <div class="header">
        <div>
            <h2>Ocean View Resort</h2>
            <div class="small">Official Booking Bill</div>
        </div>
        <div class="small" style="text-align:right;">
            Bill No: <b>BILL-<%= r.getReservationId() %></b><br>
            Date: <%= java.time.LocalDate.now() %>
        </div>
    </div>

    <div class="small">
        <b>Reservation:</b> <%= r.getReservationId() %><br>
        <b>Guest:</b> <%= r.getGuestName() %> (<%= r.getGuestContact() %>)<br>
        <b>Email:</b> <%= r.getGuestEmail()==null?"-":r.getGuestEmail() %><br>
        <b>Room:</b> <%= r.getRoomNumber() %> (<%= r.getRoomType() %>)<br>
        <b>Check-in:</b> <%= r.getCheckInDate() %> &nbsp; | &nbsp;
        <b>Check-out:</b> <%= r.getCheckOutDate() %> &nbsp; | &nbsp;
        <b>Nights:</b> <%= nights %><br>
        <b>Status:</b> <%= r.getStatus() %>
    </div>

    <table>
        <tr>
            <th>Description</th>
            <th>Qty</th>
            <th>Amount (LKR)</th>
        </tr>
        <tr>
            <td>Room Charges (Rate x Nights)</td>
            <td><%= nights %></td>
            <td><%= String.format("%,.2f", roomBase) %></td>
        </tr>
        <tr>
            <td>Guests</td>
            <td><%= r.getNumberOfGuests() %></td>
            <td>-</td>
        </tr>
        <tr>
            <td>Special Requests</td>
            <td>-</td>
            <td><%= (r.getSpecialRequests()==null || r.getSpecialRequests().isEmpty()) ? "-" : r.getSpecialRequests() %></td>
        </tr>
    </table>

    <div class="total">
        Total: LKR <%= String.format("%,.2f", total) %>
    </div>

    <p class="small" style="margin-top:12px;">
        Thank you for choosing Ocean View Resort.
    </p>
</div>

</body>
</html>
