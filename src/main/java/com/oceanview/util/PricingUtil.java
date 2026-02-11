package com.oceanview.util;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class PricingUtil {

    public static final double TAX_RATE = 0.10;           
    public static final double EXTRA_GUEST_FEE = 500.00; 

    public static double calculateTotal(double ratePerNight, String checkIn, String checkOut, int guests) {

        LocalDate in = LocalDate.parse(checkIn);
        LocalDate out = LocalDate.parse(checkOut);

        long nights = ChronoUnit.DAYS.between(in, out);
        if (nights <= 0) nights = 1;

        double roomBase = ratePerNight * nights;

        int extraGuests = Math.max(0, guests - 1);
        double extraFee = extraGuests * EXTRA_GUEST_FEE * nights;

        double subTotal = roomBase + extraFee;
        double tax = subTotal * TAX_RATE;

        return subTotal + tax;
    }
}
