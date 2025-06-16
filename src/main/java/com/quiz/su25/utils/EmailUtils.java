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
 * Utility class for handling email operations in the application.
 * Provides functionality for:
 * - Sending general emails
 * - Sending OTP verification emails
 * - Sending registration confirmation emails
 */
public class EmailUtils {
//    private static final String USERNAME_EMAIL = "trinhkhanhlinh60@gmail.com";
//    private static final String PASSWORD_APP_EMAIL = "nkbm sttl hpaj pmrw";

    // Email configuration constants
    private static final String USERNAME_EMAIL = "tienhoang1524@gmail.com";
    private static final String PASSWORD_APP_EMAIL = "rdzs hcay eesp wfiy";

    
    /**
     * Sends a general email with HTML content
     * @param to Recipient email address
     * @param subject Email subject
     * @param content HTML content of the email
     * @return true if email sent successfully
     * @throws AddressException if email address is invalid
     * @throws MessagingException if there's an error sending the email
     */
    public static boolean sendMail(String to, String subject, String content) throws AddressException, MessagingException{
        // Configure email properties
        Properties props = new Properties();
        props.put("mail.smtp.host","smtp.gmail.com");
        props.put("mail.smtp.port","587");
        props.put("mail.smtp.auth","true");
        props.put("mail.smtp.starttls.enable","true");
        
        // Create email session with authentication
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
        
        // Send the email
        Transport.send(message);
        return true;
    }
    /**
     * Sends an OTP verification email
     * @param to Recipient email address
     * @return Generated OTP as a string
     */
    public static String sendOTPMail(String to){
        // Generate 6-digit OTP
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
    /**
     * Generates a random OTP of specified length
     * @param i Length of the OTP
     * @return Generated OTP as an integer
     */
    private static int generateOTP(int i) {
        int otp = (int)(Math.random() * Math.pow(10,i));
        return otp;
    }
//    public static void main(String[] args){
//        try {
//            sendMail("khanhlinhtrinh323@gmail.com","test tao mail","helooo");
//        } catch (MessagingException ex) {
//            Logger.getLogger(EmailUtils.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }

    // SMTP configuration constants
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USERNAME = "tienhoang1524@gmail.com"; // Replace with your email
    private static final String SMTP_PASSWORD = "rdzs hcay eesp wfiy"; // Replace with your app password

    /**
     * Sends a registration confirmation email with detailed information
     * @param toEmail Recipient email address
     * @param fullName Recipient's full name
     * @param password Account password (null for existing users)
     * @param subjectTitle Title of the registered subject
     * @param validFrom Registration validity start date
     * @param validTo Registration validity end date
     * @param notes Additional notes to include in the email
     */
    public static void sendRegistrationEmail(String toEmail, String fullName, String password, String subjectTitle, String validFrom, String validTo, String notes) {
        // Configure email properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Create email session with authentication
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });

