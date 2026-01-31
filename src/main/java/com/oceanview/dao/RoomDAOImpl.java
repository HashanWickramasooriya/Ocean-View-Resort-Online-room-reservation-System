package com.oceanview.dao;

import com.oceanview.entity.Room;
import java.sql.*;
import java.util.*;

public class RoomDAOImpl implements RoomDAO {

    private Connection conn;
    public RoomDAOImpl(Connection conn) { this.conn = conn; }

    @Override
    public int addRoom(Room room) {
        String sql = "INSERT INTO rooms(room_number,room_name,room_type,rate_per_night,adult_capacity,child_capacity,description,facilities,status) VALUES(?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomName());
            ps.setString(3, room.getRoomType());
            ps.setDouble(4, room.getRatePerNight());
            ps.setInt(5, room.getAdultCapacity());
            ps.setInt(6, room.getChildCapacity());
            ps.setString(7, room.getDescription());
            ps.setString(8, room.getFacilities());
            ps.setString(9, "AVAILABLE");
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public void addRoomImages(int roomId, List<String> images) {
        String sql = "INSERT INTO room_images(room_id,image_path) VALUES(?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String img : images) {
                ps.setInt(1, roomId);
                ps.setString(2, img);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM rooms");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setRoomName(rs.getString("room_name"));
                r.setRoomType(rs.getString("room_type"));
                r.setRatePerNight(rs.getDouble("rate_per_night"));
                r.setAdultCapacity(rs.getInt("adult_capacity"));
                r.setChildCapacity(rs.getInt("child_capacity"));
                r.setDescription(rs.getString("description"));
                r.setFacilities(rs.getString("facilities"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Room getRoomById(int id) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM rooms WHERE room_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Room r = new Room();
                r.setRoomId(id);
                r.setRoomNumber(rs.getString("room_number"));
                r.setRoomName(rs.getString("room_name"));
                r.setRoomType(rs.getString("room_type"));
                r.setRatePerNight(rs.getDouble("rate_per_night"));
                r.setAdultCapacity(rs.getInt("adult_capacity"));
                r.setChildCapacity(rs.getInt("child_capacity"));
                r.setDescription(rs.getString("description"));
                r.setFacilities(rs.getString("facilities"));
                r.setStatus(rs.getString("status"));
                return r;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean updateRoom(Room r) {
        String sql = "UPDATE rooms SET room_name=?,room_type=?,rate_per_night=?,adult_capacity=?,child_capacity=?,description=?,facilities=?,status=? WHERE room_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getRoomName());
            ps.setString(2, r.getRoomType());
            ps.setDouble(3, r.getRatePerNight());
            ps.setInt(4, r.getAdultCapacity());
            ps.setInt(5, r.getChildCapacity());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getFacilities());
            ps.setString(8, r.getStatus());
            ps.setInt(9, r.getRoomId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean deleteRoom(int id) {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM rooms WHERE room_id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<String> getRoomImages(int roomId) {
        List<String> imgs = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement("SELECT image_path FROM room_images WHERE room_id=?")) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) imgs.add(rs.getString(1));
        } catch (Exception e) { e.printStackTrace(); }
        return imgs;
    }
}
