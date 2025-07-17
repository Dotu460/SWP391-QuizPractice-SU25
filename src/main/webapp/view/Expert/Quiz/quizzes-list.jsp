<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quản lý Quiz</title>
    <meta name="description" content="SkillGro - Quản lý Quiz">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <style>
        .quiz-management {
            padding: 20px;
        }
        
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .quiz-table {
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

        /* Thêm CSS mới cho bảng */
        .table th, .table td {
            white-space: nowrap;  /* Giữ nội dung trên 1 dòng */
            overflow: hidden;     /* Ẩn nội dung bị tràn */
            max-width: 200px;     /* Chiều rộng tối đa của mỗi cột */
            width: 12.5%;         /* Chia đều 8 cột (100/8) */
            padding: 12px 15px;   /* Padding đều cho các ô */
            vertical-align: middle; /* Căn giữa nội dung theo chiều dọc */
        }

        /* Cột Actions rộng hơn một chút vì có nhiều nút */
        .column-actions {
            width: 160px !important;
            background-color: white;
            z-index: 1;
        }

        /* Hover effect để hiển thị nội dung đầy đủ */
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
        
        .btn-view { background-color: #17a2b8; }
        .btn-view:hover { background-color: #138496; }
        
        .btn-edit { background-color: #007bff; }
        .btn-edit:hover { background-color: #0056b3; }
        
        .btn-delete { background-color: #dc3545; }
        .btn-delete:hover { background-color: #c82333; }

        .btn-question { background-color: #6f42c1; }
        .btn-question:hover { background-color: #553098; }
        
        .quiz-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }
        .status-draft { background-color: #fff3cd; color: #856404; }
        
        .settings-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .settings-btn:hover {
            background-color: #5a6268;
            color: white;
        }
        
        .column-checkbox {
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }
        
        .column-checkbox input[type="checkbox"] {
            margin-right: 8px;
        }
        
        .column-checkbox label {
            margin-bottom: 0;
            user-select: none;
            cursor: pointer;
        }
        
        .modal-body {
            max-height: 400px;
            overflow-y: auto;
        }
        
        /* Hidden columns */
        .col-hidden {
            display: none !important;
        }
        
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .action-column {
            white-space: nowrap;
            min-width: 160px;
        }

        .pagination-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .page-link {
            color: #0d6efd;
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 0.375rem 0.75rem;
        }
        .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
        }
        .page-item.disabled .page-link {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
        }
        .pagination {
            margin-bottom: 0;
        }

        /* Add styles for the reset button */
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            color: white;
        }

        /* Custom styles for buttons */
        .btn-sm {
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        
        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
            transform: translateY(-1px);
        }
        
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
            background-color: transparent;
        }
        
        .btn-outline-secondary:hover {
            color: #fff;
            background-color: #6c757d;
            border-color: #6c757d;
            transform: translateY(-1px);
        }
        
        /* Add shadow on hover */
        .btn:hover {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        /* Icon spacing */
        .btn i {
            font-size: 12px;
        }

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
    <!-- Scroll-top-end-->

    <!-- header-area -->
    <jsp:include page="../../common/user/header.jsp"></jsp:include>
    <!-- header-area-end -->

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
                    <div class="col-lg-3">
                            <jsp:include page="../../admin/adminSidebar.jsp">
                                <jsp:param name="active" value="quizzes-lists"/>
                            </jsp:include>
                        </div>
                    
                    <div class="col-lg-9">
                        <div class="quiz-management">
                            <!-- Page Title with Settings Button -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="title">Quizzes List</h4>
                                <div>
                                    <a href="${pageContext.request.contextPath}/quizzes-list?action=add" class="btn btn-success">
                                        <i class="fa fa-plus"></i> Create New Quiz
                                    </a>
                                </div>
                            </div>

                            <!-- Filter Section -->
                            <div class="filter-section">
                                <form action="${pageContext.request.contextPath}/quizzes-list" method="get" id="filterForm">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="quizName">Quiz name:</label>
                                            <input type="text" class="form-control" id="quizName" name="quizName" 
                                                   placeholder="Enter quiz name..." value="${param.quizName}">
                                        </div>
                                        <div class="col-md-3">
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
                                        <div class="col-md-3">
                                            <label for="quizType">Quiz types:</label>
                                            <select class="form-control" id="quizType" name="quizType">
                                                <option value="">-- All types --</option>
                                                <option value="practice" ${param.quizType == 'practice' ? 'selected' : ''}>Practice</option>
                                                <option value="exam" ${param.quizType == 'exam' ? 'selected' : ''}>Exam</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <div class="search-reset-group">
                                                <button type="submit" class="search-btn">
                                                    Search
                                                </button>
                                                <button type="button" class="reset-btn" onclick="resetFilter()">
                                                    Reset
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mt-3">
                                        <div class="col-12 text-end">
                                            <button type="button" class="settings-btn" id="columnSettingsBtn" style="width: auto; padding: 6px 12px; font-size: 14px;">
                                                <i class="fa fa-cog"></i> Customize column display
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Quiz List -->
                            <div class="quiz-table">
                                <div class="table-container">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0" id="quizTable">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th class="column-id" data-column="id">ID</th>
                                                    <th class="column-name" data-column="name">Quiz Name</th>   
                                                    <th class="column-type" data-column="type">Quiz Type</th>
                                                    <th class="column-level" data-column="level">Level</th>
                                                    <th class="column-subject" data-column="subject">Subject</th>
                                                    <th class="column-lesson" data-column="lesson">Lesson</th>
                                                    <th class="column-questions" data-column="questions">Number of Questions</th>
                                                    <th class="column-duration" data-column="duration">Duration</th>
                                                    <th class="column-actions" data-column="actions" style="min-width: 160px;">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                        <c:forEach items="${quizzesList}" var="quiz" varStatus="status">
                                                            <tr>
                                                                <td class="column-id" data-column="id">${quiz.id}</td>
                                                                <td class="column-name" data-column="name"><strong>${quiz.name}</strong></td>
                                                                <td class="column-type" data-column="type"> ${quiz.quiz_type}
                                                                </td>
                                                                <td class="column-level" data-column="level">${quiz.level}
                                                                </td>
                                                                <td class="column-subject" data-column="subject">
                                                                    <c:set var="lesson" value="${lessonDAO.findById(quiz.lesson_id)}" />
                                                                    <c:if test="${lesson != null}">
                                                                        <c:set var="subject" value="${subjectDAO.findById(lesson.subject_id)}" />
                                                                        <c:if test="${subject != null}">
                                                                            ${subject.title}
                                                                        </c:if>
                                                                    </c:if>
                                                                </td>
                                                                <td class="column-lesson" data-column="lesson">
                                                                    ${lessonDAO.findById(quiz.lesson_id).title}
                                                                </td>
                                                                <td class="column-questions" data-column="questions">${quiz.number_of_questions_target} </td>
                                                                <td class="column-duration" data-column="duration">${quiz.duration_minutes} minutes</td>
                                                                <td class="column-actions" data-column="actions">
                                                                    <a href="${pageContext.request.contextPath}/quizzes-list?action=details&id=${quiz.id}" 
                                                                       class="btn-action btn-view" title="Details">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <form action="${pageContext.request.contextPath}/quizzes-list" method="post" style="display: inline;">
                                                                        <input type="hidden" name="action" value="delete">
                                                                        <input type="hidden" name="quizId" value="${quiz.id}">
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

                                    <!-- Phân trang -->
                                    <c:if test="${totalPages > 0}">
                                        <div class="d-flex justify-content-between align-items-center mt-4">
                                            <!-- Form nhập số bản ghi mỗi trang -->
                                            <div class="records-per-page">
                                                <form action="${pageContext.request.contextPath}/quizzes-list" method="get" class="d-flex align-items-center">
                                                    <!-- Giữ lại các tham số tìm kiếm hiện tại -->
                                                    <input type="hidden" name="quizName" value="${param.quizName}">
                                                    <input type="hidden" name="subjectId" value="${param.subjectId}">
                                                    <input type="hidden" name="quizType" value="${param.quizType}">
                                                    
                                                    <label for="recordsPerPage" class="me-2">Records per page:</label>
                                                    <div class="d-flex align-items-center">
                                                        <input type="number" class="form-control form-control-sm" 
                                                               id="recordsPerPage" name="recordsPerPage" 
                                                               value="${recordsPerPage}" min="1" max="100" 
                                                               style="width: 50px;">
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Phân trang -->
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination mb-0">
                                                    <!-- Nút Previous -->
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" 
                                                           href="${pageContext.request.contextPath}/quizzes-list?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}&quizName=${param.quizName}&subjectId=${param.subjectId}&quizType=${param.quizType}"
                                                           ${currentPage == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                                            &laquo;
                                                        </a>
                                                    </li>

                                                    <!-- Các số trang -->
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                            <a class="page-link" 
                                                               href="${pageContext.request.contextPath}/quizzes-list?page=${i}&recordsPerPage=${recordsPerPage}&quizName=${param.quizName}&subjectId=${param.subjectId}&quizType=${param.quizType}">
                                                                ${i}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <!-- Nút Next -->
                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" 
                                                           href="${pageContext.request.contextPath}/quizzes-list?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}&quizName=${param.quizName}&subjectId=${param.subjectId}&quizType=${param.quizType}"
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
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

    <!-- Column Settings Modal -->
    <div class="modal fade" id="columnSettingsModal" tabindex="-1" role="dialog" aria-labelledby="columnSettingsModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="columnSettingsModalLabel">
                        <i class="fa fa-cog"></i> Customize column display
                    </h5>
                </div>
                <div class="modal-body">
                    <p class="text-muted mb-3">Select the columns you want to display in the table:</p>
                    <form id="columnSettingsForm">
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-id" value="id" checked>
                            <label for="col-id">ID</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-name" value="name" checked>
                            <label for="col-name">Quiz Name</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-type" value="type" checked>
                            <label for="col-type">Quiz Type</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-level" value="level" checked>
                            <label for="col-level">Level</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-subject" value="subject" checked>
                            <label for="col-subject">Subject</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-lesson" value="lesson" checked>
                            <label for="col-lesson">Lesson</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-questions" value="questions" checked>
                            <label for="col-questions">Number of Questions</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-duration" value="duration" checked>
                            <label for="col-duration">Duration</label>
                        </div>
                    </form>
                    
                    <hr>
                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="selectAllBtn">
                            <i class="fa fa-check-square"></i> Select all
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="deselectAllBtn">
                            <i class="fa fa-square"></i> Deselect all
                        </button>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="applySettingsBtn">
                        <i class="fa fa-check"></i> Apply
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Khi trang load xong
        $(document).ready(function() {
            // Khi bấm nút tùy chỉnh cột
            $('#columnSettingsBtn').click(function() {
                $('#columnSettingsModal').modal('show');
            });
            
            // Khi bấm nút Áp dụng
            $('#applySettingsBtn').click(function() {
                applySettings();
            });
            
            // Khi bấm nút Chọn tất cả
            $('#selectAllBtn').click(function() {
                $('#columnSettingsForm input[type="checkbox"]').prop('checked', true);
            });
            
            // Khi bấm nút Bỏ chọn tất cả
            $('#deselectAllBtn').click(function() {
                $('#columnSettingsForm input[type="checkbox"]').prop('checked', false);
            });
        });
        
        // Hàm áp dụng cài đặt cột
        function applySettings() {
            // Ẩn tất cả cột trước
            $('.column-id, .column-name, .column-type, .column-level, .column-subject, .column-lesson, .column-questions, .column-duration').hide();
            
            // Hiện các cột được chọn
            if ($('#col-id').is(':checked')) {
                $('.column-id').show();
            }
            if ($('#col-name').is(':checked')) {
                $('.column-name').show();
            }
            if ($('#col-type').is(':checked')) {
                $('.column-type').show();
            }
            if ($('#col-level').is(':checked')) {
                $('.column-level').show();
            }
            if ($('#col-subject').is(':checked')) {
                $('.column-subject').show();
            }
            if ($('#col-lesson').is(':checked')) {
                $('.column-lesson').show();
            }
            if ($('#col-questions').is(':checked')) {
                $('.column-questions').show();
            }
            if ($('#col-duration').is(':checked')) {
                $('.column-duration').show();
            }
            
            // Đóng modal và hiện thông báo
            $('#columnSettingsModal').modal('hide');
            alert('Đã áp dụng cài đặt cột!');
        }


        function confirmDelete(form) {
            if (confirm('Are you sure you want to delete this quiz?')) {
                form.submit();
            }
        }
        
        // Display success/error messages if they exist

        // Add reset filter function
        function resetFilter() {
            document.getElementById('quizName').value = '';
            document.getElementById('subjectId').value = '';
            document.getElementById('quizType').value = '';
            document.getElementById('recordsPerPage').value = ''; // Reset records per page too
            document.getElementById('filterForm').submit();
        }
        
        // Add event listener for records per page input
        document.getElementById('recordsPerPage').addEventListener('change', function(e) {
            if (!this.value || this.value < 1) {
                this.value = ''; // Empty value to show all records
            }
            this.form.submit();
        });
    </script>
</body>

</html>