package com.oceanview.dao;

import com.oceanview.entity.Room;
import java.util.List;

public interface RoomDAO {

    boolean addRoom(Room room);

    List<Room> getAllRooms();

    Room getRoomById(int id);

    boolean updateRoom(Room room);

    boolean deleteRoom(int id);
}
