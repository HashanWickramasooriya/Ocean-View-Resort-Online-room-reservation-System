<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.Room,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>

<%
int id = Integer.parseInt(request.getParameter("id"));
RoomDAO dao = new RoomDAOImpl(DBConnection.getConnection());
Room room = dao.getRoomById(id);
List<String> images = dao.getRoomImages(id);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Room</title>
<style>
img{width:120px;height:90px;margin:5px;object-fit:cover;}
</style>
</head>
<body>

<h2>Edit Room</h2>

<form action="<%=request.getContextPath()%>/admin/update-room"
      method="post" enctype="multipart/form-data">

<input type="hidden" name="roomId" value="<%=room.getRoomId()%>">

Room Name: <input type="text" name="roomName" value="<%=room.getRoomName()%>"><br><br>

Type:
<select name="roomType">
<option <%=room.getRoomType().equals("STANDARD")?"selected":""%>>STANDARD</option>
<option <%=room.getRoomType().equals("DELUXE")?"selected":""%>>DELUXE</option>
<option <%=room.getRoomType().equals("SUITE")?"selected":""%>>SUITE</option>
<option <%=room.getRoomType().equals("VILLA")?"selected":""%>>VILLA</option>
</select><br><br>

Rate: <input type="number" step="0.01" name="rate" value="<%=room.getRatePerNight()%>"><br><br>

Adults: <input type="number" name="adultCapacity" value="<%=room.getAdultCapacity()%>"><br><br>
Children: <input type="number" name="childCapacity" value="<%=room.getChildCapacity()%>"><br><br>

Facilities:<br>
<textarea name="facilities"><%=room.getFacilities()%></textarea><br><br>

Description:<br>
<textarea name="description"><%=room.getDescription()%></textarea><br><br>

Status:
<select name="status">
<option <%=room.getStatus().equals("AVAILABLE")?"selected":""%>>AVAILABLE</option>
<option <%=room.getStatus().equals("MAINTENANCE")?"selected":""%>>MAINTENANCE</option>
<option <%=room.getStatus().equals("CLEANING")?"selected":""%>>CLEANING</option>
</select><br><br>

<h3>Current Images</h3>
<% for(String img : images){ %>
<img src="<%=request.getContextPath()%>/<%=img%>">
<% } %>

<br><br>
Add More Images: <input type="file" name="images" multiple><br><br>

<button type="submit">Update Room</button>
</form>

</body>
</html>
