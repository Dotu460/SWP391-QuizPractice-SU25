package com.quiz.su25.entity.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext implements I_DAO<User> {

    @Override
    public List<User> findAll() {
        String sql = "SELECT u.*, r.* FROM users u JOIN role r ON u.role_id = r.id";
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
    public boolean update(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, password_hash = ?, gender = ?, mobile = ?, "
                + "avatar_url = ?, role_id = ?, status = ?, email_verified_at = ?, "
                + "reset_password_token = ?, reset_password_expires = ? WHERE user_id = ?";
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
            statement.setObject(9, user.getEmail_verified_at());
            statement.setString(10, user.getReset_password_token());
            statement.setObject(11, user.getReset_password_expires());
            statement.setInt(12, user.getUser_id());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class UserDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(User user) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, user.getUser_id());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error delete at class UserDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO users (full_name, email, password_hash, gender, mobile, avatar_url, "
                + "role_id, status, email_verified_at, reset_password_token, reset_password_expires) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, statement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getFull_name());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword_hash());
            statement.setBoolean(4, user.isGender());
            statement.setString(5, user.getMobile());
            statement.setString(6, user.getAvatar_url());
            statement.setInt(7, user.getRole().getId());
            statement.setString(8, user.getStatus());
            statement.setObject(9, user.getEmail_verified_at());
            statement.setString(10, user.getReset_password_token());
            statement.setObject(11, user.getReset_password_expires());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public User getFromResultSet(ResultSet resultSet) throws SQLException {
        // Create Role object from result set
        Role role = Role.builder()
                .id(resultSet.getInt("id"))
                .role_name(resultSet.getString("role_name"))
                .description(resultSet.getString("description"))
                .created_at(resultSet.getDate("created_at"))
                .build();

        // Create User object from result set
        User user = User.builder()
                .user_id(resultSet.getInt("user_id"))
                .full_name(resultSet.getString("full_name"))
                .email(resultSet.getString("email"))
                .password_hash(resultSet.getString("password_hash"))
                .gender(resultSet.getBoolean("gender"))
                .mobile(resultSet.getString("mobile"))
                .avatar_url(resultSet.getString("avatar_url"))
                .role(role)
                .status(resultSet.getString("status"))
                .email_verified_at(resultSet.getObject("email_verified_at", java.time.LocalDateTime.class))
                .reset_password_token(resultSet.getString("reset_password_token"))
                .reset_password_expires(resultSet.getObject("reset_password_expires", java.time.LocalDateTime.class))
                .build();

        return user;
    }

    @Override
    public User findById(Integer id) {
        String sql = "SELECT u.*, r.* FROM users u JOIN role r ON u.role_id = r.id WHERE u.user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public User findByEmail(String email) {
        String sql = "SELECT u.*, r.* FROM users u JOIN role r ON u.role_id = r.id WHERE u.email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findByEmail at class UserDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        userDAO.findAll().forEach(user -> {
            System.out.println(user);
        });
    }
}