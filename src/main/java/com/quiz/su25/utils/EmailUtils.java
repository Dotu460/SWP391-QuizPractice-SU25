/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.utils;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.AddressException;
import java.util.Properties;
import java.util.logging.Logger;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.logging.Level;

/**
 *
 * @author LENOVO
 */
public class EmailUtils {
    private static final String USERNAME_EMAIL = "trinhkhanhlinh60@gmail.com";
    private static final String PASSWORD_APP_EMAIL = "ygut kwfj pcol wnrs";
    
    public static boolean sendMail(String to, String subject, String content) throws AddressException, MessagingException{
        Properties props = new Properties();
        props.put("mail.smtp.host","smtp.gmail.com");
        props.put("mail.smtp.port","587");
        props.put("mail.smtp.auth","true");
        props.put("mail.smtp.starttls.enable","true");
        
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator(){
            @Override
            protected PasswordAuthentication getPasswordAuthentication(){
                return new PasswordAuthentication(USERNAME_EMAIL,PASSWORD_APP_EMAIL);
            }
        });
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(USERNAME_EMAIL));
        message.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(content,"text/html; charset=UTF-8");
        
        Transport.send(message);
        return true;
    }
    public static String sendOTPMail(String to){
        int otp = generateOTP(6);
        String subject = "Ma OTP";
        String content = " Ma OTP cua ban la: " + otp;
        
        try{
            sendMail(to, subject, content);
        }catch(MessagingException ex){
            Logger.getLogger(EmailUtils.class.getName()).log(Level.SEVERE,null,ex);
        }
        return String.valueOf(otp);
    }
        private static int generateOTP(int i) {
            int otp = (int)(Math.random() * Math.pow(10,i));
            return otp;
        }
//    public static void main(String[] args){
//            sendOTPMail("khanhlinhtrinh323@gmail.com");
//    }
}
