package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;

@WebServlet(name = "QuizHandleMenuController", urlPatterns = {"/quiz-handle-menu"})
public class QuizHandleMenuController extends HttpServlet {
    
    private final QuizzesDAO quizzesDAO = new QuizzesDAO();
    private final UserQuizAttemptsDAO userQuizAttemptsDAO = new UserQuizAttemptsDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO(); // Thêm SubjectDAO
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== Starting QuizHandleMenuController ===");
            
            HttpSession session = request.getSession(true);
            int userId = 10; // Hardcoded user id for testing
            session.setAttribute("user", userId);
            System.out.println("Set session with user id = " + userId);

            String packageIdParam = request.getParameter("packageId");
            List<Quizzes> quizzesList;

            if (packageIdParam != null && !packageIdParam.isEmpty()) {
                try {
                    int packageId = Integer.parseInt(packageIdParam);
                    System.out.println("Fetching quizzes for packageId: " + packageId);
                    quizzesList = quizzesDAO.findByPricePackageId(packageId);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid packageId: " + packageIdParam);
                    quizzesList = quizzesDAO.findAll(); // Lấy tất cả nếu ID không hợp lệ
                }
            } else {
                // Nếu không có packageId, lấy tất cả quiz
                System.out.println("Fetching all quizzes from database...");
                quizzesList = quizzesDAO.findAll();
            }
            
            System.out.println("Found " + (quizzesList != null ? quizzesList.size() : "null") + " quizzes");
            
            if (quizzesList == null) {
                throw new Exception("quizzesList is null");
            }
            
            // Get user's quiz attempts
            List<UserQuizAttempts> userAttempts = userQuizAttemptsDAO.findByUserId(userId);
            
            // Create a map of quiz_id to score
            Map<Integer, Double> quizScores = new HashMap<>();
            for (Quizzes quiz : quizzesList) {
                UserQuizAttempts latestAttempt = userQuizAttemptsDAO.findLatestAttempt(userId, quiz.getId());
                if (latestAttempt != null && 
                    (GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED.equals(latestAttempt.getStatus()) || 
                     GlobalConfig.QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED.equals(latestAttempt.getStatus()))) {
                    quizScores.put(quiz.getId(), latestAttempt.getScore());
                } else {
                    quizScores.put(quiz.getId(), null);
                }
            }
            
            Map<Integer, Boolean> quizHasEssay = new HashMap<>();
            Map<Integer, Boolean> quizEssayGraded = new HashMap<>();
            Map<Integer, String> quizAttemptStatus = new HashMap<>();
            
            for (Quizzes quiz : quizzesList) {
                boolean hasEssay = quizzesDAO.hasEssayQuestions(quiz.getId());
                quizHasEssay.put(quiz.getId(), hasEssay);
                
                UserQuizAttempts latestAttempt = userQuizAttemptsDAO.findLatestAttempt(userId, quiz.getId());
                
                if (latestAttempt != null) {
                    quizAttemptStatus.put(quiz.getId(), latestAttempt.getStatus());
                    boolean isEssayGraded = hasEssay && GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED.equals(latestAttempt.getStatus());
                    quizEssayGraded.put(quiz.getId(), isEssayGraded);
                } else {
                    quizEssayGraded.put(quiz.getId(), false);
                    quizAttemptStatus.put(quiz.getId(), null);
                }
            }
            
            request.setAttribute("quizzesList", quizzesList);
            request.setAttribute("quizScores", quizScores);
            request.setAttribute("quizHasEssay", quizHasEssay);
            request.setAttribute("quizEssayGraded", quizEssayGraded);
            request.setAttribute("quizAttemptStatus", quizAttemptStatus);
            System.out.println("Set quiz attributes for JSP");
            
            String forwardPath = "view/user/quiz_handle/quiz-handle-menu.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            
        } catch (Exception e) {
            System.out.println("=== Error in QuizHandleMenuController ===");
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body><h1>Error occurred:</h1><p>" + e.getMessage() + "</p></body></html>");
        }
    }
} 