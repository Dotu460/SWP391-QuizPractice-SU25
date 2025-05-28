package com.quiz.su25.dal.impl;


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
        String sql = "DELETE FROM sers WHERE id = ?";
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

    public List<User> getPaginatedUsers(int page, int pageSize, String genderFilter,
                                        String roleFilter, String statusFilter,
                                        String searchTerm, String sortBy, String sortOrder) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, full_name, email, password, gender, mobile, avatar_url, role_id, status ");
        sql.append("FROM users WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append("AND gender = ? ");
            params.add("male".equals(genderFilter) ? 1 : 0);
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(roleFilter));
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append("ORDER BY ").append(sortBy);
            if ("desc".equalsIgnoreCase(sortOrder)) {
                sql.append(" DESC ");
            } else {
                sql.append(" ASC ");
            }
        } else {
            sql.append("ORDER BY id ");
        }

        // Add pagination
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        List<User> users = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

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
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM users WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append("AND gender = ? ");
            params.add("male".equals(genderFilter) ? 1 : 0);
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(roleFilter));
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
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
            System.out.println("Error in countTotalUsers: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }

//    @Override
//    public Map<Integer, User> findAllMap() {
//        String sql = "Select * from users";
//        Map<Integer, User> mapUser = new HashMap<>();
//        try {
//            connection = getConnection();
//            statement = connection.prepareStatement(sql);
//            resultSet = statement.executeQuery();
//            while (resultSet.next()) {
//                User user = getFromResultSet(resultSet);
//                mapUser.put(user.getId(), user);
//            }
//        } catch (SQLException e) {
//            System.out.println("Error findAllMap at class UserDAO: " + e.getMessage());
//        } finally {
//            closeResources();
//        }
//        return mapUser;
//    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // Test findAll
        System.out.println("Testing findAll():");
        List<User> allUsers = userDAO.findAll();
        if (allUsers.isEmpty()) {
            System.out.println("No users found.");
        } else {
            for (User user : allUsers) {
                System.out.println(user);
            }
        }
        System.out.println("--------------------");

        // Test findById
        System.out.println("Testing findById(1):");
        User userById = userDAO.findById(1); // Assuming a user with ID 1 exists
        if (userById != null) {
            System.out.println(userById);
        } else {
            System.out.println("User with ID 1 not found.");
        }
        System.out.println("--------------------");

        System.out.println("Testing findById(100):"); // Test with a non-existent ID
        User nonExistentUser = userDAO.findById(100);
        if (nonExistentUser != null) {
            System.out.println(nonExistentUser);
        } else {
            System.out.println("User with ID 100 not found.");
        }
        System.out.println("--------------------");
    }
}

