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
import java.sql.Date;

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
            statement.setDouble(3, t.getList_price());
            statement.setDouble(4, t.getSale_price());
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
            statement.setDouble(3, t.getList_price());
            statement.setDouble(4, t.getSale_price());
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
        String sql = "DELETE FROM pricePackage WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());

            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class PricePackageDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
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
                .name(resultSet.getString("name"))
                .access_duration_months(resultSet.getInt("access_duration_months"))
                .status(resultSet.getString("status"))
                .list_price(resultSet.getDouble("list_price"))
                .sale_price(resultSet.getDouble("sale_price"))
                .description(resultSet.getString("description"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_at(resultSet.getDate("created_at"))
                .build();
        return pricePackage;
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

    /**
     * Find price packages with filters and pagination
     */
    public List<PricePackage> findPricePackagesWithFilters(String statusFilter, String searchFilter,
                                                           String minPriceFilter, String maxPriceFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM pricePackage WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add filters
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            parameters.add(statusFilter.trim());
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (minPriceFilter != null && !minPriceFilter.trim().isEmpty()) {
            try {
                int minPrice = Integer.parseInt(minPriceFilter.trim());
                sql.append(" AND sale_price >= ?");
                parameters.add(minPrice);
            } catch (NumberFormatException e) {
                // Ignore invalid price
            }
        }

        if (maxPriceFilter != null && !maxPriceFilter.trim().isEmpty()) {
            try {
                int maxPrice = Integer.parseInt(maxPriceFilter.trim());
                sql.append(" AND sale_price <= ?");
                parameters.add(maxPrice);
            } catch (NumberFormatException e) {
                // Ignore invalid price
            }
        }

        // Add pagination
        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        List<PricePackage> listPricePackage = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PricePackage pricePackage = getFromResultSet(resultSet);
                listPricePackage.add(pricePackage);
            }
        } catch (Exception e) {
            System.out.println("Error findPricePackagesWithFilters at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listPricePackage;
    }

    /**
     * Get total count of filtered price packages
     */
    public int getTotalFilteredPricePackages(String statusFilter, String searchFilter,
                                             String minPriceFilter, String maxPriceFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM pricePackage WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add filters
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            parameters.add(statusFilter.trim());
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (minPriceFilter != null && !minPriceFilter.trim().isEmpty()) {
            try {
                int minPrice = Integer.parseInt(minPriceFilter.trim());
                sql.append(" AND sale_price >= ?");
                parameters.add(minPrice);
            } catch (NumberFormatException e) {
                // Ignore invalid price
            }
        }

        if (maxPriceFilter != null && !maxPriceFilter.trim().isEmpty()) {
            try {
                int maxPrice = Integer.parseInt(maxPriceFilter.trim());
                sql.append(" AND sale_price <= ?");
                parameters.add(maxPrice);
            } catch (NumberFormatException e) {
                // Ignore invalid price
            }
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error getTotalFilteredPricePackages at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

}