package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.SubjectCategories;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SubjectCategoriesDAO extends DBContext implements I_DAO<SubjectCategories> {

    @Override
    public List<SubjectCategories> findAll() {
        String sql = "SELECT id, name, description FROM subject_categories";
        List<SubjectCategories> listCategories = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                SubjectCategories category = getFromResultSet(resultSet);
                listCategories.add(category);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectCategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listCategories;
    }

    @Override
    public SubjectCategories findById(Integer id) {
        String sql = "SELECT id, name, description FROM subject_categories WHERE id = ?";
        SubjectCategories category = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SubjectCategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return category;
    }

    @Override
    public int insert(SubjectCategories category) {
        String sql = "INSERT INTO subject_categories (name, description) VALUES (?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SubjectCategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(SubjectCategories category) {
        String sql = "UPDATE subject_categories SET name = ?, description = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setInt(3, category.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SubjectCategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(SubjectCategories category) {
        if (category == null || category.getId() == null) {
            return false;
        }
        return deleteById(category.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM subject_categories WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SubjectCategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public SubjectCategories getFromResultSet(ResultSet resultSet) throws SQLException {
        return SubjectCategories.builder()
                .id(resultSet.getInt("id"))
                .name(resultSet.getString("name"))
                .description(resultSet.getString("description"))
                .build();
    }

    public List<SubjectCategories> getPaginatedCategories(int page, int pageSize, String searchTerm,
                                                          String sortBy, String sortOrder) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, name, description ");
        sql.append("FROM subject_categories WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (name LIKE ? OR description LIKE ?) ");
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
            sql.append("ORDER BY id ");
        }

        // Add pagination
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        List<SubjectCategories> categories = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in getPaginatedCategories: " + e.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    public int countTotalCategories(String searchTerm) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM subject_categories WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (name LIKE ? OR description LIKE ?) ");
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
            System.out.println("Error in countTotalCategories: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }

    public static void main(String[] args) {
        SubjectCategoriesDAO categoryDAO = new SubjectCategoriesDAO();

        // Test findAll
        System.out.println("Testing findAll():");
        List<SubjectCategories> allCategories = categoryDAO.findAll();
        if (allCategories.isEmpty()) {
            System.out.println("No categories found.");
        } else {
            for (SubjectCategories category : allCategories) {
                System.out.println(category);
            }
        }
        System.out.println("--------------------");

        // Test findById
        System.out.println("Testing findById(1):");
        SubjectCategories categoryById = categoryDAO.findById(1);
        if (categoryById != null) {
            System.out.println(categoryById);
        } else {
            System.out.println("Category with ID 1 not found.");
        }
    }
}