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
                                <h4 class="title">${user.full_name != null ? user.full_name : 'User Name'}</h4>
                                <!-- Form for changing profile picture -->
                                <form method="POST" action="${pageContext.request.contextPath}/my-profile" enctype="multipart/form-data" class="mt-2">
                                    <input type="hidden" name="action" value="changePicture">
                                    <div class="form-group mb-2">
                                        <label for="avatarUpload" class="form-label">Change Profile Picture</label>
                                        <input type="file" class="form-control form-control-sm" id="avatarUpload" name="avatar" accept="image/*" required>
                                    </div>
                                    <button type="submit" class="btn btn-sm btn-secondary">Upload New Picture</button>
                                </form>
                                <!-- End of form for changing profile picture -->
                            </div>
                        </div>
                    </div>
                </div>
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                           <jsp:include page="../../common/user/sidebarAllCustomer.jsp"></jsp:include>
                           
                            <div class="col-lg-9">
                                <div class="dashboard__content-wrap">
                                    <div class="dashboard__content-title">
                                        <h4 class="title">My Profile</h4>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="profile__content-wrap">
                                                <form method="POST" action="${pageContext.request.contextPath}/my-profile">
                                                    <input type="hidden" name="action" value="updateProfile">
                                                    <div class="form-group mb-3">
                                                        <label for="profileFullName">Full Name</label>
                                                        <input type="text" class="form-control" id="profileFullName" name="full_name" value="${user.full_name}">
                                                    </div>
                                                    <div class="form-group mb-3">
                                                        <label for="profileUsername">Username</label>
                                                        <input type="text" class="form-control" id="profileUsername" name="username" value="instructor" readonly>
                                                    </div>
                                                    <div class="form-group mb-3">
                                                        <label for="profileEmail">Email</label>
                                                        <input type="email" class="form-control" id="profileEmail" name="email" value="${user.email}">
                                                    </div>
                                                    <div class="form-group mb-3">
                                                        <label for="profileMobile">Phone Number</label>
                                                        <input type="text" class="form-control" id="profileMobile" name="mobile" value="${user.mobile}">
                                                    </div>
                                                    <div class="form-group mb-3">
                                                        <label for="profileSkillOccupation">gender</label>
                                                        <input type="text" class="form-control" id="profileSkillOccupation" name="skill_occupation" value=" ">
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Update Profile</button>
                                                </form>
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