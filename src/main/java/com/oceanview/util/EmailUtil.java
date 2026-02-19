package com.oceanview.util;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    private static final String SMTP_USER = " oceanviewresort.booking@gmail.com";

    private static final String SMTP_PASS = "ytnugsvyrsgwjhwu";

    private static Session buildSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); 
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });
    }

    public static void sendTextEmail(String to, String subject, String body) {
        if (to == null || to.trim().isEmpty()) return;

        try {
            Session session = buildSession();
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SMTP_USER));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);
            msg.setText(body);
            Transport.send(msg);
            System.out.println(" Text email sent to " + to);
        } catch (Exception e) {
            System.out.println(" Text email sending failed!");
            e.printStackTrace();
        }
    }

    public static void sendHtmlEmail(String to, String subject, String htmlBody) {
        if (to == null || to.trim().isEmpty()) return;

        try {
            Session session = buildSession();
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SMTP_USER));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);

            msg.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println(" HTML email sent to " + to);
        } catch (Exception e) {
            System.out.println(" HTML email sending failed!");
            e.printStackTrace();
        }
    }
}
