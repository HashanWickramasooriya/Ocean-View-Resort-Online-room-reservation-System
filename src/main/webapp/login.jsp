<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ocean View Resort | Staff Login</title>

<%@ include file="/AllComponents/css/AllCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
</head>

<body>

<div class="ov-galileo ov-staff">
  <span class="ov-blob ov-blob-1"></span>
  <span class="ov-blob ov-blob-2"></span>
  <span class="ov-blob ov-blob-3"></span>

  <div class="ov-shell">
    <div class="ov-topbar">
      <div class="ov-top-left">
        <div class="ov-mini-logo"><i class="fa-solid fa-water"></i></div>
        <span class="ov-mini-brand">Ocean View Resort</span>
      </div>

      <div class="ov-top-links d-none d-md-flex">
        <span class="ov-pill"><i class="fa-solid fa-user-shield"></i> Staff Portal</span>
      </div>

      <div class="ov-top-menu d-md-none">
        <span class="ov-pill"><i class="fa-solid fa-user-shield"></i></span>
      </div>
    </div>

    <div class="ov-grid">
      <!-- Left info panel -->
      <div class="ov-left">
        <div class="ov-brand-big">
          <div class="ov-logo-big"><i class="fa-solid fa-hotel"></i></div>
          <div>
            <h2 class="ov-hotel">Staff Login</h2>
            <p class="ov-sub">Admin • Reception</p>
          </div>
        </div>

        <h1 class="ov-headline">Manage the resort operations.</h1>
        <p class="ov-desc">
          Sign in to access booking management, guest check-in/check-out, room availability,
          and administrative controls. This portal is restricted to authorized staff only.
        </p>

        <div class="ov-badges">
          <span><i class="fa-solid fa-shield-heart"></i> Secure Access</span>
          <span><i class="fa-solid fa-clipboard-check"></i> Front Desk</span>
          <span><i class="fa-solid fa-gear"></i> Admin Tools</span>
        </div>
      </div>

      <!-- Right login card -->
      <div class="ov-right">
        <div class="ov-card">

          <div class="ov-card-header">
            <p class="ov-small-title">OCEAN VIEW RESORT</p>
            <p class="ov-small-sub">Staff Sign In</p>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error mb-3"><%= request.getAttribute("error") %></div>
          <% } %>

          <form action="<%= request.getContextPath() %>/login" method="post" autocomplete="off">

            <!-- ✅ Role selection -->
            <div class="ov-role">
              <input type="radio" name="role" id="roleAdmin" value="ADMIN" checked>
              <label for="roleAdmin"><i class="fa-solid fa-user-tie"></i> Admin</label>

              <input type="radio" name="role" id="roleReception" value="RECEPTION">
              <label for="roleReception"><i class="fa-solid fa-user-tie"></i> Reception</label>
            </div>

            <div class="ov-field">
              <label for="username">Username</label>
              <div class="ov-input">
                <i class="fa-regular fa-user"></i>
                <input id="username" type="text" name="username" placeholder="Enter staff username" required>
              </div>
            </div>

            <div class="ov-field">
              <label for="password">Password</label>
              <div class="ov-input">
                <i class="fa-solid fa-lock"></i>
                <input id="password" type="password" name="password" placeholder="Enter password" required>
                <button type="button" class="ov-eye" onclick="togglePassword()">
                 
                </button>
              </div>
            </div>

            <button class="ov-btn" type="submit">
              Sign In <i class="fa-solid fa-arrow-right"></i>
            </button>

            <div class="ov-footnote">
              <i class="fa-solid fa-circle-info"></i>
              Only Admin & Reception accounts are allowed.
            </div>

          </form>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  function togglePassword(){
    const pwd = document.getElementById("password");
    const icon = document.getElementById("eyeIcon");
    if(pwd.type === "password"){
      pwd.type = "text";
      icon.className = "fa-regular fa-eye-slash";
    } else {
      pwd.type = "password";
      icon.className = "fa-regular fa-eye";
    }
  }
</script>

</body>
</html>
