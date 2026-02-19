<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oceanview.entity.Room" %>
<%@ page import="com.oceanview.entity.User" %>

<%
    User staff = (User) session.getAttribute("user");
    if (staff == null || !"STAFF".equals(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");

    String checkInVal = request.getAttribute("checkIn") != null ? String.valueOf(request.getAttribute("checkIn")) : "";
    String checkOutVal = request.getAttribute("checkOut") != null ? String.valueOf(request.getAttribute("checkOut")) : "";
    String roomTypeVal = request.getAttribute("roomType") != null ? String.valueOf(request.getAttribute("roomType")) : "ALL";

    List<Room> rooms = (List<Room>) request.getAttribute("rooms");

    int availableCount = (rooms == null) ? 0 : rooms.size();
    double minRate = -1;
    if (rooms != null) {
        for (Room r : rooms) {
            try{
                double rate = r.getRatePerNight();
                if (minRate < 0 || rate < minRate) minRate = rate;
            }catch(Exception ex){}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Room Availability | Ocean View Resort</title>

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

.kpis{
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap:14px;
  margin-bottom:14px;
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
}
.kpiTop{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
.kpiTitle{ font-weight:900; }
.kpiMeta{
  font-size:12px; font-weight:800;
  color: rgba(234,242,255,0.70);
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  padding:5px 10px; border-radius:999px;
}
.kpiValue{ margin-top:12px; font-size:34px; font-weight:950; }
.kpiHint{ margin-top:4px; color:var(--muted); font-weight:700; font-size:13px; }

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

.filters{
  display:grid;
  grid-template-columns: 1.2fr 1.2fr 1fr 1fr;
  gap:12px;
  align-items:end;
}
@media (max-width: 1050px){
  .filters{ grid-template-columns: 1fr 1fr; }
}
label{
  display:block;
  font-weight:850;
  font-size:13px;
  margin:0 0 6px;
  color: rgba(234,242,255,0.92);
}
input, select{
  width:100%;
  padding:11px 12px;
  border-radius:16px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  color: var(--text);
  outline:none;
  font-size:14px;
}
input:focus, select:focus{
  border-color: rgba(34,211,238,0.45);
  box-shadow: 0 0 0 3px rgba(34,211,238,0.15);
}
.btn{
  border:none;
  border-radius:16px;
  cursor:pointer;
  font-weight:950;
  font-size:14px;
  padding:12px 14px;
  transition:0.25s ease;
}
.btnPrimary{
  color:#07142B;
  background: linear-gradient(135deg, var(--b), var(--a));
}
.btnPrimary:hover{ transform: translateY(-2px); filter:saturate(1.15); }

.controlsRow{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  align-items:center;
  justify-content:space-between;
  margin-top:12px;
}
.searchBox{
  flex: 1 1 280px;
  max-width: 420px;
}
.rightControls{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  align-items:center;
}

.tableWrap{
  width:100%;
  overflow:auto;
  border-radius:18px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.04);
  margin-top:12px;
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
tr:hover td{ background: rgba(34,211,238,0.06); }

.badge{
  display:inline-block;
  padding:5px 10px;
  border-radius:999px;
  font-size:11px;
  font-weight:950;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
}
.badge.AVAILABLE{ border-color: rgba(52,211,153,0.45); background: rgba(52,211,153,0.14); }
.badge.BOOKED{ border-color: rgba(245,158,11,0.45); background: rgba(245,158,11,0.16); }
.badge.MAINTENANCE{ border-color: rgba(251,113,133,0.55); background: rgba(251,113,133,0.16); }

.actions{
  display:flex;
  gap:8px;
  flex-wrap:wrap;
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
.actionBtn.add{ border-color: rgba(34,211,238,0.35); background: rgba(34,211,238,0.10); }

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

      <a href="<%=request.getContextPath()%>/staff/manage-reservations">
        <div class="left">Manage Reservations</div>
       
      </a>

      <a href="<%=request.getContextPath()%>/staff/room-availability"
         style="border-color: rgba(34,211,238,0.40); background: rgba(34,211,238,0.10);">
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
        <h2>Room Availability</h2>
        <p>Search free rooms by date range and type</p>
      </div>
      <div style="color: var(--muted); font-weight:800; font-size:12px;">
        Staff: <%= staff.getFullName() %>
      </div>
    </div>

    <% if(error != null){ %>
      <div class="alert error" id="msgBox">
        <div> <%= error %></div>
        <button type="button" onclick="closeMsg()">✕</button>
      </div>
    <% } %>

    <!-- Search card -->
    <section class="card">
      <div class="cardHead">
        <h3>Search</h3>
        <span>Pick dates</span>
      </div>
      <div class="cardBody">

        <form method="get" action="<%=request.getContextPath()%>/staff/room-availability" id="searchForm">
          <div class="filters">
            <div>
              <label>Check In</label>
              <input type="date" name="checkIn" id="checkIn" value="<%= checkInVal %>" required>
            </div>

            <div>
              <label>Check Out</label>
              <input type="date" name="checkOut" id="checkOut" value="<%= checkOutVal %>" required>
            </div>

            <div>
              <label>Room Type</label>
              <select name="roomType" id="roomType">
                <option value="ALL">ALL</option>
                <option value="STANDARD">STANDARD</option>
                <option value="DELUXE">DELUXE</option>
                <option value="SUITE">SUITE</option>
                <option value="VILLA">VILLA</option>
              </select>
            </div>

            <div>
              <button type="submit" class="btn btnPrimary">Search</button>
            </div>
          </div>
        </form>

        <div class="controlsRow">
          <div class="searchBox">
            <label>Quick Search (in results)</label>
            <input type="text" id="q" placeholder="Search room no / name / type...">
          </div>

          <div class="rightControls">
  <div style="min-width:220px;">
    <label>Sort</label>
    <select id="sortBy">
      <option value="room">Room No (A→Z)</option>
      <option value="rateAsc">Rate (Low→High)</option>
      <option value="rateDesc">Rate (High→Low)</option>
      <option value="adult">Adult Capacity (High→Low)</option>
    </select>
  </div>
</div>
        </div>

      </div>
    </section>

    <% if(rooms != null){ %>

      <div class="kpis">
        <div class="kpi">
          <div class="kpiTop"><div class="kpiTitle">Available Rooms</div><div class="kpiMeta">Results</div></div>
          <div class="kpiValue"><%= availableCount %></div>
          <div class="kpiHint">Rooms matching your date range</div>
        </div>

        <div class="kpi">
          <div class="kpiTop"><div class="kpiTitle">Room Type</div><div class="kpiMeta">Filter</div></div>
          <div class="kpiValue" style="font-size:20px; margin-top:16px;"><%= roomTypeVal %></div>
          <div class="kpiHint">Selected category</div>
        </div>

        <div class="kpi">
          <div class="kpiTop"><div class="kpiTitle">Cheapest Rate</div><div class="kpiMeta">From</div></div>
          <div class="kpiValue"><%= (minRate < 0 ? "-" : String.format("%,.0f", minRate)) %></div>
          <div class="kpiHint">Lowest rate per night</div>
        </div>

        <div class="kpi">
          <div class="kpiTop"><div class="kpiTitle">Date Range</div><div class="kpiMeta">Selected</div></div>
          <div class="kpiValue" style="font-size:16px; margin-top:18px;">
            <%= (checkInVal.isEmpty() ? "-" : checkInVal) %> → <%= (checkOutVal.isEmpty() ? "-" : checkOutVal) %>
          </div>
          <div class="kpiHint">Check-in to check-out</div>
        </div>
      </div>

      <section class="card">
        <div class="cardHead">
          <h3>Available Rooms</h3>
          <span><%= rooms.size() %> found</span>
        </div>
        <div class="cardBody">

          <% if(rooms.isEmpty()){ %>
            <div style="color: var(--muted); font-weight:800;">No rooms available for selected dates.</div>
          <% } else { %>

            <div class="tableWrap">
              <table id="roomsTable">
                <thead>
                  <tr>
                    <th>Room Number</th>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Rate / Night</th>
                    <th>Adult</th>
                    <th>Child</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <% for (Room r : rooms) { %>
                    <tr>
                      <td class="colRoom"><b><%= r.getRoomNumber() %></b></td>
                      <td class="colName"><%= r.getRoomName() %></td>
                      <td class="colType"><%= r.getRoomType() %></td>
                      <td class="colRate"><%= String.format("%,.2f", r.getRatePerNight()) %></td>
                      <td class="colAdult"><%= r.getAdultCapacity() %></td>
                      <td class="colChild"><%= r.getChildCapacity() %></td>
                      <td>
                        <span class="badge <%= r.getStatus() %>"><%= r.getStatus() %></span>
                      </td>
                      <td>
                        <div class="actions">
                          <a class="actionBtn add"
                             href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp?roomId=<%= r.getRoomId() %>&checkIn=<%= checkInVal %>&checkOut=<%= checkOutVal %>">
                             ➕ Add Reservation
                          </a>
                        </div>
                      </td>
                    </tr>
                  <% } %>
                </tbody>
              </table>
            </div>

          <% } %>

        </div>
      </section>

    <% } %>

  </main>
</div>

<script>
  (function(){
    var selected = "<%= roomTypeVal %>";
    var sel = document.getElementById("roomType");
    if(sel) sel.value = selected;
  })();

  function closeMsg(){
    const box = document.getElementById("msgBox");
    if(!box) return;
    box.style.opacity = "0";
    box.style.transform = "translateY(-10px)";
    setTimeout(()=> box.remove(), 250);
  }
  setTimeout(closeMsg, 4000);

  document.getElementById("searchForm")?.addEventListener("submit", function(e){
    const inVal = document.getElementById("checkIn").value;
    const outVal = document.getElementById("checkOut").value;
    if(inVal && outVal && outVal <= inVal){
      e.preventDefault();
      alert("Check-out must be after check-in.");
    }
  });

  const q = document.getElementById("q");
  const sortBy = document.getElementById("sortBy");
  const tbody = document.querySelector("#roomsTable tbody");

  function filterRows(){
    if(!tbody) return;
    const query = (q.value || "").toLowerCase().trim();
    [...tbody.querySelectorAll("tr")].forEach(tr=>{
      const text = tr.innerText.toLowerCase();
      tr.style.display = text.includes(query) ? "" : "none";
    });
  }

  function parseNum(str){
    return parseFloat((str || "").replace(/,/g,"")) || 0;
  }

  function sortRows(){
    if(!tbody) return;
    const rows = [...tbody.querySelectorAll("tr")];

    rows.sort((a,b)=>{
      const mode = sortBy.value;

      const roomA = (a.querySelector(".colRoom")?.innerText || "").trim();
      const roomB = (b.querySelector(".colRoom")?.innerText || "").trim();

      const rateA = parseNum(a.querySelector(".colRate")?.innerText);
      const rateB = parseNum(b.querySelector(".colRate")?.innerText);

      const adultA = parseNum(a.querySelector(".colAdult")?.innerText);
      const adultB = parseNum(b.querySelector(".colAdult")?.innerText);

      if(mode === "rateAsc") return rateA - rateB;
      if(mode === "rateDesc") return rateB - rateA;
      if(mode === "adult") return adultB - adultA;

      return roomA.localeCompare(roomB, undefined, {numeric:true, sensitivity:"base"});
    });

    rows.forEach(r=> tbody.appendChild(r));
  }

  q?.addEventListener("input", filterRows);
  sortBy?.addEventListener("change", function(){ sortRows(); filterRows(); });

  sortRows();
</script>

</body>
</html>
