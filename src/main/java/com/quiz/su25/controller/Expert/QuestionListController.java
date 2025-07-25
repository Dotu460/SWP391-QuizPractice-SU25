/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.Expert;

import com.quiz.su25.dal.impl.*;
import com.quiz.su25.entity.*;
import com.quiz.su25.entity.User;
import com.quiz.su25.config.GlobalConfig;
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
        maxFileSize = 1024 * 1024 * 10, // 10 MB
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
            out.println("<h1>Servlet QuestionListController at " + request.getContextPath() + "</h1>");
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");


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
            case "deleteOption":
                deleteQuestionOption(request, response);
                break;
            default:
                saveQuestion(request, response);
                break;
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin user từ session
            User currentUser = (User) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);
            request.setAttribute("currentUser", currentUser);

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
            int recordsPerPage = 5;
            String recordsPerPageStr = request.getParameter("recordsPerPage");
            if (recordsPerPageStr != null && !recordsPerPageStr.trim().isEmpty()) {
                try {
                    recordsPerPage = Integer.parseInt(recordsPerPageStr);
                    if (recordsPerPage < 1) {
                        recordsPerPage = 5;
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
            request.setAttribute("lessonDAO", lessonDAO);
            request.setAttribute("subjectDAO", subjectDAO);

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
            request.setAttribute("lessonDAO", lessonDAO);
            request.setAttribute("subjectDAO", subjectDAO);
            // Forward tới trang edit
            request.getRequestDispatcher("/view/Expert/Question/question-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid question ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/questions-list");
        }
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
        String[] correctAnswers = request.getParameterValues("correctAnswers");
        String optionCountStr = request.getParameter("optionCount");
        try {
            int questionIdInt = Integer.parseInt(questionId);
            int quizIdInt = Integer.parseInt(quizId);
            int optionCount = Integer.parseInt(optionCountStr);
            
            // Validate that at least one correct answer is selected
            if (correctAnswers == null || correctAnswers.length == 0) {
                request.setAttribute("errorMessage", "Please select at least one correct answer!");
                List<Quizzes> quizzesList = quizzesDAO.findAll();
                request.setAttribute("quizzesList", quizzesList);
                if (questionIdInt != 0) {
                    Question existingQuestion = questionDAO.findById(questionIdInt);
                    if (existingQuestion != null) {
                        List<QuestionOption> options = questionOptionDAO.findByQuestionId(questionIdInt);
                        existingQuestion.setQuestionOptions(options);
                        request.setAttribute("question", existingQuestion);
                    }
                }
                request.getRequestDispatcher("/view/Expert/Question/question-edit.jsp").forward(request, response);
                return;
            }
            
            // Convert correctAnswers to Set for easier lookup
            java.util.Set<Integer> correctAnswerSet = new java.util.HashSet<>();
            for (String answerStr : correctAnswers) {
                correctAnswerSet.add(Integer.parseInt(answerStr));
            }
            Question question;
            boolean isNew = (questionIdInt == 0);
            if (isNew) {
                question = new Question();
                question.setStatus("active");
            } else {
                question = questionDAO.findById(questionIdInt);
                if (question == null) {
                    throw new Exception("Question not found");
                }
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
                String answerText = request.getParameter("answerText_" + i);
                String optionIdStr = request.getParameter("optionId_" + i);
                if ((optionText == null || optionText.isEmpty()) && (answerText == null || answerText.isEmpty())) {
                    continue;
                }
                int optionId = 0;
                try {
                    optionId = Integer.parseInt(optionIdStr);
                } catch (Exception ignore) {
                }
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

                if (optionText != null && !optionText.isEmpty()) {
                    option.setOption_text(optionText);
                    option.setAnswer_text(null);
                } else {
                    option.setOption_text(null);
                    option.setAnswer_text(answerText);
                }

                option.setCorrect_key(correctAnswerSet.contains(i));
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
        if (fileName == null) {
            return false;
        }
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
                if (row == null || isEmptyRow(row)) {
                    continue;
                }

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
            if (cell != null && cell.getCellType() != CellType.BLANK
                    && !getCellValueAsString(cell).trim().isEmpty()) {
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
        if (cell == null) {
            return "";
        }

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
        if (cell == null) {
            return null;
        }

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
        response.setHeader("Content-Disposition", "attachment; filename=\"question_import_template.xlsx\"");

        try (Workbook workbook = new XSSFWorkbook()) {
            
            // ===== CREATE INSTRUCTIONS SHEET =====
            Sheet instructionsSheet = workbook.createSheet("Instructions");
            
            // Create styles
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            headerStyle.setFont(headerFont);
            
            CellStyle boldStyle = workbook.createCellStyle();
            Font boldFont = workbook.createFont();
            boldFont.setBold(true);
            boldStyle.setFont(boldFont);
            
            int rowNum = 0;
            
            // Title
            Row titleRow = instructionsSheet.createRow(rowNum++);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("QUESTION IMPORT TEMPLATE - INSTRUCTIONS");
            titleCell.setCellStyle(titleStyle);
            rowNum++; // Empty row
            
            // General instructions
            Row generalRow = instructionsSheet.createRow(rowNum++);
            Cell generalCell = generalRow.createCell(0);
            generalCell.setCellValue("GENERAL INSTRUCTIONS:");
            generalCell.setCellStyle(headerStyle);
            
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("1. Fill data in the 'Questions' sheet starting from row 2");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("2. Do not modify the header row in the 'Questions' sheet");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("3. All fields are required except 'Media URL'");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("4. Save file as .xlsx format before importing");
            rowNum++; // Empty row
            
            // Field descriptions
            Row fieldsRow = instructionsSheet.createRow(rowNum++);
            Cell fieldsCell = fieldsRow.createCell(0);
            fieldsCell.setCellValue("FIELD DESCRIPTIONS:");
            fieldsCell.setCellStyle(headerStyle);
            
            // Quiz ID section
            Row quizIdRow = instructionsSheet.createRow(rowNum++);
            Cell quizIdCell = quizIdRow.createCell(0);
            quizIdCell.setCellValue("1. Quiz ID:");
            quizIdCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Enter the numeric ID of the quiz");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Available Quiz IDs and Names:");
            
            // Get all quizzes to show available IDs
            List<Quizzes> allQuizzes = quizzesDAO.findAll();
            for (Quizzes quiz : allQuizzes) {
                try {
                    // Get lesson and subject info
                    Lesson lesson = lessonDAO.findById(quiz.getLesson_id());
                    if (lesson != null) {
                        Subject subject = subjectDAO.findById(lesson.getSubject_id());
                        String displayText = String.format("     ID: %d - %s (%s - %s)", 
                            quiz.getId(), quiz.getName(), 
                            subject != null ? subject.getTitle() : "Unknown Subject", 
                            lesson.getTitle());
                        instructionsSheet.createRow(rowNum++).createCell(0).setCellValue(displayText);
                    }
                } catch (Exception e) {
                    String displayText = String.format("     ID: %d - %s", quiz.getId(), quiz.getName());
                    instructionsSheet.createRow(rowNum++).createCell(0).setCellValue(displayText);
                }
            }
            rowNum++; // Empty row
            
            // Question Type section
            Row typeRow = instructionsSheet.createRow(rowNum++);
            Cell typeCell = typeRow.createCell(0);
            typeCell.setCellValue("2. Question Type:");
            typeCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - multiple: Multiple choice question");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - essay: Essay/text answer question");
            rowNum++; // Empty row
            
            // Content section
            Row contentRow = instructionsSheet.createRow(rowNum++);
            Cell contentCell = contentRow.createCell(0);
            contentCell.setCellValue("3. Content:");
            contentCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - The question text/content");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Can contain HTML tags for formatting");
            rowNum++; // Empty row
            
            // Media URL section  
            Row mediaRow = instructionsSheet.createRow(rowNum++);
            Cell mediaCell = mediaRow.createCell(0);
            mediaCell.setCellValue("4. Media URL (Optional):");
            mediaCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - URL to image, video or other media");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Leave empty if no media needed");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Example: https://example.com/image.jpg");
            rowNum++; // Empty row
            
            // Level section
            Row levelRow = instructionsSheet.createRow(rowNum++);
            Cell levelCell = levelRow.createCell(0);
            levelCell.setCellValue("5. Level:");
            levelCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - easy: Easy difficulty");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - medium: Medium difficulty");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - hard: Hard difficulty");
            rowNum++; // Empty row
            
            // Status section
            Row statusRow = instructionsSheet.createRow(rowNum++);
            Cell statusCell = statusRow.createCell(0);
            statusCell.setCellValue("6. Status:");
            statusCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - active: Question is active and visible");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - hidden: Question is hidden from users");
            rowNum++; // Empty row
            
            // Explanation section
            Row explanationRow = instructionsSheet.createRow(rowNum++);
            Cell explanationCell = explanationRow.createCell(0);
            explanationCell.setCellValue("7. Explanation:");
            explanationCell.setCellStyle(boldStyle);
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Explanation for the correct answer");
            instructionsSheet.createRow(rowNum++).createCell(0).setCellValue("   - Helps students understand the solution");
            
            // Auto-size columns for instructions
            for (int i = 0; i < 2; i++) {
                instructionsSheet.autoSizeColumn(i);
            }
            
            // ===== CREATE QUESTIONS SHEET =====
            Sheet questionsSheet = workbook.createSheet("Questions");

            // Create header row
            Row headerRow = questionsSheet.createRow(0);
            String[] headers = {
                "Quiz ID", "Question Type", "Content", "Media URL (optional)",
                "Level", "Status", "Explanation"
            };

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Create sample data rows
            Row sampleRow1 = questionsSheet.createRow(1);
            sampleRow1.createCell(0).setCellValue(allQuizzes.isEmpty() ? 1 : allQuizzes.get(0).getId());
            sampleRow1.createCell(1).setCellValue("multiple");
            sampleRow1.createCell(2).setCellValue("What is the capital of France?");
            sampleRow1.createCell(3).setCellValue("");
            sampleRow1.createCell(4).setCellValue("easy");
            sampleRow1.createCell(5).setCellValue("active");
            sampleRow1.createCell(6).setCellValue("Paris is the capital and largest city of France.");
            
            Row sampleRow2 = questionsSheet.createRow(2);
            sampleRow2.createCell(0).setCellValue(allQuizzes.isEmpty() ? 1 : allQuizzes.get(0).getId());
            sampleRow2.createCell(1).setCellValue("essay");
            sampleRow2.createCell(2).setCellValue("Explain the importance of renewable energy sources.");
            sampleRow2.createCell(3).setCellValue("https://example.com/renewable-energy.jpg");
            sampleRow2.createCell(4).setCellValue("medium");
            sampleRow2.createCell(5).setCellValue("active");
            sampleRow2.createCell(6).setCellValue("Renewable energy is important for sustainability and reducing carbon emissions.");

            // Auto-size columns for questions sheet
            for (int i = 0; i < headers.length; i++) {
                questionsSheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());
        } catch (Exception e) {
            System.out.println("Error creating template: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating template");
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            Question question = questionDAO.findById(questionId);

            if (question != null) {
                // Delete all question options first to avoid foreign key constraint violation
                boolean optionsDeleted = questionOptionDAO.deleteByQuestionId(questionId);
                
                // Then delete the question
                boolean questionDeleted = questionDAO.delete(question);
                
                if (questionDeleted) {
                    request.getSession().setAttribute("toastMessage", "Question deleted successfully");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to delete question");
                    request.getSession().setAttribute("toastType", "error");
                }
            } else {
                request.getSession().setAttribute("toastMessage", "Question not found");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid question ID");
            request.getSession().setAttribute("toastType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error deleting question: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }

        // Preserve filter state after deletion
        StringBuilder redirectURL = new StringBuilder(request.getContextPath()).append("/questions-list");
        List<String> params = new ArrayList<>();

        // Add filter parameters if they exist
        String page = request.getParameter("page");
        String content = request.getParameter("content");
        String subjectId = request.getParameter("subjectId");
        String lessonId = request.getParameter("lessonId");
        String quizId = request.getParameter("quizId");
        String status = request.getParameter("status");
        String recordsPerPage = request.getParameter("recordsPerPage");

        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (content != null && !content.isEmpty()) {
            try {
                params.add("content=" + URLEncoder.encode(content, "UTF-8"));
            } catch (Exception e) {
                // If encoding fails, skip this parameter
            }
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
            try {
                params.add("status=" + URLEncoder.encode(status, "UTF-8"));
            } catch (Exception e) {
                // If encoding fails, skip this parameter
            }
        }
        if (recordsPerPage != null && !recordsPerPage.isEmpty()) {
            params.add("recordsPerPage=" + recordsPerPage);
        }

        // Add parameters to URL
        if (!params.isEmpty()) {
            redirectURL.append("?").append(String.join("&", params));
        }

        // Redirect back to list with preserved filters
        response.sendRedirect(redirectURL.toString());
    }

    private void deleteQuestionOption(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int optionId = Integer.parseInt(request.getParameter("optionId"));
            QuestionOption option = questionOptionDAO.findById(optionId);
            
            if (option == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Option not found\"}");
                return;
            }
            
            // Delete the option
            boolean success = questionOptionDAO.delete(option);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Option deleted successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to delete option\"}");
            }
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid option ID\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

}