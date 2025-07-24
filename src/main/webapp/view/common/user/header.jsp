<%-- 
    Document   : header
    Created on : 23 thg 5, 2025, 23:36:22
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
    <!-- header-top -->
    <div class="header-top-wrap">
        <div class="container">
            <div class="header-top">
                <div class="row align-items-center">
                    <div class="col-lg-10">
                        <div class="header-top-left">
                            <ul class="list-inline">
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/map_marker.svg" alt="location" class="icon">
                                    Hoa Lac Hi-tech Park, Km29, Thang Long Boulevard, Thach Hoa, Thach That, Ha Noi, Vietnam
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/envelope.svg" alt="email" class="icon">
                                    <a href="mailto:info@skillgrodemo.com">se1931Group@gmail.com</a>
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/phone.svg" alt="phone" class="icon">
                                    Call us: +84 123 456 789
                                </li>
                            </ul>
                        </div>
                    
                    </div>
                    <div class="col-lg-2">
                    <ul class="tg-header__top-social list-wrap">
                        <li>Follow Us:</li>
                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                        <li><a href="#"><i class="fab fa-whatsapp"></i></a></li>
                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                        <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                    </ul>
                </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header-fixed-height"></div>
    <div id="sticky-header" class="tg-header__area">
        <div class="container custom-container">
            <div class="row">
                <div class="col-12">
                    <div class="tgmenu__wrap">
                        <nav class="tgmenu__nav">
                            <div class="logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                            </div>
                            <div class="tgmenu__navbar-wrap tgmenu__main-menu d-flex"> 
                                <ul class="navigation">
                                    <li><a href="${pageContext.request.contextPath}/my-profile">Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/price-package-menu">Course</a></li>
                                    <li><a href="${pageContext.request.contextPath}/blog">Blog List</a></li>
                                    <c:if test="${sessionScope.account.role_id == 4}"> 
                                    <li><a href="${pageContext.request.contextPath}/slider-list">Slide List</a></li>
                                    </c:if>
                                    <c:if test="${sessionScope.account.role_id == 4 ||sessionScope.account.role_id == 1 || sessionScope.account.role_id == 3 }"> 
                                    <li class="menu-item-has-children"><a href="#">Dashboard</a>
                                        <ul class="sub-menu">
                                            <li class="menu-item-has-children">
                                                <a href="instructor-dashboard.html">Admin Dashboard</a>
                                                <ul class="sub-menu">
                                                    <li><a href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/registrations">Registration</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/price-package-list">Price Package</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/setting">Settings</a></li>
                                                </ul>
                                            </li>
                                            <li class="menu-item-has-children"><a href="student-dashboard.html">Expert Dashboard</a>
                                                <ul class="sub-menu">
                                                    <li><a href="${pageContext.request.contextPath}/manage-subjects">Manage Subject</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/admin/subjects">Subject</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/quizzes-list">Quiz</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/questions-list">Question</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/expert/essay-grading">Essay grading</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    </c:if>
                                </ul>
                            </div>
                            <div class="tgmenu__action">
                                <ul class="list-wrap">                                   
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account}">
                                            <!-- User Icon với Dropdown khi đã đăng nhập -->
                                            <li class="user-dropdown-action" style="display: inline; position: relative;">
                                                <a href="#" class="user-profile-icon" onclick="toggleUserDropdownAction(event)" title="User Menu">
                                                    <i class="fas fa-user-circle"></i>
                                                </a>
                                                <div class="dropdown-menu-action" id="userDropdownAction">
                                                    <a href="${pageContext.request.contextPath}/change-password" class="dropdown-item-action">
                                                        <i class="fas fa-key"></i> Change Password
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item-action">
                                                        <i class="fas fa-sign-out-alt"></i> Log out
                                                    </a>
                                                </div>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Cùng User Icon khi chưa đăng nhập - click để vào login -->
                                            <li style="display: inline;">
                                                <a href="${pageContext.request.contextPath}/login" class="user-profile-icon" title="Login">
                                                    <i class="fas fa-user-circle"></i>
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                            <div class="mobile-login-btn">
                                <a href="login"><img src="${pageContext.request.contextPath}/view/common/img/icons/user.svg" alt="" class="injectable"></a>
                            </div>
                            <div class="mobile-nav-toggler"><i class="tg-flaticon-menu-1"></i></div>
                        </nav>
                    </div>
                    <!-- Mobile Menu  -->
                    <div class="tgmobile__menu">
                        <nav class="tgmobile__menu-box">
                            <div class="close-btn"><i class="tg-flaticon-close-1"></i></div>
                            <div class="nav-logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                            </div>
                            <div class="tgmobile__search">
                                <form action="#">
                                    <input type="text" placeholder="Search here...">
                                    <button><i class="fas fa-search"></i></button>
                                </form>
                            </div>
                            <div class="tgmobile__menu-outer">
                                <!--Here Menu Will Come Automatically Via Javascript / Same Menu as in Header-->
                            </div>
                            <div class="social-links">
                                <ul class="list-wrap">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                                </ul>
                            </div>
                        </nav>
                    </div>
                    <div class="tgmobile__menu-backdrop"></div>
                    <!-- End Mobile Menu -->
                </div>
            </div>
        </div>
    </div>
    <!-- header-top-end -->

    <!-- header-area -->

    <!-- header-area-end -->

    <style>
        .header-top-wrap {
            background: #1A1B3D;
            padding: 8px 0;
            color: #fff;
        }
        .header-top-left ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .header-top-left ul li {
            display: inline-block;
            margin-right: 20px;
            font-size: 14px;
            vertical-align: middle;
        }
        .header-top-left ul li:last-child {
            margin-right: 0;
        }
        .header-top-left ul li img.icon {
            width: 14px;
            height: 14px;
            margin-right: 8px;
            filter: brightness(0) invert(1);
            vertical-align: middle;
            display: inline-block;
        }
        .header-top-left ul li a {
            color: #fff;
            text-decoration: none;
            vertical-align: middle;
        }
        .header-social ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .header-social ul li {
            display: inline-block;
            margin-left: 15px;
        }
        .header-social ul li a {
            color: #fff;
            font-size: 14px;
        }
        .header-social ul li a:hover {
            color: #4A90E2;
        }
        .header-area {
            padding: 0;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-area .container {
            padding: 5px 0;
        }
        .logo img {
            max-height: 40px;
        }
        .header-menu {
            margin-top: -10px;
        }
        .button-style {
            display: inline-block;
            padding: 12px 30px;
            background-color: #6559F5; /* màu tím */
            color: white;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            border: 2px solid #0D006C; /* tím đậm hơn một chút */
            border-radius: 999px; /* bo tròn hoàn toàn */
            box-shadow: 0 4px 12px rgba(128, 0, 128, 0.2);
            transition: all 0.3s ease;
        }

        .button-style:hover {
            background-color: #6559F5;
            box-shadow: 0 6px 15px rgba(128, 0, 128, 0.3);
        }
        .tgmenu__action .button-style {
            margin-right: 10px; /* Khoảng cách giữa các nút */
        }
        .navbar {
            padding: 0;
        }
        .navbar-nav .nav-link {
            color: #2D3748;
            font-weight: 500;
            padding: 6px 15px;
            transition: color 0.3s ease;
            display: flex;
            align-items: center;
        }
        .navbar-nav .nav-link:hover {
            color: #4A90E2;
        }
        
       
        .navbar-nav {
            display: flex;
            align-items: center;
            margin: 0;
            padding: 0;
        }
        .navigation {
            display: flex;
            align-items: center;
            margin: 0;
            padding: 0;
            list-style: none;
            gap: 15px;
        }
        .navigation > li {
            display: flex;
            align-items: center;
        }
        .navigation > li > a {
            color: #2D3748;
            font-weight: 500;
            text-decoration: none;
            padding: 6px 0;
            display: flex;
            align-items: center;
        }
        .tgmenu__navbar-wrap {
            margin-top: -5px;
        }

        /* User Profile Icon - dùng chung cho cả 2 trạng thái */
        .user-profile-icon {
            display: inline-flex !important;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background-color: #6559F5;
            color: white !important;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 2px solid #0D006C;
            box-shadow: 0 2px 8px rgba(101, 89, 245, 0.3);
            cursor: pointer;
        }

        .user-profile-icon:hover {
            background-color: #5a4de6 !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(101, 89, 245, 0.4);
            color: white !important;
            text-decoration: none;
        }

        .user-profile-icon i {
            font-size: 22px;
        }

        /* Dropdown Menu cho Action */
        .user-dropdown-action {
            position: relative !important;
        }

        .dropdown-menu-action {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            min-width: 200px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            margin-top: 8px;
        }

        .dropdown-menu-action.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item-action {
            display: flex;
            align-items: center;
            padding: 14px 18px;
            color: #2d3748;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.2s ease;
            border-bottom: 1px solid #f7fafc;
        }

        .dropdown-item-action:last-child {
            border-bottom: none;
        }

        .dropdown-item-action:hover {
            background-color: #f7fafc;
            color: #6559F5;
            text-decoration: none;
        }

        .dropdown-item-action i {
            margin-right: 10px;
            width: 18px;
            font-size: 16px;
        }

        /* Arrow cho dropdown action */
        .dropdown-menu-action::before {
            content: '';
            position: absolute;
            top: -6px;
            right: 15px;
            width: 12px;
            height: 12px;
            background: white;
            border: 1px solid #e2e8f0;
            border-bottom: none;
            border-right: none;
            transform: rotate(45deg);
        }
    </style>
</header>

<!-- Login Modal -->
<div id="loginModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
    <div class="modal-content" style="background-color: white; margin: 15% auto; padding: 20px; width: 300px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
        <h2 style="color: #6C5CE7; margin-bottom: 20px;">Login</h2>
        <form id="loginForm">
            <div style="margin-bottom: 15px;">
                <input type="text" id="username" placeholder="Username" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            <div style="margin-bottom: 20px;">
                <input type="password" id="password" placeholder="Password" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            <div style="display: flex; justify-content: space-between;">
                <button type="submit" style="padding: 10px 20px; background-color: #6C5CE7; color: white; border: none; border-radius: 5px; cursor: pointer;">Login</button>
                <button type="button" onclick="closeLoginModal()" style="padding: 10px 20px; background-color: #8B7FD2; color: white; border: none; border-radius: 5px; cursor: pointer;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleUserDropdownAction(event) {
    event.preventDefault();
    event.stopPropagation();
    
    const dropdown = document.getElementById('userDropdownAction');
    dropdown.classList.toggle('show');
}

// Đóng dropdown khi click ra ngoài (cho action)
document.addEventListener('click', function(event) {
    const dropdown = document.getElementById('userDropdownAction');
    const userBtn = document.querySelector('.user-dropdown-action .user-profile-icon');
    
    if (dropdown && !dropdown.contains(event.target) && userBtn && !userBtn.contains(event.target)) {
        dropdown.classList.remove('show');
    }
});

// Đóng dropdown khi nhấn ESC (cho action)
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const dropdown = document.getElementById('userDropdownAction');
        if (dropdown) {
            dropdown.classList.remove('show');
        }
    }
});
</script>