package com.quiz.su25.dal.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Subject;
import java.sql.Date;

public class SubjectDAO extends DBContext implements I_DAO<Subject> {

    @Override
    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Subject findById(Integer id) {
        String sql = "SELECT * FROM subject WHERE id = ?";
        Subject subject = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                subject = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return subject;
    }

    @Override
    public int insert(Subject subject) {
        String sql = "INSERT INTO subject "
                + "(title, thumbnail_url, tag_line, brief_info, description, category_id, "
                + "owner_id, status, featured_flag, created_at, updated_at, created_by, updated_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getBrief_info());
            statement.setString(5, subject.getDescription());
            statement.setInt(6, subject.getCategory_id());
            statement.setInt(7, subject.getOwner_id());
            statement.setString(8, subject.getStatus());
            statement.setBoolean(9, subject.getFeatured_flag());
            statement.setDate(10, (Date) subject.getCreated_at());
            statement.setDate(11, (Date) subject.getUpdated_at());
            statement.setInt(12, subject.getCreated_by());
            statement.setInt(13, subject.getUpdated_by());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Subject subject) {
        String sql = "UPDATE subject SET "
                + "title = ?, thumbnail_url = ?, tag_line = ?, brief_info = ?, description = ?, "
                + "category_id = ?, owner_id = ?, status = ?, featured_flag = ?, "
                + "updated_at = ?, updated_by = ? "
                + "WHERE subject_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, subject.getTitle());
            statement.setString(2, subject.getThumbnail_url());
            statement.setString(3, subject.getTag_line());
            statement.setString(4, subject.getBrief_info());
            statement.setString(5, subject.getDescription());
            statement.setInt(6, subject.getCategory_id());
            statement.setInt(7, subject.getOwner_id());
            statement.setString(8, subject.getStatus());
            statement.setBoolean(9, subject.getFeatured_flag());
            statement.setObject(10, subject.getUpdated_at());
            statement.setInt(11, subject.getUpdated_by());
            statement.setInt(12, subject.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Subject subject) {
        if (subject == null || subject.getId() == null) {
            return false;
        }
        return deleteById(subject.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM subject WHERE subject_id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Subject getFromResultSet(ResultSet resultSet) throws SQLException {
        return Subject.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .thumbnail_url(resultSet.getString("thumbnail_url"))
                .tag_line(resultSet.getString("tag_line"))
                .brief_info(resultSet.getString("brief_info"))
                .description(resultSet.getString("description"))
                .category_id(resultSet.getInt("category_id"))
                .owner_id(resultSet.getInt("owner_id"))
                .status(resultSet.getString("status"))
                .featured_flag(resultSet.getBoolean("featured_flag"))
                .created_at(resultSet.getDate("created_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_by(resultSet.getInt("created_by"))
                .updated_by(resultSet.getInt("updated_by"))
                .build();
    }

    public List<Subject> getPaginatedSubjects(int page, int pageSize, String categoryFilter,
                                              String statusFilter, String searchTerm,
                                              String sortBy, String sortOrder) {
        List<Subject> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM subject WHERE 1=1");

        // Add filters
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                statement.setString(paramIndex++, categoryFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }

            // Set pagination parameters
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                subjects.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error in getPaginatedSubjects: " + e.getMessage());
        } finally {
            closeResources();
        }

        return subjects;
    }

    public int countTotalSubjects(String categoryFilter, String statusFilter, String searchTerm) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM subject WHERE 1=1");

        // Add filters
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                statement.setString(paramIndex++, categoryFilter);
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                statement.setString(paramIndex++, statusFilter);
            }

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countTotalSubjects: " + e.getMessage());
        } finally {
            closeResources();
        }

        return count;
    }

    public List<Subject> getFeaturedSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE featured_flag = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getFeaturedSubjects at class SubjectDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public static void main(String[] args) {
        // Create DAO instance
        SubjectDAO dao = new SubjectDAO();

        // Test findAll
        System.out.println("\n----- Testing findAll() -----");
        List<Subject> allSubjects = dao.findAll();
        printSubjects(allSubjects);

        // Test insert
        System.out.println("\n----- Testing insert() -----");
        Subject newSubject = Subject.builder()
                .title("Test Subject")
                .thumbnail_url("https://example.com/test.jpg")
                .tag_line("This is a test subject")
                .description("Detailed description for testing")
                .featured_flag(true)
                .category_id(1)
                .status("ACTIVE")
                .build();
        int newId = dao.insert(newSubject);
        System.out.println("Inserted new subject with ID: " + newId);

        // Test findById
        System.out.println("\n----- Testing findById() -----");
        Subject retrievedSubject = dao.findById(newId);
        printSubject(retrievedSubject);

        // Test update
        System.out.println("\n----- Testing update() -----");
        retrievedSubject.setTitle("Updated Test Subject");
        retrievedSubject.setDescription("Updated description");
        boolean updateSuccess = dao.update(retrievedSubject);
        System.out.println("Update successful: " + updateSuccess);
        printSubject(dao.findById(newId));

        // Test getPaginatedSubjects
        System.out.println("\n----- Testing getPaginatedSubjects() -----");
        List<Subject> paginatedSubjects = dao.getPaginatedSubjects(
                1, 5, null, "ACTIVE", "Test", "title", "asc");
        printSubjects(paginatedSubjects);

        // Test countTotalSubjects
        System.out.println("\n----- Testing countTotalSubjects() -----");
        int count = dao.countTotalSubjects(null, "ACTIVE", "Test");
        System.out.println("Total matching subjects: " + count);

        // Test getFeaturedSubjects
        System.out.println("\n----- Testing getFeaturedSubjects() -----");
        List<Subject> featuredSubjects = dao.getFeaturedSubjects();
        printSubjects(featuredSubjects);

        // Test delete
        System.out.println("\n----- Testing delete() -----");
        boolean deleteSuccess = dao.delete(retrievedSubject);
        System.out.println("Delete successful: " + deleteSuccess);
        System.out.println("Subject after deletion: " + dao.findById(newId));

        // Test deleteById
        System.out.println("\n----- Testing deleteById() -----");
        // First create another subject to delete
        Subject anotherSubject = Subject.builder()
                .title("Another Test Subject")
                .thumbnail_url("https://example.com/another.jpg")
                .tag_line("Another test subject")
                .description("Another description")
                .featured_flag(false)
                .category_id(2)
                .status("INACTIVE")
                .build();
        int anotherId = dao.insert(anotherSubject);
        System.out.println("Created subject with ID: " + anotherId);
        boolean deleteByIdSuccess = dao.deleteById(anotherId);
        System.out.println("DeleteById successful: " + deleteByIdSuccess);
    }

    private static void printSubject(Subject subject) {
        if (subject == null) {
            System.out.println("Subject not found");
            return;
        }
        System.out.println("ID: " + subject.getId());
        System.out.println("Title: " + subject.getTitle());
        System.out.println("Thumbnail: " + subject.getThumbnail_url());
        System.out.println("Tag Line: " + subject.getTag_line());
        System.out.println("Description: " + subject.getDescription());
        System.out.println("Featured: " + subject.getFeatured_flag());
        System.out.println("Category ID: " + subject.getCategory_id());
        System.out.println("Status: " + subject.getStatus());
    }

    private static void printSubjects(List<Subject> subjects) {
        if (subjects == null || subjects.isEmpty()) {
            System.out.println("No subjects found");
            return;
        }
        System.out.println("Found " + subjects.size() + " subjects:");
        for (int i = 0; i < subjects.size(); i++) {
            System.out.println("--- Subject " + (i+1) + " ---");
            printSubject(subjects.get(i));
        }
    }
}
