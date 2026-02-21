<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.Room,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>

<%
RoomDAO dao = new RoomDAOImpl(DBConnection.getConnection());
List<Room> rooms = dao.getAllRooms();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Rooms | Ocean View Resort</title>
<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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

.layout{
  display:grid;
  grid-template-columns: 280px 1fr;
  min-height:100vh;
}

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

.main{
  padding:28px;
}

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

.add-btn{
  padding:12px 18px;
  border-radius:16px;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  color:#fff;
  font-weight:950;
  text-decoration:none;
  box-shadow: 0 12px 26px rgba(2,132,199,0.20);
  white-space:nowrap;
}
.add-btn:hover{ filter:brightness(1.05); }


.alert{
  margin-top:16px;
  padding:12px 14px;
  border-radius:16px;
  font-weight:950;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.85);
}
.alert.success{
  border-color: rgba(16,185,129,0.25);
  background: rgba(16,185,129,0.10);
  color: rgba(7, 103, 62, 0.95);
}
.alert.error{
  border-color: rgba(244,63,94,0.25);
  background: rgba(244,63,94,0.10);
  color: rgba(159, 18, 57, 0.95);
}


.card{
  margin-top:22px;
  border-radius:22px;
  background: rgba(255,255,255,0.78);
  backdrop-filter: blur(14px);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
  overflow:hidden;
}

.table-wrap{
  overflow:auto;
}
table{
  width:100%;
  border-collapse:separate;
  border-spacing:0;
  min-width:1100px;
}

thead th{
  text-align:left;
  padding:14px;
  font-size:12px;
  letter-spacing:0.5px;
  text-transform:uppercase;
  color: var(--muted);
  background: rgba(255,255,255,0.90);
  border-bottom: 1px solid rgba(15,23,42,0.10);
  position: sticky;
  top: 0;
  z-index: 2;
}

tbody td{
  padding:14px;
  border-bottom:1px solid rgba(15,23,42,0.08);
  font-weight:750;
  background: rgba(255,255,255,0.60);
}

tbody tr:hover td{
  background: rgba(2,132,199,0.10);
}

.pill{
  display:inline-flex;
  align-items:center;
  padding:7px 12px;
  border-radius:999px;
  font-size:12px;
  font-weight:950;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(2,132,199,0.10);
  color: rgba(2, 76, 129, 0.95);
}

.actions a{
  display:inline-flex;
  align-items:center;
  gap:6px;
  padding:8px 12px;
  border-radius:14px;
  text-decoration:none;
  font-weight:950;
  margin-right:8px;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.70);
  color: var(--text);
  transition: 0.18s ease;
}

.actions a.edit{
  border-color: rgba(2,132,199,0.30);
  background: rgba(2,132,199,0.10);
  color: var(--primary);
}
.actions a.edit:hover{
  background: rgba(2,132,199,0.16);
}

.actions a.delete{
  border-color: rgba(251,113,133,0.40);
  background: rgba(251,113,133,0.12);
  color: #b91c1c;
}
.actions a.delete:hover{
  background: rgba(251,113,133,0.18);
}

@media (max-width: 1050px){
  .layout{ grid-template-columns: 1fr; }
  .sidebar{
    border-right:none;
    border-bottom:1px solid rgba(15,23,42,0.12);
    min-height:auto;
  }
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

      <a class="active" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">
        Rooms 
      </a>

      <a href="<%=request.getContextPath()%>/admin/manageStaff.jsp">
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
        <h2>Manage Rooms</h2>
        <p>View, edit and manage all resort rooms</p>
      </div>

      <a class="add-btn" href="<%=request.getContextPath()%>/admin/addRoom.jsp"> Add Room</a>
    </div>

    <div class="card">
      <table>
        <thead>
          <tr>
            <th>No</th>
            <th>Name</th>
            <th>Type</th>
            <th>Rate</th>
            <th>Capacity</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
        <% for(Room r : rooms){ %>
          <tr>
            <td><%= r.getRoomNumber() %></td>
            <td><%= r.getRoomName() %></td>
            <td><%= r.getRoomType() %></td>
            <td>LKR <%= r.getRatePerNight() %></td>
            <td><%= r.getAdultCapacity() %> Adults / <%= r.getChildCapacity() %> Kids</td>
            <td><%= r.getStatus() %></td>

            <td>
              <a class="btn edit" href="<%=request.getContextPath()%>/admin/editRoom.jsp?id=<%=r.getRoomId()%>">Edit</a>

              <a class="btn delete"
                 href="<%=request.getContextPath()%>/admin/delete-room?id=<%=r.getRoomId()%>"
                 onclick="return confirm('Delete this room?')">
                 Delete
              </a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

  </main>

</div>

</body>
</html>
