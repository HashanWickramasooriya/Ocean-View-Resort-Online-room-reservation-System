package com.oceanview.dao;

import java.util.Map;


public interface DashboardDAO {

    public int getTotalUsers();

    public int getTotalRooms();

    public int getTotalReservations();

    public double getMonthlyRevenue();
    Map<String, Double> getRevenueByMonth(int year);
    
    Map<String, Integer> getReservationStatusCounts();
    
}
