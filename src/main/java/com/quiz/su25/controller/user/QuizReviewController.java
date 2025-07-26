/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptAnswersDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.ArrayList;

/**
 *
 * @author kenngoc
 */
@WebServlet(name = "QuizReviewController", urlPatterns = {"/quiz-review"})
public class QuizReviewController extends HttpServlet {

    private final UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
    private final QuizzesDAO quizDAO = new QuizzesDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final UserQuizAttemptAnswersDAO userAnswersDAO = new UserQuizAttemptAnswersDAO();
    private final QuestionOptionDAO optionDAO = new QuestionOptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String quizIdStr = request.getParameter("quizId");

        if (quizIdStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int quizId = Integer.parseInt(quizIdStr);
            
            // Lấy user từ session thay vì hardcode
            com.quiz.su25.entity.User user = (com.quiz.su25.entity.User) session.getAttribute(com.quiz.su25.config.GlobalConfig.SESSION_ACCOUNT);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            int userId = user.getId();

            System.out.println("\n===== QUIZ REVIEW =====");
            System.out.println("Reviewing quiz ID: " + quizId + " for user ID: " + userId);

            // Debug: Kiểm tra tất cả attempts của user cho quiz này
            List<UserQuizAttempts> allAttempts = attemptsDAO.findByUserId(userId);
            System.out.println("Total attempts for user " + userId + ": " + allAttempts.size());
            for (UserQuizAttempts attempt : allAttempts) {
                if (attempt.getQuiz_id().equals(quizId)) {
                    System.out.println("Found attempt for quiz " + quizId + ": ID=" + attempt.getId() + 
                                      ", Status=" + attempt.getStatus() + 
                                      ", Score=" + attempt.getScore() +
                                      ", End_time=" + attempt.getEnd_time());
                }
            }

            // Tìm attempt mới nhất đã hoàn thành (status=completed)
            List<UserQuizAttempts> completedAttempts = attemptsDAO.findCompletedAttemptsByQuizId(userId, quizId);
            
            System.out.println("Found " + (completedAttempts != null ? completedAttempts.size() : 0) + " completed attempts");
            
            if (completedAttempts == null || completedAttempts.isEmpty()) {
                System.out.println("No completed attempts found");
                session.setAttribute("toastMessage", "No completed quiz attempt found to review.");
                session.setAttribute("toastType", "error");
                
                // Lấy packageId từ request để giữ context khi redirect
                String packageId = request.getParameter("packageId");
                String redirectUrl = request.getContextPath() + "/quiz-handle-menu";
                if (packageId != null && !packageId.isEmpty()) {
                    redirectUrl += "?packageId=" + packageId;
                }
                System.out.println("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            }

            // Lấy attempt đã hoàn thành mới nhất (đầu tiên trong danh sách đã sắp xếp)
            UserQuizAttempts latestAttempt = completedAttempts.get(0);
            System.out.println("Found latest completed attempt: ID=" + latestAttempt.getId() + 
                              ", Score=" + latestAttempt.getScore() +
                              ", Date=" + latestAttempt.getEnd_time());

            Quizzes quiz = quizDAO.findById(quizId);
            List<Question> questions = questionDAO.findByQuizId(quizId);
            List<UserQuizAttemptAnswers> userAnswers = userAnswersDAO.findByAttemptId(latestAttempt.getId());

            System.out.println("Found " + userAnswers.size() + " answer records for this attempt");

            // Tạo map cho câu trả lời trắc nghiệm
            Map<Integer, List<Integer>> userAnswerMap = new HashMap<>();
            
            // Tạo map cho câu trả lời tự luận
            Map<Integer, String> essayAnswerMap = new HashMap<>();
            
            // Phân loại câu trả lời
            for (UserQuizAttemptAnswers answer : userAnswers) {
                int questionId = answer.getQuiz_question_id();
                
                // Nếu có câu trả lời tự luận
                if (answer.getEssay_answer() != null && !answer.getEssay_answer().isEmpty()) {
                    essayAnswerMap.put(questionId, answer.getEssay_answer());
                } 
                // Nếu là câu trả lời trắc nghiệm
                else {
                    if (!userAnswerMap.containsKey(questionId)) {
                        userAnswerMap.put(questionId, new ArrayList<>());
                    }
                    userAnswerMap.get(questionId).add(answer.getSelected_option_id());
                }
            }

            System.out.println("User answer map: " + userAnswerMap);
            System.out.println("Essay answer map: " + essayAnswerMap);

            for (Question q : questions) {
                List<QuestionOption> options = optionDAO.findByQuestionId(q.getId());
                q.setQuestionOptions(options);
            }

            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("userAnswerMap", userAnswerMap);
            request.setAttribute("essayAnswerMap", essayAnswerMap);
            request.setAttribute("attempt", latestAttempt);
            
            // Pass all userAnswers for complete data access in JSP
            request.setAttribute("allUserAnswers", userAnswers);

            request.getRequestDispatcher("view/user/quiz_handle/quiz-handle-review.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("Error parsing quiz ID: " + e.getMessage());
            // Lấy packageId từ request để giữ context khi redirect
            String packageId = request.getParameter("packageId");
            String redirectUrl = request.getContextPath() + "/quiz-handle-menu";
            if (packageId != null && !packageId.isEmpty()) {
                redirectUrl += "?packageId=" + packageId;
            }
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            System.out.println("Error in QuizReviewController: " + e.getMessage());
            e.printStackTrace();
            // Lấy packageId từ request để giữ context khi redirect
            String packageId = request.getParameter("packageId");
            String redirectUrl = request.getContextPath() + "/quiz-handle-menu";
            if (packageId != null && !packageId.isEmpty()) {
                redirectUrl += "?packageId=" + packageId;
            }
            response.sendRedirect(redirectUrl);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Utility method to convert YouTube URLs to their embed format
     * For use in JSP pages via EL function or in controller logic
     * @param url YouTube URL (either youtube.com/watch?v= or youtu.be/ format)
     * @return Properly formatted YouTube embed URL
     */
    private String getYoutubeEmbedUrl(String url) {
        if (url == null || url.isEmpty()) {
            return "";
        }
        
        // Handle youtu.be short links
        if (url.contains("youtu.be/")) {
            String videoId = url.substring(url.lastIndexOf("/") + 1);
            return "https://www.youtube.com/embed/" + videoId;
        }
        
        // Handle standard youtube.com watch links
        if (url.contains("youtube.com/watch")) {
            // Extract the v parameter
            int vIndex = url.indexOf("v=");
            if (vIndex != -1) {
                String videoId = url.substring(vIndex + 2);
                // Remove any additional parameters
                int ampIndex = videoId.indexOf("&");
                if (ampIndex != -1) {
                    videoId = videoId.substring(0, ampIndex);
                }
                return "https://www.youtube.com/embed/" + videoId;
            }
        }
        
        // Return original URL if it doesn't match expected patterns
        return url;
    }
} 