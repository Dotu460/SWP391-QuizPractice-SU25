/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.quiz.su25.dal.impl;

/**
 *
 * @author FPT
 */

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext implements I_DAO<User> {

    @Override
    public List<User> findAll() {
        String sql = "SELECT id, full_name, email, password, gender, mobile, avatar_url, role_id, status FROM [User]"; // Giả sử tên bảng là User
        List<User> listUser = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = getFromResultSet(resultSet);
                listUser.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listUser;
    }

    @Override
    public User findById(Integer id) {
        String sql = "SELECT id, full_name, email, password, gender, mobile, avatar_url, role_id, status FROM [User] WHERE id = ?";
        User user = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return user;
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO [User] (full_name, email, password, gender, mobile, avatar_url, role_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getFull_name());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setInt(4, user.getGender());
            statement.setString(5, user.getMobile());
            statement.setString(6, user.getAvatar_url());
            statement.setInt(7, user.getRole_id());
            statement.setString(8, user.getStatus());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE [User] SET full_name = ?, email = ?, password = ?, gender = ?, mobile = ?, avatar_url = ?, role_id = ?, status = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getFull_name());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setInt(4, user.getGender());
            statement.setString(5, user.getMobile());
            statement.setString(6, user.getAvatar_url());
            statement.setInt(7, user.getRole_id());
            statement.setString(8, user.getStatus());
            statement.setInt(9, user.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(User user) {
         if (user == null || user.getId() == null) {
            return false;
        }
        return deleteById(user.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM [User] WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }


    @Override
    public User getFromResultSet(ResultSet resultSet) throws SQLException {
        return User.builder()
                .id(resultSet.getInt("id"))
                .full_name(resultSet.getString("full_name"))
                .email(resultSet.getString("email"))
                .password(resultSet.getString("password"))
                .gender(resultSet.getInt("gender"))
                .mobile(resultSet.getString("mobile"))
                .avatar_url(resultSet.getString("avatar_url"))
                .role_id(resultSet.getInt("role_id"))
                .status(resultSet.getString("status"))
                .build();
    }

    // Phương thức main để test (tùy chọn)
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // Test findAll
        System.out.println("Testing findAll():");
        List<User> users = userDAO.findAll();
        if (users.isEmpty()) {
            System.out.println("No users found.");
        } else {
            users.forEach(System.out::println);
        }
        System.out.println("--------------------");

        // Test findById
        System.out.println("Testing findById(1):"); // Thay đổi ID nếu cần
        User userById = userDAO.findById(1);
        if (userById != null) {
            System.out.println(userById);
        } else {
            System.out.println("User with id 1 not found.");
        }
        System.out.println("--------------------");

        // Lưu ý: Các thao tác insert, update, delete sẽ thay đổi dữ liệu trong DB.
        // Cần cẩn thận khi chạy các phần test này.

        // Test insert
        // System.out.println("Testing insert():");
        // User newUser = User.builder()
        //         .full_name("New User Test")
        //         .email("newusertest@example.com")
        //         .password("password123")
        //         .gender(1)
        //         .mobile("0123456789")
        //         .avatar_url("avatar.png")
        //         .role_id(2) // Giả sử role_id = 2 là user thường
        //         .status("active")
        //         .build();
        // int newUserId = userDAO.insert(newUser);
        // if (newUserId != -1) {
        //     System.out.println("Inserted new user with id: " + newUserId);
        //     newUser.setId(newUserId); // Gán ID cho đối tượng newUser
        //     System.out.println(newUser);

            // Test update
            // System.out.println("Testing update():");
            // newUser.setFull_name("Updated User Test Name");
            // newUser.setStatus("inactive");
            // boolean updateSuccess = userDAO.update(newUser);
            // if (updateSuccess) {
            //     System.out.println("User updated successfully: " + userDAO.findById(newUserId));
            // } else {
            //     System.out.println("User update failed.");
            // }
            // System.out.println("--------------------");

            // Test delete
            // System.out.println("Testing delete():");
            // boolean deleteSuccess = userDAO.deleteById(newUserId);
            // if (deleteSuccess) {
            //     System.out.println("User with id " + newUserId + " deleted successfully.");
            //     System.out.println("User after delete: " + userDAO.findById(newUserId));
            // } else {
            //     System.out.println("User delete failed.");
            // }
        // } else {
        //     System.out.println("User insert failed.");
        // }
        // System.out.println("--------------------");
    }
}

