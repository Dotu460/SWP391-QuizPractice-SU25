<%-- 
    Document   : addQuiz
    Created on : 4 thg 6, 2025, 09:05:11
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Add Quiz</title>
    <meta name="description" content="SkillGro - Add Quiz">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for form styling -->
    <style>
        .add-form-card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .add-form-card .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .add-form-card .card-body {
            padding: 25px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h5 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            color: #343a40;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-control {
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 10px 12px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .btn-group {
            gap: 10px;
        }
        
        .required {
            color: #dc3545;
        }
        
        .alert {
            border-radius: 4px;
            margin-bottom: 20px;
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
            <div class="container-fluid">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/user/sidebar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Add New Quiz</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/quizzes-list" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to Quizzes
                                        </a>
                                    </div>
                                </div>

                                <!-- Success/Error Messages -->
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        ${success}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Add Form Card -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card add-form-card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Create New Quiz</h5>
                                            </div>
                                            <div class="card-body">
                                                <form method="post" action="${pageContext.request.contextPath}/quizzes-list?action=create">
                                                    <!-- Basic Information Section -->
                                                    <div class="form-section">
                                                        <h5>Quiz Information</h5>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="name" class="form-label">Quiz Name <span class="required">*</span></label>
                                                                    <input type="text" class="form-control" id="name" name="name" 
                                                                           value="${param.name != null ? param.name : ''}" required>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="lesson_id" class="form-label">Lesson <span class="required">*</span></label>
                                                                    <select class="form-control" id="lesson_id" name="lesson_id" required>
                                                                        <option value="">Select Lesson</option>
                                                                        <c:forEach items="${lessonsList}" var="lesson">
                                                                            <c:set var="subject" value="${subjectDAO.findById(lesson.subject_id)}" />
                                                                            <option value="${lesson.id}" ${param.lesson_id == lesson.id ? 'selected' : ''}>
                                                                                ${subject.title}: ${lesson.title}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="quiz_type" class="form-label">Quiz Type <span class="required">*</span></label>
                                                                    <select class="form-control" id="quiz_type" name="quiz_type" required>
                                                                        <option value="">Select Type</option>
                                                                        <option value="Practice" ${param.quiz_type == 'Practice' ? 'selected' : ''}>Practice</option>
                                                                        <option value="Exam" ${param.quiz_type == 'Exam' ? 'selected' : ''}>Exam</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="level" class="form-label">LevelLevel <span class="required">*</span></label>
                                                                    <select class="form-control" id="level" name="level" required>
                                                                        <option value="">Choose Level</option>
                                                                        <option value="easy" ${param.level == 'easy' ? 'selected' : ''}>easy</option>
                                                                        <option value="medium" ${param.level == 'medium' ? 'selected' : ''}>Medium</option>
                                                                        <option value="hard" ${param.level == 'hard' ? 'selected' : ''}>hard</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Quiz Settings Section -->
                                                    <div class="form-section">
                                                        <h5>Quiz Settings</h5>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="duration_minutes" class="form-label">Duration (Minutes) <span class="required">*</span></label>
                                                                    <input type="number" class="form-control" id="duration_minutes" name="duration_minutes" 
                                                                           value="${param.duration_minutes != null ? param.duration_minutes : ''}" min="1" required>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="number_of_questions" class="form-label">Number of Questions <span class="required">*</span></label>
                                                                    <input type="number" class="form-control" id="number_of_questions" name="number_of_questions" 
                                                                           value="${param.number_of_questions != null ? param.number_of_questions : ''}" min="1" required>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>                                                    
                                                    <!-- Action Buttons -->
                                                    <div class="text-end btn-group">
                                                        <a href="${pageContext.request.contextPath}/quizzes-list" class="btn btn-secondary">
                                                            <i class="fa fa-times"></i> Cancel
                                                        </a>
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fa fa-plus"></i> Create Quiz
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
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
    


    
</body>

</html>
