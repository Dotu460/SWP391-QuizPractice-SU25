package com.quiz.su25.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.ServletException;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.RoleDAO;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.Role;
import java.util.Map;

@WebServlet("/test2")
public class TestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve 2 thong tin user va role
        UserDAO userDAO = new UserDAO();
        RoleDAO roleDAO = new RoleDAO();
        Map<Integer, User> mapUser = userDAO.findAllMap();
        Map<Integer, Role> mapRole = roleDAO.findAllMap();
        
        
        //set vao request
        request.setAttribute("mapUser", mapUser);
        request.setAttribute("mapRole", mapRole);

        //chuyen sang trang test.jsp
        request.getRequestDispatcher("test.jsp").forward(request, response);
    }
}
