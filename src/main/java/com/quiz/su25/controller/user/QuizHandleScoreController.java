package com.quiz.su25.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "QuizHandleScoreController", urlPatterns = {"/quiz-handle-score"})
public class QuizHandleScoreController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Forward to the score page
            request.getRequestDispatcher("/view/user/quizHandle/quiz-handle-score.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in QuizHandleScoreController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/quiz-handle-menu");
        }
    }
} 