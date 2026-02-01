<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.oceanview.entity.*,com.oceanview.dao.*,com.oceanview.database.DBConnection"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"STAFF".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
RoomDAO roomDao = new RoomDAOImpl(DBConnection.getConnection());
List<Room> rooms = roomDao.getAllRooms();

String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Reservation - Step 1</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<style>
.container{max-width:900px;margin:30px auto;background:#fff;padding:20px;border-radius:10px;}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.room-preview{border:1px solid #ddd;padding:15px;border-radius:10px;}
.room-images img{width:90px;height:70px;object-fit:cover;border-radius:6px;margin:4px;border:1px solid #ccc;}
.error{color:red;font-weight:bold;}
button{padding:10px 16px;background:#0059b3;color:#fff;border:none;border-radius:6px;}
</style>
</head>
<body>

<div class="container">
<h2>Add Reservation (Step 1)</h2>
<% if(error != null){ %><p class="error"><%= error %></p><% } %>

<form method="post" action="<%=request.getContextPath()%>/staff/add-reservation-step1">
<div class="grid">

<div>
    <label>Room</label><br>
    <select name="roomId" id="roomId" required onchange="loadRoom()">
        <option value="">-- Select Room --</option>
        <% for(Room r: rooms){ %>
        <option value="<%=r.getRoomId()%>"><%=r.getRoomNumber()%> - <%=r.getRoomType()%></option>
        <% } %>
    </select><br><br>

    <label>Check-in</label><br>
    <input type="text" name="checkIn" id="checkIn" required><br><br>

    <label>Check-out</label><br>
    <input type="text" name="checkOut" id="checkOut" required><br><br>

    <label>Guests</label><br>
    <input type="number" name="guests" min="1" value="1" required><br><br>

    <label>Special Requests</label><br>
    <textarea name="specialRequests" rows="4"></textarea><br><br>

    <button type="submit">Next → Guest Details</button>
</div>

<div class="room-preview">
    <h3>Room Details</h3>
    <div id="roomText">Select a room to see details.</div>
    <div class="room-images" id="roomImages"></div>
</div>

</div>
</form>
</div>

<script>
let booked = [];
let checkInPicker, checkOutPicker;

function initPickers() {
    if (checkInPicker) checkInPicker.destroy();
    if (checkOutPicker) checkOutPicker.destroy();

    checkInPicker = flatpickr("#checkIn", {
        dateFormat: "Y-m-d",
        disable: booked.map(d => new Date(d)),
        minDate: "today",
        onChange: function(selectedDates) {
            if (selectedDates.length) {
                checkOutPicker.set("minDate", selectedDates[0]);
            }
        }
    });

    checkOutPicker = flatpickr("#checkOut", {
        dateFormat: "Y-m-d",
        disable: booked.map(d => new Date(d)),
        minDate: "today"
    });
}

async function loadRoom() {
    const roomId = document.getElementById("roomId").value;
    if (!roomId) return;

    // room details
    const detailsRes = await fetch("<%=request.getContextPath()%>/staff/room-details?roomId=" + roomId);
    const room = await detailsRes.json();

    document.getElementById("roomText").innerHTML =
        "<b>Room:</b> " + room.roomNumber + " (" + room.roomType + ")<br>" +
        "<b>Name:</b> " + room.roomName + "<br>" +
        "<b>Rate:</b> LKR " + room.rate.toFixed(2) + " / night<br>" +
        "<b>Capacity:</b> Adults " + room.adultCapacity + " | Children " + room.childCapacity + "<br>" +
        "<b>Facilities:</b> " + (room.facilities || "-") + "<br>" +
        "<b>Description:</b> " + (room.description || "-");

    const imagesDiv = document.getElementById("roomImages");
    imagesDiv.innerHTML = "";
    (room.images || []).forEach(p => {
        const img = document.createElement("img");
        img.src = "<%=request.getContextPath()%>/" + p;
        imagesDiv.appendChild(img);
    });

    // booked dates
    const bookedRes = await fetch("<%=request.getContextPath()%>/staff/booked-dates?roomId=" + roomId);
    booked = await bookedRes.json();

    initPickers();
}

initPickers();
</script>

</body>
</html>
