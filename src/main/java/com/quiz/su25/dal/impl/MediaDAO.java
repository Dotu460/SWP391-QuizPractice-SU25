package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Media;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MediaDAO extends DBContext implements I_DAO<Media> {

    @Override
    public List<Media> findAll() {
        List<Media> list = new ArrayList<>();
        String sql = "SELECT * FROM media ORDER BY subjectId, type, id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public Media findById(Integer id) {
        String sql = "SELECT * FROM media WHERE id = ?";
        Media media = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                media = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return media;
    }

    @Override
    public int insert(Media media) {
        String sql = "INSERT INTO media (subjectId, link, type, notes) VALUES (?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, media.getSubjectId());
            statement.setString(2, media.getLink());
            statement.setInt(3, media.getType() != null ? media.getType() : 0);
            statement.setString(4, media.getNotes());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Media media) {
        String sql = "UPDATE media SET subjectId = ?, link = ?, type = ?, notes = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, media.getSubjectId());
            statement.setString(2, media.getLink());
            statement.setInt(3, media.getType() != null ? media.getType() : 0);
            statement.setString(4, media.getNotes());
            statement.setInt(5, media.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Media media) {
        if (media == null || media.getId() == null) {
            return false;
        }
        return deleteById(media.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM media WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Media getFromResultSet(ResultSet resultSet) throws SQLException {
        return Media.builder()
                .id(resultSet.getInt("id"))
                .subjectId(resultSet.getInt("subjectId"))
                .link(resultSet.getString("link"))
                .type(resultSet.getInt("type"))
                .notes(resultSet.getString("notes"))
                .build();
    }

    // Additional methods for media-specific operations

    /**
     * Find all media for a specific subject
     */
    public List<Media> findBySubjectId(Integer subjectId) {
        List<Media> list = new ArrayList<>();
        String sql = "SELECT * FROM media WHERE subjectId = ? ORDER BY type, id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findBySubjectId at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Find media by subject ID and type (0: image, 1: video)
     */
    public List<Media> findBySubjectIdAndType(Integer subjectId, Integer type) {
        List<Media> list = new ArrayList<>();
        String sql = "SELECT * FROM media WHERE subjectId = ? AND type = ? ORDER BY id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            statement.setInt(2, type);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findBySubjectIdAndType at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Get all images for a subject
     */
    public List<Media> findImagesBySubjectId(Integer subjectId) {
        return findBySubjectIdAndType(subjectId, 0);
    }

    /**
     * Get all videos for a subject
     */
    public List<Media> findVideosBySubjectId(Integer subjectId) {
        return findBySubjectIdAndType(subjectId, 1);
    }

    /**
     * Delete all media for a specific subject
     */
    public boolean deleteBySubjectId(Integer subjectId) {
        String sql = "DELETE FROM media WHERE subjectId = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected >= 0; // 0 or more rows affected is success
        } catch (SQLException e) {
            System.out.println("Error deleteBySubjectId at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    /**
     * Count media by subject ID
     */
    public int countBySubjectId(Integer subjectId) {
        String sql = "SELECT COUNT(*) FROM media WHERE subjectId = ?";
        int count = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countBySubjectId at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return count;
    }

    /**
     * Get the first image for a subject (useful for thumbnails)
     */
    public Media findFirstImageBySubjectId(Integer subjectId) {
        String sql = "SELECT * FROM media WHERE subjectId = ? AND type = 0 ORDER BY id LIMIT 1";
        Media media = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                media = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findFirstImageBySubjectId at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return media;
    }

    /**
     * Get the first video for a subject
     */
    public Media findFirstVideoBySubjectId(Integer subjectId) {
        String sql = "SELECT * FROM media WHERE subjectId = ? AND type = 1 ORDER BY id LIMIT 1";
        Media media = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, subjectId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                media = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findFirstVideoBySubjectId at class MediaDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return media;
    }

    // Test main method
    public static void main(String[] args) {
        System.out.println("=== MediaDAO Test ===");
        
        MediaDAO dao = new MediaDAO();
        
        // Test findAll
        System.out.println("\n----- Testing findAll() -----");
        List<Media> allMedia = dao.findAll();
        printMediaList(allMedia);
        
        // Test insert
        System.out.println("\n----- Testing insert() -----");
        Media testMedia = Media.builder()
                .subjectId(1)
                .link("https://example.com/test-image.jpg")
                .type(0) // image
                .notes("Test image for subject 1")
                .build();
        int newId = dao.insert(testMedia);
        System.out.println("Inserted new media with ID: " + newId);
        
        // Test findById
        if (newId > 0) {
            System.out.println("\n----- Testing findById() -----");
            Media retrievedMedia = dao.findById(newId);
            printMedia(retrievedMedia);
            
            // Test update
            System.out.println("\n----- Testing update() -----");
            retrievedMedia.setNotes("Updated test notes");
            boolean updateSuccess = dao.update(retrievedMedia);
            System.out.println("Update successful: " + updateSuccess);
            
            // Test findBySubjectId
            System.out.println("\n----- Testing findBySubjectId() -----");
            List<Media> subjectMedia = dao.findBySubjectId(1);
            printMediaList(subjectMedia);
            
            // Test delete
            System.out.println("\n----- Testing delete() -----");
            boolean deleteSuccess = dao.delete(retrievedMedia);
            System.out.println("Delete successful: " + deleteSuccess);
        }
        
        System.out.println("\n=== MediaDAO Test Complete ===");
    }
    
    private static void printMedia(Media media) {
        if (media == null) {
            System.out.println("Media not found");
            return;
        }
        System.out.println("ID: " + media.getId());
        System.out.println("Subject ID: " + media.getSubjectId());
        System.out.println("Link: " + media.getLink());
        System.out.println("Type: " + media.getType() + " (" + media.getTypeString() + ")");
        System.out.println("Notes: " + media.getNotes());
    }
    
    private static void printMediaList(List<Media> mediaList) {
        if (mediaList == null || mediaList.isEmpty()) {
            System.out.println("No media found");
            return;
        }
        System.out.println("Found " + mediaList.size() + " media items:");
        for (int i = 0; i < mediaList.size(); i++) {
            System.out.println("--- Media " + (i+1) + " ---");
            printMedia(mediaList.get(i));
        }
    }
} 