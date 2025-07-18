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
        <!-- CSS includes -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/view/common/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/view/common/css/fontawesome-all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                line-height: 1.6;
                color: #333;
                background-color: #f8f9fa;
            }
            .container {
                padding: 20px;
            }
            .card {
                background: #fff;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .card-header {
                background: #5751E1;
                color: white;
                padding: 15px 20px;
                border-radius: 5px 5px 0 0;
            }
            .card-body {
                padding: 20px;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
            }
            .table th, .table td {
                padding: 12px 15px;
                border-bottom: 1px solid #ddd;
            }
            .table th {
                background-color: #f8f9fa;
                font-weight: bold;
            }
            .btn {
                display: inline-block;
                padding: 8px 16px;
                background: #5751E1;
                color: white;
                border-radius: 4px;
                text-decoration: none;
            }
            .badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
            }
            .badge-warning {
                background: #ffc107;
                color: #000;
            }
            .badge-success {
                background: #28a745;
                color: #fff;
            }
            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-info {
                background-color: #d1ecf1;
                color: #0c5460;
                border: 1px solid #bee5eb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Essay Grading</h1>
            
<!--             Debug info 
            <div class="alert alert-info">
                <h4>Debug Information:</h4>
                <ul>
                    <li>attempts: ${not empty attempts ? attempts.size() : 'null'}</li>
                    <li>userMap: ${not empty userMap ? userMap.size() : 'null'}</li>
                    <li>quizMap: ${not empty quizMap ? quizMap.size() : 'null'}</li>
                    <li>allQuizzes: ${not empty allQuizzes ? allQuizzes.size() : 'null'}</li>
                    <li>currentPage: ${currentPage}</li>
                    <li>pageSize: ${pageSize}</li>
                    <li>totalPages: ${totalPages}</li>
                    <li>totalAttempts: ${totalAttempts}</li>
                </ul>
            </div>-->
            
            <div class="card">
                <div class="card-header">
                    <h2>Essay Grading List</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty attempts}">
                            <p>No attempts found that need grading.</p>
                        </c:when>
                        <c:otherwise>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>User ID</th>
                                        <th>Student</th>
                                        <th>Quiz</th>
                                        <th>Start Time</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${attempts}" var="attempt" varStatus="loop">
                                        <tr>
                                            <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                            <td>${attempt.user_id}</td>
                                            <td>
                                                <c:if test="${not empty userMap[attempt.user_id]}">
                                                    <c:set var="user" value="${userMap[attempt.user_id]}" />
                                                    ${user.full_name}
                                                </c:if>
                                                <c:if test="${empty userMap[attempt.user_id]}">
                                                    Unknown User
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty quizMap[attempt.quiz_id]}">
                                                    <c:set var="quiz" value="${quizMap[attempt.quiz_id]}" />
                                                    ${quiz.name}
                                                </c:if>
                                                <c:if test="${empty quizMap[attempt.quiz_id]}">
                                                    Quiz ID: ${attempt.quiz_id}
                                                </c:if>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${attempt.start_time}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${attempt.status == 'partially_graded'}">
                                                        <span class="badge badge-warning">Partially Graded</span>
                                                    </c:when>
                                                    <c:when test="${attempt.status == 'completed'}">
                                                        <span class="badge badge-success">Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${attempt.status}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/essay-score?attemptId=${attempt.id}" 
                                                   class="btn">Grade</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- JS includes -->
        <script src="${pageContext.request.contextPath}/view/common/js/vendor/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/view/common/js/bootstrap.min.js"></script>
    </body>
</html> 