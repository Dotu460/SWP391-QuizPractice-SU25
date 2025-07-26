package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.UserQuizAttempts;
import com.quiz.su25.entity.Lesson;
import com.quiz.su25.entity.PricePackage;
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
import java.util.LinkedHashMap;

@WebServlet(name = "QuizHandleMenuController", urlPatterns = {"/quiz-handle-menu"})
public class QuizHandleMenuController extends HttpServlet {
    
    private final QuizzesDAO quizzesDAO = new QuizzesDAO();
    private final UserQuizAttemptsDAO userQuizAttemptsDAO = new UserQuizAttemptsDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO(); // Thêm SubjectDAO
    private final LessonDAO lessonDAO = new LessonDAO();
    private final PricePackageDAO pricePackageDAO = new PricePackageDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== Starting QuizHandleMenuController ===");
            HttpSession session = request.getSession(false);
            com.quiz.su25.entity.User user = (session != null) ? (com.quiz.su25.entity.User) session.getAttribute(com.quiz.su25.config.GlobalConfig.SESSION_ACCOUNT) : null;
            if (user == null || user.getRole_id() != com.quiz.su25.config.GlobalConfig.ROLE_STUDENT) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            int userId = user.getId();
            // Check package access if packageId is present
            String packageIdParam = request.getParameter("packageId");
            if (packageIdParam != null && !packageIdParam.isEmpty()) {
                try {
                    int packageId = Integer.parseInt(packageIdParam);
                    // Check registration for this user and package
                    com.quiz.su25.dal.impl.RegistrationDAO registrationDAO = new com.quiz.su25.dal.impl.RegistrationDAO();
                    java.util.List<com.quiz.su25.entity.Registration> regs = registrationDAO.findByUserId(userId);
                    java.sql.Date now = new java.sql.Date(System.currentTimeMillis());
                    boolean hasValid = false;
                    for (com.quiz.su25.entity.Registration reg : regs) {
                        System.out.println("Check reg: user=" + reg.getUser_id() + ", package=" + reg.getPackage_id() + ", status=" + reg.getStatus() + ", valid_to=" + reg.getValid_to());
                        if (reg.getPackage_id() != null && reg.getPackage_id().equals(packageId) &&
                            ("paid".equalsIgnoreCase(reg.getStatus()) || "active".equalsIgnoreCase(reg.getStatus()) || "approved".equalsIgnoreCase(reg.getStatus())) &&
                            reg.getValid_to() != null && reg.getValid_to().after(now)) {
                            hasValid = true;
                            break;
                        }
                    }
                    if (!hasValid) {
                        // No valid registration, redirect to price-package-menu with error
                        request.getSession().setAttribute("toastMessage", "You do not have access to this package. Please purchase it first.");
                        request.getSession().setAttribute("toastType", "error");
                        response.sendRedirect(request.getContextPath() + "/price-package-menu");
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Invalid packageId, fallback to normal flow
                }
            }
            session.setAttribute("user", userId);
            System.out.println("Set session with user id = " + userId);

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
            
            // Sau khi có quizzesList, tạo map lessonId -> lessonTitle
            Map<Integer, String> lessonTitles = new HashMap<>();
            Map<Integer, Integer> lessonToSubject = new HashMap<>();
            for (Quizzes quiz : quizzesList) {
                Integer lessonId = quiz.getLesson_id();
                if (lessonId != null && !lessonTitles.containsKey(lessonId)) {
                    Lesson lesson = lessonDAO.findById(lessonId);
                    if (lesson != null) {
                        lessonTitles.put(lessonId, lesson.getTitle());
                        lessonToSubject.put(lessonId, lesson.getSubject_id());
                    }
                }
            }
            request.setAttribute("lessonTitles", lessonTitles);
            request.setAttribute("lessonToSubject", lessonToSubject);

            // Tạo map subjectId -> subjectTitle
            Map<Integer, String> subjectTitles = new HashMap<>();
            for (Integer subjectId : lessonToSubject.values()) {
                if (subjectId != null && !subjectTitles.containsKey(subjectId)) {
                    Subject subject = subjectDAO.findById(subjectId);
                    if (subject != null) {
                        subjectTitles.put(subjectId, subject.getTitle());
                    }
                }
            }
            request.setAttribute("subjectTitles", subjectTitles);

            // Tạo map quizId -> số lượng câu hỏi thực tế
            QuestionDAO questionDAO = new QuestionDAO();
            Map<Integer, Integer> questionCounts = new HashMap<>();
            for (Quizzes quiz : quizzesList) {
                int count = questionDAO.countQuestionsByQuizId(quiz.getId());
                questionCounts.put(quiz.getId(), count);
            }
            request.setAttribute("questionCounts", questionCounts);

            String packageName = null;
            if (packageIdParam != null && !packageIdParam.isEmpty()) {
                try {
                    int packageId = Integer.parseInt(packageIdParam);
                    PricePackage pkg = pricePackageDAO.findById(packageId);
                    if (pkg != null) {
                        packageName = pkg.getName();
                    }
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
            request.setAttribute("packageName", packageName);

            // Group quizzes by subjectId
            Map<Integer, List<Quizzes>> quizzesBySubject = new LinkedHashMap<>();
            for (Quizzes quiz : quizzesList) {
                Integer lessonId = quiz.getLesson_id();
                Integer subjectId = lessonToSubject.get(lessonId);
                if (subjectId != null) {
                    quizzesBySubject.computeIfAbsent(subjectId, k -> new java.util.ArrayList<>()).add(quiz);
                }
            }
            request.setAttribute("quizzesBySubject", quizzesBySubject);

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