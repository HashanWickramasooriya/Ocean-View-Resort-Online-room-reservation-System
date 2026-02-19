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
<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>

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
.span-2{ grid-column: span 2; }
@media (max-width: 980px){ .span-2{ grid-column: span 1; } }

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

  <main class="main">

    <div class="topbar">
      <div>
        <h2>Edit Room</h2>
        <p>Update room details, status, and manage room images.</p>
      </div>
      <a class="back-btn" href="<%=request.getContextPath()%>/admin/manageRooms.jsp">Back</a>
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
