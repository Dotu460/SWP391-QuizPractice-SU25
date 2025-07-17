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
import java.sql.Timestamp;
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

            // Redirect to the quiz handle page instead of forwarding to a non-existent JSP
            response.sendRedirect(request.getContextPath() + "/quiz-handle?id=" + attempt.getQuiz_id());

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
            return;
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
                return;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
            return;
        }
    }

    /**
     * Xóa tất cả các câu trả lời của một câu hỏi trong một lần thi.
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     */
    public void clearAnswersForQuestion(Integer attemptId, Integer questionId) {
        try {
            //answersDAO.deleteByAttemptAndQuestionId(attemptId, questionId);
        } catch (Exception e) {
            System.err.println("Error in clearAnswersForQuestion: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Lưu một lựa chọn trả lời cho câu hỏi (chỉ thực hiện insert).
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     * @param selectedOptionId ID của lựa chọn (có thể null)
     * @param isCorrect Trạng thái đúng/sai của tổng thể câu hỏi
     */
    public void saveAnswer(Integer attemptId, Integer questionId, Integer selectedOptionId, boolean isCorrect) {
        try {
            // Chỉ insert, không update. Việc xóa các câu trả lời cũ được xử lý riêng.
            if (selectedOptionId != null) {
                UserQuizAttemptAnswers newAnswer = UserQuizAttemptAnswers.builder()
                        .attempt_id(attemptId)
                        .quiz_question_id(questionId)
                        .selected_option_id(selectedOptionId)
                        .correct(isCorrect)
                        .answer_at(new Timestamp(System.currentTimeMillis()))
                        .build();
                answersDAO.insert(newAnswer);
            }
        } catch (Exception e) {
            System.err.println("Error in saveAnswer (insert-only): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Lưu câu trả lời tự luận cho câu hỏi.
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     * @param essayAnswer Nội dung câu trả lời tự luận
     * @return true nếu lưu thành công, false nếu thất bại
     */
    public boolean saveEssayAnswer(Integer attemptId, Integer questionId, String essayAnswer) {
        try {
            // Xóa các câu trả lời cũ
            clearAnswersForQuestion(attemptId, questionId);
            
            // Lưu câu trả lời tự luận mới
            return answersDAO.saveEssayAnswer(attemptId, questionId, essayAnswer);
        } catch (Exception e) {
            System.err.println("Error in saveEssayAnswer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lưu câu trả lời cho một câu hỏi trong attempt
     *
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
        if (questionIdStr == null) {
            Object attr = request.getAttribute("questionId");
            if (attr != null) questionIdStr = attr.toString();
        }
        String selectedOptionIdStr = request.getParameter("selectedOptionId");
        if (selectedOptionIdStr == null) {
            Object attr = request.getAttribute("selectedOptionId");
            if (attr != null) selectedOptionIdStr = attr.toString();
        }
        String isCorrectStr = request.getParameter("isCorrect");
        if (isCorrectStr == null) {
            Object attr = request.getAttribute("isCorrect");
            if (attr != null) isCorrectStr = attr.toString();
        }

        if (questionIdStr == null || isCorrectStr == null) { // selectedOptionIdStr can be null
            System.out.println("DEBUG PARAMS: questionIdStr=" + questionIdStr
                    + ", selectedOptionIdStr=" + selectedOptionIdStr
                    + ", isCorrectStr=" + isCorrectStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing required parameters: "
                    + (questionIdStr == null ? "questionId " : "")
                    + (isCorrectStr == null ? "isCorrect" : "")
            );
            return;
        }

        try {
            Integer questionId = Integer.parseInt(questionIdStr);
            Integer selectedOptionId = (selectedOptionIdStr != null && !selectedOptionIdStr.isEmpty()) 
                                        ? Integer.parseInt(selectedOptionIdStr) : null;
            Boolean isCorrect = Boolean.parseBoolean(isCorrectStr);
            // call the new saveAnswer method.
            // First clear old answers, then save new ones.
            clearAnswersForQuestion(attempt.getId(), questionId);
            saveAnswer(attempt.getId(), questionId, selectedOptionId, isCorrect);
            
            // Send success response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            return;
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
            return;
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
            attempt.setEnd_time(new Timestamp(System.currentTimeMillis()));
            attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
            attempt.setUpdate_at(new Timestamp(System.currentTimeMillis()));

            attemptsDAO.update(attempt);
        }

        // Redirect to the quiz handle page instead of forwarding to a non-existent JSP
        response.sendRedirect(request.getContextPath() + "/quiz-handle?id=" + attempt.getQuiz_id());
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
