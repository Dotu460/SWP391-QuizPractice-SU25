/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quiz.su25.controller.Expert;

import com.quiz.su25.dal.impl.*;
import com.quiz.su25.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.io.File;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

@WebServlet(name = "QuestionListController", urlPatterns = {"/questions-list", "/upload-media"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class QuestionListController extends HttpServlet {
   
    private static final String LIST_PAGE = "view/Expert/Question/questions-list.jsp";
    private static final String UPLOAD_DIRECTORY = "uploads/media";
    private QuestionDAO questionDAO;
    private QuestionOptionDAO questionOptionDAO;
    private SubjectDAO subjectDAO;
    private LessonDAO lessonDAO;
    private QuizzesDAO quizzesDAO;

    @Override
    public void init() throws ServletException {
        questionDAO = new QuestionDAO();
        questionOptionDAO = new QuestionOptionDAO();
        subjectDAO = new SubjectDAO();
        lessonDAO = new LessonDAO();
        quizzesDAO = new QuizzesDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet QuestionListController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuestionListController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                showAddQuestionForm(request, response);
                break;
            case "edit":
                editQuestion(request, response);
                break;
            case "downloadTemplate":
                downloadTemplate(request, response);
                break;
            case "list":
            default:
                listQuestions(request, response);
                break;
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/upload-media".equals(path)) {
            handleMediaUpload(request, response);
            return;
        }

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "import":
                importFromExcel(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            case "hide":
            case "activate":
                toggleQuestionStatus(request, response);
                break;
            default:
                saveQuestion(request, response);
                break;
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get and validate filter parameters
            String content = request.getParameter("content");
            if (content != null && content.trim().isEmpty()) {
                content = null;
            }

            String status = request.getParameter("status");
            if (status != null && status.trim().isEmpty()) {
                status = null;
            }

            // Parse IDs if provided
            Integer subjectId = null;
            Integer lessonId = null;
            Integer quizId = null;

            try {
                String subjectIdStr = request.getParameter("subjectId");
                if (subjectIdStr != null && !subjectIdStr.trim().isEmpty() && !"0".equals(subjectIdStr)) {
                    subjectId = Integer.parseInt(subjectIdStr);
                }

                String lessonIdStr = request.getParameter("lessonId");
                if (lessonIdStr != null && !lessonIdStr.trim().isEmpty() && !"0".equals(lessonIdStr)) {
                    lessonId = Integer.parseInt(lessonIdStr);
                }

                String quizIdStr = request.getParameter("quizId");
                if (quizIdStr != null && !quizIdStr.trim().isEmpty() && !"0".equals(quizIdStr)) {
                    quizId = Integer.parseInt(quizIdStr);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid ID format: " + e.getMessage());
            }

            // Get total records count
            int totalRecords = questionDAO.getTotalFilteredQuestions(content, subjectId, lessonId, quizId, status);

            // Handle records per page
            int recordsPerPage = totalRecords;
            String recordsPerPageStr = request.getParameter("recordsPerPage");
            if (recordsPerPageStr != null && !recordsPerPageStr.trim().isEmpty()) {
                try {
                    recordsPerPage = Integer.parseInt(recordsPerPageStr);
                    if (recordsPerPage < 1) {
                        recordsPerPage = totalRecords;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Invalid records per page format: " + e.getMessage());
                }
            }

            // Handle pagination
            int currentPage = (recordsPerPage == totalRecords) ? 1 : 1;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty() && recordsPerPage != totalRecords) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid page number format: " + e.getMessage());
            }

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            if (totalPages == 0) {
                totalPages = 1;
            }
            if (currentPage < 1) {
                currentPage = 1;
            } else if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            // Get filtered questions with pagination
            List<Question> questionsList = questionDAO.findQuestionsWithFilters(
                content, subjectId, lessonId, quizId, status, currentPage, recordsPerPage
            );

            // Get all data for dropdowns
            List<Subject> subjectsList = subjectDAO.findAll();
            List<Lesson> lessonsList = lessonDAO.findAll();
            List<Quizzes> quizzesList = quizzesDAO.findAll();

            // Set attributes for the view
            request.setAttribute("questionsList", questionsList);
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("lessonsList", lessonsList);
            request.setAttribute("quizzesList", quizzesList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("content", content);
            request.setAttribute("subjectId", subjectId);
            request.setAttribute("lessonId", lessonId);
            request.setAttribute("quizId", quizId);
            request.setAttribute("status", status);
            request.setAttribute("lessonDAO", lessonDAO);
            request.setAttribute("subjectDAO", subjectDAO);
            request.setAttribute("quizDAO", quizzesDAO);

            // Forward to the list page
            request.getRequestDispatcher(LIST_PAGE).forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in QuestionListController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher(LIST_PAGE).forward(request, response);
        }
    }

    private void toggleQuestionStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String action = request.getParameter("action");
            String newStatus = "activate".equals(action) ? "active" : "hidden";

            Question question = questionDAO.findById(questionId);
            if (question != null) {
                question.setStatus(newStatus);
                boolean updated = questionDAO.update(question);
                
                if (updated) {
                    request.getSession().setAttribute("successMessage", "Question status updated successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to update question status!");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Question not found!");
            }

            // Preserve filter state after update
            StringBuilder redirectURL = new StringBuilder(request.getContextPath()).append("/questions-list");
            List<String> params = new ArrayList<>();

            // Add filter parameters if they exist
            String page = request.getParameter("page");
            String content = request.getParameter("content");
            String subjectId = request.getParameter("subjectId");
            String lessonId = request.getParameter("lessonId");
            String quizId = request.getParameter("quizId");
            String status = request.getParameter("status");

            if (page != null && !page.isEmpty()) {
                params.add("page=" + page);
            }
            if (content != null && !content.isEmpty()) {
                params.add("content=" + URLEncoder.encode(content, "UTF-8"));
            }
            if (subjectId != null && !subjectId.isEmpty() && !"0".equals(subjectId)) {
                params.add("subjectId=" + subjectId);
            }
            if (lessonId != null && !lessonId.isEmpty() && !"0".equals(lessonId)) {
                params.add("lessonId=" + lessonId);
            }
            if (quizId != null && !quizId.isEmpty() && !"0".equals(quizId)) {
                params.add("quizId=" + quizId);
            }
            if (status != null && !status.isEmpty()) {
                params.add("status=" + URLEncoder.encode(status, "UTF-8"));
            }

            // Add parameters to URL
            if (!params.isEmpty()) {
                redirectURL.append("?").append(String.join("&", params));
            }

            // Redirect back to list with preserved filters
            response.sendRedirect(redirectURL.toString());

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid question ID!");
            response.sendRedirect(request.getContextPath() + "/questions-list");
        }
    }

    private void showAddQuestionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all data for dropdowns
            List<Subject> subjectsList = subjectDAO.findAll();
            List<Lesson> lessonsList = lessonDAO.findAll();
            List<Quizzes> quizzesList = quizzesDAO.findAll();
            
            // Set attributes for JSP
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("lessonsList", lessonsList);
            request.setAttribute("quizzesList", quizzesList);
            
            // Forward to the add question page
            request.getRequestDispatcher("view/Expert/Question/addQuestion.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in showAddQuestionForm: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the page.");
            request.getRequestDispatcher("view/Expert/Question/addQuestion.jsp").forward(request, response);
        }
    }

    private void editQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionId = request.getParameter("id");
        if (questionId == null || questionId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Question ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/questions-list");
            return;
        }
        try {
            int questionIdInt = Integer.parseInt(questionId);
            Question question = questionDAO.findById(questionIdInt);
            if (question == null) {
                request.getSession().setAttribute("toastMessage", "Question not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/questions-list");
                return;
            }
            // Lấy danh sách đáp án
            List<QuestionOption> options = questionOptionDAO.findByQuestionId(questionIdInt);
            question.setQuestionOptions(options);
            // Lấy danh sách quiz cho dropdown
            List<Quizzes> quizzesList = quizzesDAO.findAll();
            request.setAttribute("question", question);
            request.setAttribute("quizzesList", quizzesList);
            // Forward tới trang edit
            request.getRequestDispatcher("/view/Expert/Question/question-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid question ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/questions-list");
        }
    }

    private void importFromExcel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Part filePart = request.getPart("excelFile");
            if (filePart == null || filePart.getSize() == 0) {
                request.getSession().setAttribute("toastMessage", "Please select an Excel file to import.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/questions-list");
                return;
            }

            String fileName = filePart.getSubmittedFileName();
            if (!isValidExcelFile(fileName)) {
                request.getSession().setAttribute("toastMessage", "Invalid file format. Only .xlsx or .xls files are accepted.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/questions-list");
                return;
            }

            List<Question> questions = parseExcelFile(filePart.getInputStream(), fileName);
            List<String> errors = validateQuestions(questions);

            if (!errors.isEmpty()) {
                String errorMessage = "Data validation errors: " + String.join(", ", errors);
                request.getSession().setAttribute("toastMessage", errorMessage);
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/questions-list");
                return;
            }

            int successCount = 0;
            int errorCount = 0;
            int duplicateCount = 0;
            List<String> importErrors = new ArrayList<>();

            for (Question question : questions) {
                try {
                    // Check if question with same content already exists
                    List<Question> existingQuestions = questionDAO.findByContent(question.getContent());
                    if (!existingQuestions.isEmpty()) {
                        duplicateCount++;
                        importErrors.add("Duplicate question found: " + question.getContent());
                        continue;
                    }

                    int result = questionDAO.insert(question);
                    if (result > 0) { // Check if insert was successful (returns the new ID)
                        successCount++;
                    } else {
                        errorCount++;
                        importErrors.add("Failed to add question: " + question.getContent());
                    }
                } catch (Exception e) {
                    errorCount++;
                    importErrors.add("Error adding question: " + e.getMessage());
                }
            }

            String message = "Import completed: " + successCount + " successful, " + errorCount + " failed, " + duplicateCount + " duplicates.";
            if (!importErrors.isEmpty() && importErrors.size() <= 5) {
                message += " Error details: " + String.join("; ", importErrors);
            }

            request.getSession().setAttribute("toastMessage", message);
            request.getSession().setAttribute("toastType", successCount > 0 ? "success" : "error");

        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error during import: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/questions-list");
    }

    private boolean isValidExcelFile(String fileName) {
        if (fileName == null) return false;
        String lowercaseFileName = fileName.toLowerCase();
        return lowercaseFileName.endsWith(".xlsx") || lowercaseFileName.endsWith(".xls");
    }

    private List<Question> parseExcelFile(InputStream inputStream, String fileName) throws IOException {
        List<Question> questions = new ArrayList<>();
        Workbook workbook = null;

        try {
            if (fileName.toLowerCase().endsWith(".xlsx")) {
                workbook = new XSSFWorkbook(inputStream);
            } else {
                workbook = new HSSFWorkbook(inputStream);
            }

            Sheet sheet = workbook.getSheetAt(0);
            
            // Skip header row (row 0)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null || isEmptyRow(row)) continue;

                try {
                    Question question = parseRowToQuestion(row);
                    if (question != null) {
                        questions.add(question);
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing row " + (i + 1) + ": " + e.getMessage());
                }
            }
        } finally {
            if (workbook != null) {
                workbook.close();
            }
        }
        return questions;
    }

    private boolean isEmptyRow(Row row) {
        for (int i = 0; i < 7; i++) { // Check first 7 columns
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK && 
                !getCellValueAsString(cell).trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }

    private Question parseRowToQuestion(Row row) {
        Integer quizId = getCellValueAsInteger(row.getCell(0));
        String type = getCellValueAsString(row.getCell(1));
        String content = getCellValueAsString(row.getCell(2));
        String mediaUrl = getCellValueAsString(row.getCell(3));
        String level = getCellValueAsString(row.getCell(4));
        String status = getCellValueAsString(row.getCell(5));
        String explanation = getCellValueAsString(row.getCell(6));

        return Question.builder()
                .quiz_id(quizId)
                .type(type)
                .content(content)
                .media_url(mediaUrl)
                .level(level)
                .status(status != null && !status.isEmpty() ? status : "active")
                .explanation(explanation)
                .build();
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    return String.valueOf((long) cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }

    private Integer getCellValueAsInteger(Cell cell) {
        if (cell == null) return null;
        
        try {
            switch (cell.getCellType()) {
                case NUMERIC:
                    return (int) cell.getNumericCellValue();
                case STRING:
                    String value = cell.getStringCellValue().trim();
                    return value.isEmpty() ? null : Integer.parseInt(value);
                default:
                    return null;
            }
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<String> validateQuestions(List<Question> questions) {
        List<String> errors = new ArrayList<>();
        
        for (int i = 0; i < questions.size(); i++) {
            Question question = questions.get(i);
            int rowNum = i + 2; // +2 because Excel starts from 1 and we skip header
            
            if (question.getQuiz_id() == null) {
                errors.add("Row " + rowNum + ": Quiz ID is required");
            }
            
            if (question.getType() == null || question.getType().trim().isEmpty()) {
                errors.add("Row " + rowNum + ": Question type is required");
            }
            
            if (question.getContent() == null || question.getContent().trim().isEmpty()) {
                errors.add("Row " + rowNum + ": Question content is required");
            }
            
            if (question.getLevel() == null || question.getLevel().trim().isEmpty()) {
                errors.add("Row " + rowNum + ": Question level is required");
            }
        }
        
        return errors;
    }

    private void downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"question_template.xlsx\"");

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Questions");

            // Create header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {
                "Quiz ID", "Question Type", "Content", "Media URL (optional)",
                "Level", "Status", "Explanation"
            };

            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Create sample data row
            Row sampleRow = sheet.createRow(1);
            sampleRow.createCell(0).setCellValue(1);
            sampleRow.createCell(1).setCellValue("multiple_choice");
            sampleRow.createCell(2).setCellValue("Sample question content");
            sampleRow.createCell(3).setCellValue("https://example.com/media.jpg");
            sampleRow.createCell(4).setCellValue("easy");
            sampleRow.createCell(5).setCellValue("active");
            sampleRow.createCell(6).setCellValue("Sample explanation");

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error creating template: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/questions-list");
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            Question question = questionDAO.findById(questionId);
            
            if (question != null) {
                boolean success = questionDAO.delete(question);
                if (success) {
                    request.getSession().setAttribute("toastMessage", "Question deleted successfully");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to delete question");
                    request.getSession().setAttribute("toastType", "danger");
                }
            } else {
                request.getSession().setAttribute("toastMessage", "Question not found");
                request.getSession().setAttribute("toastType", "danger");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid question ID");
            request.getSession().setAttribute("toastType", "danger");
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error deleting question: " + e.getMessage());
            request.getSession().setAttribute("toastType", "danger");
        }
        
        response.sendRedirect(request.getContextPath() + "/questions-list");
    }

    private void saveQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionId = request.getParameter("questionId");
        String content = request.getParameter("content");
        String quizId = request.getParameter("quizId");
        String type = request.getParameter("type");
        String level = request.getParameter("level");
        String status = request.getParameter("status");
        String explanation = request.getParameter("explanation");
        String mediaUrl = request.getParameter("media_url");
        String correctAnswerStr = request.getParameter("correctAnswer");
        String optionCountStr = request.getParameter("optionCount");
        try {
            int questionIdInt = Integer.parseInt(questionId);
            int quizIdInt = Integer.parseInt(quizId);
            int optionCount = Integer.parseInt(optionCountStr);
            int correctAnswer = Integer.parseInt(correctAnswerStr);
            Question question;
            boolean isNew = (questionIdInt == 0);
            if (isNew) {
                question = new Question();
                question.setStatus("active");
            } else {
                question = questionDAO.findById(questionIdInt);
                if (question == null) throw new Exception("Question not found");
            }
            // Validate dữ liệu
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Nội dung câu hỏi không được để trống!");
                List<Quizzes> quizzesList = quizzesDAO.findAll();
                request.setAttribute("quizzesList", quizzesList);
                request.setAttribute("question", question);
                request.getRequestDispatcher("/view/Expert/Question/question-edit.jsp").forward(request, response);
                return;
            }
            // Cập nhật trường dữ liệu
            question.setContent(content);
            question.setQuiz_id(quizIdInt);
            question.setType(type);
            question.setLevel(level);
            question.setStatus(status);
            question.setExplanation(explanation);
            
            // Xử lý media_url
            if (mediaUrl != null && !mediaUrl.trim().isEmpty()) {
                question.setMedia_url(mediaUrl);
            }
            
            // Lưu question
            if (isNew) {
                questionIdInt = questionDAO.insert(question);
                question.setId(questionIdInt);
            } else {
                questionDAO.update(question);
            }
            // --- XỬ LÝ ĐÁP ÁN GIỮ LẠI ID CŨ ---
            List<QuestionOption> oldOptions = questionOptionDAO.findByQuestionId(questionIdInt);
            List<Integer> formOptionIds = new ArrayList<>();
            for (int i = 1; i <= optionCount; i++) {
                String optionText = request.getParameter("optionText_" + i);
                String optionIdStr = request.getParameter("optionId_" + i);
                if (optionText == null || optionText.isEmpty()) continue;
                int optionId = 0;
                try { optionId = Integer.parseInt(optionIdStr); } catch (Exception ignore) {}
                formOptionIds.add(optionId);
                QuestionOption option;
                if (optionId != 0) {
                    option = questionOptionDAO.findById(optionId);
                    if (option == null) {
                        option = new QuestionOption();
                        option.setQuestion_id(questionIdInt);
                    }
                } else {
                    option = new QuestionOption();
                    option.setQuestion_id(questionIdInt);
                }
                option.setOption_text(optionText);
                option.setCorrect_key(i == correctAnswer);
                option.setDisplay_order(i);
                if (optionId != 0) {
                    questionOptionDAO.update(option);
                } else {
                    questionOptionDAO.insert(option);
                }
            }
            for (QuestionOption oldOpt : oldOptions) {
                if (!formOptionIds.contains(oldOpt.getId())) {
                    questionOptionDAO.delete(oldOpt);
                }
            }
            request.getSession().setAttribute("toastMessage", "Question saved successfully");
            request.getSession().setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/questions-list");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi khi lưu câu hỏi: " + e.getMessage());
            List<Quizzes> quizzesList = quizzesDAO.findAll();
            request.setAttribute("quizzesList", quizzesList);
            // Nếu có thể, set lại question để giữ dữ liệu đã nhập
            String questionIdStr = request.getParameter("questionId");
            if (questionId != null && !questionId.equals("0")) {
                Question question = questionDAO.findById(Integer.parseInt(questionId));
                request.setAttribute("question", question);
            }
            request.getRequestDispatcher("/view/Expert/Question/question-edit.jsp").forward(request, response);
        }
    }

    private void handleMediaUpload(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");

        try {
            Part filePart = request.getPart("file");

            if (filePart == null) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"No file found in the request\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }

            String fileName = getFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"Invalid file name\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }

            // Validate file type
            String fileType = filePart.getContentType();
            if (!fileType.startsWith("image/") && !fileType.startsWith("video/")) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"Only image and video files are allowed\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }

            // Create year/month based subdirectories
            String timestamp = String.valueOf(System.currentTimeMillis());
            String uniqueFileName = timestamp + "_" + fileName;
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("/" + UPLOAD_DIRECTORY);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            String fileUrl = request.getContextPath() + "/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;

            // Return response based on TinyMCE requirements
            if (fileType.startsWith("image/")) {
                jsonResponse.append("\"location\": \"").append(fileUrl).append("\"");
            } else {
                // For video, return both location and additional info
                jsonResponse.append("\"location\": \"").append(fileUrl).append("\",");
                jsonResponse.append("\"title\": \"").append(fileName).append("\",");
                jsonResponse.append("\"success\": true");
            }

        } catch (Exception e) {
            jsonResponse.append("\"success\": false,");
            jsonResponse.append("\"message\": \"Error uploading file: ").append(e.getMessage()).append("\"");
            e.printStackTrace();
        }

        jsonResponse.append("}");
        out.print(jsonResponse.toString());
    }

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
}
