package com.oceanview.database;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionFactory {

    private DBConnectionFactory() {
    }

    public static Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }
}
