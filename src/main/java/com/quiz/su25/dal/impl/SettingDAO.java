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
        String sql = "SELECT id, setting_key, setting_value FROM setting";
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
        String sql = "SELECT id, setting_key, setting_value FROM setting WHERE id = ?";
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
        String sql = "INSERT INTO setting (setting_key, setting_value) VALUES (?, ?)";
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
        String sql = "UPDATE setting SET setting_key = ?, setting_value = ? WHERE id = ?";
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

    /**
     * Find setting by key
     * @param key The setting key to search for
     * @return Setting object if found, null otherwise
     */
    public Setting findByKey(String key) {
        String sql = "SELECT id, setting_key, setting_value FROM setting WHERE setting_key = ?";
        Setting setting = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, key);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                setting = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findByKey at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return setting;
    }

    /**
     * Get value by key
     * @param key The setting key
     * @return The value associated with the key, null if not found
     */
    public String getValueByKey(String key) {
        String sql = "SELECT setting_value FROM setting WHERE setting_key = ?";
        String value = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, key);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                value = resultSet.getString("setting_value");
            }
        } catch (SQLException e) {
            System.out.println("Error getValueByKey at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return value;
    }

    /**
     * Update value by key
     * @param key The setting key
     * @param value The new value
     * @return true if successful, false otherwise
     */
    public boolean updateValueByKey(String key, String value) {
        String sql = "UPDATE setting SET setting_value = ? WHERE setting_key = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, value);
            statement.setString(2, key);
            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updateValueByKey at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    /**
     * Check if key exists
     * @param key The setting key to check
     * @return true if key exists, false otherwise
     */
    public boolean isKeyExist(String key) {
        String sql = "SELECT COUNT(*) FROM setting WHERE setting_key = ?";
        boolean exists = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, key);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                exists = resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error isKeyExist at class SettingDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return exists;
    }

    /**
     * Insert or Update setting (upsert operation)
     * @param key The setting key
     * @param value The setting value
     * @return true if successful, false otherwise
     */
    public boolean upsert(String key, String value) {
        if (isKeyExist(key)) {
            return updateValueByKey(key, value);
        } else {
            Setting setting = Setting.builder()
                    .key(key)
                    .value(value)
                    .build();
            return insert(setting) > 0;
        }
    }

    @Override
    public Setting getFromResultSet(ResultSet resultSet) throws SQLException {
        return Setting.builder()
                .id(resultSet.getInt("id"))
                .key(resultSet.getString("setting_key"))
                .value(resultSet.getString("setting_value"))
                .build();
    }
} 