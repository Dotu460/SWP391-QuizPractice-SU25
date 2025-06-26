package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Setting;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SettingDAO extends DBContext implements I_DAO<Setting> {

    @Override
    public List<Setting> findAll() {
        List<Setting> list = new ArrayList<>();
        String sql = "SELECT id, `key`, `value` FROM setting";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Setting findById(Integer id) {
        String sql = "SELECT id, `key`, `value` FROM setting WHERE id = ?";
        Setting setting = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                setting = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return setting;
    }

    @Override
    public int insert(Setting setting) {
        String sql = "INSERT INTO setting (`key`, `value`) VALUES (?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, setting.getKey());
            statement.setString(2, setting.getValue());
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Setting setting) {
        String sql = "UPDATE setting SET `key` = ?, `value` = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, setting.getKey());
            statement.setString(2, setting.getValue());
            statement.setInt(3, setting.getId());
            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Setting setting) {
        if (setting == null || setting.getId() == null) {
            return false;
        }
        return deleteById(setting.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM setting WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Setting getFromResultSet(ResultSet resultSet) throws SQLException {
        return Setting.builder()
                .id(resultSet.getInt("id"))
                .key(resultSet.getString("key"))
                .value(resultSet.getString("value"))
                .build();
    }
} 