<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.*,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    RoomDAO roomDao = new RoomDAOImpl(DBConnection.getConnection());
    List<Room> rooms = roomDao.getAllRooms();

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Add Reservation - Step 1 | Ocean View Resort</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

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

*{ box-sizing:border-box; }
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

.main{ padding:22px 22px 28px; }

.topbar{
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:12px;
  margin-bottom:14px;
}
.title h2{ margin:0; font-size:22px; font-weight:950; }
.title p{ margin:6px 0 0; color:var(--muted); font-weight:700; font-size:13px; }

.steps{
  display:flex; gap:8px; align-items:center; flex-wrap:wrap;
  padding:10px 12px;
  border-radius: 999px;
  border:1px solid var(--stroke);
  background: rgba(255,255,255,0.06);
}
.stepPill{
  font-size:12px; font-weight:900;
  padding:6px 10px;
  border-radius: 999px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  color: rgba(234,242,255,0.78);
}
.stepPill.active{
  background: rgba(34,211,238,0.14);
  border-color: rgba(34,211,238,0.35);
  color: var(--text);
}
.stepArrow{ color: rgba(234,242,255,0.55); font-weight:900; }

.alert{
  border-radius:18px;
  padding:12px 14px;
  margin-bottom:14px;
  border:1px solid rgba(251,113,133,0.45);
  background: rgba(251,113,133,0.16);
  font-weight:850;
}

.grid{
  display:grid;
  grid-template-columns: 420px 1fr;
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

label{
  display:block;
  font-weight:850;
  font-size:13px;
  margin:10px 0 6px;
  color: rgba(234,242,255,0.92);
}
input, select, textarea{
  width:100%;
  padding:11px 12px;
  border-radius:16px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  color: var(--text);
  outline:none;
  font-size:14px;
}
input::placeholder, textarea::placeholder{ color: rgba(234,242,255,0.55); }
input:focus, select:focus, textarea:focus{
  border-color: rgba(34,211,238,0.45);
  box-shadow: 0 0 0 3px rgba(34,211,238,0.15);
}
textarea{ resize:vertical; min-height:92px; }

.row2{ display:grid; grid-template-columns: 1fr 1fr; gap:10px; }
.hint{ font-size:12px; color: var(--muted); margin-top:6px; }

.primaryBtn{
  width:100%;
  margin-top:14px;
  padding:12px 14px;
  border:none;
  border-radius:16px;
  cursor:pointer;
  font-weight:950;
  font-size:14px;
  color:#07142B;
  background: linear-gradient(135deg, var(--b), var(--a));
  transition:0.25s ease;
}
.primaryBtn:hover{ transform: translateY(-2px); filter:saturate(1.15); }

.previewTop{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:10px;
  margin-bottom:10px;
}
.box{
  border-radius:18px;
  padding:12px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
  font-size:14px;
  line-height:1.5;
}
.section{
  margin-top:10px;
  border-radius:18px;
  overflow:hidden;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.05);
}
.sectionTitle{
  padding:10px 12px;
  font-weight:950;
  font-size:13px;
  color: rgba(234,242,255,0.92);
  border-bottom:1px solid rgba(255,255,255,0.10);
  background: rgba(255,255,255,0.06);
}
.sectionBody{
  padding:12px;
  max-height:170px;
  overflow:auto;
  font-size:14px;
  color: rgba(234,242,255,0.86);
  white-space:normal;
  line-height:1.55;
}
.fac-list{ margin:0; padding-left:18px; }
.fac-list li{ margin:4px 0; }

.images{
  display:grid;
  grid-template-columns: repeat(auto-fill,minmax(120px,1fr));
  gap:10px;
  padding:12px;
}
.images img{
  width:100%;
  height:90px;
  object-fit:cover;
  border-radius:16px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.05);
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

      <a href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp" style="border-color: rgba(34,211,238,0.40); background: rgba(34,211,238,0.10);">
        <div class="left">Add Reservation</div>
        <span class="tag">Step 1</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/manage-reservations">
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

  <main class="main">

    <div class="topbar">
      <div class="title">
        <h2>Add Reservation</h2>
        <p>Step 1 · Select room and dates</p>
      </div>

      <div class="steps" aria-label="Progress">
        <span class="stepPill active">1 · Room & Dates</span>
        <span class="stepArrow">→</span>
        <span class="stepPill">2 · Guest Details</span>
      </div>
    </div>

    <% if(error != null){ %>
      <div class="alert"><%= error %></div>
    <% } %>

    <div class="grid">

      <!--  LEFT: FORM -->
      <section class="card">
        <div class="cardHead"><h3>Reservation Details</h3><span>Fill required fields</span></div>
        <div class="cardBody">

          <form method="post" action="<%=request.getContextPath()%>/staff/add-reservation-step1">

            <label>Room</label>
            <select name="roomId" id="roomId" required onchange="loadRoom()">
              <option value="">-- Select Room --</option>
              <% for(Room r: rooms){ %>
                <option value="<%=r.getRoomId()%>"><%=r.getRoomNumber()%> - <%=r.getRoomType()%></option>
              <% } %>
            </select>

            <div class="row2">
              <div>
                <label>Check-in</label>
                <input type="text" name="checkIn" id="checkIn" placeholder="YYYY-MM-DD" required>
              </div>
              <div>
                <label>Check-out</label>
                <input type="text" name="checkOut" id="checkOut" placeholder="YYYY-MM-DD" required>
              </div>
            </div>
            <div class="hint">Checkout date must be after check-in.</div>

            <div class="row2">
              <div>
                <label>Guests</label>
                <input type="number" name="guests" min="1" value="1" required>
              </div>
              <div>
                <label>&nbsp;</label>
                <input type="text" value="Auto pricing in next step" disabled style="opacity:0.75;">
              </div>
            </div>

            <label>Special Requests</label>
            <textarea name="specialRequests" rows="4" placeholder="Optional..."></textarea>

            <button type="submit" class="primaryBtn">Next → Guest Details</button>
          </form>

        </div>
      </section>

      <!--  RIGHT: PREVIEW -->
      <section class="card">
        <div class="cardHead"><h3>Room Preview</h3><span>Live details</span></div>
        <div class="cardBody">

          <div class="previewTop">
            <div class="box" id="boxMain">
              <b>Room:</b> - <br>
              <b>Name:</b> -
            </div>
            <div class="box" id="boxRate">
              <b>Rate:</b> - <br>
              <b>Capacity:</b> -
            </div>
          </div>

          <div class="section">
            <div class="sectionTitle">Facilities</div>
            <div class="sectionBody" id="roomFacilities">Select a room…</div>
          </div>

          <div class="section">
            <div class="sectionTitle">Description</div>
            <div class="sectionBody" id="roomDescription">Select a room…</div>
          </div>

          <div class="section">
            <div class="sectionTitle">Images</div>
            <div class="images" id="roomImages"></div>
          </div>

        </div>
      </section>

    </div>
  </main>

