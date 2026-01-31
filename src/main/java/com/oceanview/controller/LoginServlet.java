package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.dao.UserDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBConnection.getConnection();
            userDAO = new UserDAOImpl(conn);
        } catch (Exception e) {
            throw new ServletException("DB Init Failed", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // HARD-CODED ADMIN (optional)
        if ("admin".equals(username) && "admin123".equals(password)) {
            User admin = new User();
            admin.setUserId(0);
            admin.setUsername("admin");
            admin.setFullName("Administrator");
            admin.setRole("ADMIN");
            admin.setStatus("ACTIVE");

            session.setAttribute("user", admin);
            response.sendRedirect(request.getContextPath() + "/admin/admindashboard.jsp");
            return;
        }

        try {
            User user = userDAO.login(username, password);

            if (user != null) {
                session.setAttribute("user", user);

                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/admindashboard.jsp");
                } else {
                    // ✅ FIXED LOWERCASE PATH
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard.jsp");
                }

            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
