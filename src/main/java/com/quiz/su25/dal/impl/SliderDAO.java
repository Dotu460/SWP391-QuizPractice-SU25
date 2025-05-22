/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.entity.Slider;
import com.quiz.su25.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO {

    public List<Slider> getAllSliders() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT id, title, image, backlink FROM Slider";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Slider slider = Slider.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .image(rs.getString("image"))
                        .backlink(rs.getString("backlink"))
                        .build();
                list.add(slider);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}