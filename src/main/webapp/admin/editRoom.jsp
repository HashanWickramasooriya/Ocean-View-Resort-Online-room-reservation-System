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
<title>Edit Room</title>
<style>
body{font-family:Arial;background:#f2f5f9;padding:20px;}
.container{background:white;padding:20px;border-radius:10px;max-width:700px;margin:auto;}
img{width:120px;height:90px;margin:5px;object-fit:cover;border-radius:6px;border:1px solid #ccc;}
.image-box{display:inline-block;text-align:center;margin:5px;}
.delete-link{color:red;font-size:12px;text-decoration:none;}
button{padding:10px 15px;background:#0059b3;color:white;border:none;border-radius:6px;}
</style>
</head>
<body>

<div class="container">
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

<% for(RoomImage img : images){ %>
<div class="image-box">
    <img src="<%=request.getContextPath()%>/<%=img.getImagePath()%>"><br>
    <a class="delete-link"
       href="<%=request.getContextPath()%>/admin/delete-room-image?imageId=<%=img.getImageId()%>&roomId=<%=room.getRoomId()%>"
       onclick="return confirm('Delete this image?')">Delete</a>
</div>
<% } %>

<br><br>
Add More Images: <input type="file" name="images" multiple><br><br>

<button type="submit">Update Room</button>
</form>
</div>

</body>
</html>
