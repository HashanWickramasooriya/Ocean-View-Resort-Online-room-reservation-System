<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.oceanview.entity.*, com.oceanview.dao.*, com.oceanview.database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Rooms List</title>
<style>
body { font-family: Arial; background:#f4f6f8; padding:20px;}
h2 { text-align:center; }
table { width:100%; border-collapse:collapse; margin-top:20px; background:white; }
th, td { border:1px solid #ccc; padding:10px; text-align:center; }
th { background:#2ecc71; color:white; }
a.button { background:#3498db; color:white; padding:5px 10px; text-decoration:none; border-radius:4px;}
a.delete { background:#e74c3c; }
img { width:60px; height:50px; margin:2px; object-fit:cover; }
</style>
</head>
<body>

<h2>Rooms List</h2>
<div style="text-align:right; margin-bottom:10px;">
    <a class="button" href="<%=request.getContextPath()%>/admin/addRoom.jsp">+ Add New Room</a>
</div>

<%
RoomDAOImpl roomDao = new RoomDAOImpl(DBConnection.getConnection());
RoomImageDAO imgDao = new RoomImageDAOImpl(DBConnection.getConnection());
List<Room> rooms = roomDao.getAllRooms();
%>

<table>
<tr>
<th>ID</th>
<th>Number</th>
<th>Name</th>
<th>Type</th>
<th>Rate (Rs.)</th>
<th>Capacity</th>
<th>Facilities</th>
<th>Images</th>
<th>Status</th>
<th>Actions</th>
</tr>

<% for(Room room : rooms){ %>
<tr>
<td><%= room.getRoomId() %></td>
<td><%= room.getRoomNumber() %></td>
<td><%= room.getRoomName() %></td>
<td><%= room.getRoomType() %></td>
<td><%= room.getRatePerNight() %></td>

<td>
Adults: <%= room.getAdultCapacity() %><br>
Children: <%= room.getChildCapacity() %>
</td>

<td><%= room.getFacilities() %></td>

<td>
<%
List<RoomImage> imgs = imgDao.getImagesByRoomId(room.getRoomId());
for(RoomImage img : imgs){
%>
<img src="<%=request.getContextPath()%>/<%=img.getImagePath()%>" alt="Room Image">
<% } %>
</td>

<td><%= room.getStatus() %></td>

<td>
<a class="button" href="<%=request.getContextPath()%>/admin/editRoom.jsp?id=<%= room.getRoomId() %>">Edit</a>
<a class="button delete" href="<%=request.getContextPath()%>/admin/delete-room?id=<%= room.getRoomId() %>"
   onclick="return confirm('Are you sure?')">Delete</a>
</td>
</tr>
<% } %>

</table>

</body>
</html>
