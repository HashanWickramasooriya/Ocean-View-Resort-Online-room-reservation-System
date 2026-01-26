package com.oceanview.dao;

import com.oceanview.entity.User;
import com.oceanview.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    private Connection conn;

    public UserDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // ---------------- CREATE USER ----------------
    @Override
    public boolean createUser(User user) {
        if (isUsernameExists(user.getUsername())) {
            return false; 
        }

        boolean result = false;
        String sql = "INSERT INTO users(username,password,full_name,email,phone,role,status) VALUES(?,?,?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtil.hashPassword(user.getPassword()));
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getStatus());
            result = ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // ---------------- LOGIN ----------------
    @Override
    public User login(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username=? AND status='ACTIVE'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashed = rs.getString("password");
                if (PasswordUtil.checkPassword(password, hashed)) {
                    user = mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // ---------------- GET USER BY ID ----------------
    @Override
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // ---------------- GET ALL USERS ----------------
    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // ---------------- UPDATE USER ----------------
    @Override
    public boolean updateUser(User user) {
        boolean result = false;
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, role=?, status=? WHERE user_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setInt(6, user.getUserId());

            result = ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // ---------------- DELETE USER (SOFT) ----------------
    @Override
    public boolean deleteUser(int userId) {
        boolean result = false;
        String sql = "UPDATE users SET status='INACTIVE' WHERE user_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            result = ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // ---------------- CHECK USERNAME ----------------
    @Override
    public boolean isUsernameExists(String username) {
        boolean exists = false;
        String sql = "SELECT user_id FROM users WHERE username=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            exists = rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exists;
    }

    // ---------------- RESET PASSWORD ----------------
    @Override
    public boolean updatePassword(int userId, String newPassword) {
        boolean result = false;
        String sql = "UPDATE users SET password=? WHERE user_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setInt(2, userId);
            result = ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // ---------------- PRIVATE MAPPER ----------------
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
}
