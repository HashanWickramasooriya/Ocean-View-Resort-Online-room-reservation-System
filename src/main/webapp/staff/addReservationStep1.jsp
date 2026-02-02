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
    body{
        font-family: "Segoe UI", Arial, sans-serif;
        background:#f2f5f9;
        margin:0;
        padding:0;
    }

    .wrapper{
        max-width:1100px;
        margin:30px auto;
        padding:0 16px;
    }

    .card{
        background:#fff;
        border-radius:14px;
        box-shadow:0 10px 25px rgba(0,0,0,0.08);
        overflow:hidden;
    }

    .header{
        padding:18px 22px;
        background:linear-gradient(90deg,#003366,#0059b3);
        color:#fff;
    }
    .header h2{ margin:0; font-size:22px; }

    .content{
        display:grid;
        grid-template-columns: 340px 1fr;
        gap:18px;
        padding:18px;
    }

    .left, .right{
        background:#ffffff;
        border:1px solid #e5e7eb;
        border-radius:12px;
        padding:16px;
    }

    label{
        display:block;
        font-weight:700;
        margin:10px 0 6px;
        color:#111827;
        font-size:14px;
    }

    input, select, textarea{
        width:100%;
        padding:10px 12px;
        border:1px solid #d1d5db;
        border-radius:10px;
        outline:none;
        font-size:14px;
        background:#fff;
    }
    input:focus, select:focus, textarea:focus{
        border-color:#0059b3;
        box-shadow:0 0 0 3px rgba(0,89,179,0.15);
    }

    textarea{ resize:vertical; min-height:90px; }

    .btn{
        width:100%;
        margin-top:14px;
        padding:12px 14px;
        border:none;
        border-radius:10px;
        background:#0059b3;
        color:#fff;
        font-weight:800;
        cursor:pointer;
        font-size:15px;
    }
    .btn:hover{ background:#003366; }

    .error{
        margin:14px 18px 0;
        padding:10px 12px;
        border-radius:10px;
        background:#fdecea;
        color:#b42318;
        font-weight:700;
        border:1px solid #f5c2c7;
    }

    .right h3{
        margin:0 0 10px;
        color:#003366;
        font-size:18px;
    }

    .detail-grid{
        display:grid;
        grid-template-columns: 1fr 1fr;
        gap:12px;
        margin-bottom:10px;
    }

    .detail-box{
        background:#f8fafc;
        border:1px solid #e5e7eb;
        border-radius:12px;
        padding:12px;
        font-size:14px;
        color:#111827;
    }

    .section{
        margin-top:12px;
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:12px;
        overflow:hidden;
    }

    .section-title{
        padding:10px 12px;
        background:#f1f5f9;
        font-weight:800;
        font-size:14px;
        color:#0f172a;
        border-bottom:1px solid #e5e7eb;
    }

    .section-body{
        padding:12px;
        max-height:160px;
        overflow-y:auto;
        font-size:14px;
        color:#111827;
        line-height:1.5;
        white-space:normal;
    }

    .fac-list{
        margin:0;
        padding-left:18px;
    }
    .fac-list li{
        margin:4px 0;
    }

    .images{
        display:grid;
        grid-template-columns: repeat(auto-fill,minmax(110px,1fr));
        gap:10px;
        padding:12px;
    }
    .images img{
        width:100%;
        height:85px;
        object-fit:cover;
        border-radius:10px;
        border:1px solid #e5e7eb;
        background:#f8fafc;
    }

    .hint{
        font-size:12px;
        color:#64748b;
        margin-top:6px;
    }

    @media (max-width: 900px){
        .content{ grid-template-columns: 1fr; }
    }
</style>

</head>
<body>

<div class="wrapper">
    <div class="card">
        <div class="header">
            <h2>Add Reservation (Step 1)</h2>
        </div>

        <% if(error != null){ %>
            <div class="error"><%= error %></div>
        <% } %>

        <div class="content">
            <!-- LEFT FORM -->
            <div class="left">
                <form method="post" action="<%=request.getContextPath()%>/staff/add-reservation-step1">

                    <label>Room</label>
                    <select name="roomId" id="roomId" required onchange="loadRoom()">
                        <option value="">-- Select Room --</option>
                        <% for(Room r: rooms){ %>
                            <option value="<%=r.getRoomId()%>"><%=r.getRoomNumber()%> - <%=r.getRoomType()%></option>
                        <% } %>
                    </select>

                    <label>Check-in</label>
                    <input type="text" name="checkIn" id="checkIn" placeholder="YYYY-MM-DD" required>

                    <label>Check-out</label>
                    <input type="text" name="checkOut" id="checkOut" placeholder="YYYY-MM-DD" required>
                    <div class="hint">Checkout date must be after check-in.</div>

                    <label>Guests</label>
                    <input type="number" name="guests" min="1" value="1" required>

                    <label>Special Requests</label>
                    <textarea name="specialRequests" rows="4" placeholder="Optional..."></textarea>

                    <button type="submit" class="btn">Next → Guest Details</button>
                </form>
            </div>

            <!-- RIGHT PREVIEW -->
            <div class="right">
                <h3>Room Details</h3>

                <div class="detail-grid">
                    <div class="detail-box" id="boxMain">
                        <b>Room:</b> - <br>
                        <b>Name:</b> -
                    </div>
                    <div class="detail-box" id="boxRate">
                        <b>Rate:</b> - <br>
                        <b>Capacity:</b> -
                    </div>
                </div>

                <div class="section">
                    <div class="section-title">Facilities</div>
                    <div class="section-body" id="roomFacilities">Select a room…</div>
                </div>

                <div class="section">
                    <div class="section-title">Description</div>
                    <div class="section-body" id="roomDescription">Select a room…</div>
                </div>

                <div class="section" style="margin-top:12px;">
                    <div class="section-title">Images</div>
                    <div class="images" id="roomImages"></div>
                </div>
            </div>
        </div>
    </div>
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
                const minOut = new Date(selectedDates[0]);
                minOut.setDate(minOut.getDate() + 1);
                checkOutPicker.set("minDate", minOut);
            }
        }
    });

    checkOutPicker = flatpickr("#checkOut", {
        dateFormat: "Y-m-d",
        disable: booked.map(d => new Date(d)),
        minDate: "today"
    });
}

