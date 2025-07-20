package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Registration;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.util.function.BiConsumer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;
import java.util.HashMap;

/**
 * Data Access Object (DAO) class for managing Registration entities.
 * Handles all database operations related to registrations including:
 * - Basic CRUD operations
 * - Filtered searches with pagination
 * - User-specific registration queries
 * - Status management
 */
public class RegistrationDAO extends DBContext implements I_DAO<Registration> {

    /**
     * Retrieves all registrations from the database
     * @return List of all Registration objects
     */
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
            System.out.println("Error findAll at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    /**
     * Updates an existing registration in the database
     * @param t Registration object containing updated information
     * @return true if update successful, false otherwise
     */
    @Override
    public boolean update(Registration t) {
        String sql = "UPDATE registrations "
                + "SET user_id = ?, subject_id = ?, package_id = ?, "
                + "registration_time = ?, total_cost = ?, status = ?, valid_from = ?, valid_to = ? "
                + "WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getUser_id());
            
            // Handle NULL values properly  
            if (t.getSubject_id() != null) {
                statement.setInt(2, t.getSubject_id());
            } else {
                statement.setNull(2, java.sql.Types.INTEGER);
            }
            
            if (t.getPackage_id() != null) {
                statement.setInt(3, t.getPackage_id());
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setDate(4, t.getRegistration_time());
            statement.setDouble(5, t.getTotal_cost());
            statement.setString(6, t.getStatus());
            statement.setDate(7, t.getValid_from());
            statement.setDate(8, t.getValid_to());
            statement.setInt(9, t.getId());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Deletes a registration from the database
     * @param t Registration object to delete (only ID is required)
     * @return true if deletion successful, false otherwise
     */
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
            System.out.println("Error delete at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Inserts a new registration into the database
     * @param t Registration object to insert
     * @return ID of the newly inserted registration, or 0 if insertion failed
     */
    @Override
    public int insert(Registration t) {
        System.out.println("🚀 DAO.insert() CALLED");
        System.out.println("   User ID: " + t.getUser_id());
        System.out.println("   Subject ID: " + t.getSubject_id());
        System.out.println("   Package ID: " + t.getPackage_id());
        System.out.println("   Status: " + t.getStatus());
        
        String sql = "INSERT INTO registrations (user_id, subject_id, package_id, "
                + "registration_time, total_cost, status, valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, t.getUser_id());
            
            // Handle NULL values properly
            if (t.getSubject_id() != null) {
                statement.setInt(2, t.getSubject_id());
            } else {
                statement.setNull(2, java.sql.Types.INTEGER);
            }
            
            if (t.getPackage_id() != null) {
                statement.setInt(3, t.getPackage_id());
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            
            statement.setDate(4, t.getRegistration_time());
            statement.setDouble(5, t.getTotal_cost());
            statement.setString(6, t.getStatus());
            statement.setDate(7, t.getValid_from());
            statement.setDate(8, t.getValid_to());
            
            System.out.println("💾 Executing SQL: " + sql);
            int affectedRows = statement.executeUpdate();
            System.out.println("📊 Affected rows: " + affectedRows);

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int generatedId = generatedKeys.getInt(1);
                        System.out.println("✅ Insert successful! Generated ID: " + generatedId);
                        return generatedId;
                    }
                }
            }
            System.out.println("❌ Insert failed: No affected rows");
        } catch (SQLException e) {
            System.out.println("💥 SQLException in DAO.insert(): " + e.getMessage());
            System.out.println("💥 SQL State: " + e.getSQLState());
            System.out.println("💥 Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Maps a database row to a Registration object
     * @param resultSet ResultSet containing the database row
     * @return Registration object populated with data from ResultSet
     * @throws SQLException if there's an error accessing the ResultSet
     */
    @Override
    public Registration getFromResultSet(ResultSet resultSet) throws SQLException {
        // 🚨 Handle NULL values properly
        Integer subjectId = resultSet.getInt("subject_id");
        if (resultSet.wasNull()) {
            subjectId = null;
        }
        
        Integer packageId = resultSet.getInt("package_id"); 
        if (resultSet.wasNull()) {
            packageId = null;
        }
        
        return Registration.builder()
                .id(resultSet.getInt("id"))
                .user_id(resultSet.getInt("user_id"))
                .subject_id(subjectId)
                .package_id(packageId)
                .registration_time(resultSet.getDate("registration_time"))
                .total_cost(resultSet.getDouble("total_cost"))
                .status(resultSet.getString("status"))
                .valid_from(resultSet.getDate("valid_from"))
                .valid_to(resultSet.getDate("valid_to"))
                .build();
    }

    /**
     * Finds a registration by its ID
     * @param id ID of the registration to find
     * @return Registration object if found, null otherwise
     */
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
            System.out.println("Error findById at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Counts registrations for a specific user with optional filters
     * @param userId ID of the user
     * @param subjectId Optional subject filter
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return Number of matching registrations
     */
    public int countByUserId(Integer userId, Integer subjectId, String status, Date fromDate, Date toDate) {
        // Xây dựng câu SQL cơ bản
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM registrations r WHERE r.user_id = ?");
        List<Object> params = new ArrayList<>(); // Danh sách tham số truy vấn
        params.add(userId); // Thêm userId vào danh sách tham số

        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?"); // Thêm điều kiện lọc theo subjectId nếu có
            params.add(subjectId);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?"); // Thêm điều kiện lọc theo status nếu có
            params.add(status);
        }

        if (fromDate != null) {
            sql.append(" AND r.valid_from >= ?"); // Lọc các bản ghi có valid_from từ fromDate
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND r.valid_to <= ?"); // Lọc các bản ghi có valid_to đến toDate
            params.add(toDate);
        }

        try {
            connection = getConnection(); // Lấy kết nối CSDL
            statement = connection.prepareStatement(sql.toString()); // Chuẩn bị câu lệnh SQL
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i)); // Gán từng tham số vào PreparedStatement
            }
            resultSet = statement.executeQuery(); // Thực thi câu lệnh
            if (resultSet.next()) {
                return resultSet.getInt(1); // Trả về số lượng bản ghi
            }
        } catch (SQLException e) {
            System.out.println("Error countByUserId at class RegistrationDAO: " + e.getMessage()); // In lỗi nếu có
        } finally {
            closeResources(); // Đóng tài nguyên
        }
        return 0; // Trả về 0 nếu có lỗi
    }

    /**
     * Retrieves paginated registrations for a specific user with filters
     * @param userId ID of the user
     * @param offset Starting position for pagination
     * @param limit Number of records to retrieve
     * @param subjectId Optional subject filter
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return List of matching Registration objects
     */
    public List<Registration> findByUserIdPaginated(Integer userId, int offset, int limit, Integer subjectId, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT r.* FROM registrations r WHERE r.user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?");
            params.add(subjectId);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }

        if (fromDate != null) {
            sql.append(" AND (DATE(r.valid_from) >= ? OR r.valid_from IS NULL)");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND (DATE(r.valid_to) <= ? OR r.valid_to IS NULL)");
            params.add(toDate);
        }

        sql.append(" ORDER BY r.registration_time DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            System.out.println("Executing SQL: " + sql.toString()); // Debug log
            System.out.println("Parameters: " + params); // Debug log
            
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Date) {
                    statement.setDate(i + 1, (Date) param);
                    System.out.println("Setting date parameter " + (i + 1) + ": " + param); // Debug log
                } else {
                    statement.setObject(i + 1, param);
                }
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.err.println("Error in findByUserIdPaginated: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    /**
     * Counts registrations for a user with subject name search
     * @param userId ID of the user
     * @param subjectNameSearch Search term for subject name
     * @param subjectId Optional subject filter
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return Number of matching registrations
     */
    public int countByUserIdAndSubjectNameSearch(Integer userId, String subjectNameSearch, Integer subjectId, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT r.id) FROM registrations r");
        List<Object> params = new ArrayList<>();
        boolean joinedWithSubject = false;

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" JOIN subject s ON r.subject_id = s.id"); // Nối bảng nếu cần tìm theo tên môn học
            joinedWithSubject = true;
        }

