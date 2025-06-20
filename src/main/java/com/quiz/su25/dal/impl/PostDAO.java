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
        String sql = "INSERT INTO post (title,category, thumbnail_url,category, brief_info, content, category_id, author_id, published_at, updated_at, created_at, status, featured_flag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getCategory());
            statement.setString(3, post.getThumbnail_url());
            statement.setString(4, post.getBrief_info());
            statement.setString(5, post.getContent());
            statement.setInt(6, post.getCategory_id());
            statement.setInt(7, post.getAuthor_id());
            statement.setDate(8, post.getPublished_at());
            statement.setDate(9, post.getUpdated_at());
            statement.setDate(10, post.getCreated_at());
            statement.setString(11, post.getStatus());
            statement.setBoolean(12, post.getFeatured_flag());

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                generatedId = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error insert at class PostDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
        return generatedId;
    }

    @Override
    public boolean update(Post post) {
        String sql = "UPDATE post SET title = ?, thumbnail_url = ?, brief_info = ?, content = ?, category_id = ?, author_id = ?, published_at = ?, updated_at = ?, created_at = ?, status = ?, featured_flag = ? WHERE id = ?";
        boolean success = false;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, post.getTitle());
            statement.setString(2, post.getThumbnail_url());
            statement.setString(3, post.getBrief_info());
            statement.setString(4, post.getContent());
            statement.setInt(5, post.getCategory_id());
            statement.setInt(6, post.getAuthor_id());
            statement.setDate(7, post.getPublished_at());
            statement.setDate(8, post.getUpdated_at());
            statement.setDate(9, post.getCreated_at());
            statement.setString(10, post.getStatus());
            statement.setBoolean(11, post.getFeatured_flag());
            statement.setInt(12, post.getId());

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
                .author_id(resultSet.getInt("author_id"))
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
        String sql = "SELECT * FROM post WHERE featured_flag = 2 ORDER BY published_at DESC LIMIT ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
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
    public int countPostsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM post WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countPostsByCategory at class PostDAO: " + e.getMessage());
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
        String sql = "SELECT p.*, u.id as author_id, u.full_name as author_name, u.avatar_url as author_avatar, "
                + "c.id as category_id, c.name as category_name "
                + "FROM post p "
                + "JOIN users u ON p.author_id = u.id "
                + "JOIN category c ON p.category_id = c.id "
                + "WHERE p.id = ?";

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
                author.put("id", resultSet.getInt("author_id"));
                author.put("name", resultSet.getString("author_name"));
                author.put("avatar", resultSet.getString("author_avatar"));
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
    public List<Post> getRelatedPostsByCategory(int categoryId, int currentPostId, int limit) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM post WHERE category_id = ? AND id != ? ORDER BY updated_at DESC LIMIT ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            statement.setInt(2, currentPostId);
            statement.setInt(3, limit);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getRelatedPostsByCategory at class PostDAO: " + e.getMessage());
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
    public String findCategory(Integer categoryId) {
        if (categoryId == null) {
            return "Uncategorized";
        }

        String sql = "SELECT p.category FROM quiz_practice_su25.post p WHERE p.category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);

            System.out.println("Executing SQL: " + sql); // Debug log
            System.out.println("With category ID: " + categoryId); // Debug log

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String categoryName = resultSet.getString("category");
                System.out.println("Found category: " + categoryName); // Debug log
                return categoryName != null ? categoryName : "Uncategorized";
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
