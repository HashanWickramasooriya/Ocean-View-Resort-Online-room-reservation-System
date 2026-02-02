package com.oceanview.dao;

import com.oceanview.entity.Reservation;
import com.oceanview.entity.ReservationDetails;

import java.util.List;

public interface ReservationDAO {

    String generateReservationId();

    boolean isRoomAvailable(int roomId, String checkIn, String checkOut);

    boolean createReservation(Reservation reservation);

    List<Reservation> getAllReservations();

    Reservation getReservationById(String reservationId);

    boolean updateReservation(Reservation reservation);

    boolean cancelReservation(String reservationId);

    
    List<ReservationDetails> getAllReservationDetails();

    ReservationDetails getReservationDetailsById(String reservationId);

    
    List<ReservationDetails> searchReservations(String q, String status, String fromDate, String toDate);
}
