<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.oceanview.entity.User" %>
<%@ page import="com.oceanview.dao.DashboardDAO" %>
<%@ page import="com.oceanview.dao.DashboardDAOImpl" %>
<%@ page import="com.oceanview.database.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Calendar" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();
    DashboardDAO dashboardDAO = new DashboardDAOImpl(conn);

    // Get current year and previous year for revenue data
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    int previousYear = currentYear - 1;
    
    // Get revenue by month for current year (using existing method)
    Map<String, Double> currentYearRevenue = dashboardDAO.getRevenueByMonth(currentYear);
    
    // Get revenue by month for previous year for comparison
    Map<String, Double> previousYearRevenue = dashboardDAO.getRevenueByMonth(previousYear);
    
    // Get reservation status counts
    Map<String, Integer> statusCounts = dashboardDAO.getReservationStatusCounts();
    
    // Get monthly revenue for dashboard (current month)
    double monthlyRevenue = dashboardDAO.getMonthlyRevenue();
    
    // Get totals
    int totalUsers = dashboardDAO.getTotalUsers();
    int totalRooms = dashboardDAO.getTotalRooms();
    int totalReservations = dashboardDAO.getTotalReservations();
    
    // Calculate some derived metrics
    int confirmedReservations = statusCounts.getOrDefault("CONFIRMED", 0);
    int pendingReservations = statusCounts.getOrDefault("PENDING", 0);
    int cancelledReservations = statusCounts.getOrDefault("CANCELLED", 0);
    int completedReservations = statusCounts.getOrDefault("COMPLETED", 0);
    
    // Calculate average daily rate (simplified)
    double averageDailyRate = totalReservations > 0 ? monthlyRevenue / totalReservations : 15000;
    
    // Calculate occupancy rate (simplified)
    double occupancyRate = totalRooms > 0 ? (confirmedReservations * 100.0) / (totalRooms * 30) : 75;
    if(occupancyRate > 100) occupancyRate = 85; // Cap at reasonable value
    
    // Format months for chart
    StringBuilder months = new StringBuilder();
    StringBuilder currentYearData = new StringBuilder();
    StringBuilder previousYearData = new StringBuilder();
    
    // Month names in order
    String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    
    for (int i = 0; i < monthNames.length; i++) {
        String month = monthNames[i];
        if (i > 0) {
            months.append(",");
            currentYearData.append(",");
            previousYearData.append(",");
        }
        months.append("'").append(month).append("'");
        
        // Get revenue for this month from current year data
        Double currentRevenue = currentYearRevenue.get(month);
        currentYearData.append(currentRevenue != null ? currentRevenue : 0);
        
        // Get revenue for this month from previous year data
        Double previousRevenue = previousYearRevenue.get(month);
        previousYearData.append(previousRevenue != null ? previousRevenue : 0);
    }
    
    // Calculate totals for summary
    double totalRevenueCurrentYear = currentYearRevenue.values().stream().mapToDouble(Double::doubleValue).sum();
    double totalRevenuePreviousYear = previousYearRevenue.values().stream().mapToDouble(Double::doubleValue).sum();
    double revenueGrowth = totalRevenuePreviousYear > 0 ? 
        ((totalRevenueCurrentYear - totalRevenuePreviousYear) / totalRevenuePreviousYear) * 100 : 0;
    
    // Find best month
    String bestMonth = "December";
    double bestMonthRevenue = 0;
    for (Map.Entry<String, Double> entry : currentYearRevenue.entrySet()) {
        if (entry.getValue() > bestMonthRevenue) {
            bestMonthRevenue = entry.getValue();
            bestMonth = entry.getKey();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Revenue Chart | Ocean View Resort</title>
<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
:root{
    --bg:#E0F2FE;
    --card:#FFFFFF;
    --primary:#0284C7;      
    --text:#0F172A;
    --muted:#475569;
    --success:#10B981;
    --warning:#FBBF24;
    --error:#F43F5E;
    --panel: rgba(255,255,255,0.92);
    --panel2: rgba(255,255,255,0.98);
    --border: rgba(15,23,42,0.12);
    --shadow: 0 14px 34px rgba(15,23,42,0.12);
    --radius: 22px;
    --sky:#22c1f0;
}

*{box-sizing:border-box}
body{
    margin:0;
    font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial;
    background:
        radial-gradient(900px 600px at 70% 10%, rgba(2,132,199,0.14), transparent 58%),
        radial-gradient(900px 650px at 20% 90%, rgba(16,185,129,0.08), transparent 60%),
        linear-gradient(180deg, var(--bg), #f8fbff);
    color:var(--text);
    min-height:100vh;
}

.layout{
    display:grid;
    grid-template-columns: 280px 1fr;
    min-height:100vh;
}

/* Sidebar styles - exactly matching dashboard */
.sidebar{
    padding:22px 18px;
    border-right:1px solid rgba(255,255,255,0.14);
    background: linear-gradient(180deg, #0b1f3a, #082036);
    color:#fff;
}
.brand{
    display:flex;
    gap:12px;
    align-items:center;
    padding:10px 10px 18px;
}
.logo{
    width:44px;height:44px;border-radius:16px;
    background: linear-gradient(135deg, var(--primary), var(--sky));
    box-shadow: 0 14px 28px rgba(2,132,199,0.22);
}
.brand h1{
    font-size:16px;
    margin:0;
    font-weight:900;
    color:#fff;
}
.brand p{
    margin:3px 0 0;
    color: rgba(255,255,255,0.72);
    font-size:12px;
    font-weight:700;
}

.nav{
    margin-top:12px;
    display:flex;
    flex-direction:column;
    gap:12px;
}
.nav a{
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:14px 14px;
    border-radius:16px;
    background: rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.12);
    color:#fff;
    text-decoration:none;
    font-weight:800;
}
.nav a:hover{
    background: rgba(2,132,199,0.22);
    border-color: rgba(2,132,199,0.35);
}
.nav a .tag{
    padding:5px 10px;
    border-radius:999px;
    font-size:12px;
    color:rgba(255,255,255,0.78);
    border:1px solid rgba(255,255,255,0.14);
    background: rgba(255,255,255,0.08);
}

.nav a.active {
    background: rgba(2,132,199,0.35);
    border-color: rgba(2,132,199,0.6);
}

.sidebar-bottom{
    position:sticky;
    top: calc(100vh - 100px);
    margin-top:22px;
}
.logo{
    width:70px;
    height:70px;
    border-radius:14px;
    overflow:hidden;
    display:flex;
    align-items:center;
    justify-content:center;
    background: rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.15);
}

.logo img{
    width:100%;
    height:100%;
    object-fit:contain;
}

.logout{
    display:block;
    text-align:center;
    padding:14px;
    border-radius:16px;
    background: rgba(251,113,133,0.22);
    border:1px solid rgba(251,113,133,0.45);
    color:#fff;
    text-decoration:none;
    font-weight:900;
}

.logout:hover{
    background: rgba(251,113,133,0.35);
    border-color: rgba(251,113,133,0.65);
}

/* Content styles */
.content{
    padding:28px;
}

.header-card{
    padding:18px 22px;
    border-radius:22px;
    background: var(--panel2);
    border:1px solid var(--border);
    box-shadow: var(--shadow);
    backdrop-filter: blur(14px);
    margin-bottom:28px;
}
.header-card h2{
    margin:0;
    font-size:22px;
    font-weight:950;
}
.header-card p{
    margin:6px 0 0;
    color:var(--muted);
    font-weight:700;
}

/* Chart container styles */
.chart-container {
    background: rgba(255,255,255,0.82);
    border:1px solid rgba(15,23,42,0.10);
    backdrop-filter: blur(16px);
    box-shadow: var(--shadow);
    border-radius: var(--radius);
    padding: 28px;
    margin-bottom: 28px;
    transition:0.35s;
}

.chart-container:hover {
    transform: translateY(-5px);
    box-shadow: 0 22px 55px rgba(2,132,199,0.20);
    border-color: rgba(2,132,199,0.25);
}

.chart-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24px;
}

.chart-header h3 {
    margin:0;
    font-size:20px;
    font-weight:950;
    color:var(--text);
}

.chart-header span {
    color:var(--muted);
    font-weight:700;
    font-size:14px;
    padding:8px 16px;
    background: rgba(2,132,199,0.08);
    border-radius: 40px;
}

.chart-wrapper {
    position: relative;
    height: 400px;
    width: 100%;
}

/* Stats summary cards */
.stats-summary {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 28px;
}

.summary-card {
    background: rgba(255,255,255,0.82);
    border:1px solid rgba(15,23,42,0.10);
    backdrop-filter: blur(16px);
    box-shadow: var(--shadow);
    border-radius: var(--radius);
    padding: 20px;
    transition:0.35s;
}

.summary-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 22px 55px rgba(2,132,199,0.20);
    border-color: rgba(2,132,199,0.25);
}

