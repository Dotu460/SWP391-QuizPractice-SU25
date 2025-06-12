/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserQuizAttemptAnswersDAO extends DBContext implements I_DAO<UserQuizAttemptAnswers> {

    @Override
    public List<UserQuizAttemptAnswers> findAll() {
        String sql = "SELECT * FROM UserQuizAttemptAnswers";
        List<UserQuizAttemptAnswers> listAnswers = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                UserQuizAttemptAnswers answer = getFromResultSet(resultSet);
                listAnswers.add(answer);
            }
        } catch (Exception e) {
            System.out.println("Error findAll at class UserQuizAttemptAnswersDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAnswers;
    }

    @Override
    public UserQuizAttemptAnswers findById(Integer id) {
        String sql = "SELECT * FROM UserQuizAttemptAnswers WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class UserQuizAttemptAnswersDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    @Override
    public int insert(UserQuizAttemptAnswers t) {
        String sql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, selected_option_id, correct, answer_at) VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getAttempt_id());
            statement.setInt(2, t.getQuiz_question_id());
            statement.setInt(3, t.getSelected_option_id());
            statement.setBoolean(4, t.getCorrect());
            statement.setDate(5, t.getAnswer_at());
            
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(UserQuizAttemptAnswers t) {
        String sql = "UPDATE UserQuizAttemptAnswers SET attempt_id=?, quiz_question_id=?, selected_option_id=?, correct=?, answer_at=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getAttempt_id());
            statement.setInt(2, t.getQuiz_question_id());
            statement.setInt(3, t.getSelected_option_id());
            statement.setBoolean(4, t.getCorrect());
            statement.setDate(5, t.getAnswer_at());
            statement.setInt(6, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(UserQuizAttemptAnswers t) {
        String sql = "DELETE FROM UserQuizAttemptAnswers WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public UserQuizAttemptAnswers getFromResultSet(ResultSet resultSet) throws SQLException {
        return UserQuizAttemptAnswers.builder()
                .id(resultSet.getInt("id"))
                .attempt_id(resultSet.getInt("attempt_id"))
                .quiz_question_id(resultSet.getInt("quiz_question_id"))
                .selected_option_id(resultSet.getInt("selected_option_id"))
                .correct(resultSet.getBoolean("correct"))
                .answer_at(resultSet.getDate("answer_at"))
                .build();
    }

    // Additional methods for quiz answers

    /**
     * Find all answers for a specific attempt
     */
    public List<UserQuizAttemptAnswers> findByAttemptId(Integer attemptId) {
        String sql = "SELECT * FROM UserQuizAttemptAnswers WHERE attempt_id = ? ORDER BY quiz_question_id";
        List<UserQuizAttemptAnswers> listAnswers = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                UserQuizAttemptAnswers answer = getFromResultSet(resultSet);
                listAnswers.add(answer);
            }
        } catch (Exception e) {
            System.out.println("Error findByAttemptId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAnswers;
    }

    /**
     * Find answer for a specific question in an attempt
     */
    public UserQuizAttemptAnswers findByAttemptAndQuestionId(Integer attemptId, Integer questionId) {
        String sql = "SELECT * FROM UserQuizAttemptAnswers WHERE attempt_id = ? AND quiz_question_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            statement.setInt(2, questionId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findByAttemptAndQuestionId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Count correct answers for an attempt
     */
    public int countCorrectAnswers(Integer attemptId) {
        String sql = "SELECT COUNT(*) FROM UserQuizAttemptAnswers WHERE attempt_id = ? AND correct = true";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error countCorrectAnswers at class UserQuizAttemptAnswersDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Delete all answers for an attempt
     */
    public boolean deleteByAttemptId(Integer attemptId) {
        String sql = "DELETE FROM UserQuizAttemptAnswers WHERE attempt_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByAttemptId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Batch insert multiple answers
     */
    public boolean batchInsertAnswers(List<UserQuizAttemptAnswers> answers) {
        String sql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, selected_option_id, correct, answer_at) VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            statement = connection.prepareStatement(sql);
            
            for (UserQuizAttemptAnswers answer : answers) {
                statement.setInt(1, answer.getAttempt_id());
                statement.setInt(2, answer.getQuiz_question_id());
                statement.setInt(3, answer.getSelected_option_id());
                statement.setBoolean(4, answer.getCorrect());
                statement.setDate(5, answer.getAnswer_at());
                statement.addBatch();
            }
            
            statement.executeBatch();
            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                System.out.println("Error rolling back at class UserQuizAttemptAnswersDAO: " + ex.getMessage());
            }
            System.out.println("Error batchInsertAnswers at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException e) {
                System.out.println("Error resetting auto-commit at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            }
            closeResources();
        }
    }
    
    public static void main(String[] args) {
        UserQuizAttemptAnswersDAO userQuizAttemptAnswersDAO = new UserQuizAttemptAnswersDAO();
        userQuizAttemptAnswersDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
