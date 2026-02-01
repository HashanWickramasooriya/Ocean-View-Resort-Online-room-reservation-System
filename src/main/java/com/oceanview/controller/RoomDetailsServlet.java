package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.dao.RoomImageDAO;
import com.oceanview.dao.RoomImageDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Room;
import com.oceanview.entity.RoomImage;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/staff/room-details")
public class RoomDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int roomId = Integer.parseInt(req.getParameter("roomId"));

        try (Connection conn = DBConnection.getConnection()) {
            RoomDAO roomDAO = new RoomDAOImpl(conn);
            RoomImageDAO imgDAO = new RoomImageDAOImpl(conn);

            Room room = roomDAO.getRoomById(roomId);
            List<RoomImage> images = imgDAO.getImagesByRoomId(roomId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"roomId\":").append(room.getRoomId()).append(",");
            sb.append("\"roomNumber\":\"").append(escape(room.getRoomNumber())).append("\",");
            sb.append("\"roomName\":\"").append(escape(room.getRoomName())).append("\",");
            sb.append("\"roomType\":\"").append(escape(room.getRoomType())).append("\",");
            sb.append("\"rate\":").append(room.getRatePerNight()).append(",");
            sb.append("\"adultCapacity\":").append(room.getAdultCapacity()).append(",");
            sb.append("\"childCapacity\":").append(room.getChildCapacity()).append(",");
            sb.append("\"facilities\":\"").append(escape(room.getFacilities())).append("\",");
            sb.append("\"description\":\"").append(escape(room.getDescription())).append("\",");

            sb.append("\"images\":[");
            for (int i = 0; i < images.size(); i++) {
                sb.append("\"").append(escape(images.get(i).getImagePath())).append("\"");
                if (i < images.size() - 1) sb.append(",");
            }
            sb.append("]}");

            resp.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
