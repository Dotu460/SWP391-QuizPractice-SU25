package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.CategoryDAO;
import com.quiz.su25.dal.impl.PostDAO;
import com.quiz.su25.entity.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        
        // Lấy parameter search từ request
        String searchQuery = request.getParameter("search");
        String categoryParam = request.getParameter("category");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String[] displayOptionsArray = request.getParameterValues("display");
        
        // Parse parameters with defaults
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
        String categoryName = categoryParam;        
        // Xử lý display options
        List<String> displayOptions = new ArrayList<>();
        if (displayOptionsArray != null && displayOptionsArray.length > 0) {
            displayOptions = Arrays.asList(displayOptionsArray);
        } else {
            // Nếu không có option nào được chọn, mặc định hiển thị tất cả
            displayOptions = Arrays.asList("title", "category", "brief_info", "date");
        }
        
        // Get posts based on search criteria
        List<Post> posts;
        int totalCount;
        List<Map<String, Object>> postsWithDetails = new ArrayList<>();
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Gọi method search từ PostDAO
            posts = postDAO.getPostsByCategoryName(categoryName, page, pageSize);
            totalCount = postDAO.countPostsByCategoryName(categoryName);
        } else if (categoryName != null) {
            // Filter by category
            posts = postDAO.getPostsByCategoryName(categoryName, page, pageSize);
            totalCount = postDAO.countPostsByCategoryName(categoryName);
        } else {
            // Get all posts with pagination
            posts = postDAO.getPostsPaginated(page, pageSize);
            totalCount = postDAO.countTotalPosts();
        }
        
        // Get additional details for each post
        for (Post post : posts) {
            Map<String, Object> postDetails = new HashMap<>();
            postDetails.put("post", post);
            
            // Get category name using the category_id
            postDetails.put("categoryName",post.getCategory());
            postsWithDetails.add(postDetails);
        }
        
        // Calculate pagination
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // Get latest posts for sidebar
        List<Post> latestPosts = postDAO.getLatestPostsForSidebar(5);
        
        // Set attributes for JSP
        request.setAttribute("posts", postsWithDetails);
        request.setAttribute("latestPosts", latestPosts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("categoryName", categoryName);
        request.setAttribute("displayOptions", displayOptions);
        
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