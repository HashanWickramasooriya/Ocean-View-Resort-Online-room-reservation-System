<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.entity.ReservationDetails" %>
<%@ page import="com.oceanview.dao.ReservationDAO" %>
<%@ page import="com.oceanview.dao.ReservationDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>

<%
    User staff = (User) session.getAttribute("user");
    if (staff == null || !"STAFF".equals(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String id = request.getParameter("id");
    if (id == null || id.trim().isEmpty()) {
        out.print("Invalid reservation");
        return;
    }

    ReservationDetails r = null;
    try(Connection conn = DBConnection.getConnection()){
        ReservationDAO dao = new ReservationDAOImpl(conn);
        r = dao.getReservationDetailsById(id);
    } catch(Exception e){ e.printStackTrace(); }

    if (r == null) {
        out.print("Reservation not found");
        return;
    }

    LocalDate inDate = LocalDate.parse(String.valueOf(r.getCheckInDate()));
    LocalDate outDate = LocalDate.parse(String.valueOf(r.getCheckOutDate()));

    long nights = ChronoUnit.DAYS.between(inDate, outDate);
    if(nights <= 0) nights = 1;

    double roomBase = r.getRatePerNight() * nights;
    double total = r.getTotalAmount();

    String special = (r.getSpecialRequests() == null) ? "" : r.getSpecialRequests().trim();
    String status = (r.getStatus() == null) ? "UNKNOWN" : r.getStatus().trim();

    String badgeClass = "neutral";
    if ("CONFIRMED".equalsIgnoreCase(status) || "CHECKED_IN".equalsIgnoreCase(status) || "CHECKED_OUT".equalsIgnoreCase(status)) badgeClass = "ok";
    else if ("PENDING".equalsIgnoreCase(status)) badgeClass = "warn";
    else if ("CANCELLED".equalsIgnoreCase(status)) badgeClass = "bad";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill - <%= r.getReservationId() %></title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

<style>

:root{
  --ink:#0B1220;
  --muted:#667085;
  --line:#E7EAF0;
  --paper:#FFFFFF;
  --soft:#F6F8FF;

  --brand:#1D4ED8;
  --brand2:#22D3EE;

  --ok:#16A34A;
  --warn:#D97706;
  --bad:#DC2626;
  --neutral:#334155;
}

*{box-sizing:border-box}
body{
  margin:0;
  font-family: "Inter", system-ui, -apple-system, Segoe UI, Roboto, Arial;
  background:#0B1220;
  padding:22px;
}

.wrap{
  max-width: 980px;
  margin: 0 auto;
}


.actions{
  display:flex;
  justify-content:flex-end;
  gap:10px;
  margin-bottom:12px;
}
.btn{
  border:none;
  border-radius: 12px;
  padding: 10px 14px;
  font-weight: 800;
  cursor:pointer;
  transition:.2s ease;
}
.btn:active{ transform: translateY(1px); }
.btnBack{
  background: rgba(255,255,255,0.10);
  color:#fff;
  border:1px solid rgba(255,255,255,0.16);
}
.btnBack:hover{ background: rgba(255,255,255,0.14); }
.btnPrint{
  color:#081026;
  background: linear-gradient(135deg, var(--brand2), var(--brand));
}
.btnPrint:hover{ filter:saturate(1.15); transform: translateY(-1px); }

.paper{
  background: var(--paper);
  border-radius: 18px;
  overflow:hidden;
  border:1px solid rgba(15,23,42,0.08);
}


.accent{
  height: 10px;
  background: linear-gradient(90deg, var(--brand), var(--brand2));
}


.header{
  padding:18px 22px;
  display:flex;
  justify-content:space-between;
  gap:16px;
  border-bottom: 1px solid var(--line);
}
.brandBox h1{
  margin:0;
  font-size:20px;
  font-weight: 950;
  color: var(--ink);
}
.brandBox p{
  margin:6px 0 0;
  color: var(--muted);
  font-weight: 700;
  font-size: 12px;
}
.meta{
  text-align:right;
  font-size:12px;
  color: var(--muted);
  font-weight: 700;
}
.meta b{ color: var(--ink); }


.badge{
  display:inline-flex;
  align-items:center;
  gap:8px;
  margin-top:10px;
  padding:6px 10px;
  border-radius: 999px;
  border:1px solid var(--line);
  font-weight: 900;
  font-size: 12px;
}
.dot{ width:8px;height:8px;border-radius:999px;background: var(--neutral); }
.badge.ok{ color:var(--ok); border-color: rgba(22,163,74,0.25); background: rgba(22,163,74,0.08); }
.badge.ok .dot{ background:var(--ok); }
.badge.warn{ color:var(--warn); border-color: rgba(217,119,6,0.25); background: rgba(217,119,6,0.10); }
.badge.warn .dot{ background:var(--warn); }
.badge.bad{ color:var(--bad); border-color: rgba(220,38,38,0.25); background: rgba(220,38,38,0.10); }
.badge.bad .dot{ background:var(--bad); }
.badge.neutral{ color:var(--neutral); background: rgba(51,65,85,0.06); }


.body{
  padding: 18px 22px;
  position:relative;
}


.watermark:after{
  content:"OCEAN VIEW RESORT";
  position:absolute;
  inset:0;
  display:flex;
  align-items:center;
  justify-content:center;
  transform: rotate(-18deg);
  font-weight: 950;
  letter-spacing: .18em;
  font-size: 42px;
  color: rgba(15,23,42,0.05);
  pointer-events:none;
}

.grid{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:12px;
}
@media (max-width: 860px){
  .grid{ grid-template-columns: 1fr; }
  .meta{ text-align:left; }
}

.card{
  border:1px solid var(--line);
  border-radius: 14px;
  padding:14px;
  background: #fff;
}
.row{
  display:grid;
  grid-template-columns: 160px 1fr;
  gap:10px;
  padding:8px 0;
  border-bottom: 1px dashed rgba(0,0,0,0.08);
}
.row:last-child{ border-bottom:none; }
.k{
  color: var(--muted);
  font-weight: 800;
  font-size:12px;
}
.v{
  color: var(--ink);
  font-weight: 900;
  font-size:13px;
}

.tableWrap{
  margin-top: 14px;
  border:1px solid var(--line);
  border-radius: 14px;
  overflow:hidden;
}
table{ width:100%; border-collapse:collapse; }
th, td{
  padding:12px 12px;
  border-bottom:1px solid var(--line);
  font-size:13px;
}
th{
  background: var(--soft);
  color:#3B455A;
  font-weight: 950;
  letter-spacing:.06em;
  text-transform: uppercase;
  font-size: 12px;
}
td{ color: var(--ink); font-weight: 700; }
tr:last-child td{ border-bottom:none; }

.qty{ text-align:center; width:120px; }
.money{ text-align:right; white-space:nowrap; }

.totalBar{
  margin-top: 14px;
  display:flex;
  justify-content:flex-end;
}
.totalBox{
  min-width: 340px;
  border:1px solid var(--line);
  border-radius: 14px;
  background: #F8FAFF;
  padding: 12px 14px;
}
.totalLine{
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:10px;
}
.totalLabel{
  font-weight: 950;
  color: var(--muted);
  font-size: 12px;
}
.totalAmount{
  font-weight: 950;
  font-size: 20px;
  color: var(--ink);
}

.footer{
  border-top: 1px solid var(--line);
  padding: 14px 22px 18px;
  display:flex;
  justify-content:space-between;
  gap:12px;
  font-size:12px;
  color: var(--muted);
  font-weight: 800;
}
.footer b{ color: var(--ink); }

@page { size: A4; margin: 14mm; }


@media print{
  body{ background:#fff !important; padding:0 !important; }
  .actions{ display:none !important; }
  .wrap{ max-width:none !important; }
  .paper{ border:1px solid #ddd !important; }
}
</style>
</head>

<body>
<div class="wrap">

  <div class="actions">
    <button class="btn btnBack" type="button"
      onclick="window.location.href='<%=request.getContextPath()%>/staff/manage-reservations'">
      ← Back
    </button>
    <button class="btn btnPrint" type="button" onclick="window.print()">🖨 Print</button>
  </div>

  <section class="paper">
    <div class="accent"></div>

    <div class="header">
      <div class="brandBox">
        <h1>Ocean View Resort</h1>
        <p>Invoice / Booking Bill • Keep this for your records</p>
      </div>

      <div class="meta">
        Bill No: <b>BILL-<%= r.getReservationId() %></b><br>
        Date: <b><%= LocalDate.now() %></b><br>
        <span class="badge <%= badgeClass %>"><span class="dot"></span> <%= status %></span>
      </div>
    </div>

    <div class="body watermark">

      <div class="grid">
        <div class="card">
          <div class="row"><div class="k">Guest</div><div class="v"><%= r.getGuestName() %></div></div>
          <div class="row"><div class="k">Contact</div><div class="v"><%= r.getGuestContact() %></div></div>
          <div class="row"><div class="k">Email</div><div class="v"><%= (r.getGuestEmail()==null || r.getGuestEmail().trim().isEmpty()) ? "-" : r.getGuestEmail() %></div></div>
        </div>

        <div class="card">
          <div class="row"><div class="k">Reservation ID</div><div class="v"><%= r.getReservationId() %></div></div>
          <div class="row"><div class="k">Room</div><div class="v"><%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</div></div>
          <div class="row"><div class="k">Stay</div><div class="v"><%= r.getCheckInDate() %> → <%= r.getCheckOutDate() %></div></div>
          <div class="row"><div class="k">Nights</div><div class="v"><%= nights %></div></div>
        </div>
      </div>

      <% if(!special.isEmpty()){ %>
        <div class="card" style="margin-top:12px;">
          <div class="row" style="border-bottom:none;">
            <div class="k">Special Requests</div>
            <div class="v"><%= special %></div>
          </div>
        </div>
      <% } %>

      <div class="tableWrap">
        <table>
          <thead>
          <tr>
            <th>Description</th>
            <th class="qty">Qty</th>
            <th class="money">Amount (LKR)</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>Room Charges (Rate × Nights)</td>
            <td class="qty"><%= nights %></td>
            <td class="money"><%= String.format("%,.2f", roomBase) %></td>
          </tr>
          <tr>
            <td>Guests</td>
            <td class="qty"><%= r.getNumberOfGuests() %></td>
            <td class="money">-</td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="totalBar">
        <div class="totalBox">
          <div class="totalLine">
            <div class="totalLabel">Total Payable</div>
            <div class="totalAmount">LKR <%= String.format("%,.2f", total) %></div>
          </div>
        </div>
      </div>

    </div>
 </section>
</div>
</body>
</html>