</div>

<script>
let booked = [];
let checkInPicker, checkOutPicker;

function initPickers() {
  if (checkInPicker) checkInPicker.destroy();
  if (checkOutPicker) checkOutPicker.destroy();

  checkInPicker = flatpickr("#checkIn", {
    dateFormat: "Y-m-d",
    disable: booked.map(d => new Date(d)),
    minDate: "today",
    onChange: function(selectedDates) {
      if (selectedDates.length) {
        const minOut = new Date(selectedDates[0]);
        minOut.setDate(minOut.getDate() + 1);
        checkOutPicker.set("minDate", minOut);
      }
    }
  });

  checkOutPicker = flatpickr("#checkOut", {
    dateFormat: "Y-m-d",
    disable: booked.map(d => new Date(d)),
    minDate: "today"
  });
}

function renderFacilities(text){
  const facDiv = document.getElementById("roomFacilities");
  facDiv.innerHTML = "";

  if(!text || !text.trim()){
    facDiv.textContent = "-";
    return;
  }

  let items = text.replace(/\r/g,"").split(/,|\n/).map(x => x.trim()).filter(x => x.length > 0);

  const ul = document.createElement("ul");
  ul.className = "fac-list";
  items.forEach(i => {
    const li = document.createElement("li");
    li.textContent = i;
    ul.appendChild(li);
  });
  facDiv.appendChild(ul);
}

async function loadRoom(){
  const roomId = document.getElementById("roomId").value;

  if(!roomId){
    document.getElementById("boxMain").innerHTML = "<b>Room:</b> - <br><b>Name:</b> -";
    document.getElementById("boxRate").innerHTML = "<b>Rate:</b> - <br><b>Capacity:</b> -";
    document.getElementById("roomFacilities").textContent = "Select a room…";
    document.getElementById("roomDescription").textContent = "Select a room…";
    document.getElementById("roomImages").innerHTML = "";
    booked = [];
    initPickers();
    return;
  }

  try{
    const detailsRes = await fetch("<%=request.getContextPath()%>/staff/room-details?roomId=" + roomId);
    if(!detailsRes.ok){
      document.getElementById("roomFacilities").textContent = "❌ Failed to load room details";
      return;
    }
    const room = await detailsRes.json();

    document.getElementById("boxMain").innerHTML =
      "<b>Room:</b> " + (room.roomNumber || "-") + " (" + (room.roomType || "-") + ")<br>" +
      "<b>Name:</b> " + (room.roomName || "-");

    document.getElementById("boxRate").innerHTML =
      "<b>Rate:</b> LKR " + Number(room.rate || 0).toFixed(2) + " / night<br>" +
      "<b>Capacity:</b> Adults " + (room.adultCapacity ?? "-") + " | Children " + (room.childCapacity ?? "-");

    renderFacilities(room.facilities || "");

    document.getElementById("roomDescription").textContent =
      (room.description && room.description.trim()) ? room.description : "-";

    const imagesDiv = document.getElementById("roomImages");
    imagesDiv.innerHTML = "";
    (room.images || []).forEach(p => {
      const img = document.createElement("img");
      img.src = "<%=request.getContextPath()%>/" + p;
      img.alt = "Room image";
      imagesDiv.appendChild(img);
    });

    const bookedRes = await fetch("<%=request.getContextPath()%>/staff/booked-dates?roomId=" + roomId);
    booked = bookedRes.ok ? await bookedRes.json() : [];
    initPickers();

  }catch(e){
    console.error(e);
    document.getElementById("roomFacilities").textContent = "❌ Error loading room";
  }
}

initPickers();
</script>

</body>
</html>
