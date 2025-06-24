/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller;

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
            int userId = 10; // Hardcoded user ID as requested

            UserQuizAttempts latestAttempt = attemptsDAO.findLatestAttempt(userId, quizId);

            if (latestAttempt == null || !GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED.equals(latestAttempt.getStatus())) {
                session.setAttribute("toastMessage", "No completed quiz attempt found to review.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/quiz-handle-menu");
                return;
            }

            Quizzes quiz = quizDAO.findById(quizId);
            List<Question> questions = questionDAO.findByQuizId(quizId);
            List<UserQuizAttemptAnswers> userAnswers = userAnswersDAO.findByAttemptId(latestAttempt.getId());

            Map<Integer, List<Integer>> userAnswerMap = userAnswers.stream()
                    .collect(Collectors.groupingBy(UserQuizAttemptAnswers::getQuiz_question_id,
                            Collectors.mapping(UserQuizAttemptAnswers::getSelected_option_id, Collectors.toList())));

            for (Question q : questions) {
                List<QuestionOption> options = optionDAO.findByQuestionId(q.getId());
                q.setQuestionOptions(options);
            }

            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("userAnswerMap", userAnswerMap);
            request.setAttribute("attempt", latestAttempt);

            request.getRequestDispatcher("view/user/quizHandle/quiz-handle-review.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 