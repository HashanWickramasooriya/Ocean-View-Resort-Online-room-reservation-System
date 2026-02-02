package com.oceanview.dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BookingCalendarDAOImpl implements BookingCalendarDAO {

    private final Connection conn;
    public BookingCalendarDAOImpl(Connection conn) { this.conn = conn; }

    @Override
    public boolean markBookedDates(int roomId, String reservationId, String checkIn, String checkOut) {
        String sql = "INSERT INTO booking_calendar(room_id,booking_date,status,reservation_id) VALUES(?,?, 'BOOKED', ?)";
        LocalDate start = LocalDate.parse(checkIn);
        LocalDate end = LocalDate.parse(checkOut); // not included

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            LocalDate d = start;
            while (d.isBefore(end)) {
                ps.setInt(1, roomId);
                ps.setDate(2, Date.valueOf(d));
                ps.setString(3, reservationId);
                ps.addBatch();
                d = d.plusDays(1);
            }
            ps.executeBatch();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<String> getBookedDates(int roomId) {
        List<String> dates = new ArrayList<>();
        String sql = "SELECT booking_date FROM booking_calendar WHERE room_id=? AND status='BOOKED' ORDER BY booking_date";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                dates.add(rs.getDate(1).toString()); // yyyy-mm-dd
            }
        } catch (Exception e) { e.printStackTrace(); }
        return dates;
    }

    @Override
    public boolean clearReservationDates(String reservationId) {
        String sql = "DELETE FROM booking_calendar WHERE reservation_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
  

}
