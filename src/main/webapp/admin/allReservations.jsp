<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.entity.ReservationDetails" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<ReservationDetails> reservations =
            (List<ReservationDetails>) request.getAttribute("reservations");
    if (reservations == null) reservations = new ArrayList<>();

    String q = request.getAttribute("q") != null ? (String) request.getAttribute("q") : "";
    String status = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "ALL";
    String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : "";
    String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservations | Ocean View Resort</title>
<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<style>
.main{
  padding:18px 22px 30px;
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
.topbar{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  padding:18px 18px;
  border-radius:20px;
  background: var(--panel);
  border:1px solid var(--border);
  backdrop-filter: blur(14px);
  box-shadow: var(--shadow);
}
.topbar h2{
  margin:0;
  font-size:20px;
  font-weight:950;
  color: var(--text);
}
.topbar .sub{
  margin-top:6px;
  color:var(--muted);
  font-size:13px;
  font-weight:700;
}
.topbar .btn-logout{
  padding:12px 18px;
  border-radius:16px;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.75);
  color:var(--text);
  text-decoration:none;
  font-weight:900;
}
.topbar .btn-logout:hover{
  background: rgba(251,113,133,0.12);
  border-color: rgba(251,113,133,0.25);
}

.card{
  margin-top:18px;
  border-radius:20px;
  background: var(--panel2);
  border:1px solid var(--border);
  backdrop-filter: blur(14px);
  box-shadow: var(--shadow);
  overflow:hidden;
}
.card-head{
  padding:16px 18px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  flex-wrap:wrap;
  border-bottom:1px solid rgba(15,23,42,0.10);
}
.count{
  padding:8px 12px;
  border-radius:999px;
  background: rgba(2,132,199,0.12);
  border:1px solid rgba(2,132,199,0.22);
  color: var(--primary);
  font-weight:900;
}

.filters{
  padding:14px 18px 18px;
}
.grid{
  display:grid;
  grid-template-columns: 1.7fr 0.8fr 0.7fr 0.7fr auto auto;
  gap:12px;
  align-items:end;
}
label{
  display:block;
  margin:0 0 6px 4px;
  font-size:12px;
  font-weight:900;
  color: var(--muted);
}
input, select{
  width:100%;
  padding:12px 12px;
  border-radius:16px;
  border:1px solid rgba(15,23,42,0.12);
  background: #ffffff;
  color:var(--text);
  outline:none;
}
input:focus, select:focus{
  border-color: rgba(2,132,199,0.50);
  box-shadow: 0 0 0 4px rgba(2,132,199,0.18);
}
.btn{
  padding:12px 16px;
  border-radius:16px;
  border:none;
  cursor:pointer;
  font-weight:950;
  color:#fff;
  background: var(--primary);
}
.btn:hover{ filter:brightness(0.97); }
.btn-ghost{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  padding:12px 16px;
  border-radius:16px;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.80);
  color:var(--text);
  text-decoration:none;
  font-weight:950;
}
.btn-ghost:hover{
  background: rgba(251,113,133,0.10);
  border-color: rgba(251,113,133,0.25);
}

.table-wrap{
  overflow:auto;
  border-top:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.55);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
}
table{
  width:100%;
  border-collapse:separate;
  border-spacing:0;
  min-width:1100px;
  background: transparent;
}
thead th{
  position:sticky;
  top:0;
  z-index:2;
  text-align:left;
  padding:14px 14px;
  font-size:12px;
  letter-spacing:0.5px;
  text-transform:uppercase;
  background: rgba(255,255,255,0.70);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-bottom:1px solid rgba(15,23,42,0.10);
  color: var(--text);
}
tbody td{
  padding:14px 14px;
  border-bottom:1px solid rgba(15,23,42,0.08);
  vertical-align:top;
  font-size:14px;
  color: var(--text);
  background: rgba(255,255,255,0.40);
}
tbody tr:hover td{
  background: rgba(2,132,199,0.10);
}

.small{ color:var(--muted); font-size:12px; margin-top:6px; font-weight:700; }
.bold{ font-weight:950; }

.badge{
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:8px 12px;
  border-radius:999px;
  font-weight:950;
  font-size:12px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.70);
}
.dot{ width:9px;height:9px;border-radius:50%; background: var(--warning); }

.b-confirmed{
  background: rgba(16,185,129,0.14);
  border-color: rgba(16,185,129,0.25);
  color: var(--success);
}
.b-confirmed .dot{ background: var(--success); }

.b-pending{
  background: rgba(251,191,36,0.18);
  border-color: rgba(251,191,36,0.35);
  color: #925c00;
}
.b-pending .dot{ background: var(--warning); }

