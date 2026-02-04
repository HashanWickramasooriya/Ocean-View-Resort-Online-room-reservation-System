package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.ReservationDetails;
import com.oceanview.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/all-reservations")
public class AdminAllReservationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String q = request.getParameter("q");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        if (status == null || status.trim().isEmpty()) status = "ALL";

        try (Connection conn = DBConnection.getConnection()) {

            ReservationDAO dao = new ReservationDAOImpl(conn);

            boolean hasAnyFilter =
                    (q != null && !q.trim().isEmpty()) ||
                    (!"ALL".equalsIgnoreCase(status)) ||
                    (fromDate != null && !fromDate.trim().isEmpty()) ||
                    (toDate != null && !toDate.trim().isEmpty());

            List<ReservationDetails> list = hasAnyFilter
                    ? dao.searchReservations(q, status, fromDate, toDate)
                    : dao.getAllReservationDetails();

            request.setAttribute("reservations", list);

            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);

            request.getRequestDispatcher("/admin/allReservations.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/dashboard.jsp?error=Failed+to+load+reservations");
        }
    }
}
