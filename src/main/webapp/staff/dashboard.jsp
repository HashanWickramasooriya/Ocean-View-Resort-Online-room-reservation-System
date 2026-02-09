<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.entity.ReservationDetails" %>

<%
  User user = (User) session.getAttribute("user");
  if (user == null || !"STAFF".equals(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }

  Integer todayCheckIns = (Integer) request.getAttribute("todayCheckIns");
  Integer todayCheckOuts = (Integer) request.getAttribute("todayCheckOuts");
  Integer availableRooms = (Integer) request.getAttribute("availableRooms");
  Integer pendingRequests = (Integer) request.getAttribute("pendingRequests");

  if (todayCheckIns == null) todayCheckIns = 0;
  if (todayCheckOuts == null) todayCheckOuts = 0;
  if (availableRooms == null) availableRooms = 0;
  if (pendingRequests == null) pendingRequests = 0;

  List<ReservationDetails> schedule = (List<ReservationDetails>) request.getAttribute("todaySchedule");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Reception Dashboard | Ocean View Resort</title>

<style>
:root{
  --bg1:#050B18;
  --bg2:#07142B;
  --card: rgba(255,255,255,0.08);
  --card2: rgba(255,255,255,0.10);
  --stroke: rgba(255,255,255,0.14);
  --text:#EAF2FF;
  --muted: rgba(234,242,255,0.70);

  --a:#7C3AED;
  --b:#22D3EE;
  --c:#34D399;
  --d:#F59E0B;

  --shadow: 0 18px 55px rgba(0,0,0,0.50);
  --radius: 22px;
}

*{box-sizing:border-box}
body{
  margin:0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial;
  color:var(--text);
  background:
    radial-gradient(900px 550px at 70% 12%, rgba(34,211,238,0.16), transparent 60%),
    radial-gradient(900px 600px at 20% 85%, rgba(124,58,237,0.18), transparent 65%),
    radial-gradient(700px 500px at 50% 105%, rgba(52,211,153,0.10), transparent 60%),
    linear-gradient(180deg, var(--bg1), var(--bg2));
  overflow-x:hidden;
}

.app{ display:grid; grid-template-columns: 290px 1fr; min-height:100vh; }

.sidebar{
  padding:22px 18px;
  border-right:1px solid rgba(255,255,255,0.10);
  background: linear-gradient(180deg, rgba(255,255,255,0.06), rgba(255,255,255,0.02));
  backdrop-filter: blur(14px);
}

.brand{ display:flex; gap:12px; align-items:center; padding:10px 10px 18px; }
.logo{
  width:46px;height:46px;border-radius:16px;
  background: linear-gradient(135deg, var(--a), var(--b));
  box-shadow: 0 14px 34px rgba(34,211,238,0.15);
  position:relative;
}
.logo:after{
  content:"";
  position:absolute;
  inset:10px;
  border-radius:12px;
  background: rgba(255,255,255,0.20);
  transform: rotate(10deg);
}
.brand h1{ margin:0; font-size:15px; font-weight:950; }
.brand p{ margin:4px 0 0; font-size:12px; font-weight:700; color:var(--muted); }

.nav{ display:flex; flex-direction:column; gap:10px; margin-top:6px; }
.nav a{
  text-decoration:none;
  color:var(--text);
  background: rgba(255,255,255,0.06);
  border:1px solid rgba(255,255,255,0.10);
  padding:12px;
  border-radius:16px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  transition:0.25s ease;
}
.nav a:hover{
  transform: translateY(-2px);
  border-color: rgba(34,211,238,0.35);
  background: rgba(34,211,238,0.10);
}
.nav .left{ display:flex; gap:10px; align-items:center; font-weight:850; }
.ico{
  width:38px;height:38px;border-radius:14px;
  display:flex;align-items:center;justify-content:center;
  background: rgba(255,255,255,0.08);
  border:1px solid rgba(255,255,255,0.10);
}

.tag{
  font-size:12px; font-weight:800;
  padding:5px 10px; border-radius:999px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
  color: rgba(234,242,255,0.78);
}

.sidebar-bottom{ margin-top:18px; position:sticky; top: calc(100vh - 110px); }
.logout{
  display:block; text-align:center; padding:14px; border-radius:16px;
  text-decoration:none; font-weight:950; color:#fff;
  border:1px solid rgba(251,113,133,0.55);
  background: rgba(251,113,133,0.18);
  transition:0.25s ease;
}
.logout:hover{ background: rgba(251,113,133,0.28); transform: translateY(-2px); }

.main{ padding:22px 22px 28px; }

.welcome h2{ margin:0; font-size:22px; font-weight:950; }
.welcome p{ margin:6px 0 0; color:var(--muted); font-weight:700; font-size:13px; }

.kpis{
  margin-top:18px;
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap:14px;
}
.kpi{
  position:relative;
  overflow:hidden;
  border-radius: var(--radius);
  background: var(--card);
  border:1px solid var(--stroke);
  padding:16px 16px 14px;
  box-shadow: var(--shadow);
  backdrop-filter: blur(16px);
  transition:0.25s ease;
}
.kpi:hover{ transform: translateY(-6px); border-color: rgba(255,255,255,0.22); }

.kpi:before{
  content:"";
  position:absolute;
  width:180px;height:180px;
  top:-95px; right:-95px;
  border-radius:50%;
  opacity:0.9;
}
.kpi.violet:before{ background: radial-gradient(circle, rgba(124,58,237,0.38), transparent 70%); }
.kpi.cyan:before{ background: radial-gradient(circle, rgba(34,211,238,0.34), transparent 70%); }
.kpi.green:before{ background: radial-gradient(circle, rgba(52,211,153,0.30), transparent 70%); }
.kpi.amber:before{ background: radial-gradient(circle, rgba(245,158,11,0.28), transparent 70%); }

.kpiTop{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
.kpiTitle{ font-weight:900; }
.kpiMeta{
  font-size:12px; font-weight:800;
  color: rgba(234,242,255,0.70);
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  padding:5px 10px; border-radius:999px;
}
.kpiValue{ margin-top:12px; font-size:40px; font-weight:950; }
.kpiHint{ margin-top:4px; color:var(--muted); font-weight:700; font-size:13px; }

.grid{
  margin-top:16px;
  display:grid;
  grid-template-columns: 1fr 1fr; /* ✅ now two cards side by side */
  gap:14px;
  align-items:start;
}
.card{
  border-radius: var(--radius);
  background: var(--card2);
  border:1px solid var(--stroke);
  box-shadow: var(--shadow);
  backdrop-filter: blur(18px);
  overflow:hidden;
}
.cardHead{
  padding:14px 16px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  border-bottom:1px solid rgba(255,255,255,0.10);
}
.cardHead h3{ margin:0; font-size:15px; font-weight:950; }
.cardHead span{ color:var(--muted); font-weight:750; font-size:12px; }
.cardBody{ padding:14px 16px 16px; }

/* ✅ Quick Actions */
.actions{
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
  gap:12px;
}
.action{
  text-decoration:none;
  color:var(--text);
  border-radius:18px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
  padding:14px;
  transition:0.25s ease;
  display:flex;
  gap:12px;
  align-items:center;
}
.action:hover{
  transform: translateY(-5px);
  border-color: rgba(34,211,238,0.30);
  background: rgba(34,211,238,0.08);
}
.badge{
  width:46px;height:46px;border-radius:16px;
  display:flex;align-items:center;justify-content:center;
  background: linear-gradient(135deg, var(--a), var(--b));
  border:1px solid rgba(255,255,255,0.10);
  font-size:20px;
  flex:0 0 auto;
}
.action h4{ margin:0; font-size:14px; font-weight:950; }
.action p{ margin:6px 0 0; color:var(--muted); font-size:12px; font-weight:750; }

/* ✅ Schedule list */
.list{ display:flex; flex-direction:column; gap:10px; }
.item{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  padding:12px;
  border-radius:16px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.05);
}
.item:hover{
  border-color: rgba(124,58,237,0.35);
  background: rgba(124,58,237,0.08);
}
.line1{ font-weight:950; font-size:13px; }
.line2{ color:var(--muted); font-weight:750; font-size:12px; margin-top:4px; }

.rightBox{ display:flex; align-items:center; gap:10px; }
.time{
  font-weight:950;
  font-size:12px;
  padding:6px 10px;
  border-radius:999px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
  white-space:nowrap;
}
.badgeType{
  margin-left:8px;
  font-size:11px;
  font-weight:900;
  padding:4px 10px;
  border-radius:999px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  color: rgba(234,242,255,0.85);
}

.btn{
  border:1px solid rgba(255,255,255,0.16);
  background: rgba(255,255,255,0.06);
  color: var(--text);
  font-weight:950;
  padding:8px 12px;
  border-radius:14px;
  cursor:pointer;
  transition:0.2s ease;
}
.btn:hover{ transform: translateY(-2px); }
.btnCheckIn{
  background: rgba(52,211,153,0.16);
  border-color: rgba(52,211,153,0.40);
}
.btnCheckOut{
  background: rgba(245,158,11,0.16);
  border-color: rgba(245,158,11,0.45);
}

@media (max-width: 1100px){ .grid{ grid-template-columns: 1fr; } }
@media (max-width: 980px){
  .app{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(255,255,255,0.10); }
  .sidebar-bottom{ position:static; }
}
</style>
</head>

<body>
<div class="app">

  <aside class="sidebar">
    <div class="brand">
      <div class="logo"></div>
      <div>
        <h1>Reception Desk</h1>
        <p>Ocean View Resort</p>
      </div>
    </div>

    <nav class="nav">
      <a href="<%=request.getContextPath()%>/staff/dashboard">
        <div class="left"><div class="ico">🏠</div>Dashboard</div>
        <span class="tag">Home</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp">
        <div class="left"><div class="ico">➕</div>Add Reservation</div>
        <span class="tag">Create</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/manage-reservations">
        <div class="left"><div class="ico">📋</div>Manage Reservations</div>
        <span class="tag">Manage</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/room-availability">
        <div class="left"><div class="ico">🛏</div>Room Availability</div>
        <span class="tag">Check</span>
      </a>
    </nav>

    <div class="sidebar-bottom">
      <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
  </aside>

  <main class="main">

    <div class="welcome">
      <h2>Hi, <%= user.getFullName() %> 👋</h2>
      <p>Reception Dashboard · Live hotel operations</p>
    </div>

    <div class="kpis">
      <div class="kpi cyan">
        <div class="kpiTop"><div class="kpiTitle">Today Check-ins</div><div class="kpiMeta">Arrivals</div></div>
        <div class="kpiValue"><%= todayCheckIns %></div>
        <div class="kpiHint">PENDING / CONFIRMED arriving today</div>
      </div>

      <div class="kpi violet">
        <div class="kpiTop"><div class="kpiTitle">Today Check-outs</div><div class="kpiMeta">Departures</div></div>
        <div class="kpiValue"><%= todayCheckOuts %></div>
        <div class="kpiHint">CHECKED_IN leaving today</div>
      </div>

      <div class="kpi green">
        <div class="kpiTop"><div class="kpiTitle">Available Rooms</div><div class="kpiMeta">Today</div></div>
        <div class="kpiValue"><%= availableRooms %></div>
        <div class="kpiHint">rooms.status=AVAILABLE and not booked today</div>
      </div>

      <div class="kpi amber">
        <div class="kpiTop"><div class="kpiTitle">Pending Reservations</div><div class="kpiMeta">Action</div></div>
        <div class="kpiValue"><%= pendingRequests %></div>
        <div class="kpiHint">status=PENDING</div>
      </div>
    </div>

    <div class="grid">

      <!-- ✅ QUICK ACTIONS CARD -->
      <section class="card">
        <div class="cardHead"><h3>Quick Actions</h3><span>Fast workflow</span></div>
        <div class="cardBody">
          <div class="actions">

            <a class="action" href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp">
              <div class="badge">➕</div>
              <div>
                <h4>Add Reservation</h4>
                <p>Create a new booking</p>
              </div>
            </a>

            <a class="action" href="<%=request.getContextPath()%>/staff/manage-reservations">
              <div class="badge">📋</div>
              <div>
                <h4>Manage Reservations</h4>
                <p>Edit / cancel / confirm</p>
              </div>
            </a>

            <a class="action" href="<%=request.getContextPath()%>/staff/room-availability">
              <div class="badge">🛏</div>
              <div>
                <h4>Room Availability</h4>
                <p>Check free rooms today</p>
              </div>
            </a>

            <a class="action" href="<%=request.getContextPath()%>/staff/reservations.jsp">
              <div class="badge">🧾</div>
              <div>
                <h4>All Reservations</h4>
                <p>Search booking history</p>
              </div>
            </a>

          </div>
        </div>
      </section>

      <!-- ✅ TODAY SCHEDULE CARD -->
      <section class="card">
        <div class="cardHead"><h3>Today’s Schedule</h3><span>Arrivals & departures</span></div>
        <div class="cardBody">
          <div class="list">

            <%
              if (schedule != null && !schedule.isEmpty()) {
                for (ReservationDetails d : schedule) {
            %>
              <div class="item">
                <div>
                  <div class="line1">
                    Room <%= d.getRoomNumber() %> · <%= d.getGuestName() %>
                    <span class="badgeType"><%= d.getTodayType() %></span>
                  </div>
                  <div class="line2">
                    <%= d.getRoomType() %> · Status: <%= d.getStatus() %> · <%= d.getReservationId() %>
                  </div>
                </div>

                <div class="rightBox">
                  <div class="time">
                    <%= ("CHECK-IN".equals(d.getTodayType())) ? d.getCheckInDate() : d.getCheckOutDate() %>
                  </div>

                  <%
                    if ("CHECK-IN".equals(d.getTodayType()) &&
                        ("PENDING".equals(d.getStatus()) || "CONFIRMED".equals(d.getStatus()))) {
                  %>
                    <form action="<%=request.getContextPath()%>/staff/checkin" method="post" style="margin:0;">
                      <input type="hidden" name="reservationId" value="<%= d.getReservationId() %>" />
                      <button type="submit" class="btn btnCheckIn">Check-in</button>
                    </form>
                  <%
                    }
                  %>

                  <%
                    if ("CHECK-OUT".equals(d.getTodayType()) && "CHECKED_IN".equals(d.getStatus())) {
                  %>
                    <form action="<%=request.getContextPath()%>/staff/checkout" method="post" style="margin:0;">
                      <input type="hidden" name="reservationId" value="<%= d.getReservationId() %>" />
                      <button type="submit" class="btn btnCheckOut">Check-out</button>
                    </form>
                  <%
                    }
                  %>
                </div>
              </div>
            <%
                }
              } else {
            %>
              <div class="item">
                <div>
                  <div class="line1">No arrivals or departures today</div>
                  <div class="line2">All clear ✅</div>
                </div>
                <div class="time">Today</div>
              </div>
            <%
              }
            %>

          </div>
        </div>
      </section>

    </div>

  </main>
</div>
</body>
</html>
