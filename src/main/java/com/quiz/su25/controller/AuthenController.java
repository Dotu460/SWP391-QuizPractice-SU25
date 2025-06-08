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
@WebServlet(name="AuthenController", urlPatterns={"/login","/register","/verifyOTP","/resendOTP","/forgot-password","/reset-password"})
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
            case "/resendOTP":
                resendOTP(request, response);
                break;
            case "/forgot-password":
                forgotPassword(request, response);
                break;
            case "/reset-password":
                resetPassword(request, response);
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
    private void verifyOTP(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String OTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String OTPInSession = (String) session.getAttribute("OTP");
        
        try {
            //check OTP
            if(OTP.equals(OTPInSession)) {
                // Lấy thông tin user từ session
                String fullName = (String) session.getAttribute("fullName");
                String password = (String) session.getAttribute("password");
                String mobile = (String) session.getAttribute("mobile");
                String genderStr = (String) session.getAttribute("gender");
                
                // Xử lý gender an toàn
                int gender = 0; // Giá trị mặc định nếu gender là null
                if (genderStr != null && genderStr.equals("male")) {
                    gender = 1;
                }

                // Tạo user mới
                User newUser = User.builder()
                    .full_name(fullName)
                    .email(email)
                    .password(password)
                    .gender(gender)
                    .mobile(mobile)
                    .avatar_url(null)  // Default avatar
                    .role_id(2)        // Default role for regular users
                    .status("active")  // Default status
                    .build();

                // Lưu user vào database
                int userId = userDAO.insert(newUser);

                if (userId > 0) {
                    // Xóa thông tin trong session
                    session.removeAttribute("OTP");
                    session.removeAttribute("email");
                    session.removeAttribute("fullName");
                    session.removeAttribute("password");
                    session.removeAttribute("mobile");
                    session.removeAttribute("gender");

                    // Thêm thông báo thành công
                    request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.setAttribute("type", "success");

                    // Chuyển về trang login
                    request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
                    request.getRequestDispatcher("view/authen/login/otp.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Mã OTP không đúng. Vui lòng thử lại.");
                request.getRequestDispatcher("view/authen/login/otp.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
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
            
            // Create new user
            User newUser = User.builder()
                    .full_name(fullName)
                    .email(email)
                    .password(password)
                    .gender(gender)
                    .mobile(mobile)
                    .avatar_url(null)  // Default avatar
                    .role_id(2)        // Default role for regular users
                    .status("active")  // Default status
                    .build();
            
            // Insert user into database
            int userId = userDAO.insert(newUser);
            
            if (userId > 0) {
                // Registration successful
                String OTP = EmailUtils.sendOTPMail(email);
                session.setAttribute("OTP", OTP);
                session.setAttribute("email", email);
                request.getRequestDispatcher("otp.jsp").forward(request, response);
            } else {
                // Registration failed
                request.setAttribute("message", "Registration failed. Please try again.");
                request.setAttribute("type", "danger");
                request.getRequestDispatcher("view/authen/register/register.jsp").forward(request, response);
            }
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
        response.setContentType("text/plain;charset=UTF-8");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        try {
            if (email != null && !email.isEmpty()) {
                // Tạo và gửi OTP mới
                String newOTP = EmailUtils.sendOTPMail(email);
                session.setAttribute("OTP", newOTP);
                
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
        } catch (Exception e) {
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
}
