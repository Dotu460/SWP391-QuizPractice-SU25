<%-- 
    Document   : questions-list
    Created on : 13 thg 6, 2025, 23:36:40
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quản lý Câu hỏi</title>
    <meta name="description" content="SkillGro - Quản lý Câu hỏi">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    
    <!-- Add iziToast CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">

    <style>
        .question-management {
            padding: 20px;
        }
        
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .question-table {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .table-container {
            width: 100%;
            overflow-x: auto;
            margin-bottom: 15px;
        }
        
        .table-responsive {
            width: 100%;
            margin-bottom: 0;
        }

        .table th, .table td {
            white-space: nowrap;
            overflow: hidden;
            max-width: 200px;
            padding: 12px 15px;
            vertical-align: middle;
        }

        .column-actions {
            width: 120px !important;
            background-color: white;
            z-index: 1;
        }

        .table td:hover {
            overflow: visible;
            white-space: normal;
            background-color: #f8f9fa;
            position: relative;
            z-index: 2;
        }
        
        .btn-action {
            padding: 5px 10px;
            margin: 2px;
            border: none;
            border-radius: 4px;
            color: white !important;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 32px;
            transition: all 0.3s ease;
        }
        
        .btn-edit { background-color: #007bff; }
        .btn-edit:hover { background-color: #0056b3; }
        
        .btn-active { background-color: #28a745; }
        .btn-active:hover { background-color: #218838; }
        
        .btn-hidden { background-color: #6c757d; }
        .btn-hidden:hover { background-color: #5a6268; }
        
        .btn-delete { background-color: #dc3545; }
        .btn-delete:hover { 
            background-color: #c82333;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .question-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-active { background-color: #d4edda; color: #155724; }
        .status-hidden { background-color: #f8d7da; color: #721c24; }
        
        .search-reset-group {
            display: flex;
            gap: 8px;
            width: 100%;
        }

        .search-btn, .reset-btn {
            border: none;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            min-width: 60px;
            letter-spacing: 0.3px;
        }

        .search-btn {
            background-color: #3b82f6;
            color: white;
            flex: 1;
        }

        .search-btn:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
        }

        .reset-btn {
            background-color: #e5e7eb;
            color: #4b5563;
            flex: 1;
        }

        .reset-btn:hover {
            background-color: #d1d5db;
            transform: translateY(-1px);
        }

        .search-btn:active, .reset-btn:active {
            transform: translateY(1px);
        }
    </style>
    </head>

    <body>
    <!-- Scroll-top -->
    <button class="scroll__top scroll-to-target" data-target="html">
        <i class="tg-flaticon-arrowhead-up"></i>
    </button>

    <!-- header-area -->
    <jsp:include page="../../common/user/header.jsp"></jsp:include>

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="dashboard__bg"><img src="${pageContext.request.contextPath}/view/common/img/bg/dashboard_bg.jpg" alt=""></div>
            <div class="container-fluid px-0">
                <div class="dashboard__top-wrap">
                    <div class="dashboard__top-bg" data-background="${pageContext.request.contextPath}/view/common/img/bg/student_bg.jpg"></div>
                    <div class="dashboard__instructor-info">
                        <div class="dashboard__instructor-info-left">
                            <div class="thumb">
                                <c:choose>
                                    <c:when test="${not empty currentUser.avatar_url}">
                                        <img src="${pageContext.request.contextPath}${currentUser.avatar_url}" alt="User Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors02.jpg" alt="Default Avatar">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="content">
                                <h4 class="title">${not empty currentUser.full_name ? currentUser.full_name : 'Expert User'}</h4>
                            </div>
                        </div>
                    </div>
                </div>                          
            </div>

            <div class="dashboard__inner-wrap">
                <div class="row">
                    <jsp:include page="../../common/user/sidebar.jsp"></jsp:include>
                    
                    <div class="col-lg-9">
                        <div class="question-management">
                            <!-- Page Title with Add Button -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="title">Questions List</h4>
                                <div>
                                    <a href="${pageContext.request.contextPath}/questions-list?action=add" class="btn btn-success">
                                        <i class="fa fa-plus"></i> Import Question
                                    </a>
                                </div>
                            </div>

                            <!-- Filter Section -->
                            <div class="filter-section">
                                <form action="${pageContext.request.contextPath}/questions-list" method="get" id="filterForm">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <label for="content">Question content:</label>
                                            <input type="text" class="form-control" id="content" name="content" 
                                                   placeholder="Enter question content..." value="${param.content}">
                                        </div>
                                        <div class="col-md-2">
                                            <label for="subjectId">Subject:</label>
                                            <select class="form-control" id="subjectId" name="subjectId" onchange="loadLessons()">
                                                <option value="">-- All subjects --</option>
                                                <c:forEach items="${subjectsList}" var="subject">
                                                    <option value="${subject.id}" ${param.subjectId == subject.id ? 'selected' : ''}>
                                                        ${subject.title}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label for="lessonId">Lesson: </label>
                                            <select class="form-control" id="lessonId" name="lessonId">
                                                <option value="">-- All Lessons --</option>
                                                <c:forEach items="${lessonsList}" var="lesson">
                                                    <option value="${lesson.id}" ${param.lessonId == lesson.id ? 'selected' : ''}>
                                                        ${lesson.title}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label for="quizId">Dimension:</label>
                                            <select class="form-control" id="quizId" name="quizId">
                                                <option value="">-- All Dimensions --</option>
                                                <c:forEach items="${quizzesList}" var="quiz">
                                                    <option value="${quiz.id}" ${param.quizId == quiz.id ? 'selected' : ''}>
                                                        ${quiz.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label for="status">Status:</label>
                                            <select class="form-control" id="status" name="status">
                                                <option value="">-- All status --</option>
                                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                                <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Hidden</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1 d-flex align-items-end">
                                            <div class="search-reset-group">
                                                <button type="submit" class="search-btn">
                                                    <i class="fa fa-search"></i>
                                                </button>
                                                <button type="button" class="reset-btn" onclick="resetFilter()">
                                                    <i class="fa fa-undo"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Question List -->
                            <div class="question-table">
                                <div class="table-container">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Content</th>
                                                    <th>Subject</th>
                                                    <th>Lesson</th>
                                                    <th>Dimension</th>
                                                    <th>Level</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${questionsList}" var="question">
                                                    <tr>
                                                        <td>${question.id}</td>
                                                        <td>${question.content}</td>
                                                        <td>
                                                            <c:set var="quiz" value="${quizDAO.findById(question.quiz_id)}" />
                                                            <c:if test="${quiz != null}">
                                                                <c:set var="lesson" value="${lessonDAO.findById(quiz.lesson_id)}" />
                                                                <c:if test="${lesson != null}">
                                                                    <c:set var="subject" value="${subjectDAO.findById(lesson.subject_id)}" />
                                                                    <c:if test="${subject != null}">
                                                                        <p>${subject.title}</p>
                                                                    </c:if>
                                                                </c:if>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:set var="quiz" value="${quizDAO.findById(question.quiz_id)}" />
                                                            <c:if test="${quiz != null}">
                                                                <c:set var="lesson" value="${lessonDAO.findById(quiz.lesson_id)}" />
                                                                <c:if test="${lesson != null}">
                                                                    <p>${lesson.title}</p>
                                                                </c:if>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:set var="quiz" value="${quizDAO.findById(question.quiz_id)}" />
                                                            <c:if test="${quiz != null}">
                                                                <p>${quiz.name}</p>
                                                            </c:if>
                                                        </td>
                                                        <td>${question.level}</td>
                                                        <td>
                                                            <span class="question-status ${question.status == 'active' ? 'status-active' : 'status-hidden'}">
                                                                ${question.status}
                                                            </span>
                                                        </td>
                                                        <td class="column-actions">
                                                            <a href="${pageContext.request.contextPath}/questions-list?action=edit&id=${question.id}" 
                                                               class="btn-action btn-edit" title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <form action="${pageContext.request.contextPath}/questions-list" method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="${question.status == 'active' ? 'hide' : 'activate'}">
                                                                <input type="hidden" name="questionId" value="${question.id}">
                                                                <button type="submit" class="btn-action ${question.status == 'active' ? 'btn-hidden' : 'btn-active'}" 
                                                                        title="${question.status == 'active' ? 'Hide' : 'Activate'}">
                                                                    <i class="fas ${question.status == 'active' ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/questions-list" method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="questionId" value="${question.id}">
                                                                <button type="button" onclick="confirmDelete(this.form)" 
                                                                        class="btn-action btn-delete" title="Delete">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 0}">
                                        <div class="d-flex justify-content-between align-items-center mt-4">
                                            <div class="records-per-page">
                                                <form action="${pageContext.request.contextPath}/questions-list" method="get" class="d-flex align-items-center">
                                                    <input type="hidden" name="content" value="${param.content}">
                                                    <input type="hidden" name="subjectId" value="${param.subjectId}">
                                                    <input type="hidden" name="lessonId" value="${param.lessonId}">
                                                    <input type="hidden" name="quizId" value="${param.quizId}">
                                                    <input type="hidden" name="status" value="${param.status}">
                                                    
                                                    <label for="recordsPerPage" class="me-2">Records per page:</label>
                                                    <div class="d-flex align-items-center">
                                                        <input type="number" class="form-control form-control-sm" 
                                                               id="recordsPerPage" name="recordsPerPage" 
                                                               value="${recordsPerPage}" min="1" max="100" 
                                                               style="width: 50px;">
                                                    </div>
                                                </form>
                                            </div>

                                            <nav aria-label="Page navigation">
                                                <ul class="pagination mb-0">
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" 
                                                           href="${pageContext.request.contextPath}/questions-list?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}&content=${param.content}&subjectId=${param.subjectId}&lessonId=${param.lessonId}&quizId=${param.quizId}&status=${param.status}"
                                                           ${currentPage == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                                            &laquo;
                                                        </a>
                                                    </li>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                            <a class="page-link" 
                                                               href="${pageContext.request.contextPath}/questions-list?page=${i}&recordsPerPage=${recordsPerPage}&content=${param.content}&subjectId=${param.subjectId}&lessonId=${param.lessonId}&quizId=${param.quizId}&status=${param.status}">
                                                                ${i}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" 
                                                           href="${pageContext.request.contextPath}/questions-list?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}&content=${param.content}&subjectId=${param.subjectId}&lessonId=${param.lessonId}&quizId=${param.quizId}&status=${param.status}"
                                                           ${currentPage == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                                            &raquo;
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>

    <!-- Import Question Modal -->
    <div class="modal fade" id="importQuestionModal" tabindex="-1" aria-labelledby="importQuestionLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/questions-list" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="import">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title" id="importQuestionLabel">Import Questions from Excel</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="excelFile" class="form-label">Select Excel file:</label>
                            <input type="file" class="form-control" id="excelFile" name="excelFile" 
                                   accept=".xlsx,.xls" required>
                            <div class="form-text">
                                Only .xlsx or .xls files are accepted. Maximum size: 10MB.
                            </div>
                        </div>
                        <div class="alert alert-info">
                            <strong>Excel file format:</strong><br>
                            <small>
                                Column A: Quiz ID<br>
                                Column B: Question Type<br>
                                Column C: Content<br>
                                Column D: Media URL (optional)<br>
                                Column E: Level<br>
                                Column F: Status<br>
                                Column G: Explanation<br>
                            </small>
                            <br>
                            <a href="${pageContext.request.contextPath}/questions-list?action=downloadTemplate" class="btn btn-sm btn-outline-primary mt-2">
                                📥 Download Template
                            </a>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning">Import</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        function resetFilter() {
            document.getElementById('content').value = '';
            document.getElementById('subjectId').value = '';
            document.getElementById('lessonId').value = '';
            document.getElementById('quizId').value = '';
            document.getElementById('status').value = '';
            document.getElementById('recordsPerPage').value = '';
            document.getElementById('filterForm').submit();
        }
        
        function confirmDelete(form) {
            if (confirm('Are you sure you want to delete this question?')) {
                form.submit();
            }
        }
        
        function loadLessons() {
            const subjectId = document.getElementById('subjectId').value;
            if (subjectId) {
                // Add AJAX call to load lessons based on selected subject
                fetch(`${pageContext.request.contextPath}/api/lessons?subjectId=${subjectId}`)
                    .then(response => response.json())
                    .then(data => {
                        const lessonSelect = document.getElementById('lessonId');
                        lessonSelect.innerHTML = '<option value="">-- All lessons --</option>';
                        data.forEach(lesson => {
                            lessonSelect.innerHTML += `<option value="${lesson.id}">${lesson.title}</option>`;
                        });
                    });
            }
        }
        
        // Add event listener for records per page input
        document.getElementById('recordsPerPage').addEventListener('change', function(e) {
            if (!this.value || this.value < 1) {
                this.value = '';
            }
            this.form.submit();
        });

        // Add event listener for import button
        document.querySelector('a[href*="action=add"]').addEventListener('click', function(e) {
            e.preventDefault();
            const importModal = new bootstrap.Modal(document.getElementById('importQuestionModal'));
            importModal.show();
        });

        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'bottomRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 5000,
                progressBar: true,
                closeOnClick: true,
                onClosing: function () {
                    // Remove toast attributes from the session after displaying
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                    }).then(response => {
                        if (!response.ok) {
                            console.error('Failed to remove toast attributes');
                        }
                    }).catch(error => {
                        console.error('Error:', error);
                    });
                }
            });
        }
    </script>
    </body>
</html>
