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

@WebServlet("/staff/checkout")
public class StaffCheckOutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"STAFF".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String reservationId = req.getParameter("reservationId");
        if (reservationId == null || reservationId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO dao = new ReservationDAOImpl(conn);
            dao.markCheckedOut(reservationId.trim());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
    }
}
