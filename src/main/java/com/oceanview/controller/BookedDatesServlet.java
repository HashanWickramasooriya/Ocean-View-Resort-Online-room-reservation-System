package com.oceanview.controller;

import com.oceanview.dao.BookingCalendarDAO;
import com.oceanview.dao.BookingCalendarDAOImpl;
import com.oceanview.database.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/staff/booked-dates")
public class BookedDatesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int roomId = Integer.parseInt(req.getParameter("roomId"));

        try (Connection conn = DBConnection.getConnection()) {
            BookingCalendarDAO calDAO = new BookingCalendarDAOImpl(conn);
            List<String> dates = calDAO.getBookedDates(roomId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < dates.size(); i++) {
                sb.append("\"").append(dates.get(i)).append("\"");
                if (i < dates.size() - 1) sb.append(",");
            }
            sb.append("]");
            resp.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
        }
    }
}
