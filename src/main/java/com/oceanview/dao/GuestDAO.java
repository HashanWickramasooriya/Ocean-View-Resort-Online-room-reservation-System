package com.oceanview.dao;

import com.oceanview.entity.Guest;

public interface GuestDAO {
    int createGuest(Guest guest);
    Guest getGuestById(int guestId);
 

}
