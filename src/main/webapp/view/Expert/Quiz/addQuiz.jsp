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
        
        .is-valid {
            border-color: #28a745 !important;
        }
        
        .is-invalid {
            border-color: #dc3545 !important;
        }
        
        .valid-feedback {
            color: #28a745;
            font-size: 0.875em;
        }
        
        .invalid-feedback {
            color: #dc3545;
            font-size: 0.875em;
        }
        
        .checking {
            color: #6c757d;
            font-size: 0.875em;
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
                                                                    <div id="nameValidation" class="form-text mt-1" style="display: none;"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="lesson_id" class="form-label">Lesson <span class="required">*</span></label>
                                                                    <select class="form-control" id="lesson_id" name="lesson_id" required>
                                                                        <c:choose>
                                                                            <c:when test="${not empty lessonsList}">
                                                                                <option value="">Select Lesson</option>
                                                                                <c:forEach items="${lessonsList}" var="lesson">
                                                                                    <c:set var="subject" value="${subjectDAO.findById(lesson.subject_id)}" />
                                                                                    <option value="${lesson.id}" ${param.lesson_id == lesson.id ? 'selected' : ''}>
                                                                                        ${subject.title}: ${lesson.title}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <option value="">No lessons available - Please create lessons first</option>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </select>
                                                                    
                                                                    <!-- Check if no lessons available -->
                                                                    <c:if test="${empty lessonsList}">
                                                                        <div class="alert alert-warning mt-2 mb-0" role="alert">
                                                                            <i class="fa fa-exclamation-triangle me-2"></i>
                                                                            <strong>No lessons found!</strong> 
                                                                            You need to create lessons first before creating quizzes.
                                                                            <br>
                                                                            <a href="${pageContext.request.contextPath}/manage-subjects/add-lesson" class="btn btn-sm btn-outline-primary mt-2">
                                                                                <i class="fa fa-plus"></i> Create New Lesson
                                                                            </a>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="quiz_type" class="form-label">Quiz Type <span class="required">*</span></label>
                                                                    <select class="form-control" id="quiz_type" name="quiz_type" required>
                                                                        <option value="">Select Type</option>
                                                                        <option value="practice" ${param.quiz_type == 'practice' ? 'selected' : ''}>Practice</option>
                                                                        <option value="exam" ${param.quiz_type == 'exam' ? 'selected' : ''}>Exam</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="level" class="form-label">Level <span class="required">*</span></label>
                                                                    <select class="form-control" id="level" name="level" required>
                                                                        <option value="">Choose Level</option>
                                                                        <option value="easy" ${param.level == 'easy' ? 'selected' : ''}>Easy</option>
                                                                        <option value="medium" ${param.level == 'medium' ? 'selected' : ''}>Medium</option>
                                                                        <option value="hard" ${param.level == 'hard' ? 'selected' : ''}>Hard</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="status" class="form-label">Status <span class="required">*</span></label>
                                                                    <select class="form-control" id="status" name="status" required>
                                                                        <option value="">Select Status</option>
                                                                        <option value="active" ${param.status == 'active' ? 'selected' : 'selected'}>Active</option>
                                                                        <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Hidden</option>
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
                                                        <button type="submit" class="btn btn-success" 
                                                                ${empty lessonsList ? 'disabled title="Please create lessons first"' : ''}>
                                                            <i class="fa fa-plus"></i> Create Quiz
                                                        </button>
                                                    </div>
                                                    
                                                    <c:if test="${empty lessonsList}">
                                                        <div class="alert alert-info mt-3" role="alert">
                                                            <i class="fa fa-info-circle me-2"></i>
                                                            <strong>Important:</strong> You cannot create a quiz without lessons. 
                                                            Please create at least one lesson first, then come back to create your quiz.
                                                        </div>
                                                    </c:if>
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
    
    <script>
        $(document).ready(function() {
            // Check if lessons list is empty
            <c:choose>
                <c:when test="${not empty lessonsList}">
                    var hasLessons = true;
                </c:when>
                <c:otherwise>
                    var hasLessons = false;
                </c:otherwise>
            </c:choose>
            
            var nameCheckTimeout;
            var isNameValid = true;
            
            // Real-time quiz name validation
            $('#name, #lesson_id').on('input change', function() {
                var nameInput = $('#name');
                var lessonSelect = $('#lesson_id');
                var nameValidation = $('#nameValidation');
                
                var quizName = nameInput.val().trim();
                var lessonId = lessonSelect.val();
                
                // Clear previous timeout
                clearTimeout(nameCheckTimeout);
                
                if (quizName === '' || lessonId === '') {
                    nameValidation.hide();
                    nameInput.removeClass('is-valid is-invalid');
                    isNameValid = true;
                    return;
                }
                
                // Show checking status
                nameValidation.show()
                    .removeClass('valid-feedback invalid-feedback')
                    .addClass('checking')
                    .html('<i class="fa fa-spinner fa-spin"></i> Checking availability...');
                nameInput.removeClass('is-valid is-invalid');
                
                // Delay AJAX call for better UX
                nameCheckTimeout = setTimeout(function() {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/quizzes-list',
                        type: 'POST',
                        data: {
                            action: 'checkName',
                            name: quizName,
                            lessonId: lessonId
                        },
                        dataType: 'json',
                        success: function(response) {
                            if (response.valid) {
                                nameValidation.removeClass('checking invalid-feedback')
                                    .addClass('valid-feedback')
                                    .html('<i class="fa fa-check"></i> Quiz name is available');
                                nameInput.removeClass('is-invalid').addClass('is-valid');
                                isNameValid = true;
                            } else {
                                nameValidation.removeClass('checking valid-feedback')
                                    .addClass('invalid-feedback')
                                    .html('<i class="fa fa-times"></i> ' + response.message);
                                nameInput.removeClass('is-valid').addClass('is-invalid');
                                isNameValid = false;
                            }
                        },
                        error: function() {
                            nameValidation.removeClass('checking valid-feedback invalid-feedback')
                                .addClass('checking')
                                .html('<i class="fa fa-exclamation-triangle"></i> Unable to check name availability');
                            nameInput.removeClass('is-valid is-invalid');
                            isNameValid = true; // Allow submission on error
                        }
                    });
                }, 500); // 500ms delay
            });
            
            // Handle form submission
            $('form').on('submit', function(e) {
                if (!hasLessons) {
                    e.preventDefault();
                    alert('Cannot create quiz without lessons. Please create lessons first.');
                    return false;
                }
                
                // Check name validation
                if (!isNameValid) {
                    e.preventDefault();
                    alert('Please choose a different quiz name as the current one already exists.');
                    $('#name').focus();
                    return false;
                }
                
                // Additional validation
                var lessonId = $('#lesson_id').val();
                if (!lessonId || lessonId === '') {
                    e.preventDefault();
                    alert('Please select a lesson for this quiz.');
                    $('#lesson_id').focus();
                    return false;
                }
                
                return true;
            });
            
            // Auto-hide success/error alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut(500);
            }, 5000);
        });
    </script>
    
</body>

</html>