.summary-card h4 {
    margin:0 0 10px 0;
    font-size:15px;
    font-weight:950;
    color:var(--muted);
}

.summary-card .value {
    font-size:32px;
    font-weight:950;
    color:#062a4d;
    margin-bottom:5px;
}

.summary-card .trend {
    font-size:13px;
    font-weight:700;
    color:var(--success);
    display: flex;
    align-items: center;
    gap: 5px;
}

.summary-card .trend.negative {
    color: var(--error);
}

/* Status cards */
.status-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    margin-top: 15px;
}

.status-card {
    padding: 15px;
    border-radius: 16px;
    background: rgba(255,255,255,0.9);
    border: 1px solid var(--border);
}

.status-label {
    font-size: 13px;
    font-weight: 700;
    color: var(--muted);
    margin-bottom: 5px;
}

.status-value {
    font-size: 24px;
    font-weight: 950;
    color: #062a4d;
}

.status-card.confirmed { border-left: 4px solid var(--success); }
.status-card.pending { border-left: 4px solid var(--warning); }
.status-card.cancelled { border-left: 4px solid var(--error); }
.status-card.completed { border-left: 4px solid var(--primary); }

@media (max-width: 1050px){
    .layout{ grid-template-columns: 1fr; }
    .sidebar{ border-right:none; border-bottom:1px solid rgba(15,23,42,0.12); }
    .sidebar-bottom{ position:static; }
}