function renderFacilities(text){
    const facDiv = document.getElementById("roomFacilities");
    facDiv.innerHTML = "";

    if(!text || !text.trim()){
        facDiv.textContent = "-";
        return;
    }

    // split by comma OR new line
    let items = text.replace(/\r/g,"").split(/,|\n/).map(x => x.trim()).filter(x => x.length > 0);

    const ul = document.createElement("ul");
    ul.className = "fac-list";
    items.forEach(i => {
        const li = document.createElement("li");
        li.textContent = i;
        ul.appendChild(li);
    });
    facDiv.appendChild(ul);
}

async function loadRoom(){
    const roomId = document.getElementById("roomId").value;

    // reset
    if(!roomId){
        document.getElementById("boxMain").innerHTML = "<b>Room:</b> - <br><b>Name:</b> -";
        document.getElementById("boxRate").innerHTML = "<b>Rate:</b> - <br><b>Capacity:</b> -";
        document.getElementById("roomFacilities").textContent = "Select a room…";
        document.getElementById("roomDescription").textContent = "Select a room…";
        document.getElementById("roomImages").innerHTML = "";
        booked = [];
        initPickers();
        return;
    }

    try{
        // 1) room details
        const detailsRes = await fetch("<%=request.getContextPath()%>/staff/room-details?roomId=" + roomId);
        if(!detailsRes.ok){
            document.getElementById("roomFacilities").textContent = "❌ Failed to load room details";
            return;
        }
        const room = await detailsRes.json();

        document.getElementById("boxMain").innerHTML =
            "<b>Room:</b> " + (room.roomNumber || "-") + " (" + (room.roomType || "-") + ")<br>" +
            "<b>Name:</b> " + (room.roomName || "-");

        document.getElementById("boxRate").innerHTML =
            "<b>Rate:</b> LKR " + Number(room.rate || 0).toFixed(2) + " / night<br>" +
            "<b>Capacity:</b> Adults " + (room.adultCapacity ?? "-") + " | Children " + (room.childCapacity ?? "-");

        renderFacilities(room.facilities || "");

        document.getElementById("roomDescription").textContent =
            (room.description && room.description.trim()) ? room.description : "-";

        const imagesDiv = document.getElementById("roomImages");
        imagesDiv.innerHTML = "";
        (room.images || []).forEach(p => {
            const img = document.createElement("img");
            img.src = "<%=request.getContextPath()%>/" + p;
            img.alt = "Room image";
            imagesDiv.appendChild(img);
        });

        // 2) booked dates
        const bookedRes = await fetch("<%=request.getContextPath()%>/staff/booked-dates?roomId=" + roomId);
        booked = bookedRes.ok ? await bookedRes.json() : [];
        initPickers();

    }catch(e){
        console.error(e);
        document.getElementById("roomFacilities").textContent = "❌ Error loading room";
    }
}

initPickers();
</script>

</body>
</html>
