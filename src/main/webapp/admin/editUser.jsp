<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.dao.UserDAO" %>
<%@ page import="com.oceanview.dao.UserDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    /* ================= ADMIN AUTH CHECK ================= */
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    /* ================= VALIDATE ID ================= */
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("manageStaff.jsp");
        return;
    }

    int userId = Integer.parseInt(idParam);

    /* ================= LOAD USER ================= */
    UserDAO userDAO = new UserDAOImpl(DBConnection.getConnection());
    User user = userDAO.getUserById(userId);

    if (user == null) {
        response.sendRedirect("manageStaff.jsp");
        return;
    }

    /* ================= FLASH MESSAGE CONTROL ================= */
    Boolean fromUpdate = (Boolean) session.getAttribute("fromUpdate");
    String successMsg  = (String) session.getAttribute("successMsg");
    String errorMsg    = (String) session.getAttribute("errorMsg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Staff</title>

<style>
body {
    font-family: Arial;
    background: #f2f5f9;
}
.container {
    width: 450px;
    margin: 40px auto;
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}
h2 {
    text-align: center;
    color: #003366;
}
label {
    font-weight: bold;
    display: block;
    margin-top: 12px;
}
input, select {
    width: 100%;
    padding: 8px;
    margin-top: 6px;
    border-radius: 6px;
    border: 1px solid #ccc;
}
button {
    margin-top: 20px;
    width: 100%;
    padding: 12px;
    background: #0059b3;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
}
button:hover {
    background: #003366;
}
.alert-success {
    background: #e6ffed;
    color: #2e7d32;
    padding: 10px;
    border-radius: 6px;
    margin-bottom: 15px;
    text-align: center;
    font-weight: bold;
}
.alert-error {
    background: #fdecea;
    color: #c62828;
    padding: 10px;
    border-radius: 6px;
    margin-bottom: 15px;
    text-align: center;
    font-weight: bold;
}
.back-link {
    text-align: center;
    margin-top: 15px;
}
.back-link a {
    text-decoration: none;
    color: #0059b3;
    font-weight: bold;
}
</style>
</head>

<body>

<div class="container">

<h2>Edit Staff</h2>

<%-- ================= SHOW MESSAGE ONLY AFTER UPDATE ================= --%>
<%
    if (fromUpdate != null && fromUpdate) {

        if (successMsg != null) {
%>
            <div class="alert-success"><%= successMsg %></div>
<%
        } else if (errorMsg != null) {
%>
            <div class="alert-error"><%= errorMsg %></div>
<%
        }

        // 🔥 CLEAR FLASH DATA (SHOW ONCE ONLY)
        session.removeAttribute("fromUpdate");
        session.removeAttribute("successMsg");
        session.removeAttribute("errorMsg");
    }
%>

<form action="<%=request.getContextPath()%>/admin/update-user" method="post">

    <input type="hidden" name="userId" value="<%= user.getUserId() %>">

    <label>Username</label>
    <input type="text" value="<%= user.getUsername() %>" disabled>

    <label>Full Name *</label>
    <input type="text" name="fullName" value="<%= user.getFullName() %>" required>

    <label>Email</label>
    <input type="email" name="email"
           value="<%= user.getEmail() == null ? "" : user.getEmail() %>">

    <label>Phone</label>
    <input type="text" name="phone"
           value="<%= user.getPhone() == null ? "" : user.getPhone() %>">

    <label>Role *</label>
    <select name="role" required>
        <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN</option>
        <option value="STAFF" <%= "STAFF".equals(user.getRole()) ? "selected" : "" %>>STAFF</option>
    </select>

    <label>Status *</label>
    <select name="status" required>
        <option value="ACTIVE" <%= "ACTIVE".equals(user.getStatus()) ? "selected" : "" %>>ACTIVE</option>
        <option value="INACTIVE" <%= "INACTIVE".equals(user.getStatus()) ? "selected" : "" %>>INACTIVE</option>
    </select>

    <button type="submit">Update User</button>
</form>

<div class="back-link">
    <a href="manageStaff.jsp">← Back to Manage Staff</a>
</div>

</div>

</body>
</html>
