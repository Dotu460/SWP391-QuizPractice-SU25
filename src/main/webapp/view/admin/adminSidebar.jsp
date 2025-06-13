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
        <h6 class="title">Welcome, ${sessionScope.user.full_name != null ? sessionScope.user.full_name : 'Admin'}</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
            </li>
            <li class="${param.active == 'profile' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/profile">
                    <i class="skillgro-avatar"></i>
                    My Profile
                </a>
            </li>
            <li class="${param.active == 'subjects' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/subjects">
                    <i class="skillgro-book"></i>
                    Subjects
                </a>
            </li>
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
            <li class="${param.active == 'courses' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/courses">
                    <i class="skillgro-video-tutorial"></i>
                    Courses
                </a>
            </li>


            <li class="${param.active == 'announcements' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/announcements">
                    <i class="skillgro-marketing"></i>
                    Announcements
                </a>
            </li>
            <li class="${param.active == 'quiz' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/quiz">
                    <i class="skillgro-chat"></i>
                    Quiz Attempts
                </a>
            </li>
        </ul>
    </nav>
    <div class="dashboard__sidebar-title mt-40 mb-20">
        <h6 class="title">USER</h6>
    </div>
    <nav class="dashboard__sidebar-menu">
        <ul class="list-wrap">
            <li class="${param.active == 'settings' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/settings">
                    <i class="skillgro-settings"></i>
                    Settings
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="skillgro-logout"></i>
                    Logout
                </a>
            </li>
        </ul>
    </nav>
</div>
