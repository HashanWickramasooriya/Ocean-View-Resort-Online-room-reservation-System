<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.dao.DashboardDAO" %>
<%@ page import="com.oceanview.dao.DashboardDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>
<%@ page import="java.sql.Connection" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();
    DashboardDAO dashboardDAO = new DashboardDAOImpl(conn);


    int totalUsers = dashboardDAO.getTotalUsers();
    int totalRooms = dashboardDAO.getTotalRooms();
    int totalReservations = dashboardDAO.getTotalReservations();
    double monthlyRevenue = dashboardDAO.getMonthlyRevenue();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | Ocean View Resort</title>

<style>
body {
    font-family: Segoe UI, Arial;
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

.stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
}

.stat-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}

.stat-card h4 { color: #555; }
.stat-card p {
    font-size: 30px;
    font-weight: bold;
    color: #003366;
}


.quick-actions {
    margin-top: 35px;
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

.quick-actions a {
    padding: 14px 22px;
    background: #0059b3;
    color: white;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
}

.quick-actions a:hover {
    background: #003366;
}
</style>
</head>

<body>

<header>
    <h1>Ocean View Resort</h1>
    <p>Admin Dashboard</p>
</header>

<div class="layout">

<div class="sidebar">
    <a href="admindashboard.jsp">🏠 Dashboard</a>
    <a href="manageStaff.jsp">👨‍💼 Staff</a>
    <a href="manageRooms.jsp">🛏 Rooms</a>
    <a href="reservations.jsp">📋 Reservations</a>
    <a href="<%=request.getContextPath()%>/logout">🚪 Logout</a>
</div>

<div class="content">

    <h2>Welcome, <%= user.getFullName() %> 👋</h2>

   
    <div class="stats">
        <div class="stat-card">
            <h4>Total Active Users</h4>
            <p><%= totalUsers %></p>
        </div>

        <div class="stat-card">
            <h4>Total Rooms</h4>
            <p><%= totalRooms %></p>
        </div>

        <div class="stat-card">
            <h4>Total Reservations</h4>
            <p><%= totalReservations %></p>
        </div>

        <div class="stat-card">
            <h4>Monthly Revenue (LKR)</h4>
            <p><%= String.format("%,.2f", monthlyRevenue) %></p>
        </div>
    </div>

    
    <div class="quick-actions">
        <a href="addUser.jsp">➕ Add Staff</a>
        <a href="addRoom.jsp">➕ Add Room</a>
        <a href="reservations.jsp">📋 View Reservations</a>
        <a href="reports.jsp">📊 Generate Report</a>
    </div>

</div>
</div>

</body>
</html>
