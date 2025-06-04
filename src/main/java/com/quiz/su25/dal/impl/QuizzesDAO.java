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
        String sql = "UPDATE Quizzes SET name = ?, subject_id = ?, level = ?,"
                + " number_of_questions_target = ?, duration_minutes = ?, pass_rate = ?, "
                + "quiz_type = ?, status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getSubject_id());
            statement.setString(3, t.getLevel());
            statement.setInt(4, t.getNumber_of_questions_target());
            statement.setInt(5, t.getDuration_minutes());
            statement.setDouble(6, t.getPass_rate());
            statement.setString(7, t.getQuiz_type());
            statement.setString(8, t.getStatus());
            statement.setInt(9, t.getId());
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
        String sql = "INSERT INTO Quizzes (name, subject_id, level, number_of_questions_target,"
                + " duration_minutes, pass_rate, quiz_type, status ) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getSubject_id());
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

    @Override
    public Quizzes getFromResultSet(ResultSet resultSet) throws SQLException {
        return Quizzes.builder()
                .id(resultSet.getInt("id"))
                .name(resultSet.getString("name"))
                .subject_id(resultSet.getInt("subject_id"))
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


    public List<Quizzes> findQuizzesWithFilters(String quizName, String subjectId, 
            String quizType, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Quizzes WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Add name filter
        if (quizName != null && !quizName.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            String searchPattern = "%" + quizName.trim() + "%";
            parameters.add(searchPattern);
        }
        
        // Add subject filter
        if (subjectId != null && !subjectId.trim().isEmpty()) {
            try {
                int subjectIdInt = Integer.parseInt(subjectId.trim());
                sql.append(" AND subject_id = ?");
                parameters.add(subjectIdInt);
            } catch (NumberFormatException e) {
                // Ignore invalid subject id
            }
        }
        
        // Add quiz type filter
        if (quizType != null && !quizType.trim().isEmpty()) {
            sql.append(" AND quiz_type = ?");
            parameters.add(quizType.trim());
        }
        
        // Add pagination
        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");
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
    
    /**
     * Get total count of filtered quizzes
     */
    public int getTotalFilteredQuizzes(String quizName, String subjectId, String quizType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Quizzes WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Add name filter
        if (quizName != null && !quizName.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            String searchPattern = "%" + quizName.trim() + "%";
            parameters.add(searchPattern);
        }
        
        // Add subject filter
        if (subjectId != null && !subjectId.trim().isEmpty()) {
            try {
                int subjectIdInt = Integer.parseInt(subjectId.trim());
                sql.append(" AND subject_id = ?");
                parameters.add(subjectIdInt);
            } catch (NumberFormatException e) {
                // Ignore invalid subject id
            }
        }
        
        // Add quiz type filter
        if (quizType != null && !quizType.trim().isEmpty()) {
            sql.append(" AND quiz_type = ?");
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
        int total = quizzesDAO.getTotalFilteredQuizzes("Basic Math Quiz", "8", "Multiple Choice");
        System.out.println(total);
    }
}

