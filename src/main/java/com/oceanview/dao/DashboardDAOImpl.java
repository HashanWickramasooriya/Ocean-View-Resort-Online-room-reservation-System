package com.oceanview.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.LinkedHashMap;

public class DashboardDAOImpl implements DashboardDAO {

    private Connection conn;

    public DashboardDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE status='ACTIVE'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getTotalReservations() {
        String sql = "SELECT COUNT(*) FROM reservations";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public double getMonthlyRevenue() {

        String sql = """
            SELECT IFNULL(SUM(total_amount),0)
            FROM reservations
            WHERE MONTH(check_in_date) = MONTH(CURRENT_DATE())
              AND YEAR(check_in_date) = YEAR(CURRENT_DATE())
              AND status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // ================= YEARLY REVENUE BY MONTH =================
    @Override
    public Map<String, Double> getRevenueByMonth(int year) {

        Map<String, Double> revenueMap = new LinkedHashMap<>();

        String[] months = {
            "Jan","Feb","Mar","Apr","May","Jun",
            "Jul","Aug","Sep","Oct","Nov","Dec"
        };

        // Initialize all months with 0
        for (String m : months) {
            revenueMap.put(m, 0.0);
        }

        String sql = """
            SELECT MONTH(check_in_date) AS month,
                   IFNULL(SUM(total_amount),0) AS revenue
            FROM reservations
            WHERE YEAR(check_in_date) = ?
              AND status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')
            GROUP BY MONTH(check_in_date)
            ORDER BY month
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                int monthNumber = rs.getInt("month");
                double revenue = rs.getDouble("revenue");

                revenueMap.put(months[monthNumber - 1], revenue);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return revenueMap;
    }

    // ================= RESERVATION STATUS COUNTS =================
    @Override
    public Map<String, Integer> getReservationStatusCounts() {

        Map<String, Integer> statusMap = new LinkedHashMap<>();

        // Initialize all possible statuses to avoid null in pie chart
        statusMap.put("CONFIRMED", 0);
        statusMap.put("CHECKED_IN", 0);
        statusMap.put("CHECKED_OUT", 0);
        statusMap.put("CANCELLED", 0);
        statusMap.put("PENDING", 0);
        statusMap.put("NO_SHOW", 0);

        String sql = """
            SELECT status, COUNT(*) AS total
            FROM reservations
            GROUP BY status
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                String status = rs.getString("status");
                int total = rs.getInt("total");

                statusMap.put(status, total);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return statusMap;
    }
}