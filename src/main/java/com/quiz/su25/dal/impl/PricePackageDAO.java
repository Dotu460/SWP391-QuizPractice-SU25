/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.PricePackage;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class PricePackageDAO extends DBContext implements I_DAO<PricePackage>{

    @Override
    public List<PricePackage> findAll() {
        String sql = "select * from pricePackage";
        List<PricePackage> listPricePackage = new ArrayList<>();
        try {
            //tao connection
            connection = getConnection();
            //chuan bi cho statement
            statement = connection.prepareStatement(sql);
            //set param
            
            //thuc thi cau lenh
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                PricePackage pricePackage = getFromResultSet(resultSet);
                listPricePackage.add(pricePackage);
            }                      
        } catch (Exception e) {
            System.out.println("Error findAll at class PricePackageDAO: " + e.getMessage());
        } finally{
            closeResources();
        }
        return listPricePackage;
    }

    @Override
    public boolean update(PricePackage t) {
        String sql = "UPDATE pricePackage SET name=?, access_duration_months=?, list_price=?, sale_price=?, status=?, description=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getAccess_duration_months());
            statement.setInt(3, t.getList_price());
            statement.setInt(4, t.getSale_price());
            statement.setString(5, t.getStatus());
            statement.setString(6, t.getDescription());
            statement.setInt(7, t.getId());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error update at class PricePackageDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean create(PricePackage t) {
        String sql = "INSERT INTO pricePackage (name, access_duration_months, list_price, sale_price, status, description) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getName());
            statement.setInt(2, t.getAccess_duration_months());
            statement.setInt(3, t.getList_price());
            statement.setInt(4, t.getSale_price());
            statement.setString(5, t.getStatus());
            statement.setString(6, t.getDescription());
            
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error create at class PricePackageDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(PricePackage t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(PricePackage t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public PricePackage getFromResultSet(ResultSet resultSet) throws SQLException {
        PricePackage pricePackage = PricePackage
                .builder()
                .id(resultSet.getInt("id"))
                .subject_id(resultSet.getInt("subject_id"))
                .name(resultSet.getString("name"))
                .access_duration_months(resultSet.getInt("access_duration_months"))
                .status(resultSet.getString("status"))
                .list_price(resultSet.getInt("list_price"))
                .sale_price(resultSet.getInt("sale_price"))
                .description(resultSet.getString("description"))
                .build();
        return pricePackage;
    }

    @Override
    public PricePackage findById(Integer id) {
        String sql = "SELECT * FROM pricePackage WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    public static void main(String[] args) {
        PricePackageDAO pricePackageDAO = new PricePackageDAO();
        pricePackageDAO.findAll().forEach(item -> {
            System.out.println(item);
        });
    }
    
}
