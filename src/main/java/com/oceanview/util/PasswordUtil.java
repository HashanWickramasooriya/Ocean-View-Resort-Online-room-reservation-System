package com.oceanview.util;

import org.mindrot.jbcrypt.BCrypt;


public class PasswordUtil {

   
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

   
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            throw new IllegalArgumentException("Invalid hash provided for comparison");
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public static void main(String[] args) {
        String plain = "admin123";
        String hash = hashPassword(plain);
        System.out.println("Plain: " + plain);
        System.out.println("Hash: " + hash);
        System.out.println("Check: " + checkPassword("admin123", hash));
    }
}
