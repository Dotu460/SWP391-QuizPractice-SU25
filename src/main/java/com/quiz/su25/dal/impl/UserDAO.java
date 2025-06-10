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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext implements I_DAO<User> {

    @Override
    public List<User> findAll() {
        String sql = "SELECT "
                + "id, full_name, email, password, gender, mobile, avatar_url, role_id, status"
                + " FROM users"; // Giả sử tên bảng là User
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
        String sql = "SELECT id, full_name, email, password, gender, mobile, avatar_url, role_id, status FROM users WHERE id = ?";
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
        String sql = "INSERT INTO users "
                + "(full_name, email, password, gender, mobile, avatar_url, role_id, status)"
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setObject(1, user.getFull_name());     // Can be NULL
            statement.setString(2, user.getEmail());         // NOT NULL
            statement.setString(3, user.getPassword());      // NOT NULL
            statement.setObject(4, user.getGender());        // Can be NULL
            statement.setString(5, user.getMobile());        // NOT NULL
            statement.setObject(6, user.getAvatar_url());    // Can be NULL
            statement.setObject(7, user.getRole_id());       // Can be NULL
            statement.setObject(8, user.getStatus());        // Can be NULL

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class UserDAO: " + e.getMessage());
            e.printStackTrace(); // Print full stack trace for debugging
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users "
                + "SET full_name = ?, email = ?, password = ?"
                + ", gender = ?, mobile = ?, avatar_url = ?"
                + ", role_id = ?, status = ?"
                + ""
                + " WHERE id = ?";
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
        String sql = "DELETE FROM users WHERE id = ?";
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

    public User login(String email, String password) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return User.builder()
                        .id(rs.getInt("id"))
                        .full_name(rs.getString("full_name"))
                        .email(rs.getString("email"))
                        .password(rs.getString("password"))
                        .gender(rs.getInt("gender"))
                        .mobile(rs.getString("mobile"))
                        .avatar_url(rs.getString("avatar_url"))
                        .role_id(rs.getInt("role_id"))
                        .status(rs.getString("status"))
                        .build();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // First, get an existing user
        User existingUser = userDAO.findById(10); // Thay đổi ID này theo ID có trong database của bạn

        if (existingUser != null) {
            System.out.println("Before update:");
            System.out.println("Full name: " + existingUser.getFull_name());
            System.out.println("Mobile: " + existingUser.getMobile());
            System.out.println("Gender: " + existingUser.getGender());

            // Create updated user with some changes
            User updatedUser = User.builder()
                    .id(existingUser.getId())
                    .full_name("Test Update Name")
                    .email(existingUser.getEmail()) // keep existing email
                    .password(existingUser.getPassword()) // keep existing password
                    .gender(1) // change gender
                    .mobile("0987654321") // change mobile
                    .avatar_url(existingUser.getAvatar_url()) // keep existing avatar
                    .role_id(existingUser.getRole_id()) // keep existing role
                    .status(existingUser.getStatus()) // keep existing status
                    .build();

            // Try to update
            boolean success = userDAO.update(updatedUser);
            System.out.println("\nUpdate success: " + success);

            if (success) {
                // Verify the update by getting the user again
                User verifyUser = userDAO.findById(10);
                System.out.println("\nAfter update:");
                System.out.println("Full name: " + verifyUser.getFull_name());
                System.out.println("Mobile: " + verifyUser.getMobile());
                System.out.println("Gender: " + verifyUser.getGender());
            }
        } else {
            System.out.println("User not found!");
        }
    }

    public User findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
            
        } catch (SQLException e) {
            System.out.println("Error findByEmailAndPassword at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Check if an email already exists in the database
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean isEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking if email exists: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Update password for a user with given email
     * @param email User's email
     * @param newPassword New password to set
     * @return true if password was updated successfully, false otherwise
     */
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, newPassword);
            statement.setString(2, email);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

}
