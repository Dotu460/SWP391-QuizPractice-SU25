package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Lesson;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class LessonDAO extends DBContext implements I_DAO<Lesson> {

    @Override
    public List<Lesson> findAll() {
        String sql = "SELECT * FROM Lessons";
        List<Lesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Lesson lesson = getFromResultSet(resultSet);
                list.add(lesson);
            }
        } catch (Exception e) {
            System.out.println("Error findAll at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Lesson findById(Integer id) {
        String sql = "SELECT * FROM Lessons WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Lesson> findBySubjectId(Integer subjectId) {
        String sql = "SELECT * FROM Lessons WHERE subject_id = ? ORDER BY order_in_subject";
        List<Lesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Lesson lesson = getFromResultSet(resultSet);
                list.add(lesson);
            }
        } catch (Exception e) {
            System.out.println("Error findBySubjectId at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public int insert(Lesson lesson) {
        String sql = "INSERT INTO Lessons (subject_id, title, content_text, content_url, order_in_subject, status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, lesson.getSubject_id());
            statement.setString(2, lesson.getTitle());
            statement.setString(3, lesson.getContent_text());
            statement.setString(4, lesson.getContent_url());
            statement.setInt(5, lesson.getOrder_in_subject());
            statement.setString(6, lesson.getStatus());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating lesson failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating lesson failed, no ID obtained.");
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class LessonDAO: " + e.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(Lesson lesson) {
        String sql = "UPDATE Lessons SET subject_id = ?, title = ?, content_text = ?, content_url = ?, order_in_subject = ?, status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lesson.getSubject_id());
            statement.setString(2, lesson.getTitle());
            statement.setString(3, lesson.getContent_text());
            statement.setString(4, lesson.getContent_url());
            statement.setInt(5, lesson.getOrder_in_subject());
            statement.setString(6, lesson.getStatus());
            statement.setInt(7, lesson.getId());

            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class LessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Lesson lesson) {
        String sql = "DELETE FROM Lessons WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lesson.getId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class LessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateStatus(Integer id, String status) {
        String sql = "UPDATE Lessons SET status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateStatus at class LessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateOrder(Integer id, Integer order) {
        String sql = "UPDATE Lessons SET order_in_subject = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, order);
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error updateOrder at class LessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public Lesson getFromResultSet(ResultSet rs) throws SQLException {
        return Lesson.builder()
                .id(rs.getInt("id"))
                .subject_id(rs.getInt("subject_id"))
                .title(rs.getString("title"))
                .content_text(rs.getString("content_text"))
                .content_url(rs.getString("content_url"))
                .order_in_subject(rs.getInt("order_in_subject"))
                .status(rs.getString("status"))
                .build();
    }

    public List<Lesson> findBySubjectIdAndStatus(Integer subjectId, String status) {
        String sql = "SELECT * FROM Lessons WHERE subject_id = ? AND status = ? ORDER BY order_in_subject";
        List<Lesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            statement.setString(2, status);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Lesson lesson = getFromResultSet(resultSet);
                list.add(lesson);
            }
        } catch (Exception e) {
            System.out.println("Error findBySubjectIdAndStatus at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
    
    public List<Lesson> findLessonsWithPagination(Integer subjectId, Integer pageNumber, Integer pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        String sql = "SELECT * FROM Lessons WHERE subject_id = ? ORDER BY order_in_subject LIMIT ? OFFSET ?";
        List<Lesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            statement.setInt(2, pageSize);
            statement.setInt(3, offset);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Lesson lesson = getFromResultSet(resultSet);
                list.add(lesson);
            }
        } catch (Exception e) {
            System.out.println("Error findLessonsWithPagination at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
    
    public int countLessonsBySubjectId(Integer subjectId) {
        String sql = "SELECT COUNT(*) as total FROM Lessons WHERE subject_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("Error countLessonsBySubjectId at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Find lessons with filters and pagination
     */
    public List<Lesson> findLessonsWithFilters(String statusFilter, String searchFilter, 
            Integer subjectId, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT l.* FROM Lessons l");
        List<Object> parameters = new ArrayList<>();
        
        sql.append(" WHERE 1=1");
        
        // Add subject filter
        if (subjectId != null) {
            sql.append(" AND l.subject_id = ?");
            parameters.add(subjectId);
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            parameters.add(statusFilter.trim());
        }
        
        // Add search filter
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (l.title LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
        }
        
        // Add pagination
        sql.append(" ORDER BY l.order_in_subject ASC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        List<Lesson> listLesson = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Lesson lesson = getFromResultSet(resultSet);
                listLesson.add(lesson);
            }
        } catch (Exception e) {
            System.out.println("Error findLessonsWithFilters at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listLesson;
    }
    
    /**
     * Get total count of filtered lessons
     */
    public int getTotalFilteredLessons(String statusFilter, String searchFilter, Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM Lessons l");
        List<Object> parameters = new ArrayList<>();
        
        sql.append(" WHERE 1=1");
        
        // Add subject filter
        if (subjectId != null) {
            sql.append(" AND l.subject_id = ?");
            parameters.add(subjectId);
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            parameters.add(statusFilter.trim());
        }
        
        // Add search filter
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (l.title LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
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
                return resultSet.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("Error getTotalFilteredLessons at class LessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        LessonDAO dao = new LessonDAO();
        dao.findAll().forEach(System.out::println);
    }
} 