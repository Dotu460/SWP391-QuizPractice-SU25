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
        String sql = "INSERT INTO QuestionOption (question_id, option_text, answer_text, correct_key, display_order) VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuestion_id());
            statement.setString(2, t.getOption_text());
            statement.setString(3, t.getAnswer_text());
            statement.setBoolean(4, t.isCorrect_key());
            statement.setInt(5, t.getDisplay_order());
            
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
        String sql = "UPDATE QuestionOption SET question_id=?, option_text=?, answer_text=?, correct_key=?, display_order=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuestion_id());
            statement.setString(2, t.getOption_text());
            statement.setString(3, t.getAnswer_text());
            statement.setBoolean(4, t.isCorrect_key());
            statement.setInt(5, t.getDisplay_order());
            statement.setInt(6, t.getId());
            
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
                .answer_text(resultSet.getString("answer_text"))
                .correct_key(resultSet.getBoolean("correct_key"))
                .display_order(resultSet.getInt("display_order"))
                .build();
    }

    /**
     * Find all correct options for a question
     */
    public List<QuestionOption> findCorrectOptionsByQuestionId(Integer questionId) {
        String sql = "SELECT * FROM QuestionOption WHERE question_id = ? AND correct_key = true";
        List<QuestionOption> correctOptions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, questionId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                QuestionOption option = getFromResultSet(resultSet);
                correctOptions.add(option);
            }
        } catch (Exception e) {
            System.out.println("Error findCorrectOptionsByQuestionId at class QuestionOptionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return correctOptions;
    }

    public static void main(String[] args) {
        try {
            QuestionOptionDAO questionOptionDAO = new QuestionOptionDAO();
            
            // Test với một số question_id cụ thể
            Integer[] testQuestionIds = {1, 2, 3, 4, 5}; // Thay bằng các ID thực tế trong database của bạn
            
            for (Integer questionId : testQuestionIds) {
                System.out.println("\n=== Testing Question ID: " + questionId + " ===");
                
                // Test findByQuestionId (lấy tất cả options)
                System.out.println("\nAll options for Question " + questionId + ":");
                List<QuestionOption> allOptions = questionOptionDAO.findByQuestionId(questionId);
                if (allOptions.isEmpty()) {
                    System.out.println("No options found.");
                } else {
                    for (QuestionOption option : allOptions) {
                        System.out.println("Option ID: " + option.getId()
                                + "\nQuestion ID: " + option.getQuestion_id()
                                + "\nOption Text: " + option.getOption_text()
                                + "\nAnswer Text: " + option.getAnswer_text()
                                + "\nIs Correct: " + option.isCorrect_key()
                                + "\nDisplay Order: " + option.getDisplay_order()
                                + "\n-------------------");
                    }
                }
                
                // Test findCorrectOptionsByQuestionId (chỉ lấy correct options)
                System.out.println("\nCorrect options for Question " + questionId + ":");
                List<QuestionOption> correctOptions = questionOptionDAO.findCorrectOptionsByQuestionId(questionId);
                if (correctOptions.isEmpty()) {
                    System.out.println("No correct options found.");
                } else {
                    for (QuestionOption option : correctOptions) {
                        System.out.println("Option ID: " + option.getId()
                                + "\nQuestion ID: " + option.getQuestion_id()
                                + "\nOption Text: " + option.getOption_text()
                                + "\nAnswer Text: " + option.getAnswer_text()
                                + "\nIs Correct: " + option.isCorrect_key()
                                + "\nDisplay Order: " + option.getDisplay_order()
                                + "\n-------------------");
                    }
                }
                
                System.out.println("=====================================");
            }
        } catch (Exception e) {
            System.out.println("Error testing QuestionOptionDAO: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean updateOptionTextAndAnswerText(int optionId, String optionText, String answerText) {
        String sql = "UPDATE QuestionOption SET option_text = ?, answer_text = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, optionText);
            statement.setString(2, answerText);
            statement.setInt(3, optionId);
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateOptionTextAndAnswerText at class QuestionOptionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
}   
