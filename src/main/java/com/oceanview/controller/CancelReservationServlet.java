package com.oceanview.controller;

import com.oceanview.dao.BookingCalendarDAO;
import com.oceanview.dao.BookingCalendarDAOImpl;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User staff = (User) req.getSession().getAttribute("user");
        if (staff == null || !"STAFF".equals(staff.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String reservationId = req.getParameter("id");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ReservationDAO resDAO = new ReservationDAOImpl(conn);
            BookingCalendarDAO calDAO = new BookingCalendarDAOImpl(conn);

            resDAO.cancelReservation(reservationId);
            calDAO.clearReservationDates(reservationId);

            conn.commit();

            req.getSession().setAttribute("successMsg", "Reservation cancelled: " + reservationId);
            resp.sendRedirect(req.getContextPath() + "/staff/manage-reservations");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
            resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp?error=Cancel failed");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }
}