        sql.append(" WHERE r.user_id = ?");
        params.add(userId);

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" AND s.title LIKE ?"); // Lọc theo tên môn học (tìm kiếm mờ)
            params.add("%" + subjectNameSearch.trim() + "%");
        }

        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?");
            params.add(subjectId);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }

        if (fromDate != null) {
            sql.append(" AND r.valid_from >= ?");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND r.valid_to <= ?");
            params.add(toDate);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1); // Trả về số lượng
            }
        } catch (SQLException e) {
            System.out.println("Error countByUserIdAndSubjectNameSearch: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Retrieves paginated registrations for a user with subject name search
     * @param userId ID of the user
     * @param subjectNameSearch Search term for subject name
     * @param offset Starting position for pagination
     * @param limit Number of records to retrieve
     * @param subjectId Optional subject filter
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return List of matching Registration objects
     */
    public List<Registration> findByUserIdAndSubjectNameSearchPaginated(
            Integer userId, String subjectNameSearch, int offset, int limit,
            Integer subjectId, String status, Date fromDate, Date toDate) {

        StringBuilder sql = new StringBuilder("SELECT DISTINCT r.* FROM registrations r");
        List<Object> params = new ArrayList<>();
        boolean joinedWithSubject = false;

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" JOIN subject s ON r.subject_id = s.id"); // Nối bảng nếu tìm theo tên môn học
            joinedWithSubject = true;
        }

        sql.append(" WHERE r.user_id = ?");
        params.add(userId);

        if (joinedWithSubject) {
            sql.append(" AND s.title LIKE ?");
            params.add("%" + subjectNameSearch.trim() + "%");
        }

        if (subjectId != null) {
            sql.append(" AND r.subject_id = ?");
            params.add(subjectId);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }

        if (fromDate != null) {
            sql.append(" AND r.valid_from >= ?");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND r.valid_to <= ?");
            params.add(toDate);
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
            System.out.println("Error findByUserIdAndSubjectNameSearchPaginated: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    /**
     * Finds registrations with various filters and sorting options
     * @param emailSearch Optional email search term
     * @param subjectSearch Optional subject search term
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @param sortBy Field to sort by
     * @param sortOrder Sort order (asc/desc)
     * @param page Page number
     * @param pageSize Number of records per page
     * @return List of matching Registration objects
     */
    public List<Registration> findRegistrationsWithFilters(
            String emailSearch, String subjectSearch, String status,
            Date fromDate, Date toDate, String sortBy, String sortOrder,
            int page, int pageSize) {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT r.* FROM registrations r ");
        sql.append("JOIN users u ON r.user_id = u.id ");
        sql.append("JOIN subject s ON r.subject_id = s.id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> parameters = new ArrayList<>();
        
        // Add filters
        if (emailSearch != null && !emailSearch.trim().isEmpty()) {
            sql.append("AND u.email LIKE ? ");
            parameters.add("%" + emailSearch.trim() + "%");
        }
        
        if (subjectSearch != null && !subjectSearch.trim().isEmpty()) {
            sql.append("AND s.title LIKE ? ");
            parameters.add("%" + subjectSearch.trim() + "%");
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            parameters.add(status.trim());
        }
        
        if (fromDate != null) {
            sql.append("AND r.registration_time >= ? ");
            parameters.add(fromDate);
        }
        
        if (toDate != null) {
            sql.append("AND r.registration_time <= ? ");
            parameters.add(toDate);
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
            
            if ("desc".equalsIgnoreCase(sortOrder)) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append("ORDER BY r.id DESC");
        }
        
        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        List<Registration> registrations = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
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

    /**
     * Calculates pagination details based on total records and desired page size
     * @param totalRecords Total number of records
     * @param desiredRows Desired number of rows per page
     * @return Map containing pageSize and totalPages
     */
    public Map<String, Integer> calculatePagination(int totalRecords, int desiredRows) {
        Map<String, Integer> result = new HashMap<>();
        
        // Validate and adjust desiredRows
        int pageSize = desiredRows;
        if (pageSize <= 0) {
            pageSize = 10; // Default page size
        } else if (pageSize > 1000) {
            pageSize = 1000; // Maximum page size
        }
        
        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages < 1) {
            totalPages = 1; // At least 1 page
        }
        
        result.put("pageSize", pageSize);
        result.put("totalPages", totalPages);
        return result;
    }

    /**
     * Finds registrations with dynamic column selection and pagination
     * @param emailSearch Optional email search term
     * @param subjectSearch Optional subject search term
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @param sortBy Field to sort by
     * @param sortOrder Sort order (asc/desc)
     * @param page Page number
     * @param pageSize Number of records per page
     * @param selectedColumns Array of column names to include in result
     * @return List of matching Registration objects
     */
    public List<Registration> findRegistrationsWithDynamicColumns(
            String emailSearch, String subjectSearch, String status,
            Date fromDate, Date toDate, String sortBy, String sortOrder,
            int page, int pageSize, String[] selectedColumns) {
        List<Registration> registrations = new ArrayList<>();
        
        // Validate page and pageSize
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (pageSize > 1000) pageSize = 1000;
        
        String sql = "SELECT r.* FROM registrations r " +
                    "INNER JOIN users u ON r.user_id = u.id " +
                    "INNER JOIN subject s ON r.subject_id = s.id " +
                    "WHERE 1=1 ";
        
        // Add filters
        if (emailSearch != null && !emailSearch.isEmpty()) {
            sql += "AND u.email LIKE ? ";
        }
        if (subjectSearch != null && !subjectSearch.isEmpty()) {
            sql += "AND s.title LIKE ? ";
        }
        if (status != null && !status.isEmpty()) {
            sql += "AND r.status = ? ";
        }
        if (fromDate != null) {
            sql += "AND r.valid_from >= ? ";
        }
        if (toDate != null) {
            sql += "AND r.valid_to <= ? ";
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql += "ORDER BY ";
            switch (sortBy) {
                case "id":
                    sql += "r.id ";
                    break;
                case "email":
                    sql += "u.email ";
                    break;
                case "subject":
                    sql += "s.title ";
                    break;
                case "package":
                    sql += "r.package_id ";
                    break;
                case "total_cost":
                    sql += "r.total_cost ";
                    break;
                case "status":
                    sql += "r.status ";
                    break;
                case "valid_from":
                    sql += "r.valid_from ";
                    break;
                case "valid_to":
                    sql += "r.valid_to ";
                    break;
                case "registration_time":
                    sql += "r.registration_time ";
                    break;
                default:
                    sql += "r.id ";
            }
            sql += (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) ? "DESC " : "ASC ";
        } else {
            sql += "ORDER BY r.id DESC "; // Default sorting
        }

        // Add pagination for MySQL
        sql += "LIMIT ? OFFSET ?";

        try (Connection conn = getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (emailSearch != null && !emailSearch.isEmpty()) {
                stm.setString(paramIndex++, "%" + emailSearch + "%");
            }
            if (subjectSearch != null && !subjectSearch.isEmpty()) {
                stm.setString(paramIndex++, "%" + subjectSearch + "%");
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, status);
            }
            if (fromDate != null) {
                stm.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                stm.setDate(paramIndex++, toDate);
            }

            // Set pagination parameters for MySQL
            stm.setInt(paramIndex++, pageSize);
            stm.setInt(paramIndex, (page - 1) * pageSize);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    registrations.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    /**
     * Counts total number of registrations matching filter criteria
     * @param emailSearch Optional email search term
     * @param subjectSearch Optional subject search term
     * @param status Optional status filter
     * @param fromDate Optional start date filter
     * @param toDate Optional end date filter
     * @return Number of matching registrations
     */
    public int countFilteredRegistrations(
            String emailSearch, String subjectSearch, String status,
            Date fromDate, Date toDate) {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT r.id) FROM registrations r ");
        sql.append("JOIN users u ON r.user_id = u.id ");
        sql.append("JOIN subject s ON r.subject_id = s.id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> parameters = new ArrayList<>();
        
        // Add filters
        if (emailSearch != null && !emailSearch.trim().isEmpty()) {
            sql.append("AND u.email LIKE ? ");
            parameters.add("%" + emailSearch.trim() + "%");
        }
        
        if (subjectSearch != null && !subjectSearch.trim().isEmpty()) {
            sql.append("AND s.title LIKE ? ");
            parameters.add("%" + subjectSearch.trim() + "%");
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            parameters.add(status.trim());
        }
        
        if (fromDate != null) {
            sql.append("AND r.registration_time >= ? ");
            parameters.add(fromDate);
        }
        
        if (toDate != null) {
            sql.append("AND r.registration_time <= ? ");
            parameters.add(toDate);
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countFilteredRegistrations: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }

    /**
     * Retrieves all unique status values from registrations
     * @return List of unique status values
     */
    public List<String> getAllStatuses() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM registrations ORDER BY status ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                statuses.add(resultSet.getString("status"));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllStatuses at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return statuses;
    }

    /**
     * Finds all registrations for a specific user
     * @param userId ID of the user
     * @return List of Registration objects for the user
     */
    public List<Registration> findByUserId(Integer userId) {
        String sql = "SELECT * FROM registrations WHERE user_id = ?";
        List<Registration> listRegistration = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Registration registration = getFromResultSet(resultSet);
                listRegistration.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error findByUserId at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }
    
    /**
     * Checks if a user is already registered for a specific subject/course
     * @param userId ID of the user
     * @param subjectId ID of the subject/course
     * @return true if already registered, false otherwise
     */
    public boolean isAlreadyRegistered(Integer userId, Integer subjectId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE user_id = ? AND subject_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error isAlreadyRegistered at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public static void main(String[] args) {
        // Create DAO instances
        RegistrationDAO dao = new RegistrationDAO();

        System.out.println("===== TESTING BASIC CRUD OPERATIONS =====");

        // Test findAll
        System.out.println("\n----- Testing findAll() -----");
        List<Registration> allRegistrations = dao.findAll();
        printRegistrations(allRegistrations);

        // Test insert
        System.out.println("\n----- Testing insert() -----");
        // Create a sample registration for testing
        Date currentDate = new Date(System.currentTimeMillis());
        Date validFrom = new Date(System.currentTimeMillis());
        // Valid to date is 30 days from now
        Date validTo = new Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000);

        Registration newRegistration = Registration.builder()
                .user_id(1) // Assuming user with ID 1 exists
                .subject_id(4) // Assuming subject with ID 1 exists
                .package_id(1) // Assuming package with ID 1 exists
                .registration_time(currentDate)
                .total_cost(99.99)
                .status("pending")
                .valid_from(validFrom)
                .valid_to(validTo)
                .build();

        int newId = dao.insert(newRegistration);
        System.out.println("Inserted new registration with ID: " + newId);


        // Test findById
        System.out.println("\n----- Testing findById() -----");
        Registration retrievedRegistration = dao.findById(newId);
        printRegistration(retrievedRegistration);

        // Test update
        System.out.println("\n----- Testing update() -----");
        retrievedRegistration.setStatus("approved");
        retrievedRegistration.setTotal_cost(89.99);
        boolean updateSuccess = dao.update(retrievedRegistration);
        System.out.println("Update successful: " + updateSuccess);
        System.out.println("Updated registration:");
        printRegistration(dao.findById(newId));

        System.out.println("\n===== TESTING SPECIALIZED METHODS =====");

        // Test countByUserId
        System.out.println("\n----- Testing countByUserId() -----");
        int userId = 1; // Assuming user with ID 1 exists and has registrations
        int countForUser = dao.countByUserId(userId, null, null, null, null);
        System.out.println("Total registrations for user " + userId + ": " + countForUser);

        // Test with filters
        System.out.println("Total 'approved' registrations for user " + userId + ": " +
                dao.countByUserId(userId, null, "approved", null, null));

        // Test findByUserIdPaginated
        System.out.println("\n----- Testing findByUserIdPaginated() -----");
        List<Registration> userRegistrations = dao.findByUserIdPaginated(userId, 0, 5, null, null, null, null);
        System.out.println("First 5 registrations for user " + userId + ":");
        printRegistrations(userRegistrations);

        // Test countByUserIdAndSubjectNameSearch
        System.out.println("\n----- Testing countByUserIdAndSubjectNameSearch() -----");
        String searchTerm = "Java"; // Adjust based on your data
        int searchCount = dao.countByUserIdAndSubjectNameSearch(userId, searchTerm, null, null, null, null);
        System.out.println("Count for user " + userId + " with subject name containing '" + searchTerm + "': " + searchCount);

        // Test findByUserIdAndSubjectNameSearchPaginated
        System.out.println("\n----- Testing findByUserIdAndSubjectNameSearchPaginated() -----");
        List<Registration> searchResults = dao.findByUserIdAndSubjectNameSearchPaginated(
                userId, searchTerm, 0, 5, null, null, null, null);
        System.out.println("Search results for user " + userId + " with subject name containing '" + searchTerm + "':");
        printRegistrations(searchResults);

        // Test findRegistrationsWithFilters
        System.out.println("\n----- Testing findRegistrationsWithFilters() -----");
        String emailSearch = "user"; // Adjust based on your data
        List<Registration> filteredRegistrations = dao.findRegistrationsWithFilters(
                emailSearch, null, "approved", null, null, "registration_time", "desc", 1, 5);
        System.out.println("Filtered registrations (email contains '" + emailSearch + "', status='approved'):");
        printRegistrations(filteredRegistrations);

        // Test countFilteredRegistrations
        System.out.println("\n----- Testing countFilteredRegistrations() -----");
        int filteredCount = dao.countFilteredRegistrations(emailSearch, null, "approved", null, null);
        System.out.println("Count of filtered registrations: " + filteredCount);

        // Test delete
        System.out.println("\n----- Testing delete() -----");
        boolean deleteSuccess = dao.delete(retrievedRegistration);
        System.out.println("Delete successful: " + deleteSuccess);
        System.out.println("Registration after deletion: " + dao.findById(newId));
    }

    private static void printRegistration(Registration registration) {
        if (registration == null) {
            System.out.println("Registration not found");
            return;
        }

        System.out.println("ID: " + registration.getId());
        System.out.println("User ID: " + registration.getUser_id());
        System.out.println("Subject ID: " + registration.getSubject_id());
        System.out.println("Package ID: " + registration.getPackage_id());
        System.out.println("Registration Time: " + registration.getRegistration_time());
        System.out.println("Total Cost: $" + registration.getTotal_cost());
        System.out.println("Status: " + registration.getStatus());
        System.out.println("Valid From: " + registration.getValid_from());
        System.out.println("Valid To: " + registration.getValid_to());
    }

    private static void printRegistrations(List<Registration> registrations) {
        if (registrations == null || registrations.isEmpty()) {
            System.out.println("No registrations found");
            return;
        }

        System.out.println("Found " + registrations.size() + " registrations:");
        for (int i = 0; i < Math.min(registrations.size(), 5); i++) {
            System.out.println("\n--- Registration " + (i+1) + " ---");
            printRegistration(registrations.get(i));
        }

        if (registrations.size() > 5) {
            System.out.println("\n... and " + (registrations.size() - 5) + " more registrations");
        }
    }

}
