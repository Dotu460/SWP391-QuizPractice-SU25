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
import com.quiz.su25.dal.I_DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO extends DBContext implements I_DAO<Slider> {

    @Override
    public List<Slider> findAll() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT id, title, image, backlink, status FROM Slider";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Slider findById(Integer id) {
        String sql = "SELECT id, title, image, backlink, status FROM Slider WHERE id = ?";
        Slider slider = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                slider = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return slider;
    }

    @Override
    public int insert(Slider slider) {
        String sql = "INSERT INTO Slider (title, image, backlink, status) VALUES (?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImage());
            statement.setString(3, slider.getBacklink());
            statement.setBoolean(4, slider.getStatus());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Slider slider) {
        String sql = "UPDATE Slider SET title = ?, image = ?, backlink = ?, status = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImage());
            statement.setString(3, slider.getBacklink());
            statement.setBoolean(4, slider.getStatus());
            statement.setInt(5, slider.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Slider slider) {
        if (slider == null || slider.getId() == null) {
            return false;
        }
        return deleteById(slider.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Slider WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Slider getFromResultSet(ResultSet resultSet) throws SQLException {
        return Slider.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .image(resultSet.getString("image"))
                .backlink(resultSet.getString("backlink"))
                .status(resultSet.getBoolean("status"))
                .build();
    }
}