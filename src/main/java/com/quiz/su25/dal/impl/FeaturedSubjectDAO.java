/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.entity.FeaturedSubject;
import java.sql.*;
import java.util.*;
import com.quiz.su25.dal.DBContext;
import com.quiz.su25.entity.FeaturedSubject;

public class FeaturedSubjectDAO {
    public List<FeaturedSubject> getFeaturedSubjects() {
        List<FeaturedSubject> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM Subject";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(FeaturedSubject.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .thumbnail(rs.getString("thumbnail"))
                        .tagline(rs.getString("tagline"))
                        .build());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

