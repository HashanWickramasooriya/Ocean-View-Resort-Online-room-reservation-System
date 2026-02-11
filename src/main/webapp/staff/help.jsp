<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Help Center | Ocean View Resort</title>

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

/* Sidebar */
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

/* Main */
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

.grid{
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap:14px;
  margin-top:14px;
}

.badge{
  display:inline-block;
  padding:6px 10px;
  border-radius:999px;
  font-size:11px;
  font-weight:950;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.06);
  color: rgba(234,242,255,0.86);
  margin-bottom:10px;
}

.noteBox{
  border-radius:18px;
  border:1px solid rgba(245,158,11,0.35);
  background: rgba(245,158,11,0.10);
  padding:12px 14px;
  font-weight:850;
  color: rgba(234,242,255,0.90);
}

ul{ margin:10px 0 0; padding-left:18px; color: rgba(234,242,255,0.88); }
li{ margin:6px 0; color: rgba(234,242,255,0.86); line-height:1.6; }
.small{ color: var(--muted); font-size:12px; font-weight:800; line-height:1.6; }

.btnRow{
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
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:8px;
}
.btnPrimary{
  color:#07142B;
  background: linear-gradient(135deg, var(--b), var(--a));
}
.btnPrimary:hover{ transform: translateY(-2px); filter:saturate(1.15); }
.btnGhost{
  background: rgba(255,255,255,0.06);
  border:1px solid rgba(255,255,255,0.14);
  color: var(--text);
}
.btnGhost:hover{ transform: translateY(-2px); border-color: rgba(255,255,255,0.22); }

/* FAQ accordion */
.faq-item{
  border-radius:18px;
  border:1px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.05);
  overflow:hidden;
  margin-top:10px;
}
.faq-q{
  width:100%;
  background: transparent;
  border:none;
  cursor:pointer;
  padding:14px 14px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  text-align:left;
  color: var(--text);
  font-weight:950;
}
.faq-q:hover{ background: rgba(34,211,238,0.06); }
.faq-a{
  max-height:0;
  overflow:hidden;
  padding:0 14px;
  transition:max-height .35s ease, padding .3s ease;
}
.faq-item.active .faq-a{
  max-height:520px;
  padding:0 14px 12px;
}
.arrow{
  opacity:.85;
  transition: transform .25s ease;
}
.faq-item.active .arrow{ transform: rotate(180deg); }

.footerNote{
  margin-top:14px;
  text-align:center;
  color: var(--muted);
  font-size:12px;
  font-weight:800;
}

