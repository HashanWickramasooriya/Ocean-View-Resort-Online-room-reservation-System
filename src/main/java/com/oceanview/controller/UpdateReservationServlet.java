package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Reservation;
import com.oceanview.entity.ReservationDetails;
import com.oceanview.entity.User;
import com.oceanview.util.PricingUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/update-reservation")
public class UpdateReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        User staff = (User) req.getSession().getAttribute("user");
        if (staff == null || !"STAFF".equals(staff.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String reservationId = req.getParameter("reservationId");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");
        String guestsStr = req.getParameter("guests");
        String special = req.getParameter("specialRequests");
        String status = req.getParameter("status");

        if (reservationId == null || checkIn == null || checkOut == null || guestsStr == null) {
            resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp?error=Invalid data");
            return;
        }

        int guests = Integer.parseInt(guestsStr);

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ReservationDAO resDAO = new ReservationDAOImpl(conn);
            BookingCalendarDAO calDAO = new BookingCalendarDAOImpl(conn);

            ReservationDetails old = resDAO.getReservationDetailsById(reservationId);
            if (old == null) {
                conn.rollback();
                resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp?error=Reservation not found");
                return;
            }

            boolean dateChanged =
                    !old.getCheckInDate().toString().equals(checkIn) ||
                    !old.getCheckOutDate().toString().equals(checkOut);

            if (dateChanged) {
               
                calDAO.clearReservationDates(reservationId);

               
                if (!resDAO.isRoomAvailable(old.getRoomId(), checkIn, checkOut)) {
                    conn.rollback();
                    resp.sendRedirect(req.getContextPath() + "/staff/editReservation.jsp?id=" + reservationId + "&error=Room not available for new dates");
                    return;
                }

               
                calDAO.markBookedDates(old.getRoomId(), reservationId, checkIn, checkOut);
            }
            double newTotal = PricingUtil.calculateTotal(old.getRatePerNight(), checkIn, checkOut, guests);

            Reservation r = new Reservation();
            r.setReservationId(reservationId);
            r.setCheckInDate(java.sql.Date.valueOf(checkIn));
            r.setCheckOutDate(java.sql.Date.valueOf(checkOut));
            r.setNumberOfGuests(guests);
            r.setSpecialRequests(special);
            r.setStatus(status);
            r.setTotalAmount(newTotal);
            r.setAdvancePayment(old.getAdvancePayment());

            if (!resDAO.updateReservation(r)) {
                conn.rollback();
                resp.sendRedirect(req.getContextPath() + "/staff/editReservation.jsp?id=" + reservationId + "&error=Update failed");
                return;
            }

            conn.commit();

            req.getSession().setAttribute("successMsg", "Reservation updated: " + reservationId);
            resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
            resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp?error=Update failed");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }
}
