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
import java.sql.Date;
import java.time.LocalDate;

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
        String sql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, selected_option_id, correct, answer_at, essay_answer, essay_score, essay_feedback) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getAttempt_id());
            statement.setInt(2, t.getQuiz_question_id());
            statement.setInt(3, t.getSelected_option_id() != null ? t.getSelected_option_id() : 0);
            statement.setBoolean(4, t.getCorrect());
            statement.setDate(5, t.getAnswer_at());
            statement.setString(6, t.getEssay_answer());
            
            if (t.getEssay_score() != null) {
                statement.setDouble(7, t.getEssay_score());
            } else {
                statement.setNull(7, java.sql.Types.DOUBLE);
            }
            
            statement.setString(8, t.getEssay_feedback());
            
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
        String sql = "UPDATE UserQuizAttemptAnswers SET attempt_id=?, quiz_question_id=?, selected_option_id=?, correct=?, answer_at=?, essay_answer=?, essay_score=?, essay_feedback=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getAttempt_id());
            statement.setInt(2, t.getQuiz_question_id());
            statement.setInt(3, t.getSelected_option_id() != null ? t.getSelected_option_id() : 0);
            statement.setBoolean(4, t.getCorrect());
            statement.setDate(5, t.getAnswer_at());
            statement.setString(6, t.getEssay_answer());
            
            if (t.getEssay_score() != null) {
                statement.setDouble(7, t.getEssay_score());
            } else {
                statement.setNull(7, java.sql.Types.DOUBLE);
            }
            
            statement.setString(8, t.getEssay_feedback());
            statement.setInt(9, t.getId());
            
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
        UserQuizAttemptAnswers answer = new UserQuizAttemptAnswers();
        answer.setId(resultSet.getInt("id"));
        answer.setAttempt_id(resultSet.getInt("attempt_id"));
        answer.setQuiz_question_id(resultSet.getInt("quiz_question_id"));
        
        // Xử lý trường selected_option_id có thể null
        Integer selectedOptionId = resultSet.getInt("selected_option_id");
        if (resultSet.wasNull()) {
            selectedOptionId = null;
        }
        answer.setSelected_option_id(selectedOptionId);
        
        answer.setCorrect(resultSet.getBoolean("correct"));
        answer.setAnswer_at(resultSet.getDate("answer_at"));
        
        // Đọc các trường cho câu hỏi tự luận
        answer.setEssay_answer(resultSet.getString("essay_answer"));
        
        // Kiểm tra xem cột essay_score có tồn tại không
        try {
            Double essayScore = resultSet.getDouble("essay_score");
            if (resultSet.wasNull()) {
                essayScore = null;
            }
            answer.setEssay_score(essayScore);
        } catch (SQLException e) {
            // Nếu cột không tồn tại, đặt giá trị mặc định là null
            answer.setEssay_score(null);
            System.out.println("Column 'essay_score' not found, using default value null");
        }
        
        // Kiểm tra xem cột essay_feedback có tồn tại không
        try {
            answer.setEssay_feedback(resultSet.getString("essay_feedback"));
        } catch (SQLException e) {
            // Nếu cột không tồn tại, đặt giá trị mặc định là null
            answer.setEssay_feedback(null);
            System.out.println("Column 'essay_feedback' not found, using default value null");
        }
        
        return answer;
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
    public List<UserQuizAttemptAnswers> findByAttemptAndQuestionId(Integer attemptId, Integer questionId) {
        String sql = "SELECT * FROM UserQuizAttemptAnswers WHERE attempt_id = ? AND quiz_question_id = ?";
        List<UserQuizAttemptAnswers> answers = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            statement.setInt(2, questionId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                answers.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            System.out.println("Error findByAttemptAndQuestionId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return answers;
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
     * Delete all answers for a question in an attempt
     */
    public boolean deleteByAttemptAndQuestionId(Integer attemptId, Integer questionId) {
        String sql = "DELETE FROM UserQuizAttemptAnswers WHERE attempt_id = ? AND quiz_question_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            statement.setInt(2, questionId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByAttemptAndQuestionId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Batch insert multiple answers
     */
    public boolean batchInsertAnswers(List<UserQuizAttemptAnswers> answers) {
        String sql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, selected_option_id, correct, answer_at, essay_answer) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            statement = connection.prepareStatement(sql);
            
            for (UserQuizAttemptAnswers answer : answers) {
                statement.setInt(1, answer.getAttempt_id());
                statement.setInt(2, answer.getQuiz_question_id());
                statement.setInt(3, answer.getSelected_option_id() != null ? answer.getSelected_option_id() : 0);
                statement.setBoolean(4, answer.getCorrect());
                statement.setDate(5, answer.getAnswer_at());
                statement.setString(6, answer.getEssay_answer());
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

    /**
     * Lưu câu trả lời tự luận cho một câu hỏi trong một lần thi
     * 
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     * @param essayAnswer Nội dung câu trả lời tự luận
     * @return true nếu lưu thành công, false nếu thất bại
     */
    public boolean saveEssayAnswer(Integer attemptId, Integer questionId, String essayAnswer) {
        try {
            // Kiểm tra xem đã có câu trả lời cho câu hỏi này chưa
            UserQuizAttemptAnswers existingAnswer = findEssayAnswerByAttemptAndQuestionId(attemptId, questionId);
            
            if (existingAnswer != null) {
                // Nếu đã có, cập nhật câu trả lời
                String sql = "UPDATE UserQuizAttemptAnswers SET essay_answer = ? WHERE attempt_id = ? AND quiz_question_id = ?";
                connection = getConnection();
                statement = connection.prepareStatement(sql);
                statement.setString(1, essayAnswer);
                statement.setInt(2, attemptId);
                statement.setInt(3, questionId);
                
                return statement.executeUpdate() > 0;
            } else {
                // Nếu chưa có, tạo mới câu trả lời
                String sql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, essay_answer, answer_at) VALUES (?, ?, ?, NOW())";
                connection = getConnection();
                statement = connection.prepareStatement(sql);
                statement.setInt(1, attemptId);
                statement.setInt(2, questionId);
                statement.setString(3, essayAnswer);
                
                return statement.executeUpdate() > 0;
            }
        } catch (Exception e) {
            System.out.println("Error saveEssayAnswer at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Tìm câu trả lời tự luận cho một câu hỏi trong một lần thi
     * 
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     * @return UserQuizAttemptAnswers nếu tìm thấy, null nếu không tìm thấy
     */
    public UserQuizAttemptAnswers findEssayAnswerByAttemptAndQuestionId(Integer attemptId, Integer questionId) {
        // Không kiểm tra essay_score trong câu truy vấn SQL
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
            System.out.println("Error findEssayAnswerByAttemptAndQuestionId at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Cập nhật điểm và feedback cho câu trả lời tự luận
     * 
     * @param attemptId ID của lần thi
     * @param questionId ID của câu hỏi
     * @param score Điểm số (0-10)
     * @param feedback Phản hồi của giáo viên
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateEssayScore(Integer attemptId, Integer questionId, Double score, String feedback) {
        try {
            // Kiểm tra xem bảng có cột essay_score và essay_feedback không
            boolean columnsExist = checkColumnsExist();
            
            if (!columnsExist) {
                // Nếu không tồn tại, thêm các cột này vào bảng
                addEssayColumns();
            }
            
            // Kiểm tra xem câu trả lời đã tồn tại chưa
            UserQuizAttemptAnswers existingAnswer = findEssayAnswerByAttemptAndQuestionId(attemptId, questionId);
            
            if (existingAnswer == null) {
                // Nếu chưa có câu trả lời, tạo mới với điểm và feedback
                System.out.println("No existing answer found, creating new one");
                String insertSql = "INSERT INTO UserQuizAttemptAnswers (attempt_id, quiz_question_id, essay_score, essay_feedback, answer_at) VALUES (?, ?, ?, ?, NOW())";
                connection = getConnection();
                statement = connection.prepareStatement(insertSql);
                statement.setInt(1, attemptId);
                statement.setInt(2, questionId);
                statement.setDouble(3, score);
                statement.setString(4, feedback);
                
                return statement.executeUpdate() > 0;
            } else {
                // Nếu đã có câu trả lời, cập nhật điểm và feedback
                System.out.println("Updating existing answer with ID: " + existingAnswer.getId());
                String updateSql = "UPDATE UserQuizAttemptAnswers SET essay_score = ?, essay_feedback = ? WHERE attempt_id = ? AND quiz_question_id = ?";
                connection = getConnection();
                statement = connection.prepareStatement(updateSql);
                statement.setDouble(1, score);
                statement.setString(2, feedback);
                statement.setInt(3, attemptId);
                statement.setInt(4, questionId);
                
                return statement.executeUpdate() > 0;
            }
        } catch (Exception e) {
            System.out.println("Error updateEssayScore at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Kiểm tra xem bảng UserQuizAttemptAnswers có chứa cột essay_score và essay_feedback không
     */
    private boolean checkColumnsExist() {
        try {
            connection = getConnection();
            resultSet = connection.getMetaData().getColumns(null, null, "UserQuizAttemptAnswers", "essay_score");
            boolean essayScoreExists = resultSet.next();
            
            resultSet = connection.getMetaData().getColumns(null, null, "UserQuizAttemptAnswers", "essay_feedback");
            boolean essayFeedbackExists = resultSet.next();
            
            return essayScoreExists && essayFeedbackExists;
        } catch (Exception e) {
            System.out.println("Error checkColumnsExist at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thêm cột essay_score và essay_feedback vào bảng UserQuizAttemptAnswers
     */
    private boolean addEssayColumns() {
        try {
            connection = getConnection();
            statement = connection.prepareStatement(
                "ALTER TABLE UserQuizAttemptAnswers ADD COLUMN IF NOT EXISTS essay_score DOUBLE NULL, " +
                "ADD COLUMN IF NOT EXISTS essay_feedback TEXT NULL"
            );
            statement.executeUpdate();
            System.out.println("Added essay_score and essay_feedback columns to UserQuizAttemptAnswers table");
            return true;
        } catch (Exception e) {
            System.out.println("Error addEssayColumns at class UserQuizAttemptAnswersDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        UserQuizAttemptAnswersDAO userQuizAttemptAnswersDAO = new UserQuizAttemptAnswersDAO();
        userQuizAttemptAnswersDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
