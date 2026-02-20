package com.oceanview.dao;

import com.oceanview.entity.User;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)

public class UserDAOImplTest {

	private static Connection conn;
    private UserDAOImpl userDAO;

    @BeforeAll
    static void setupConnection() throws Exception {
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ocean_view_resort?useSSL=false&serverTimezone=UTC",
                "root",
                "12345"
        );
    }

    @AfterAll
    static void closeConnection() throws Exception {
        conn.close();
    }

    @BeforeEach
    void setup() throws Exception {
        userDAO = new UserDAOImpl(conn);

        
        try (Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("DELETE FROM users WHERE username LIKE 'test_%'");
        }
    }

    // CREATE USER
    @Test
    @Order(1)
    void testCreateUser() {
        User user = new User();
        user.setUsername("test_create");
        user.setPassword("123456");
        user.setFullName("Test Create");
        user.setEmail("test_create@test.com");
        user.setPhone("0771111111");
        user.setRole("STAFF");
        user.setStatus("ACTIVE");

        boolean created = userDAO.createUser(user);

        assertTrue(created);
        assertTrue(userDAO.isUsernameExists("test_create"));
    }

    // LOGIN USER (VALID)
    @Test
    @Order(2)
    void testLoginValidUser() {
        User user = new User();
        user.setUsername("test_login");
        user.setPassword("password123");
        user.setFullName("Test Login");
        user.setEmail("test_login@test.com");
        user.setPhone("0772222222");
        user.setRole("STAFF");
        user.setStatus("ACTIVE");

        userDAO.createUser(user);

        User loggedIn = userDAO.login("test_login", "password123");

        assertNotNull(loggedIn);
        assertEquals("test_login", loggedIn.getUsername());
    }

    //INVALID LOGIN
    @Test
    @Order(3)
    void testInvalidLogin() {
        User result = userDAO.login("test_invalid", "wrongpass");
        assertNull(result);
    }

    //  UPDATE USER
    @Test
    @Order(4)
    void testUpdateUser() {
        User user = new User();
        user.setUsername("test_update");
        user.setPassword("pass");
        user.setFullName("Old Name");
        user.setEmail("old@test.com");
        user.setPhone("0773333333");
        user.setRole("STAFF");
        user.setStatus("ACTIVE");

        userDAO.createUser(user);

        User existing = userDAO.login("test_update", "pass");

        existing.setFullName("New Name");
        existing.setEmail("new@test.com");
        existing.setPhone("0779999999");
        existing.setRole("ADMIN");
        existing.setStatus("ACTIVE");

        boolean updated = userDAO.updateUser(existing);

        assertTrue(updated);

        User updatedUser = userDAO.getUserById(existing.getUserId());
        assertEquals("New Name", updatedUser.getFullName());
    }

    // DELETE USER
    @Test
    @Order(5)
    void testDeleteUser() {
        User user = new User();
        user.setUsername("test_delete");
        user.setPassword("pass");
        user.setFullName("Delete Me");
        user.setEmail("delete@test.com");
        user.setPhone("0774444444");
        user.setRole("STAFF");
        user.setStatus("ACTIVE");

        userDAO.createUser(user);

        User created = userDAO.login("test_delete", "pass");

        boolean deleted = userDAO.deleteUser(created.getUserId());

        assertTrue(deleted);
        assertNull(userDAO.getUserById(created.getUserId()));
    }

    //  USERNAME EXISTS CHECK
    @Test
    @Order(6)
    void testUsernameExists() {
        User user = new User();
        user.setUsername("test_duplicate");
        user.setPassword("pass");
        user.setFullName("Dup User");
        user.setEmail("dup@test.com");
        user.setPhone("0775555555");
        user.setRole("STAFF");
        user.setStatus("ACTIVE");

        userDAO.createUser(user);

        assertTrue(userDAO.isUsernameExists("test_duplicate"));
        assertFalse(userDAO.isUsernameExists("test_not_exist"));
    }
}
