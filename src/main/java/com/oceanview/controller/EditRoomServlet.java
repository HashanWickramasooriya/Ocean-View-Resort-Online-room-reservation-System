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
import java.util.Collection;
import java.sql.Connection;

@WebServlet("/EditRoomServlet")
@MultipartConfig
public class EditRoomServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));

        try (Connection con = DBConnection.getConnection()) {
            RoomDAO dao = new RoomDAOImpl(con);
            Room oldRoom = dao.getRoomById(roomId);

            String uploadPath = getServletContext().getRealPath("") + "uploads/rooms";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String images = oldRoom.getImages();
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                    part.write(uploadPath + File.separator + fileName);
                    images += fileName + ",";
                }
            }

            oldRoom.setRoomNumber(request.getParameter("roomNumber"));
            oldRoom.setRoomName(request.getParameter("roomName"));
            oldRoom.setRoomType(request.getParameter("roomType"));
            oldRoom.setRatePerNight(Double.parseDouble(request.getParameter("rate")));
            oldRoom.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            oldRoom.setDescription(request.getParameter("description"));
            oldRoom.setFacilities(request.getParameter("facilities"));
            oldRoom.setImages(images);
            oldRoom.setStatus(request.getParameter("status"));

            dao.updateRoom(oldRoom);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin/rooms.jsp");
    }
}
