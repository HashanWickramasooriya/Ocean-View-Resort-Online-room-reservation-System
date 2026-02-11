package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Room;
import com.oceanview.entity.User;
import com.oceanview.util.BillingCalculator;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/add-reservation-step1")
public class AddReservationStep1Servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        User staff = (User) req.getSession().getAttribute("user");
        if (staff == null || !"STAFF".equals(staff.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String roomIdStr = req.getParameter("roomId");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");
        String guestsStr = req.getParameter("guests");
        String special = req.getParameter("specialRequests");

        int roomId = Integer.parseInt(roomIdStr);
        int guests = Integer.parseInt(guestsStr);

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO resDAO = new ReservationDAOImpl(conn);
            RoomDAO roomDAO = new RoomDAOImpl(conn);

            if (!resDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
                resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep1.jsp?error=Room not available for selected dates");
                return;
            }

            Room room = roomDAO.getRoomById(roomId);

            String reservationId = resDAO.generateReservationId();
            int baseGuests = Math.max(1, room.getAdultCapacity()); 
            double total = BillingCalculator.calculateTotal(
                    room.getRatePerNight(), guests, baseGuests, checkIn, checkOut
            );

            HttpSession session = req.getSession();
            session.setAttribute("step_reservationId", reservationId);
            session.setAttribute("step_roomId", roomId);
            session.setAttribute("step_checkIn", checkIn);
            session.setAttribute("step_checkOut", checkOut);
            session.setAttribute("step_guests", guests);
            session.setAttribute("step_special", special);
            session.setAttribute("step_total", total);

            resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep2.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/addReservationStep1.jsp?error=Failed");
        }
    }
}
