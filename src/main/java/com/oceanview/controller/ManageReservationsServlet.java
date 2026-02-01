package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/manage-reservations")
public class ManageReservationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User staff = (User) req.getSession().getAttribute("user");
        if (staff == null || !"STAFF".equals(staff.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO dao = new ReservationDAOImpl(conn);
            req.getSession().setAttribute("reservationList", dao.getAllReservations());
            resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/dashboard.jsp?error=Failed");
        }
    }
}
