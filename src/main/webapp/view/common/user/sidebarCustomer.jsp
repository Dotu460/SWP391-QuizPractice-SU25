<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-lg-3">
    <!-- Dropdown Search Box -->
    <div class="dashboard__sidebar-title mt-30 mb-10">
        <h6 class="title">Search & Filter</h6>
    </div>
    <div style="margin-bottom:50px;">
        <form action="${pageContext.request.contextPath}/my-registration" method="get" class="dashboard_sidebar_search-form">
            <div style="display: flex; align-items: center; border: 1px solid #ccc; border-radius: 3px; overflow: hidden; margin-bottom: 10px;">
                <input type="text" name="searchName" placeholder="Search by Subject Name" value="${currentSearchName}" style="flex: 1; border: none; padding: 10px; outline: none;" />
            </div>
            
            <!-- Subject Filter Dropdown -->
            <div style="border: 1px solid #ccc; border-radius: 3px; overflow: hidden; margin-bottom:10px;">
                <select name="subjectId" style="width: 100%; border: none; padding: 10px; outline: none; background-color: white;">
                    <option value="0">All Subjects</option>
                    <c:forEach var="subject" items="${allSubjects}">
                        <option value="${subject.id}" ${subject.id eq currentSubjectId ? 'selected' : ''}>${subject.title}</option>
                    </c:forEach>
                </select>
            </div>
            
            <button type="submit" style="background-color: #007bff; color: white; border: none; padding: 10px 15px; cursor: pointer; width:100%; border-radius:3px;">
                Apply Filters
            </button>
        </form>
    </div>

    <div class="dashboard__sidebar-wrap">
        <div class="dashboard__sidebar-title mb-20">
            <h6 class="title">Welcome, Jone Due</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="instructor-profile.html">
                        <i class="skillgro-avatar"></i>
                        My Profile
                    </a>
                </li>
                <li>
                    <a href="instructor-attempts.html">
                        <i class="skillgro-question"></i>
                        My Quiz Attempts
                    </a>
                </li>
                <li class = "active">
                    <a href="instructor-history.html">
                        <i class="skillgro-satchel"></i>
                        My Registration
                    </a>
                </li>
            </ul>
        </nav>

        <div class="dashboard__sidebar-title mt-30 mb-20">
            <h6 class="title">User</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="index.html">
                        <i class="skillgro-logout"></i>
                        Logout
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>
