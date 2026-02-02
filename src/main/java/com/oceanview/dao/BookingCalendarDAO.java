package com.oceanview.dao;

import java.util.List;

public interface BookingCalendarDAO {
    boolean markBookedDates(int roomId, String reservationId, String checkIn, String checkOut);
    List<String> getBookedDates(int roomId);
    boolean clearReservationDates(String reservationId);
    
    
}
