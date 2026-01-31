<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User" %>
<%
User user = (User) session.getAttribute("user");

if (user == null || !"STAFF".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff Dashboard | Ocean View Resort</title>

<style>
body {
    font-family: 'Segoe UI', Arial;
    background: #f2f5f9;
    margin: 0;
}

header {
    background: linear-gradient(90deg, #003366, #0059b3);
    color: white;
    padding: 20px;
    text-align: center;
}

.layout { display: flex; }

.sidebar {
    width: 220px;
    background: #1e1e2f;
    min-height: 100vh;
}

.sidebar a {
    display: block;
    padding: 12px 18px;
    color: #ccc;
    text-decoration: none;
}

.sidebar a:hover {
    background: #343454;
    color: white;
}

.content {
    flex: 1;
    padding: 25px;
}

.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    text-align: center;
}

.card h3 {
    color: #003366;
    margin-bottom: 10px;
}

.card a {
    display: inline-block;
    margin-top: 10px;
    padding: 10px 15px;
    background: #0059b3;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}

.card a:hover { background: #003366; }
</style>
</head>

<body>

<header>
    <h1>Ocean View Resort</h1>
    <p>Staff Dashboard</p>
</header>

<div class="layout">

<div class="sidebar">
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="addReservation.jsp">➕ Add Reservation</a>
    <a href="reservations.jsp">📋 All Reservations</a>
    <a href="checkAvailability.jsp">🛏 Check Room Availability</a>
    <a href="help.jsp">❓ Help</a>
    <a href="<%=request.getContextPath()%>/logout">🚪 Logout</a>
</div>

<div class="content">
    <h2>Welcome, <%= user.getFullName() %> 👋</h2>

    <div class="card-grid">

        <div class="card">
            <h3>Add Reservation</h3>
            <p>Create a new room booking</p>
            <a href="addReservation.jsp">Open</a>
        </div>

        <div class="card">
            <h3>View Reservations</h3>
            <p>See all bookings</p>
            <a href="reservations.jsp">Open</a>
        </div>

        <div class="card">
            <h3>Check Availability</h3>
            <p>Find free rooms</p>
            <a href="checkAvailability.jsp">Open</a>
        </div>

        <div class="card">
            <h3>Help Guide</h3>
            <p>System usage instructions</p>
            <a href="help.jsp">Open</a>
        </div>

    </div>
</div>

</div>

</body>
</html>
