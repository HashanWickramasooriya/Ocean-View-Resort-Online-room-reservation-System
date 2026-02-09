<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room | Ocean View Resort</title>

<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
