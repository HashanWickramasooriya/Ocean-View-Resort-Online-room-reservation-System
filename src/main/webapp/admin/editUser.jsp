<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.dao.UserDAO" %>
<%@ page import="com.oceanview.dao.UserDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff.jsp");
        return;
    }

    int userId = 0;
    try {
        userId = Integer.parseInt(idParam);
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff.jsp");
        return;
    }

    UserDAO userDAO = new UserDAOImpl(DBConnection.getConnection());
    User user = userDAO.getUserById(userId);
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff.jsp");
        return;
    }

    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType"); 

    String safeType = "";
    if (messageType != null) {
        if ("success".equalsIgnoreCase(messageType)) safeType = "success";
        else if ("error".equalsIgnoreCase(messageType)) safeType = "error";
    }

    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit User | Ocean View Resort</title>
<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.logo{
  width:70px;
  height:70px;
  border-radius:14px;
  overflow:hidden;
  display:flex;
  align-items:center;
  justify-content:center;
  background: rgba(255,255,255,0.08);
  border:1px solid rgba(255,255,255,0.15);
}

.logo img{
  width:100%;
  height:100%;
  object-fit:contain;
}
</style>
</head>

<body>

<div class="layout">

  <aside class="sidebar">
    <div class="brand">
       <div class="logo">
    <img src="<%= request.getContextPath() %>/AllComponents/images/Logo_2.png"
         alt="Ocean View Resort Logo">
</div>
      <div>
        <h1>Admin Panel</h1>
        <p>Ocean View Resort</p>
      </div>
    </div>

    <nav class="nav">
      <a href="<%=request.getContextPath()%>/admin/admindashboard.jsp">
        Dashboard 
      </a>
      <a href="<%=request.getContextPath()%>/admin/manageRooms.jsp">
        Rooms 
      </a>
      <a class="active" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">
        Staff 
      </a>
      <a href="<%=request.getContextPath()%>/admin/all-reservations">
        Reservations 
      </a>
      <a href="<%= request.getContextPath() %>/admin/revenue-chart">
    View Revenue Chart
</a>
    </nav>

    <div class="sidebar-bottom">
      <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
  </aside>

  <main class="main">

    <div class="topbar">
      <div>
        <h2>Edit User</h2>
        <p>Update user details, role, and account status.</p>
      </div>

      <a class="back-btn" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">← Back</a>
    </div>

    <div class="card">

      <% if (message != null && !message.trim().isEmpty()) { %>
        <div class="message <%= safeType %>"><%= message %></div>
      <% } %>

      <div class="card-body">
        <form action="<%=request.getContextPath()%>/admin/update-user" method="post">

          <input type="hidden" name="userId" value="<%= user.getUserId() %>">

          <div class="form-grid">

            <div class="field full">
              <label>Username</label>
              <input type="text" value="<%= user.getUsername() %>" disabled>
            </div>

            <div class="field">
              <label for="fullName">Full Name *</label>
              <input type="text" name="fullName" id="fullName" value="<%= user.getFullName() %>" required>
            </div>

            <div class="field">
              <label for="email">Email</label>
              <input type="email" name="email" id="email"
                     value="<%= user.getEmail() == null ? "" : user.getEmail() %>"
                     placeholder="name@example.com">
            </div>

            <div class="field">
              <label for="phone">Phone</label>
              <input type="text" name="phone" id="phone"
                     value="<%= user.getPhone() == null ? "" : user.getPhone() %>"
                     placeholder="+94 ...">
            </div>

            <div class="field">
              <label for="role">Role *</label>
              <select name="role" id="role" required>
                <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN</option>
                <option value="STAFF" <%= "STAFF".equals(user.getRole()) ? "selected" : "" %>>STAFF</option>
              </select>
            </div>

            <div class="field">
              <label for="status">Status *</label>
              <select name="status" id="status" required>
                <option value="ACTIVE" <%= "ACTIVE".equals(user.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                <option value="INACTIVE" <%= "INACTIVE".equals(user.getStatus()) ? "selected" : "" %>>INACTIVE</option>
              </select>
            </div>

          </div>

          <div class="actions">
            <a class="btn btn-ghost" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">Cancel</a>
            <button class="btn btn-primary" type="submit">Update User</button>
          </div>

        </form>
      </div>

    </div>

  </main>

</div>

</body>
</html>
