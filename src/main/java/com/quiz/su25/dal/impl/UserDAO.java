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
import com.quiz.su25.utils.PasswordHasher;
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
            statement.setString(3, user.getPassword());
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
        } catch (Exception e) {
            System.out.println("Error hashing password: " + e.getMessage());
            e.printStackTrace();
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
            statement.setInt(7, user.getRole_id() != null ? user.getRole_id() : 2);
            statement.setString(8, user.getStatus() != null ? user.getStatus() : "active");
            statement.setInt(9, user.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class UserDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error hashing password in update: " + e.getMessage());
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
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = User.builder()
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
                
                // Verify password using PasswordHasher
                if (PasswordHasher.verifyPassword(password, user.getPassword())) {
                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        RoleDAO roleDAO = new RoleDAO();

        // 1. First check what roles exist in the database
        System.out.println("=== Checking Available Roles ===");
        var roles = roleDAO.findAll();
        if (roles.isEmpty()) {
            System.out.println("No roles found in database!");
        } else {
            System.out.println("Available roles:");
            roles.forEach(role -> 
                System.out.println("Role ID: " + role.getId() + 
                                 ", Name: " + role.getName() )
            );
        }

        // 2. Try to create a user with role_id = 2 (should be Regular User)
        System.out.println("\n=== Testing User Creation with role_id = 2 ===");
        User testUser = User.builder()
                .full_name("Test User")
                .email("test" + System.currentTimeMillis() + "@example.com") // Unique email
                .password("password123")
                .gender(1)
                .mobile("1234567890")
                .avatar_url(null)
                .role_id(2)  // Try with role_id = 2
                .status("active")
                .build();

        try {
            int userId = userDAO.insert(testUser);
            if (userId > 0) {
                System.out.println("Successfully created user with role_id = 2");
                System.out.println("New user ID: " + userId);
                
                // Verify the user was created correctly
                User createdUser = userDAO.findById(userId);
                if (createdUser != null) {
                    System.out.println("Verified user details:");
                    System.out.println("ID: " + createdUser.getId());
                    System.out.println("Name: " + createdUser.getFull_name());
                    System.out.println("Email: " + createdUser.getEmail());
                    System.out.println("Role ID: " + createdUser.getRole_id());
                }
            } else {
                System.out.println("Failed to create user with role_id = 2");
            }
        } catch (Exception e) {
            System.out.println("Error creating user: " + e.getMessage());
            e.printStackTrace();
        }

        // 3. Try to create a user with an invalid role_id
        System.out.println("\n=== Testing User Creation with invalid role_id = 999 ===");
        User invalidUser = User.builder()
                .full_name("Invalid Role User")
                .email("invalid" + System.currentTimeMillis() + "@example.com")
                .password("password123")
                .gender(1)
                .mobile("1234567890")
                .avatar_url(null)
                .role_id(999)  // Try with invalid role_id
                .status("active")
                .build();

        try {
            int userId = userDAO.insert(invalidUser);
            if (userId > 0) {
                System.out.println("WARNING: Successfully created user with invalid role_id = 999");
            } else {
                System.out.println("Expected failure: Could not create user with invalid role_id = 999");
            }
        } catch (Exception e) {
            System.out.println("Expected error creating user with invalid role: " + e.getMessage());
        }
    }

    public User findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = getFromResultSet(resultSet);
                // Verify password using PasswordHasher
                if (PasswordHasher.verifyPassword(password, user.getPassword())) {
                    return user;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error findByEmailAndPassword at class UserDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error verifying password in findByEmailAndPassword: " + e.getMessage());
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
            statement.setString(1, PasswordHasher.hashPassword(newPassword));
            statement.setString(2, email);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error hashing password in updatePassword: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public List<User> getPaginatedUsers(int page, int pageSize, String genderFilter, String roleFilter,
                                        String statusFilter, String searchTerm, String sortBy, String sortOrder) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");

        // Add filters
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append(" AND gender = ?");
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND role_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR mobile LIKE ?)");
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY id ASC"); // Default sorting
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (genderFilter != null && !genderFilter.isEmpty()) {
                statement.setString(paramIndex++, genderFilter);
            }

            if (roleFilter != null && !roleFilter.isEmpty()) {
                statement.setString(paramIndex++, roleFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }

            // Set pagination parameters
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in getPaginatedUsers: " + e.getMessage());
        } finally {
            closeResources();
        }

        return users;
    }

    public int countTotalUsers(String genderFilter, String roleFilter, String statusFilter, String searchTerm) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");

        // Add filters
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append(" AND gender = ?");
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND role_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR mobile LIKE ?)");
        }

        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (genderFilter != null && !genderFilter.isEmpty()) {
                statement.setString(paramIndex++, genderFilter);
            }

            if (roleFilter != null && !roleFilter.isEmpty()) {
                statement.setString(paramIndex++, roleFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countTotalUsers: " + e.getMessage());
        } finally {
            closeResources();
        }

        return count;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by email: " + e.getMessage());
        }
        return null;
    }

}
