/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author FPT
 */
public class RoleDAO extends DBContext implements I_DAO<Role> {

    @Override
    public List<Role> findAll() {
        String sql = "SELECT id, name FROM role";
        List<Role> listRole = new ArrayList<>();
        try {
            //tao connection
            connection = getConnection();
            //chuan bi cho statmenet
            statement = connection.prepareStatement(sql);
            //set parameter (optional)

            //thuc thi cau lenh
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Role role = getFromResultSet(resultSet);
                listRole.add(role);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRole;
    }

    @Override
    public boolean update(Role t) {
        String sql = "UPDATE role SET name = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getId());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }


    @Override
    public boolean delete(Role t) {
        String sql = "DELETE FROM role WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error delete at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;   
    }

    @Override
    public int insert(Role t) {
        String sql = "INSERT INTO role (name) VALUES (?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected;
        } catch (SQLException e) {
            System.out.println("Error insert at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public Role getFromResultSet(ResultSet resultSet) throws SQLException {
        Role role = Role
                .builder()
                .id(resultSet.getInt("id"))
                .name(resultSet.getString("name"))
                .build();
        return role;
    }

    @Override
    public Role findById(Integer id) {
        String sql = "SELECT id, name FROM role WHERE id = ?";
        Role role = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                role = new Role();
                role.setId(resultSet.getInt("id"));
                role.setName(resultSet.getString("name"));
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return role;
    }

    public String getRoleNameById(Integer roleId) {
        Role role = findById(roleId);
        return role != null ? role.getName() : "Unknown";
    }

//    @Override
    public Map<Integer, Role> findAllMap() {
        String sql = "Select * from role";
        Map<Integer, Role> mapRole = new HashMap<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Role role = getFromResultSet(resultSet);
                mapRole.put(role.getId(), role);
            }
        } catch (SQLException e) {
            System.out.println("Error findAllMap at class RoleDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return mapRole;
    }

    public static void main(String[] args) {
        RoleDAO roleDAO = new RoleDAO();
        Map<Integer, Role> mapRole = roleDAO.findAllMap();
        for (Map.Entry<Integer, Role> entry : mapRole.entrySet()) {
            System.out.println(entry.getKey() + " - " + entry.getValue());
        }
    }

}
