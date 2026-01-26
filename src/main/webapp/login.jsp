<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ocean View Resort | Login</title>

<style>
body {font-family: Arial; background:#f2f2f2;}
.login-box {width:350px; margin:100px auto; padding:20px; background:#fff; border-radius:5px; box-shadow:0 0 10px rgba(0,0,0,0.1);}
h2{text-align:center;}
input{width:100%; padding:10px; margin:10px 0;}
button{width:100%; padding:10px; background:#007BFF; color:white; border:none; cursor:pointer;}
.error{color:red; text-align:center;}
</style>
</head>

<body>
<div class="login-box">
<h2>Login</h2>

<% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
<% } %>

<form action="login" method="post">
<input type="text" name="username" placeholder="Username" required />
<input type="password" name="password" placeholder="Password" required />
<button type="submit">Login</button>
</form>
</div>
</body>
</html>
