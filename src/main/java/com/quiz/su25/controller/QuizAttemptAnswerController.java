/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptAnswersDAO;
import com.quiz.su25.entity.UserQuizAttempts;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
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
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author kenngoc
 */
@WebServlet(name = "QuizAttemptAnswerController", urlPatterns = {"/quiz-attempt-answer"})
public class QuizAttemptAnswerController extends HttpServlet {

    private final UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
    private final UserQuizAttemptAnswersDAO answersDAO = new UserQuizAttemptAnswersDAO();

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
            out.println("<title>Servlet QuizAttemptAnswerController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizAttemptAnswerController at " + request.getContextPath() + "</h1>");
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
        String attemptIdStr = request.getParameter("attemptId");
        
        if (attemptIdStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            Integer attemptId = Integer.parseInt(attemptIdStr);
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            
            if (attempt == null || !GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS.equals(attempt.getStatus())) {
                response.sendRedirect("home");
                return;
            }

            // Forward to the quiz attempt page
            request.setAttribute("attempt", attempt);
            request.getRequestDispatcher("quiz-attempt.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
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
        String attemptIdStr = request.getParameter("attemptId");
        String action = request.getParameter("action");
        
        if (attemptIdStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            Integer attemptId = Integer.parseInt(attemptIdStr);
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            
            if (attempt == null || !GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS.equals(attempt.getStatus())) {
                response.sendRedirect("home");
                return;
            }

            if ("save_answer".equals(action)) {
                saveAnswer(request, response, attempt);
            } else if ("submit_quiz".equals(action)) {
                submitQuiz(request, response, attempt);
            } else {
                response.sendRedirect("home");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    /**
     * Lưu câu trả lời cho một câu hỏi trong attempt
     * @param request HttpServletRequest chứa thông tin câu trả lời
     * @param response HttpServletResponse
     * @param attempt UserQuizAttempts object
     * @throws ServletException
     * @throws IOException
     */
    public void saveAnswer(HttpServletRequest request, HttpServletResponse response, UserQuizAttempts attempt)
            throws ServletException, IOException {
        // Get the answer data from the request
        String questionIdStr = request.getParameter("questionId");
        String selectedOptionIdStr = request.getParameter("selectedOptionId");
        String isCorrectStr = request.getParameter("isCorrect");
        
        if (questionIdStr == null || selectedOptionIdStr == null || isCorrectStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try {
            Integer questionId = Integer.parseInt(questionIdStr);
            Integer selectedOptionId = Integer.parseInt(selectedOptionIdStr);
            Boolean isCorrect = Boolean.parseBoolean(isCorrectStr);

            // Check if answer already exists for this question
            UserQuizAttemptAnswers existingAnswer = answersDAO.findByAttemptAndQuestionId(attempt.getId(), questionId);
            
            if (existingAnswer != null) {
                // Update existing answer
                existingAnswer.setSelected_option_id(selectedOptionId);
                existingAnswer.setCorrect(isCorrect);
                existingAnswer.setAnswer_at(Date.valueOf(LocalDate.now()));
                answersDAO.update(existingAnswer);
            } else {
                // Create new answer
                UserQuizAttemptAnswers newAnswer = UserQuizAttemptAnswers.builder()
                        .attempt_id(attempt.getId())
                        .quiz_question_id(questionId)
                        .selected_option_id(selectedOptionId)
                        .correct(isCorrect)
                        .answer_at(Date.valueOf(LocalDate.now()))
                        .build();
                answersDAO.insert(newAnswer);
            }
            
            // Send success response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private void submitQuiz(HttpServletRequest request, HttpServletResponse response, UserQuizAttempts attempt)
            throws ServletException, IOException {
        // Calculate final score
        int totalQuestions = answersDAO.findByAttemptId(attempt.getId()).size();
        int correctAnswers = answersDAO.countCorrectAnswers(attempt.getId());
        
        if (totalQuestions > 0) {
            double score = (double) correctAnswers / totalQuestions * 100;
            boolean passed = score >= 60; // Assuming 60% is passing score
            
            // Update attempt with final score
            attempt.setScore(score);
            attempt.setPassed(passed);
            attempt.setEnd_time(Date.valueOf(LocalDate.now()));
            attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
            attempt.setUpdate_at(Date.valueOf(LocalDate.now()));
            
            attemptsDAO.update(attempt);
        }
        
        // Redirect to results page
        response.sendRedirect("quiz-results?attemptId=" + attempt.getId());
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

}
