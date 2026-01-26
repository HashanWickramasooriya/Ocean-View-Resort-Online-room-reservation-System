package com.oceanview.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil handles password hashing and verification using BCrypt.
 */
public class PasswordUtil {

    /**
     * Hash a plain-text password using BCrypt.
     *
     * @param plainPassword The plain-text password
     * @return Hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Check a plain-text password against a hashed password.
     *
     * @param plainPassword The plain-text password
     * @param hashedPassword The hashed password from DB
     * @return true if matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            throw new IllegalArgumentException("Invalid hash provided for comparison");
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    // Optional: Generate a test main
    public static void main(String[] args) {
        String plain = "admin123";
        String hash = hashPassword(plain);
        System.out.println("Plain: " + plain);
        System.out.println("Hash: " + hash);
        System.out.println("Check: " + checkPassword("admin123", hash));
    }
}
