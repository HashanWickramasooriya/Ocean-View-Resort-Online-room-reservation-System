package com.oceanview.dao;

import com.oceanview.entity.RoomImage;
import java.util.List;

public interface RoomImageDAO {
    List<RoomImage> getImagesByRoomId(int roomId);
}
