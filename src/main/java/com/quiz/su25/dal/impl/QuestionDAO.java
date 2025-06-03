/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Question;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class QuestionDAO extends DBContext implements I_DAO<Question> {

    @Override
    public List<Question> findAll() {
        String sql = "select * from Question";
        List<Question> listQuestion = new ArrayList<>();
        try {
            //tao connection
            connection = getConnection();
            //chuan bi cho statement
            statement = connection.prepareStatement(sql);
            //set param
            
            //thuc thi cau lenh
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                Question question = getFromResultSet(resultSet);
                listQuestion.add(question);
            }                      
        } catch (Exception e) {
            System.out.println("Error findAll at class QuestionDAO: " + e.getMessage());
        } finally{
            closeResources();
        }
        return listQuestion;
    }

    @Override
    public boolean update(Question t) {
        String sql = "UPDATE Question SET subject_id=?, lesson_id=?, dimension_id=?, content=?, media_url=?, level=?, status=?, explanation=?, created_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getSubject_id());
            statement.setInt(2, t.getLesson_id());
            statement.setInt(3, t.getDimension_id());
            statement.setString(4, t.getContent());
            statement.setString(5, t.getMedia_url());
            statement.setString(6, t.getLevel());
            statement.setString(7, t.getStatus());
            statement.setString(8, t.getExplanation());
            statement.setInt(9, t.getCreated_by());
            statement.setInt(10, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class QuestionDAO - update: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Question t) {
        String sql = "DELETE FROM Question WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class QuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Question t) {
        String sql = "INSERT INTO Question (subject_id, lesson_id, dimension_id, content, media_url, level, status, explanation, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getSubject_id());
            statement.setInt(2, t.getLesson_id());
            statement.setInt(3, t.getDimension_id());
            statement.setString(4, t.getContent());
            statement.setString(5, t.getMedia_url());
            statement.setString(6, t.getLevel());
            statement.setString(7, t.getStatus());
            statement.setString(8, t.getExplanation());
            statement.setInt(9, t.getCreated_by());
            
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class QuestionDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public Question getFromResultSet(ResultSet resultSet) throws SQLException {
        return Question.builder()
                .id(resultSet.getInt("id"))
                .subject_id(resultSet.getInt("subject_id"))
                .lesson_id(resultSet.getInt("lesson_id"))
                .dimension_id(resultSet.getInt("dimension_id"))
                .content(resultSet.getString("content"))
                .media_url(resultSet.getString("media_url"))
                .level(resultSet.getString("level"))
                .status(resultSet.getString("status"))
                .explanation(resultSet.getString("explanation"))
                .created_by(resultSet.getInt("created_by"))
                .build();
    }

    @Override
    public Question findById(Integer id) {
        String sql = "SELECT * FROM Question WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    public static void main(String[] args) {
        QuestionDAO questionDAO = new QuestionDAO();
        questionDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
