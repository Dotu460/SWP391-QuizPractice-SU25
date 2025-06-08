/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Category;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author LENOVO
 */
public class CategoryDAO extends DBContext implements I_DAO<Category> {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Category findById(Integer id) {
        String sql = "SELECT * FROM category WHERE id = ?";
        Category category = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return category;
    }

    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO category (name, description, icon_url) VALUES (?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setString(3, category.getIcon_url());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE category SET name = ?, description = ?, icon_url = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setString(3, category.getIcon_url());
            statement.setInt(4, category.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Category category) {
        if (category == null || category.getId() == null) {
            return false;
        }
        return deleteById(category.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM category WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Category getFromResultSet(ResultSet resultSet) throws SQLException {
        return Category.builder()
                .id(resultSet.getInt("id"))
                .name(resultSet.getString("name"))
                .description(resultSet.getString("description"))
                .icon_url(resultSet.getString("icon_url"))
                .build();
    }
    
    /**
     * Count the number of posts in each category
     * @return A map with category ID as key and post count as value
     */
    public Map<Integer, Integer> countPostsByCategories() {
        Map<Integer, Integer> countMap = new HashMap<>();
        String sql = "SELECT c.id, COUNT(p.id) as post_count FROM category c " +
                     "LEFT JOIN post p ON c.id = p.category_id " +
                     "GROUP BY c.id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int categoryId = resultSet.getInt("id");
                int postCount = resultSet.getInt("post_count");
                countMap.put(categoryId, postCount);
            }
        } catch (SQLException e) {
            System.out.println("Error countPostsByCategories at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return countMap;
    }
    
    /**
     * Get all categories with post counts
     * @return List of categories with post counts
     */
    public List<Map<String, Object>> getCategoriesWithPostCounts() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) as post_count FROM category c " +
                     "LEFT JOIN post p ON c.id = p.category_id " +
                     "GROUP BY c.id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> item = new HashMap<>();
                Category category = getFromResultSet(resultSet);
                item.put("category", category);
                item.put("postCount", resultSet.getInt("post_count"));
                list.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getCategoriesWithPostCounts at class CategoryDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
} 