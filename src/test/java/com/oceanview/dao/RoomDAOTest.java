package com.oceanview.dao;

import com.oceanview.database.DBConnection;
import com.oceanview.entity.Room;

import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RoomDAOTest {

    private static Connection conn;
    private static RoomDAOImpl roomDAO;
    private static int testRoomId;

    @BeforeAll
    static void setup() throws SQLException {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);   
        roomDAO = new RoomDAOImpl(conn);
    }

    @AfterAll
    static void tearDown() throws Exception {
        conn.commit();   
        conn.close();
    }
    //Add Room Test
   
    @Test
    @Order(1)
    void testAddRoom() {
        Room room = new Room();
        room.setRoomNumber("T101");
        room.setRoomName("Test Deluxe");
        room.setRoomType("DELUXE");
        room.setRatePerNight(150.0);
        room.setAdultCapacity(2);
        room.setChildCapacity(1);
        room.setDescription("Test Description");
        room.setFacilities("WiFi, TV");

        testRoomId = roomDAO.addRoom(room);

        assertTrue(testRoomId > 0);
    }

    // Get Room By ID Test
   
    @Test
    @Order(2)
    void testGetRoomById() {
        Room room = roomDAO.getRoomById(testRoomId);

        assertNotNull(room);
        assertEquals("Test Deluxe", room.getRoomName());
    }

    //  Update Room Test
   
    @Test
    @Order(3)
    void testUpdateRoom() {
        Room room = roomDAO.getRoomById(testRoomId);
        room.setRoomName("Updated Deluxe");

        boolean updated = roomDAO.updateRoom(room);

        assertTrue(updated);

        Room updatedRoom = roomDAO.getRoomById(testRoomId);
        assertEquals("Updated Deluxe", updatedRoom.getRoomName());
    }

    
    
    @Test
    @Order(4)
    void testGetAvailableRooms() {

        List<Room> rooms = roomDAO.getAvailableRooms(
                "2026-01-01",
                "2026-01-05",
                "DELUXE"
        );

        assertNotNull(rooms);
        assertTrue(rooms.size() > 0);
    }

    // Delete Room Test
    
    @Order(5)
    void testDeleteRoom() {
        boolean deleted = roomDAO.deleteRoom(testRoomId);
        assertTrue(deleted);

        Room room = roomDAO.getRoomById(testRoomId);
        assertNull(room);
    }
}