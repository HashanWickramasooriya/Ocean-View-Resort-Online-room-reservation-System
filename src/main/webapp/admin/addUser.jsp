<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New User | Ocean View Resort</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f5f9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 500px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }
        h2 { text-align: center; color: #003366; }
        label { font-weight: bold; display: block; margin-top: 15px; }
        input, select {
            width: 100%;
            padding: 8px 12px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background: #0059b3;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        button:hover { background: #003366; }
        .message { text-align: center; margin-top: 10px; font-weight: bold; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>

<div class="container">
    <h2>Add New User</h2>

    <%-- Display success or error message --%>
    <% 
        String message = (String) request.getAttribute("message");
        String messageType = (String) request.getAttribute("messageType");
        if(message != null) {
    %>
        <p class="message <%= messageType %>"><%= message %></p>
    <% } %>

    <form action="<%=request.getContextPath()%>/admin/add-user" method="post">
        <label for="username">Username *</label>
        <input type="text" name="username" id="username" required>

        <label for="fullName">Full Name *</label>
        <input type="text" name="fullName" id="fullName" required>

        <label for="email">Email</label>
        <input type="email" name="email" id="email">
        
        <label for="password">Password *</label>
        <input type="password" name="password" id="password" required>

        <label for="phone">Phone</label>
        <input type="text" name="phone" id="phone">

        <label for="role">Role *</label>
        <select name="role" id="role" required>
            <option value="STAFF">STAFF</option>
            <option value="ADMIN">ADMIN</option>
        </select>

        <button type="submit">Add User</button>
    </form>
</div>

</body>
</html>
