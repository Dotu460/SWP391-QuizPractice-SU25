/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.entity.Post;
import java.sql.*;
import java.util.*;
import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;

public class PostDAO extends DBContext implements I_DAO<Post> {
    
    @Override
    public List<Post> findAll() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Post findById(Integer id) {
        String sql = "SELECT * FROM post WHERE id = ?";
        Post post = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                post = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return post;
    }

    @Override
    public int insert(Post post) {
        String sql = "INSERT INTO post (title, thumbnail_url, brief_info, content, category_id, author_id, published_at, updated_at, created_at, status, featured_flag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getThumbnail_url());
            statement.setString(3, post.getBrief_info());
            statement.setString(4, post.getContent());
            statement.setInt(5, post.getCategory_id());
            statement.setInt(6, post.getAuthor_id());
            statement.setDate(7, post.getPublished_at());
            statement.setDate(8, post.getUpdated_at());
            statement.setDate(9, post.getCreated_at());
            statement.setString(10, post.getStatus());
            statement.setBoolean(11, post.getFeatured_flag());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Post post) {
        String sql = "UPDATE post SET title = ?, thumbnail_url = ?, brief_info = ?, content = ?, category_id = ?, author_id = ?, published_at = ?, updated_at = ?, created_at = ?, status = ?, featured_flag = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getThumbnail_url());
            statement.setString(3, post.getBrief_info());
            statement.setString(4, post.getContent());
            statement.setInt(5, post.getCategory_id());
            statement.setInt(6, post.getAuthor_id());
            statement.setDate(7, post.getPublished_at());
            statement.setDate(8, post.getUpdated_at());
            statement.setDate(9, post.getCreated_at());
            statement.setString(10, post.getStatus());
            statement.setBoolean(11, post.getFeatured_flag());
            statement.setInt(12, post.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Post post) {
        if (post == null || post.getId() == null) {
            return false;
        }
        return deleteById(post.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM post WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Post getFromResultSet(ResultSet resultSet) throws SQLException {
        return Post.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbnail_url"))
                .brief_info(resultSet.getString("brief_info"))
                .content(resultSet.getString("content"))
                .category_id(resultSet.getInt("category_id"))
                .author_id(resultSet.getInt("author_id"))
                .published_at(resultSet.getDate("published_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_at(resultSet.getDate("created_at"))
                .status(resultSet.getString("status"))
                .featured_flag(resultSet.getBoolean("featured_flag"))
                .build();
    }

    public List<Post> getHotPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE featured_flag = true ORDER BY published_at DESC LIMIT 5";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getHotPosts at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Post> getLatestPosts(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE featured_flag = 2 ORDER BY published_at DESC LIMIT ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getLatestPosts at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
}
