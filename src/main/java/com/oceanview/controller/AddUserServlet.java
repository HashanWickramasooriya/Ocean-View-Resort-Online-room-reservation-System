package com.oceanview.controller;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.oceanview.dao.UserDAO;
import com.oceanview.dao.UserDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.User;

@WebServlet("/admin/add-user")
public class AddUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBConnection.getConnection();
            userDAO = new UserDAOImpl(conn);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = (User) request.getSession().getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setPassword(request.getParameter("password"));
        user.setRole(request.getParameter("role"));
        user.setStatus("ACTIVE");

        boolean created = userDAO.createUser(user);

        if (created) {
            request.getSession().setAttribute("successMsg", "New staff member added successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/manageStaff.jsp");
        } else {
            request.setAttribute("message", "Username already exists!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/addUser.jsp").forward(request, response);
        }
    }
}
