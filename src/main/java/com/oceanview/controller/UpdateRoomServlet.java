package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Room;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/update-room")
@MultipartConfig
public class UpdateRoomServlet extends HttpServlet {

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            int roomId = Integer.parseInt(req.getParameter("roomId"));

            // ===== UPDATE ROOM DETAILS =====
            Room room = new Room();
            room.setRoomId(roomId);
            room.setRoomName(req.getParameter("roomName"));
            room.setRoomType(req.getParameter("roomType"));
            room.setRatePerNight(Double.parseDouble(req.getParameter("rate")));
            room.setAdultCapacity(Integer.parseInt(req.getParameter("adultCapacity")));
            room.setChildCapacity(Integer.parseInt(req.getParameter("childCapacity")));
            room.setDescription(req.getParameter("description"));
            room.setFacilities(req.getParameter("facilities"));
            room.setStatus(req.getParameter("status"));

            dao.updateRoom(room);

            // ===== CORRECT RUNTIME UPLOAD PATH =====
            String appPath = req.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + "uploads" + File.separator + "rooms";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            System.out.println("UPLOAD PATH = " + uploadPath);

            // ===== SAVE NEW IMAGES =====
            List<String> images = new ArrayList<>();

            for (Part part : req.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {

                    String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                    part.write(uploadPath + File.separator + fileName);

                    images.add("uploads/rooms/" + fileName);
                }
            }

            if (!images.isEmpty()) {
                dao.addRoomImages(roomId, images);
            }

            resp.sendRedirect("manageRooms.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("editRoom.jsp?id=" + req.getParameter("roomId") + "&error=Failed");
        }
    }
}
