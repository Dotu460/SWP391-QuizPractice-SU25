/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.SubjectCategories;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPT
 */
public class SubjectCategoriesDAO extends DBContext implements I_DAO<SubjectCategories>{

    @Override
    public List<SubjectCategories> findAll() {
        String sql = "SELECT * FROM SubjectCategories";
        List<SubjectCategories> listSubjectCategories = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                SubjectCategories subjectCategories = getFromResultSet(resultSet);
                listSubjectCategories.add(subjectCategories);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectCategoriesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listSubjectCategories;
    }

    @Override
    public boolean update(SubjectCategories t) {
        String sql = "UPDATE SubjectCategories SET name = ?, description = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setString(2, t.getDescription());
            statement.setInt(3, t.getId());
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error update at class SubjectCategoriesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(SubjectCategories t) {
        String sql = "DELETE FROM SubjectCategories WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error delete at class SubjectCategoriesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(SubjectCategories t) {
        String sql = "INSERT INTO SubjectCategories (name, description) VALUES (?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setString(2, t.getDescription());
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insert at class SubjectCategoriesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override   
    public SubjectCategories getFromResultSet(ResultSet resultSet) throws SQLException {
        SubjectCategories subjectCategories = SubjectCategories
        .builder()
        .id(resultSet.getInt("id"))
        .name("name")
        .description("description")
        .build();
        return subjectCategories;
    }

    @Override
    public SubjectCategories findById(Integer id) {
        String sql = "SELECT * FROM SubjectCategories WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            return getFromResultSet(resultSet);
        } catch (SQLException e) {
            System.out.println("Error findById at class SubjectCategoriesDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
}