/* Responsive */
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
      <div class="logo"></div>
      <div>
        <h1>Reception Desk</h1>
        <p>Ocean View Resort</p>
      </div>
    </div>

    <nav class="nav">
      <a href="<%=request.getContextPath()%>/staff/dashboard">
        <div class="left">Dashboard</div>
        <span class="tag">Home</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/addReservationStep1.jsp">
        <div class="left">Add Reservation</div>
        <span class="tag">Create</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/manage-reservations">
        <div class="left">Manage Reservations</div>
        <span class="tag">Manage</span>
      </a>

      <a href="<%=request.getContextPath()%>/staff/room-availability">
        <div class="left">Room Availability</div>
        <span class="tag">Check</span>
      </a>

      <!-- ACTIVE -->
      <a href="<%=request.getContextPath()%>/staff/help.jsp"
         style="border-color: rgba(34,211,238,0.40); background: rgba(34,211,238,0.10);">
        <div class="left">Help</div>
        <span class="tag">Support</span>
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
        <h2>Help Center</h2>
        <p>Guides, rules, and quick troubleshooting for staff</p>
      </div>
      <div class="small">
        Staff: <b><%= user.getFullName() %></b>
      </div>
    </div>

    <div class="card">
      <div class="cardHead">
        <h3>System Purpose</h3>
        <span>Overview</span>
      </div>
      <div class="cardBody">
        <div class="noteBox">
          This reservation system helps Ocean View Resort staff manage bookings efficiently.
          Each booking is stored with a unique reservation number to avoid conflicts and delays.
        </div>
      </div>
    </div>

    <div class="grid">

      <div class="card">
        <div class="cardBody">
          <div class="badge">1 · Login</div>
          <h3 style="margin:0;">User Authentication</h3>
          <ul>
            <li>Enter your username and password to access the system.</li>
            <li>Only STAFF accounts can access staff pages.</li>
            <li>If login fails, confirm credentials or contact admin.</li>
          </ul>
        </div>
      </div>

      <div class="card">
        <div class="cardBody">
          <div class="badge">2 · Add Reservation</div>
          <h3 style="margin:0;">Create Booking</h3>
          <ul>
            <li>Select a room and choose check-in / check-out dates.</li>
            <li>Booked dates are disabled automatically in the calendar.</li>
            <li>Enter guest details and confirm before saving.</li>
          </ul>
        </div>
      </div>

      <div class="card">
        <div class="cardBody">
          <div class="badge">3 · Manage Reservations</div>
          <h3 style="margin:0;">Edit / Cancel / Print</h3>
          <ul>
            <li>Use <b>Manage Reservations</b> to edit dates and guest count.</li>
            <li>Cancel bookings when guests request cancellation.</li>
            <li>Print bill for checkout using the Print action.</li>
          </ul>
        </div>
      </div>

      <div class="card">
        <div class="cardBody">
          <div class="badge">4 · Room Availability</div>
          <h3 style="margin:0;">Find Free Rooms</h3>
          <ul>
            <li>Search by date range and room type to find free rooms.</li>
            <li>Use <b>Add Reservation</b> button from results to book quickly.</li>
            <li>Double-check dates before confirming.</li>
          </ul>
        </div>
      </div>

    </div>

    <div class="card" style="margin-top:14px;">
      <div class="cardHead">
        <h3>Reservation Guidelines</h3>
        <span>Rules</span>
      </div>
      <div class="cardBody">
        <ul>
          <li>Check-out date must be after check-in date.</li>
          <li>Do not exceed room capacity (adults/children).</li>
          <li>Always confirm room availability before saving.</li>
          <li>For check-in/out, confirm reservation status first.</li>
        </ul>
      </div>
    </div>

    <!-- ✅ UPDATED FAQ QUESTIONS/ANSWERS -->
    <div class="card" style="margin-top:14px;">
      <div class="cardHead">
        <h3>Frequently Asked Questions</h3>
        <span>FAQ</span>
      </div>

      <div class="cardBody">

        <div class="faq-item active">
          <button type="button" class="faq-q">
            <span>How do I create a new reservation quickly?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>Go to <b>Add Reservation</b> from the sidebar.</li>
              <li>Select the room, check-in and check-out dates (Step 1).</li>
              <li>Click <b>Next</b>, enter guest details (Step 2), then <b>Submit</b>.</li>
            </ul>
          </div>
        </div>

        <div class="faq-item">
          <button type="button" class="faq-q">
            <span>What should I do if the guest wants to change dates?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>Open <b>Manage Reservations</b>.</li>
              <li>Click <b>Edit</b> for that reservation.</li>
              <li>Update dates and guests, then click <b>Update Reservation</b>.</li>
              <li>If dates conflict with another booking, select a different room/date.</li>
            </ul>
          </div>
        </div>

        <div class="faq-item">
          <button type="button" class="faq-q">
            <span>Why can’t I select some dates when booking?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>Those dates are already booked for the selected room.</li>
              <li>The calendar disables booked dates automatically.</li>
              <li>Try a different room or adjust the date range.</li>
            </ul>
          </div>
        </div>

        <div class="faq-item">
          <button type="button" class="faq-q">
            <span>How do I check rooms available for a date range?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>Open <b>Room Availability</b> from the sidebar.</li>
              <li>Select check-in and check-out dates and room type.</li>
              <li>Click <b>Search</b>.</li>
              <li>Use <b>Add Reservation</b> button from the results table if needed.</li>
            </ul>
          </div>
        </div>

        <div class="faq-item">
          <button type="button" class="faq-q">
            <span>How do I print a bill for checkout?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>Open <b>Manage Reservations</b>.</li>
              <li>Click the 🧾 <b>Print</b> action for the reservation.</li>
              <li>A new tab opens — click <b>Print Bill</b>.</li>
            </ul>
          </div>
        </div>

        <div class="faq-item">
          <button type="button" class="faq-q">
            <span>System keeps redirecting me to login. What should I check?</span>
            <span class="arrow">▾</span>
          </button>
          <div class="faq-a">
            <ul>
              <li>After login, ensure you store the user in session:</li>
              <li><b>session.setAttribute("user", userObj)</b></li>
              <li>Role must match exactly: <b>STAFF</b>.</li>
              <li>Check browser cookies are enabled (session requires cookies).</li>
            </ul>
          </div>
        </div>

      </div>
    </div>

    

  </main>
</div>

<script>
  // FAQ Accordion
  (function(){
    const items = document.querySelectorAll(".faq-item");
    items.forEach(item=>{
      const btn = item.querySelector(".faq-q");
      btn.addEventListener("click", ()=>{
        items.forEach(x => { if(x !== item) x.classList.remove("active"); });
        item.classList.toggle("active");
      });
    });
  })();
</script>

</body>
</html>
