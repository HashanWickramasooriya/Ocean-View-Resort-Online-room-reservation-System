<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.dao.UserDAO" %>
<%@ page import="com.oceanview.dao.UserDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    // ---------------- ADMIN AUTH CHECK ----------------
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ---------------- LOAD USERS ----------------
    UserDAO userDAO = new UserDAOImpl(DBConnection.getConnection());
    List<User> users = userDAO.getAllUsers();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Staff | Ocean View Resort</title>

<style>
body { font-family: Arial; background:#f2f5f9; }
.container { padding: 30px; }

table {
    width: 100%;
    border-collapse: collapse;
    background: white;
}
th, td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    text-align: left;
    vertical-align: middle;
}
th { background: #003366; color: white; }

.actions a {
    margin-right: 10px;
    text-decoration: none;
    font-weight: bold;
}
.edit { color: #0059b3; }
.delete { color: red; }

.add-btn {
    display: inline-block;
    margin-bottom: 15px;
    padding: 10px 15px;
    background: #0059b3;
    color: white;
    border-radius: 6px;
    text-decoration: none;
}
</style>
</head>

<body>

<div class="container">
<h2>Manage Staff</h2>

<a href="addUser.jsp" class="add-btn">➕ Add New Staff</a>

<table>
<tr>
    <th>ID</th>
    <th>Username</th>
    <th>Full Name</th>
    <th>Email</th>
    <th>Phone</th>
    <th>Role</th>
    <th>Status</th>
    <th>Actions</th>
</tr>

<% for (User u : users) { %>
<tr>
    <td><%= u.getUserId() %></td>
    <td><%= u.getUsername() %></td>
    <td><%= u.getFullName() %></td>
    <td><%= u.getEmail() == null ? "-" : u.getEmail() %></td>
    <td><%= u.getPhone() == null ? "-" : u.getPhone() %></td>
    <td><%= u.getRole() %></td>
    <td><%= u.getStatus() %></td>
    <td class="actions">
        <a class="edit" href="editUser.jsp?id=<%= u.getUserId() %>">✏ Edit</a>
        <a class="delete"
           href="<%=request.getContextPath()%>/admin/delete-user?id=<%= u.getUserId() %>"
           onclick="return confirm('Are you sure you want to delete this user?')">
           🗑 Delete
        </a>
    </td>
</tr>
<% } %>

</table>
</div>

</body>
</html>
