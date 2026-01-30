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

@WebServlet("/AddRoomServlet")
@MultipartConfig
public class AddRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Save images in webapp/uploads/rooms
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "rooms";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        StringBuilder imageNames = new StringBuilder();
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                part.write(uploadPath + File.separator + fileName);
                imageNames.append(fileName).append(",");
            }
        }

        // Remove trailing comma
        if (imageNames.length() > 0) {
            imageNames.setLength(imageNames.length() - 1);
        }

        // Create Room object
        Room room = new Room();
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setRoomName(request.getParameter("roomName"));
        room.setRoomType(request.getParameter("roomType"));
        room.setRatePerNight(Double.parseDouble(request.getParameter("rate")));
        room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        room.setFacilities(request.getParameter("facilities"));
        room.setDescription(request.getParameter("description"));
        room.setImages(imageNames.toString());
        room.setStatus(request.getParameter("status"));

        // Insert into DB
        try (Connection con = DBConnection.getConnection()) {
            RoomDAO dao = new RoomDAOImpl(con);
            dao.addRoom(room);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect to room list
        response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp");
    }
}
