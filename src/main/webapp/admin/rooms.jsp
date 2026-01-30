<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.oceanview.entity.Room, com.oceanview.dao.RoomDAOImpl, com.oceanview.database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rooms List</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 20px;}
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background: #2ecc71; color: white; }
        a.button { background: #3498db; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px;}
        a.delete { background: #e74c3c; }
        img { width: 60px; height: 50px; margin: 2px; }
    </style>
</head>
<body>
<h2>Rooms List</h2>
<div style="text-align: right; margin-bottom: 10px;">
    <a class="button" href="<%=request.getContextPath()%>/add-room.jsp">+ Add New Room</a>
</div>

<%
    List<Room> rooms = new ArrayList<>();
    try {
        RoomDAOImpl dao = new RoomDAOImpl(DBConnection.getConnection());
        rooms = dao.getAllRooms();
    } catch (Exception e) { e.printStackTrace(); }
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
    <%
        for(Room room : rooms){
    %>
    <tr>
        <td><%= room.getRoomId() %></td>
        <td><%= room.getRoomNumber() %></td>
        <td><%= room.getRoomName() %></td>
        <td><%= room.getRoomType() %></td>
        <td><%= room.getRatePerNight() %></td>
        <td><%= room.getCapacity() %></td>
        <td><%= room.getFacilities() %></td>
        <td>
            <%
                if(room.getImages() != null){
                    String[] imgs = room.getImages().split(",");
                    for(String img : imgs){
                        if(!img.trim().isEmpty()){
            %>
                            <img src="<%=request.getContextPath()%>/uploads/rooms/<%= img %>" alt="Room Image">
            <%
                        }
                    }
                }
            %>
        </td>
        <td><%= room.getStatus() %></td>
        <td>
            <a class="button" href="<%=request.getContextPath()%>/edit-room.jsp?id=<%= room.getRoomId() %>">Edit</a>
            <a class="button delete" href="<%=request.getContextPath()%>/DeleteRoomServlet?id=<%= room.getRoomId() %>"
               onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
    <%
        }
    %>
</table>
</body>
</html>
