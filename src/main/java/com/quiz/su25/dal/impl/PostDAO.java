/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.dal.impl;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.entity.Post;
import java.sql.*;
import java.util.*;
import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
// Explicitly import java.sql.Date to resolve ambiguity
import java.sql.Date;

public class PostDAO extends DBContext implements I_DAO<Post> {

    @Override
    public List<Post> findAll() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error findAll at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

   @Override
    public Post findById(Integer id) {
        String sql = "SELECT * FROM post WHERE id = ?";
        Post post = null;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                post = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return post;
    }

    @Override
    public int insert(Post post) {
        String sql = "INSERT INTO post (category, title, thumbnail_url, brief_info, content, category_id, author, published_at, updated_at, created_at, status, featured_flag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        // DEBUGGING: Print all post data before insert
        System.out.println("=== POST INSERT DEBUG ===");
        System.out.println("SQL: " + sql);
        System.out.println("Post data:");
        System.out.println("  Category: " + post.getCategory());
        System.out.println("  Title: " + post.getTitle());
        System.out.println("  Thumbnail_url: " + post.getThumbnail_url());
        System.out.println("  Brief_info: " + post.getBrief_info());
        System.out.println("  Content: " + (post.getContent() != null ? post.getContent().substring(0, Math.min(50, post.getContent().length())) + "..." : "null"));
        System.out.println("  Category_id: " + post.getCategory_id());
        System.out.println("  Author: " + post.getAuthor());
        System.out.println("  Published_at: " + post.getPublished_at());
        System.out.println("  Updated_at: " + post.getUpdated_at());
        System.out.println("  Created_at: " + post.getCreated_at());
        System.out.println("  Status: " + post.getStatus());
        System.out.println("  Featured_flag: " + post.getFeatured_flag());
        
        try {
            connection = getConnection();
            System.out.println("Connection obtained: " + (connection != null ? "SUCCESS" : "NULL"));
            System.out.println("Connection closed: " + (connection != null ? connection.isClosed() : "connection is null"));
            
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            System.out.println("PreparedStatement created: " + (statement != null ? "SUCCESS" : "NULL"));
            
            statement.setString(1, post.getCategory());           // category (chuỗi)
            statement.setString(2, post.getTitle());              // title
            statement.setString(3, post.getThumbnail_url());      // thumbnail_url
            statement.setString(4, post.getBrief_info());         // brief_info
            statement.setString(5, post.getContent());            // content
            statement.setInt(6, post.getCategory_id());           // category_id
            statement.setString(7, post.getAuthor());             // author (chuỗi)
            statement.setDate(8, post.getPublished_at());         // published_at
            statement.setDate(9, post.getUpdated_at());           // updated_at
            statement.setDate(10, post.getCreated_at());          // created_at
            statement.setString(11, post.getStatus());            // status
            statement.setInt(12, (post.getFeatured_flag() != null && post.getFeatured_flag()) ? 1 : 0);
            
            System.out.println("All parameters set. Executing insert...");
            int rowsAffected = statement.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
                System.out.println("Generated ID: " + generatedId);
            } else {
                System.out.println("ERROR: No generated keys returned!");
            }
            
            System.out.println("INSERT COMPLETED SUCCESSFULLY!");
            
        } catch (SQLException e) {
            System.out.println("ERROR insert at class PostDAO: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace(); // ✅ ADD FULL STACK TRACE
        } finally {
            closeResources();
        }
        
        System.out.println("Returning generated ID: " + generatedId);
        System.out.println("=== POST INSERT DEBUG END ===");
        return generatedId;
    }

