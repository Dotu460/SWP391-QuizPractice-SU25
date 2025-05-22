package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.MyRegistration;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MyRegistrationDAO extends DBContext implements I_DAO<MyRegistration> {

    @Override
    public List<MyRegistration> findAll() {
        String sql = "select * from registrations";
        List<MyRegistration> listregistration = new ArrayList<>();
        try {
            //tao connection
            connection = getConnection();
            //chuan bi cho statmenet
            statement = connection.prepareStatement(sql);
            //set parameter (optional)

            //thuc thi cau lenh
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                MyRegistration registration = getFromResultSet(resultSet);
                listregistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listregistration;
    }

    public List<MyRegistration> findAll1() {
        String sql = "SELECT mr.*, s.title AS subject_title, p.list_price, p.status AS package_status "
                + "FROM MyRegistration mr "
                + "JOIN Subject s ON mr.subject_id = s.id "
                + "JOIN PricePackage p ON mr.package_id = p.id";
        List<MyRegistration> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                MyRegistration registration = getFromResultSet(resultSet);
                list.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public MyRegistration findById(Integer id) {
        String sql = "SELECT mr.*, s.title AS subject_title, p.list_price, p.status AS package_status "
                + "FROM MyRegistration mr "
                + "JOIN Subject s ON mr.subject_id = s.id "
                + "JOIN PricePackage p ON mr.package_id = p.id "
                + "WHERE mr.id = ?";
        MyRegistration registration = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                registration = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return registration;
    }

    @Override
    public int insert(MyRegistration registration) {
        String sql = "INSERT INTO MyRegistration (user_id, subname, subject_id, package_id, registration_time, total_cost, status, valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, registration.getUser_id());
            statement.setString(2, registration.getSubname());
            statement.setInt(3, registration.getSubject_id());
            statement.setInt(4, registration.getPackage_id());
            statement.setDate(5, registration.getRegistration_time());
            statement.setDouble(6, registration.getTotal_cost());
            statement.setString(7, registration.getStatus());
            statement.setDate(8, registration.getValid_from());
            statement.setDate(9, registration.getValid_to());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(MyRegistration registration) {
        String sql = "UPDATE MyRegistration "
                + "SET user_id = ?, subname = ?, subject_id = ?, package_id = ?, registration_time = ?, total_cost = ?, status = ?, valid_from = ?, valid_to = ? "
                + "WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, registration.getUser_id());
            statement.setString(2, registration.getSubname());
            statement.setInt(3, registration.getSubject_id());
            statement.setInt(4, registration.getPackage_id());
            statement.setDate(5, registration.getRegistration_time());
            statement.setDouble(6, registration.getTotal_cost());
            statement.setString(7, registration.getStatus());
            statement.setDate(8, registration.getValid_from());
            statement.setDate(9, registration.getValid_to());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(MyRegistration registration) {
        return deleteById(registration.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM MyRegistration WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public MyRegistration getFromResultSet(ResultSet resultSet) throws SQLException {
        return MyRegistration.builder()
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

    public int getTotalByUserId(int userId) {
        String sql = "SELECT COUNT(*) AS total FROM MyRegistration WHERE user_id = ?";
        int total = 0;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                total = resultSet.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalByUserId at MyRegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }

        return total;
    }

    public static void main(String[] args) {
        MyRegistrationDAO dao = new MyRegistrationDAO();

        // Test findAll with join
        System.out.println("Testing findAll():");
        List<MyRegistration> registrations = dao.findAll();
        registrations.forEach(System.out::println);

        // Test findById with join
        System.out.println("Testing findById(1):");
        MyRegistration registration = dao.findById(1);
        System.out.println(registration);
    }

}
