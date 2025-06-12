package com.quiz.su25.controller;

import com.google.gson.JsonObject;
import com.quiz.su25.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/check-session")
public class SessionCheckController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        JsonObject result = new JsonObject();
        // Luôn trả về valid=true vì chúng ta đang sử dụng user ID cứng
        result.addProperty("valid", true);
        
        out.write(result.toString());
    }
} 