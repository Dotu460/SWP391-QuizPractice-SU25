package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.QuestionOption;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionOptionDAO extends DBContext implements I_DAO<QuestionOption> {

    @Override
    public List<QuestionOption> findAll() {
        String sql = "SELECT * FROM QuestionOption";
        List<QuestionOption> listOptions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                QuestionOption option = getFromResultSet(resultSet);
                listOptions.add(option);
            }                      
        } catch (Exception e) {
            System.out.println("Error findAll at class QuestionOptionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listOptions;
    }

    @Override
    public QuestionOption findById(Integer id) {
        String sql = "SELECT * FROM QuestionOption WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class QuestionOptionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<QuestionOption> findByQuestionId(Integer questionId) {
        String sql = "SELECT * FROM QuestionOption WHERE question_id = ? ORDER BY display_order";
        List<QuestionOption> listOptions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, questionId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                QuestionOption option = getFromResultSet(resultSet);
                listOptions.add(option);
            }
        } catch (Exception e) {
            System.out.println("Error findByQuestionId at class QuestionOptionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listOptions;
    }

    @Override
    public int insert(QuestionOption t) {
        String sql = "INSERT INTO QuestionOption (question_id, option_text, is_correct_key, display_order) VALUES (?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuestion_id());
            statement.setString(2, t.getOption_text());
            statement.setBoolean(3, t.isCorrect_key());
            statement.setInt(4, t.getDisplay_order());
            
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class QuestionOptionDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(QuestionOption t) {
        String sql = "UPDATE QuestionOption SET question_id=?, option_text=?, is_correct_key=?, display_order=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuestion_id());
            statement.setString(2, t.getOption_text());
            statement.setBoolean(3, t.isCorrect_key());
            statement.setInt(4, t.getDisplay_order());
            statement.setInt(5, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class QuestionOptionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(QuestionOption t) {
        String sql = "DELETE FROM QuestionOption WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class QuestionOptionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean deleteByQuestionId(Integer questionId) {
        String sql = "DELETE FROM QuestionOption WHERE question_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, questionId);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByQuestionId at class QuestionOptionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public QuestionOption getFromResultSet(ResultSet resultSet) throws SQLException {
        return QuestionOption.builder()
                .id(resultSet.getInt("id"))
                .question_id(resultSet.getInt("question_id"))
                .option_text(resultSet.getString("option_text"))
                .correct_key(resultSet.getBoolean("is_correct_key"))
                .display_order(resultSet.getInt("display_order"))
                .build();
    }

    public static void main(String[] args) {
        QuestionOptionDAO dao = new QuestionOptionDAO();
        dao.findAll().forEach(System.out::println);
    }
} 