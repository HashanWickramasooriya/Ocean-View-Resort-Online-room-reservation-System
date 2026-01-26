package com.oceanview.dao;

import com.oceanview.entity.User;
import java.util.List;

public interface UserDAO {

    // Create new user (admin)
    boolean createUser(User user);

    // Login using username and password
    User login(String username, String password);

    // Get user by ID
    User getUserById(int userId);

    // Get all users
    List<User> getAllUsers();

    // Update user info
    boolean updateUser(User user);

    // Soft delete user
    boolean deleteUser(int userId);

    // Check if username exists
    boolean isUsernameExists(String username);

    // Reset password
    boolean updatePassword(int userId, String newPassword);
}
