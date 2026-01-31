<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.Room,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>

<%
RoomDAO dao = new RoomDAOImpl(DBConnection.getConnection());
List<Room> rooms = dao.getAllRooms();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Rooms</title>
<style>
table{width:100%;border-collapse:collapse;}
th,td{padding:10px;border:1px solid #ccc;}
.btn{padding:6px 10px;background:#0059b3;color:white;text-decoration:none;border-radius:4px;}
.delete{background:red;}
</style>
</head>
<body>

<h2>Manage Rooms</h2>
<a class="btn" href="addRoom.jsp">➕ Add Room</a>
<br><br>

<table>
<tr>
<th>No</th><th>Name</th><th>Type</th><th>Rate</th>
<th>Capacity</th><th>Status</th><th>Actions</th>
</tr>

<% for(Room r : rooms){ %>
<tr>
<td><%= r.getRoomNumber() %></td>
<td><%= r.getRoomName() %></td>
<td><%= r.getRoomType() %></td>
<td>LKR <%= r.getRatePerNight() %></td>
<td><%= r.getAdultCapacity() %> Adults / <%= r.getChildCapacity() %> Kids</td>
<td><%= r.getStatus() %></td>
<td>
<a class="btn" href="editRoom.jsp?id=<%=r.getRoomId()%>">Edit</a>
<a class="btn delete" href="<%=request.getContextPath()%>/admin/delete-room?id=<%=r.getRoomId()%>"
onclick="return confirm('Delete this room?')">Delete</a>
</td>
</tr>
<% } %>
</table>

</body>
</html>
