package com.oceanview.dao;

import com.oceanview.entity.Reservation;
import java.util.List;

public interface ReservationDAO {
    String generateReservationId();
    boolean isRoomAvailable(int roomId, String checkIn, String checkOut);
    boolean createReservation(Reservation reservation);
    List<Reservation> getAllReservations();
    Reservation getReservationById(String reservationId);
    boolean updateReservation(Reservation reservation);
    boolean cancelReservation(String reservationId);
}
