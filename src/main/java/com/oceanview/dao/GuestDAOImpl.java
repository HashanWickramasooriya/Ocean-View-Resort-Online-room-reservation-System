package com.oceanview.dao;

import com.oceanview.entity.Guest;
import java.sql.*;

public class GuestDAOImpl implements GuestDAO {

    private final Connection conn;
    public GuestDAOImpl(Connection conn) { this.conn = conn; }

    @Override
    public int createGuest(Guest g) {

        String sql = "INSERT INTO guests(guest_name,address,contact_number,email,id_type,id_number,nationality,date_of_birth) " +
                     "VALUES(?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, g.getGuestName());
            ps.setString(2, g.getAddress());
            ps.setString(3, g.getContactNumber());
            ps.setString(4, g.getEmail());
            ps.setString(5, g.getIdType());
            ps.setString(6, g.getIdNumber());
            ps.setString(7, g.getNationality());

            if (g.getDateOfBirth() != null) {
                ps.setDate(8, g.getDateOfBirth());
            } else {
                ps.setNull(8, Types.DATE);
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int getGuestIdByContactAndEmail(String contact, String email) {
        if (contact == null || contact.trim().isEmpty()) return 0;
        if (email == null || email.trim().isEmpty()) return 0;

        String sql = "SELECT guest_id FROM guests WHERE contact_number=? AND email=? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contact.trim());
            ps.setString(2, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("guest_id");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean updateGuest(Guest g) {
        String sql = "UPDATE guests SET guest_name=?, address=?, id_type=?, id_number=?, nationality=?, date_of_birth=? " +
                     "WHERE guest_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, g.getGuestName());
            ps.setString(2, g.getAddress());
            ps.setString(3, g.getIdType());
            ps.setString(4, g.getIdNumber());
            ps.setString(5, g.getNationality());

            if (g.getDateOfBirth() != null) {
                ps.setDate(6, g.getDateOfBirth());
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setInt(7, g.getGuestId());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Guest getGuestById(int guestId) {
        String sql = "SELECT * FROM guests WHERE guest_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Guest g = new Guest();
                g.setGuestId(rs.getInt("guest_id"));
                g.setGuestName(rs.getString("guest_name"));
                g.setAddress(rs.getString("address"));
                g.setContactNumber(rs.getString("contact_number"));
                g.setEmail(rs.getString("email"));
                g.setIdType(rs.getString("id_type"));
                g.setIdNumber(rs.getString("id_number"));
                g.setNationality(rs.getString("nationality"));
                g.setDateOfBirth(rs.getDate("date_of_birth"));
                return g;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
