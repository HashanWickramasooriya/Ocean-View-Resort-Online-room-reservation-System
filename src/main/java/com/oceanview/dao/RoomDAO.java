package com.oceanview.dao;

import com.oceanview.entity.Room;
import java.util.List;

public interface RoomDAO {
    int addRoom(Room room);
    boolean updateRoom(Room room);
    boolean deleteRoom(int roomId);
    Room getRoomById(int roomId);
    List<Room> getAllRooms();
    void addRoomImages(int roomId, List<String> images);
    List<String> getRoomImages(int roomId);
}
