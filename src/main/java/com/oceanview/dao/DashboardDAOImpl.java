package com.oceanview.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
            WHERE MONTH(created_at) = MONTH(CURRENT_DATE())
              AND YEAR(created_at) = YEAR(CURRENT_DATE())
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}