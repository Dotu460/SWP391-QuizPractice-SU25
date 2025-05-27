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
     * Đếm số bản ghi của một user cụ thể
     */
    public int countByUserId(Integer userId, Integer subjectId, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM registrations r WHERE r.user_id = ?");
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
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countByUserId at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Lấy danh sách đăng ký của một user cụ thể với phân trang và các bộ lọc: subjectId, status, fromDate, toDate.
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
            System.out.println("Error findByUserIdPaginated at class RegistrationDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listRegistration;
    }

    /**
     * Đếm số lượng bản ghi đăng ký của một user cụ thể dựa trên tìm kiếm tên môn học và các bộ lọc khác.
     *
     * @param userId ID của user
     * @param subjectNameSearch Từ khóa tìm tên môn học (có thể null hoặc rỗng).
     * @param subjectId ID môn học (null nếu không lọc).
     * @param status Trạng thái (null hoặc rỗng nếu không lọc).
     * @param fromDate Ngày bắt đầu (null nếu không lọc).
     * @param toDate Ngày kết thúc (null nếu không lọc).
     * @return Tổng số bản ghi.
     */
    public int countByUserIdAndSubjectNameSearch(Integer userId, String subjectNameSearch, Integer subjectId, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT r.id) FROM registrations r");
        List<Object> params = new ArrayList<>();
        boolean joinedWithSubject = false;

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" JOIN subject s ON r.subject_id = s.id");
            joinedWithSubject = true;
        }

        sql.append(" WHERE r.user_id = ?");
        params.add(userId);

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
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
            System.out.println("Error countByUserIdAndSubjectNameSearch: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Lấy danh sách bản ghi đăng ký của một user cụ thể với phân trang và tìm kiếm tên môn học.
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
    public List<Registration> findByUserIdAndSubjectNameSearchPaginated(
            Integer userId, String subjectNameSearch, int offset, int limit,
            Integer subjectId, String status, Date fromDate, Date toDate) {

        StringBuilder sql = new StringBuilder("SELECT DISTINCT r.* FROM registrations r");
        List<Object> params = new ArrayList<>();
        boolean joinedWithSubject = false;

        if (subjectNameSearch != null && !subjectNameSearch.trim().isEmpty()) {
            sql.append(" JOIN subject s ON r.subject_id = s.id");
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

}
