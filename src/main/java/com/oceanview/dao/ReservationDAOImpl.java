package com.oceanview.dao;

import com.oceanview.entity.Reservation;
import com.oceanview.entity.ReservationDetails;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    private final Connection conn;

    public ReservationDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public String generateReservationId() {
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String prefix = "RES-" + today + "-";

        String sql = "SELECT reservation_id FROM reservations WHERE reservation_id LIKE ? ORDER BY reservation_id DESC LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String last = rs.getString(1); // RES-20260201-005
                int lastSeq = Integer.parseInt(last.substring(last.length() - 3));
                return prefix + String.format("%03d", lastSeq + 1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean createReservation(Reservation r) {

        String sql = """
            INSERT INTO reservations(
                reservation_id, guest_id, room_id, check_in_date, check_out_date,
                number_of_guests, special_requests, status, total_amount, advance_payment, created_by
            )
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

        } catch (Exception e) {
            e.printStackTrace();
        }

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

        } catch (Exception e) {
            e.printStackTrace();
        }

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean updateReservation(Reservation r) {

        String sql = """
            UPDATE reservations
            SET check_in_date=?, check_out_date=?, number_of_guests=?, special_requests=?,
                status=?, total_amount=?, advance_payment=?
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean cancelReservation(String reservationId) {

        String sql = "UPDATE reservations SET status='CANCELLED' WHERE reservation_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ✅ FULL DETAILS (JOIN)
    @Override
    public List<ReservationDetails> getAllReservationDetails() {

        List<ReservationDetails> list = new ArrayList<>();

        String sql = """
            SELECT r.*,
                   g.guest_name, g.contact_number, g.email, g.address,
                   rm.room_number, rm.room_type, rm.rate_per_night
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            JOIN rooms rm ON r.room_id = rm.room_id
            ORDER BY r.created_at DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapDetails(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public ReservationDetails getReservationDetailsById(String reservationId) {

        String sql = """
            SELECT r.*,
                   g.guest_name, g.contact_number, g.email, g.address,
                   rm.room_number, rm.room_type, rm.rate_per_night
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            JOIN rooms rm ON r.room_id = rm.room_id
            WHERE r.reservation_id=?
            LIMIT 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapDetails(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ✅ SEARCH + FILTER
    @Override
    public List<ReservationDetails> searchReservations(String q, String status,
                                                      String fromDate, String toDate) {

        List<ReservationDetails> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT r.*,
                   g.guest_name, g.contact_number, g.email, g.address,
                   rm.room_number, rm.room_type, rm.rate_per_night
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            JOIN rooms rm ON r.room_id = rm.room_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        // ✅ Search box filter
        if (q != null && !q.trim().isEmpty()) {
            sql.append("""
                AND (
                    r.reservation_id LIKE ?
                    OR g.guest_name LIKE ?
                    OR g.contact_number LIKE ?
                    OR rm.room_number LIKE ?
                )
            """);

            String like = "%" + q.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }

        // ✅ Status filter
        if (status != null && !status.trim().isEmpty()
                && !"ALL".equalsIgnoreCase(status)) {

            sql.append(" AND r.status=? ");
            params.add(status.trim());
        }

        // ✅ Date filters (supports from only, to only, or both)

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND r.check_out_date > ? ");
            params.add(java.sql.Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND r.check_in_date < ? ");
            params.add(java.sql.Date.valueOf(toDate));
        }

        sql.append(" ORDER BY r.created_at DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);

                if (p instanceof java.sql.Date) {
                    ps.setDate(i + 1, (java.sql.Date) p);
                } else {
                    ps.setString(i + 1, p.toString());
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapDetails(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public int countTodayCheckIns() {
        String sql = """
            SELECT COUNT(*)
            FROM reservations
            WHERE check_in_date = CURDATE()
              AND status IN ('PENDING','CONFIRMED')
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * "Today Check-outs" = leaving today; usually CHECKED_IN guests or already CHECKED_OUT today.
     */
    @Override
    public int countTodayCheckOuts() {
        String sql = """
            SELECT COUNT(*)
            FROM reservations
            WHERE check_out_date = CURDATE()
              AND status IN ('CHECKED_IN','CHECKED_OUT')
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countPendingReservations() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status='PENDING'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Available rooms today:
     * 1) rooms.status must be AVAILABLE
     * 2) not BOOKED in booking_calendar today
     */
    @Override
    public int countAvailableRoomsToday() {
        String sql = """
            SELECT COUNT(*)
            FROM rooms rm
            WHERE rm.status = 'AVAILABLE'
              AND rm.room_id NOT IN (
                SELECT DISTINCT room_id
                FROM booking_calendar
                WHERE booking_date = CURDATE()
                  AND status = 'BOOKED'
              )
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Today schedule list:
     * - Show check-ins (PENDING/CONFIRMED arriving today)
     * - Show check-outs (CHECKED_IN/CHECKED_OUT leaving today)
     */
    @Override
    public List<ReservationDetails> getTodaySchedule(int limit) {
        List<ReservationDetails> list = new ArrayList<>();

        String sql = """
            SELECT r.*,
                   g.guest_name, g.contact_number, g.email, g.address,
                   rm.room_number, rm.room_type, rm.rate_per_night,
                   CASE
                     WHEN r.check_in_date = CURDATE() THEN 'CHECK-IN'
                     WHEN r.check_out_date = CURDATE() THEN 'CHECK-OUT'
                     ELSE 'TODAY'
                   END AS today_type
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            JOIN rooms rm ON r.room_id = rm.room_id
            WHERE (
                   (r.check_in_date = CURDATE() AND r.status IN ('PENDING','CONFIRMED'))
                OR (r.check_out_date = CURDATE() AND r.status IN ('CHECKED_IN','CHECKED_OUT'))
            )
            ORDER BY
              CASE WHEN r.check_in_date = CURDATE() THEN 0 ELSE 1 END,
              r.check_in_date ASC,
              r.created_at DESC
            LIMIT ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservationDetails d = mapDetails(rs);
                d.setTodayType(rs.getString("today_type"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    @Override
    public boolean markCheckedIn(String reservationId) {
        String sql = "UPDATE reservations SET status='CHECKED_IN' WHERE reservation_id=? AND status IN ('PENDING','CONFIRMED')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean markCheckedOut(String reservationId) {
        String sql = "UPDATE reservations SET status='CHECKED_OUT' WHERE reservation_id=? AND status='CHECKED_IN'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // ✅ mapper for ReservationDetails
    private ReservationDetails mapDetails(ResultSet rs) throws Exception {
        ReservationDetails d = new ReservationDetails();

        d.setReservationId(rs.getString("reservation_id"));
        d.setGuestId(rs.getInt("guest_id"));
        d.setRoomId(rs.getInt("room_id"));

        d.setGuestName(rs.getString("guest_name"));
        d.setGuestContact(rs.getString("contact_number"));
        d.setGuestEmail(rs.getString("email"));
        d.setGuestAddress(rs.getString("address"));

        d.setRoomNumber(rs.getString("room_number"));
        d.setRoomType(rs.getString("room_type"));
        d.setRatePerNight(rs.getDouble("rate_per_night"));

        d.setCheckInDate(rs.getDate("check_in_date"));
        d.setCheckOutDate(rs.getDate("check_out_date"));
        d.setNumberOfGuests(rs.getInt("number_of_guests"));
        d.setSpecialRequests(rs.getString("special_requests"));
        d.setStatus(rs.getString("status"));
        d.setTotalAmount(rs.getDouble("total_amount"));
        d.setAdvancePayment(rs.getDouble("advance_payment"));
        d.setCreatedAt(rs.getTimestamp("created_at"));

        return d;
    }
}