        try {
            // Create and configure email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Welcome to Quiz Practice - Your Account Information");

            // Generate HTML email content with styling
            String emailContent = String.format("""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            line-height: 1.6;
                            color: #333;
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                        }
                        .header {
                            background-color: #4A90E2;
                            color: white;
                            padding: 20px;
                            text-align: center;
                            border-radius: 5px 5px 0 0;
                        }
                        .content {
                            background-color: #ffffff;
                            padding: 20px;
                            border: 1px solid #e0e0e0;
                            border-radius: 0 0 5px 5px;
                        }
                        .section {
                            margin-bottom: 20px;
                            padding: 15px;
                            background-color: #f8f9fa;
                            border-radius: 5px;
                        }
                        .section-title {
                            color: #4A90E2;
                            font-weight: bold;
                            margin-bottom: 10px;
                        }
                        .info-item {
                            margin: 10px 0;
                        }
                        .label {
                            font-weight: bold;
                            color: #666;
                        }
                        .value {
                            color: #333;
                        }
                        .button {
                            display: inline-block;
                            padding: 10px 20px;
                            background-color: #4A90E2;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            margin: 20px 0;
                        }
                        .footer {
                            text-align: center;
                            margin-top: 20px;
                            padding-top: 20px;
                            border-top: 1px solid #e0e0e0;
                            color: #666;
                            font-size: 0.9em;
                        }
                        .important {
                            background-color: #fff3cd;
                            border-left: 4px solid #ffc107;
                            padding: 10px;
                            margin: 10px 0;
                        }
                        .notes {
                            background-color: #e3f2fd;
                            border-left: 4px solid #2196f3;
                            padding: 10px;
                            margin: 10px 0;
                        }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Welcome to Quiz Practice!</h1>
                    </div>
                    <div class="content">
                        <p>Dear %s,</p>
                        
                        <p>Welcome to Quiz Practice! Your account has been successfully created. We're excited to have you on board!</p>
                        
                        <div class="section">
                            <div class="section-title">📱 Login Information</div>
                            <div class="info-item">
                                <span class="label">Email:</span>
                                <span class="value">%s</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Password:</span>
                                <span class="value">%s</span>
                            </div>
                            <a href="http://localhost:9999/SWP391_QuizPractice/login" class="button">Login Now</a>
                        </div>
                        
                        <div class="section">
                            <div class="section-title">📚 Registration Details</div>
                            <div class="info-item">
                                <span class="label">Subject:</span>
                                <span class="value">%s</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Valid From:</span>
                                <span class="value">%s</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Valid To:</span>
                                <span class="value">%s</span>
                            </div>
                        </div>
                        
                        %s
                        
                        <div class="important">
                            <strong>Important Notes:</strong>
                            <ul>
                                <li>Please change your password after your first login</li>
                                <li>Keep your login credentials secure</li>
                                <li>If you have any questions, please contact our support team</li>
                            </ul>
                        </div>
                        
                        <p>We're here to help you succeed in your learning journey!</p>
                        
                        <div class="footer">
                            <p>Best regards,<br>Quiz Practice Team</p>
                            <p>This is an automated message, please do not reply directly to this email.</p>
                        </div>
                    </div>
                </body>
                </html>
                """, 
                fullName, toEmail, password, subjectTitle, validFrom, validTo,
                notes != null && !notes.trim().isEmpty() ? 
                    String.format("""
                        <div class="notes">
                            <div class="section-title">📝 Additional Notes</div>
                            <p>%s</p>
                        </div>
                        """, notes) : "");

            // Set email content and send
            message.setContent(emailContent, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("Registration email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.out.println("Error sending registration email: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Sends a payment confirmation email with detailed information
     * @param toEmail Recipient email address
     * @param fullName Recipient's full name
     * @param subjectTitle Title of the registered subject
     * @param validFrom Registration validity start date
     * @param validTo Registration validity end date
     * @param notes Additional notes to include in the email
     */
    public static void sendPaymentConfirmationEmail(String toEmail, String fullName, String subjectTitle, String validFrom, String validTo, String notes) {
        // Configure email properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Create email session with authentication
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });

        try {
            // Create and configure email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Payment Confirmation - Quiz Practice");

            // Generate HTML email content with styling
            String emailContent = String.format("""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            line-height: 1.6;
                            color: #333;
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                        }
                        .header {
                            background-color: #28a745;
                            color: white;
                            padding: 20px;
                            text-align: center;
                            border-radius: 5px 5px 0 0;
                        }
                        .content {
                            background-color: #ffffff;
                            padding: 20px;
                            border: 1px solid #e0e0e0;
                            border-radius: 0 0 5px 5px;
                        }
                        .section {
                            margin-bottom: 20px;
                            padding: 15px;
                            background-color: #f8f9fa;
                            border-radius: 5px;
                        }
                        .section-title {
                            color: #28a745;
                            font-weight: bold;
                            margin-bottom: 10px;
                        }
                        .info-item {
                            margin: 10px 0;
                        }
                        .label {
                            font-weight: bold;
                            color: #666;
                        }
                        .value {
                            color: #333;
                        }
                        .button {
                            display: inline-block;
                            padding: 10px 20px;
                            background-color: #28a745;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            margin: 20px 0;
                        }
                        .footer {
                            text-align: center;
                            margin-top: 20px;
                            padding-top: 20px;
                            border-top: 1px solid #e0e0e0;
                            color: #666;
                            font-size: 0.9em;
                        }
                        .important {
                            background-color: #d4edda;
                            border-left: 4px solid #28a745;
                            padding: 10px;
                            margin: 10px 0;
                        }
                        .notes {
                            background-color: #e3f2fd;
                            border-left: 4px solid #2196f3;
                            padding: 10px;
                            margin: 10px 0;
                        }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Payment Confirmation</h1>
                    </div>
                    <div class="content">
                        <p>Dear %s,</p>
                        
                        <p>We are pleased to confirm that your payment has been successfully processed. Your registration is now active!</p>
                        
                        <div class="section">
                            <div class="section-title">📚 Registration Details</div>
                            <div class="info-item">
                                <span class="label">Subject:</span>
                                <span class="value">%s</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Valid From:</span>
                                <span class="value">%s</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Valid To:</span>
                                <span class="value">%s</span>
                            </div>
                        </div>
                        
                        %s
                        
                        <div class="important">
                            <strong>Important Notes:</strong>
                            <ul>
                                <li>You can now access all features of the course</li>
                                <li>Your access will be valid until the end date specified above</li>
                                <li>If you have any questions, please contact our support team</li>
                            </ul>
                        </div>
                        
                        <a href="http://localhost:9999/SWP391_QuizPractice/login" class="button">Access Your Course</a>
                        
                        <div class="footer">
                            <p>Best regards,<br>Quiz Practice Team</p>
                            <p>This is an automated message, please do not reply directly to this email.</p>
                        </div>
                    </div>
                </body>
                </html>
                """, 
                fullName, subjectTitle, validFrom, validTo,
                notes != null && !notes.trim().isEmpty() ? 
                    String.format("""
                        <div class="notes">
                            <div class="section-title">📝 Additional Notes</div>
                            <p>%s</p>
                        </div>
                        """, notes) : "");

            // Set email content and send
            message.setContent(emailContent, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("Payment confirmation email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.out.println("Error sending payment confirmation email: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Main method for testing email functionality
     */
    public static void main(String[] args) {
        System.out.println("=== Testing Email Sending ===");
        
        // Test data
        String testEmail = "33b3kwornd@illubd.com"; // Replace with your test email
        String testName = "Test User";
        String testPassword = "TestPass123";
        String testSubject = "Java Programming";
        String testValidFrom = "2024-03-15";
        String testValidTo = "2024-06-15";

        System.out.println("Sending test email to: " + testEmail);
        System.out.println("Test data:");
        System.out.println("- Name: " + testName);
        System.out.println("- Password: " + testPassword);
        System.out.println("- Subject: " + testSubject);
        System.out.println("- Valid From: " + testValidFrom);
        System.out.println("- Valid To: " + testValidTo);
        System.out.println("\nAttempting to send email...");

        try {
            sendRegistrationEmail(
                testEmail,
                testName,
                testPassword,
                testSubject,
                testValidFrom,
                testValidTo,
                "This is a test email. Please ignore if you are not the intended recipient."
            );
            System.out.println("\nTest completed successfully!");
        } catch (Exception e) {
            System.out.println("\nTest failed with error:");
            e.printStackTrace();
        }
    }
}