/* Revenue stats */
.revenue-stats {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.stat-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 0;
    border-bottom: 1px solid var(--border);
}

.stat-label {
    font-weight: 700;
    color: var(--muted);
}

.stat-value {
    font-weight: 950;
    color: #062a4d;
    font-size: 18px;
}
</style>
</head>
<body>

<div class="layout">

    <!-- Sidebar - exactly matching dashboard -->
    <aside class="sidebar">
        <div class="brand">
            <div class="logo">
                <img src="<%= request.getContextPath() %>/AllComponents/images/Logo_2.png"
                     alt="Ocean View Resort Logo">
            </div>
            <div>
                <h1>Admin Panel</h1>
                <p>Ocean View Resort</p>
            </div>
        </div>

        <nav class="nav">
            <a href="<%=request.getContextPath()%>/admin/admindashboard.jsp">
                Dashboard 
            </a>
            <a href="<%=request.getContextPath()%>/admin/manageRooms.jsp">
                Rooms 
            </a>
            <a href="<%=request.getContextPath()%>/admin/manageStaff.jsp">
                Staff 
            </a>
            <a href="<%=request.getContextPath()%>/admin/all-reservations">
                Reservations 
            </a>
            <a href="<%= request.getContextPath() %>/admin/revenue-chart" class="active">
                Revenue Chart 
            </a>
        </nav>

        <div class="sidebar-bottom">
            <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="content">

        <div class="header-card">
            <h2>Revenue Analytics</h2>
            <p>Track and analyze your resort's financial performance</p>
        </div>

        <!-- Quick Stats Summary -->
        <div class="stats-summary">
            <div class="summary-card">
                <h4>Total Revenue (<%= currentYear %>)</h4>
                <div class="value">LKR <%= String.format("%,.0f", totalRevenueCurrentYear) %></div>
                <div class="trend <%= revenueGrowth >= 0 ? "" : "negative" %>">
                    <%= revenueGrowth >= 0 ? "↑" : "↓" %> <%= String.format("%.1f", Math.abs(revenueGrowth)) %>% vs previous year
                </div>
            </div>
            <div class="summary-card">
                <h4>Average Monthly Revenue</h4>
                <div class="value">LKR <%= String.format("%,.0f", totalRevenueCurrentYear/12) %></div>
                <div class="trend">Based on <%= currentYear %> data</div>
            </div>
            <div class="summary-card">
                <h4>Best Performing Month</h4>
                <div class="value"><%= bestMonth %></div>
                <div class="trend">LKR <%= String.format("%,.0f", bestMonthRevenue) %></div>
            </div>
            <div class="summary-card">
                <h4>Current Month Revenue</h4>
                <div class="value">LKR <%= String.format("%,.0f", monthlyRevenue) %></div>
                <div class="trend">As of today</div>
            </div>
        </div>

        <!-- Main Chart - Year over Year Comparison -->
        <div class="chart-container">
            <div class="chart-header">
                <h3>Monthly Revenue Comparison</h3>
                <span><%= currentYear %> vs <%= previousYear %></span>
            </div>
            <div class="chart-wrapper">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <!-- Additional Insights -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 28px;">
           
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Reservation Status</h3>
                    <span>Current Distribution</span>
                </div>
                <div class="chart-wrapper" style="height: 300px;">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>

            <!-- Key Metrics -->
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Key Performance Indicators</h3>
                    <span>Hotel Metrics</span>
                </div>
                <div class="status-grid">
                    <div class="status-card confirmed">
                        <div class="status-label">Confirmed</div>
                        <div class="status-value"><%= confirmedReservations %></div>
                    </div>
                    <div class="status-card pending">
                        <div class="status-label">Pending</div>
                        <div class="status-value"><%= pendingReservations %></div>
                    </div>
                    <div class="status-card cancelled">
                        <div class="status-label">Cancelled</div>
                        <div class="status-value"><%= cancelledReservations %></div>
                    </div>
                    <div class="status-card completed">
                        <div class="status-label">Completed</div>
                        <div class="status-value"><%= completedReservations %></div>
                    </div>
                </div>
                
                <div style="margin-top: 20px;">
                    <div class="stat-row">
                        <span class="stat-label">Average Daily Rate (est.)</span>
                        <span class="stat-value">LKR <%= String.format("%,.0f", averageDailyRate) %></span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Occupancy Rate (est.)</span>
                        <span class="stat-value"><%= String.format("%.1f", occupancyRate) %>%</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Total Rooms</span>
                        <span class="stat-value"><%= totalRooms %></span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Total Users</span>
                        <span class="stat-value"><%= totalUsers %></span>
                    </div>
                </div>
            </div>
        </div>

    </main>

