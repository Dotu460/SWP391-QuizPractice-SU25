package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Registration;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO extends DBContext implements I_DAO<Registration> {

    @Override
    public List<Registration> findAll() {
        String sql = "SELECT * FROM registrations";
        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    @Override
    public boolean update(Registration t) {
        String sql = "UPDATE registrations "
                + "SET user_id = ?, subname = ?, subject_id = ?, package_id = ?, "
                + "registration_time = ?, total_cost = ?, status = ?, valid_from = ?, valid_to = ? "
                + "WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getUser_id());
            statement.setInt(3, t.getSubject_id());
            statement.setInt(4, t.getPackage_id());
            statement.setDate(5, t.getRegistration_time());
            statement.setDouble(6, t.getTotal_cost());
            statement.setString(7, t.getStatus());
            statement.setDate(8, t.getValid_from());
            statement.setDate(9, t.getValid_to());
            statement.setInt(10, t.getId());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Registration t) {
        String sql = "DELETE FROM registrations WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getId());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error delete at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(Registration t) {
        String sql = "INSERT INTO registrations (user_id, subject_id, package_id, "
                + "registration_time, total_cost, status, valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getUser_id());
            statement.setInt(2, t.getSubject_id());
            statement.setInt(3, t.getPackage_id());
            statement.setDate(4, t.getRegistration_time());
            statement.setDouble(5, t.getTotal_cost());
            statement.setString(6, t.getStatus());
            statement.setDate(7, t.getValid_from());
            statement.setDate(8, t.getValid_to());
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insert at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public Registration getFromResultSet(ResultSet resultSet) throws SQLException {
        return Registration.builder()
                .id(resultSet.getInt("id"))
                .user_id(resultSet.getInt("user_id"))
                .subject_id(resultSet.getInt("subject_id"))
                .package_id(resultSet.getInt("package_id"))
                .registration_time(resultSet.getDate("registration_time"))
                .total_cost(resultSet.getDouble("total_cost"))
                .status(resultSet.getString("status"))
                .valid_from(resultSet.getDate("valid_from"))
                .valid_to(resultSet.getDate("valid_to"))
                .build();
    }

    @Override
    public Registration findById(Integer id) {
        String sql = "SELECT * FROM registrations WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM registrations";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countAll at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Registration> findAllPaginated(int offset, int limit) {
        String sql = "SELECT * FROM registrations ORDER BY registration_time DESC LIMIT ? OFFSET ?";
        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            statement.setInt(2, offset);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findAllPaginated at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    public static void main(String[] args) {
        RegistrationDAO myRegistrationDAO = new RegistrationDAO();
        List<Registration> listRegistration = myRegistrationDAO.findAll();
        for (Registration registration : listRegistration) {
            System.out.println(registration);
        }
    }

}