<%-- 
    Document   : my-profile
    Created on : 24 thg 5, 2025, 14:49:11
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - My Profile</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .profile-picture-container {
                position: relative;
                width: 100px; /* Adjust to match your desired avatar size */
                height: 100px; /* Adjust to match your desired avatar size */
                border-radius: 50%; /* For circular avatars */
                overflow: hidden; 
                cursor: pointer;
                margin-bottom: 15px; /* Space below avatar */
            }
            .profile-picture-container img {
                display: block;
                width: 100%;
                height: 100%;
                object-fit: cover; /* Ensures the image covers the area without distortion */
            }
            .change-picture-form-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                color: white;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                opacity: 0;
                transition: opacity 0.3s ease;
                text-align: center;
                padding: 5px;
            }
            .profile-picture-container:hover .change-picture-form-overlay {
                opacity: 1;
            }
            .change-picture-form-overlay .form-label {
                font-size: 0.8em;
                margin-bottom: 3px;
                display: block;
            }
            .change-picture-form-overlay .form-control-sm {
                font-size: 0.8em;
                max-width: 90%;
                margin-bottom: 5px;
            }
            .change-picture-form-overlay .btn-sm {
                font-size: 0.8em;
                padding: 3px 8px;
            }
        </style>
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
            <div class="dashboard__bg"><img src="<c:url value='/view/common/img/bg/dashboard_bg.jpg'/>" alt="Dashboard Background"></div>
            <div class="container">
                <div class="dashboard__top-wrap">
                    <div class="dashboard__top-bg" data-background="<c:url value='/view/common/img/bg/student_bg.jpg'/>"></div>
                    <div class="dashboard__instructor-info">
                        <div class="dashboard__instructor-info-left">
                            <div class="profile-picture-container">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar_url && sessionScope.user.avatar_url ne '/images/default.jpg'}">
                                        <img src="<c:url value='${sessionScope.user.avatar_url}'/>" alt="User Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/view/common/img/courses/default_avatar.png'/>" alt="Default Avatar">
                                    </c:otherwise>
                                </c:choose>
                                <form method="POST" action="<c:url value='/my-profile'/>" enctype="multipart/form-data" class="change-picture-form-overlay">
                                    <input type="hidden" name="action" value="changePicture">
                                    <label for="avatarUpload" class="form-label">Change Picture</label>
                                    <input type="file" class="form-control form-control-sm" id="avatarUpload" name="avatar" accept="image/*" required onchange="this.form.submit()">
                                    <%-- Small invisible submit button, form submitted by onchange event --%>
                                    <button type="submit" class="btn btn-sm btn-secondary" style="display:none;">Upload</button> 
                                </form>
                            </div>
                            <div class="content">
                                <h4 class="title">${sessionScope.user.full_name != null ? sessionScope.user.full_name : 'User Name'}</h4>
                                <c:if test="${not empty sessionScope.user.avatar_url && sessionScope.user.avatar_url ne '/images/default.jpg'}">
                                    <form method="POST" action="<c:url value='/my-profile'/>" style="margin-top: 10px;">
                                        <input type="hidden" name="action" value="deletePicture">
                                        <button type="submit" class="btn btn-sm btn-danger">Remove Picture</button>
                                    </form>
                                </c:if>
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
                                    
                                    <!-- Display success/error messages -->
                                    <c:if test="${not empty message}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            ${message}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        </div>
                                    </c:if>

                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="profile__content-wrap">
                                                <form method="POST" action="<c:url value='/my-profile'/>">
                                                    <input type="hidden" name="action" value="updateProfile">
                                                    
                                                                                        <div class="form-group mb-3">
                                        <label for="profileRole">Role</label>
                                        <input type="text" class="form-control" id="profileRole" name="role" 
                                               value="${roleDAO.getRoleNameById(sessionScope.user.role_id)}" 
                                               readonly style="background-color: #f8f9fa; cursor: not-allowed;">
                                        <small class="form-text text-muted">Role cannot be changed</small>
                                    </div>
                                                    
                                                    <div class="form-group mb-3">
                                                        <label for="profileFullName">Full Name</label>
                                                        <input type="text" class="form-control" id="profileFullName" name="full_name" value="${sessionScope.user.full_name}" required>
                                                    </div>
                                                    
                                                    <div class="form-group mb-3">
                                                        <label for="profileEmail">Email</label>
                                                        <input type="email" class="form-control" id="profileEmail" name="email" value="${sessionScope.user.email}" readonly style="background-color: #f8f9fa; cursor: not-allowed;">
                                                        <small class="form-text text-muted">Email cannot be changed</small>
                                                    </div>
                                                    
                                                    <div class="form-group mb-3">
                                                        <label for="profileMobile">Phone Number</label>
                                                        <input type="text" class="form-control ${not empty phoneError ? 'is-invalid' : ''}" 
                                                               id="profileMobile" name="mobile" 
                                                               value="${not empty invalidPhone ? invalidPhone : sessionScope.user.mobile}">
                                                        <c:if test="${not empty phoneError}">
                                                            <div class="invalid-feedback">
                                                                ${phoneError}
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    
                                                    <div class="form-group mb-3">
                                                        <label for="profileGender">Gender</label>
                                                        <select class="form-control" id="profileGender" name="gender">
                                                            <option value="" disabled ${empty sessionScope.user.gender ? 'selected' : ''}>Select Gender</option>
                                                            <option value="0" ${sessionScope.user.gender == 0 ? 'selected' : ''}>Male</option>
                                                            <option value="1" ${sessionScope.user.gender == 1 ? 'selected' : ''}>Female</option>
                                                            <option value="2" ${sessionScope.user.gender == 2 ? 'selected' : ''}>Other</option>
                                                        </select>
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
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

</html>