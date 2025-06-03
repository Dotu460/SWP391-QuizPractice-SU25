package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Registration;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
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
    
    // Overloaded method for filtering by subjectId
    public int countAll(Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM registrations");
        List<Object> params = new ArrayList<>();
        if (subjectId != null) {
            sql.append(" WHERE subject_id = ?");
            params.add(subjectId);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countAll(subjectId) at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    // Original method calls overloaded one
    public int countAll() {
        return countAll(null);
    }

    // Overloaded method for filtering by subjectId
    public List<Registration> findAllPaginated(int offset, int limit, Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT * FROM registrations");
        List<Object> params = new ArrayList<>();
        if (subjectId != null) {
            sql.append(" WHERE subject_id = ?");
            params.add(subjectId);
        }
        sql.append(" ORDER BY registration_time DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findAllPaginated(subjectId) at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    // Original method calls overloaded one
    public List<Registration> findAllPaginated(int offset, int limit) {
        return findAllPaginated(offset, limit, null);
    }

    // Overloaded method for filtering by subjectId
    public int countBySubjectNameSearch(String subjectNameSearch, Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT r.id) FROM registrations r JOIN subject s ON r.subject_id = s.id");
        List<Object> params = new ArrayList<>();

        sql.append(" WHERE 1=1");

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" AND s.title LIKE ?");
            params.add("%" + subjectNameSearch.trim() + "%");
        }
        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?");
            params.add(subjectId);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countBySubjectNameSearch(subjectId) at RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    
    public int countBySubjectNameSearch(String subjectNameSearch) {
        return countBySubjectNameSearch(subjectNameSearch, null);
    }

    // Overloaded method for filtering by subjectId
    public List<Registration> findBySubjectNameSearchPaginated(String subjectNameSearch, int offset, int limit, Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT DISTINCT r.* FROM registrations r JOIN subject s ON r.subject_id = s.id");
        List<Object> params = new ArrayList<>();

        sql.append(" WHERE 1=1");

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" AND s.title LIKE ?");
            params.add("%" + subjectNameSearch.trim() + "%");
        }
        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?");
            params.add(subjectId);
        }

        sql.append(" ORDER BY r.registration_time DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findBySubjectNameSearchPaginated(subjectId) at RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    // Original method calls overloaded one
    public List<Registration> findBySubjectNameSearchPaginated(String subjectNameSearch, int offset, int limit) {
        return findBySubjectNameSearchPaginated(subjectNameSearch, offset, limit, null);
    }

    public List<Registration> findRegistrationsWithFilters(String subjectSearch, String email, String status,
                                                         Date fromDate, Date toDate, String sortBy, String sortOrder,
                                                         int page, int pageSize) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT r.* FROM registrations r ");
        sql.append("JOIN subject s ON r.subject_id = s.id ");
        sql.append("JOIN users u ON r.user_id = u.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectSearch != null && !subjectSearch.trim().isEmpty()) {
            sql.append("AND s.title LIKE ? ");
            params.add("%" + subjectSearch.trim() + "%");
        }

        if (email != null && !email.trim().isEmpty()) {
            sql.append("AND u.email LIKE ? ");
            params.add("%" + email.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status.trim());
        }

        if (fromDate != null) {
            sql.append("AND r.registration_time >= ? ");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append("AND r.registration_time <= ? ");
            params.add(toDate);
        }

        // Add sorting
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            sql.append("ORDER BY ");
            switch (sortBy) {
                case "email":
                    sql.append("u.email");
                    break;
                case "subject":
                    sql.append("s.title");
                    break;
                default:
                    sql.append("r.").append(sortBy);
            }
            sql.append(sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? " DESC" : " ASC");
        } else {
            sql.append("ORDER BY r.id DESC");
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Registration> registrations = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                registrations.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in findRegistrationsWithFilters: " + e.getMessage());
        } finally {
            closeResources();
        }
        return registrations;
    }

    public int countTotalRegistrations(String subjectSearch, String email, String status,
                                     Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT r.id) FROM registrations r ");
        sql.append("JOIN subject s ON r.subject_id = s.id ");
        sql.append("JOIN users u ON r.user_id = u.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectSearch != null && !subjectSearch.trim().isEmpty()) {
            sql.append("AND s.title LIKE ? ");
            params.add("%" + subjectSearch.trim() + "%");
        }

        if (email != null && !email.trim().isEmpty()) {
            sql.append("AND u.email LIKE ? ");
            params.add("%" + email.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status.trim());
        }

        if (fromDate != null) {
            sql.append("AND r.registration_time >= ? ");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append("AND r.registration_time <= ? ");
            params.add(toDate);
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
            System.out.println("Error in countTotalRegistrations: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }

    public static void main(String[] args) {
        RegistrationDAO myRegistrationDAO = new RegistrationDAO();
        List<Registration> listRegistration = myRegistrationDAO.findAll();
        for (Registration registration : listRegistration) {
            System.out.println(registration);
        }
    }

}