package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.database.DBConnection;
import com.oceanview.entity.Room;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/staff/room-details")
public class RoomDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String idStr = req.getParameter("roomId");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write("{}");
            return;
        }

        int roomId = Integer.parseInt(idStr);

        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try (Connection conn = DBConnection.getConnection()) {

            RoomDAO roomDAO = new RoomDAOImpl(conn);
            Room room = roomDAO.getRoomById(roomId);

            if (room == null) {
                resp.getWriter().write("{}");
                return;
            }

            List<String> images = room.getImages();

            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"roomId\":").append(room.getRoomId()).append(",");
            sb.append("\"roomNumber\":\"").append(json(room.getRoomNumber())).append("\",");
            sb.append("\"roomName\":\"").append(json(room.getRoomName())).append("\",");
            sb.append("\"roomType\":\"").append(json(room.getRoomType())).append("\",");
            sb.append("\"rate\":").append(room.getRatePerNight()).append(",");
            sb.append("\"adultCapacity\":").append(room.getAdultCapacity()).append(",");
            sb.append("\"childCapacity\":").append(room.getChildCapacity()).append(",");
            sb.append("\"facilities\":\"").append(json(room.getFacilities())).append("\",");
            sb.append("\"description\":\"").append(json(room.getDescription())).append("\",");

            sb.append("\"images\":[");
            for (int i = 0; i < images.size(); i++) {
                sb.append("\"").append(json(images.get(i))).append("\"");
                if (i < images.size() - 1) sb.append(",");
            }
            sb.append("]");

            sb.append("}");

            resp.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"server\"}");
        }
    }

    // Safe JSON string escape (also keeps new lines)
    private static String json(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
    }
}
