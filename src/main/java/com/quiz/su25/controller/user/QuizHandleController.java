/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author quangmingdoc
 */
@WebServlet(name = "QuizHandleController", urlPatterns = {"/quiz-handle"})
public class QuizHandleController extends HttpServlet {

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
            out.println("<title>Servlet QuizHandleController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizHandleController at " + request.getContextPath() + "</h1>");
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
        try {
            // Lấy số thứ tự câu hỏi từ parameter, mặc định là 1
            String questionNumber = request.getParameter("questionNumber");
            int currentNumber = questionNumber != null ? Integer.parseInt(questionNumber) : 1;
            
            // Lấy danh sách câu hỏi từ database
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.findAll();
            
            // Kiểm tra nếu có câu hỏi
            if (!questions.isEmpty() && currentNumber <= questions.size()) {
                // Lấy câu hỏi hiện tại
                Question currentQuestion = questions.get(currentNumber - 1);
                
                // Lấy các options cho câu hỏi hiện tại
                QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                List<QuestionOption> options = optionDAO.findByQuestionId(currentQuestion.getId());
                currentQuestion.setQuestionOptions(options);
                
                // Lấy câu trả lời đã chọn từ session
                HttpSession session = request.getSession();
                Map<Integer, List<Integer>> userAnswers = (Map<Integer, List<Integer>>) session.getAttribute("userAnswers");
                
                if (userAnswers != null && userAnswers.containsKey(currentQuestion.getId())) {
                    List<Integer> selectedAnswers = userAnswers.get(currentQuestion.getId());
                    request.setAttribute("selectedAnswers", selectedAnswers);
                }
                
                // Set attributes cho JSP
                request.setAttribute("question", currentQuestion);
                request.setAttribute("currentNumber", currentNumber);
                request.setAttribute("totalQuestions", questions.size());
                request.setAttribute("questions", questions);
            }
            
            request.getRequestDispatcher("view/user/quizHandle/quiz-handle.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=1");
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
        String action = request.getParameter("action");
        System.out.println("Action received: " + action); // Debug log
        
        if ("saveAnswer".equals(action)) {
            try {
                // Lấy thông tin câu hỏi và câu trả lời
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                String[] selectedAnswerIds = request.getParameterValues("answer");
                String nextAction = request.getParameter("nextAction");
                int currentNumber = Integer.parseInt(request.getParameter("questionNumber"));
                
                System.out.println("Question ID: " + questionId); // Debug log
                System.out.println("Current Number: " + currentNumber); // Debug log
                System.out.println("Next Action: " + nextAction); // Debug log
                
                // Lấy hoặc tạo mới map lưu câu trả lời trong session
                HttpSession session = request.getSession();
                Map<Integer, List<Integer>> userAnswers = (Map<Integer, List<Integer>>) session.getAttribute("userAnswers");
                if (userAnswers == null) {
                    userAnswers = new HashMap<>();
                }
                
                // Lưu câu trả lời vào map
                List<Integer> answers = new ArrayList<>();
                if (selectedAnswerIds != null) {
                    for (String answerId : selectedAnswerIds) {
                        answers.add(Integer.parseInt(answerId));
                    }
                }
                userAnswers.put(questionId, answers);
                
                // Cập nhật session
                session.setAttribute("userAnswers", userAnswers);
                
                // Xác định số câu hỏi tiếp theo
                int nextNumber = currentNumber;
                if ("next".equals(nextAction)) {
                    nextNumber++;
                } else if ("previous".equals(nextAction)) {
                    nextNumber--;
                }
                
                System.out.println("Redirecting to question: " + nextNumber); // Debug log
                
                // Chuyển hướng đến câu hỏi tiếp theo
                response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=" + nextNumber);
            } catch (Exception e) {
                System.out.println("Error in doPost: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=1");
            }
        }
    }

}
