package com.quiz.su25.controller;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;    

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.utils.EmailUtils;
@WebServlet(name="AuthenController", urlPatterns={"/login","/register","/verifyOTP","/forgot-password","/reset-password","/resendOTP","/newpassword","/registerverifyOTP"})
public class AuthenController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
                break;
            case "/forgot-password":
                request.getRequestDispatcher("view/authen/login/forgot-password.jsp").forward(request, response);
                break;
            case "/reset-password":
                request.getRequestDispatcher("view/authen/login/reset-password.jsp").forward(request, response);
                break;
            case "/verifyOTP":
                request.getRequestDispatcher("view/authen/login/otp.jsp").forward(request, response);
                break;
            case "//registerverifyOTP":
                request.getRequestDispatcher("view/authen/register/register_otp.jsp").forward(request, response);
                break;  
            case "/newpassword":
                request.getRequestDispatcher("view/authen/register/newpassword.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
                break;
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                login(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
                registerDoPost(request, response);
                break;
            case "/verifyOTP":
                verifyOTP(request, response);
                break;
            case "/registerverifyOTP":
                registerverifyOTP(request,response);
                break;
            case "/resendOTP":
                resendOTP(request, response);
                break;
            case "/forgot-password":
                forgotPassword(request, response);
                break;
            case "/reset-password":
                resetPassword(request, response);
                break;
            case "/newpassword":
                newPassword(request, response);
                break;
            default:
                login(request, response);
                break;
        }
    }

    public void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");        
        
        try {
            User user = userDAO.findByEmailAndPassword(email, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute(GlobalConfig.SESSION_ACCOUNT, user);
               
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
        }
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Check if it's an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            // For AJAX requests, send a 200 OK status
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            // For regular requests, redirect to home
            response.sendRedirect("home");
        }
    }
    private void registerverifyOTP(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String OTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        String OTPInSession = (String) session.getAttribute("OTP");

        // Check OTP
        if(OTP.equals(OTPInSession)) {
            request.getRequestDispatcher("view/authen/register/newpassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Mã OTP không đúng. Vui lòng thử lại.");
            request.getRequestDispatcher("view/authen/register/register_otp.jsp").forward(request, response);
        }
    }
    private void verifyOTP(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String OTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        String OTPInSession = (String) session.getAttribute("OTP");

        // Check OTP
        if(OTP.equals(OTPInSession)) {
            request.getRequestDispatcher("view/authen/login/reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Mã OTP không đúng. Vui lòng thử lại.");
            request.getRequestDispatcher("view/authen/login/otp.jsp").forward(request, response);
        }
    }
    public void registerDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String genderStr = request.getParameter("gender");
        
        if (genderStr == null || genderStr.trim().isEmpty()) {
            request.setAttribute("message", "Please select gender.");
            request.setAttribute("type", "danger");
            request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession();
        int gender = "male".equals(genderStr) ? 1 : 0;
        try {
            // Check if email already exists
            if (userDAO.isEmailExist(email)) {
                request.setAttribute("message", "Email already exists. Please use a different email.");
                request.setAttribute("type", "danger");
                request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
                return;
            }
            
            // Save user information to session for later use
            session.setAttribute("fullName", fullName);
            session.setAttribute("password", password);
            session.setAttribute("email", email);
            session.setAttribute("mobile", mobile);
            session.setAttribute("gender", genderStr);
            
            // Generate and send OTP
            String OTP = EmailUtils.sendOTPMail(email);
            session.setAttribute("OTP", OTP);
            // Set OTP creation time
            session.setAttribute("OTPCreationTime", System.currentTimeMillis());
            
            // Forward to OTP verification page
            request.getRequestDispatcher("view/authen/register/register_otp.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Handle exceptions
            request.setAttribute("message", "An error occurred during registration: " + e.getMessage());
            request.setAttribute("type", "danger");
            request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
        }
    }

    private void forgotPassword(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try {
            // Kiểm tra email có tồn tại trong database không
            boolean emailExists = userDAO.isEmailExist(email);
            
            if (emailExists) {
                // Tạo OTP mới
                String OTP = EmailUtils.sendOTPMail(email);
                
                // Lưu thông tin vào session
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("OTP", OTP);
                session.setAttribute("OTPCreationTime", System.currentTimeMillis());
                session.setAttribute("isPasswordReset", true); // Đánh dấu đây là quá trình reset password
                
                // Chuyển đến trang nhập OTP
                request.getRequestDispatcher("view/authen/login/otp.jsp").forward(request, response);
            } else {
                // Email không tồn tại
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.getRequestDispatcher("view/authen/login/forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("view/authen/login/forgot-password.jsp").forward(request, response);
        }
    }

    private void resendOTP(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        System.out.println(">>> resendOTP servlet called <<<");
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        Boolean isPasswordReset = (Boolean) session.getAttribute("isPasswordReset");
        String isRegistration = request.getParameter("isRegistration");
        
        System.out.println("ResendOTP - Email from session: " + email);
        System.out.println("ResendOTP - isPasswordReset: " + isPasswordReset);
        System.out.println("isRegistration: " + isRegistration);
        System.out.println("Request method: " + request.getMethod());
        System.out.println("All parameters: " + request.getParameterMap().keySet());
        
        try {
            if (email != null && !email.isEmpty()) {
                // For registration flow, don't check email existence
                if ("true".equalsIgnoreCase(isRegistration)) {
                    // Generate and send new OTP
                    String newOTP = EmailUtils.sendOTPMail(email);
                    session.setAttribute("OTP", newOTP);
                    session.setAttribute("OTPCreationTime", System.currentTimeMillis());
                    
                    System.out.println("ResendOTP - Registration flow - New OTP sent to: " + email);
                    response.getWriter().write("success");
                    return;
                }
                
                // For password reset flow
                if (isPasswordReset != null && isPasswordReset) {
                    // Generate and send new OTP
                    String newOTP = EmailUtils.sendOTPMail(email);
                    session.setAttribute("OTP", newOTP);
                    session.setAttribute("OTPCreationTime", System.currentTimeMillis());
                    
                    System.out.println("ResendOTP - Password reset flow - New OTP sent to: " + email);
                    response.getWriter().write("success");
                    return;
                }
                
                // For other flows, check email existence
                if (userDAO.isEmailExist(email)) {
                    // Generate and send new OTP
                    String newOTP = EmailUtils.sendOTPMail(email);
                    session.setAttribute("OTP", newOTP);
                    session.setAttribute("OTPCreationTime", System.currentTimeMillis());
                    
                    System.out.println("ResendOTP - Other flow - New OTP sent to: " + email);
                    response.getWriter().write("success");
                } else {
                    System.out.println("ResendOTP - Email not found in database: " + email);
                    response.getWriter().write("error");
                }
            } else {
                System.out.println("ResendOTP - Email not found in session");
                response.getWriter().write("error");
            }
        } catch (Exception e) {
            System.out.println("ResendOTP - Error: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        Boolean isPasswordReset = (Boolean) session.getAttribute("isPasswordReset");
        
        try {
            // Kiểm tra xem có phải đang trong quá trình reset password không
            if (isPasswordReset == null || !isPasswordReset) {
                request.setAttribute("error", "Invalid password reset request!");
                request.getRequestDispatcher("${pageContext.request.contextPath}/login").forward(request, response);
                return;
            }
            
            // Kiểm tra password và confirm password có khớp không
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match!");
                request.getRequestDispatcher("view/authen/login/reset-password.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật password mới
            boolean success = userDAO.updatePassword(email, password);
            
            if (success) {
                // Xóa các session attributes
                session.removeAttribute("email");
                session.removeAttribute("isPasswordReset");
                session.removeAttribute("OTP");
                
                // Thông báo thành công và chuyển về trang login
                request.setAttribute("message", "Password has been reset successfully!");
                request.setAttribute("type", "success");
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
                request.getRequestDispatcher("view/authen/login/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("view/authen/login/reset-password.jsp").forward(request, response);
        }
    }
    private void newPassword(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();
        
        // Get required data from session
        String email = (String) session.getAttribute("email");
        String mobile = (String) session.getAttribute("mobile");
        
        try {
            // Validate required data
            if (email == null || mobile == null) {
                request.setAttribute("error", "Missing required information. Please start over.");
                request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
                return;
            }
            
            // Validate password match
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match!");
                request.getRequestDispatcher("view/authen/register/newpassword.jsp").forward(request, response);
                return;
            }
            
            // Create new user with only required fields
            User newUser = new User();
            // Set NOT NULL fields
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setMobile(mobile);
            
            // Optional fields - let them be NULL
            String fullName = (String) session.getAttribute("fullName");
            String genderStr = (String) session.getAttribute("gender");
            if (fullName != null) newUser.setFull_name(fullName);
            if (genderStr != null) newUser.setGender("male".equals(genderStr) ? 1 : 0);
            
            // Insert new user
            int userId = userDAO.insert(newUser);
            
            if (userId > 0) {
                // Clear all session attributes
                session.removeAttribute("email");
                session.removeAttribute("OTP");
                session.removeAttribute("OTPCreationTime");
                session.removeAttribute("fullName");
                session.removeAttribute("mobile");
                session.removeAttribute("gender");
                
                // Set success message and redirect to login
                request.setAttribute("message", "Registration completed successfully! Please login.");
                request.setAttribute("type", "success");
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
            } else {
                System.out.println("Failed to insert user. User ID returned: " + userId);
                request.setAttribute("error", "Failed to create account. Please try again.");
                request.getRequestDispatcher("view/authen/register/newpassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error in newPassword: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("view/authen/register/newpassword.jsp").forward(request, response);
        }
    }
}
