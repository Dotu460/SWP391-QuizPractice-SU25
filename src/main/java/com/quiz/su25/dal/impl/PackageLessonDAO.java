package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.PackageLesson;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PackageLessonDAO extends DBContext implements I_DAO<PackageLesson> {

    @Override
    public List<PackageLesson> findAll() {
        String sql = "SELECT * FROM package_lesson";
        List<PackageLesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PackageLesson packageLesson = getFromResultSet(resultSet);
                list.add(packageLesson);
            }
        } catch (Exception e) {
            System.out.println("Error findAll at class PackageLessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public PackageLesson findById(Integer id) {
        String sql = "SELECT * FROM package_lesson WHERE package_id = ?";
        List<PackageLesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PackageLesson packageLesson = getFromResultSet(resultSet);
                list.add(packageLesson);
            }
        } catch (Exception e) {
            System.out.println("Error findById at class PackageLessonDAO: " + e.getMessage());
        }
        return list.get(0);
    }

    public List<PackageLesson> findByPackageId(Integer packageId) {
        String sql = "SELECT * FROM package_lesson WHERE package_id = ?";
        List<PackageLesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, packageId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PackageLesson packageLesson = getFromResultSet(resultSet);
                list.add(packageLesson);
            }
        } catch (Exception e) {
            System.out.println("Error findByPackageId at class PackageLessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public List<PackageLesson> findByLessonId(Integer lessonId) {
        String sql = "SELECT * FROM package_lesson WHERE lesson_id = ?";
        List<PackageLesson> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PackageLesson packageLesson = getFromResultSet(resultSet);
                list.add(packageLesson);
            }
        } catch (Exception e) {
            System.out.println("Error findByLessonId at class PackageLessonDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public int insert(PackageLesson packageLesson) {
        String sql = "INSERT INTO package_lesson (package_id, lesson_id) VALUES (?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, packageLesson.getPackage_id());
            statement.setInt(2, packageLesson.getLesson_id());
            return statement.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error insert at class PackageLessonDAO: " + e.getMessage());
            return 0;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(PackageLesson packageLesson) {
        // This method is not applicable for this table as it only contains foreign keys
        throw new UnsupportedOperationException("Update operation is not supported for PackageLesson");
    }

    @Override
    public boolean delete(PackageLesson packageLesson) {
        String sql = "DELETE FROM package_lesson WHERE package_id = ? AND lesson_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, packageLesson.getPackage_id());
            statement.setInt(2, packageLesson.getLesson_id());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error delete at class PackageLessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean deleteByPackageId(Integer packageId) {
        String sql = "DELETE FROM package_lesson WHERE package_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, packageId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByPackageId at class PackageLessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean deleteByLessonId(Integer lessonId) {
        String sql = "DELETE FROM package_lesson WHERE lesson_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteByLessonId at class PackageLessonDAO: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public PackageLesson getFromResultSet(ResultSet resultSet) throws SQLException {
        return PackageLesson.builder()
                .package_id(resultSet.getInt("package_id"))
                .lesson_id(resultSet.getInt("lesson_id"))
                .build();
    }

    public static void main(String[] args) {
        PackageLessonDAO dao = new PackageLessonDAO();
        dao.findAll().forEach(System.out::println);
    }
} 