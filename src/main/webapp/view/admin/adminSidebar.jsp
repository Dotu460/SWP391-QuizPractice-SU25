<%--
  Created by IntelliJ IDEA.
  User: Tien Hoang
  Date: 6/3/2025
  Time: 9:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="dashboard__sidebar-wrap">
    <div class="dashboard__sidebar-title mb-20">
        <h6 class="title">, ${sessionScope.user.full_name != null ? sessionScope.user.full_name : 'Admin'}</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'users' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i>
                    Users
                </a>
            </li>
            <li class="${param.active == 'registrations' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/registrations">
                    <i class="skillgro-book-2"></i>
                    Registrations
                </a>
            </li>
             <li class="${param.active == 'price-package' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/price-package-list">
                    <i class="skillgro-book-2"></i>
                    Price Package
                </a>
            </li>
        </ul>
    </nav>

    <div class="dashboard__sidebar-title mt-40 mb-20">
        <h6 class="title">Admin, Expert</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'subjects' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/subjects">
                    <i class="skillgro-book"></i>
                    Subjects
                </a>
            </li>
            <li class="${param.active == 'questions-list' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/questions-list">
                    <i class="skillgro-avatar"></i>
                    Questions
                </a>
            </li>
            <li class="${param.active == 'quizzes-lists' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/quizzes-list">
                    <i class="skillgro-avatar"></i>
                    Quiz
                </a>
            </li>
            <li class="${param.active == 'manage-subjects' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/manage-subjects">
                    <i class="skillgro-video-tutorial"></i>
                    Manage Subject
                </a>
            </li>
        </ul>
    </nav>
    <div class="dashboard__sidebar-title mt-40 mb-20">
        <h6 class="title">Grading</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'grading' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/expert/essay-grading">
                    <i class="skillgro-video-tutorial"></i>
                    essay grading
                </a>
            </li>
        </ul>
    </nav>
    <div class="dashboard__sidebar-title mt-40 mb-20">
        <h6 class="title">Setting</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'setting' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/setting">
                    <i class="skillgro-video-tutorial"></i>
                    Setting
                </a>
            </li>
        </ul>
    </nav>

</div>