    @Override
    public boolean update(Post post) {
        String sql = "UPDATE post SET category = ?, title = ?, thumbnail_url = ?, brief_info = ?, content = ?, category_id = ?, author = ?, published_at = ?, updated_at = ?, created_at = ?, status = ?, featured_flag = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, post.getCategory());           // category (chuỗi)
            statement.setString(2, post.getTitle());              // title
            statement.setString(3, post.getThumbnail_url());      // thumbnail_url
            statement.setString(4, post.getBrief_info());         // brief_info
            statement.setString(5, post.getContent());            // content
            statement.setInt(6, post.getCategory_id());           // category_id
            statement.setString(7, post.getAuthor());             // author (chuỗi)
            statement.setDate(8, post.getPublished_at());         // published_at
            statement.setDate(9, post.getUpdated_at());           // updated_at
            statement.setDate(10, post.getCreated_at());          // created_at
            statement.setString(11, post.getStatus());            // status
            statement.setInt(12, (post.getFeatured_flag() != null && post.getFeatured_flag()) ? 1 : 0);
            statement.setInt(13, post.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error update at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public boolean delete(Post post) {
        if (post == null || post.getId() == null) {
            return false;
        }
        return deleteById(post.getId());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM post WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteById at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    @Override
    public Post getFromResultSet(ResultSet resultSet) throws SQLException {
        return Post.builder()
                .id(resultSet.getInt("id"))
                .title(resultSet.getString("title"))
                .category(resultSet.getString("category"))
                .thumbnail_url(resultSet.getString("thumbnail_url"))
                .brief_info(resultSet.getString("brief_info"))
                .content(resultSet.getString("content"))
                .category_id(resultSet.getInt("category_id"))
                .author(resultSet.getString("author"))
                .published_at(resultSet.getDate("published_at"))
                .updated_at(resultSet.getDate("updated_at"))
                .created_at(resultSet.getDate("created_at"))
                .status(resultSet.getString("status"))
                .featured_flag(resultSet.getBoolean("featured_flag"))
                .build();
    }

    public List<Post> getHotPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE featured_flag = true ORDER BY published_at DESC LIMIT 5";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getHotPosts at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Post> getLatestPosts(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE status = 'published' ORDER BY published_at DESC LIMIT 2";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
//            statement.setInt(1, limit);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getLatestPosts at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Get posts with pagination sorted by updated date
     *
     * @param pageNumber The page number (1-based)
     * @param pageSize Number of posts per page
     * @return List of posts for the requested page
     */
    public List<Post> getPostsPaginated(int pageNumber, int pageSize) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post ORDER BY updated_at DESC LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, pageSize);
            statement.setInt(2, (pageNumber - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getPostsPaginated at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Count total number of posts
     *
     * @return Total number of posts
     */
    public int countTotalPosts() {
        String sql = "SELECT COUNT(*) FROM post";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countTotalPosts at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Get posts by category ID with pagination
     *
     * @param categoryId The category ID
     * @param pageNumber The page number (1-based)
     * @param pageSize Number of posts per page
     * @return List of posts for the requested category and page
     */
    public List<Post> getPostsByCategory(int categoryId, int pageNumber, int pageSize) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE category_id = ? ORDER BY updated_at DESC LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            statement.setInt(2, pageSize);
            statement.setInt(3, (pageNumber - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getPostsByCategory at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Count total number of posts in a category
     *
     * @param categoryId The category ID
     * @return Total number of posts in the category
     */
    public int countPostsByCategoryName(String category) {
        String sql = "SELECT COUNT(*) FROM post WHERE category = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countPostsByCategoryName at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Search posts with multiple criteria and pagination
     *
     * @param keyword The keyword to search for
     * @param searchTitle Whether to search in title
     * @param searchCategory Whether to search in category
     * @param searchBriefInfo Whether to search in brief info
     * @param searchDate Whether to search by date
     * @param startDate Start date for date range search (can be null)
     * @param endDate End date for date range search (can be null)
     * @param pageNumber The page number (1-based)
     * @param pageSize Number of posts per page
     * @return List of posts matching the search criteria
     */
    public List<Post> searchPosts(String keyword, boolean searchTitle, boolean searchCategory,
            boolean searchBriefInfo, boolean searchDate, Date startDate, Date endDate,
            int pageNumber, int pageSize) {

        List<Post> list = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT DISTINCT p.* FROM quiz_practice_su25.post p WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Add search conditions based on parameters
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append("AND (");
            List<String> conditions = new ArrayList<>();

            if (searchTitle) {
                conditions.add("LOWER(p.title) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (searchBriefInfo) {
                conditions.add("LOWER(p.brief_info) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (searchCategory) {
                conditions.add("LOWER(p.category) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (!conditions.isEmpty()) {
                sqlBuilder.append(String.join(" OR ", conditions));
            }
            sqlBuilder.append(")");

        }
        sqlBuilder.append("ORDER BY p.published_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((pageNumber - 1)* pageSize);

//        if (searchDate && startDate != null && endDate != null) {
//            sqlBuilder.append(" AND p.published_at BETWEEN ? AND ?");
//            params.add(startDate);
//            params.add(endDate);
//        }
//
//        // Add order by and pagination
//        sqlBuilder.append(" ORDER BY p.published_at DESC LIMIT ? OFFSET ?");
//        params.add(pageSize);
//        params.add((pageNumber - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Date) {
                    statement.setDate(i + 1, (Date) param);
                } else if (param instanceof Integer) {
                    statement.setInt(i + 1, (Integer) param);
                }
            }

            System.out.println("Executing SQL: " + sqlBuilder.toString());
            System.out.println("With params: " + params);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error searchPosts at class PostDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return list;
    }

    /**
     * Count total number of posts matching search criteria
     *
     * @param keyword The keyword to search for
     * @param searchTitle Whether to search in title
     * @param searchCategory Whether to search in category
     * @param searchBriefInfo Whether to search in brief info
     * @param searchDate Whether to search by date
     * @param startDate Start date for date range search (can be null)
     * @param endDate End date for date range search (can be null)
     * @return Total number of posts matching the search criteria
     */
    public int countSearchResults(String keyword, boolean searchTitle, boolean searchCategory,
            boolean searchBriefInfo, boolean searchDate, Date startDate, Date endDate) {

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT COUNT(DISTINCT p.id) FROM post p ");
        sqlBuilder.append("LEFT JOIN category c ON p.category_id = c.id ");
        sqlBuilder.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Add search conditions based on parameters
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append("AND (");
            List<String> conditions = new ArrayList<>();

            if (searchTitle) {
                conditions.add("LOWER(p.title) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (searchBriefInfo) {
                conditions.add("LOWER(p.brief_info) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (searchCategory) {
                conditions.add("LOWER(c.name) LIKE LOWER(?)");
                params.add("%" + keyword + "%");
            }

            if (!conditions.isEmpty()) {
                sqlBuilder.append(String.join(" OR ", conditions));
            }
            sqlBuilder.append(")");
        }

        if (searchDate && startDate != null && endDate != null) {
            sqlBuilder.append(" AND p.published_at BETWEEN ? AND ?");
            params.add(startDate);
            params.add(endDate);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Date) {
                    statement.setDate(i + 1, (Date) param);
                } else if (param instanceof Integer) {
                    statement.setInt(i + 1, (Integer) param);
                }
            }

            System.out.println("Executing count SQL: " + sqlBuilder.toString());
            System.out.println("With params: " + params);

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countSearchResults at class PostDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return 0;
    }

    /**
     * Get latest posts for sidebar
     *
     * @param limit Number of posts to retrieve
     * @return List of latest posts
     */
    public List<Post> getLatestPostsForSidebar(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post ORDER BY updated_at DESC LIMIT ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getLatestPostsForSidebar at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Get post details with author and category information for blog detail
     * page
     *
     * @param postId The post ID
     * @return Map containing post details, author information, and category
     * information
     */
    public Map<String, Object> getPostDetailsWithAuthorAndCategory(int postId) {
        Map<String, Object> result = new HashMap<>();
        String sql = "SELECT * FROM post WHERE id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, postId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                // Get post details
                Post post = getFromResultSet(resultSet);
                result.put("post", post);

                // Get author details
                Map<String, Object> author = new HashMap<>();
                author.put("name", post.getAuthor()); // Dùng author string
                result.put("author", author);

                // Get category details
                Map<String, Object> category = new HashMap<>();
                category.put("id", resultSet.getInt("category_id"));
                category.put("name", resultSet.getString("category_name"));
                result.put("category", category);
            }
        } catch (SQLException e) {
            System.out.println("Error getPostDetailsWithAuthorAndCategory at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }

        return result;
    }

    /**
     * Get related posts by category for blog detail page
     *
     * @param categoryId The category ID
     * @param currentPostId The current post ID to exclude
     * @param limit Number of related posts to retrieve
     * @return List of related posts
     */
    public List<Post> getPostsByCategoryName(String category, int pageNumber, int pageSize) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE category = ? ORDER BY updated_at DESC LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category);
            statement.setInt(2, pageSize);
            statement.setInt(3, (pageNumber - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getPostsByCategoryName at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Increment view count for a post
     *
     * @param postId The post ID
     * @return true if successful, false otherwise
     */
    public boolean incrementViewCount(int postId) {
        String sql = "UPDATE post SET view_count = COALESCE(view_count, 0) + 1 WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, postId);
            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error incrementViewCount at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return success;
    }

    /**
     * Find category name by category_id
     *
     * @param categoryId The category ID
     * @return Category name or "Uncategorized" if not found
     */
    public String findCategory(String categoryName) {
        if (categoryName == null || categoryName.trim().isEmpty()) {
            return "Uncategorized";
        }

        String sql = "SELECT p.category FROM post p WHERE p.category = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, categoryName.trim());

            System.out.println("Executing SQL: " + sql); // Debug log
            System.out.println("With category name: " + categoryName); // Debug log

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String foundCategory = resultSet.getString("category");
                System.out.println("Found category: " + foundCategory); // Debug log
                return foundCategory != null ? foundCategory : "Uncategorized";
            }
        } catch (SQLException e) {
            System.out.println("Error findCategory at class PostDAO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return "Uncategorized";
    }
}
