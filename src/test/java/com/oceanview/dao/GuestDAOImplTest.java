package com.oceanview.dao;

import com.oceanview.database.DBConnection;
import com.oceanview.entity.Guest;

import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.Date;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class GuestDAOImplTest {

    private static Connection conn;
    private static GuestDAOImpl guestDAO;
    private static int testGuestId;

    private static String guestName;
    private static String contactNumber;
    private static String email;

    @BeforeAll
    static void setup() throws Exception {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); 
        guestDAO = new GuestDAOImpl(conn);

       
        long unique = System.currentTimeMillis();
        guestName = "John Perera";
        contactNumber = "077" + (unique % 10000000);
        email = "john" + unique + "@test.com";
    }

    @AfterAll
    static void tearDown() throws Exception {
        conn.commit();  
        conn.close();
    }

    // Create Guest
    
    @Test
    @Order(1)
    void testCreateGuest() {

        Guest g = new Guest();
        g.setGuestName(guestName);
        g.setAddress("No 45, Galle Road, Colombo");
        g.setContactNumber(contactNumber);
        g.setEmail(email);

       
        g.setIdType("NATIONAL_ID");

        
        g.setIdNumber("200089786578");

        g.setNationality("Sri Lankan");
        g.setDateOfBirth(Date.valueOf("2000-08-15"));

        testGuestId = guestDAO.createGuest(g);

        assertTrue(testGuestId > 0);
    }

    //  Get Guest By ID
    
    @Test
    @Order(2)
    void testGetGuestById() {

        Guest g = guestDAO.getGuestById(testGuestId);

        assertNotNull(g);
        assertEquals(guestName, g.getGuestName());
        assertEquals("NATIONAL_ID", g.getIdType());
        assertEquals("200089786578", g.getIdNumber());
        assertEquals(contactNumber, g.getContactNumber());
        assertEquals(email, g.getEmail());
    }

    //  Update Guest
   
    @Test
    @Order(3)
    void testUpdateGuest() {

        Guest g = guestDAO.getGuestById(testGuestId);

        g.setGuestName("John Silva");
        g.setAddress("Kandy");
        g.setNationality("Indian");

        boolean updated = guestDAO.updateGuest(g);
        assertTrue(updated);

        Guest updatedGuest = guestDAO.getGuestById(testGuestId);

        assertEquals("John Silva", updatedGuest.getGuestName());
        assertEquals("Kandy", updatedGuest.getAddress());
        assertEquals("Indian", updatedGuest.getNationality());
    }
}