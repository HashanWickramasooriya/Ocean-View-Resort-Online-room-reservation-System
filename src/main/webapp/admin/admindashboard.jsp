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
:root{
  /* ✅ Ocean Breeze palette (NO PINK USED IN UI) */
  --bg:#E0F2FE;
  --card:#FFFFFF;
  --primary:#0284C7;      /* Ocean Blue */
  --text:#0F172A;
  --muted:#475569;

  /* status colors (optional) */
  --success:#10B981;
  --warning:#FBBF24;
  --error:#F43F5E;

  /* UI neutrals */
  --panel: rgba(255,255,255,0.92);
  --panel2: rgba(255,255,255,0.98);
  --border: rgba(15,23,42,0.12);
  --shadow: 0 14px 34px rgba(15,23,42,0.12);
  --radius: 22px;

  /* accents */
  --sky:#22c1f0;
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

/* ✅ SIDEBAR (EXACT SAME AS allReservations.jsp) */
.sidebar{
  padding:22px 18px;
  border-right:1px solid rgba(255,255,255,0.14);
  background: linear-gradient(180deg, #0b1f3a, #082036);
  color:#fff;
}
.brand{
  display:flex;
  gap:12px;
  align-items:center;
  padding:10px 10px 18px;
}
.logo{
  width:44px;height:44px;border-radius:16px;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 14px 28px rgba(2,132,199,0.22);
}
.brand h1{
  font-size:16px;
  margin:0;
  font-weight:900;
  color:#fff;
}
.brand p{
  margin:3px 0 0;
  color: rgba(255,255,255,0.72);
  font-size:12px;
  font-weight:700;
}

.nav{
  margin-top:12px;
  display:flex;
  flex-direction:column;
  gap:12px;
}
.nav a{
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:14px 14px;
  border-radius:16px;
  background: rgba(255,255,255,0.08);
  border:1px solid rgba(255,255,255,0.12);
  color:#fff;
  text-decoration:none;
  font-weight:800;
}
.nav a:hover{
  background: rgba(2,132,199,0.22);
  border-color: rgba(2,132,199,0.35);
}
.nav a .tag{
  padding:5px 10px;
  border-radius:999px;
  font-size:12px;
  color:rgba(255,255,255,0.78);
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.08);
}

.sidebar-bottom{
  position:sticky;
  top: calc(100vh - 100px);
  margin-top:22px;
}
.logout{
  display:block;
  text-align:center;
  padding:14px;
  border-radius:16px;

  /* ✅ Coral Pink Logout */
  background: rgba(251,113,133,0.22);
  border:1px solid rgba(251,113,133,0.45);
  color:#fff;

  text-decoration:none;
  font-weight:900;
}

.logout:hover{
  background: rgba(251,113,133,0.35);
  border-color: rgba(251,113,133,0.65);
}
/* Main */
.content{
  padding:28px;
}

/* Header card */
.header-card{
  padding:18px 22px;
  border-radius:22px;
  background: var(--panel2);
  border:1px solid var(--border);
  box-shadow: var(--shadow);
  backdrop-filter: blur(14px);
}
.header-card h2{
  margin:0;
  font-size:22px;
  font-weight:950;
}
.header-card p{
  margin:6px 0 0;
  color:var(--muted);
  font-weight:700;
}

/* ✅ MODERN STATS (NO ICONS + LARGE TITLE + DARK BLUE NUMBER) */
.stats{
  margin-top:28px;
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap:24px;
}

.stat-tile{
  border-radius:var(--radius);
  padding:26px;
  position:relative;
  overflow:hidden;
  background: rgba(255,255,255,0.82);
  border:1px solid rgba(15,23,42,0.10);
  backdrop-filter: blur(16px);
  box-shadow: var(--shadow);
  transition:0.35s;
  text-align:center;
}

.stat-tile:hover{
  transform: translateY(-10px);
  box-shadow: 0 22px 55px rgba(2,132,199,0.20);
  border-color: rgba(2,132,199,0.25);
}

/* Glow effect */
.stat-tile::before{
  content:"";
  position:absolute;
  width:180px;
  height:180px;
  top:-80px;
  right:-80px;
  border-radius:50%;
  background: radial-gradient(circle, rgba(2,132,199,0.25), transparent 72%);
}

/* ✅ Large Title */
.stat-tile h4{
  margin:0;
  font-size:20px;
  font-weight:950;
  color:var(--text);
}

/* ✅ Big Number */
.stat-tile p{
  margin:18px 0 8px;
  font-size:46px;
  font-weight:950;
  color:#062a4d; /* Dark Blue */
}

/* ✅ Middle Subtitle */
.stat-tile .hint{
  margin-top:6px;
  font-size:14px;
  font-weight:700;
  color:var(--muted);
}

/* ✅ ACTION SECTION (cards, NO PINK) */
.actions{
  margin-top:40px;
}

.actions-head{
  display:flex;
  align-items:flex-end;
  justify-content:space-between;
  gap:14px;
  flex-wrap:wrap;
  margin-bottom:18px;
}

.actions-head h3{
  margin:0;
  font-size:18px;
  font-weight:950;
}

.actions-head span{
  color:var(--muted);
  font-weight:700;
  font-size:13px;
}

.action-grid{
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap:20px;
}

.action-card{
  padding:20px;
  border-radius:22px;
  background: rgba(255,255,255,0.82);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
  backdrop-filter: blur(14px);
  text-decoration:none;
  color:var(--text);
  transition:0.35s;
  position:relative;
  overflow:hidden;
}

.action-card::after{
  content:"";
  position:absolute;
  inset:auto -40px -40px auto;
  width:170px;
  height:170px;
  border-radius:50%;
  background: radial-gradient(circle, rgba(2,132,199,0.22), transparent 70%);
}

.action-card:hover{
  transform: translateY(-8px);
  border-color: rgba(2,132,199,0.35);
  box-shadow: 0 22px 55px rgba(2,132,199,0.18);
}

.action-top{
  display:flex;
  align-items:center;
  gap:12px;
  margin-bottom:10px;
}

.action-badge{
  width:44px;height:44px;
  border-radius:16px;
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:20px;
  color:white;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 10px 22px rgba(2,132,199,0.18);
}

.action-card h4{
  margin:0;
  font-size:16px;
  font-weight:950;
}

.action-card p{
  margin:6px 0 0;
  font-size:13px;
  color:var(--muted);
  font-weight:700;
}

/* Responsive */
@media (max-width: 1050px){
  .layout{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(15,23,42,0.12); }
  .sidebar-bottom{ position:static; }
}
</style>
</head>

<body>

<div class="layout">

  <!-- ✅ Sidebar -->
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
      <a href="<%=request.getContextPath()%>/admin/manageStaff.jsp">
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
  <main class="content">

    <div class="header-card">
      <h2>Welcome, <%= user.getFullName() %> 👋</h2>
      <p>Ocean Breeze Admin Dashboard Overview</p>
    </div>

    <!-- ✅ Stats (NO ICONS + LARGE TITLE + DARK BLUE NUMBER + MIDDLE TEXT) -->
    <div class="stats">

      <div class="stat-tile">
        <h4>Total Active Users</h4>
        <p><%= totalUsers %></p>
        <div class="hint">Users currently registered</div>
      </div>

      <div class="stat-tile">
        <h4>Total Rooms</h4>
        <p><%= totalRooms %></p>
        <div class="hint">Rooms available in the resort</div>
      </div>

      <div class="stat-tile">
        <h4>Total Reservations</h4>
        <p><%= totalReservations %></p>
        <div class="hint">Bookings created so far</div>
      </div>

      <div class="stat-tile">
        <h4>Monthly Revenue</h4>
        <p>LKR <%= String.format("%,.0f", monthlyRevenue) %></p>
        <div class="hint">Revenue this month</div>
      </div>

    </div>

    <!-- ✅ Actions (cards) -->
    <div class="actions">
      <div class="actions-head">
        <h3>Quick Management</h3>
        <span>Common tasks for front-office admins</span>
      </div>

      <div class="action-grid">

        <a class="action-card" href="<%=request.getContextPath()%>/admin/addUser.jsp">
          <div class="action-top">
            <div class="action-badge">➕</div>
            <div>
              <h4>Add Staff Member</h4>
              <p>Create and manage hotel employees easily</p>
            </div>
          </div>
        </a>

        <a class="action-card" href="<%=request.getContextPath()%>/admin/addRoom.jsp">
          <div class="action-top">
            <div class="action-badge">🛏</div>
            <div>
              <h4>Add New Room</h4>
              <p>Register rooms with pricing & facilities</p>
            </div>
          </div>
        </a>

        <a class="action-card" href="<%=request.getContextPath()%>/admin/all-reservations">
          <div class="action-top">
            <div class="action-badge">📋</div>
            <div>
              <h4>View Reservations</h4>
              <p>Track guest bookings and reservation history</p>
            </div>
          </div>
        </a>

      </div>
    </div>

  </main>

</div>

</body>
</html>
