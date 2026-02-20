package com.oceanview.dao;

import com.oceanview.database.DBConnection;
import com.oceanview.entity.Reservation;

import org.junit.jupiter.api.*;

import java.sql.*;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ReservationDAOImplTest {

    private static Connection conn;
    private static ReservationDAOImpl reservationDAO;

    private static int TEST_ROOM_ID;
    private static int TEST_GUEST_ID;
    private static final int CREATED_BY = 1;

    private static String testReservationId;

    // SETUP
  
    @BeforeAll
    static void setup() throws Exception {

        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); 
        reservationDAO = new ReservationDAOImpl(conn);

        TEST_ROOM_ID = insertTestRoom();
        TEST_GUEST_ID = insertTestGuest();
    }

    @AfterAll
    static void tearDown() throws Exception {
        conn.commit();   
        conn.close();
    }

    // HELPER METHODS
  
    private static int insertTestRoom() throws Exception {

        String sql = """
            INSERT INTO rooms(
                room_number, room_name, room_type,
                rate_per_night, adult_capacity, child_capacity,
                description, facilities, status
            )
            VALUES('T-999','Test Room','DELUXE',100,2,1,
                   'JUnit Test Room','WiFi','AVAILABLE')
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            return rs.getInt(1);
        }
    }

    private static int insertTestGuest() throws Exception {

        String sql = """
            INSERT INTO guests(
                guest_name, contact_number, email, address
            )
            VALUES('JUnit Guest','0770000000',
                   'junit@test.com','Test Address')
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            return rs.getInt(1);
        }
    }

    // Generate Reservation id
    @Test
    @Order(1)
    void testGenerateReservationId() {

        String id = reservationDAO.generateReservationId();

        assertNotNull(id);
        assertTrue(id.matches("RES-\\d{8}-\\d{3}"));
    }

    //  Create Reservation
   
    @Order(2)
    void testCreateReservation() {

        testReservationId = reservationDAO.generateReservationId();

        Reservation r = new Reservation();
        r.setReservationId(testReservationId);
        r.setGuestId(TEST_GUEST_ID);
        r.setRoomId(TEST_ROOM_ID);
        r.setCheckInDate(Date.valueOf("2026-03-01"));
        r.setCheckOutDate(Date.valueOf("2026-03-05"));
        r.setNumberOfGuests(2);
        r.setSpecialRequests("JUnit booking");
        r.setStatus("PENDING");
        r.setTotalAmount(500);
        r.setAdvancePayment(100);
        r.setCreatedBy(CREATED_BY);

        boolean created = reservationDAO.createReservation(r);
        assertTrue(created);

        Reservation saved = reservationDAO.getReservationById(testReservationId);
        assertNotNull(saved);
    }

    //  Update Reservation
   
    @Test
    @Order(3)
    void testUpdateReservation() {

        Reservation r = reservationDAO.getReservationById(testReservationId);

        r.setNumberOfGuests(3);
        r.setStatus("CONFIRMED");

        boolean updated = reservationDAO.updateReservation(r);
        assertTrue(updated);

        Reservation updatedRes = reservationDAO.getReservationById(testReservationId);
        assertEquals(3, updatedRes.getNumberOfGuests());
        assertEquals("CONFIRMED", updatedRes.getStatus());
    }

    //  Check Room Availability
 
    @Test
    @Order(4)
    void testRoomAvailability() {

        boolean available = reservationDAO.isRoomAvailable(
                TEST_ROOM_ID,
                "2026-04-01",
                "2026-04-05"
        );

        assertTrue(available);
    }

    //  Get All Reservations
   
    @Test
    @Order(5)
    void testGetAllReservations() {

        List<Reservation> list = reservationDAO.getAllReservations();

        assertNotNull(list);
        assertTrue(list.size() > 0);
    }

    //  Search Reservations
   
    @Test
    @Order(6)
    void testSearchReservations() {

        var results = reservationDAO.searchReservations(
                testReservationId,
                "ALL",
                "",
                ""
        );

        assertNotNull(results);
        assertTrue(results.size() > 0);
    }

    //  Mark Checked In
   
    @Test
    @Order(7)
    void testMarkCheckedIn() {

        boolean checkedIn = reservationDAO.markCheckedIn(testReservationId);
        assertTrue(checkedIn);

        Reservation r = reservationDAO.getReservationById(testReservationId);
        assertEquals("CHECKED_IN", r.getStatus());
    }

    // Mark Checked Out
   
    @Test
    @Order(8)
    void testMarkCheckedOut() {

        boolean checkedOut = reservationDAO.markCheckedOut(testReservationId);
        assertTrue(checkedOut);

        Reservation r = reservationDAO.getReservationById(testReservationId);
        assertEquals("CHECKED_OUT", r.getStatus());
    }

    //  Cancel Reservation
    @Test
    @Order(9)
    void testCancelReservation() {

        boolean cancelled = reservationDAO.cancelReservation(testReservationId);
        assertTrue(cancelled);

        Reservation r = reservationDAO.getReservationById(testReservationId);
        assertEquals("CANCELLED", r.getStatus());
    }
}