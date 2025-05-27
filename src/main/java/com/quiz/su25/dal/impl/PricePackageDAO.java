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
import java.util.List;

/**
 *
 * @author FPT
 */
public class PricePackageDAO extends DBContext implements I_DAO<PricePackage> {

    @Override
    public List<PricePackage> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(PricePackage t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
        return PricePackage.builder()
                .id(resultSet.getInt("subject_id"))
                .list_price(resultSet.getDouble("list_price"))
                .sale_price(resultSet.getDouble("sale_price"))
                .description(resultSet.getString("description"))
                .status(resultSet.getString("status"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .build();
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        finally {
            closeResources();
        }
        return null;
    }

    public static void main(String[] args) {
        PricePackageDAO pricePackageDAO = new PricePackageDAO();
        PricePackage pricePackage = pricePackageDAO.findById(1);
        System.out.println(pricePackage);
    }
    
}
