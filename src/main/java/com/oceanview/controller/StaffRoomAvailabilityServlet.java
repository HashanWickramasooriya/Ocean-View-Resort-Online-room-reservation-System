package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;

@WebServlet("/staff/room-availability")
public class StaffRoomAvailabilityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");
        String roomType = req.getParameter("roomType"); // optional

        // First time open page (no search yet)
        if (checkIn == null || checkOut == null || checkIn.isBlank() || checkOut.isBlank()) {
            req.getRequestDispatcher("/staff/staff_room_availability.jsp").forward(req, resp);
            return;
        }

        // Validate date order
        try {
            LocalDate in = LocalDate.parse(checkIn);
            LocalDate out = LocalDate.parse(checkOut);

            if (!out.isAfter(in)) {
                req.setAttribute("error", "Check-out date must be after check-in date.");
                req.getRequestDispatcher("/staff/staff_room_availability.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            req.setAttribute("error", "Invalid date format.");
            req.getRequestDispatcher("/staff/staff_room_availability.jsp").forward(req, resp);
            return;
        }

        // ✅ Handle SQLException here
        try (Connection conn = DBConnection.getConnection()) {

            RoomDAO roomDAO = new RoomDAOImpl(conn);
            req.setAttribute("rooms", roomDAO.getAvailableRooms(checkIn, checkOut, roomType));

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        // Keep values after search
        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);
        req.setAttribute("roomType", roomType);

        req.getRequestDispatcher("/staff/staff_room_availability.jsp").forward(req, resp);
    }
}