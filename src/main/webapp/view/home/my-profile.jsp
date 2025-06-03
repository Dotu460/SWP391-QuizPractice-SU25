<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>My Profile - SkillGro</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
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
            <!-- dashboard-area -->
            <section class="dashboard__area section-pb-120">
                <div class="dashboard__bg"><img src="${pageContext.request.contextPath}/view/common/img/bg/dashboard_bg.jpg" alt=""></div>
                <div class="container">
                    <div class="dashboard__top-wrap">
                        <div class="dashboard__top-bg" data-background="${pageContext.request.contextPath}/view/common/img/bg/student_bg.jpg"></div>
                        <div class="dashboard__instructor-info">
                            <div class="dashboard__instructor-info-left">
                                <div class="thumb">
                                    <img src="${user.avatar != null ? user.avatar : pageContext.request.contextPath.concat('/view/common/img/default-avatar.jpg')}" alt="User Avatar">
                                </div>
                                <div class="content">
                                    <h4 class="title">${user.fullName}</h4>
                                    <ul class="list-wrap">
                                        <li><span>Member since:</span> ${user.createdDate}</li>
                                        <li><span>Last login:</span> ${user.lastLogin}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                            <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>

                            <div class="col-lg-9">
                                <div class="dashboard__content-wrap">
                                    <div class="dashboard__content-title">
                                        <h4 class="title">My Profile</h4>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="profile-overview">
                                                <div class="row mb-4">
                                                    <div class="col-md-4">
                                                        <div class="stat-card">
                                                            <h5>Enrolled Courses</h5>
                                                            <h2>${userStats.enrolledCourses}</h2>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="stat-card">
                                                            <h5>Completed Courses</h5>
                                                            <h2>${userStats.completedCourses}</h2>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="stat-card">
                                                            <h5>Certificates Earned</h5>
                                                            <h2>${userStats.certificatesEarned}</h2>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Recent Activities -->
                                                <div class="section-title mb-3">
                                                    <h5>Recent Activities</h5>
                                                </div>
                                                <div class="activities-list mb-4">
                                                    <c:forEach var="activity" items="${recentActivities}">
                                                        <div class="activity-item">
                                                            <div class="activity-icon">
                                                                <i class="${activity.icon}"></i>
                                                            </div>
                                                            <div class="activity-content">
                                                                <p>${activity.description}</p>
                                                                <small class="text-muted">${activity.date}</small>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <!-- Learning Progress -->
                                                <div class="section-title mb-3">
                                                    <h5>Learning Progress</h5>
                                                </div>
                                                <div class="progress-list">
                                                    <c:forEach var="course" items="${inProgressCourses}">
                                                        <div class="course-progress mb-3">
                                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                                <h6>${course.title}</h6>
                                                                <span>${course.progressPercentage}%</span>
                                                            </div>
                                                            <div class="progress">
                                                                <div class="progress-bar" role="progressbar" 
                                                                     style="width: ${course.progressPercentage}%" 
                                                                     aria-valuenow="${course.progressPercentage}" 
                                                                     aria-valuemin="0" 
                                                                     aria-valuemax="100">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <!-- Quick Actions -->
                                                <div class="section-title mb-3">
                                                    <h5>Quick Actions</h5>
                                                </div>
                                                <div class="quick-actions">
                                                    <a href="edit-profile" class="btn btn-primary">Edit Profile</a>
                                                    <a href="my-courses" class="btn btn-info">My Courses</a>
                                                    <a href="certificates" class="btn btn-success">View Certificates</a>
                                                    <a href="account-settings" class="btn btn-warning">Account Settings</a>
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
            <!-- dashboard-area-end -->
        </main>
        <!-- main-area-end -->

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
    </body>
</html>
