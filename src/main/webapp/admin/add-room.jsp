<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room</title>
<style>
body { font-family: Arial, sans-serif; background: #f4f6f8; }
.container { width: 50%; margin: auto; background: white; padding: 20px; margin-top: 30px; border-radius: 6px; }
h2 { text-align: center; }
input, select, textarea, button { width: 100%; padding: 8px; margin-top: 8px; }
button { background: #2ecc71; color: white; border: none; margin-top: 15px; cursor: pointer; }
.back { display: block; margin-top: 10px; text-align: center; }
</style>
</head>
<body>

<div class="container">
    <h2>Add New Room</h2>

    <form action="<%=request.getContextPath()%>/AddRoomServlet" method="post" enctype="multipart/form-data">

        <label>Room Number</label>
        <input type="text" name="roomNumber" required>

        <label>Room Name</label>
        <input type="text" name="roomName" required>

        <label>Room Type</label>
        <select name="roomType" required>
            <option value="">-- Select Type --</option>
            <option value="STANDARD">STANDARD</option>
            <option value="DELUXE">DELUXE</option>
            <option value="SUITE">SUITE</option>
            <option value="VILLA">VILLA</option>
        </select>

        <label>Rate Per Night (Rs.)</label>
        <input type="number" step="0.01" name="rate" required>

        <label>Capacity</label>
        <input type="number" name="capacity" required>

        <label>Facilities</label>
        <textarea name="facilities" placeholder="AC, WiFi, TV, Mini Bar"></textarea>

        <label>Description</label>
        <textarea name="description"></textarea>

        <label>Room Images</label>
        <input type="file" name="images" multiple>

        <label>Status</label>
        <select name="status">
            <option value="AVAILABLE">AVAILABLE</option>
            <option value="MAINTENANCE">MAINTENANCE</option>
        </select>

        <button type="submit">Add Room</button>
    </form>

    <a class="back" href="<%=request.getContextPath()%>/admin/rooms.jsp">← Back to Rooms</a>
</div>

</body>
</html>
