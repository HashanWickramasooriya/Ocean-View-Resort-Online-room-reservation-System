package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.Connection;

@WebServlet("/DeleteRoomServlet")
public class DeleteRoomServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws java.io.IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {
            RoomDAO dao = new RoomDAOImpl(con);
            dao.deleteRoom(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin/rooms.jsp");
    }
}
