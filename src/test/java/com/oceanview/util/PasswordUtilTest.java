package com.oceanview.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilTest {

    // Hash Password
  
    @Test
    void testHashPassword() {

        String plain = "admin123";
        String hash = PasswordUtil.hashPassword(plain);

        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$"));
        assertNotEquals(plain, hash);
    }

    // Verify Password (Correct)
    @Test
    void testVerifyPasswordCorrect() {

        String plain = "admin123";
        String hash = PasswordUtil.hashPassword(plain);

        boolean result = PasswordUtil.checkPassword("admin123", hash);

        assertTrue(result);
    }

    //  Verify Password (Incorrect)
   
    @Test
    void testVerifyPasswordIncorrect() {

        String hash = PasswordUtil.hashPassword("admin123");

        boolean result = PasswordUtil.checkPassword("wrongpass", hash);

        assertFalse(result);
    }

    //  Invalid Hash
   
    @Test
    void testInvalidHash() {

        Exception exception = assertThrows(
                IllegalArgumentException.class,
                () -> PasswordUtil.checkPassword("admin123", "invalidHash")
        );

        assertEquals("Invalid hash provided for comparison", exception.getMessage());
    }
}