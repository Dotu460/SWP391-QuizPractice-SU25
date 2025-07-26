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
        String sql = "SELECT id, title, image, backlink, status FROM slider";
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
        String sql = "SELECT id, title, image_url, backlink_url, status, notes FROM slider WHERE id = ?";
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
        String sql = "INSERT INTO slider (title, image_url, backlink_url, status, notes) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImage_url());
            statement.setString(3, slider.getBacklink_url());
            statement.setBoolean(4, slider.getStatus());
            statement.setString(5, slider.getNotes());

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
        String sql = "UPDATE slider SET title = ?, image_url = ?, backlink_url = ?, status = ?, notes = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImage_url());
            statement.setString(3, slider.getBacklink_url());
            statement.setBoolean(4, slider.getStatus());
            statement.setString(5, slider.getNotes());
            statement.setInt(6, slider.getId());

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
        String sql = "DELETE FROM slider WHERE id = ?";
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
                .image_url(resultSet.getString("image_url"))
                .backlink_url(resultSet.getString("backlink_url"))
                .status(resultSet.getBoolean("status"))
                .notes(resultSet.getString("notes"))
                .build();
    }

    public List<Slider> getActiveSliders() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT * FROM slider WHERE status = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveSliders at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Slider> findSlidersWithFilters(String status, String search, int page, int pageSize) {
        List<Slider> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM slider WHERE 1=1");
        
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (title LIKE ?)");
        }
        
        sql.append(" ORDER BY id ASC LIMIT ? OFFSET ?");
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                statement.setBoolean(paramIndex++, "active".equalsIgnoreCase(status));
            }
            if (search != null && !search.isEmpty()) {
                statement.setString(paramIndex++, "%" + search + "%");
            }
            
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findSlidersWithFilters at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public int getTotalFilteredSliders(String status, String search) {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM slider WHERE 1=1");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (title LIKE ?)");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                statement.setBoolean(paramIndex++, "active".equalsIgnoreCase(status));
            }
            if (search != null && !search.isEmpty()) {
                statement.setString(paramIndex++, "%" + search + "%");
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                total = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalFilteredSliders at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return total;
    }
}