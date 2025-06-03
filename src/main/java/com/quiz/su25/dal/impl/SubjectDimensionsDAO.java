/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.SubjectDimensions;
import com.quiz.su25.entity.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class SubjectDimensionsDAO extends DBContext implements I_DAO<SubjectDimensions>{

    @Override
    public List<SubjectDimensions> findAll() {
        String sql = "select * from subject";
        List<SubjectDimensions> listSubjectDimensions = new ArrayList<>();
        try {
            //tao connection
            connection = getConnection();
            //chuan bi cho statement
            statement = connection.prepareStatement(sql);
            //set param
            
            //thuc thi cau lenh
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                SubjectDimensions subjectDimensions = getFromResultSet(resultSet);
                listSubjectDimensions.add(subjectDimensions);
            }                      
        } catch (Exception e) {
            System.out.println("Error findAll at class SubjectDimensionsDAO: " + e.getMessage());
        } finally{
            closeResources();
        }
        return listSubjectDimensions;
    }

    @Override
    public boolean update(SubjectDimensions t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(SubjectDimensions t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(SubjectDimensions t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public SubjectDimensions getFromResultSet(ResultSet resultSet) throws SQLException {
        SubjectDimensions subjectDimensions = SubjectDimensions
                .builder()
                .id(resultSet.getInt("id"))
                .subject_id("subject_id")
                .type("type")
                .name("name")
                .description("description")
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .build();
        return subjectDimensions;    
    }

    @Override
    public SubjectDimensions findById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public static void main(String[] args) {
        SubjectDimensionsDAO subjectDimensionsDAO = new SubjectDimensionsDAO();
        subjectDimensionsDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
}
