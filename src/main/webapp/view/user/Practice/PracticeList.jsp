<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Online Courses & Education Template</title>
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
                <div class="container-fluid px-0">
                    <div class="dashboard__top-wrap">
                        <div class="dashboard__top-bg" data-background="${pageContext.request.contextPath}/view/common/img/bg/student_bg.jpg"></div>
                        <div class="dashboard__instructor-info">
                            <div class="dashboard__instructor-info-left">
                                <div class="thumb">
                                    <c:choose>
                                        <c:when test="${not empty currentUser.avatar_url}">
                                            <img src="${pageContext.request.contextPath}${currentUser.avatar_url}" alt="User Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors02.jpg" alt="Default Avatar">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="content">
                                    <h4 class="title">${not empty currentUser.full_name ? currentUser.full_name : 'User'}</h4>
                                    <ul class="list-wrap">
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
                                    <h4 class="title">My Quiz Attempts</h4>
                                </div>
                                <div class="row">
                                    <div class="col-12">
                                        <div class="dashboard__review-table">
                                            <table class="table table-borderless">
                                                <thead>
                                                    <tr>
                                                        <th>Quiz</th>
                                                        <th>Qus</th>
                                                        <th>TM</th>
                                                        <th>CA</th>
                                                        <th>Result</th>
                                                        <th>&nbsp;</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <div class="dashboard__quiz-info">
                                                                <p>January 20, 2024</p>
                                                                <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                <span>Student: <a href="#">John Due</a></span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">5</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">9</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">3</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">Pass</span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/practice-details" title="View Detail"><i class="skillgro-edit"></i></a>
                                                               
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
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
