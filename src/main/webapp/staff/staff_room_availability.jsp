<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oceanview.entity.Room" %>

<html>
<head>
    <title>Room Availability</title>
    <style>
        body{font-family:Arial; margin:20px;}
        .box{max-width:900px; margin:auto;}
        .error{color:red; margin:10px 0;}
        table{width:100%; border-collapse:collapse; margin-top:15px;}
        th,td{border:1px solid #ddd; padding:10px;}
        th{background:#f3f3f3;}
        input,select{padding:8px; margin:5px;}
        button{padding:10px 14px; cursor:pointer;}
    </style>
</head>
<body>
<div class="box">

    <h2>Staff - Room Availability</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form method="get" action="<%=request.getContextPath()%>/staff/room-availability">
        <label>Check In:</label>
        <input type="date" name="checkIn" value="<%= request.getAttribute("checkIn") != null ? request.getAttribute("checkIn") : "" %>" required>

        <label>Check Out:</label>
        <input type="date" name="checkOut" value="<%= request.getAttribute("checkOut") != null ? request.getAttribute("checkOut") : "" %>" required>

        <label>Room Type:</label>
        <select name="roomType">
            <option value="ALL">ALL</option>
            <option value="STANDARD">STANDARD</option>
            <option value="DELUXE">DELUXE</option>
            <option value="SUITE">SUITE</option>
            <option value="VILLA">VILLA</option>
        </select>

        <button type="submit">Search</button>
    </form>

    <%
        List<Room> rooms = (List<Room>) request.getAttribute("rooms");
        if (rooms != null) {
    %>

        <h3>Available Rooms</h3>

        <% if (rooms.isEmpty()) { %>
            <p>No rooms available for selected dates.</p>
        <% } else { %>

        <table>
            <tr>
                <th>Room Number</th>
                <th>Name</th>
                <th>Type</th>
                <th>Rate / Night</th>
                <th>Adult</th>
                <th>Child</th>
                <th>Status</th>
            </tr>

            <% for (Room r : rooms) { %>
            <tr>
                <td><%= r.getRoomNumber() %></td>
                <td><%= r.getRoomName() %></td>
                <td><%= r.getRoomType() %></td>
                <td><%= r.getRatePerNight() %></td>
                <td><%= r.getAdultCapacity() %></td>
                <td><%= r.getChildCapacity() %></td>
                <td><%= r.getStatus() %></td>
            </tr>
            <% } %>
        </table>

        <% } %>

    <% } %>

</div>

<script>
    // keep selected roomType after search
    (function(){
        var selected = "<%= request.getAttribute("roomType") != null ? request.getAttribute("roomType") : "ALL" %>";
        var sel = document.querySelector("select[name='roomType']");
        if(sel) sel.value = selected;
    })();
</script>

</body>
</html>
