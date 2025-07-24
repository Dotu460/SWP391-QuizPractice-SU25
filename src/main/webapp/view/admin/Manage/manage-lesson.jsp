<%-- 
    Document   : manage-lesson
    Created on : 24 thg 6, 2025, 09:46:39
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Subject Content</title>
    <meta name="description" content="SkillGro - Subject Content">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
    
    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    
    <!-- iziToast CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    
    <style>
        .content-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .content-title {
            font-weight: 500;
            margin-bottom: 0;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .content-list {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }
        
        .content-list-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .content-list-header h5 {
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        
        .type-badge {
            font-size: 0.75rem;
            padding: 4px 12px;
            border-radius: 20px;
            margin-left: 10px;
            font-weight: 500;
            border: 1px solid;
        }
        
        .type-lesson {
            background-color: #e3f2fd;
            color: #1976d2;
            border-color: #1976d2;
        }
        
        .type-quiz {
            background-color: #e8f5e9;
            color: #2e7d32;
            border-color: #2e7d32;
        }
        
        .lesson-item {
            border-bottom: 2px solid #e0e0e0;
            padding: 25px 20px;
            transition: all 0.3s ease;
            background-color: #ffffff;
            position: relative;
        }
        
        .lesson-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background-color: #1976d2;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .lesson-item:hover {
            background-color: #f8f9fa;
        }
        
        .lesson-item:hover::before {
            opacity: 1;
        }
        
        .lesson-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .lesson-content {
            padding: 20px;
        }
        
        .nested-quizzes {
            margin: 15px 0 0 25px;
            padding-left: 20px;
            border-left: 3px solid #1976d2;
            background-color: #fafafa;
            border-radius: 0 8px 8px 0;
        }
        
        .quiz-item {
            background-color: #fff;
            margin: 15px 0;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
            position: relative;
        }
        
        .quiz-item::before {
            content: '';
            position: absolute;
            left: -23px;
            top: 50%;
            width: 20px;
            height: 2px;
            background-color: #1976d2;
        }
        
        .quiz-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateX(5px);
            border-color: #1976d2;
        }
        
        .lesson-title-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .lesson-title-section i {
            font-size: 1.2rem;
            color: #1976d2;
        }
        
        .lesson-count {
            position: absolute;
            left: -40px;
            top: 50%;
            transform: translateY(-50%);
            width: 30px;
            height: 30px;
            background-color: #1976d2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .quiz-count {
            font-size: 0.8rem;
            color: #666;
            margin-left: 10px;
        }
        
        .no-content-message {
            text-align: center;
            padding: 30px 20px;
            color: #666;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin: 15px 0;
            border: 1px dashed #ccc;
        }
        
        .no-content-message i {
            font-size: 1.5rem;
            color: #999;
            margin-bottom: 10px;
            display: block;
        }
        
        .action-buttons .btn {
            margin-left: 5px;
        }
        
        .action-buttons .btn i {
            margin-right: 0;
        }
        
        .dashboard__content-wrap {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
        }
        
        .dashboard__content-title {
            margin-bottom: 30px;
        }
        
        .dashboard__content-title h4 {
            font-weight: 600;
            color: #2c3e50;
        }
        
        @media (max-width: 768px) {
            .lesson-item {
                padding: 15px;
            }
            
            .nested-quizzes {
                margin-left: 15px;
                padding-left: 15px;
            }
            
            .lesson-count {
                display: none;
            }
        }
        
        /* New Button Styles */
        .custom-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .custom-btn::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: -100%;
            background: linear-gradient(90deg, rgba(255,255,255,0.2), transparent);
            transition: 0.3s;
        }

        .custom-btn:hover::after {
            left: 100%;
        }

        .custom-btn i {
            font-size: 1rem;
        }

        .custom-btn.btn-primary-soft {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .custom-btn.btn-primary-soft:hover {
            background-color: #1976d2;
            color: white;
            transform: translateY(-2px);
        }

        .custom-btn.btn-success-soft {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .custom-btn.btn-success-soft:hover {
            background-color: #2e7d32;
            color: white;
            transform: translateY(-2px);
        }

        .custom-btn.btn-danger-soft {
            background-color: #ffebee;
            color: #d32f2f;
        }

        .custom-btn.btn-danger-soft:hover {
            background-color: #d32f2f;
            color: white;
            transform: translateY(-2px);
        }

        .custom-btn.btn-warning-soft {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .custom-btn.btn-warning-soft:hover {
            background-color: #f57c00;
            color: white;
            transform: translateY(-2px);
        }

        .custom-btn.btn-info-soft {
            background-color: #e0f7fa;
            color: #0097a7;
        }

        .custom-btn.btn-info-soft:hover {
            background-color: #0097a7;
            color: white;
            transform: translateY(-2px);
        }

        .action-btn-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .action-btn-group .custom-btn {
            padding: 6px 12px;
        }

        .main-action-btn {
            padding: 12px 24px;
            font-size: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .main-action-btn:hover {
            box-shadow: 0 6px 8px rgba(0,0,0,0.15);
        }

        .floating-action-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: linear-gradient(45deg, #1976d2, #2196f3);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .floating-action-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }

        .floating-action-btn i {
            font-size: 24px;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: linear-gradient(145deg, #ffffff, #f3f3f3);
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            color: #2c3e50;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 3px 3px 6px #e8e8e8, -3px -3px 6px #ffffff;
        }
        
        .back-button:hover {
            transform: translateX(-5px);
            box-shadow: 5px 5px 10px #e8e8e8, -5px -5px 10px #ffffff;
            color: #1976d2;
        }
        
        .back-button i {
            transition: transform 0.3s ease;
        }
        
        .back-button:hover i {
            transform: translateX(-4px);
        }
        
        .dashboard__content-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .dashboard__content-title h4 {
            margin: 0;
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Questions List Styles */
        .questions-list {
            margin-top: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .accordion-button {
            background-color: #fff;
            color: #2c3e50;
            font-weight: 500;
            border: none;
            box-shadow: none;
            padding: 15px;
        }
        
        .accordion-button:not(.collapsed) {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .accordion-button:focus {
            box-shadow: none;
            border-color: #e0e0e0;
        }
        
        .accordion-item {
            border: 1px solid #e0e0e0;
            margin-bottom: 10px;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .question-details {
            padding: 15px;
        }
        
        .question-details p {
            margin-bottom: 8px;
        }
        
        .options-list {
            margin-top: 15px;
        }
        
        .option-item {
            display: flex;
            align-items: center;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            margin-bottom: 8px;
            position: relative;
        }
        
        .option-item.correct-option {
            background-color: #e8f5e9;
            border-color: #4caf50;
        }
        
        .option-marker {
            width: 24px;
            height: 24px;
            background-color: #f0f0f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            margin-right: 10px;
            font-size: 0.9rem;
        }
        
        .correct-option .option-marker {
            background-color: #4caf50;
            color: white;
        }
        
        .option-text {
            flex: 1;
        }
        
        .correct-badge {
            position: absolute;
            right: 10px;
            color: #4caf50;
        }
        
        .question-actions {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        
        .question-actions .custom-btn {
            margin-right: 8px;
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
            <div class="container">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <div class="col-lg-3">
                            <jsp:include page="../adminSidebar.jsp">
                                <jsp:param name="active" value="subjects"/>
                            </jsp:include>
                        </div>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title">
                                    <h4 class="title">Subject Content: ${subject.title}</h4>
                                    <a href="${pageContext.request.contextPath}/manage-subjects" class="back-button">
                                        <i class="fa fa-arrow-left"></i>
                                        <span>Back to Subjects</span>
                                    </a>
                                </div>
                                
                                <!-- Subject Header -->
                                <div class="subject-header">
                                    <h3 class="subject-title">${subject.title}</h3>
                                    <p class="subject-description">${subject.description}</p>
                                </div>
                                
                                <!-- Add Content Buttons -->
                                <div class="add-content-buttons">
                                    <h5><i class="fa fa-plus-circle"></i> Add New Content</h5>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/manage-subjects/add-lesson?subjectId=${subject.id}" 
                                           class="custom-btn main-action-btn btn-primary-soft">
                                            <i class="fa fa-book"></i>
                                            <span>Add New Lesson</span>
                                        </a>
                                    </div>
                                </div>
                                
                                <!-- Lessons List with Nested Quizzes -->
                                <div class="content-list">
                                    <div class="content-list-header">
                                        <h5><i class="fa fa-list"></i> Subject Content</h5>
                                    </div>
                                    <div class="content-items">
                                        <c:forEach var="lesson" items="${lessons}" varStatus="status">
                                            <!-- Lesson Item -->
                                            <div class="content-item lesson-item">
                                                <div class="lesson-count">${status.index + 1}</div>
                                                <div class="w-100">
                                                    <div class="lesson-header">
                                                        <div class="lesson-title-section">
                                                            <i class="fa fa-book-open"></i>
                                                            <p class="content-title mb-0">
                                                                ${lesson.title}
                                                                <span class="type-badge type-lesson">Lesson</span>
                                                                <c:set var="quizCount" value="0" />
                                                                <c:forEach var="quiz" items="${quizzes}">
                                                                    <c:if test="${quiz.lesson_id == lesson.id}">
                                                                        <c:set var="quizCount" value="${quizCount + 1}" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                <span class="quiz-count">${quizCount} Quizzes</span>
                                                            </p>
                                                        </div>
                                                        <div class="action-btn-group">
                                                            <a href="${pageContext.request.contextPath}/manage-subjects/add-quiz?lessonId=${lesson.id}" 
                                                               class="custom-btn btn-success-soft">
                                                                <i class="fa fa-plus"></i>
                                                                <span>Quiz</span>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/manage-subjects/edit-lesson?id=${lesson.id}" 
                                                               class="custom-btn btn-warning-soft">
                                                                <i class="fa fa-edit"></i>
                                                            </a>
                                                            <a href="javascript:void(0)" 
                                                               class="custom-btn btn-danger-soft delete-lesson-btn"
                                                               data-lesson-id="${lesson.id}"
                                                               data-lesson-title="${lesson.title}">
                                                                <i class="fa fa-trash"></i>
                                                            </a>
                                                        </div>
                                                    </div>

                                                    <!-- Nested Quizzes -->
                                                    <div class="nested-quizzes">
                                                        <c:set var="hasQuizzes" value="false" />
                                                        <c:forEach var="quiz" items="${quizzes}">
                                                            <c:if test="${quiz.lesson_id == lesson.id}">
                                                                <c:set var="hasQuizzes" value="true" />
                                                                <div class="quiz-item">
                                                                    <div class="d-flex justify-content-between align-items-center">
                                                                        <div class="d-flex align-items-center">
                                                                            <i class="fa fa-question-circle text-success me-2"></i>
                                                                            <p class="content-title mb-0">
                                                                                ${quiz.name}
                                                                                <span class="type-badge type-quiz">Quiz</span>
                                                                            </p>
                                                                        </div>
                                                                        <div class="action-btn-group">
                                                                            <a href="${pageContext.request.contextPath}/manage-subjects/view-quiz?id=${quiz.id}" 
                                                                               class="custom-btn btn-warning-soft">
                                                                                <i class="fa fa-edit"></i>
                                                                            </a>
                                                                            <a href="javascript:void(0)" 
                                                                               class="custom-btn btn-danger-soft delete-quiz-btn"
                                                                               data-quiz-id="${quiz.id}"
                                                                               data-quiz-name="${quiz.name}">
                                                                                <i class="fa fa-trash"></i>
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${!hasQuizzes}">
                                                            <div class="no-content-message">
                                                                <i class="fa fa-info-circle"></i>
                                                                No quizzes available for this lesson
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <c:if test="${empty lessons}">
                                            <div class="no-content-message">
                                                <i class="fa fa-info-circle"></i>
                                                No lessons available. Add your first lesson to get started.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Floating Action Button -->
                                <a href="${pageContext.request.contextPath}/manage-subjects/add-lesson?subjectId=${subject.id}" 
                                   class="floating-action-btn">
                                    <i class="fa fa-plus"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>

    <!-- JS here -->
    <jsp:include page="../../common/js/"></jsp:include>
    
    <!-- iziToast JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    
    <script>
        // Check for success parameter and show toast
        if ('${param.success}' === 'quiz_updated') {
            iziToast.success({
                title: 'Success',
                message: 'Quiz has been updated successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        if ('${param.success}' === 'lesson_added') {
            iziToast.success({
                title: 'Success',
                message: 'Lesson has been added successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        if ('${param.success}' === 'lesson_updated') {
            iziToast.success({
                title: 'Success',
                message: 'Lesson has been updated successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        if ('${param.success}' === 'quiz_added') {
            iziToast.success({
                title: 'Success',
                message: 'Quiz has been added successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        if ('${param.success}' === 'lesson_deleted') {
            iziToast.success({
                title: 'Success',
                message: 'Lesson has been deleted successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        if ('${param.success}' === 'quiz_deleted') {
            iziToast.success({
                title: 'Success',
                message: 'Quiz has been deleted successfully',
                position: 'topRight',
                timeout: 5000,
                closeOnClick: true,
                pauseOnHover: true
            });
        }
        
        // Handle delete lesson
        document.addEventListener('DOMContentLoaded', function() {
            const deleteLessonBtns = document.querySelectorAll('.delete-lesson-btn');
            deleteLessonBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const lessonId = this.getAttribute('data-lesson-id');
                    const lessonTitle = this.getAttribute('data-lesson-title');
                    
                    if (confirm('Are you sure you want to delete lesson "' + lessonTitle + '"?\n\nThis will also delete all quizzes in this lesson and cannot be undone.')) {
                        window.location.href = '${pageContext.request.contextPath}/manage-subjects/delete-lesson?id=' + lessonId;
                    }
                });
            });
            
            const deleteQuizBtns = document.querySelectorAll('.delete-quiz-btn');
            deleteQuizBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const quizId = this.getAttribute('data-quiz-id');
                    const quizName = this.getAttribute('data-quiz-name');
                    
                    if (confirm('Are you sure you want to delete quiz "' + quizName + '"?\n\nThis will also delete all questions and options in this quiz and cannot be undone.')) {
                        window.location.href = '${pageContext.request.contextPath}/manage-subjects/delete-quiz?id=' + quizId;
                    }
                });
            });
        });
    </script>
</body>
</html>
