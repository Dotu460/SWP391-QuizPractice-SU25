/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.config.GlobalConfig;
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
            statement.setTimestamp(3, t.getStart_time());
            statement.setTimestamp(4, t.getEnd_time());
            statement.setDouble(5, t.getScore());
            statement.setBoolean(6, t.getPassed());
            statement.setString(7, t.getStatus());
            statement.setTimestamp(8, t.getCreated_at());
            statement.setTimestamp(9, t.getUpdate_at());

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
            statement.setTimestamp(3, t.getStart_time());
            statement.setTimestamp(4, t.getEnd_time());
            statement.setDouble(5, t.getScore());
            statement.setBoolean(6, t.getPassed());
            statement.setString(7, t.getStatus());
            statement.setTimestamp(8, t.getCreated_at());
            statement.setTimestamp(9, t.getUpdate_at());
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
                .start_time(resultSet.getTimestamp("start_time"))
                .end_time(resultSet.getTimestamp("end_time"))
                .score(resultSet.getDouble("score"))
                .passed(resultSet.getBoolean("passed"))
                .status(resultSet.getString("status"))
                .created_at(resultSet.getTimestamp("created_at"))
                .update_at(resultSet.getTimestamp("update_at"))
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
     * Ordered by update_at DESC, end_time DESC, created_at DESC to ensure we get the most recently updated attempt
     */
    public UserQuizAttempts findLatestAttempt(Integer userId, Integer quizId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE user_id = ? AND quiz_id = ? ORDER BY update_at DESC, end_time DESC, created_at DESC LIMIT 1";
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
    public boolean updateScore(Integer attemptId, Double score, Boolean passed) {
        String sql = "UPDATE UserQuizAttempts SET score = ?, passed = ?, update_at = CURRENT_TIMESTAMP WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setDouble(1, score);
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

    /**
     * Check if an attempt exists in the database
     */
    public boolean checkAttemptExists(Integer attemptId) {
        String sql = "SELECT COUNT(*) FROM UserQuizAttempts WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                int count = resultSet.getInt(1);
                System.out.println("Checking if attempt ID " + attemptId + " exists: " + (count > 0));
                return count > 0;
            }
        } catch (Exception e) {
            System.out.println("Error checkAttemptExists at class UserQuizAttemptsDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Update only status of an attempt
     */
    public boolean updateStatus(Integer attemptId, String status) {
        String sql = "UPDATE UserQuizAttempts SET status = ?, update_at = CURRENT_TIMESTAMP WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, attemptId);

            int result = statement.executeUpdate();
            System.out.println("Updating status of attempt ID " + attemptId + " to " + status + ": " + (result > 0 ? "SUCCESS" : "FAILED"));
            return result > 0;
        } catch (Exception e) {
            System.out.println("Error updateStatus at class UserQuizAttemptsDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Mark all in-progress attempts for a user and quiz as abandoned
     * This is useful when starting a new attempt to ensure only one is in-progress
     */
    public int markAllInProgressAsAbandoned(Integer userId, Integer quizId) {
        String sql = "UPDATE UserQuizAttempts SET status = ?, update_at = CURRENT_TIMESTAMP " +
                     "WHERE user_id = ? AND quiz_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "abandoned");
            statement.setInt(2, userId);
            statement.setInt(3, quizId);
            statement.setString(4, "in_progress");

            int updatedCount = statement.executeUpdate();
            System.out.println("Marked " + updatedCount + " in-progress attempts as abandoned for user " + 
                              userId + " and quiz " + quizId);
            return updatedCount;
        } catch (Exception e) {
            System.out.println("Error markAllInProgressAsAbandoned at class UserQuizAttemptsDAO: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources();
        }
    }

    /**
     * Find the latest in-progress attempt by a user for a specific quiz
     */
    public UserQuizAttempts findLatestInProgressAttempt(Integer userId, Integer quizId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE user_id = ? AND quiz_id = ? AND status = ? ORDER BY created_at DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, quizId);
            statement.setString(3, "in_progress");
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                System.out.println("Found latest in-progress attempt: ID=" + attempt.getId());
                return attempt;
            }
            System.out.println("No in-progress attempt found for user " + userId + " and quiz " + quizId);
        } catch (Exception e) {
            System.out.println("Error findLatestInProgressAttempt at class UserQuizAttemptsDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Find all completed or partially graded attempts for a specific user and quiz, ordered by newest first
     */
    public List<UserQuizAttempts> findCompletedAttemptsByQuizId(Integer userId, Integer quizId) {
        String sql = "SELECT * FROM UserQuizAttempts WHERE user_id = ? AND quiz_id = ? AND (status = 'completed' OR status = 'partially_graded') ORDER BY end_time DESC, created_at DESC";
        List<UserQuizAttempts> completedAttempts = new ArrayList<>();
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, quizId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                completedAttempts.add(attempt);
            }
            
            System.out.println("Found " + completedAttempts.size() + " completed/partially graded attempts for user " + userId + " and quiz " + quizId);
            
        } catch (Exception e) {
            System.out.println("Error findCompletedAttemptsByQuizId at class UserQuizAttemptsDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return completedAttempts;
    }

    /**
     * Tìm kiếm attempts theo các điều kiện lọc và phân trang
     */
    public List<UserQuizAttempts> findAttemptsByFilters(Integer quizId, Integer userId, String status, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM UserQuizAttempts WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc
        if (quizId != null) {
            sql.append(" AND quiz_id = ?");
            params.add(quizId);
        }
        
        if (userId != null) {
            sql.append(" AND user_id = ?");
            params.add(userId);
        }
        
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        } else {
            // Mặc định chỉ lấy các attempts có câu hỏi tự luận cần chấm điểm
            sql.append(" AND (status = ? OR status = ?)");
            params.add(GlobalConfig.QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED);
            params.add(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
        }
        
        // Thêm sắp xếp và phân trang
        sql.append(" ORDER BY update_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        List<UserQuizAttempts> listAttempts = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Đặt các tham số
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                UserQuizAttempts attempt = getFromResultSet(resultSet);
                listAttempts.add(attempt);
            }
        } catch (Exception e) {
            System.out.println("Error findAttemptsByFilters at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listAttempts;
    }

    /**
     * Đếm tổng số attempts theo các điều kiện lọc
     */
    public int countAttemptsByFilters(Integer quizId, Integer userId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM UserQuizAttempts WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc
        if (quizId != null) {
            sql.append(" AND quiz_id = ?");
            params.add(quizId);
        }
        
        if (userId != null) {
            sql.append(" AND user_id = ?");
            params.add(userId);
        }
        
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        } else {
            // Mặc định chỉ đếm các attempts có câu hỏi tự luận cần chấm điểm
            sql.append(" AND (status = ? OR status = ?)");
            params.add(GlobalConfig.QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED);
            params.add(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Đặt các tham số
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error countAttemptsByFilters at class UserQuizAttemptsDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        UserQuizAttemptsDAO userQuizAttemptsDAO = new UserQuizAttemptsDAO();
        userQuizAttemptsDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
