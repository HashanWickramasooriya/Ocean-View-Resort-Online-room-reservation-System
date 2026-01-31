package com.oceanview.controller;

import com.oceanview.database.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/delete-room-image")
public class DeleteRoomImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        int imageId = Integer.parseInt(req.getParameter("imageId"));
        int roomId  = Integer.parseInt(req.getParameter("roomId"));

        try (Connection conn = DBConnection.getConnection()) {

            // Get image path
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT image_path FROM room_images WHERE image_id=?");
            ps.setInt(1, imageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String path = rs.getString("image_path");

                // Delete file from server
                String fullPath = getServletContext().getRealPath("") + File.separator + path;
                File f = new File(fullPath);
                if (f.exists()) f.delete();
            }

            // Delete from DB
            ps = conn.prepareStatement("DELETE FROM room_images WHERE image_id=?");
            ps.setInt(1, imageId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("editRoom.jsp?id=" + roomId);
    }
}
