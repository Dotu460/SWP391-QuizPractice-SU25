/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Subject;

/**
 *
 * @author FPT
 */
public class SubjectDAO extends DBContext implements I_DAO<Subject>{

    @Override
    public List<Subject> findAll() {
        String sql = "SELECT id, title, thumbnail_url, brief_info, description, category_id, status FROM subject";
        List<Subject> listSubject = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Subject subject = getFromResultSet(resultSet);
                listSubject.add(subject);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listSubject;
    }

    @Override
    public boolean update(Subject t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Subject t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Subject t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Subject getFromResultSet(ResultSet resultSet) throws SQLException {
        return Subject.builder()
        .id(resultSet.getInt("id"))
        .title(resultSet.getString("title"))
        .thumbnail_url(resultSet.getString("thumbnail_url"))
        .description(resultSet.getString("description"))
        .subjectcategories_id(resultSet.getInt("category_id"))
        .brief_info(resultSet.getString("brief_info"))
        .status(resultSet.getString("status"))
//        .created_at(resultSet.getDate("created_at"))
//        .updated_at(resultSet.getDate("updated_at"))
        .build();
    }

    @Override
    public Subject findById(Integer id) {
        String sql = "SELECT * FROM subject WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        finally {
            closeResources();
        }
        return null;
    }


    public static void main(String[] args) {
        SubjectDAO subjectDAO = new SubjectDAO();
        System.out.println(subjectDAO.findById(2));
    }
    
}
