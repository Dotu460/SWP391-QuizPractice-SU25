package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.QuizQuestion;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuizQuestionDAO extends DBContext implements I_DAO<QuizQuestion> {

    @Override
    public List<QuizQuestion> findAll() {
        String sql = "SELECT * FROM QuizQuestion";
        List<QuizQuestion> listQuizQuestions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                QuizQuestion quizQuestion = getFromResultSet(resultSet);
                listQuizQuestions.add(quizQuestion);
            }                      
        } catch (Exception e) {
            System.out.println("Error findAll at class QuizQuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuizQuestions;
    }

    @Override
    public QuizQuestion findById(Integer id) {
        String sql = "SELECT * FROM QuizQuestion WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class QuizQuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<QuizQuestion> findByQuizId(Integer quizId) {
        String sql = "SELECT * FROM QuizQuestion WHERE quiz_id = ? ORDER BY order_in_quiz";
        List<QuizQuestion> listQuizQuestions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                QuizQuestion quizQuestion = getFromResultSet(resultSet);
                listQuizQuestions.add(quizQuestion);
            }
        } catch (Exception e) {
            System.out.println("Error findByQuizId at class QuizQuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuizQuestions;
    }

    @Override
    public int insert(QuizQuestion t) {
        String sql = "INSERT INTO QuizQuestion (quiz_id, question_id, order_in_quiz) VALUES (?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setInt(2, t.getQuestion_id());
            statement.setInt(3, t.getOrder_in_quiz());
            
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class QuizQuestionDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(QuizQuestion t) {
        String sql = "UPDATE QuizQuestion SET quiz_id=?, question_id=?, order_in_quiz=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setInt(2, t.getQuestion_id());
            statement.setInt(3, t.getOrder_in_quiz());
            statement.setInt(4, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class QuizQuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(QuizQuestion t) {
        String sql = "DELETE FROM QuizQuestion WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class QuizQuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean deleteByQuizId(Integer quizId) {
        String sql = "DELETE FROM QuizQuestion WHERE quiz_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByQuizId at class QuizQuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateQuestionOrder(Integer id, Integer order) {
        String sql = "UPDATE QuizQuestion SET order_in_quiz = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, order);
            statement.setInt(2, id);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateQuestionOrder at class QuizQuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public QuizQuestion getFromResultSet(ResultSet resultSet) throws SQLException {
        return QuizQuestion.builder()
                .id(resultSet.getInt("id"))
                .quiz_id(resultSet.getInt("quiz_id"))
                .Question_id(resultSet.getInt("question_id"))
                .order_in_quiz(resultSet.getInt("order_in_quiz"))
                .build();
    }

    public static void main(String[] args) {
        QuizQuestionDAO dao = new QuizQuestionDAO();
        dao.findAll().forEach(System.out::println);
    }
} 
