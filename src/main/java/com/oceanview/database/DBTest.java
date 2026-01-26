package com.oceanview.database;

import java.sql.Connection;
import com.oceanview.database.DBConnection;

public class DBTest {

    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {

            if (con != null) {
                System.out.println("✅ Database connected successfully!");
            } else {
                System.out.println("❌ Database connection failed!");
            }

        } catch (Exception e) {
            System.out.println("❌ Error connecting to database!");
            e.printStackTrace();
        }
    }
}