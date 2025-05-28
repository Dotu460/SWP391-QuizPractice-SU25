/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Subject;

/**
 *
 * @author FPT
 */
public class SubjectDAO extends DBContext implements I_DAO<Subject> {

    @Override
    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM Subject";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Subject findById(Integer id) {
        String sql = "SELECT * FROM Subject WHERE id = ?";
        Subject subject = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                subject = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return subject;
    }

    @Override
    public int insert(Subject subject) {
        String sql = "INSERT INTO Subject (title, thumbnail_url, tag_line, description, featured, subjectcategories_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getDescription());
            statement.setBoolean(5, subject.getFeatured());
            statement.setInt(6, subject.getSubjectcategories_id());
            statement.setString(7, subject.getStatus());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Subject subject) {
        String sql = "UPDATE Subject SET title = ?, thumbnail_url = ?, tag_line = ?, description = ?, featured = ?, subjectcategories_id = ?, status = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getDescription());
            statement.setBoolean(5, subject.getFeatured());
            statement.setInt(6, subject.getSubjectcategories_id());
            statement.setString(7, subject.getStatus());
            statement.setInt(8, subject.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Subject subject) {
        if (subject == null || subject.getId() == null) {
            return false;
        }
        return deleteById(subject.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Subject WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Subject getFromResultSet(ResultSet resultSet) throws SQLException {
        return Subject.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbnail_url"))
                .tag_line(resultSet.getString("tag_line"))
                .description(resultSet.getString("description"))
                .featured(resultSet.getBoolean("featured"))
                .subjectcategories_id(resultSet.getInt("subjectcategories_id"))
                .status(resultSet.getString("status"))
                .build();
    }
   //Lấy danh sách các môn học được đánh dấu là nổi bật (featured_flag = true) từ dtb
    public List<Subject> getFeaturedSubjects() {// Tạo danh sách trống để chứa các môn học nổi bật
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE featured_flag = true";
        try {
            connection = getConnection(); // Mở kết nối đến dtb
            statement = connection.prepareStatement(sql);// Chuẩn bị câu lệnh SQL để thực thi
            resultSet = statement.executeQuery(); // Thực thi câu lệnh và lưu kết quả vào resultSet
            while (resultSet.next()) {// Duyệt qua từng bản ghi trong resultSet
                list.add(getFromResultSet(resultSet));// Chuyển đổi mỗi bản ghi thành một đối tượng Subject và thêm vào danh sách
            }
        } catch (SQLException e) {// Ghi ra thông báo lỗi nếu có lỗi xảy ra khi truy vấn cơ sở dữ liệu
            System.out.println("Error getFeaturedSubjects at class SubjectDAO: " + e.getMessage());
        } finally {// Đóng các tài nguyên (kết nối, statement, resultSet) để tránh rò rỉ bộ nhớ
            closeResources();
        }
        return list;// Trả về danh sách các môn học nổi bật
    }
}
