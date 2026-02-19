package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Guest;
import com.oceanview.entity.Reservation;
import com.oceanview.entity.Room;
import com.oceanview.entity.User;
import com.oceanview.util.EmailUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/add-reservation-step2")
public class AddReservationStep2Servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        User staff = (User) req.getSession().getAttribute("user");
        if (staff == null || !"STAFF".equals(staff.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        HttpSession session = req.getSession();

        String reservationId = (String) session.getAttribute("step_reservationId");
        Integer roomId       = (Integer) session.getAttribute("step_roomId");
        String checkIn       = (String) session.getAttribute("step_checkIn");
        String checkOut      = (String) session.getAttribute("step_checkOut");
        Integer guestsCount  = (Integer) session.getAttribute("step_guests");
        String special       = (String) session.getAttribute("step_special");
        Double total         = (Double) session.getAttribute("step_total");

        if (reservationId == null || roomId == null || checkIn == null || checkOut == null || guestsCount == null || total == null) {
            resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep1.jsp?error=Session expired. Please try again.");
            return;
        }

        Guest g = new Guest();
        g.setGuestName(req.getParameter("guestName"));
        g.setAddress(req.getParameter("address"));
        g.setContactNumber(req.getParameter("contactNumber"));
        g.setEmail(req.getParameter("email"));
        g.setNationality(req.getParameter("nationality"));
        g.setIdType(req.getParameter("idType"));
        g.setIdNumber(req.getParameter("idNumber"));

        String dob = req.getParameter("dob");
        if (dob != null && !dob.trim().isEmpty()) {
            g.setDateOfBirth(java.sql.Date.valueOf(dob));
        }

        if (g.getGuestName() == null || g.getGuestName().trim().isEmpty()
                || g.getAddress() == null || g.getAddress().trim().isEmpty()
                || g.getContactNumber() == null || g.getContactNumber().trim().isEmpty()
                || g.getEmail() == null || g.getEmail().trim().isEmpty()) {

            resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp?error=Please fill required guest details");
            return;
        }

        Connection conn = null;
        int guestId;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            GuestDAO guestDAO = new GuestDAOImpl(conn);
            ReservationDAO resDAO = new ReservationDAOImpl(conn);
            BookingCalendarDAO calDAO = new BookingCalendarDAOImpl(conn);

            if (!resDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
                conn.rollback();
                resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep1.jsp?error=Room became unavailable");
                return;
            }

            guestId = guestDAO.getGuestIdByContactAndEmail(g.getContactNumber(), g.getEmail());

            if (guestId == 0) {
                guestId = guestDAO.createGuest(g);
                if (guestId == 0) {
                    conn.rollback();
                    resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp?error=Guest create failed");
                    return;
                }
            } else {
                g.setGuestId(guestId);
                guestDAO.updateGuest(g);
            }

            Reservation r = new Reservation();
            r.setReservationId(reservationId);
            r.setGuestId(guestId);
            r.setRoomId(roomId);
            r.setCheckInDate(java.sql.Date.valueOf(checkIn));
            r.setCheckOutDate(java.sql.Date.valueOf(checkOut));
            r.setNumberOfGuests(guestsCount);
            r.setSpecialRequests(special);
            r.setStatus("CONFIRMED");
            r.setTotalAmount(total);
            r.setAdvancePayment(0.0);
            r.setCreatedBy(staff.getUserId());

            if (!resDAO.createReservation(r)) {
                conn.rollback();
                resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp?error=Reservation failed");
                return;
            }

            if (!calDAO.markBookedDates(roomId, reservationId, checkIn, checkOut)) {
                conn.rollback();
                resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp?error=Calendar booking failed");
                return;
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
            resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp?error=Failed");
            return;

        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }

        Room room = null;
        try (Connection conn2 = DBConnection.getConnection()) {
            RoomDAO roomDAO = new RoomDAOImpl(conn2);
            room = roomDAO.getRoomById(roomId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            if (room != null) {
                String subject = "Ocean View Resort - Booking Confirmed (" + reservationId + ")";

                String html =
                        "<!DOCTYPE html>" +
                        "<html><body style='font-family:Arial,Helvetica,sans-serif;background:#f4f6f8;padding:20px;'>" +
                        "  <div style='max-width:650px;margin:auto;background:#ffffff;border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,0.12);overflow:hidden;'>" +
                        "    <div style='background:linear-gradient(90deg,#003366,#0059b3);padding:18px;color:#fff;text-align:center;'>" +
                        "      <h2 style='margin:0;'>Ocean View Resort</h2>" +
                        "      <p style='margin:6px 0 0;'>Booking Confirmed </p>" +
                        "    </div>" +
                        "    <div style='padding:18px;'>" +
                        "      <p style='margin:0 0 14px;'>Hello <b>" + escapeHtml(g.getGuestName()) + "</b>, your reservation is confirmed.</p>" +
                        "      <div style='background:#f7fafc;border:1px solid #e5e7eb;border-radius:10px;padding:14px;'>" +
                        "        <p style='margin:6px 0;'><b>Reservation ID:</b> " + escapeHtml(reservationId) + "</p>" +
                        "        <p style='margin:6px 0;'><b>Room:</b> " + escapeHtml(room.getRoomNumber()) + " (" + escapeHtml(room.getRoomType()) + ")</p>" +
                        "        <p style='margin:6px 0;'><b>Check-in:</b> " + escapeHtml(checkIn) + "</p>" +
                        "        <p style='margin:6px 0;'><b>Check-out:</b> " + escapeHtml(checkOut) + "</p>" +
                        "        <p style='margin:6px 0;'><b>Guests:</b> " + guestsCount + "</p>" +
                        "      </div>" +
                        "      <div style='margin-top:14px;background:#fff7ed;border:1px solid #fed7aa;border-radius:10px;padding:14px;'>" +
                        "        <p style='margin:0;font-size:16px;'><b>Total Amount:</b> <span style='font-size:18px;color:#9a3412;'>LKR " +
                        String.format("%,.2f", total) +
                        "        </span></p>" +
                        "      </div>" +
                        "      <p style='margin-top:16px;color:#374151;'>Thank you!<br/>Ocean View Resort</p>" +
                        "    </div>" +
                        "    <div style='padding:14px;text-align:center;background:#f1f5f9;color:#64748b;font-size:12px;'>" +
                        "      This is an automated email. Please do not reply." +
                        "    </div>" +
                        "  </div>" +
                        "</body></html>";

                EmailUtil.sendHtmlEmail(g.getEmail(), subject, html);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.removeAttribute("step_reservationId");
        session.removeAttribute("step_roomId");
        session.removeAttribute("step_checkIn");
        session.removeAttribute("step_checkOut");
        session.removeAttribute("step_guests");
        session.removeAttribute("step_special");
        session.removeAttribute("step_total");

        session.setAttribute("successMsg", "Reservation created successfully! Reservation ID: " + reservationId);
        resp.sendRedirect(req.getContextPath() + "/staff/manageReservations.jsp");
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
