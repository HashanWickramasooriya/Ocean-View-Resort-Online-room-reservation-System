package com.oceanview.dao;

import com.oceanview.entity.Reservation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class ReservationDAOImpl implements ReservationDAO {

    private final Connection conn;
    public ReservationDAOImpl(Connection conn) { this.conn = conn; }

    @Override
    public String generateReservationId() {
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String prefix = "RES-" + today + "-";

        String sql = "SELECT reservation_id FROM reservations WHERE reservation_id LIKE ? ORDER BY reservation_id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String last = rs.getString(1);
                int lastSeq = Integer.parseInt(last.substring(last.length() - 3));
                return prefix + String.format("%03d", lastSeq + 1);
            }
        } catch (Exception e) { e.printStackTrace(); }

        return prefix + "001";
    }

    @Override
    public boolean isRoomAvailable(int roomId, String checkIn, String checkOut) {
        String sql = """
            SELECT COUNT(*)
            FROM booking_calendar
            WHERE room_id=?
              AND booking_date >= ?
              AND booking_date < ?
              AND status='BOOKED'
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, java.sql.Date.valueOf(checkIn));
            ps.setDate(3, java.sql.Date.valueOf(checkOut));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;
        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean createReservation(Reservation r) {
        String sql = """
            INSERT INTO reservations(reservation_id,guest_id,room_id,check_in_date,check_out_date,
            number_of_guests,special_requests,status,total_amount,advance_payment,created_by)
            VALUES(?,?,?,?,?,?,?,?,?,?,?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getReservationId());
            ps.setInt(2, r.getGuestId());
            ps.setInt(3, r.getRoomId());
            ps.setDate(4, r.getCheckInDate());
            ps.setDate(5, r.getCheckOutDate());
            ps.setInt(6, r.getNumberOfGuests());
            ps.setString(7, r.getSpecialRequests());
            ps.setString(8, r.getStatus());
            ps.setDouble(9, r.getTotalAmount());
            ps.setDouble(10, r.getAdvancePayment());
            ps.setInt(11, r.getCreatedBy());
            return ps.executeUpdate() == 1;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getString("reservation_id"));
                r.setGuestId(rs.getInt("guest_id"));
                r.setRoomId(rs.getInt("room_id"));
                r.setCheckInDate(rs.getDate("check_in_date"));
                r.setCheckOutDate(rs.getDate("check_out_date"));
                r.setNumberOfGuests(rs.getInt("number_of_guests"));
                r.setSpecialRequests(rs.getString("special_requests"));
                r.setStatus(rs.getString("status"));
                r.setTotalAmount(rs.getDouble("total_amount"));
                r.setAdvancePayment(rs.getDouble("advance_payment"));
                r.setCreatedBy(rs.getInt("created_by"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public Reservation getReservationById(String reservationId) {
        String sql = "SELECT * FROM reservations WHERE reservation_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getString("reservation_id"));
                r.setGuestId(rs.getInt("guest_id"));
                r.setRoomId(rs.getInt("room_id"));
                r.setCheckInDate(rs.getDate("check_in_date"));
                r.setCheckOutDate(rs.getDate("check_out_date"));
                r.setNumberOfGuests(rs.getInt("number_of_guests"));
                r.setSpecialRequests(rs.getString("special_requests"));
                r.setStatus(rs.getString("status"));
                r.setTotalAmount(rs.getDouble("total_amount"));
                r.setAdvancePayment(rs.getDouble("advance_payment"));
                r.setCreatedBy(rs.getInt("created_by"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                return r;
            }

        } catch (Exception e) { e.printStackTrace(); }

        return null;
    }

    @Override
    public boolean updateReservation(Reservation r) {
        String sql = """
            UPDATE reservations
            SET check_in_date=?, check_out_date=?, number_of_guests=?, special_requests=?, status=?, total_amount=?, advance_payment=?
            WHERE reservation_id=?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, r.getCheckInDate());
            ps.setDate(2, r.getCheckOutDate());
            ps.setInt(3, r.getNumberOfGuests());
            ps.setString(4, r.getSpecialRequests());
            ps.setString(5, r.getStatus());
            ps.setDouble(6, r.getTotalAmount());
            ps.setDouble(7, r.getAdvancePayment());
            ps.setString(8, r.getReservationId());
            return ps.executeUpdate() == 1;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean cancelReservation(String reservationId) {
        String sql = "UPDATE reservations SET status='CANCELLED' WHERE reservation_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
}
