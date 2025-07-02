<%-- 
    Document   : manage-edit-lesson
    Created on : 29 thg 6, 2025, 10:56:52
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Edit Lesson</title>
    <meta name="description" content="SkillGro - Edit Lesson">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px 15px;
            width: 100%;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
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
        <section class="course-details-area pt-120 pb-100">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12 col-lg-12">
                        <div class="form-container">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="mb-0">Edit Lesson: ${lesson.title}</h4>
                                <a href="${pageContext.request.contextPath}/manage-subjects/view?id=${subject.id}" class="back-button">
                                    <i class="fa fa-arrow-left"></i> Back to Subject Content
                                </a>
                            </div>
                            
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" style="margin-bottom: 20px;">${errorMessage}</div>
                            </c:if>
                            
                            <!-- Edit Form -->
                            <form action="${pageContext.request.contextPath}/manage-subjects/edit-lesson" method="post">
                                <input type="hidden" name="lessonId" value="${lesson.id}">
                                
                                <!-- Basic Information -->
                                <div class="form-section">
                                    <h5 class="form-section-title">Lesson Information</h5>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Lesson Title</label>
                                        <input type="text" class="form-control" name="title" value="${lesson.title}" required>
                                        <small class="form-text">Enter the lesson title</small>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Lesson Content</label>
                                        <textarea class="form-control" name="content_text" rows="8" placeholder="Enter lesson content here...">${lesson.content_text}</textarea>
                                        <small class="form-text">Provide the main content of the lesson</small>
                                    </div>
                                </div>
                                
                                <!-- Status Information -->
                                <div class="form-section">
                                    <h5 class="form-section-title">Status</h5>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Status</label>
                                        <select name="status" class="form-control" required>
                                            <option value="active" ${lesson.status == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="hidden" ${lesson.status == 'hidden' ? 'selected' : ''}>Hidden</option>
                                        </select>
                                        <small class="form-text">Choose lesson visibility status</small>
                                    </div>
                                </div>
                                
                                <!-- Form Actions -->
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/manage-subjects/view?id=${subject.id}" class="btn btn-outline-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">Update Lesson</button>
                                </div>
                            </form>
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
