<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room</title>
</head>
<body>

<h2>Add New Room</h2>

<form action="<%=request.getContextPath()%>/admin/add-room"
      method="post" enctype="multipart/form-data">

Room Number: <input type="text" name="roomNumber" required><br><br>
Room Name: <input type="text" name="roomName"><br><br>

Type:
<select name="roomType">
<option>STANDARD</option>
<option>DELUXE</option>
<option>SUITE</option>
<option>VILLA</option>
</select><br><br>

Rate: <input type="number" step="0.01" name="rate"><br><br>
Adults: <input type="number" name="adultCapacity"><br><br>
Children: <input type="number" name="childCapacity"><br><br>

Facilities:<br>
<textarea name="facilities"></textarea><br><br>

Description:<br>
<textarea name="description"></textarea><br><br>

Room Images: <input type="file" name="images" multiple><br><br>

<button type="submit">Add Room</button>
</form>

</body>
</html>
