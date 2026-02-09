<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType"); // "success" or "error"

    // ✅ Normalize messageType so styling always works
    String safeType = "";
    if (messageType != null) {
        if ("success".equalsIgnoreCase(messageType)) safeType = "success";
        else if ("error".equalsIgnoreCase(messageType)) safeType = "error";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New User | Ocean View Resort</title>

<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>

<div class="layout">

  <!-- Sidebar -->
  <aside class="sidebar">

    <div class="brand">
      <div class="logo"></div>
      <div>
        <h1>Admin Panel</h1>
        <p>Ocean View Resort</p>
      </div>
    </div>

    <nav class="nav">
      <a href="<%=request.getContextPath()%>/admin/admindashboard.jsp">
        Dashboard <span class="tag">Home</span>
      </a>
      <a href="<%=request.getContextPath()%>/admin/manageRooms.jsp">
        Rooms <span class="tag">Manage</span>
      </a>
      <a class="active" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">
        Staff <span class="tag">Users</span>
      </a>
      <a href="<%=request.getContextPath()%>/admin/all-reservations">
        Reservations <span class="tag">View</span>
      </a>
    </nav>

    <div class="sidebar-bottom">
      <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>

  </aside>

  <!-- Main -->
  <main class="main">

    <div class="topbar">
      <div>
        <h2>Add New User</h2>
        <p>Create a new STAFF or ADMIN account</p>
      </div>
      <a class="back-btn" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">← Back</a>
    </div>

    <div class="card">

      <h3 class="card-title">User Details</h3>
      <p class="card-sub">Fill the required fields and choose the role.</p>

      <% if (message != null && !message.trim().isEmpty()) { %>
        <p class="message <%= safeType %>"><%= message %></p>
      <% } %>

      <form action="<%=request.getContextPath()%>/admin/add-user" method="post">
        <div class="form-grid">

          <div class="field">
            <label for="username">Username *</label>
            <input type="text" name="username" id="username" required>
          </div>

          <div class="field">
            <label for="fullName">Full Name *</label>
            <input type="text" name="fullName" id="fullName" required>
          </div>

          <div class="field">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" placeholder="name@example.com">
          </div>

          <div class="field">
            <label for="phone">Phone</label>
            <input type="text" name="phone" id="phone" placeholder="+94 ...">
          </div>

          <div class="field">
            <label for="password">Password *</label>
            <input type="password" name="password" id="password" required>
          </div>

          <div class="field">
            <label for="role">Role *</label>
            <select name="role" id="role" required>
              <option value="STAFF">STAFF</option>
              <option value="ADMIN">ADMIN</option>
            </select>
          </div>

        </div>

        <!-- ✅ centered buttons -->
        <div class="actions">
          <a class="btn btn-ghost" href="<%=request.getContextPath()%>/admin/manageStaff.jsp">Cancel</a>
          <button class="btn btn-primary" type="submit">Add User</button>
        </div>
      </form>

    </div>

  </main>

</div>

</body>
</html>
