package com.oceanview.dao;

import com.oceanview.entity.RoomImage;
import java.sql.*;
import java.util.*;

public class RoomImageDAOImpl implements RoomImageDAO {

    private Connection conn;
    public RoomImageDAOImpl(Connection conn){ this.conn = conn; }

    @Override
    public List<RoomImage> getImagesByRoomId(int roomId){
        List<RoomImage> list = new ArrayList<>();

        try(PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM room_images WHERE room_id=?")) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                RoomImage img = new RoomImage();
                img.setImageId(rs.getInt("image_id"));
                img.setRoomId(rs.getInt("room_id"));
                img.setImagePath(rs.getString("image_path"));
                list.add(img);
            }

        }catch(Exception e){ e.printStackTrace(); }

        return list;
    }
}
