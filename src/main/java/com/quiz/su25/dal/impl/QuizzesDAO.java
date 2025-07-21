/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Quizzes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPT
 */
public class QuizzesDAO extends DBContext implements I_DAO<Quizzes>{

    @Override
    public List<Quizzes> findAll() {
        List<Quizzes> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM Quizzes";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                quizzes.add(getFromResultSet(resultSet));
            }
            return quizzes;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return quizzes;
    }

    @Override
    public boolean update(Quizzes t) {
        String sql = "UPDATE Quizzes SET name = ?, lesson_id = ?, level = ?,"
                + " number_of_questions_target = ?, duration_minutes = ?,  "
                + "quiz_type = ?, status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getLesson_id());
            statement.setString(3, t.getLevel());
            statement.setInt(4, t.getNumber_of_questions_target());
            statement.setInt(5, t.getDuration_minutes());
            statement.setString(6, t.getQuiz_type());
            statement.setString(7, t.getStatus());
            statement.setInt(8, t.getId());
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Quizzes t) {
        String sql = "DELETE FROM Quizzes WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(Quizzes t) {
        String sql = "INSERT INTO Quizzes (name, lesson_id, level, number_of_questions_target,"
                + " duration_minutes, quiz_type, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getLesson_id());
            statement.setString(3, t.getLevel());
            statement.setInt(4, t.getNumber_of_questions_target());
            statement.setInt(5, t.getDuration_minutes());
            statement.setDouble(6, t.getPass_rate());
            statement.setString(7, t.getQuiz_type());
            statement.setString(8, t.getStatus());
            statement.executeUpdate();
            return 1;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int insertNewQuiz(Quizzes t) {
        String sql = "INSERT INTO Quizzes (name, lesson_id, level, number_of_questions_target,"
                + " duration_minutes, quiz_type, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getLesson_id());
            statement.setString(3, t.getLevel());
            statement.setInt(4, t.getNumber_of_questions_target());
            statement.setInt(5, t.getDuration_minutes());
            statement.setString(6, t.getQuiz_type());
            statement.setString(7, t.getStatus());
            statement.executeUpdate();
            return 1;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    

    @Override
    public Quizzes getFromResultSet(ResultSet resultSet) throws SQLException {
        return Quizzes.builder()
                .id(resultSet.getInt("id"))
                .name(resultSet.getString("name"))
                .lesson_id(resultSet.getInt("lesson_id"))
                .level(resultSet.getString("level"))
                .number_of_questions_target(resultSet.getInt("number_of_questions_target"))
                .duration_minutes(resultSet.getInt("duration_minutes"))
                .pass_rate(resultSet.getDouble("pass_rate"))
                .quiz_type(resultSet.getString("quiz_type"))
                .status(resultSet.getString("status"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_by(resultSet.getInt("created_by"))
                .build();
    }

    @Override
    public Quizzes findById(Integer id) {
        String sql = "SELECT * FROM Quizzes WHERE id = ?";
         try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Quizzes> findQuizzesWithFilters(String quizName, Integer subjectId, 
            Integer lessonId, String quizType, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
            "SELECT q.* FROM Quizzes q "
            + "INNER JOIN Lessons l ON q.lesson_id = l.id "
            + "INNER JOIN subject s ON l.subject_id = s.id "
            + "WHERE 1=1"
        );
        List<Object> parameters = new ArrayList<>();
        
        // Add quiz name filter
        if (quizName != null && !quizName.trim().isEmpty()) {
            sql.append(" AND q.name LIKE ?");
            parameters.add("%" + quizName.trim() + "%");
        }
        
        // Add subject id filter
        if (subjectId != null) {
            sql.append(" AND s.id = ?");
            parameters.add(subjectId);
        }
        
        // Add lesson id filter
        if (lessonId != null) {
            sql.append(" AND l.id = ?");
            parameters.add(lessonId);
        }
        
        // Add quiz type filter
        if (quizType != null && !quizType.trim().isEmpty()) {
            sql.append(" AND q.quiz_type = ?");
            parameters.add(quizType.trim());
        }
        
        // Add order by and pagination
        sql.append(" ORDER BY q.id ASC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        List<Quizzes> listQuizzes = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Quizzes quiz = getFromResultSet(resultSet);
                listQuizzes.add(quiz);
            }
        } catch (Exception e) {
            System.out.println("Error findQuizzesWithFilters at class QuizzesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuizzes;
    }
    
    public int getTotalFilteredQuizzes(String quizName, Integer subjectId, Integer lessonId, String quizType) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Quizzes q "
            + "INNER JOIN Lessons l ON q.lesson_id = l.id "
            + "INNER JOIN subject s ON l.subject_id = s.id "
            + "WHERE 1=1"
        );
        List<Object> parameters = new ArrayList<>();
        
        // Add quiz name filter
        if (quizName != null && !quizName.trim().isEmpty()) {
            sql.append(" AND q.name LIKE ?");
            parameters.add("%" + quizName.trim() + "%");
        }
        
        // Add subject id filter
        if (subjectId != null) {
            sql.append(" AND s.id = ?");
            parameters.add(subjectId);
        }
        
        // Add lesson id filter
        if (lessonId != null) {
            sql.append(" AND l.id = ?");
            parameters.add(lessonId);
        }
        
        // Add quiz type filter
        if (quizType != null && !quizType.trim().isEmpty()) {
            sql.append(" AND q.quiz_type = ?");
            parameters.add(quizType.trim());
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error getTotalFilteredQuizzes at class QuizzesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        QuizzesDAO quizzesDAO = new QuizzesDAO();
        int total = quizzesDAO.getTotalFilteredQuizzes(null, null, null, null);
        System.out.println(total);
    }
    
    /**
     * Check if quiz name exists within the same lesson
     */
    public boolean isNameExistsInLesson(String name, Integer lessonId) {
        String sql = "SELECT COUNT(*) FROM Quizzes WHERE name = ? AND lesson_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setInt(2, lessonId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("Error isNameExistsInLesson at class QuizzesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    /**
     * Check if quiz name exists within the same lesson excluding a specific quiz
     */
    public boolean isNameExistsInLessonExcluding(String name, Integer lessonId, Integer excludeQuizId) {
        String sql = "SELECT COUNT(*) FROM Quizzes WHERE name = ? AND lesson_id = ? AND id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setInt(2, lessonId);
            statement.setInt(3, excludeQuizId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("Error isNameExistsInLessonExcluding at class QuizzesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean hasEssayQuestions(Quizzes quiz) {
        // Implementation of hasEssayQuestions method
        return false; // Placeholder return, actual implementation needed
    }

    public boolean hasEssayQuestions(Integer quizId) {
        String sql = "SELECT COUNT(*) AS essay_count FROM Question q WHERE q.quiz_id = ? AND q.type = 'essay'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("essay_count") > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in hasEssayQuestions: " + e.getMessage());
        } finally {
            closeResources();
        }
        // Default to false if there's an error
        return false;
    }

}

