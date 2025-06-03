/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Subject;

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
        String sql = "INSERT INTO subject (title, thumbnail_url, tag_line, description, featured_flag, category_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getDescription());
            statement.setBoolean(5, subject.getFeatured_flag());
            statement.setInt(6, subject.getCategory_id());
            statement.setString(7, subject.getStatus());

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
        String sql = "UPDATE subject SET title = ?, thumbnail_url = ?, tag_line = ?, description = ?, featured_flag = ?, category_id = ?, status = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getDescription());
            statement.setBoolean(5, subject.getFeatured_flag());
            statement.setInt(6, subject.getCategory_id());
            statement.setString(7, subject.getStatus());
            statement.setInt(8, subject.getId());

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
        String sql = "DELETE FROM subject WHERE id = ?";
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
                .description(resultSet.getString("description"))
                .featured_flag(resultSet.getBoolean("featured_flag"))
                .category_id(resultSet.getInt("category_id"))
                .status(resultSet.getString("status"))
                .build();
    }

    public List<Subject> getPaginatedSubjects(int page, int pageSize, String categoryFilter,
                                              String statusFilter, String searchTerm,
                                              String sortBy, String sortOrder) {
        List<Subject> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM subject WHERE 1=1");

        // Add filters
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                statement.setString(paramIndex++, categoryFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }

            // Set pagination parameters
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, (page - 1) * pageSize);

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
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM subject WHERE 1=1");

        // Add filters
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                statement.setString(paramIndex++, categoryFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
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
}
