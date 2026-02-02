<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
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

    String successMsg = (String) session.getAttribute("successMsg");
    session.removeAttribute("successMsg");

    String error = request.getParameter("error");

    List<ReservationDetails> list = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection()){
        ReservationDAO dao = new ReservationDAOImpl(conn);
        list = dao.getAllReservationDetails();
    } catch(Exception e){ e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Reservations</title>
<style>
body{font-family:Arial;background:#f2f5f9;margin:0;padding:20px;}
.container{max-width:1100px;margin:auto;background:white;padding:20px;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.12);}
h2{color:#003366;margin-top:0;}
table{width:100%;border-collapse:collapse;margin-top:15px;}
th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left;vertical-align:top;}
th{background:#003366;color:white;}
.badge{padding:4px 10px;border-radius:20px;font-size:12px;font-weight:bold;display:inline-block;}
.CONFIRMED{background:#DBEAFE;color:#1E40AF;}
.PENDING{background:#FEF3C7;color:#92400E;}
.CANCELLED{background:#FEE2E2;color:#991B1B;}
.CHECKED_IN{background:#D1FAE5;color:#065F46;}
.CHECKED_OUT{background:#E5E7EB;color:#374151;}
.actions a{margin-right:8px;text-decoration:none;font-weight:bold;}
.edit{color:#0059b3;}
.cancel{color:red;}
.print{color:#0b8b8a;}
.alert{padding:10px;border-radius:8px;margin:10px 0;font-weight:bold;}
.success{background:#e6ffed;color:#2e7d32;}
.error{background:#fdecea;color:#c62828;}
</style>
</head>
<body>

<div class="container">
    <h2>Manage Reservations</h2>

    <% if(successMsg != null){ %>
        <div class="alert success"><%= successMsg %></div>
    <% } %>

    <% if(error != null){ %>
        <div class="alert error"><%= error %></div>
    <% } %>

    <table>
        <tr>
            <th>Reservation</th>
            <th>Guest</th>
            <th>Room</th>
            <th>Dates</th>
            <th>Status</th>
            <th>Total (LKR)</th>
            <th>Actions</th>
        </tr>

        <% for(ReservationDetails r : list){ %>
        <tr>
            <td><b><%= r.getReservationId() %></b><br>
                <small><%= r.getCreatedAt() %></small>
            </td>
            <td>
                <b><%= r.getGuestName() %></b><br>
                <small><%= r.getGuestContact() %></small><br>
                <small><%= r.getGuestEmail() == null ? "-" : r.getGuestEmail() %></small>
            </td>
            <td>
                <b><%= r.getRoomNumber() %></b><br>
                <small><%= r.getRoomType() %></small>
            </td>
            <td>
                <small>IN: <%= r.getCheckInDate() %></small><br>
                <small>OUT: <%= r.getCheckOutDate() %></small><br>
                <small>Guests: <%= r.getNumberOfGuests() %></small>
            </td>
            <td>
                <span class="badge <%= r.getStatus() %>"><%= r.getStatus() %></span>
            </td>
            <td><%= String.format("%,.2f", r.getTotalAmount()) %></td>
            <td class="actions">
                <a class="print" target="_blank"
                   href="<%=request.getContextPath()%>/staff/printBill.jsp?id=<%= r.getReservationId() %>">🧾 Print</a>

                <a class="edit"
                   href="<%=request.getContextPath()%>/staff/editReservation.jsp?id=<%= r.getReservationId() %>">✏ Edit</a>

                <% if(!"CANCELLED".equals(r.getStatus())){ %>
                    <a class="cancel"
                       href="<%=request.getContextPath()%>/staff/cancel-reservation?id=<%= r.getReservationId() %>"
                       onclick="return confirm('Cancel this reservation?')">❌ Cancel</a>
                <% } %>
            </td>
        </tr>
        <% } %>

    </table>
</div>

</body>
</html>
