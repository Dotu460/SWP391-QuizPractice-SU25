package com.quiz.su25.entity.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext implements I_DAO<User> {

    @Override
    public List<User> findAll() {
        String sql = "SELECT u.*, r.role_name, r.description, r.created_at FROM users u LEFT JOIN role r ON u.role_id = r.id";
        List<User> userList = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = getFromResultSet(resultSet);
                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return userList;
    }

    @Override
    public User findById(Integer id) {
        String sql = "SELECT u.*, r.role_name, r.description, r.created_at FROM users u LEFT JOIN role r ON u.role_id = r.id WHERE u.user_id = ?";
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
        String sql = "INSERT INTO users (full_name, email, password_hash, gender, mobile, avatar_url, role_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getFull_name());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword_hash());
            statement.setBoolean(4, user.isGender());
            statement.setString(5, user.getMobile());
            statement.setString(6, user.getAvatar_url());
            statement.setInt(7, user.getRole().getId());
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
        String sql = "UPDATE users SET full_name = ?, email = ?, password_hash = ?, gender = ?, mobile = ?, avatar_url = ?, role_id = ?, status = ? WHERE user_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getFull_name());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword_hash());
            statement.setBoolean(4, user.isGender());
            statement.setString(5, user.getMobile());
            statement.setString(6, user.getAvatar_url());
            statement.setInt(7, user.getRole().getId());
            statement.setString(8, user.getStatus());
            statement.setInt(9, user.getUser_id());

            success = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(User user) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, user.getUser_id());
            success = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error delete at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public User getFromResultSet(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUser_id(resultSet.getInt("user_id"));
        user.setFull_name(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPassword_hash(resultSet.getString("password_hash"));
        user.setGender(resultSet.getBoolean("gender"));
        user.setMobile(resultSet.getString("mobile"));
        user.setAvatar_url(resultSet.getString("avatar_url"));
        user.setStatus(resultSet.getString("status"));

        // Handle Role relationship
        Role role = new Role();
        role.setId(resultSet.getInt("role_id"));

        try {
            role.setRole_name(resultSet.getString("role_name"));
            role.setDescription(resultSet.getString("description"));
            role.setCreated_at(resultSet.getDate("created_at"));
        } catch (SQLException e) {
            // Role data might be null
        }

        user.setRole(role);
        return user;
    }

    // Method for paginated user list with filtering, searching and sorting
    public List<User> getPaginatedUsers(int page, int pageSize,
                                        String genderFilter, String roleFilter, String statusFilter,
                                        String searchTerm, String sortBy, String sortOrder) {
        List<User> userList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT u.*, r.role_name, r.description, r.created_at " +
                        "FROM users u LEFT JOIN role r ON u.role_id = r.id WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Apply filters
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append(" AND u.gender = ?");
            params.add(genderFilter.equalsIgnoreCase("male"));
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND u.role_id = ?");
            params.add(Integer.parseInt(roleFilter));
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND u.status = ?");
            params.add(statusFilter);
        }

        // Apply search
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.mobile LIKE ?)");
            String searchPattern = "%" + searchTerm + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Apply sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            String column;
            switch (sortBy) {
                case "id": column = "u.user_id"; break;
                case "full_name": column = "u.full_name"; break;
                case "gender": column = "u.gender"; break;
                case "email": column = "u.email"; break;
                case "mobile": column = "u.mobile"; break;
                case "role": column = "r.role_name"; break;
                case "status": column = "u.status"; break;
                default: column = "u.user_id"; break;
            }

            sql.append(" ORDER BY ").append(column);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY u.user_id ASC");
        }

        // Apply pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = getFromResultSet(resultSet);
                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getPaginatedUsers at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }

        return userList;
    }

    // Count total users for pagination with filters and search
    public int countTotalUsers(String genderFilter, String roleFilter, String statusFilter, String searchTerm) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM users u LEFT JOIN role r ON u.role_id = r.id WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Apply filters
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append(" AND u.gender = ?");
            params.add(genderFilter.equalsIgnoreCase("male"));
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND u.role_id = ?");
            params.add(Integer.parseInt(roleFilter));
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND u.status = ?");
            params.add(statusFilter);
        }

        // Apply search
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.mobile LIKE ?)");
            String searchPattern = "%" + searchTerm + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countTotalUsers at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }
}