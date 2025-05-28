
package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.PricePackage;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PricePackageDAO extends DBContext implements I_DAO<PricePackage> {

    @Override
    public List<PricePackage> findAll() {
        String sql = "SELECT id, subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at FROM price_package";
        List<PricePackage> listPricePackage = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PricePackage pricePackage = getFromResultSet(resultSet);
                listPricePackage.add(pricePackage);
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listPricePackage;
    }

    @Override
    public PricePackage findById(Integer id) {
        String sql = "SELECT id, subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at FROM price_package WHERE id = ?";
        PricePackage pricePackage = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                pricePackage = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return pricePackage;
    }

    @Override
    public int insert(PricePackage pricePackage) {
        String sql = "INSERT INTO price_package "
                + "(subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, pricePackage.getSubject_id());
            statement.setString(2, pricePackage.getPackage_name());
            statement.setDouble(3, pricePackage.getList_price());
            statement.setDouble(4, pricePackage.getSale_price());
            statement.setString(5, pricePackage.getStatus());
            statement.setString(6, pricePackage.getDescription());
            statement.setDate(7, pricePackage.getCreated_at());
            statement.setDate(8, pricePackage.getUpdated_at());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(PricePackage pricePackage) {
        String sql = "UPDATE price_package "
                + "SET subject_id = ?, package_name = ?, list_price = ?, sale_price = ?, "
                + "status = ?, description = ?, updated_at = ? "
                + "WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, pricePackage.getSubject_id());
            statement.setString(2, pricePackage.getPackage_name());
            statement.setDouble(3, pricePackage.getList_price());
            statement.setDouble(4, pricePackage.getSale_price());
            statement.setString(5, pricePackage.getStatus());
            statement.setString(6, pricePackage.getDescription());
            statement.setDate(7, pricePackage.getUpdated_at());
            statement.setInt(8, pricePackage.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(PricePackage pricePackage) {
        if (pricePackage == null || pricePackage.getId() == null) {
            return false;
        }
        return deleteById(pricePackage.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM price_package WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public PricePackage getFromResultSet(ResultSet resultSet) throws SQLException {
        return PricePackage.builder()
                .id(resultSet.getInt("id"))
                .subject_id(resultSet.getInt("subject_id"))
                .package_name(resultSet.getString("package_name"))
                .list_price(resultSet.getDouble("list_price"))
                .sale_price(resultSet.getDouble("sale_price"))
                .status(resultSet.getString("status"))
                .description(resultSet.getString("description"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .build();
    }

    public List<PricePackage> findBySubjectId(Integer subjectId) {
        String sql = "SELECT id, subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at "
                + "FROM price_package WHERE subject_id = ?";
        List<PricePackage> packages = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                packages.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findBySubjectId at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return packages;
    }

    public PricePackage findLowestPricePackageBySubjectId(Integer subjectId) {
        String sql = "SELECT id, subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at "
                + "FROM price_package WHERE subject_id = ? AND status = 'active' ORDER BY sale_price ASC LIMIT 1";
        PricePackage lowestPricePackage = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                lowestPricePackage = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findLowestPricePackageBySubjectId at class PricePackageDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return lowestPricePackage;
    }

    public List<PricePackage> getPaginatedPricePackages(int page, int pageSize, Integer subjectIdFilter,
                                            String statusFilter, String searchTerm,
                                            String sortBy, String sortOrder) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, subject_id, package_name, list_price, sale_price, status, description, created_at, updated_at ");
        sql.append("FROM price_package WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (subjectIdFilter != null) {
            sql.append("AND subject_id = ? ");
            params.add(subjectIdFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (package_name LIKE ? OR description LIKE ?) ");
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

        List<PricePackage> packages = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                packages.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in getPaginatedPricePackages: " + e.getMessage());
        } finally {
            closeResources();
        }
        return packages;
    }

    public int countTotalPricePackages(Integer subjectIdFilter, String statusFilter, String searchTerm) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM price_package WHERE 1=1 ");

        // Add filters
        List<Object> params = new ArrayList<>();
        if (subjectIdFilter != null) {
            sql.append("AND subject_id = ? ");
            params.add(subjectIdFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append("AND (package_name LIKE ? OR description LIKE ?) ");
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
            System.out.println("Error in countTotalPricePackages: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }

    public static void main(String[] args) {
        PricePackageDAO pricePackageDAO = new PricePackageDAO();

        // Test findAll
        System.out.println("Testing findAll():");
        List<PricePackage> allPackages = pricePackageDAO.findAll();
        if (allPackages.isEmpty()) {
            System.out.println("No price packages found.");
        } else {
            for (PricePackage pkg : allPackages) {
                System.out.println(pkg);
            }
        }
        System.out.println("--------------------");

        // Test findById
        System.out.println("Testing findById(1):");
        PricePackage packageById = pricePackageDAO.findById(1);
        if (packageById != null) {
            System.out.println(packageById);
        } else {
            System.out.println("Package with ID 1 not found.");
        }
    }
}