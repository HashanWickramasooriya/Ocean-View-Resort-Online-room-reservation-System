<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection" %>

<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.entity.ReservationDetails" %>
<%@ page import="com.oceanview.dao.ReservationDAO" %>
<%@ page import="com.oceanview.dao.ReservationDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    User staff = (User) session.getAttribute("user");
    if (staff == null || !"STAFF".equals(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String successMsg = (String) session.getAttribute("successMsg");
    session.removeAttribute("successMsg");

    String error = request.getParameter("error");

    List<ReservationDetails> list = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection()){
        ReservationDAO dao = new ReservationDAOImpl(conn);
        list = dao.getAllReservationDetails();
    } catch(Exception e){ e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Manage Reservations | Ocean View Resort</title>

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

  --ok:#34D399;
  --warn:#F59E0B;
  --bad:#fb7185;
  --gray:#94a3b8;

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

.main{ padding:22px 22px 28px; width:100%; }
.topbar{
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:12px;
  margin-bottom:14px;
}
.title h2{ margin:0; font-size:22px; font-weight:950; }
.title p{ margin:6px 0 0; color:var(--muted); font-weight:700; font-size:13px; }

.card{
  border-radius: var(--radius);
  background: var(--card2);
  border:1px solid var(--stroke);
  box-shadow: var(--shadow);
  backdrop-filter: blur(18px);
  overflow:hidden;
  width:100%;
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

.alert{
  border-radius:18px;
  padding:12px 14px;
  margin: 0 0 14px 0;
  font-weight:900;
  width: 100%;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  animation: fadeSlide .35s ease;
}
.alert.success{
  border:1px solid rgba(52,211,153,0.45);
  background: rgba(52,211,153,0.16);
  color: var(--ok);
}
.alert.error{
  border:1px solid rgba(251,113,133,0.45);
  background: rgba(251,113,133,0.16);
  color: var(--bad);
}
.alert button{
  border:none;
  cursor:pointer;
  border-radius:12px;
  padding:6px 10px;
  background: rgba(255,255,255,0.08);
  color: var(--text);
  font-weight:900;
}
@keyframes fadeSlide{
  from{opacity:0; transform:translateY(-10px);}
  to{opacity:1; transform:translateY(0);}
}

/* Table */
.tableWrap{
  width:100%;
  overflow:auto;
  border-radius:18px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.04);
}
table{
  width:100%;
  border-collapse:separate;
  border-spacing:0;
  min-width: 980px;
}
th, td{
  padding:12px 12px;
  border-bottom:1px solid rgba(255,255,255,0.10);
  vertical-align:top;
  font-size:13px;
}
th{
  position:sticky;
  top:0;
  background: rgba(255,255,255,0.06);
  backdrop-filter: blur(10px);
  font-size:12px;
  text-transform:uppercase;
  letter-spacing:.08em;
  color: rgba(234,242,255,0.80);
}
tr:hover td{
  background: rgba(34,211,238,0.06);
}
small{ color: var(--muted); font-weight:750; }

/* Badges */
.badge{
  display:inline-block;
  padding:5px 10px;
  border-radius:999px;
  font-size:11px;
  font-weight:950;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
}
.badge.CONFIRMED{ border-color: rgba(34,211,238,0.35); background: rgba(34,211,238,0.14); }
.badge.PENDING{ border-color: rgba(245,158,11,0.45); background: rgba(245,158,11,0.16); }
.badge.CANCELLED{ border-color: rgba(251,113,133,0.55); background: rgba(251,113,133,0.16); }
.badge.CHECKED_IN{ border-color: rgba(52,211,153,0.45); background: rgba(52,211,153,0.14); }
.badge.CHECKED_OUT{ border-color: rgba(148,163,184,0.35); background: rgba(148,163,184,0.12); }

/* Actions */
.actions{
  display:flex;
  flex-wrap:wrap;
  gap:8px;
}
.actionBtn{
  text-decoration:none;
  font-weight:950;
  font-size:12px;
  padding:8px 10px;
  border-radius:14px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  color: var(--text);
  transition:.2s ease;
  display:inline-flex;
  align-items:center;
  gap:6px;
  white-space:nowrap;
}
.actionBtn:hover{ transform: translateY(-2px); border-color: rgba(255,255,255,0.22); }
.actionBtn.print{ border-color: rgba(34,211,238,0.35); background: rgba(34,211,238,0.10); }
.actionBtn.edit{ border-color: rgba(124,58,237,0.35); background: rgba(124,58,237,0.10); }
.actionBtn.cancel{ border-color: rgba(251,113,133,0.50); background: rgba(251,113,133,0.12); }

@media (max-width: 980px){
  .app{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(255,255,255,0.10); }
  .sidebar-bottom{ position:static; }
}
</style>
</head>

<body>
<div class="app">

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="brand">
       <div class="logo">
    <img src="<%= request.getContextPath() %>/AllComponents/images/Logo_2.png"
         alt="Ocean View Resort Logo">
</div>
      <div>
        <h1>Reception Desk</h1>
        <p>Ocean View Resort</p>
      </div>
    </div>

    <nav class="nav">
      <a href="<%=request.getContextPath()%>/staff/dashboard">
        <div class="left">Dashboard</div>
       
      </a>

      <a href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp">
        <div class="left">Add Reservation</div>
        
      </a>

      <a href="<%=request.getContextPath()%>/staff/manage-reservations"
         style="border-color: rgba(34,211,238,0.40); background: rgba(34,211,238,0.10);">
        <div class="left">Manage Reservations</div>
        
      </a>

      <a href="<%=request.getContextPath()%>/staff/room-availability">
        <div class="left">Room Availability</div>
       
      </a>
      
      <a href="<%=request.getContextPath()%>/staff/help.jsp">
  <div class="left">Help</div>

</a>
      
    </nav>

    <div class="sidebar-bottom">
      <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
  </aside>

  <!-- Main -->
  <main class="main">

    <div class="topbar">
      <div class="title">
        <h2>Manage Reservations</h2>
        <p>View, edit, cancel, and print reservation bills</p>
      </div>
      <div style="color: var(--muted); font-weight:800; font-size:12px;">
        Total: <%= (list == null ? 0 : list.size()) %>
      </div>
    </div>

    <% if(successMsg != null){ %>
      <div class="alert success" id="msgBox">
        <div> <%= successMsg %></div>
        <button type="button" onclick="closeMsg()">✕</button>
      </div>
    <% } %>

    <% if(error != null){ %>
      <div class="alert error" id="msgBox">
        <div> <%= error %></div>
        <button type="button" onclick="closeMsg()">✕</button>
      </div>
    <% } %>

    <section class="card">
      <div class="cardHead">
        <h3>Reservations List</h3>
        <span>All bookings</span>
      </div>

      <div class="cardBody">
        <div class="tableWrap">
          <table>
            <tr>
              <th>Reservation</th>
              <th>Guest</th>
              <th>Room</th>
              <th>Dates</th>
              <th>Status</th>
              <th>Total (LKR)</th>
              <th>Actions</th>
            </tr>

            <% if(list != null){ for(ReservationDetails r : list){ %>
              <tr>
                <td>
                  <b><%= r.getReservationId() %></b><br>
                  <small><%= r.getCreatedAt() %></small>
                </td>

                <td>
                  <b><%= r.getGuestName() %></b><br>
                  <small><%= r.getGuestContact() %></small><br>
                  <small><%= (r.getGuestEmail() == null || r.getGuestEmail().trim().isEmpty()) ? "-" : r.getGuestEmail() %></small>
                </td>

                <td>
                  <b><%= r.getRoomNumber() %></b><br>
                  <small><%= r.getRoomType() %></small>
                </td>

                <td>
                  <small>IN: <%= r.getCheckInDate() %></small><br>
                  <small>OUT: <%= r.getCheckOutDate() %></small><br>
                  <small>Guests: <%= r.getNumberOfGuests() %></small>
                </td>

                <td>
                  <span class="badge <%= r.getStatus() %>"><%= r.getStatus() %></span>
                </td>

                <td><%= String.format("%,.2f", r.getTotalAmount()) %></td>

                <td>
                  <div class="actions">
                    <a class="actionBtn print" target="_blank"
                      href="<%=request.getContextPath()%>/staff/printBill.jsp?id=<%= r.getReservationId() %>">🧾 Print</a>

                    <a class="actionBtn edit"
                      href="<%=request.getContextPath()%>/staff/editReservation.jsp?id=<%= r.getReservationId() %>">✏ Edit</a>

                    <% if(!"CANCELLED".equals(r.getStatus())){ %>
                      <a class="actionBtn cancel"
                        href="<%=request.getContextPath()%>/staff/cancel-reservation?id=<%= r.getReservationId() %>"
                        onclick="return confirm('Cancel this reservation?')">❌ Cancel</a>
                    <% } %>
                  </div>
                </td>
              </tr>
            <% } } %>

          </table>
        </div>
      </div>
    </section>

  </main>
</div>

<script>
function closeMsg(){
  const box = document.getElementById("msgBox");
  if(!box) return;
  box.style.opacity = "0";
  box.style.transform = "translateY(-10px)";
  setTimeout(()=> box.remove(), 250);
}
setTimeout(closeMsg, 4000);
</script>

</body>
</html>
