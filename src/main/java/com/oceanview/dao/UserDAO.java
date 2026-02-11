package com.oceanview.dao;

import com.oceanview.entity.User;
import java.util.List;

public interface UserDAO {

    boolean createUser(User user);

    User login(String username, String password);

    User getUserById(int userId);

    List<User> getAllUsers();

    boolean updateUser(User user);

    boolean deleteUser(int userId);

    boolean isUsernameExists(String username);

    boolean updatePassword(int userId, String newPassword);
}
