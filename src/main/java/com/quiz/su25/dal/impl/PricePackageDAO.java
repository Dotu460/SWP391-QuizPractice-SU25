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
                .name(resultSet.getString("name"))
                .list_price(resultSet.getDouble("list_price"))
                .sale_price(resultSet.getDouble("sale_price"))
                .description(resultSet.getString("description"))
                .status(resultSet.getString("status"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .access_duration_month(resultSet.getInt("access_duration_month"))
                .build();
    }

    @Override
    // Lấy thông tin từ database
    public PricePackage findById(Integer id) {
        //Câu lệnh lấy dữ liệu
        String sql = "SELECT * FROM pricePackage WHERE id = ?";
        try {
            // tạo 1 bảng trắng
            connection = getConnection();
            // viết thông tin câu lệnh lênh bảng trắng đó
            statement = connection.prepareStatement(sql);
            // Lấy id muốn lấy
            statement.setInt(1, id);
            // thực hiện câu lệnh lấy kết quả
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

    
}
