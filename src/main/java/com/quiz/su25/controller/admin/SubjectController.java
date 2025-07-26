package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.SubjectCategoriesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.MediaDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.SubjectCategories;
import com.quiz.su25.entity.Media;
import com.quiz.su25.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "SubjectController", urlPatterns = {"/admin/subjects", "/admin/subject/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 100,    // 100 MB
    maxRequestSize = 1024 * 1024 * 200  // 200 MB total
)
public class SubjectController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 8;
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final SubjectCategoriesDAO categoryDAO = new SubjectCategoriesDAO();
    private final PricePackageDAO packageDAO = new PricePackageDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MediaDAO mediaDAO = new MediaDAO();
    private final LessonDAO lessonDAO = new LessonDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/subjects")) {
            listSubjects(request, response);
        } else if (path.equals("/admin/subject")) {
            if (pathInfo != null && pathInfo.equals("/details")) {
                viewSubject(request, response);
            } else if (pathInfo != null && pathInfo.equals("/register")) {
                showRegistrationForm(request, response);
            } else if (pathInfo != null && pathInfo.equals("/new")) {
                showNewSubjectForm(request, response);
            } else if (pathInfo != null && pathInfo.equals("/edit")) {
                showEditSubjectForm(request, response);
            } else if (pathInfo != null && pathInfo.equals("/view")) {
                viewSubject(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/subject") && pathInfo != null && pathInfo.equals("/register")) {
            registerForSubject(request, response);
        } else if (path.equals("/admin/subject") && pathInfo != null && pathInfo.equals("/create")) {
            createSubject(request, response);
        } else if (path.equals("/admin/subject") && pathInfo != null && pathInfo.equals("/update")) {
            updateSubject(request, response);
        } else if (path.equals("/admin/subject") && pathInfo != null && pathInfo.equals("/delete")) {
            deleteSubject(request, response);
        } else if (path.equals("/admin/subject") && pathInfo != null && pathInfo.equals("/deleteMedia")) {
            deleteMedia(request, response);
        }
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

        // Get filter parameters
        String categoryFilter = request.getParameter("category");
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
//            statusFilter = "active"; // Default to active subjects if not specified
        }
        String searchTerm = request.getParameter("search");

        // Set default sort
        String sortBy = "updated_at";
        String sortOrder = "desc";

        // Get paginated subjects using the filters
        List<Subject> subjects = subjectDAO.getPaginatedSubjects(
                page, pageSize, categoryFilter, statusFilter, searchTerm, sortBy, sortOrder);

        // Get lesson counts for each subject
        Map<Integer, Integer> lessonCounts = new HashMap<>();
        for (Subject subject : subjects) {
            int count = lessonDAO.countLessonsBySubjectId(subject.getId());
            lessonCounts.put(subject.getId(), count);
        }

        // Get owner names for the subjects
        Map<Integer, String> ownerNames = new HashMap<>();
        for (Subject subject : subjects) {
            if (subject.getOwner_id() != null && !ownerNames.containsKey(subject.getOwner_id())) {
                User owner = userDAO.findById(subject.getOwner_id());
                if (owner != null) {
                    ownerNames.put(subject.getOwner_id(), owner.getFull_name());
                }
            }
        }
        request.setAttribute("ownerNames", ownerNames);
        request.setAttribute("lessonCounts", lessonCounts);

        // Get total count for pagination
        int totalSubjects = subjectDAO.countTotalSubjects(categoryFilter, statusFilter, searchTerm);
        int totalPages = (int) Math.ceil((double) totalSubjects / pageSize);

        // Get all categories for sidebar
        List<SubjectCategories> categories = categoryDAO.findAll();

        // Get featured subjects for sidebar (limit to 5)
        List<Subject> featuredSubjects = getFeaturedSubjects();

        // Get lowest price package for each subject
        Map<Integer, PricePackage> lowestPricePackages = getLowestPricePackages(subjects);

        // Get main thumbnails for each subject
        Map<Integer, Media> subjectThumbnails = new HashMap<>();
        for (Subject subject : subjects) {
            Media thumbnail = mediaDAO.findFirstImageBySubjectId(subject.getId());
            if (thumbnail != null) {
                subjectThumbnails.put(subject.getId(), thumbnail);
            }
        }

        // Set attributes for the view
        request.setAttribute("subjects", subjects);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSubjects", totalSubjects);
        request.setAttribute("categoryFilter", categoryFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categories", categories);
        request.setAttribute("featuredSubjects", featuredSubjects);
        request.setAttribute("lowestPricePackages", lowestPricePackages);
        request.setAttribute("subjectThumbnails", subjectThumbnails);

        // Forward to the view
        request.getRequestDispatcher("/view/admin/subject/list.jsp").forward(request, response);
    }

    private void viewSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                // Get all price packages for this subject
                List<PricePackage> subjectPricePackages = packageDAO.findBySubjectId(subjectId);
                
                // Get the lowest price package from all available packages (for backward compatibility)
                PricePackage lowestPricePackage = packageDAO.findLowestPricePackage();

                // Get the subject's category
                SubjectCategories category = categoryDAO.findById(subject.getCategory_id());

                // Get all categories for sidebar
                List<SubjectCategories> categories = categoryDAO.findAll();

                // Get featured subjects for sidebar
                List<Subject> featuredSubjects = getFeaturedSubjects();

                // Get media content for the subject
                List<Media> subjectMedia = mediaDAO.findBySubjectId(subjectId);
                List<Media> subjectImages = mediaDAO.findImagesBySubjectId(subjectId);
                List<Media> subjectVideos = mediaDAO.findVideosBySubjectId(subjectId);
                
                // Get main thumbnail and video for backward compatibility
                Media mainThumbnail = mediaDAO.findFirstImageBySubjectId(subjectId);
                Media mainVideo = mediaDAO.findFirstVideoBySubjectId(subjectId);

                // Get search term if any
                String searchTerm = request.getParameter("search");

                request.setAttribute("subject", subject);
                request.setAttribute("subjectPricePackages", subjectPricePackages);
                request.setAttribute("lowestPricePackage", lowestPricePackage);
                request.setAttribute("category", category);
                request.setAttribute("categories", categories);
                request.setAttribute("featuredSubjects", featuredSubjects);
                request.setAttribute("subjectMedia", subjectMedia);
                request.setAttribute("subjectImages", subjectImages);
                request.setAttribute("subjectVideos", subjectVideos);
                request.setAttribute("mainThumbnail", mainThumbnail);
                request.setAttribute("mainVideo", mainVideo);
                request.setAttribute("searchTerm", searchTerm);

                request.getRequestDispatcher("/view/admin/subject/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=invalidId");
        }
    }

    private void showRegistrationForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);
        int packageId = getIntParameter(request, "packageId", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                List<PricePackage> packages = packageDAO.findBySubjectId(subjectId);

                // If packageId is provided, pre-select that package
                PricePackage selectedPackage = null;
                if (packageId > 0) {
                    for (PricePackage pkg : packages) {
                        if (pkg.getId() == packageId) {
                            selectedPackage = pkg;
                            break;
                        }
                    }
                }

                request.setAttribute("subject", subject);
                request.setAttribute("packages", packages);
                request.setAttribute("selectedPackage", selectedPackage);

                request.getRequestDispatcher("/view/admin/subject/registration.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=invalidId");
        }
    }

    private void registerForSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This would connect to a registration or order service
        // For now, just implement basic functionality

        int subjectId = getIntParameter(request, "subjectId", 0);
        int packageId = getIntParameter(request, "packageId", 0);

        if (subjectId > 0 && packageId > 0) {
            // In a real application, you would:
            // 1. Verify the user is logged in
            // 2. Create an order/registration record
            // 3. Process payment if needed

            // For now, redirect with success message
            response.sendRedirect(request.getContextPath() +
                "/admin/subject/details?id=" + subjectId + "&success=registered");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=invalidData");
        }
    }

    private void showNewSubjectForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all categories for the form
        List<SubjectCategories> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        // Forward to the new subject form
        request.getRequestDispatcher("/view/admin/subject/new.jsp").forward(request, response);
    }

    private void createSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get form parameters
            String title = request.getParameter("title");
            String tagLine = request.getParameter("tag_line");
            String briefInfo = request.getParameter("brief_info");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String featuredFlag = request.getParameter("featured_flag");
            int categoryId = getIntParameter(request, "category_id", 0);
            String owner = request.getParameter("owner");
            int pricePackageId = getIntParameter(request, "price_package_id", 0); // Lấy thêm trường này

            // Validate required fields
            if (title == null || title.trim().isEmpty() || categoryId == 0) {
                request.getSession().setAttribute("errorMessage", "Course name and category are required!");
                response.sendRedirect(request.getContextPath() + "/admin/subject/new");
                return;
            }

            // Kiểm tra trùng tên course (không phân biệt hoa thường)
            if (subjectDAO.existsByTitle(title.trim())) {
                request.getSession().setAttribute("errorMessage", "Course name already exists! Please choose another name.");
                response.sendRedirect(request.getContextPath() + "/admin/subject/new");
                return;
            }

            if (owner == null || owner.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Course owner is required!");
                response.sendRedirect(request.getContextPath() + "/admin/subject/new");
                return;
            }

            // No need for thumbnail_url - using Media table for images

            // Create new subject
            Subject newSubject = Subject.builder()
                    .price_package_id(pricePackageId) // Bổ sung trường này
                    .title(title.trim())
                    .tag_line(tagLine != null ? tagLine.trim() : null)
                    .brief_info(briefInfo != null ? briefInfo.trim() : null)
                    .description(description != null ? description.trim() : null)
                    .thumbnail_url(null) // No longer using thumbnail_url - using Media table
                    .status(status != null ? status : "draft")
                    .featured_flag("on".equals(featuredFlag))
                    .category_id(categoryId)
                    .owner_id(1) // TODO: Get actual user ID from session
                    .created_at(new java.util.Date())
                    .updated_at(new java.util.Date())
                    .created_by(1) // TODO: Get from session
                    .updated_by(1) // TODO: Get from session
                    .build();

            // Insert the subject
            int newSubjectId = subjectDAO.insert(newSubject);

            if (newSubjectId > 0) {
                // Handle media uploads if files were provided
                handleMediaUploads(request, newSubjectId);
                
                request.getSession().setAttribute("successMessage", 
                    "Course '" + title + "' created successfully! You can add more media content using the rich text editor.");
                response.sendRedirect(request.getContextPath() + "/admin/subjects?success=created&id=" + newSubjectId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to create course. Please try again.");
                response.sendRedirect(request.getContextPath() + "/admin/subject/new");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/subject/new");
        }
    }

    /**
     * Handle multiple media uploads for a subject with notes
     */
    private void handleMediaUploads(HttpServletRequest request, int subjectId) {
        try {
            // Keep track of which indices have file uploads to avoid URL conflicts
            Set<String> processedImageIndices = new HashSet<>();
            Set<String> processedVideoIndices = new HashSet<>();
            
            // Handle multiple image uploads with notes
            Collection<Part> parts = request.getParts();
            
            for (Part part : parts) {
                String partName = part.getName();
                
                // Handle image uploads (image_0, image_1, etc.)
                if (partName != null && partName.startsWith("image_") && part.getSize() > 0) {
                    String imageIndex = partName.substring(6); // Extract index after "image_"
                    String imageFile = handleFileUpload(request, partName);
                    
                    if (imageFile != null) {
                        processedImageIndices.add(imageIndex);
                        
                        // Get corresponding notes for this image
                        String notes = request.getParameter("image_notes_" + imageIndex);
                        if (notes == null) notes = "";
                        
                        Media imageMedia = Media.builder()
                                .subjectId(subjectId)
                                .link(imageFile)
                                .type(0) // Image
                                .notes(notes.trim())
                                .build();
                        mediaDAO.insert(imageMedia);
                        
                        System.out.println("Successfully uploaded image file: " + imageFile + " for subject " + subjectId);
                    }
                }
                
                // Handle video uploads with notes (video_0, video_1, etc.)
                else if (partName != null && partName.startsWith("video_") && part.getSize() > 0) {
                    String videoIndex = partName.substring(6); // Extract index after "video_"
                    String videoFile = handleFileUpload(request, partName);
                    
                    if (videoFile != null) {
                        processedVideoIndices.add(videoIndex);
                        
                        // Get corresponding notes for this video
                        String notes = request.getParameter("video_notes_" + videoIndex);
                        if (notes == null) notes = "";
                        
                        Media videoMedia = Media.builder()
                                .subjectId(subjectId)
                                .link(videoFile)
                                .type(1) // Video
                                .notes(notes.trim())
                                .build();
                        mediaDAO.insert(videoMedia);
                        
                        System.out.println("Successfully uploaded video file: " + videoFile + " for subject " + subjectId);
                    }
                }
            }
            
            // Handle media URLs (only for indices that don't have file uploads)
            handleMediaUrls(request, subjectId, processedImageIndices, processedVideoIndices);
            
        } catch (Exception e) {
            System.out.println("Error handling media uploads: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Handle media URLs submitted from the form (only for indices without file uploads)
     */
    private void handleMediaUrls(HttpServletRequest request, int subjectId, Set<String> processedImageIndices, Set<String> processedVideoIndices) {
        try {
            // Handle video URLs with notes (only for indices that don't have file uploads)
            int videoUrlIndex = 0;
            while (true) {
                String videoUrl = request.getParameter("video_url_" + videoUrlIndex);
                String indexStr = String.valueOf(videoUrlIndex);
                
                // Only process URL if no file was uploaded for this index
                if (videoUrl != null && !videoUrl.trim().isEmpty() && !processedVideoIndices.contains(indexStr)) {
                    String notes = request.getParameter("video_notes_" + videoUrlIndex);
                    if (notes == null) notes = "";
                    
                    Media videoMedia = Media.builder()
                            .subjectId(subjectId)
                            .link(videoUrl.trim())
                            .type(1) // Video
                            .notes(notes.trim())
                            .build();
                    mediaDAO.insert(videoMedia);
                    
                    System.out.println("Successfully added video URL: " + videoUrl + " for subject " + subjectId);
                } else if (videoUrl == null || videoUrl.trim().isEmpty()) {
                    // Stop when we reach the first empty URL parameter
                    break;
                }
                
                videoUrlIndex++;
            }
            
        } catch (Exception e) {
            System.out.println("Error handling media URLs: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handle file upload for images and videos
     */
    private String handleFileUpload(HttpServletRequest request, String fieldName) {
        try {
            Part filePart = request.getPart(fieldName);
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    System.out.println("Processing file upload: " + fileName + " (size: " + filePart.getSize() + " bytes)");
                    
                    // Create a unique filename
                    String timestamp = String.valueOf(System.currentTimeMillis());
                    String extension = "";
                    if (fileName.contains(".")) {
                        extension = fileName.substring(fileName.lastIndexOf("."));
                    }
                    String uniqueFileName = timestamp + "_" + fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
                    
                    // Create upload directory if it doesn't exist
                    String uploadPath = request.getServletContext().getRealPath("/media");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    
                    System.out.println("Upload directory path: " + uploadPath);
                    
                    if (!uploadDir.exists()) {
                        boolean created = uploadDir.mkdirs();
                        System.out.println("Created upload directory: " + created);
                    } else {
                        System.out.println("Upload directory already exists");
                    }
                    
                    // Save the file
                    String filePath = uploadPath + java.io.File.separator + uniqueFileName;
                    filePart.write(filePath);
                    
                    // Verify file was written
                    java.io.File savedFile = new java.io.File(filePath);
                    if (savedFile.exists()) {
                        System.out.println("File saved successfully: " + filePath + " (size: " + savedFile.length() + " bytes)");
                        
                        // Return the web-accessible URL
                        String webUrl = request.getContextPath() + "/media/" + uniqueFileName;
                        System.out.println("Returning web URL: " + webUrl);
                        return webUrl;
                    } else {
                        System.err.println("Failed to save file: " + filePath);
                        return null;
                    }
                }
            } else {
                System.out.println("No file part found for field: " + fieldName + " or file is empty");
            }
        } catch (Exception e) {
            System.err.println("Error handling file upload for " + fieldName + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Extract filename from Part header
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private void showEditSubjectForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                // Get all categories for the form
                List<SubjectCategories> categories = categoryDAO.findAll();
                
                // Get existing media for the subject
                List<Media> subjectMedia = mediaDAO.findBySubjectId(subjectId);
                List<Media> subjectImages = mediaDAO.findImagesBySubjectId(subjectId);
                List<Media> subjectVideos = mediaDAO.findVideosBySubjectId(subjectId);

                request.setAttribute("subject", subject);
                request.setAttribute("categories", categories);
                request.setAttribute("subjectMedia", subjectMedia);
                request.setAttribute("subjectImages", subjectImages);
                request.setAttribute("subjectVideos", subjectVideos);

                request.getRequestDispatcher("/view/admin/subject/edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=invalidId");
        }
    }

    private void updateSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int subjectId = getIntParameter(request, "id", 0);
            
            if (subjectId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid subject ID!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            }

            // Get the existing subject
            Subject existingSubject = subjectDAO.findById(subjectId);
            if (existingSubject == null) {
                request.getSession().setAttribute("errorMessage", "Subject not found!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            }

            // Get form parameters
            String title = request.getParameter("title");
            String tagLine = request.getParameter("tag_line");
            String briefInfo = request.getParameter("brief_info");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String featuredFlag = request.getParameter("featured_flag");
            int categoryId = getIntParameter(request, "category_id", 0);

            // Validate required fields
            if (title == null || title.trim().isEmpty() || categoryId == 0) {
                request.getSession().setAttribute("errorMessage", "Course name and category are required!");
                response.sendRedirect(request.getContextPath() + "/admin/subject/edit?id=" + subjectId);
                return;
            }

            // Check if title already exists for another subject
            if (!title.trim().equalsIgnoreCase(existingSubject.getTitle()) && subjectDAO.existsByTitle(title.trim())) {
                request.getSession().setAttribute("errorMessage", "Course name already exists! Please choose another name.");
                response.sendRedirect(request.getContextPath() + "/admin/subject/edit?id=" + subjectId);
                return;
            }

            // Update the subject
            Subject updatedSubject = Subject.builder()
                    .id(subjectId)
                    .title(title.trim())
                    .tag_line(tagLine != null ? tagLine.trim() : null)
                    .brief_info(briefInfo != null ? briefInfo.trim() : null)
                    .description(description != null ? description.trim() : null)
                    .thumbnail_url(existingSubject.getThumbnail_url()) // Keep existing thumbnail_url
                    .status(status != null ? status : "draft")
                    .featured_flag("on".equals(featuredFlag))
                    .category_id(categoryId)
                    .owner_id(existingSubject.getOwner_id()) // Keep existing owner
                    .created_at(existingSubject.getCreated_at()) // Keep original creation date
                    .updated_at(new java.util.Date()) // Update modification date
                    .created_by(existingSubject.getCreated_by()) // Keep original creator
                    .updated_by(1) // TODO: Get from session
                    .build();

            // Update the subject
            boolean success = subjectDAO.update(updatedSubject);

            if (success) {
                // Clear existing media for this subject before adding new ones
                // This prevents accumulation of old/invalid media
                System.out.println("Clearing existing media for subject ID: " + subjectId);
                boolean deleted = mediaDAO.deleteBySubjectId(subjectId);
                System.out.println("Media deletion result: " + deleted);
                
                // Handle media uploads if files were provided
                handleMediaUploads(request, subjectId);
                
                request.getSession().setAttribute("successMessage", 
                    "Course '" + title + "' updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects?success=updated&id=" + subjectId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update course. Please try again.");
                response.sendRedirect(request.getContextPath() + "/admin/subject/edit?id=" + subjectId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/subjects");
        }
    }

    private void deleteSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int subjectId = getIntParameter(request, "id", 0);
            
            if (subjectId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid subject ID!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            }

            // Get the subject to delete
            Subject subject = subjectDAO.findById(subjectId);
            if (subject == null) {
                request.getSession().setAttribute("errorMessage", "Subject not found!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            }

            // Check for active registrations
            int activeRegistrations = registrationDAO.countActiveRegistrationsBySubjectId(subjectId);
            if (activeRegistrations > 0) {
                request.getSession().setAttribute("errorMessage", 
                    "Cannot delete course '" + subject.getTitle() + "' because it has " + 
                    activeRegistrations + " active registration(s). Please deactivate or transfer these registrations first.");
                response.sendRedirect(request.getContextPath() + "/admin/subjects?error=hasActiveRegistrations");
                return;
            }

            // Delete associated media first
            boolean mediaDeleted = mediaDAO.deleteBySubjectId(subjectId);
            if (!mediaDeleted) {
                System.out.println("Failed to delete media for subject ID: " + subjectId);
                request.getSession().setAttribute("errorMessage", "Failed to delete associated media files. Course deletion aborted.");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            } else {
                System.out.println("Successfully deleted all media for subject ID: " + subjectId);
            }

            // Proceed with deletion
            boolean success = subjectDAO.delete(subject);

            if (success) {
                request.getSession().setAttribute("successMessage", 
                    "Course '" + subject.getTitle() + "' deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/subjects?success=deleted");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete course. Please try again.");
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/subjects");
        }
    }

    private void deleteMedia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String mediaIdStr = request.getParameter("mediaId");
            if (mediaIdStr == null || mediaIdStr.trim().isEmpty()) {
                response.getWriter().write("error");
                return;
            }

            int mediaId = Integer.parseInt(mediaIdStr);
            
            // Get the media record first
            Media media = mediaDAO.findById(mediaId);
            if (media == null) {
                response.getWriter().write("error");
                return;
            }

            // Delete the media record from database
            boolean deleted = mediaDAO.delete(media);
            
            if (deleted) {
                // Optionally delete the physical file if it's a local file
                String link = media.getLink();
                if (link != null && link.contains("/media/")) {
                    try {
                        String fileName = link.substring(link.lastIndexOf("/") + 1);
                        String filePath = request.getServletContext().getRealPath("/media/" + fileName);
                        java.io.File file = new java.io.File(filePath);
                        if (file.exists()) {
                            file.delete();
                            System.out.println("Deleted physical file: " + filePath);
                        }
                    } catch (Exception e) {
                        System.out.println("Could not delete physical file: " + e.getMessage());
                        // Continue anyway, database record is deleted
                    }
                }
                
                response.getWriter().write("success");
                System.out.println("Successfully deleted media ID: " + mediaId);
            } else {
                response.getWriter().write("error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

    /**
     * Clean up invalid media records for a subject
     * Removes media records where the linked file doesn't exist
     */
    private void cleanupInvalidMedia(int subjectId) {
        try {
            List<Media> allMedia = mediaDAO.findBySubjectId(subjectId);
            for (Media media : allMedia) {
                String link = media.getLink();
                if (link != null && link.startsWith("/")) {
                    // This is a local file, check if it exists
                    String realPath = link.replace("/media/", "");
                    // Could add file existence check here if needed
                }
            }
        } catch (Exception e) {
            System.out.println("Error cleaning up invalid media: " + e.getMessage());
        }
    }

    // In SubjectController
    private List<Subject> getFeaturedSubjects() {
        return subjectDAO.getFeaturedSubjects();
    }

    private Map<Integer, PricePackage> getLowestPricePackages(List<Subject> subjects) {
        Map<Integer, PricePackage> lowestPricePackages = new HashMap<>();
        
        // Get the lowest price package from all packages
        PricePackage lowestPricePackage = packageDAO.findLowestPricePackage();
        
        // Assign the same lowest price package to all subjects
        if (lowestPricePackage != null) {
            for (Subject subject : subjects) {
                lowestPricePackages.put(subject.getId(), lowestPricePackage);
            }
        }

        return lowestPricePackages;
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    public static void main(String[] args) {
        // Create test instances
        SubjectDAO subjectDAO = new SubjectDAO();
        UserDAO userDAO = new UserDAO();

        // Get some subjects to test with (or create mock subjects)
        List<Subject> subjects = subjectDAO.findAll();

        // Create and populate the ownerNames map
        Map<Integer, String> ownerNames = new HashMap<>();
        for (Subject subject : subjects) {
            if (subject.getOwner_id() != null && !ownerNames.containsKey(subject.getOwner_id())) {
                User owner = userDAO.findById(subject.getOwner_id());
                if (owner != null) {
                    ownerNames.put(subject.getOwner_id(), owner.getFull_name());
                    System.out.println("Added owner: ID=" + subject.getOwner_id() +
                            ", Name=" + owner.getFull_name());
                } else {
                    System.out.println("Owner not found for ID: " + subject.getOwner_id());
                }
            } else if (subject.getOwner_id() != null) {
                System.out.println("Owner ID " + subject.getOwner_id() +
                        " already in map with name: " + ownerNames.get(subject.getOwner_id()));
            } else {
                System.out.println("Subject has null owner_id: " + subject.getTitle());
            }
        }

        // Print the final map contents
        System.out.println("\n--- Final Owner Names Map ---");
        if (ownerNames.isEmpty()) {
            System.out.println("Map is empty!");
        } else {
            for (Map.Entry<Integer, String> entry : ownerNames.entrySet()) {
                System.out.println("Owner ID: " + entry.getKey() + ", Name: " + entry.getValue());
            }
        }

        // Print how many unique owners were found
        System.out.println("\nTotal unique owners: " + ownerNames.size());
    }

}