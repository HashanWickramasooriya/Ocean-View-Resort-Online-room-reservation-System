package com.oceanview.dao;

import com.oceanview.entity.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAOImpl implements RoomDAO {

    private Connection conn;

    public RoomDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // ================= ADD ROOM =================
    @Override
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms " +
                "(room_number, room_name, room_type, rate_per_night, capacity, description, facilities, images, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomName());
            ps.setString(3, room.getRoomType());
            ps.setDouble(4, room.getRatePerNight());
            ps.setInt(5, room.getCapacity());
            ps.setString(6, room.getDescription());
            ps.setString(7, room.getFacilities());
            ps.setString(8, room.getImages());
            ps.setString(9, room.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= GET ALL ROOMS =================
    @Override
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomName(rs.getString("room_name"));
                room.setRoomType(rs.getString("room_type"));
                room.setRatePerNight(rs.getDouble("rate_per_night"));
                room.setCapacity(rs.getInt("capacity"));
                room.setDescription(rs.getString("description"));
                room.setFacilities(rs.getString("facilities"));
                room.setImages(rs.getString("images"));
                room.setStatus(rs.getString("status"));
                room.setCreatedAt(rs.getTimestamp("created_at"));
                room.setUpdatedAt(rs.getTimestamp("updated_at"));
                rooms.add(room);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // ================= GET ROOM BY ID =================
    @Override
    public Room getRoomById(int id) {
        Room room = null;
        String sql = "SELECT * FROM rooms WHERE room_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomName(rs.getString("room_name"));
                room.setRoomType(rs.getString("room_type"));
                room.setRatePerNight(rs.getDouble("rate_per_night"));
                room.setCapacity(rs.getInt("capacity"));
                room.setDescription(rs.getString("description"));
                room.setFacilities(rs.getString("facilities"));
                room.setImages(rs.getString("images"));
                room.setStatus(rs.getString("status"));
                room.setCreatedAt(rs.getTimestamp("created_at"));
                room.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return room;
    }

    // ================= UPDATE ROOM =================
    @Override
    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET " +
                "room_number=?, room_name=?, room_type=?, rate_per_night=?, capacity=?, " +
                "description=?, facilities=?, images=?, status=?, updated_at=NOW() " +
                "WHERE room_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomName());
            ps.setString(3, room.getRoomType());
            ps.setDouble(4, room.getRatePerNight());
            ps.setInt(5, room.getCapacity());
            ps.setString(6, room.getDescription());
            ps.setString(7, room.getFacilities());
            ps.setString(8, room.getImages());
            ps.setString(9, room.getStatus());
            ps.setInt(10, room.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= DELETE ROOM =================
    @Override
    public boolean deleteRoom(int id) {
        String sql = "DELETE FROM rooms WHERE room_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
