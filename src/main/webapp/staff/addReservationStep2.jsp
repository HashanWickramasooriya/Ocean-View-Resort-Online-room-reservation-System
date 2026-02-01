<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"STAFF".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
String error = request.getParameter("error");

String resId = (String) session.getAttribute("step_reservationId");
if(resId == null){
    response.sendRedirect(request.getContextPath() + "/staff/addReservationStep1.jsp?error=Session expired");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Reservation - Step 2</title>
<style>
.container{max-width:650px;margin:30px auto;background:#fff;padding:20px;border-radius:10px;}
label{display:block;margin-top:10px;font-weight:bold;}
input,select,textarea{width:100%;padding:8px;margin-top:5px;border:1px solid #ccc;border-radius:6px;}
button{margin-top:15px;padding:10px 16px;background:#0059b3;color:#fff;border:none;border-radius:6px;}
.error{color:red;font-weight:bold;}
</style>
</head>
<body>

<div class="container">
<h2>Guest Details (Step 2)</h2>
<p><b>Reservation ID:</b> <%= resId %></p>
<% if(error != null){ %><p class="error"><%= error %></p><% } %>

<form method="post" action="<%=request.getContextPath()%>/staff/add-reservation-step2">

<label>Guest Name</label>
<input type="text" name="guestName" required>

<label>Address</label>
<textarea name="address" required></textarea>

<label>Contact Number</label>
<input type="text" name="contactNumber" required>

<label>Email</label>
<input type="email" name="email">

<label>Date of Birth</label>
<input type="date" name="dob">

<label>Nationality</label>
<input type="text" name="nationality">

<label>ID Type</label>
<select name="idType">
    <option value="PASSPORT">PASSPORT</option>
    <option value="NATIONAL_ID">NATIONAL_ID</option>
    <option value="DRIVING_LICENSE">DRIVING_LICENSE</option>
    <option value="OTHER">OTHER</option>
</select>

<label>ID Number</label>
<input type="text" name="idNumber">

<button type="submit">Submit Reservation</button>

</form>
</div>
</body>
</html>
