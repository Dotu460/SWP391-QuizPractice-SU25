/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author quangmingdoc
 */
public class QuestionDAO extends DBContext implements I_DAO<Question> {

    @Override
    public List<Question> findAll() {
        String sql = "SELECT * FROM Question";
        List<Question> listQuestions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                Question question = getFromResultSet(resultSet);
                listQuestions.add(question);
            }
            // Load options cho tất cả questions
            loadOptionsForQuestions(listQuestions);
        } catch (Exception e) {
            System.out.println("Error findAll at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuestions;
    }

    @Override
    public boolean update(Question t) {
        String sql = "UPDATE Question SET quiz_id=?, type=?, content=?, media_url=?, level=?, status=?, explanation=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setString(2, t.getType());
            statement.setString(3, t.getContent());
            statement.setString(4, t.getMedia_url());
            statement.setString(5, t.getLevel());
            statement.setString(6, t.getStatus());
            statement.setString(7, t.getExplanation());
            statement.setInt(8, t.getId());
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
        String sql = "INSERT INTO Question (quiz_id, type, content, media_url, level, status, explanation) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setString(2, t.getType());
            statement.setString(3, t.getContent());
            statement.setString(4, t.getMedia_url());
            statement.setString(5, t.getLevel());
            statement.setString(6, t.getStatus());
            statement.setString(7, t.getExplanation());
            
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
                .quiz_id(resultSet.getInt("quiz_id"))
                .type(resultSet.getString("type"))
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
                Question question = getFromResultSet(resultSet);
                // Load options cho question
                loadOptionsForQuestion(question);
                return question;
            }
        } catch (Exception e) {
            System.out.println("Error findById at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Load options cho một question
     * @param question Question cần load options
     */
    private void loadOptionsForQuestion(Question question) {
        if (question != null) {
            QuestionOptionDAO optionDAO = new QuestionOptionDAO();
            List<QuestionOption> options = optionDAO.findByQuestionId(question.getId());
            question.setQuestionOptions(options);
        }
    }

    /**
     * Load options cho một list questions
     * @param questions List questions cần load options
     */
    private void loadOptionsForQuestions(List<Question> questions) {
        if (questions != null && !questions.isEmpty()) {
            QuestionOptionDAO optionDAO = new QuestionOptionDAO();
            for (Question question : questions) {
                List<QuestionOption> options = optionDAO.findByQuestionId(question.getId());
                question.setQuestionOptions(options);
            }
        }
    }

    /**
     * Tìm tất cả câu hỏi thuộc một quiz cụ thể
     * @param quizId ID của quiz cần tìm câu hỏi
     * @return Danh sách câu hỏi thuộc quiz
     */
    public List<Question> findByQuizId(Integer quizId) {
        String sql = "SELECT * FROM Question WHERE quiz_id = ?";
        List<Question> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                list.add(question);
            }
            // Load options cho tất cả questions
            loadOptionsForQuestions(list);
        } catch (Exception e) {
            System.out.println("Error findByQuizId at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Tìm tất cả câu hỏi thuộc một quiz với trạng thái cụ thể
     * @param quizId ID của quiz cần tìm câu hỏi
     * @param status Trạng thái câu hỏi cần tìm
     * @return Danh sách câu hỏi thỏa mãn điều kiện
     */
    public List<Question> findByQuizIdAndStatus(Integer quizId, String status) {
        String sql = "SELECT * FROM Question WHERE quiz_id = ? AND status = ?";
        List<Question> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            statement.setString(2, status);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                list.add(question);
            }
            // Load options cho tất cả questions
            loadOptionsForQuestions(list);
        } catch (Exception e) {
            System.out.println("Error findByQuizIdAndStatus at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Tìm câu hỏi với phân trang
     * @param pageNumber Số trang hiện tại
     * @param pageSize Số lượng câu hỏi mỗi trang
     * @return Danh sách câu hỏi đã phân trang
     */
    public List<Question> findQuestionsWithPagination(Integer pageNumber, Integer pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        String sql = "SELECT * FROM Question ORDER BY id LIMIT ? OFFSET ?";
        List<Question> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, pageSize);
            statement.setInt(2, offset);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                list.add(question);
            }
        } catch (Exception e) {
            System.out.println("Error findQuestionsWithPagination at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Đếm tổng số câu hỏi
     * @return Tổng số câu hỏi
     */
    public int countTotalQuestions() {
        String sql = "SELECT COUNT(*) as total FROM Question";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("Error countTotalQuestions at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Cập nhật trạng thái của câu hỏi
     * @param id ID của câu hỏi cần cập nhật
     * @param status Trạng thái mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE Question SET status=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateStatus at class QuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Cập nhật thứ tự của câu hỏi
     * @param id ID của câu hỏi cần cập nhật
     * @param order Thứ tự mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateOrder(Integer id, Integer order) {
        String sql = "UPDATE Question SET order_number = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, order);
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateOrder at class QuestionDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Tìm kiếm và lọc câu hỏi với nhiều tiêu chí kèm phân trang
     * 
     * @param contentFilter Tìm kiếm trong nội dung câu hỏi
     * @param subjectId Lọc theo subject
     * @param lessonId Lọc theo lesson
     * @param quizId Lọc theo quiz
     * @param statusFilter Lọc theo trạng thái câu hỏi (active/inactive)
     * @param page Số trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng câu hỏi mỗi trang
     * @return Danh sách câu hỏi thỏa mãn điều kiện cho trang hiện tại
     */
    public List<Question> findQuestionsWithFilters(String contentFilter, Integer subjectId, 
            Integer lessonId, Integer quizId, String statusFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
            "SELECT q.* FROM Question q "
            + "INNER JOIN Quizzes quiz ON q.quiz_id = quiz.id "
            + "INNER JOIN Lessons l ON quiz.lesson_id = l.id "
            + "INNER JOIN subject s ON l.subject_id = s.id "
            + "WHERE 1=1"
        );
        List<Object> parameters = new ArrayList<>();
        
        // Add content filter
        if (contentFilter != null && !contentFilter.trim().isEmpty()) {
            sql.append(" AND q.content LIKE ?");
            parameters.add("%" + contentFilter.trim() + "%");
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
        
        // Add quiz id filter
        if (quizId != null) {
            sql.append(" AND q.quiz_id = ?");
            parameters.add(quizId);
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND q.status = ?");
            parameters.add(statusFilter.trim());
        }
        
        // Add order by and pagination
        sql.append(" ORDER BY q.id ASC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        List<Question> listQuestions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                listQuestions.add(question);
            }
            // Load options cho tất cả questions
            loadOptionsForQuestions(listQuestions);
        } catch (Exception e) {
            System.out.println("Error findQuestionsWithFilters at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuestions;
    }
    
    /**
     * Đếm tổng số câu hỏi thỏa mãn điều kiện lọc
     * 
     * @param contentFilter Tìm kiếm trong nội dung câu hỏi
     * @param subjectId Lọc theo subject
     * @param lessonId Lọc theo lesson
     * @param quizId Lọc theo quiz
     * @param statusFilter Lọc theo trạng thái câu hỏi
     * @return Tổng số câu hỏi thỏa mãn điều kiện
     */
    public int getTotalFilteredQuestions(String contentFilter, Integer subjectId, 
            Integer lessonId, Integer quizId, String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Question q "
            + "INNER JOIN Quizzes quiz ON q.quiz_id = quiz.id "
            + "INNER JOIN Lessons l ON quiz.lesson_id = l.id "
            + "INNER JOIN subject s ON l.subject_id = s.id "
            + "WHERE 1=1"
        );
        List<Object> parameters = new ArrayList<>();
        
        // Add content filter
        if (contentFilter != null && !contentFilter.trim().isEmpty()) {
            sql.append(" AND q.content LIKE ?");
            parameters.add("%" + contentFilter.trim() + "%");
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
        
        // Add quiz id filter
        if (quizId != null) {
            sql.append(" AND q.quiz_id = ?");
            parameters.add(quizId);
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND q.status = ?");
            parameters.add(statusFilter.trim());
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
            System.out.println("Error getTotalFilteredQuestions at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    /**
     * Tìm câu hỏi theo nội dung
     * @param content Nội dung câu hỏi
     * @return Danh sách câu hỏi thỏa mãn điều kiện
     */
    public List<Question> findByContent(String content) {
        String sql = "SELECT * FROM Question WHERE content = ?";
        List<Question> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, content);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                list.add(question);
            }
            // Load options cho tất cả questions
            loadOptionsForQuestions(list);
        } catch (Exception e) {
            System.out.println("Error findByContent at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Đếm tổng số câu hỏi thuộc một quiz cụ thể.
     * @param quizId ID của quiz.
     * @return Tổng số câu hỏi trong quiz.
     */
    public int countQuestionsByQuizId(Integer quizId) {
        String sql = "SELECT COUNT(*) as total FROM Question WHERE quiz_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("Error countQuestionsByQuizId at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        QuestionDAO questionDAO = new QuestionDAO();
        questionDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}