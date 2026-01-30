<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.Room, com.oceanview.dao.RoomDAOImpl, com.oceanview.database.DBConnection" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    Room room = null;
    try {
        RoomDAOImpl dao = new RoomDAOImpl(DBConnection.getConnection());
        room = dao.getRoomById(id);
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Room</title>
<style>
body { font-family: Arial, sans-serif; background: #f4f6f8; }
.container { width: 50%; margin: auto; background: white; padding: 20px; margin-top: 30px; border-radius: 6px; }
h2 { text-align: center; }
input, select, textarea, button { width: 100%; padding: 8px; margin-top: 8px; }
button { background: #2ecc71; color: white; border: none; margin-top: 15px; cursor: pointer; }
.back { display: block; margin-top: 10px; text-align: center; }
img { width: 80px; height: 60px; margin: 5px; }
</style>
</head>
<body>

<div class="container">
    <h2>Edit Room</h2>

    <form action="<%=request.getContextPath()%>/EditRoomServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">

        <label>Room Number</label>
        <input type="text" name="roomNumber" value="<%= room.getRoomNumber() %>" required>

        <label>Room Name</label>
        <input type="text" name="roomName" value="<%= room.getRoomName() %>" required>

        <label>Room Type</label>
        <select name="roomType" required>
            <option value="STANDARD" <%= "STANDARD".equals(room.getRoomType()) ? "selected" : "" %>>STANDARD</option>
            <option value="DELUXE" <%= "DELUXE".equals(room.getRoomType()) ? "selected" : "" %>>DELUXE</option>
            <option value="SUITE" <%= "SUITE".equals(room.getRoomType()) ? "selected" : "" %>>SUITE</option>
            <option value="VILLA" <%= "VILLA".equals(room.getRoomType()) ? "selected" : "" %>>VILLA</option>
        </select>

        <label>Rate Per Night (Rs.)</label>
        <input type="number" step="0.01" name="rate" value="<%= room.getRatePerNight() %>" required>

        <label>Capacity</label>
        <input type="number" name="capacity" value="<%= room.getCapacity() %>" required>

        <label>Facilities</label>
        <textarea name="facilities"><%= room.getFacilities() %></textarea>

        <label>Description</label>
        <textarea name="description"><%= room.getDescription() %></textarea>

        <label>Current Images</label>
        <%
            if(room.getImages() != null){
                String[] imgs = room.getImages().split(",");
                for(String img : imgs){
        %>
                    <img src="<%=request.getContextPath()%>/uploads/rooms/<%= img %>" alt="Room Image">
        <%
                }
            }
        %>
        <label>Add New Images</label>
        <input type="file" name="images" multiple>

        <label>Status</label>
        <select name="status">
            <option value="AVAILABLE" <%= "AVAILABLE".equals(room.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
            <option value="MAINTENANCE" <%= "MAINTENANCE".equals(room.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
        </select>

        <button type="submit">Update Room</button>
    </form>

    <a class="back" href="<%=request.getContextPath()%>/admin/rooms.jsp">← Back to Rooms</a>
</div>

</body>
</html>
