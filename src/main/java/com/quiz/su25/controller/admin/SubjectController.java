package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.SubjectCategoriesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.MediaDAO;
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
import java.util.List;
import java.util.Map;

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
            statusFilter = "active"; // Default to active subjects if not specified
        }
        String searchTerm = request.getParameter("search");

        // Set default sort
        String sortBy = "updated_at";
        String sortOrder = "desc";

        // Get paginated subjects using the filters
        List<Subject> subjects = subjectDAO.getPaginatedSubjects(
                page, pageSize, categoryFilter, statusFilter, searchTerm, sortBy, sortOrder);

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
                // Get the lowest price package from all available packages
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

            // Validate required fields
            if (title == null || title.trim().isEmpty() || categoryId == 0) {
                request.getSession().setAttribute("errorMessage", "Course name and category are required!");
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
            // Handle multiple image uploads with notes
            Collection<Part> parts = request.getParts();
            
            for (Part part : parts) {
                String partName = part.getName();
                
                // Handle image uploads (image_0, image_1, etc.)
                if (partName != null && partName.startsWith("image_") && part.getSize() > 0) {
                    String imageIndex = partName.substring(6); // Extract index after "image_"
                    String imageFile = handleFileUpload(request, partName);
                    
                    if (imageFile != null) {
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
                    }
                }
                
                // Handle video uploads with notes (video_0, video_1, etc.)
                else if (partName != null && partName.startsWith("video_") && part.getSize() > 0) {
                    String videoIndex = partName.substring(6); // Extract index after "video_"
                    String videoFile = handleFileUpload(request, partName);
                    
                    if (videoFile != null) {
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
                    }
                }
            }
            
            // Also handle any media URLs with notes from the rich text editor
            handleMediaUrls(request, subjectId);
            
        } catch (Exception e) {
            System.out.println("Error handling media uploads: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Handle media URLs submitted from the form (from TinyMCE or direct URLs)
     */
    private void handleMediaUrls(HttpServletRequest request, int subjectId) {
        try {
            // Handle image URLs with notes
            int imageUrlIndex = 0;
            while (true) {
                String imageUrl = request.getParameter("image_url_" + imageUrlIndex);
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    break;
                }
                
                String notes = request.getParameter("image_url_notes_" + imageUrlIndex);
                if (notes == null) notes = "";
                
                Media imageMedia = Media.builder()
                        .subjectId(subjectId)
                        .link(imageUrl.trim())
                        .type(0) // Image
                        .notes(notes.trim())
                        .build();
                mediaDAO.insert(imageMedia);
                imageUrlIndex++;
            }
            
            // Handle video URLs with notes
            int videoUrlIndex = 0;
            while (true) {
                String videoUrl = request.getParameter("video_url_" + videoUrlIndex);
                if (videoUrl == null || videoUrl.trim().isEmpty()) {
                    break;
                }
                
                String notes = request.getParameter("video_notes_" + videoUrlIndex);
                if (notes == null) notes = "";
                
                Media videoMedia = Media.builder()
                        .subjectId(subjectId)
                        .link(videoUrl.trim())
                        .type(1) // Video
                        .notes(notes.trim())
                        .build();
                mediaDAO.insert(videoMedia);
                videoUrlIndex++;
            }
            
        } catch (Exception e) {
            System.out.println("Error handling media URLs: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handle file upload for main thumbnail or video
     */
    private String handleFileUpload(HttpServletRequest request, String fieldName) {
        try {
            Part filePart = request.getPart(fieldName);
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Create a unique filename
                    String timestamp = String.valueOf(System.currentTimeMillis());
                    String extension = "";
                    if (fileName.contains(".")) {
                        extension = fileName.substring(fileName.lastIndexOf("."));
                    }
                    String uniqueFileName = timestamp + "_" + fileName.replaceAll("[^a-zA-Z0-9.]", "_");
                    
                    // Create upload directory if it doesn't exist
                    String uploadPath = request.getServletContext().getRealPath("/media");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Save the file
                    String filePath = uploadPath + java.io.File.separator + uniqueFileName;
                    filePart.write(filePath);
                    
                    // Return the web-accessible URL
                    return "/media/" + uniqueFileName;
                }
            }
        } catch (Exception e) {
            System.out.println("Error handling file upload for " + fieldName + ": " + e.getMessage());
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