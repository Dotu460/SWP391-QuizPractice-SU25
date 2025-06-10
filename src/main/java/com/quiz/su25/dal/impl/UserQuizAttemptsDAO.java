/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.UserQuizAttempts;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserQuizAttemptsDAO extends DBContext implements I_DAO<UserQuizAttempts> {

    @Override
    public List<UserQuizAttempts> findAll() {
        String sql = "SELECT * FROM UserQuizAttempts";
        List<UserQuizAttempts> listAttempts = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                listAttempts.add(attempt);
            }
        } catch (Exception e) {
            System.out.println("Error findAll at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAttempts;
    }

    @Override
    public UserQuizAttempts findById(Integer id) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    @Override
    public int insert(UserQuizAttempts t) {
        String sql = "INSERT INTO UserQuizAttempts (user_id, quiz_id, start_time, end_time, score, passed, status, created_at, update_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getUser_id());
            statement.setInt(2, t.getQuiz_id());
            statement.setInt(3, t.getStart_time());
            statement.setInt(4, t.getEnd_time());
            statement.setInt(5, t.getScore());
            statement.setBoolean(6, t.getPassed());
            statement.setString(7, t.getStatus());
            statement.setDate(8, t.getCreated_at());
            statement.setDate(9, t.getUpdate_at());
            
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class UserQuizAttemptsDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(UserQuizAttempts t) {
        String sql = "UPDATE UserQuizAttempts SET user_id=?, quiz_id=?, start_time=?, end_time=?, score=?, passed=?, status=?, created_at=?, update_at=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getUser_id());
            statement.setInt(2, t.getQuiz_id());
            statement.setInt(3, t.getStart_time());
            statement.setInt(4, t.getEnd_time());
            statement.setInt(5, t.getScore());
            statement.setBoolean(6, t.getPassed());
            statement.setString(7, t.getStatus());
            statement.setDate(8, t.getCreated_at());
            statement.setDate(9, t.getUpdate_at());
            statement.setInt(10, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class UserQuizAttemptsDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(UserQuizAttempts t) {
        String sql = "DELETE FROM UserQuizAttempts WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class UserQuizAttemptsDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public UserQuizAttempts getFromResultSet(ResultSet resultSet) throws SQLException {
        return UserQuizAttempts.builder()
                .id(resultSet.getInt("id"))
                .user_id(resultSet.getInt("user_id"))
                .quiz_id(resultSet.getInt("quiz_id"))
                .start_time(resultSet.getInt("start_time"))
                .end_time(resultSet.getInt("end_time"))
                .score(resultSet.getInt("score"))
                .passed(resultSet.getBoolean("passed"))
                .status(resultSet.getString("status"))
                .created_at(resultSet.getDate("created_at"))
                .update_at(resultSet.getDate("update_at"))
                .build();
    }

    // Additional methods for quiz attempts

    /**
     * Find all attempts by a specific user
     */
    public List<UserQuizAttempts> findByUserId(Integer userId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE user_id = ? ORDER BY created_at DESC";
        List<UserQuizAttempts> listAttempts = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                listAttempts.add(attempt);
            }
        } catch (Exception e) {
            System.out.println("Error findByUserId at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAttempts;
    }

    /**
     * Find all attempts for a specific quiz
     */
    public List<UserQuizAttempts> findByQuizId(Integer quizId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE quiz_id = ? ORDER BY created_at DESC";
        List<UserQuizAttempts> listAttempts = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                listAttempts.add(attempt);
            }
        } catch (Exception e) {
            System.out.println("Error findByQuizId at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAttempts;
    }

    /**
     * Find the latest attempt by a user for a specific quiz
     */
    public UserQuizAttempts findLatestAttempt(Integer userId, Integer quizId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE user_id = ? AND quiz_id = ? ORDER BY created_at DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, quizId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findLatestAttempt at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Update the score and status of an attempt
     */
    public boolean updateScore(Integer attemptId, Integer score, Boolean passed) {
        String sql = "UPDATE UserQuizAttempts SET score = ?, passed = ?, status = 'completed', update_at = CURRENT_TIMESTAMP WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, score);
            statement.setBoolean(2, passed);
            statement.setInt(3, attemptId);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateScore at class UserQuizAttemptsDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
}
