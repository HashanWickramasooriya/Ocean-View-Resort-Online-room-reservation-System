package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            ReservationDAO dao = new ReservationDAOImpl(conn);

            req.setAttribute("todayCheckIns", dao.countTodayCheckIns());
            req.setAttribute("todayCheckOuts", dao.countTodayCheckOuts());
            req.setAttribute("availableRooms", dao.countAvailableRoomsToday());
            req.setAttribute("pendingRequests", dao.countPendingReservations());
            req.setAttribute("todaySchedule", dao.getTodaySchedule(8));

            req.getRequestDispatcher("/staff/dashboard.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().write("<h2>Database connection error</h2><p>Please try again later.</p>");
        }
    }
}
