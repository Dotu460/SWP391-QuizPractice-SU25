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
        }
        
        .btn-action {
            padding: 5px 10px;
            margin: 2px;
            border: none;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 12px;
        }
        
        .btn-view { background-color: #17a2b8; }
        .btn-edit { background-color: #007bff; }
        .btn-delete { background-color: #dc3545; }
        
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

    <c:url value="/QuizzesList" var="paginationUrl">
        <c:if test="${not empty param.quizName}">
            <c:param name="quizName" value="${param.quizName}" />
        </c:if>
        <c:if test="${not empty param.subjectId}">
            <c:param name="subjectId" value="${param.subjectId}" />
        </c:if>
        <c:if test="${not empty param.quizType}">
            <c:param name="quizType" value="${param.quizType}" />
        </c:if>
        <c:if test="${not empty param.pageSize}">
            <c:param name="pageSize" value="${param.pageSize}" />
        </c:if>
    </c:url>

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
                        <div class="quiz-management">
                            <!-- Page Title with Settings Button -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="title">Quản lý Quiz</h4>
                                <div>
                                    <a href="${pageContext.request.contextPath}/view/Expert/Quiz/addQuiz.jsp" class="btn btn-success">
                                        <i class="fa fa-plus"></i> Tạo Quiz Mới
                                    </a>
                                </div>
                            </div>

                            <!-- Filter Section -->
                            <div class="filter-section">
                                <form action="${pageContext.request.contextPath}/QuizzesList" method="get">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="quizName">Tên Quiz:</label>
                                            <input type="text" class="form-control" id="quizName" name="quizName" 
                                                   placeholder="Nhập tên quiz..." value="${param.quizName}">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="subjectId">Môn học:</label>
                                            <select class="form-control" id="subjectId" name="subjectId">
                                                <option value="">-- Tất cả môn học --</option>
                                                <c:forEach items="${subjectsList}" var="subject">
                                                    <option value="${subject.id}" ${param.subjectId == subject.id ? 'selected' : ''}>
                                                        ${subject.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="quizType">Loại Quiz:</label>
                                            <select class="form-control" id="quizType" name="quizType">
                                                <option value="">-- Tất cả loại --</option>
                                                <option value="Multiple Choice" ${param.quiz_type == 'Practice' ? 'selected' : ''}>Practice</option>
                                                <option value="Essay" ${param.quiz_type == 'Exam' ? 'selected' : ''}>ExamExam</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                                        </div>
                                    </div>
                                    <div class="row mt-3">
                                        <div class="col-12 text-end">
                                            <button type="button" class="settings-btn" id="columnSettingsBtn" style="width: auto; padding: 6px 12px; font-size: 14px;">
                                                <i class="fa fa-cog"></i> Tùy chỉnh hiển thị cột
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Quiz List -->
                            <div class="quiz-table">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="quizTable">
                                        <thead class="thead-light">
                                            <tr>
                                                <th class="column-id" data-column="id">ID</th>
                                                <th class="column-name" data-column="name">Quiz Name</th>
                                                <th class="column-subject" data-column="subject">Subject</th>
                                                <th class="column-lesson" data-column="lesson">Lesson</th>
                                                <th class="column-questions" data-column="questions">Number of Questions</th>
                                                <th class="column-duration" data-column="duration">Duration</th>
                                                <th class="column-actions" data-column="actions">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty quizzesList}">
                                                    <c:forEach items="${quizzesList}" var="quiz" varStatus="status">
                                                        <tr>
                                                            <td class="column-id" data-column="id">${quiz.id}</td>
                                                            <td class="column-name" data-column="name"><strong>${quiz.name}</strong></td>
                                                            <td class="column-subject" data-column="subject">
                                                                <c:forEach items="${subjectsList}" var="subject">
                                                                    <c:if test="${subject.id == quiz.subject_id}">
                                                                        ${subject.name}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td class="column-lesson" data-column="lesson">
                                                                ${quiz.lesson_name}
                                                            </td>
                                                            <td class="column-questions" data-column="questions">${quiz.number_of_questions_target}</td>
                                                            <td class="column-duration" data-column="duration">${quiz.duration_minutes} phút</td>
                                                            <td class="column-actions" data-column="actions">
                                                                <a href="${pageContext.request.contextPath}/view/Expert/Quiz/QuizDetails.jsp?id=${quiz.id}" class="btn-action btn-view" title="Detail">
                                                                    <i class="fa fa-eye"></i>
                                                                </a>
                                                                <a href="javascript:void(0)" class="btn-action btn-delete" title="Xóa" 
                                                                   onclick="return confirm('Bạn có chắc muốn xóa quiz này?')">
                                                                    <i class="fa fa-trash"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="8" class="text-center py-4">
                                                            <em>Chưa có quiz nào được tạo</em>
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
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
                        <i class="fa fa-cog"></i> Tùy chỉnh hiển thị cột
                    </h5>
                </div>
                <div class="modal-body">
                    <p class="text-muted mb-3">Chọn các cột bạn muốn hiển thị trong bảng:</p>
                    <form id="columnSettingsForm">
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-id" value="id" checked>
                            <label for="col-id">ID</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-name" value="name" checked>
                            <label for="col-name">Tên Quiz</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-subject" value="subject" checked>
                            <label for="col-subject">Môn học</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-lesson" value="lesson" checked>
                            <label for="col-lesson">Bài học</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-questions" value="questions" checked>
                            <label for="col-questions">Số câu hỏi</label>
                        </div>
                        <div class="column-checkbox">
                            <input type="checkbox" id="col-duration" value="duration" checked>
                            <label for="col-duration">Thời gian</label>
                        </div>
                    </form>
                    
                    <hr>
                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="selectAllBtn">
                            <i class="fa fa-check-square"></i> Chọn tất cả
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="deselectAllBtn">
                            <i class="fa fa-square"></i> Bỏ chọn tất cả
                        </button>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="applySettingsBtn">
                        <i class="fa fa-check"></i> Áp dụng
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
            $('.column-id, .column-name, .column-subject, .column-lesson, .column-questions, .column-duration').hide();
            
            // Hiện các cột được chọn
            if ($('#col-id').is(':checked')) {
                $('.column-id').show();
            }
            if ($('#col-name').is(':checked')) {
                $('.column-name').show();
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
    </script>
</body>

</html>