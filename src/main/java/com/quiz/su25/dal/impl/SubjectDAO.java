package com.quiz.su25.dal.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Subject;
import java.sql.Date;

/**
 *
 * @author FPT
 */
public class SubjectDAO extends DBContext implements I_DAO<Subject> {

    @Override
    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Subject findById(Integer id) {
        String sql = "SELECT * FROM subject WHERE id = ?";
        Subject subject = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                subject = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return subject;
    }

    @Override
    public int insert(Subject subject) {
        String sql = "INSERT INTO subject "
                + "(title, thumbnail_url, tag_line, brief_info, description, category_id, "
                + "owner_id, status, featured_flag, created_at, updated_at, created_by, updated_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getBrief_info());
            statement.setString(5, subject.getDescription());
            statement.setInt(6, subject.getCategory_id());
            statement.setInt(7, subject.getOwner_id());
            statement.setString(8, subject.getStatus());
            statement.setBoolean(9, subject.getFeatured_flag());
            statement.setDate(10, (Date) subject.getCreated_at());
            statement.setDate(11, (Date) subject.getUpdated_at());
            statement.setInt(12, subject.getCreated_by());
            statement.setInt(13, subject.getUpdated_by());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Subject subject) {
        String sql = "UPDATE subject SET "
                + "title = ?, thumbnail_url = ?, tag_line = ?, brief_info = ?, description = ?, "
                + "category_id = ?, owner_id = ?, status = ?, featured_flag = ?, "
                + "updated_at = ?, updated_by = ? "
                + "WHERE subject_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getBrief_info());
            statement.setString(5, subject.getDescription());
            statement.setInt(6, subject.getCategory_id());
            statement.setInt(7, subject.getOwner_id());
            statement.setString(8, subject.getStatus());
            statement.setBoolean(9, subject.getFeatured_flag());
            statement.setObject(10, subject.getUpdated_at());
            statement.setInt(11, subject.getUpdated_by());
            statement.setInt(12, subject.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Subject subject) {
        if (subject == null || subject.getId() == null) {
            return false;
        }
        return deleteById(subject.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM subject WHERE subject_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Subject getFromResultSet(ResultSet resultSet) throws SQLException {
        return Subject.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbnail_url"))
                .tag_line(resultSet.getString("tag_line"))
                .brief_info(resultSet.getString("brief_info"))
                .description(resultSet.getString("description"))
                .category_id(resultSet.getInt("category_id"))
                .owner_id(resultSet.getInt("owner_id"))
                .status(resultSet.getString("status"))
                .featured_flag(resultSet.getBoolean("featured_flag"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_by(resultSet.getInt("created_by"))
                .updated_by(resultSet.getInt("updated_by"))
                .build();
    }

    public List<Subject> getPaginatedSubjects(int page, int pageSize, String categoryFilter,
                                              String statusFilter, String searchTerm,
                                              String sortBy, String sortOrder) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT subject_id, title, thumbnail_url, tag_line, brief_info, description, ");
        sql.append("category_id, owner_id, status, featured_flag, created_at, updated_at, created_by, updated_by ");
        sql.append("FROM subject WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (title LIKE ? OR description LIKE ? OR brief_info LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append("ORDER BY ").append(sortBy);
            if ("desc".equalsIgnoreCase(sortOrder)) {
                sql.append(" DESC ");
            } else {
                sql.append(" ASC ");
            }
        } else {
            sql.append("ORDER BY subject_id ");
        }

        // Add pagination
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        List<Subject> subjects = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                subjects.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in getPaginatedSubjects: " + e.getMessage());
        } finally {
            closeResources();
        }
        return subjects;
    }

    public int countTotalSubjects(String categoryFilter, String statusFilter, String searchTerm) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM subject WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (title LIKE ? OR description LIKE ? OR brief_info LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countTotalSubjects: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }


    public List<Subject> getFeaturedSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE featured_flag = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getFeaturedSubjects at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
    public static void main(String[] args) {
        SubjectDAO subjectDAO = new SubjectDAO();

        // Test findAll
        System.out.println("Testing findAll():");
        List<Subject> allSubjects = subjectDAO.findAll();
        if (allSubjects.isEmpty()) {
            System.out.println("No subjects found.");
        } else {
            for (Subject subject : allSubjects) {
                System.out.println(subject);
            }
        }
        System.out.println("--------------------");

        // Test findById
        System.out.println("Testing findById(1):");
        Subject subjectById = subjectDAO.findById(1);
        if (subjectById != null) {
            System.out.println(subjectById);
        } else {
            System.out.println("Subject with ID 1 not found.");
        }
    }
}
