<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.entity.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Help Center | Ocean View Resort</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg,#eef3f8,#dbeafe);
    margin: 0;
}

.header {
    background: linear-gradient(90deg,#003366,#0059b3);
    color: white;
    padding: 28px;
    text-align: center;
    box-shadow: 0 4px 20px rgba(0,0,0,0.2);
}

.header h1 { margin:0; font-weight:600; }
.header p { margin: 6px 0 0; opacity: .95; }

.container {
    max-width: 1100px;
    margin: 30px auto;
    padding: 20px;
}

.card {
    background: rgba(255,255,255,0.75);
    backdrop-filter: blur(10px);
    border-radius: 14px;
    padding: 22px;
    margin-bottom: 20px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
    transform: translateY(-4px);
    box-shadow: 0 16px 35px rgba(0,0,0,0.15);
}

.card h2 {
    margin-top: 0;
    color: #003366;
    display:flex;
    align-items:center;
    gap:10px;
}

.card p {
    margin: 10px 0 0;
    color: #333;
    line-height: 1.7;
}

.card ul {
    padding-left: 20px;
    color:#333;
    line-height:1.7;
    margin: 12px 0 0;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit,minmax(300px,1fr));
    gap: 18px;
}

.badge {
    display:inline-block;
    background:#e0edff;
    color:#003366;
    padding:4px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
    margin-bottom: 10px;
}

.note {
    background:#fff9e6;
    border-left:6px solid #f4c95d;
}

.btnrow {
    margin-top: 25px;
    display:flex;
    gap:12px;
    flex-wrap:wrap;
}

.btn {
    padding:12px 18px;
    border-radius:8px;
    text-decoration:none;
    font-weight:600;
    color:white;
    background:#0059b3;
    transition: background .3s;
    display:inline-flex;
    align-items:center;
    gap:10px;
}

