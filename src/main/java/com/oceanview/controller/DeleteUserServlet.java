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

@WebServlet("/admin/delete-user")
public class DeleteUserServlet extends HttpServlet {

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = (User) request.getSession().getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(userId);

        request.getSession().setAttribute("successMsg", "User deleted successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff.jsp");
    }
}
