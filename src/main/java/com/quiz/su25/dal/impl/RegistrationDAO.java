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

/**
 * Lớp DAO (Data Access Object) cho thực thể Registration. Chịu trách nhiệm
 * tương tác với cơ sở dữ liệu liên quan đến các bản ghi đăng ký. Kế thừa từ
 * DBContext để quản lý kết nối cơ sở dữ liệu và triển khai I_DAO cho các hoạt
 * động CRUD cơ bản.
 */
public class RegistrationDAO extends DBContext implements I_DAO<Registration> {

    /**
     * Lấy tất cả các bản ghi đăng ký từ cơ sở dữ liệu.
     *
     * @return Danh sách các đối tượng Registration.
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
     * Cập nhật thông tin một bản ghi đăng ký trong cơ sở dữ liệu.
     *
     * @param t Đối tượng Registration chứa thông tin cần cập nhật.
     * @return true nếu cập nhật thành công, false nếu thất bại.
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
            statement.setInt(2, t.getSubject_id());
            statement.setInt(3, t.getPackage_id());
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
     * Xóa một bản ghi đăng ký khỏi cơ sở dữ liệu.
     *
     * @param t Đối tượng Registration cần xóa (chỉ cần ID).
     * @return true nếu xóa thành công, false nếu thất bại.
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
     * Thêm một bản ghi đăng ký mới vào cơ sở dữ liệu.
     *
     * @param t Đối tượng Registration chứa thông tin cần thêm.
     * @return ID của bản ghi mới được chèn (hiện tại đang trả về 0, có thể cần
     * cải thiện để trả về ID thực).
     */
    @Override
    public int insert(Registration t) {
        String sql = "INSERT INTO registrations (user_id, subject_id, package_id, "
                + "registration_time, total_cost, status, valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, t.getUser_id());
            statement.setInt(2, t.getSubject_id());
            statement.setInt(3, t.getPackage_id());
            statement.setDate(4, t.getRegistration_time());
            statement.setDouble(5, t.getTotal_cost());
            statement.setString(6, t.getStatus());
            statement.setDate(7, t.getValid_from());
            statement.setDate(8, t.getValid_to());
            int affectedRows = statement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Chuyển đổi một dòng từ ResultSet thành một đối tượng Registration.
     *
     * @param resultSet Đối tượng ResultSet chứa dữ liệu từ cơ sở dữ liệu.
     * @return Đối tượng Registration được tạo từ dữ liệu.
     * @throws SQLException Nếu có lỗi khi truy cập dữ liệu từ ResultSet.
     */
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

    /**
     * Tìm một bản ghi đăng ký dựa trên ID.
     *
     * @param id ID của bản ghi đăng ký cần tìm.
     * @return Đối tượng Registration nếu tìm thấy, null nếu không.
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
     * Đếm số bản ghi đăng ký của một user theo các bộ lọc
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
     * Lấy danh sách đăng ký của một user cụ thể với phân trang và các bộ lọc:
     * subjectId, status, fromDate, toDate.
     *
     * @param userId ID của user
     * @param offset Vị trí bắt đầu.
     * @param limit Số lượng bản ghi.
     * @param subjectId ID môn học (null nếu không lọc).
     * @param status Trạng thái (null hoặc rỗng nếu không lọc).
     * @param fromDate Ngày bắt đầu (null nếu không lọc).
     * @param toDate Ngày kết thúc (null nếu không lọc).
     * @return Danh sách Registration.
     */
    // Truy vấn danh sách bản ghi của một user có phân trang và lọc
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
     * Đếm số lượng bản ghi đăng ký của một user cụ thể dựa trên tìm kiếm tên
     * môn học và các bộ lọc khác.
     *
     * @param userId ID của user
     * @param subjectNameSearch Từ khóa tìm tên môn học (có thể null hoặc rỗng).
     * @param subjectId ID môn học (null nếu không lọc).
     * @param status Trạng thái (null hoặc rỗng nếu không lọc).
     * @param fromDate Ngày bắt đầu (null nếu không lọc).
     * @param toDate Ngày kết thúc (null nếu không lọc).
     * @return Tổng số bản ghi.
     */
    // Đếm số bản ghi đăng ký của user, có thể tìm theo tên môn học
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
     * Lấy danh sách bản ghi đăng ký của một user cụ thể với phân trang và tìm
     * kiếm tên môn học.
     *
     * @param userId ID của user
     * @param subjectNameSearch Từ khóa tìm tên môn học (có thể null hoặc rỗng).
     * @param offset Vị trí bắt đầu.
     * @param limit Số lượng.
     * @param subjectId ID môn học (null nếu không lọc).
     * @param status Trạng thái (null hoặc rỗng nếu không lọc).
     * @param fromDate Ngày bắt đầu (null nếu không lọc).
     * @param toDate Ngày kết thúc (null nếu không lọc).
     * @return Danh sách Registration.
     */
    // Tìm danh sách bản ghi đăng ký của user với phân trang và tìm kiếm tên môn học
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
     * Find registrations with filters and sorting
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
     * Count total filtered registrations
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
