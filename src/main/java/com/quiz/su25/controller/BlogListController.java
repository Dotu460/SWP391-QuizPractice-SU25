package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.CategoryDAO;
import com.quiz.su25.dal.impl.PostDAO;
import com.quiz.su25.entity.Category;
import com.quiz.su25.entity.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "BlogListController", urlPatterns = {"/blog"})
public class BlogListController extends HttpServlet {

    private PostDAO postDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters
        String searchQuery = request.getParameter("search");
        String categoryParam = request.getParameter("category");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String[] displayOptionsArray = request.getParameterValues("display");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        
        // Parse parameters with defaults
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
        Integer categoryId = (categoryParam != null && !categoryParam.isEmpty()) ? Integer.parseInt(categoryParam) : null;
        
        // Default display options
        List<String> displayOptions = new ArrayList<>();
        if (displayOptionsArray != null && displayOptionsArray.length > 0) {
            displayOptions = Arrays.asList(displayOptionsArray);
        } else {
            // Default to show all if no specific options selected
            displayOptions = Arrays.asList("title", "category", "brief_info", "date");
        }
        
        // Parse dates for search
        Date startDate = null;
        Date endDate = null;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        if (startDateParam != null && !startDateParam.isEmpty()) {
            try {
                startDate = new Date(dateFormat.parse(startDateParam).getTime());
            } catch (ParseException e) {
                System.out.println("Error parsing start date: " + e.getMessage());
            }
        }
        
        if (endDateParam != null && !endDateParam.isEmpty()) {
            try {
                endDate = new Date(dateFormat.parse(endDateParam).getTime());
            } catch (ParseException e) {
                System.out.println("Error parsing end date: " + e.getMessage());
            }
        }
        
        // Get posts based on search criteria
        List<Post> posts;
        int totalCount;
        List<Map<String, Object>> postsWithDetails = new ArrayList<>();
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Search posts
            boolean searchTitle = displayOptions.contains("title");
            boolean searchCategory = displayOptions.contains("category");
            boolean searchBriefInfo = displayOptions.contains("brief_info");
            boolean searchDate = displayOptions.contains("date");
            
            posts = postDAO.searchPosts(searchQuery.trim(), searchTitle, searchCategory, 
                                      searchBriefInfo, searchDate, startDate, endDate, page, pageSize);
            totalCount = postDAO.countSearchResults(searchQuery.trim(), searchTitle, searchCategory, 
                                                  searchBriefInfo, searchDate, startDate, endDate);
        } else if (categoryId != null) {
            // Filter by category
            posts = postDAO.getPostsByCategory(categoryId, page, pageSize);
            totalCount = postDAO.countPostsByCategory(categoryId);
        } else {
            // Get all posts with pagination
            posts = postDAO.getPostsPaginated(page, pageSize);
            totalCount = postDAO.countTotalPosts();
        }
        
        // Get additional details for each post (category name, author info)
        for (Post post : posts) {
            Map<String, Object> postDetails = new HashMap<>();
            postDetails.put("post", post);
            
            // Get category name
            if (post.getCategory_id() != null) {
                Category category = categoryDAO.findById(post.getCategory_id());
                postDetails.put("categoryName", category != null ? category.getName() : "Uncategorized");
            } else {
                postDetails.put("categoryName", "Uncategorized");
            }
            
            postsWithDetails.add(postDetails);
        }
        
        // Calculate pagination
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // Get categories with post counts for sidebar
        List<Map<String, Object>> categories = categoryDAO.getCategoriesWithPostCounts();
        
        // Get latest posts for sidebar
        List<Post> latestPosts = postDAO.getLatestPostsForSidebar(5);
        
        // Available display options
        List<String> availableDisplayOptions = Arrays.asList("title", "category", "brief_info", "date");
        
        // Set attributes for JSP
        request.setAttribute("posts", postsWithDetails);
        request.setAttribute("categories", categories);
        request.setAttribute("latestPosts", latestPosts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("displayOptions", displayOptions);
        request.setAttribute("availableDisplayOptions", availableDisplayOptions);
        request.setAttribute("startDate", startDateParam);
        request.setAttribute("endDate", endDateParam);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/blog_list/blog_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET to avoid form resubmission issues
        doGet(request, response);
    }
} 