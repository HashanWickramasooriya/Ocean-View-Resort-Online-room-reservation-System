package com.oceanview.util;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class BillingCalculator {

    public static final double TAX_RATE = 0.10;           
    public static final double EXTRA_GUEST_FEE = 500.00;  

    public static long nights(String checkIn, String checkOut) {
        LocalDate in = LocalDate.parse(checkIn);
        LocalDate out = LocalDate.parse(checkOut);
        return ChronoUnit.DAYS.between(in, out);
    }

    public static double calculateTotal(double ratePerNight, int guests, int baseGuests, String checkIn, String checkOut) {
        long nights = nights(checkIn, checkOut);
        if (nights <= 0) return 0;

        double roomCost = ratePerNight * nights;

        int extraGuests = Math.max(0, guests - baseGuests);
        double extraGuestCost = extraGuests * EXTRA_GUEST_FEE * nights;

        double subTotal = roomCost + extraGuestCost;
        double tax = subTotal * TAX_RATE;

        return subTotal + tax;
    }
}
