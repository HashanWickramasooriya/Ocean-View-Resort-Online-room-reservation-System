package com.oceanview.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BillingCalculatorTest {

    // Calculate Nights
   
    @Test
    void testCalculateNights() {

        long nights = BillingCalculator.nights("2026-03-01", "2026-03-05");

        assertEquals(4, nights);
    }

    //  Calculate Total (Normal Case)
   
    @Test
    void testCalculateTotal() {

        double total = BillingCalculator.calculateTotal(
                10000,    
                3,       
                2,       
                "2026-03-01",
                "2026-03-04"
        );

        // nights = 3
        // room cost = 10000 * 3 = 30000
        // extra guest = (3-2)=1 → 1*500*3 = 1500
        // subtotal = 31500
        // tax 10% = 3150
        // total = 34650

        assertEquals(34650, total);
    }

    // Zero Nights / Invalid Date Range
    
    @Test
    void testInvalidDateRange() {

        double total = BillingCalculator.calculateTotal(
                10000,
                2,
                2,
                "2026-03-05",
                "2026-03-01"
        );

        assertEquals(0, total);
    }

    // No Extra Guests
   
    @Test
    void testNoExtraGuests() {

        double total = BillingCalculator.calculateTotal(
                10000,
                2,
                2,
                "2026-03-01",
                "2026-03-03"
        );

        // nights = 2
        // room cost = 20000
        // no extra guest
        // tax = 2000
        // total = 22000

        assertEquals(22000, total);
    }
}