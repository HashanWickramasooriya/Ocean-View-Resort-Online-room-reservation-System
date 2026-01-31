package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin/delete-room")
public class DeleteRoomServlet extends HttpServlet {

    private RoomDAO dao;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBConnection.getConnection();
            dao = new RoomDAOImpl(conn);
        } catch (Exception e) {
            throw new ServletException("DB Init Failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteRoom(id);
            resp.sendRedirect("manageRooms.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("manageRooms.jsp?error=Delete Failed");
        }
    }
}