.btn:hover { background:#003366; }

.btn.secondary {
    background:#6c757d;
}
.btn.secondary:hover { background:#565e64; }

.footer-note {
    text-align:center;
    color:#555;
    margin-top:25px;
    font-size:14px;
}

/* ================= FAQ ACCORDION (Modern) ================= */

.faq-wrap {
    margin-top: 12px;
}

.faq-item {
    border-radius: 14px;
    overflow: hidden;
    margin-bottom: 14px;
    background: rgba(255,255,255,0.80);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(0,0,0,0.08);
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
    transition: all 0.25s ease;
}

/* ACTIVE Highlight */
.faq-item.active {
    border: 2px solid #0059b3;
    box-shadow: 0 14px 35px rgba(0,89,179,0.25);
}

/* Question Button */
.faq-q {
    width: 100%;
    background: transparent;
    border: none;
    cursor: pointer;
    padding: 18px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-family: inherit;
    text-align: left;
    transition: background 0.25s ease;
}

/* Hover effect */
.faq-q:hover {
    background: rgba(0,89,179,0.07);
}

/* Left side */
.faq-q-left {
    display: flex;
    align-items: center;
    gap: 12px;
}

.faq-q-left i {
    font-size: 18px;
    color: #0059b3;
}

/* Question Title */
.faq-title {
    font-weight: 600;
    color: #003366;
    font-size: 15px;
}

/* Arrow */
.faq-arrow {
    color: #0059b3;
    transition: transform 0.3s ease;
    font-size: 16px;
}

/* Answer Box */
.faq-a {
    max-height: 0;
    overflow: hidden;
    padding: 0 20px;
    transition: max-height 0.5s ease, padding 0.4s ease;
}

/* Answer Text */
.faq-a ul {
    margin: 12px 0 18px;
    padding-left: 22px;
    color: #333;
    line-height: 1.8;
    font-size: 14px;
}

/* OPEN State */
.faq-item.active .faq-a {
    max-height: 500px;
    padding: 0 20px 15px;
}

/* Rotate arrow */
.faq-item.active .faq-arrow {
    transform: rotate(180deg);
}
</style>
</head>

<body>

<div class="header">
    <h1><i class="fa-solid fa-circle-info"></i> Help & User Guide</h1>
    <p>Ocean View Resort Reservation System</p>
</div>

<div class="container">

    <div class="card note">
        <h2><i class="fa-solid fa-bell"></i> System Purpose</h2>
        <p>
            This reservation system helps Ocean View Resort staff manage guest bookings efficiently.
            Each booking is stored with a unique reservation number to avoid conflicts and delays.
        </p>
    </div>

    <div class="grid">

        <div class="card">
            <span class="badge">1. Login</span>
            <h2><i class="fa-solid fa-user-lock"></i> User Authentication</h2>
            <ul>
                <li>Enter your username and password to access the system.</li>
                <li>Only STAFF accounts can access staff pages.</li>
                <li>If login fails, confirm credentials or contact admin.</li>
            </ul>
        </div>

        <div class="card">
            <span class="badge">2. Add Reservation</span>
            <h2><i class="fa-solid fa-calendar-plus"></i> Create Booking</h2>
            <ul>
                <li>Select a room and choose check-in / check-out dates.</li>
                <li>Booked dates are disabled automatically in the calendar.</li>
                <li>Enter guest details and confirm before saving.</li>
            </ul>
        </div>

        <div class="card">
            <span class="badge">3. Display Reservation</span>
            <h2><i class="fa-solid fa-magnifying-glass"></i> View Reservation Details</h2>
            <ul>
                <li>Search by reservation number to locate a booking.</li>
                <li>System will show guest info, room info, and stay dates.</li>
                <li>Verify the details before check-in or billing.</li>
            </ul>
        </div>

        <div class="card">
            <span class="badge">4. Billing</span>
            <h2><i class="fa-solid fa-file-invoice-dollar"></i> Calculate & Print Bill</h2>
            <ul>
                <li>Total nights = (check-out date - check-in date).</li>
                <li>Total amount = nights × room rate.</li>
                <li>Use print option to generate receipt for the guest.</li>
            </ul>
        </div>

    </div>

    <div class="card">
        <span class="badge">Rules</span>
        <h2><i class="fa-solid fa-triangle-exclamation"></i> Reservation Guidelines</h2>
        <ul>
            <li>Check-out date must be after check-in date.</li>
            <li>Do not exceed room capacity (adults/children).</li>
            <li>Always confirm room availability before saving.</li>
            <li>Ensure database uses UTF-8 for correct text display.</li>
        </ul>
    </div>

    <!-- FAQ Accordion -->
    <div class="card note">
        <h2><i class="fa-solid fa-circle-question"></i> Frequently Asked Questions (FAQ)</h2>

        <div class="faq-wrap" id="faqWrap">

            <!-- FAQ 1 (OPEN BY DEFAULT) -->
            <div class="faq-item active">
                <button type="button" class="faq-q">
                    <div class="faq-q-left">
                        <i class="fa-solid fa-bed"></i>
                        <span class="faq-title">Room details or images are not loading. What should I check?</span>
                    </div>
                    <i class="fa-solid fa-chevron-down faq-arrow"></i>
                </button>
                <div class="faq-a">
                    <ul>
                        <li>Check <b>/staff/room-details</b> returns valid JSON.</li>
                        <li>Confirm image files exist in <b>uploads/rooms/</b>.</li>
                        <li>Open browser console and check for <b>404</b> errors.</li>
                    </ul>
                </div>
            </div>

            <!-- FAQ 2 -->
            <div class="faq-item">
                <button type="button" class="faq-q">
                    <div class="faq-q-left">
                        <i class="fa-solid fa-calendar-xmark"></i>
                        <span class="faq-title">Booked dates are not disabled in calendar.</span>
                    </div>
                    <i class="fa-solid fa-chevron-down faq-arrow"></i>
                </button>
                <div class="faq-a">
                    <ul>
                        <li>Ensure <b>/staff/booked-dates</b> returns: ["YYYY-MM-DD","YYYY-MM-DD"]</li>
                        <li>Call <b>initPickers()</b> after loading booked dates.</li>
                        <li>Verify booking table contains correct dates.</li>
                    </ul>
                </div>
            </div>

            <!-- FAQ 3 -->
            <div class="faq-item">
                <button type="button" class="faq-q">
                    <div class="faq-q-left">
                        <i class="fa-solid fa-file-invoice"></i>
                        <span class="faq-title">Billing amount looks incorrect. Why?</span>
                    </div>
                    <i class="fa-solid fa-chevron-down faq-arrow"></i>
                </button>
                <div class="faq-a">
                    <ul>
                        <li>Confirm check-in/check-out dates are correct.</li>
                        <li>Total nights should be at least <b>1</b> night.</li>
                        <li>Confirm the room rate in DB matches your expected rate.</li>
                    </ul>
                </div>
            </div>

            <!-- FAQ 4 -->
            <div class="faq-item">
                <button type="button" class="faq-q">
                    <div class="faq-q-left">
                        <i class="fa-solid fa-database"></i>
                        <span class="faq-title">Database connection failed. How to fix?</span>
                    </div>
                    <i class="fa-solid fa-chevron-down faq-arrow"></i>
                </button>
                <div class="faq-a">
                    <ul>
                        <li>Make sure MySQL is running on port <b>3306</b>.</li>
                        <li>Check DB name is <b>ocean_view_resort</b>.</li>
                        <li>Verify username/password inside <b>DBConnection.java</b>.</li>
                        <li>Ensure MySQL connector JAR is added to project libraries.</li>
                    </ul>
                </div>
            </div>

            <!-- FAQ 5 -->
            <div class="faq-item">
                <button type="button" class="faq-q">
                    <div class="faq-q-left">
                        <i class="fa-solid fa-user-shield"></i>
                        <span class="faq-title">System redirects to login repeatedly.</span>
                    </div>
                    <i class="fa-solid fa-chevron-down faq-arrow"></i>
                </button>
                <div class="faq-a">
                    <ul>
                        <li>After login, ensure you store session user:</li>
                        <li><b>session.setAttribute("user", userObj)</b></li>
                        <li>Role must match exactly: <b>STAFF</b></li>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    <div class="btnrow">
        <a class="btn" href="<%=request.getContextPath()%>/staff/dashboard.jsp">
            <i class="fa-solid fa-house"></i> Back to Dashboard
        </a>
        <a class="btn secondary" href="<%=request.getContextPath()%>/logout">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>

    <div class="footer-note">Ocean View Resort • Staff Help Center</div>

</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const wrap = document.getElementById("faqWrap");
    if (!wrap) return;

    const items = wrap.querySelectorAll(".faq-item");
    if (!items.length) return;

    // ✅ Ensure first FAQ is open (already has active class)
    items.forEach(item => {
        const btn = item.querySelector(".faq-q");
        btn.addEventListener("click", () => {

            // Close all except clicked
            items.forEach(x => {
                if (x !== item) x.classList.remove("active");
            });

            // Toggle clicked
            item.classList.toggle("active");
        });
    });
});
</script>

</body>
</html>
