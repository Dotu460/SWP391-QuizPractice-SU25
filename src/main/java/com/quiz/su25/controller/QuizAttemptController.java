/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;

/**
 *
 * @author kenngoc
 */
@WebServlet(name = "QuizAttemptController", urlPatterns = {"/quiz-attempt"})
public class QuizAttemptController extends HttpServlet {

    private final UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet QuizAttemptController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizAttemptController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("home");
            return;
        }

        switch (action) {
            case "start":
                startQuizAttempt(request, response);
                break;
            case "end":
                endQuizAttempt(request, response);
                break;
            default:
                response.sendRedirect("home");
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void startQuizAttempt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String quizIdStr = request.getParameter("quizId");

        if (userId == null || quizIdStr == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            Integer quizId = Integer.parseInt(quizIdStr);
            
            // Check if user already has an in-progress attempt
            UserQuizAttempts existingAttempt = attemptsDAO.findLatestAttempt(userId, quizId);
            if (existingAttempt != null && GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS.equals(existingAttempt.getStatus())) {
                // Redirect to the existing attempt
                response.sendRedirect(request.getContextPath() + "/quiz-handle?id=" + quizId);
                return;
            }

            // Create new attempt
            UserQuizAttempts newAttempt = UserQuizAttempts.builder()
                    .user_id(userId)
                    .quiz_id(quizId)
                    .start_time(Date.valueOf(LocalDate.now()))
                    .status(GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS)
                    .created_at(Date.valueOf(LocalDate.now()))
                    .update_at(Date.valueOf(LocalDate.now()))
                    .build();

            int attemptId = attemptsDAO.insert(newAttempt);
            if (attemptId > 0) {
                // Redirect to the quiz handle page with the new attempt ID
                response.sendRedirect(request.getContextPath() + "/quiz-handle?id=" + quizId);
            } else {
                // Handle error - could not create attempt
                request.setAttribute("error", "Could not start quiz attempt. Please try again.");
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    private void endQuizAttempt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String attemptIdStr = request.getParameter("attemptId");
        
        if (attemptIdStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            Integer attemptId = Integer.parseInt(attemptIdStr);
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            
            if (attempt != null) {
                // Only update if the attempt is still in progress
                if (GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS.equals(attempt.getStatus())) {
                    attempt.setEnd_time(Date.valueOf(LocalDate.now()));
                    attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
                    attempt.setUpdate_at(Date.valueOf(LocalDate.now()));
                    
                    if (attemptsDAO.update(attempt)) {
                        // Redirect to results page
                        response.sendRedirect("quiz-results?attemptId=" + attemptId);
                    } else {
                        // Handle error - could not update attempt
                        request.setAttribute("error", "Could not end quiz attempt. Please try again.");
                        response.sendRedirect(request.getContextPath() + "/home");
                    }
                } else {
                    // Attempt is already completed
                    response.sendRedirect("quiz-results?attemptId=" + attemptId);
                }
            } else {
                response.sendRedirect("home");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}
