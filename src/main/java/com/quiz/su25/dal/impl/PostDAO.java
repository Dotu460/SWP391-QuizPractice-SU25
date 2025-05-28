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
    // Tìm tất cả bài Post trong DB
    @Override
    public List<Post> findAll() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM Post";
        try {
            connection = getConnection();// Mở kết nối DB
            statement = connection.prepareStatement(sql);// Chuẩn bị statement
            resultSet = statement.executeQuery();// Thực thi query
            while (resultSet.next()) {// Lặp qua kết quả
                list.add(getFromResultSet(resultSet));// Chuyển mỗi dòng thành đối tượng Post
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();// Đóng kết nối và statement
        }
        return list;// Trả về danh sách Post
    }
    // Tìm Post theo ID
    @Override
    public Post findById(Integer id) {
        String sql = "SELECT * FROM Post WHERE id = ?";
        Post post = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);// Gán giá trị ID vào câu SQL
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                post = getFromResultSet(resultSet); // Tìm thấy Post và chuyển thành đối tượng
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return post;// Trả về Post tìm thấy hoặc null
    }
    // Thêm mới Post vào DB
    @Override
    public int insert(Post post) {
        String sql = "INSERT INTO Post (title, thumbnail, postDate, author, content) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);// Lấy ID tự tăng
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getThumbnail_url());
            statement.setDate(3, new java.sql.Date(post.getPublished_at().getTime()));
            statement.setString(4, post.getAuthor());
            statement.setString(5, post.getContent());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();// Lấy ID mới tạo
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId; // Trả về ID mới thêm hoặc -1 nếu lỗi
    }
    // Cập nhật Post trong DB
    @Override
    public boolean update(Post post) {
        String sql = "UPDATE Post SET title = ?, thumbnail = ?, postDate = ?, author = ?, content = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getThumbnail_url());
            statement.setDate(3, new java.sql.Date(post.getPublished_at().getTime()));
            statement.setString(4, post.getAuthor());
            statement.setString(5, post.getContent());
            statement.setInt(6, post.getId());

            int rowsAffected = statement.executeUpdate();// Số dòng bị ảnh hưởng
            success = rowsAffected > 0; // Nếu > 0 tức là update thành công
        } catch (SQLException e) {
            System.out.println("Error update at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }
    // Xóa Post bằng đối tượng
    @Override
    public boolean delete(Post post) {
        if (post == null || post.getId() == null) {
            return false;// Nếu post null hoặc chưa có ID thì không xóa
        }
        return deleteById(post.getId());// Gọi hàm xóa theo ID
    }
    // Xóa Post theo ID
    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Post WHERE id = ?";
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
    // Chuyển từ ResultSet sang đối tượng Post
    @Override
    public Post getFromResultSet(ResultSet resultSet) throws SQLException {
        return Post.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbnail"))
                .published_at(resultSet.getDate("published_at"))
                .author(resultSet.getString("author"))
                .content(resultSet.getString("content"))
                .build();
    }
    // Lấy 5 Post mới nhất (hot)
    public List<Post> getHotPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM Posts ORDER BY created_at DESC LIMIT 5";// Lấy top 5 bài mới nhất
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
}
