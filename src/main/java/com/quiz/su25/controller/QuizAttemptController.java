package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.UserQuizAttemptAnswersDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
import com.quiz.su25.entity.UserQuizAttempts;
import java.sql.Date;
import java.util.List;

public class QuizAttemptController {
    private final UserQuizAttemptsDAO attemptsDAO;
    private final UserQuizAttemptAnswersDAO answersDAO;

    public QuizAttemptController() {
        this.attemptsDAO = new UserQuizAttemptsDAO();
        this.answersDAO = new UserQuizAttemptAnswersDAO();
    }

    /**
     * Start a new quiz attempt
     */
    public UserQuizAttempts startQuizAttempt(Integer userId, Integer quizId) {
        UserQuizAttempts attempt = UserQuizAttempts.builder()
                .user_id(userId)
                .quiz_id(quizId)
                .start_time(new Date(System.currentTimeMillis())) // Current time as SQL Date
                .status("in_progress")
                .created_at(new Date(System.currentTimeMillis()))
                .build();
        
        attemptsDAO.insert(attempt);
        return attempt;
    }

    /**
     * Save an answer during the quiz
     */
    public boolean saveAnswer(Integer attemptId, Integer questionId, Integer selectedOptionId, boolean isCorrect) {
        UserQuizAttemptAnswers answer = UserQuizAttemptAnswers.builder()
                .attempt_id(attemptId)
                .quiz_question_id(questionId)
                .selected_option_id(selectedOptionId)
                .correct(isCorrect)
                .answer_at(new Date(System.currentTimeMillis()))
                .build();
        
        return answersDAO.insert(answer) > 0;
    }

    /**
     * Complete a quiz attempt and calculate score
     */
    public double completeQuizAttempt(Integer attemptId) {
        try {
            // Get the attempt
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            if (attempt == null) return 0.0;

            // Count correct answers
            int correctAnswers = answersDAO.countCorrectAnswers(attemptId);
            
            // Get total questions answered
            List<UserQuizAttemptAnswers> answers = answersDAO.findByAttemptId(attemptId);
            int totalQuestions = answers.size();
            
            // Calculate score (as a number between 0 and 10)
            double score = totalQuestions > 0 ? (correctAnswers * 10.0) / totalQuestions : 0.0;
            
            // Update attempt with score
            attempt.setEnd_time(new Date(System.currentTimeMillis()));
            attempt.setScore(score);
            attempt.setPassed(score >= 5.0); // Passing score is 5.0
            attempt.setStatus("completed");
            attempt.setUpdate_at(new Date(System.currentTimeMillis()));
            
            if (attemptsDAO.update(attempt)) {
                return score;
            }
            
            return 0.0;
            
        } catch (Exception e) {
            System.out.println("Error completing quiz attempt: " + e.getMessage());
            e.printStackTrace();
            return 0.0;
        }
    }

    /**
     * Get quiz attempt history for a user
     */
    public List<UserQuizAttempts> getUserAttemptHistory(Integer userId) {
        return attemptsDAO.findByUserId(userId);
    }

    /**
     * Get answers for a specific attempt
     */
    public List<UserQuizAttemptAnswers> getAttemptAnswers(Integer attemptId) {
        return answersDAO.findByAttemptId(attemptId);
    }

    /**
     * Get the latest attempt for a quiz by a user
     */
    public UserQuizAttempts getLatestAttempt(Integer userId, Integer quizId) {
        return attemptsDAO.findLatestAttempt(userId, quizId);
    }

    /**
     * Save multiple answers at once (batch save)
     */
    public boolean saveAnswersBatch(List<UserQuizAttemptAnswers> answers) {
        return answersDAO.batchInsertAnswers(answers);
    }

    /**
     * Check if a user has any incomplete attempts for a quiz
     */
    public boolean hasIncompleteAttempt(Integer userId, Integer quizId) {
        UserQuizAttempts latestAttempt = attemptsDAO.findLatestAttempt(userId, quizId);
        return latestAttempt != null && "in_progress".equals(latestAttempt.getStatus());
    }

    /**
     * Delete an attempt and all its answers
     */
    public boolean deleteAttempt(Integer attemptId) {
        // First delete all answers
        answersDAO.deleteByAttemptId(attemptId);
        
        // Then delete the attempt
        UserQuizAttempts attempt = new UserQuizAttempts();
        attempt.setId(attemptId);
        return attemptsDAO.delete(attempt);
    }
} 