<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Essay Grading</title>
        <meta name="description" content="SkillGro - Essay Grading">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        
        <style>
            .main-content {
                min-height: calc(100vh - 200px);
                padding: 20px 0;
                background-color: #f8f9fa;
            }
            
            .dashboard__content-area {
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .dashboard__content-title {
                margin-bottom: 30px;
            }
            
            .dashboard__content-title h4 {
                color: #1A1B3D;
                font-weight: 600;
                margin: 0;
            }
            
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 0;
            }
            
            .table th, .table td {
                padding: 15px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
            }
            
            .table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #1A1B3D;
                border-top: none;
            }
            
            .table tbody tr:hover {
                background-color: #f8f9fa;
            }
            
            .btn-grade {
                background: #5751E1;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            
            .btn-grade:hover {
                background: #4a45c7;
                color: white;
                text-decoration: none;
                transform: translateY(-1px);
            }
            
            .badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
            }
            
            .badge-warning {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }
            
            .badge-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 8px;
                border: none;
            }
            
            .alert-info {
                background-color: #d1ecf1;
                color: #0c5460;
            }
            
            .alert-success {
                background-color: #d4edda;
                color: #155724;
            }
            
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .no-data {
                text-align: center;
                padding: 40px 20px;
                color: #6c757d;
            }
            
            .no-data i {
                font-size: 48px;
                margin-bottom: 15px;
                color: #dee2e6;
            }
            
            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .user-avatar {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: #5751E1;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 14px;
            }
            
            .quiz-info {
                font-size: 14px;
                color: #6c757d;
            }
            
            .status-indicator {
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }
            
            .status-indicator::before {
                content: '';
                width: 8px;
                height: 8px;
                border-radius: 50%;
                display: inline-block;
            }
            
            .status-partially_graded::before {
                background-color: #ffc107;
            }
            
            .status-completed::before {
                background-color: #28a745;
            }
        </style>
    </head>
    <body>
        <!-- header-area -->
        <jsp:include page="../../common/user/header.jsp"></jsp:include>
        <!-- header-area-end -->

        <!-- main-area-start -->
        <main>
            <section class="main-content">
                <div class="container">
                    <div class="row">
                        <!-- Sidebar -->
                        <div class="col-xl-3 col-lg-4">
                            <jsp:include page="../../admin/adminSidebar.jsp"></jsp:include>
                        </div>
                        
                        <!-- Main Content -->
                        <div class="col-xl-9 col-lg-8">
                            <div class="dashboard__content-area">
                                <div class="dashboard__content-title">
                                    <h4><i class="fas fa-graduation-cap me-2"></i>Essay Grading Management</h4>
                                </div>
                                
                                <!-- Success/Error Messages -->
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>
                                
                                <!-- Debug info (comment out in production) -->
                                <!-- 
                                <div class="alert alert-info">
                                    <h6><i class="fas fa-info-circle me-2"></i>Debug Information:</h6>
                                    <ul class="mb-0">
                                        <li>attempts: ${not empty attempts ? attempts.size() : 'null'}</li>
                                        <li>userMap: ${not empty userMap ? userMap.size() : 'null'}</li>
                                        <li>quizMap: ${not empty quizMap ? quizMap.size() : 'null'}</li>
                                        <li>allQuizzes: ${not empty allQuizzes ? allQuizzes.size() : 'null'}</li>
                                        <li>currentPage: ${currentPage}</li>
                                        <li>pageSize: ${pageSize}</li>
                                        <li>totalPages: ${totalPages}</li>
                                        <li>totalAttempts: ${totalAttempts}</li>
                                    </ul>
                                </div>
                                -->
                                
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-white border-0 py-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0 text-dark">
                                                <i class="fas fa-list me-2"></i>Essay Grading List
                                            </h5>
                                            <span class="badge bg-primary">${totalAttempts} attempts</span>
                                        </div>
                                    </div>
                                    <div class="card-body p-0">
                                        <c:choose>
                                            <c:when test="${empty attempts}">
                                                <div class="no-data">
                                                    <i class="fas fa-inbox"></i>
                                                    <h5>No attempts found</h5>
                                                    <p>There are no essay attempts that need grading at the moment.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th width="5%">#</th>
                                                                <th width="20%">Student</th>
                                                                <th width="25%">Quiz</th>
                                                                <th width="15%">Start Time</th>
                                                                <th width="15%">Status</th>
                                                                <th width="10%">Progress</th>
                                                                <th width="10%">Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${attempts}" var="attempt" varStatus="loop">
                                                                <tr>
                                                                    <td>
                                                                        <span class="fw-bold">${(currentPage - 1) * pageSize + loop.index + 1}</span>
                                                                    </td>
                                                                    <td>
                                                                        <div class="user-info">
                                                                            <div class="user-avatar">
                                                                                <c:if test="${not empty userMap[attempt.user_id]}">
                                                                                    <c:set var="user" value="${userMap[attempt.user_id]}" />
                                                                                    ${fn:substring(user.full_name, 0, 1)}
                                                                                </c:if>
                                                                                <c:if test="${empty userMap[attempt.user_id]}">
                                                                                    ?
                                                                                </c:if>
                                                                            </div>
                                                                            <div>
                                                                                <div class="fw-semibold">
                                                                                    <c:if test="${not empty userMap[attempt.user_id]}">
                                                                                        <c:set var="user" value="${userMap[attempt.user_id]}" />
                                                                                        ${user.full_name}
                                                                                    </c:if>
                                                                                    <c:if test="${empty userMap[attempt.user_id]}">
                                                                                        Unknown User
                                                                                    </c:if>
                                                                                </div>
                                                                                <div class="quiz-info">ID: ${attempt.user_id}</div>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div>
                                                                            <div class="fw-semibold">
                                                                                <c:if test="${not empty quizMap[attempt.quiz_id]}">
                                                                                    <c:set var="quiz" value="${quizMap[attempt.quiz_id]}" />
                                                                                    ${quiz.name}
                                                                                </c:if>
                                                                                <c:if test="${empty quizMap[attempt.quiz_id]}">
                                                                                    Quiz ID: ${attempt.quiz_id}
                                                                                </c:if>
                                                                            </div>
                                                                            <div class="quiz-info">
                                                                                <i class="fas fa-clock me-1"></i>
                                                                                <fmt:formatDate value="${attempt.start_time}" pattern="dd/MM/yyyy HH:mm" />
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatDate value="${attempt.start_time}" pattern="dd/MM/yyyy" />
                                                                        <br>
                                                                        <small class="text-muted">
                                                                            <fmt:formatDate value="${attempt.start_time}" pattern="HH:mm" />
                                                                        </small>
                                                                    </td>
                                                                    <td>
                                                                        <span class="status-indicator status-${attempt.status}">
                                                                            <c:choose>
                                                                                <c:when test="${attempt.status == 'partially_graded'}">
                                                                                    <span class="badge badge-warning">Partially Graded</span>
                                                                                </c:when>
                                                                                <c:when test="${attempt.status == 'completed'}">
                                                                                    <span class="badge badge-success">Completed</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge bg-secondary">${attempt.status}</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <c:if test="${not empty essayCountMap[attempt.id]}">
                                                                            <c:set var="totalEssays" value="${essayCountMap[attempt.id]}" />
                                                                            <c:set var="gradedEssays" value="${gradedEssayCountMap[attempt.id]}" />
                                                                            <div class="progress" style="height: 6px;">
                                                                                <div class="progress-bar bg-success" 
                                                                                     style="width: ${totalEssays > 0 ? (gradedEssays / totalEssays * 100) : 0}%">
                                                                                </div>
                                                                            </div>
                                                                            <small class="text-muted">
                                                                                ${gradedEssays}/${totalEssays} graded
                                                                            </small>
                                                                        </c:if>
                                                                        <c:if test="${empty essayCountMap[attempt.id]}">
                                                                            <small class="text-muted">No essays</small>
                                                                        </c:if>
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/essay-score?attemptId=${attempt.id}" 
                                                                           class="btn btn-grade">
                                                                            <i class="fas fa-edit me-1"></i>Grade
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                
                                                <!-- Pagination -->
                                                <c:if test="${totalPages > 1}">
                                                    <div class="card-footer bg-white border-0 py-3">
                                                        <nav aria-label="Essay grading pagination">
                                                            <ul class="pagination justify-content-center mb-0">
                                                                <c:if test="${currentPage > 1}">
                                                                    <li class="page-item">
                                                                        <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
                                                                            <i class="fas fa-chevron-left"></i>
                                                                        </a>
                                                                    </li>
                                                                </c:if>
                                                                
                                                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                                        <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}">${pageNum}</a>
                                                                    </li>
                                                                </c:forEach>
                                                                
                                                                <c:if test="${currentPage < totalPages}">
                                                                    <li class="page-item">
                                                                        <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                                                            <i class="fas fa-chevron-right"></i>
                                                                        </a>
                                                                    </li>
                                                                </c:if>
                                                            </ul>
                                                        </nav>
                                                    </div>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
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