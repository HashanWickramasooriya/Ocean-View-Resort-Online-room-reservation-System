<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.oceanview.entity.User" %>

<%
    // ---------------- ADMIN AUTH CHECK ----------------
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Room | Ocean View Resort</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f2f5f9;
}
.container {
    width: 650px;
    margin: 40px auto;
    background: #ffffff;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}
h2 {
    text-align: center;
    color: #003366;
    margin-bottom: 20px;
}
label {
    font-weight: bold;
    display: block;
    margin-top: 14px;
}
input, select, textarea {
    width: 100%;
    padding: 10px;
    margin-top: 6px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
}
textarea {
    resize: vertical;
}
button {
    margin-top: 25px;
    width: 100%;
    padding: 14px;
    background: #0059b3;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: bold;
    font-size: 15px;
    cursor: pointer;
}
button:hover {
    background: #003366;
}
.preview {
    margin-top: 10px;
}
.preview img {
    width: 100px;
    height: 75px;
    margin: 5px;
    border-radius: 6px;
    object-fit: cover;
    border: 1px solid #ccc;
}
.back-link {
    margin-top: 15px;
    text-align: center;
}
.back-link a {
    text-decoration: none;
    color: #0059b3;
    font-weight: bold;
}
</style>

<script>
function previewImages() {
    const preview = document.getElementById("preview");
    preview.innerHTML = "";

    const files = document.getElementById("images").files;

    if (files.length > 5) {
        alert("Maximum 5 images allowed");
        document.getElementById("images").value = "";
        return;
    }

    for (let i = 0; i < files.length; i++) {
        const img = document.createElement("img");
        img.src = URL.createObjectURL(files[i]);
        preview.appendChild(img);
    }
}
</script>

</head>

<body>

<div class="container">

<h2>Add New Room</h2>

<form action="<%=request.getContextPath()%>/admin/add-room"
      method="post"
      enctype="multipart/form-data">

    <!-- Room Number -->
    <label>Room Number *</label>
    <input type="text" name="roomNumber" placeholder="e.g. 101" required>

    <!-- Room Name -->
    <label>Room Name</label>
    <input type="text" name="roomName" placeholder="e.g. Ocean View Deluxe">

    <!-- Room Type -->
    <label>Room Type *</label>
    <select name="roomType" required>
        <option value="">-- Select Room Type --</option>
        <option value="STANDARD">STANDARD</option>
        <option value="DELUXE">DELUXE</option>
        <option value="SUITE">SUITE</option>
        <option value="VILLA">VILLA</option>
    </select>

    <!-- Rate -->
    <label>Rate Per Night (LKR) *</label>
    <input type="number" name="ratePerNight" step="0.01" min="0" required>

    <!-- Capacity -->
    <label>Capacity *</label>
    <input type="number" name="capacity" min="1" value="2" required>

    <!-- Description -->
    <label>Description</label>
    <textarea name="description" rows="3"
              placeholder="Short description about the room"></textarea>

    <!-- Facilities -->
    <label>Facilities</label>
    <textarea name="facilities" rows="3"
              placeholder="WiFi, AC, TV, Mini Bar, Balcony"></textarea>

    <!-- Images -->
    <label>Room Images *</label>
    <input type="file"
           name="images"
           id="images"
           accept="image/png, image/jpeg, image/jpg"
           multiple
           onchange="previewImages()"
           required>

    <div id="preview" class="preview"></div>

    <!-- Status -->
    <label>Status *</label>
    <select name="status" required>
        <option value="AVAILABLE">AVAILABLE</option>
        <option value="MAINTENANCE">MAINTENANCE</option>
        <option value="CLEANING">CLEANING</option>
        <option value="OCCUPIED">OCCUPIED</option>
    </select>

    <button type="submit">Add Room</button>
</form>

<div class="back-link">
    <a href="manageRooms.jsp">← Back to Manage Rooms</a>
</div>

</div>

</body>
</html>
