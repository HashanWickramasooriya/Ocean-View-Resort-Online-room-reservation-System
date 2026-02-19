<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"STAFF".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String error = request.getParameter("error");
String success = request.getParameter("success");

String resId = (String) session.getAttribute("step_reservationId");
if(resId == null){
    response.sendRedirect(request.getContextPath() + "/staff/addReservationStep1.jsp?error=Session expired");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Add Reservation - Step 2 | Ocean View Resort</title>

<style>
:root{
  --bg1:#050B18;
  --bg2:#07142B;
  --card2: rgba(255,255,255,0.10);
  --stroke: rgba(255,255,255,0.14);
  --text:#EAF2FF;
  --muted: rgba(234,242,255,0.70);

  --a:#7C3AED;
  --b:#22D3EE;

  --bad:#fb7185;
  --ok:#34D399;

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

.main{
  padding:22px 22px 28px;
  width: 100%;
}

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
.stepPill.done{
  background: rgba(52,211,153,0.14);
  border-color: rgba(52,211,153,0.35);
  color: var(--text);
}
.stepPill.active{
  background: rgba(34,211,238,0.14);
  border-color: rgba(34,211,238,0.35);
  color: var(--text);
}
.stepArrow{ color: rgba(234,242,255,0.55); font-weight:900; }

.card{
  border-radius: var(--radius);
  background: var(--card2);
  border:1px solid var(--stroke);
  box-shadow: var(--shadow);
  backdrop-filter: blur(18px);
  overflow:hidden;
  width: 100%;
  max-width: none;
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
  margin-bottom:14px;
  font-weight:900;
  width: 100%;
  max-width: none;
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

.metaRow{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-bottom:10px;
}
.metaPill{
  border-radius:999px;
  padding:7px 12px;
  border:1px solid rgba(255,255,255,0.14);
  background: rgba(255,255,255,0.06);
  font-size:12px;
  font-weight:900;
  color: rgba(234,242,255,0.86);
}

.formGrid{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:12px;
}
@media (max-width: 900px){
  .app{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(255,255,255,0.10); }
  .sidebar-bottom{ position:static; }
  .formGrid{ grid-template-columns: 1fr; }
}
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
textarea{ resize:vertical; min-height:96px; }

.actionsRow{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-top:14px;
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

.btnGhost{
  display:inline-block;
  text-decoration:none;
  background: rgba(255,255,255,0.06);
  border:1px solid rgba(255,255,255,0.14);
  color: var(--text);
  padding:12px 14px;
  border-radius:16px;
  font-weight:950;
}
.btnGhost:hover{ transform: translateY(-2px); border-color: rgba(255,255,255,0.22); }

.smallHint{
  margin-top:8px;
  font-size:12px;
  color: var(--muted);
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

      <a href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp"
         style="border-color: rgba(34,211,238,0.40); background: rgba(34,211,238,0.10);">
        <div class="left">Add Reservation</div>
        <span class="tag">Step 2</span>
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
        <h2>Guest Details</h2>
        <p>Step 2 · Complete guest information</p>
      </div>

      <div class="steps">
        <span class="stepPill done">1 · Room & Dates</span>
        <span class="stepArrow">→</span>
        <span class="stepPill active">2 · Guest Details</span>
      </div>
    </div>

    <% if(success != null){ %>
      <div class="alert success" id="msgBox">
        <div> <%= success %></div>
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
        <h3>Reservation Confirmation</h3>
        <span>Almost done</span>
      </div>

      <div class="cardBody">

        <div class="metaRow">
          <div class="metaPill">Reservation ID: <%= resId %></div>
          <div class="metaPill">Staff: <%= user.getFullName() %></div>
        </div>

        <form method="post" action="<%=request.getContextPath()%>/staff/add-reservation-step2">

          <div class="formGrid">
            <div>
              <label>Guest Name</label>
              <input type="text" name="guestName" placeholder="Eg: John Perera" required>
            </div>

            <div>
              <label>Contact Number</label>
              <input type="text" name="contactNumber" placeholder="07X XXX XXXX" required>
            </div>

            <div>
              <label>Email</label>
              <input type="email" name="email" placeholder="Optional">
            </div>

            <div>
              <label>Date of Birth</label>
              <input type="date" name="dob">
            </div>

            <div>
              <label>Nationality</label>
              <input type="text" name="nationality" placeholder="Optional">
            </div>

            <div>
              <label>ID Type</label>
              <select name="idType">
                <option value="PASSPORT">PASSPORT</option>
                <option value="NATIONAL_ID">NATIONAL_ID</option>
                <option value="DRIVING_LICENSE">DRIVING_LICENSE</option>
                <option value="OTHER">OTHER</option>
              </select>
            </div>

            <div style="grid-column: 1 / -1;">
              <label>Address</label>
              <textarea name="address" placeholder="Guest address" required></textarea>
            </div>

            <div style="grid-column: 1 / -1;">
              <label>ID Number</label>
              <input type="text" name="idNumber" placeholder="Optional">
            </div>
          </div>

          <div class="actionsRow">
            <a class="btnGhost" href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp">Back</a>
            <button type="submit" class="btn btnPrimary">Submit Reservation</button>
          </div>

         

        </form>

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
