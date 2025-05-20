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

/**
 *
 * @author FPT
 */
public class RoleDAO extends DBContext implements I_DAO<Role> {

    @Override
    public List<Role> findAll() {
        String sql = "select * from role";
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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Role t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Role t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Role getFromResultSet(ResultSet resultSet) throws SQLException {
        Role role = Role
                .builder()
                .id(resultSet.getInt("id"))
                .role_name("role_name")
                .description("description")
                .created_at(resultSet.getDate("created_at"))
                .build();
        return role;
    }

    @Override
    public Role findById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public static void main(String[] args) {
        RoleDAO roleDAO = new RoleDAO();
        roleDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }

}
