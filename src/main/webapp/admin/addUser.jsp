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

<style>
:root{
  --bg:#E0F2FE;
  --primary:#0284C7;
  --sky:#22c1f0;
  --coral:#FB7185;

  --text:#0F172A;
  --muted:#475569;

  --panel: rgba(255,255,255,0.92);
  --panel2: rgba(255,255,255,0.98);
  --border: rgba(15,23,42,0.12);

  --shadow: 0 14px 34px rgba(15,23,42,0.12);
  --radius: 22px;
}

*{box-sizing:border-box}

body{
  margin:0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial;
  background:
    radial-gradient(900px 600px at 70% 10%, rgba(2,132,199,0.14), transparent 58%),
    radial-gradient(900px 650px at 20% 90%, rgba(16,185,129,0.08), transparent 60%),
    linear-gradient(180deg, var(--bg), #f8fbff);
  color:var(--text);
  min-height:100vh;
}

/* Layout */
.layout{
  display:grid;
  grid-template-columns: 280px 1fr;
  min-height:100vh;
}

/* Sidebar */
.sidebar{
  padding:22px 18px;
  border-right:1px solid rgba(255,255,255,0.10);
  background: linear-gradient(180deg, #081a33 0%, #06162b 35%, #041225 100%);
  color:#fff;

  display:flex;
  flex-direction:column;
  min-height:100vh;
}

.brand{
  display:flex;
  gap:14px;
  align-items:center;
  padding:10px 10px 18px;
}
.logo{
  width:52px;height:52px;
  border-radius:18px;
  background: linear-gradient(135deg, #00a3d9, #0b5cff);
  box-shadow: 0 18px 40px rgba(0,0,0,0.35);
}
.brand h1{
  margin:0;
  font-size:18px;
  font-weight:950;
}
.brand p{
  margin:4px 0 0;
  font-size:12px;
  font-weight:800;
  color: rgba(255,255,255,0.70);
}

.nav{
  margin-top:10px;
  display:flex;
  flex-direction:column;
  gap:14px;
}

.nav a{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  padding:14px 14px;
  border-radius:18px;
  text-decoration:none;
  color:#fff;
  font-weight:900;
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.12);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.08);
  transition: 0.22s ease;
}
.nav a:hover{
  background: rgba(0,163,217,0.16);
  border-color: rgba(0,163,217,0.30);
  transform: translateY(-1px);
}
.nav a.active{
  background: rgba(255,255,255,0.12);
  border-color: rgba(255,255,255,0.18);
}
.nav a .tag{
  padding:6px 12px;
  border-radius:999px;
  font-size:12px;
  font-weight:950;
  color: rgba(255,255,255,0.80);
  background: rgba(255,255,255,0.10);
  border: 1px solid rgba(255,255,255,0.14);
}

/* Logout Bottom (only pink) */
.sidebar-bottom{
  margin-top:auto;
  padding-top:18px;
}
.logout{
  display:block;
  width:100%;
  text-align:center;
  padding:16px 14px;
  border-radius:18px;
  font-weight:950;
  text-decoration:none;
  color:#fff;
  background: linear-gradient(135deg, rgba(251,113,133,0.28), rgba(251,113,133,0.14));
  border: 1px solid rgba(251,113,133,0.40);
  box-shadow: 0 16px 40px rgba(0,0,0,0.35);
  transition: 0.22s ease;
}
.logout:hover{
  background: linear-gradient(135deg, rgba(251,113,133,0.36), rgba(251,113,133,0.18));
  border-color: rgba(251,113,133,0.55);
  transform: translateY(-1px);
}

/* Main */
.main{ padding:28px; }

/* Top bar */
.topbar{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:16px;
  padding:18px 22px;
  border-radius:22px;
  background: var(--panel2);
  border:1px solid var(--border);
  box-shadow: var(--shadow);
}
.topbar h2{
  margin:0;
  font-size:22px;
  font-weight:950;
}
.topbar p{
  margin:6px 0 0;
  color:var(--muted);
  font-weight:700;
}

/* Back button */
.back-btn{
  padding:12px 16px;
  border-radius:16px;
  background: rgba(2,132,199,0.12);
  border:1px solid rgba(2,132,199,0.28);
  color: var(--primary);
  text-decoration:none;
  font-weight:950;
  white-space:nowrap;
}
.back-btn:hover{ background: rgba(2,132,199,0.18); }

/* Card */
.card{
  border-radius:22px;
  background: rgba(255,255,255,0.82);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
  backdrop-filter: blur(14px);
  padding:22px;
  max-width: 1200px;
  margin:22px auto 0;
}

.card-title{
  margin:0 0 4px 0;
  font-size:16px;
  font-weight:950;
}
.card-sub{
  margin:0 0 16px 0;
  color: var(--muted);
  font-weight:700;
  font-size:13px;
}

/* ✅ Message (success/error) */
.message{
  margin:0 0 14px 0;
  padding:12px 14px;
  border-radius:16px;
  font-weight:950;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.85);
}
.success{
  border-color: rgba(16,185,129,0.25);
  background: rgba(16,185,129,0.10);
  color: rgba(7, 103, 62, 0.95);
}
.error{
  border-color: rgba(244,63,94,0.25);
  background: rgba(244,63,94,0.10);
  color: rgba(159, 18, 57, 0.95);
}

/* Form grid */
.form-grid{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:14px;
}

.field label{
  display:block;
  margin:0 0 6px 4px;
  font-size:12px;
  font-weight:950;
  color: var(--muted);
}

input[type="text"],
input[type="email"],
input[type="password"],
select{
  width:100%;
  padding:12px 12px;
  border-radius:16px;
  border:1px solid rgba(15,23,42,0.14);
  background: rgba(255,255,255,0.92);
  outline:none;
  color: var(--text);
  font-weight:700;
}

input:focus, select:focus{
  border-color: rgba(2,132,199,0.55);
  box-shadow: 0 0 0 4px rgba(2,132,199,0.16);
}

/* ✅ Buttons centered (middle) */
.actions{
  margin-top:18px;
  display:flex;
  gap:12px;
  justify-content:center; /* ✅ middle */
  flex-wrap:wrap;
}

.btn{
  padding:12px 22px;
  border-radius:16px;
  border:none;
  cursor:pointer;
  font-weight:950;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  min-width: 140px;
}

.btn-primary{
  color:#fff;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 12px 26px rgba(2,132,199,0.20);
}
.btn-primary:hover{ filter:brightness(1.05); }

.btn-ghost{
  color: var(--text);
  background: rgba(255,255,255,0.85);
  border:1px solid rgba(15,23,42,0.12);
}
.btn-ghost:hover{ background: rgba(2,132,199,0.08); }

/* Responsive */
@media (max-width: 1050px){
  .layout{ grid-template-columns: 1fr; }
  .sidebar{
    border-right:none;
    border-bottom:1px solid rgba(15,23,42,0.12);
    min-height:auto;
  }
  .card{ max-width: 100%; }
}
@media (max-width: 720px){
  .form-grid{ grid-template-columns: 1fr; }
}
</style>
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
