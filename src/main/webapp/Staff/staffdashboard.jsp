<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String username = (String)session.getAttribute("username");
if (username == null || !"STAFF".equals(session.getAttribute("role"))) {
    response.sendRedirect("../login.jsp");
}
%>
<h2>Staff Dashboard</h2>
<p>Welcome, <%= username %>!</p>
<a href="../logout">Logout</a>

</body>
</html>