</div>

<script>

const ctx = document.getElementById('revenueChart').getContext('2d');
new Chart(ctx, {
    type: 'line',
    data: {
        labels: [<%= months %>],
        datasets: [
            {
                label: '<%= currentYear %> Revenue',
                data: [<%= currentYearData %>],
                borderColor: '#0284C7',
                backgroundColor: 'rgba(2, 132, 199, 0.1)',
                borderWidth: 3,
                pointBackgroundColor: '#0284C7',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7,
                tension: 0.4,
                fill: true
            },
            {
                label: '<%= previousYear %> Revenue',
                data: [<%= previousYearData %>],
                borderColor: '#94a3b8',
                backgroundColor: 'rgba(148, 163, 184, 0.1)',
                borderWidth: 2,
                pointBackgroundColor: '#94a3b8',
                pointBorderColor: '#fff',
                pointBorderWidth: 1,
                pointRadius: 4,
                pointHoverRadius: 6,
                tension: 0.4,
                borderDash: [5, 5],
                fill: false
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return context.dataset.label + ': LKR ' + context.raw.toLocaleString();
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: function(value) {
                        return 'LKR ' + value.toLocaleString();
                    }
                },
                grid: {
                    color: 'rgba(15, 23, 42, 0.06)'
                }
            },
            x: {
                grid: {
                    display: false
                }
            }
        }
    }
});

t
const ctx2 = document.getElementById('statusChart').getContext('2d');
new Chart(ctx2, {
    type: 'doughnut',
    data: {
        labels: ['Confirmed', 'Pending', 'Cancelled', 'Completed'],
        datasets: [{
            data: [
                <%= confirmedReservations %>,
                <%= pendingReservations %>,
                <%= cancelledReservations %>,
                <%= completedReservations %>
            ],
            backgroundColor: [
                '#10B981', 
                '#FBBF24', 
                '#F43F5E', 
                '#0284C7'  
            ],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom',
                labels: {
                    font: {
                        weight: '700',
                        size: 12
                    }
                }
            }
        },
        cutout: '65%'
    }
});
</script>

</body>
</html>