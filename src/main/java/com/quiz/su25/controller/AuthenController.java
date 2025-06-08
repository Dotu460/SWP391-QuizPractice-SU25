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
@WebServlet(name="AuthenController", urlPatterns={"/login","/authen","/register","/otp"})
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
            default :
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
    
    public void registerDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String genderStr = request.getParameter("gender");
        
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
                request.setAttribute("message", "Registration successful. Please login.");
                request.setAttribute("type", "success");
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
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
        String OTP = EmailUtils.sendOTPMail(email);
        session.setAttribute("OTP",OTP);
        session.setAttribute("email",email);
        request.getRequestDispatcher("otp.jsp").forward(request,response);
    }
}
