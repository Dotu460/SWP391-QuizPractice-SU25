/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.entity.Slider;
import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO extends DBContext implements I_DAO<Slider> {
   // Lấy toàn bộ danh sách Slider từ database
    @Override
    public List<Slider> findAll() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT id, title, image_url, backlink_url, status FROM Sliders";
        try {
            connection = getConnection();// Kết nối DB
            statement = connection.prepareStatement(sql); // Chuẩn bị câu SQL
            resultSet = statement.executeQuery();// Thực thi câu SQL
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));// Lấy Slider từ ResultSet
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SliderDAO: " + e.getMessage());// In lỗi nếu có
        } finally {
            closeResources();// Đóng tài nguyên (kết nối, statement, resultset)
        }
        return list;// Trả về danh sách Slider
    }
    // Tìm Slider theo ID
    @Override
    public Slider findById(Integer id) {
        String sql = "SELECT id, title, image, backlink, status FROM Slider WHERE id = ?";
        Slider slider = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);// Gán giá trị id vào câu SQL
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                slider = getFromResultSet(resultSet);// Nếu có kết quả thì trả về Slider
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return slider;// Trả về Slider hoặc null
    }
    // Thêm mới Slider vào DB
    @Override
    public int insert(Slider slider) {
        String sql = "INSERT INTO Sliders (title, image_url, backlink_url, status) VALUES ('Slider Title', 'http://example.com/image.jpg', 'http://example.com', 1)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // Lấy ID sinh tự động
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getThumbnail_url());
            statement.setString(3, slider.getBacklink_url());
            statement.setString(4, slider.getStatus());

            statement.executeUpdate();// Thực thi insert
            resultSet = statement.getGeneratedKeys();// Lấy ID vừa tạo
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;// Trả về ID của Slider mới insert hoặc -1 nếu lỗi
    }
    // Cập nhật Slider
    @Override
    public boolean update(Slider slider) {
        String sql = "UPDATE Sliders SET title = 'New Title', image_url = 'http://example.com/newimage.jpg', backlink_url = 'http://example.com/newlink', status = 1 WHERE id = 5;";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getThumbnail_url());
            statement.setString(3, slider.getBacklink_url());
            statement.setString(4, slider.getStatus());
            statement.setInt(5, slider.getId());

            int rowsAffected = statement.executeUpdate();// Số dòng bị ảnh hưởng
            success = rowsAffected > 0;// Nếu có dòng bị ảnh hưởng thì update thành công
        } catch (SQLException e) {
            System.out.println("Error update at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;// Trả về true nếu update thành công
    }
    // Xoá Slider (theo object Slider)
    @Override
    public boolean delete(Slider slider) {
        if (slider == null || slider.getId() == null) {
            return false;// Nếu slider null hoặc không có id thì không xoá
        }
        return deleteById(slider.getId());// Xoá theo id
    }
    // Xoá Slider theo id
    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Sliders WHERE id = 5;";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);// Gán id vào câu SQL

            int rowsAffected = statement.executeUpdate();// Số dòng bị xoá
            success = rowsAffected > 0;// Nếu có dòng bị xoá thì xoá thành công
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SliderDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;// Trả về true nếu xoá thành công
    }
   // Chuyển từ ResultSet sang object Slider
    @Override
    public Slider getFromResultSet(ResultSet resultSet) throws SQLException {
        return Slider.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbanil"))
                .backlink_url(resultSet.getString("backlink"))
                .status(resultSet.getString("status"))
                .build(); // Tạo Slider từ ResultSet
    }
}