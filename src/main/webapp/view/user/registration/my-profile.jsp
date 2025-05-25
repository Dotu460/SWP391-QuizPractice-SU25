<%-- 
    Document   : my-profile
    Created on : 24 thg 5, 2025, 14:49:11
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
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
                                <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors02.jpg" alt="img">
                            </div>
                            <div class="content">
                                <h4 class="title">Emily Hannah</h4>
                                <ul class="list-wrap">
                                    <li>
                                        <img src="${pageContext.request.contextPath}/view/common/img/icons/course_icon03.svg" alt="img" class="injectable">
                                        10 Courses Enrolled
                                    </li>
                                    <li>
                                        <img src="${pageContext.request.contextPath}/view/common/img/icons/course_icon05.svg" alt="img" class="injectable">
                                        7 Certificate
                                    </li>
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
                                        <div class="col-lg-12">
                                            <div class="profile__content-wrap">
                                                <ul class="list-wrap">
                                                    <li><span>Registration Date</span> February 28, 2026 8:01 am</li>
                                                    <li><span>First Name</span> Emily</li>
                                                    <li><span>Last Name</span> Hannah</li>
                                                    <li><span>Username</span> instructor</li>
                                                    <li><span>Email</span> info@skillgrodemo.com</li>
                                                    <li><span>Phone Number</span> +123 599 8989</li>
                                                    <li><span>Skill/Occupation</span> Graphic Design</li>
                                                    <li><span>Biography</span> I am eager to bring my passion for creating user-friendly and efficient web interfaces to your dynamic team. I am applying for Front End Developer position in your company.</li>
                                                </ul>
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

</html>