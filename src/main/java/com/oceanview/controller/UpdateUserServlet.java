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

@WebServlet("/admin/update-user")
public class UpdateUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBConnection.getConnection();
            userDAO = new UserDAOImpl(conn);
        } catch (Exception e) {
            throw new ServletException("DB Connection Failed", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // -------- AUTH CHECK --------
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // -------- READ FORM --------
        int userId = Integer.parseInt(request.getParameter("userId"));

        User user = new User();
        user.setUserId(userId);
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        user.setStatus(request.getParameter("status"));

        boolean updated = userDAO.updateUser(user);

        session.setAttribute("fromUpdate", true);

        if (updated) {
            session.setAttribute("successMsg", "User updated successfully!");
        } else {
            session.setAttribute("errorMsg", "Failed to update user!");
        }

        response.sendRedirect(
            request.getContextPath() + "/admin/editUser.jsp?id=" + userId
        );
    }

}