.b-cancelled{
  background: rgba(244,63,94,0.14);
  border-color: rgba(244,63,94,0.25);
  color: var(--error);
}
.b-cancelled .dot{ background: var(--error); }

@media (max-width: 1050px){
  .layout{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(15,23,42,0.12); }
  .grid{ grid-template-columns: 1fr 1fr; }
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
      <a href="<%=request.getContextPath()%>/admin/admindashboard.jsp">Dashboard <span class="tag">Home</span></a>
      <a href="<%=request.getContextPath()%>/admin/manageRooms.jsp">Rooms <span class="tag">Manage</span></a>
      <a href="<%=request.getContextPath()%>/admin/manageStaff.jsp">Staff <span class="tag">Users</span></a>
      <a href="<%=request.getContextPath()%>/admin/all-reservations">Reservations <span class="tag">View</span></a>
    </nav>

    <div class="sidebar-bottom">
      <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
  </aside>

  <main class="main">

    <div class="topbar">
      <div>
        <h2>Reservations</h2>
        <div class="sub">Search reservations, filter by status & date range</div>
      </div>
      <a class="btn-logout" href="<%=request.getContextPath()%>/admin/admindashboard.jsp">Back to Dashboard</a>
    </div>

    <section class="card">
      <div class="card-head">
        <div class="bold">All Reservations</div>
        <div class="count">Total: <%= reservations.size() %></div>
      </div>

      <div class="filters">
        <form method="get" action="<%=request.getContextPath()%>/admin/all-reservations">
          <div class="grid">

            <div>
              <label>Search</label>
              <input type="text" name="q" value="<%= q %>" placeholder="Reservation ID / Name / Room">
            </div>

            <div>
              <label>Status</label>
              <select name="status">
                <option value="ALL" <%= "ALL".equalsIgnoreCase(status) ? "selected" : "" %>>ALL</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(status) ? "selected" : "" %>>CONFIRMED</option>
                <option value="PENDING" <%= "PENDING".equalsIgnoreCase(status) ? "selected" : "" %>>PENDING</option>
                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(status) ? "selected" : "" %>>CANCELLED</option>
              </select>
            </div>

            <div>
              <label>From</label>
              <input type="date" name="fromDate" value="<%= fromDate %>">
            </div>

            <div>
              <label>To</label>
              <input type="date" name="toDate" value="<%= toDate %>">
            </div>

            <button class="btn" type="submit">Search</button>
            <a class="btn-ghost" href="<%=request.getContextPath()%>/admin/all-reservations">Reset</a>

          </div>
        </form>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Reservation</th>
              <th>Guest</th>
              <th>Room</th>
              <th>Dates</th>
              <th>Guests</th>
              <th>Total</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
          <%
            if (reservations.isEmpty()) {
          %>
            <tr>
              <td colspan="7" style="text-align:center; padding:26px; color:rgba(15,23,42,0.65); font-weight:900;">
                No reservations found.
              </td>
            </tr>
          <%
            } else {
              for (ReservationDetails r : reservations) {
                String st = (r.getStatus() != null ? r.getStatus().toUpperCase() : "PENDING");
                String badgeClass = "b-pending";
                if ("CONFIRMED".equals(st)) badgeClass = "b-confirmed";
                else if ("CANCELLED".equals(st)) badgeClass = "b-cancelled";
          %>
            <tr>
              <td>
                <div class="bold"><%= r.getReservationId() %></div>
                 </td>

              <td>
                <div class="bold"><%= r.getGuestName() %></div>
                <div class="small">📞 <%= r.getGuestContact() %></div>
                <div class="small">✉ <%= r.getGuestEmail() %></div>
              </td>

              <td>
                <div class="bold">Room <%= r.getRoomNumber() %></div>
                <div class="small"><%= r.getRoomType() %></div>
                <div class="small">Rate: LKR <%= String.format("%,.2f", r.getRatePerNight()) %></div>
              </td>

              <td>
                <div class="bold"><%= r.getCheckInDate() %></div>
                <div class="small">to</div>
                <div class="bold"><%= r.getCheckOutDate() %></div>
              </td>

              <td class="bold"><%= r.getNumberOfGuests() %></td>

              <td>
                <div class="bold">LKR <%= String.format("%,.2f", r.getTotalAmount()) %></div>
                </td>

              <td>
                <span class="badge <%= badgeClass %>">
                  <span class="dot"></span> <%= st %>
                </span>
              </td>
            </tr>
          <%
              }
            }
          %>
          </tbody>
        </table>
      </div>

    </section>

  </main>
</div>

</body>
</html>
