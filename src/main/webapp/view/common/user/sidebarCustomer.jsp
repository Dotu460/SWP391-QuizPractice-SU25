<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-lg-3">
    <div class="dashboard__sidebar-wrap">
        <div class="dashboard__sidebar-title mb-20">
            <h6 class="title">
                Welcome,
                <c:choose>
                    <c:when test="${not empty sessionScope.account and not empty sessionScope.account.full_name}">
                        ${sessionScope.account.full_name}
                    </c:when>
                    <c:otherwise>
                        User
                    </c:otherwise>
                </c:choose>
            </h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="${pageContext.request.contextPath}/my-profile">
                        <i class="skillgro-avatar"></i>
                        My Profile
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/blog">
                        <i class="skillgro-question"></i>
                        Blog List
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/price-package-menu">
                        <i class="skillgro-satchel"></i>
                        Course
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
                    <a href= "${pageContext.request.contextPath}/logout">
                        <i class="skillgro-logout"></i>
                        Logout
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>
