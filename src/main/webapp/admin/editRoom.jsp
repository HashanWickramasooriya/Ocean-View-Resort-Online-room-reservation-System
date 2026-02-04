<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.*,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>

<%
  int id = Integer.parseInt(request.getParameter("id"));
  RoomDAO roomDao = new RoomDAOImpl(DBConnection.getConnection());
  RoomImageDAO imgDao = new RoomImageDAOImpl(DBConnection.getConnection());

  Room room = roomDao.getRoomById(id);
  List<RoomImage> images = imgDao.getImagesByRoomId(id);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Room | Ocean View Resort</title>

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

/* Logout Bottom (ONLY PINK) */
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

/* Fields */
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

/* Full-width */
.span-2{ grid-column: span 2; }
@media (max-width: 980px){ .span-2{ grid-column: span 1; } }

/* Current images */
.section-title{
  margin:18px 0 12px;
  font-size:14px;
  font-weight:950;
  color: var(--text);
}

.gallery{
  display:flex;
  flex-wrap:wrap;
  gap:12px;
}

.image-box{
  width:150px;
  border-radius:18px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.85);
  box-shadow: 0 10px 22px rgba(15,23,42,0.10);
  overflow:hidden;
}

.image-box img{
  width:100%;
  height:110px;
  object-fit:cover;
  display:block;
}

.image-box .img-actions{
  padding:10px;
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:10px;
}

.pill{
  font-size:11px;
  font-weight:950;
  padding:6px 10px;
  border-radius:999px;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(2,132,199,0.08);
  color: rgba(15,23,42,0.75);
}

.delete-link{
  font-size:12px;
  font-weight:950;
  text-decoration:none;
  color: var(--coral);
  padding:6px 10px;
  border-radius:999px;
  border:1px solid rgba(251,113,133,0.35);
  background: rgba(251,113,133,0.12);
}
.delete-link:hover{
  background: rgba(251,113,133,0.18);
}

/* File input */
.file-wrap{
  padding:14px;
  border-radius:16px;
  border:1px dashed rgba(2,132,199,0.35);
  background: rgba(2,132,199,0.06);
}
.file-wrap input[type="file"]{ width:100%; }
.helper{
  margin-top:10px;
  color: rgba(71,85,105,0.90);
  font-weight:700;
  font-size:12px;
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
        <h2>Edit Room</h2>
        <p>Update room details, status, and manage room images.</p>
      </div>
      <a class="back-btn" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">← Back</a>
    </div>

    <div class="card">

      <form action="<%=request.getContextPath()%>/admin/update-room" method="post" enctype="multipart/form-data">
        <input type="hidden" name="roomId" value="<%=room.getRoomId()%>">

        <div class="form-grid">

          <div class="field span-2">
            <label>Room Name</label>
            <input type="text" name="roomName" value="<%=room.getRoomName()%>">
          </div>

          <div class="field">
            <label>Type</label>
            <select name="roomType">
              <option <%=room.getRoomType().equals("STANDARD")?"selected":""%>>STANDARD</option>
              <option <%=room.getRoomType().equals("DELUXE")?"selected":""%>>DELUXE</option>
              <option <%=room.getRoomType().equals("SUITE")?"selected":""%>>SUITE</option>
              <option <%=room.getRoomType().equals("VILLA")?"selected":""%>>VILLA</option>
            </select>
          </div>

          <div class="field">
            <label>Rate (LKR)</label>
            <input type="number" step="0.01" name="rate" value="<%=room.getRatePerNight()%>">
          </div>

          <div class="field">
            <label>Adults</label>
            <input type="number" name="adultCapacity" value="<%=room.getAdultCapacity()%>">
          </div>

          <div class="field">
            <label>Children</label>
            <input type="number" name="childCapacity" value="<%=room.getChildCapacity()%>">
          </div>

          <div class="field span-2">
            <label>Facilities</label>
            <textarea name="facilities"><%=room.getFacilities()%></textarea>
          </div>

          <div class="field span-2">
            <label>Description</label>
            <textarea name="description"><%=room.getDescription()%></textarea>
          </div>

          <div class="field">
            <label>Status</label>
            <select name="status">
              <option <%=room.getStatus().equals("AVAILABLE")?"selected":""%>>AVAILABLE</option>
              <option <%=room.getStatus().equals("MAINTENANCE")?"selected":""%>>MAINTENANCE</option>
              <option <%=room.getStatus().equals("CLEANING")?"selected":""%>>CLEANING</option>
            </select>
          </div>

          <div class="field">
            <label>Room ID</label>
            <input type="text" value="<%=room.getRoomId()%>" disabled>
          </div>

          <div class="field span-2">
            <div class="section-title">Current Images</div>

            <div class="gallery">
              <% for(RoomImage img : images){ %>
                <div class="image-box">
                  <img src="<%=request.getContextPath()%>/<%=img.getImagePath()%>" alt="Room Image">
                  <div class="img-actions">
                    <span class="pill">Image</span>
                    <a class="delete-link"
                       href="<%=request.getContextPath()%>/admin/delete-room-image?imageId=<%=img.getImageId()%>&roomId=<%=room.getRoomId()%>"
                       onclick="return confirm('Delete this image?')">Delete</a>
                  </div>
                </div>
              <% } %>
            </div>

          </div>

          <div class="field span-2">
            <label>Add More Images</label>
            <div class="file-wrap">
              <input type="file" name="images" multiple>
              <div class="helper">Upload additional images if needed (JPG/PNG). You can select multiple files.</div>
            </div>
          </div>

        </div>

        <div class="actions">
          <a class="btn btn-ghost" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">Cancel</a>
          <button class="btn btn-primary" type="submit">Update Room</button>
        </div>

      </form>

    </div>

  </main>

</div>

</body>
</html>
