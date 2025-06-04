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
        String sql = "UPDATE Question SET quiz_id=?, content=?, media_url=?, level=?, status=?, explanation=?, created_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setString(2, t.getContent());
            statement.setString(3, t.getMedia_url());
            statement.setString(4, t.getLevel());
            statement.setString(5, t.getStatus());
            statement.setString(6, t.getExplanation());
            statement.setInt(7, t.getCreated_by());
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
        String sql = "INSERT INTO Question (quiz_id, content, media_url, level, status, explanation, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getQuiz_id());
            statement.setString(2, t.getContent());
            statement.setString(3, t.getMedia_url());
            statement.setString(4, t.getLevel());
            statement.setString(5, t.getStatus());
            statement.setString(6, t.getExplanation());
            statement.setInt(7, t.getCreated_by());
            
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
    public boolean updateStatus(Integer id, String status) {
        String sql = "UPDATE Question SET status = ? WHERE id = ?";
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
     * @param statusFilter Lọc theo trạng thái câu hỏi (active/inactive)
     * @param searchFilter Tìm kiếm trong nội dung và phần giải thích
     * @param levelFilter Lọc theo độ khó (easy/medium/hard)
     * @param page Số trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng câu hỏi mỗi trang
     * @return Danh sách câu hỏi thỏa mãn điều kiện cho trang hiện tại
     */
    public List<Question> findQuestionsWithFilters(String statusFilter, String searchFilter, 
            String levelFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Question WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Thêm điều kiện lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            parameters.add(statusFilter.trim());
        }
        
        // Thêm điều kiện tìm kiếm trong nội dung và phần giải thích
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (content LIKE ? OR explanation LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // Thêm điều kiện lọc theo độ khó
        if (levelFilter != null && !levelFilter.trim().isEmpty()) {
            sql.append(" AND level = ?");
            parameters.add(levelFilter.trim());
        }
        
        // Thêm sắp xếp và phân trang
        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        List<Question> listQuestions = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Thiết lập các tham số
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Question question = getFromResultSet(resultSet);
                listQuestions.add(question);
            }
        } catch (Exception e) {
            System.out.println("Error findQuestionsWithFilters at class QuestionDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listQuestions;
    }
    
    /**
     * Đếm tổng số câu hỏi thỏa mãn điều kiện lọc
     * Phương thức này được sử dụng để tính toán phân trang và hiển thị tổng số kết quả
     * 
     * @param statusFilter Lọc theo trạng thái câu hỏi
     * @param searchFilter Tìm kiếm trong nội dung và phần giải thích
     * @param levelFilter Lọc theo độ khó
     * @return Tổng số câu hỏi thỏa mãn điều kiện
     */
    public int getTotalFilteredQuestions(String statusFilter, String searchFilter, 
            String levelFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Question WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Thêm điều kiện lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            parameters.add(statusFilter.trim());
        }
        
        // Thêm điều kiện tìm kiếm trong nội dung và phần giải thích
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (content LIKE ? OR explanation LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // Thêm điều kiện lọc theo độ khó
        if (levelFilter != null && !levelFilter.trim().isEmpty()) {
            sql.append(" AND level = ?");
            parameters.add(levelFilter.trim());
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Thiết lập các tham số
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
    
    public static void main(String[] args) {
        QuestionDAO questionDAO = new QuestionDAO();
        questionDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
