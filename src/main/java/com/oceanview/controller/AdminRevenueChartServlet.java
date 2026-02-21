package com.oceanview.controller;

import com.oceanview.dao.DashboardDAO;
import com.oceanview.dao.DashboardDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.time.Year;
import java.util.Map;

@WebServlet("/admin/revenue-chart")
public class AdminRevenueChartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User admin = (User) req.getSession().getAttribute("user");

        // Security check
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int year = Year.now().getValue();

        try (Connection conn = DBConnection.getConnection()) {

            DashboardDAO dao = new DashboardDAOImpl(conn);

            // Get revenue data
            Map<String, Double> revenueData =
                    dao.getRevenueByMonth(year);

            // Get reservation status counts
            Map<String, Integer> statusData =
                    dao.getReservationStatusCounts();

            // Set attributes
            req.setAttribute("revenueData", revenueData);
            req.setAttribute("statusData", statusData);
            req.setAttribute("year", year);

            req.getRequestDispatcher("/admin/revenueChart.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/admin/admindashboard.jsp?error=ReportFailed");
        }
    }
}