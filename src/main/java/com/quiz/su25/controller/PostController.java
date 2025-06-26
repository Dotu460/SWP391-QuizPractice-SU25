/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.PostDAO;
import com.quiz.su25.entity.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PostController", urlPatterns = {"/post"})
public class PostController extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Log 1: Kiểm tra controller có được gọi không
//            System.out.println("PostController is called");

            String postId = request.getParameter("id");
//            // Log 2: Kiểm tra ID nhận được
//            System.out.println("Received post ID: " + postId);

            Post post = postDAO.findById(Integer.parseInt(postId));
            List<Post> latestPosts = postDAO.getLatestPostsForSidebar(5);
//            String contentUrl = post.getContent();
//            response.sendRedirect(contentUrl);
            request.setAttribute("post", post);
            request.setAttribute("latestPosts", latestPosts);
            request.getRequestDispatcher("/view/post/post.jsp").forward(request, response);
//            // Log 3: Kiểm tra post có được tìm thấy không
//            System.out.println("Found post: " + (post != null));
//            if (post != null) {
//                System.out.println("Post title: " + post.getTitle());
//            }
//
//            request.setAttribute("post", post);
//            // Log 4: Kiểm tra đường dẫn JSP
//            System.out.println("Forwarding to: /view/post/post.jsp");
//
//            request.getRequestDispatcher("/view/post/post.jsp").forward(request, response);
        } catch (Exception e) {
            // Log 5: In ra lỗi nếu có
//            System.out.println("Error in PostController: ");
            e.printStackTrace();
        }
    }
}
