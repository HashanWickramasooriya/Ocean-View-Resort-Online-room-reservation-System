<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room | Ocean View Resort</title>

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
  font-family: ui-sans-serif, system-ui, Segoe UI, Roboto, Arial;
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

/* ============================= */
/* ✅ SIDEBAR (LIKE SCREENSHOT)  */
/* ============================= */
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

/* Logout Bottom */
.sidebar-bottom{
  margin-top:auto;
  padding-top:18px;
}

/* ✅ ONLY Logout is pink */
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

/* ============================= */
/* ✅ MAIN                        */
/* ============================= */
.main{
  padding:28px;
}

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

/* Form Card */
.card{
  margin-top:22px;
  border-radius:22px;
  background: rgba(255,255,255,0.80);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
  backdrop-filter: blur(14px);
  padding:22px;
}

/* Grid */
.form-grid{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:14px;
}

@media (max-width: 980px){
  .layout{ grid-template-columns: 1fr; }
  .sidebar{ border-right:none; border-bottom:1px solid rgba(15,23,42,0.12); min-height:auto; }
  .form-grid{ grid-template-columns: 1fr; }
}

.field label{
  display:block;
  margin:0 0 6px 4px;
  font-size:12px;
  font-weight:950;
  color: var(--muted);
}

input[type="text"],
input[type="number"],
select,
textarea{
  width:100%;
  padding:12px 12px;
  border-radius:16px;
  border:1px solid rgba(15,23,42,0.14);
  background: rgba(255,255,255,0.92);
  outline:none;
  color: var(--text);
  font-weight:700;
}

textarea{
  min-height:110px;
  resize:vertical;
}

input:focus, select:focus, textarea:focus{
  border-color: rgba(2,132,199,0.55);
  box-shadow: 0 0 0 4px rgba(2,132,199,0.16);
}

/* Full-width rows */
.span-2{ grid-column: span 2; }
@media (max-width: 980px){ .span-2{ grid-column: span 1; } }

/* File input */
.file-wrap{
  padding:14px;
  border-radius:16px;
  border:1px dashed rgba(2,132,199,0.35);
  background: rgba(2,132,199,0.06);
}

.file-wrap input[type="file"]{
  width:100%;
}

/* Actions */
.actions{
  margin-top:16px;
  display:flex;
  gap:12px;
  justify-content:flex-end;
  flex-wrap:wrap;
}

.btn{
  padding:12px 18px;
  border-radius:16px;
  border:none;
  cursor:pointer;
  font-weight:950;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  justify-content:center;
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

/* Small helper */
.helper{
  margin-top:10px;
  color: rgba(71,85,105,0.90);
  font-weight:700;
  font-size:12px;
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
      <a class="active" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">
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
  <main class="main">

    <div class="topbar">
      <div>
        <h2>Add New Room</h2>
        <p>Create a new room with pricing, capacity, details and images.</p>
      </div>
      <a class="back-btn" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">← Back</a>
    </div>

    <div class="card">

      <form action="<%=request.getContextPath()%>/admin/add-room" method="post" enctype="multipart/form-data">

        <div class="form-grid">

          <div class="field">
            <label>Room Number</label>
            <input type="text" name="roomNumber" required>
          </div>

          <div class="field">
            <label>Room Name</label>
            <input type="text" name="roomName" placeholder="Eg: Sea View Deluxe">
          </div>

          <div class="field">
            <label>Type</label>
            <select name="roomType">
              <option>STANDARD</option>
              <option>DELUXE</option>
              <option>SUITE</option>
              <option>VILLA</option>
            </select>
          </div>

          <div class="field">
            <label>Rate (LKR)</label>
            <input type="number" step="0.01" name="rate" placeholder="Eg: 15000.00">
          </div>

          <div class="field">
            <label>Adults</label>
            <input type="number" name="adultCapacity" placeholder="Eg: 2">
          </div>

          <div class="field">
            <label>Children</label>
            <input type="number" name="childCapacity" placeholder="Eg: 1">
          </div>

          <div class="field span-2">
            <label>Facilities</label>
            <textarea name="facilities" placeholder="Eg: WiFi, A/C, TV, Balcony, Mini bar"></textarea>
          </div>

          <div class="field span-2">
            <label>Description</label>
            <textarea name="description" placeholder="Short description about the room..."></textarea>
          </div>

          <div class="field span-2">
            <label>Room Images</label>
            <div class="file-wrap">
              <input type="file" name="images" multiple>
              <div class="helper">You can upload multiple images (JPG/PNG). Recommended: 1200px wide.</div>
            </div>
          </div>

        </div>

        <div class="actions">
          <a class="btn btn-ghost" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">Cancel</a>
          <button class="btn btn-primary" type="submit">Add Room</button>
        </div>

      </form>

    </div>

  </main>

</div>

</body>
</html>
