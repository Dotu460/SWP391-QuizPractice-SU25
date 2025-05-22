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

public class PostDAO {
    public List<Post> getHotPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM Post ORDER BY postDate DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(Post.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .thumbnail(rs.getString("thumbnail"))
                        .postDate(rs.getDate("postDate"))
                        .build());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
