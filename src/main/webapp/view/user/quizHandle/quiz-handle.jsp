<%-- 
    Document   : quiz-handle
    Created on : 4 thg 6, 2025, 19:48:20
    Author     : quangmingdoc
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Price Package Management</title>
        <meta name="description" content="SkillGro - Price Package Management">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
            <style>
                .package-status {
                    display: inline-block;
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: 500;
                }

                .status-active {
                    background-color: #e6f7e6;
                    color: #28a745;
                }

                .status-inactive {
                    background-color: #f8d7da;
                    color: #dc3545;
                }

                .table-actions {
                    display: flex;
                    gap: 8px;
                }

                .table-actions a,button {
                    padding: 4px 8px;
                    border-radius: 4px;
                    border: none;
                    color: white;
                    font-size: 12px;
                    cursor: pointer;
                }

                .action-edit {
                    background-color: #17a2b8;
                }

                .action-delete {
                    background-color: #dc3545;
                }

                .filter-form {
                    background-color: #f8f9fa;
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .settings-btn {
                    background-color: #6c757d;
                    color: white;
                    border: none;
                    padding: 5px 10px;
                    border-radius: 4px;
                    cursor: pointer;
                }

                .add-btn {
                    background-color: #28a745;
                    color: white;
                    border: none;
                    padding: 8px 15px;
                    border-radius: 4px;
                    cursor: pointer;
                }

                .modal-header {
                    background-color: #f8f9fa;
                    border-bottom: 1px solid #dee2e6;
                }

                .column-option {
                    margin-bottom: 10px;
                }

                .dashboard__content-area {
                    background: white;
                    padding: 25px;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                }

                /* User Menu Styles */
                .user-menu {
                    position: relative;
                }
                
                .user-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #8B7FD2;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }
                
                .user-icon i {
                    color: white;
                    font-size: 18px;
                }
                
                .user-icon:hover {
                    background: #7A6DC0;
                    transform: translateY(-1px);
                }
                
                /* Dropdown Menu */
                .dropdown-menu {
                    position: absolute;
                    top: 120%;
                    right: 0;
                    width: 280px;
                    background: white;
                    border-radius: 8px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.15);
                    opacity: 0;
                    visibility: hidden;
                    transform: translateY(10px);
                    transition: all 0.3s ease;
                    z-index: 1000;
                }
                
                .dropdown-menu.show {
                    opacity: 1;
                    visibility: visible;
                    transform: translateY(0);
                }
                
                /* Dropdown Header */
                .dropdown-header {
                    padding: 16px;
                    border-bottom: 1px solid #eee;
                }
                
                .user-info {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                
                .user-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    overflow: hidden;
                }
                
                .user-avatar img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }
                
                .user-details {
                    display: flex;
                    flex-direction: column;
                }
                
                .user-name {
                    font-weight: 600;
                    color: #1A1B3D;
                    font-size: 14px;
                }
                
                .user-email {
                    color: #666;
                    font-size: 12px;
                }
                
                .guest-info {
                    padding: 8px 0;
                    color: #666;
                    font-size: 14px;
                }
                
                /* Dropdown Body */
                .dropdown-body {
                    padding: 8px 0;
                }
                
                .dropdown-item {
                    display: flex;
                    align-items: center;
                    padding: 10px 16px;
                    color: #1A1B3D;
                    text-decoration: none;
                    transition: background-color 0.3s ease;
                }
                
                .dropdown-item:hover {
                    background-color: #f8f9fa;
                }
                
                .dropdown-item i {
                    width: 20px;
                    margin-right: 12px;
                    font-size: 16px;
                }
                
                .dropdown-item span {
                    font-size: 14px;
                }
                
                .text-danger {
                    color: #dc3545 !important;
                }
                
                .dropdown-divider {
                    height: 1px;
                    background-color: #eee;
                    margin: 8px 0;
                }
                
                /* Responsive Adjustments */
                @media (max-width: 576px) {
                    .dropdown-menu {
                        width: 250px;
                    }
                    
                    .user-icon {
                        width: 35px;
                        height: 35px;
                    }
                    
                    .user-icon i {
                        font-size: 16px;
                    }
                }

                /* Settings Menu Styles */
                .header-right {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                }
                
                .settings-menu {
                    position: relative;
                }
                
                .settings-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #8B7FD2;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }
                
                .settings-icon i {
                    color: white;
                    font-size: 18px;
                    transition: transform 0.3s ease;
                }
                
                .settings-icon:hover {
                    background: #7A6DC0;
                }
                
                .settings-icon.rotating i {
                    transform: rotate(90deg);
                }
                
                /* Settings Dropdown */
                .settings-dropdown {
                    position: absolute;
                    top: 120%;
                    right: 0;
                    width: 200px;
                    background: white;
                    border-radius: 8px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.15);
                    opacity: 0;
                    visibility: hidden;
                    transform: translateY(10px);
                    transition: all 0.3s ease;
                    z-index: 1000;
                }
                
                .settings-dropdown.show {
                    opacity: 1;
                    visibility: visible;
                    transform: translateY(0);
                }
                
                .settings-dropdown .dropdown-item {
                    display: flex;
                    align-items: center;
                    padding: 12px 16px;
                    color: #1A1B3D;
                    text-decoration: none;
                    transition: background-color 0.3s ease;
                }
                
                .settings-dropdown .dropdown-item:hover {
                    background-color: #f8f9fa;
                }
                
                .settings-dropdown .dropdown-item i {
                    width: 20px;
                    margin-right: 12px;
                    font-size: 16px;
                    color: #dc3545;
                }
                
                .settings-dropdown .dropdown-item span {
                    font-size: 14px;
                    font-weight: 500;
                }
                
                @media (max-width: 576px) {
                    .settings-icon {
                        width: 35px;
                        height: 35px;
                    }
                    
                    .settings-icon i {
                        font-size: 16px;
                    }
                }

                /* Question Grid Styles */
                .question-grid {
                    display: grid;
                    grid-template-columns: repeat(5, 1fr);
                    gap: 12px;
                    margin-top: 24px;
                    padding: 16px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }

                .question-box {
                    aspect-ratio: 1;
                    background: white;
                    border: 2px solid #e0e0e0;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .question-box:hover {
                    border-color: #8B7FD2;
                    background: #f8f7ff;
                    transform: translateY(-2px);
                }

                .question-number {
                    font-size: 16px;
                    font-weight: 500;
                    color: #1A1B3D;
                }

                /* Question box states */
                .question-box.unanswered {
                    border-color: #dc3545;
                    background: #fff5f5;
                }

                .question-box.answered {
                    border-color: #28a745;
                    background: #f0fff4;
                }

                .question-box.marked {
                    border-color: #ffd700;
                    background: #fffbeb;
                }

                .question-box.current {
                    border-color: #8B7FD2;
                    background: #f8f7ff;
                    box-shadow: 0 2px 8px rgba(139, 127, 210, 0.2);
                }

                @media (max-width: 576px) {
                    .question-grid {
                        gap: 8px;
                        padding: 12px;
                    }

                    .question-number {
                        font-size: 14px;
                    }
                }

                /* Question Content Styles */
                .question-content {
                    margin: 40px 0;
                    padding: 30px;
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                }

                .question-text {
                    font-size: 18px;
                    color: #1A1B3D;
                    line-height: 1.6;
                    margin-bottom: 30px;
                    font-weight: 500;
                }

                .answers-container {
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                }

                .answer-option {
                    position: relative;
                }

                .answer-radio {
                    position: absolute;
                    opacity: 0;
                    cursor: pointer;
                }

                .answer-label {
                    display: flex;
                    align-items: center;
                    padding: 16px 20px;
                    background: #f8f9fa;
                    border: 2px solid #e0e0e0;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .answer-text {
                    font-size: 16px;
                    color: #1A1B3D;
                }

                /* Radio button custom style */
                .answer-label:before {
                    content: '';
                    width: 20px;
                    height: 20px;
                    border: 2px solid #8B7FD2;
                    border-radius: 50%;
                    margin-right: 12px;
                    transition: all 0.3s ease;
                }

                /* Selected state */
                .answer-radio:checked + .answer-label {
                    border-color: #8B7FD2;
                    background: #f8f7ff;
                }

                .answer-radio:checked + .answer-label:before {
                    background: #8B7FD2;
                    box-shadow: inset 0 0 0 4px #fff;
                }

                /* Hover state */
                .answer-label:hover {
                    border-color: #8B7FD2;
                    background: #f8f7ff;
                    transform: translateY(-1px);
                }

                @media (max-width: 768px) {
                    .question-content {
                        padding: 20px;
                        margin: 20px 0;
                    }

                    .question-text {
                        font-size: 16px;
                        margin-bottom: 20px;
                    }

                    .answer-text {
                        font-size: 14px;
                    }

                    .answer-label {
                        padding: 12px 16px;
                    }
                }

                /* Peek Popup Styles */
                .peek-popup {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    z-index: 1000;
                    justify-content: center;
                    align-items: center;
                }

                .peek-popup.show {
                    display: flex;
                }

                .peek-popup .popup-content {
                    background: white;
                    border-radius: 12px;
                    width: 90%;
                    max-width: 500px;
                    padding: 24px;
                    position: relative;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                }

                .peek-popup .popup-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    padding-bottom: 12px;
                    border-bottom: 1px solid #eee;
                }

                .peek-popup .popup-header h3 {
                    font-size: 20px;
                    font-weight: 600;
                    color: #1A1B3D;
                    margin: 0;
                }

                .peek-popup .close-btn {
                    background: none;
                    border: none;
                    font-size: 20px;
                    color: #666;
                    cursor: pointer;
                    padding: 4px;
                    transition: color 0.3s ease;
                }

                .peek-popup .close-btn:hover {
                    color: #1A1B3D;
                }

                .peek-popup .explanation-text {
                    font-size: 16px;
                    line-height: 1.6;
                    color: #4B5563;
                    padding: 16px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }

                @media (max-width: 576px) {
                    .peek-popup .popup-content {
                        width: 95%;
                        padding: 16px;
                    }

                    .peek-popup .explanation-text {
                        font-size: 14px;
                        padding: 12px;
                    }
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
            <header>
                <!-- header-top -->
                <div class="header-top-wrap">
                    <div class="container">
                        <div class="header-top">
                            <div class="logo header-logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                        </div>
                            <div class="header-right">
                                <div class="settings-menu">
                                    <div class="settings-icon" onclick="toggleSettingsDropdown()">
                                        <i class="fas fa-cog"></i>
                                    </div>
                                    <div class="settings-dropdown">
                                        <a href="#" class="dropdown-item" onclick="exitQuiz()">
                                            <i class="fas fa-sign-out-alt"></i>
                                            <span>Exit Quiz</span>
                                        </a>
                                    </div>
                                </div>
                                <div class="user-menu">
                                    <div class="user-icon" onclick="toggleDropdown()">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="dropdown-menu">
                                        <div class="dropdown-header">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <div class="user-info">
                                                        <div class="user-avatar">
                                                            <img src="${pageContext.request.contextPath}/view/common/img/icons/user-avatar.png" alt="User Avatar">
                                                        </div>
                                                        <div class="user-details">
                                                            <span class="user-name">${sessionScope.user.fullName}</span>
                                                            <span class="user-email">${sessionScope.user.email}</span>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="guest-info">
                                                        <span>Welcome, Guest!</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                    </div>
                                        <div class="dropdown-body">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <a href="my-profile" class="dropdown-item">
                                                        <i class="fas fa-user-circle"></i>
                                                        <span>My Profile</span>
                                                    </a>
                                                    <a href="my-courses" class="dropdown-item">
                                                        <i class="fas fa-graduation-cap"></i>
                                                        <span>My Courses</span>
                                                    </a>
                                                    <div class="dropdown-divider"></div>
                                                    <a href="login?action=logout" class="dropdown-item text-danger">
                                                        <i class="fas fa-sign-out-alt"></i>
                                                        <span>Log out</span>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <!---------------HIỆN TẠM, XONG XOÁ--------------------------------->
                                                    <a href="my-profile" class="dropdown-item">
                                                        <i class="fas fa-user-circle"></i>
                                                        <span>My Profile</span>
                                                    </a>
                                                    <!------------------------------------------------>
                                                    <a href="login" class="dropdown-item">
                                                        <i class="fas fa-sign-in-alt"></i>
                                                        <span>Log in</span>
                                                    </a>
                                                    <a href="register" class="dropdown-item">
                                                        <i class="fas fa-user-plus"></i>
                                                        <span>Register</span>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
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
                    position: relative;
                }
                
                /* Logo styles */
                .header-logo {
                    position: relative;
                    z-index: 2;
                    display: flex;
                    align-items: center;
                }
                
                .header-logo a {
                    display: block;
                    width: auto;
                    height: 100%;
                }
                
                .header-logo img {
                    max-height: 50px;
                    width: auto;
                    height: auto;
                    display: block;
                    object-fit: contain;
                    filter: brightness(0) invert(1);
                }
                
                /* Header top styles */
                .header-top {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    min-height: 60px;
                }
                
                .header-right {
                    display: flex;
                    align-items: center;
                }
                
                /* Button styles */
                .button-style {
                    background-color: #8B7FD2;
                    color: white !important;
                    border: none;
                    border-radius: 8px;
                    padding: 8px 20px;
                    font-size: 14px;
                    font-weight: 500;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.3s ease;
                }
                
                .button-style:hover {
                    background-color: #7A6DC0;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 5px rgba(139, 127, 210, 0.3);
                }
                
                /* Responsive adjustments */
                @media (max-width: 991px) {
                    .header-logo img {
                        max-height: 40px;
                    }
                    
                    .header-top {
                        min-height: 50px;
                    }
                    
                    .header-top-wrap {
                        padding: 5px 0;
                    }
                    
                    .button-style {
                        padding: 6px 16px;
                        font-size: 13px;
                    }
                }
                
                @media (max-width: 576px) {
                    .header-logo img {
                        max-height: 35px;
                    }
                    
                    .button-style {
                        padding: 5px 12px;
                        font-size: 12px;
                    }
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
                .navbar-nav .login-btn {
                    background-color: #8B7FD2;
                    color: white !important;
                    border: none;
                    border-radius: 8px;
                    padding: 2px 10px;
                    height: 22px;
                    line-height: 22px;
                    font-size: 13px;
                    font-weight: 300;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    margin-left: 15px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    box-shadow: 0 1px 3px rgba(139, 127, 210, 0.2);
                    position: relative;
                    overflow: hidden;
                }
                .navbar-nav .login-btn:hover {
                    background-color: #7A6DC0;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 5px rgba(139, 127, 210, 0.3);
                }
                .navbar-nav .login-btn::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: -100%;
                    width: 100%;
                    height: 100%;
                    background: linear-gradient(
                        120deg,
                        transparent,
                        rgba(255, 255, 255, 0.2),
                        transparent
                        );
                    transition: 0.5s;
                }
                .navbar-nav .login-btn:hover::before {
                    left: 100%;
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
                .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn {
                    background-color: #8B7FD2;
                    color: white !important;
                    border: none;
                    border-radius: 8px;
                    padding: 4px 16px;
                    height: 28px;
                    line-height: 28px;
                    font-size: 15px;
                    font-weight: 400;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0;
                    margin-left: 15px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    box-shadow: 0 1px 3px rgba(139, 127, 210, 0.2);
                    position: relative;
                    overflow: hidden;
                    min-height: unset;
                    max-height: 28px;
                }
                .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn:hover {
                    background-color: #7A6DC0;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 5px rgba(139, 127, 210, 0.3);
                }
                .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: -100%;
                    width: 100%;
                    height: 100%;
                    background: linear-gradient(
                        120deg,
                        transparent,
                        rgba(255, 255, 255, 0.2),
                        transparent
                        );
                    transition: 0.5s;
                }
                .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn:hover::before {
                    left: 100%;
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
        <!-- Login Modal End -->

        <!-- handleLoginLogout -->
        <script>
            function handleLoginLogout(event) {
                event.preventDefault();
                const loginBtn = document.querySelector('.login-btn');

                if (loginBtn.textContent.trim() === 'Log Out') {
                    console.log('Attempting to logout...');
                    fetch('${pageContext.request.contextPath}/logout', {
                        method: 'GET',
                        credentials: 'include'
                    })
                            .then(response => {
                                console.log('Logout response:', response);
                                if (response.ok) {
                                    console.log('Logout successful');
                                    loginBtn.textContent = 'Log In';
                                } else {
                                    console.error('Logout failed:', response.status);
                                }
                            })
                            .catch(error => {
                                console.error('Logout error:', error);
                            });
                } else {
                    window.location.href = '${pageContext.request.contextPath}/login';
                }
            }
        </script>
        <!-- handleLoginLogout-end -->
        
        <!-- header-area-end -->

        <!-- main-area -->
        <main>
            <div class="container">
                <!-- Question Header Section: Hiển thị số thứ tự câu hỏi và ID -->
                <div class="question-header">
                    <div class="question-info">
                        <div class="question-number">Question ${currentNumber}/${totalQuestions}</div>
                        <div class="question-id">Question ID: ${question.id}</div>
                    </div>
                </div>

                <!-- Question Content Area -->
                <div class="question-content">
                    <div class="question-text">
                        ${question.content}
                    </div>
                    
                    <!-- Media URL nếu có -->
                    <c:if test="${not empty question.media_url}">
                        <div class="media-content mt-3">
                            <img src="${question.media_url}" alt="Question Media" class="img-fluid">
                        </div>
                    </c:if>
                </div>

                <!-- Navigation Footer Section: Chứa các nút điều hướng -->
                <div class="navigation-footer">
                    <!-- Nút Review Progress: Hiện tại chưa có chức năng -->
                    <button class="btn-review" onclick="openReviewPopup()">
                        <i class="fas fa-tasks"></i>
                        Review Progress
                    </button>

                    <!-- Review Progress Popup -->
                    <div id="reviewPopup" class="review-popup">
                        <div class="popup-content">
                            <div class="popup-header">
                                <h3>Review Progress</h3>
                                <button class="close-btn" onclick="closeReviewPopup()">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="popup-body">
                                <p class="review-subtitle">Review before scoring:</p>
                                <div class="review-buttons">
                                    <button class="review-btn btn-unanswered">
                                        Unanswered
                                    </button>
                                    <button class="review-btn btn-answered">
                                        Answered
                                    </button>
                                    <button class="review-btn btn-marked">
                                        Marked
                                    </button>
                                    <button class="review-btn btn-all">
                                        All Questions
                                    </button>
                                </div>
                                
                                <!-- Question Grid -->
                                <div class="question-grid">
                                    <c:forEach begin="1" end="${totalQuestions}" var="i">
                                        <div class="question-box ${i == currentNumber ? 'current' : ''}" 
                                             onclick="navigateToQuestion('${i}')">
                                            <span class="question-number">${i}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Container chứa các nút điều hướng -->
                    <div class="navigation-buttons">
                        <!-- Nút Peek of Answer và Mark for Review -->
                        <div class="action-buttons">
                            <button class="btn-action btn-peek" onclick="openPeekPopup()">
                                <i class="fas fa-eye"></i>
                                Peek
                            </button>
                            <button class="btn-action btn-mark" onclick="toggleMarkForReview(this)">
                                <i class="fas fa-bookmark"></i>
                                Mark
                            </button>
                        </div>
                        <!-- Nút Previous và Next/Score Exam -->
                        <div class="nav-buttons">
                            <div class="nav-group">
                                <c:if test="${currentNumber > 1}">
                                    <button class="btn-nav btn-prev" onclick="handleNavigation('previous')">
                                        <i class="fas fa-arrow-left"></i>
                                        Previous
                                    </button>
                                </c:if>
                                <c:if test="${currentNumber < totalQuestions}">
                                    <button class="btn-nav btn-next" onclick="handleNavigation('next')">
                                        Next
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </c:if>
                                <c:if test="${currentNumber == totalQuestions}">
                                    <button class="btn-nav btn-score" onclick="handleNavigation('score')">
                                        Score Exam
                                        <i class="fas fa-check"></i>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Peek Explanation Popup -->
                <div id="peekPopup" class="peek-popup">
                    <div class="popup-content">
                        <div class="popup-header">
                            <h3>Peek At Answer</h3>
                            <button class="close-btn" onclick="closePeekPopup()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="popup-body">
                            <div class="explanation-text">
                                ${question.explanation}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <style>
            /* Style cho header chứa thông tin câu hỏi */
            .question-header {
                padding: 20px 0;
                border-bottom: 1px solid #eee;
            }
            
            /* Container cho số câu hỏi và ID */
            .question-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 16px;
                color: #1A1B3D;
            }
            
            /* Style cho số thứ tự câu hỏi */
            .question-number {
                font-weight: 500;
            }
            
            /* Style cho Question ID */
            .question-id {
                color: #666;
            }
            
            /* Style cho footer chứa các nút điều hướng */
            .navigation-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 0;
                margin-top: 30px;
                border-top: 1px solid #eee;
            }
            
            /* Style cho nút Review Progress */
            .btn-review {
                background: #8B7FD2;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 24px;
                font-size: 14px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .btn-review:hover {
                background: #7A6DC0;
                transform: translateY(-1px);
            }
            
            /* Style cho container của các nút */
            .navigation-buttons {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 10px;
                margin-left: auto;
                width: auto;
            }
            
            /* Style cho nhóm nút action */
            .action-buttons {
                display: flex;
                gap: 8px;
            }
            
            /* Style cho nhóm nút navigation */
            .nav-buttons {
                display: flex;
                justify-content: flex-end;
                width: 100%;
            }

            .nav-group {
                display: flex;
                gap: 8px;
                width: fit-content;
            }
            
            /* Style chung cho các nút */
            .btn-action, .btn-nav {
                background: #fff;
                border: 2px solid #8B7FD2;
                border-radius: 8px;
                padding: 8px 16px;
                font-size: 14px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                color: #1A1B3D;
                width: 100px; /* Fixed width cho tất cả các nút */
                justify-content: center;
            }
            
            /* Style cho nút Peek */
            .btn-peek:hover {
                background: #f0f0f0;
            }
            
            /* Style cho nút Mark */
            .btn-mark:hover {
                background: #fff9e6;
            }
            
            .btn-mark.marked {
                background: #ffd700;
                border-color: #ffd700;
            }
            
            /* Style cho nút Previous và Next */
            .btn-prev {
                justify-content: flex-start;
            }
            
            .btn-next {
                justify-content: flex-end;
            }
            
            .btn-nav:hover {
                background: #8B7FD2;
                color: white;
            }
            
            /* Responsive styles */
            @media (max-width: 576px) {
                .navigation-buttons {
                    width: 100%;
                }
                
                .action-buttons, .nav-buttons {
                    justify-content: flex-end;
                }
            }

            /* Review Popup Styles */
            .review-popup {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
            }

            .review-popup.show {
                display: flex;
            }

            .popup-content {
                background: white;
                border-radius: 12px;
                width: 90%;
                max-width: 600px;
                padding: 24px;
                position: relative;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            }

            .popup-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .popup-header h3 {
                font-size: 20px;
                font-weight: 600;
                color: #1A1B3D;
                margin: 0;
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 20px;
                color: #666;
                cursor: pointer;
                padding: 4px;
                transition: color 0.3s ease;
            }

            .close-btn:hover {
                color: #1A1B3D;
            }

            .review-subtitle {
                font-size: 16px;
                color: #666;
                margin-bottom: 16px;
            }

            .review-buttons {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }

            .review-btn {
                flex: 1;
                min-width: 120px;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                background: white;
                color: #1A1B3D;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
            }

            .btn-unanswered:hover {
                border-color: #dc3545;
                background: #fff5f5;
            }

            .btn-answered:hover {
                border-color: #28a745;
                background: #f0fff4;
            }

            .btn-marked:hover {
                border-color: #ffd700;
                background: #fffbeb;
            }

            .btn-all:hover {
                border-color: #8B7FD2;
                background: #f8f7ff;
            }

            @media (max-width: 576px) {
                .popup-content {
                    padding: 16px;
                }

                .review-buttons {
                    gap: 8px;
                }

                .review-btn {
                    min-width: calc(50% - 4px);
                    padding: 8px;
                }
            }
        </style>
        <!-- main-area-end -->

        <!-- Settings-Modal -->
        <div class="modal fade" id="settingModal" tabindex="-1" role="dialog" aria-labelledby="settingModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="settingModalLabel">Display Settings</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="font-weight-bold mb-3">Select columns to display:</label>
                            <div class="d-flex justify-content-end mb-3">
                                <button type="button" class="btn btn-sm btn-outline-primary mr-2" id="selectAllColumns">Select All</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="deselectAllColumns">Deselect All</button>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="id" id="idColumn" checked>
                                    <label class="form-check-label" for="idColumn">ID</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="name" id="nameColumn" checked>
                                    <label class="form-check-label" for="nameColumn">Name</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="duration" id="durationColumn" checked>
                                    <label class="form-check-label" for="durationColumn">Duration</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="prices" id="pricesColumn" checked>
                                    <label class="form-check-label" for="pricesColumn">Prices</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="status" id="statusColumn" checked>
                                    <label class="form-check-label" for="statusColumn">Status</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="description" id="descriptionColumn" checked>
                                    <label class="form-check-label" for="descriptionColumn">Description</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Apply</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Setting-Modal-End -->

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

            <!-- iziToast CSS and JS -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/css/iziToast.min.css">
            <script src="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/js/iziToast.min.js"></script>

            <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Toast message display
                var toastMessage = "${sessionScope.toastMessage}";
                var toastType = "${sessionScope.toastType}";
                if (toastMessage) {
                    iziToast.show({
                        title: toastType === 'success' ? 'Success' : 'Error',
                        message: toastMessage,
                        position: 'topRight',
                        color: toastType === 'success' ? 'green' : 'red',
                        timeout: 5000,
                        onClosing: function () {
                            // Remove toast attributes from the session after displaying
                            fetch('${pageContext.request.contextPath}/remove-toast', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                            }).then(response => {
                                if (!response.ok) {
                                    console.error('Failed to remove toast attributes');
                                }
                            }).catch(error => {
                                console.error('Error:', error);
                            });
                        }
                    });
                }

                // Select all columns button
                document.getElementById('selectAllColumns').addEventListener('click', function () {
                    document.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
                        checkbox.checked = true;
                    });
                });

                // Deselect all columns button
                document.getElementById('deselectAllColumns').addEventListener('click', function () {
                    document.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
                        checkbox.checked = false;
                    });
                });

                // Change page size function
                window.changePageSize = function (newSize) {
                    var currentUrl = new URL(window.location);
                    currentUrl.searchParams.set('pageSize', newSize);
                    currentUrl.searchParams.set('page', '1'); // Reset to first page
                    window.location.href = currentUrl.toString();
                };
            });
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const mobileNavToggler = document.querySelector('.mobile-nav-toggler');
                const mobileMenu = document.querySelector('.tgmobile__menu');
                const menuBackdrop = document.querySelector('.tgmobile__menu-backdrop');
                const closeBtn = document.querySelector('.close-btn');

                // Open menu
                mobileNavToggler.addEventListener('click', function() {
                    mobileMenu.classList.add('active');
                    menuBackdrop.classList.add('active');
                    document.body.style.overflow = 'hidden';
                });

                // Close menu when clicking close button
                closeBtn.addEventListener('click', closeMenu);

                // Close menu when clicking backdrop
                menuBackdrop.addEventListener('click', closeMenu);

                function closeMenu() {
                    mobileMenu.classList.remove('active');
                    menuBackdrop.classList.remove('active');
                    document.body.style.overflow = '';
                }
            });
        </script>

        <script>
            function toggleDropdown() {
                const dropdown = document.querySelector('.dropdown-menu');
                dropdown.classList.toggle('show');
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(event) {
                    const userMenu = document.querySelector('.user-menu');
                    if (!userMenu.contains(event.target)) {
                        dropdown.classList.remove('show');
                    }
                });
            }
        </script>

        <script>
            function toggleSettingsDropdown() {
                const settingsIcon = document.querySelector('.settings-icon');
                const dropdown = document.querySelector('.settings-dropdown');
                const iconElement = settingsIcon.querySelector('i');
                
                // Toggle rotation class
                settingsIcon.classList.toggle('rotating');
                
                // Toggle dropdown
                dropdown.classList.toggle('show');
                
                // Remove rotation and close dropdown when clicking outside
                document.addEventListener('click', function(event) {
                    const settingsMenu = document.querySelector('.settings-menu');
                    if (!settingsMenu.contains(event.target)) {
                        settingsIcon.classList.remove('rotating');
                        dropdown.classList.remove('show');
                    }
                });
            }
            
            function exitQuiz() {
                if(confirm('Are you sure you want to exit the quiz?')) {
                    // Add your exit quiz logic here
                    window.location.href = 'your-exit-url';
                }
            }
        </script>

        <script>
            /**
             * Hàm xử lý việc chuyển câu hỏi
             * @param {string} action - 'next' hoặc 'previous'
             */
            function handleNavigation(action) {
                // Lấy số câu hỏi hiện tại từ URL, mặc định là 1
                var currentNumber = parseInt('${param.questionNumber}' || '1');
                var nextNumber;
                
                // Xác định số câu hỏi tiếp theo dựa vào action
                if (action === 'next' && currentNumber < 10) {
                    nextNumber = currentNumber + 1;
                } else if (action === 'previous' && currentNumber > 1) {
                    nextNumber = currentNumber - 1;
                } else {
                    nextNumber = currentNumber;
                }
                
                // Thêm timestamp để tránh cache của trình duyệt
                var timestamp = new Date().getTime();
                // Chuyển hướng đến URL mới với số câu hỏi đã cập nhật
                window.location.href = 'quiz-handle?action=' + action + '&questionNumber=' + nextNumber + '&t=' + timestamp;
            }
        </script>

        <script>
            /**
             * Hàm xử lý đánh dấu câu hỏi để review
             * @param {HTMLElement} button - Button element được click
             */
            function toggleMarkForReview(button) {
                // Toggle class marked
                button.classList.toggle('marked');
                
                // Lưu trạng thái đánh dấu vào localStorage
                var questionNumber = parseInt('${param.questionNumber}' || '1');
                var markedQuestions = JSON.parse(localStorage.getItem('markedQuestions') || '{}');
                
                if (button.classList.contains('marked')) {
                    markedQuestions[questionNumber] = true;
                } else {
                    delete markedQuestions[questionNumber];
                }
                
                localStorage.setItem('markedQuestions', JSON.stringify(markedQuestions));
            }

            // Khôi phục trạng thái đánh dấu khi load trang
            document.addEventListener('DOMContentLoaded', function() {
                var questionNumber = parseInt('${param.questionNumber}' || '1');
                var markedQuestions = JSON.parse(localStorage.getItem('markedQuestions') || '{}');
                
                if (markedQuestions[questionNumber]) {
                    document.querySelector('.btn-mark').classList.add('marked');
                }
            });
        </script>

        <script>
            function openReviewPopup() {
                document.getElementById('reviewPopup').classList.add('show');
            }

            function closeReviewPopup() {
                document.getElementById('reviewPopup').classList.remove('show');
            }

            // Close popup when clicking outside
            document.addEventListener('click', function(event) {
                const popup = document.getElementById('reviewPopup');
                const popupContent = popup.querySelector('.popup-content');
                if (event.target === popup) {
                    closeReviewPopup();
                }
            });
        </script>

        <script>
            function navigateToQuestion(questionNumber) {
                window.location.href = 'quiz-handle?action=navigate&questionNumber=' + questionNumber;
            }

            // Update question box states based on current status
            function updateQuestionBoxStates() {
                const currentNumber = parseInt('${param.questionNumber}' || '1');
                const boxes = document.querySelectorAll('.question-box');
                
                boxes.forEach((box, index) => {
                    const number = index + 1;
                    if (number === currentNumber) {
                        box.classList.add('current');
                    }
                    // Thêm các trạng thái khác khi cần
                });
            }

            // Call when popup opens
            document.getElementById('reviewPopup').addEventListener('show', updateQuestionBoxStates);
        </script>

        <script>
            function saveAnswer(questionId, answerId) {
                // Gửi AJAX request để lưu câu trả lời
                fetch('quiz-handle?action=saveAnswer', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `questionId=${questionId}&answerId=${answerId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Cập nhật UI nếu cần
                        updateQuestionBoxStates();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        </script>

        <script>
            function openPeekPopup() {
                document.getElementById('peekPopup').classList.add('show');
            }

            function closePeekPopup() {
                document.getElementById('peekPopup').classList.remove('show');
            }

            // Close popup when clicking outside
            document.addEventListener('DOMContentLoaded', function() {
                document.getElementById('peekPopup').addEventListener('click', function(event) {
                    if (event.target === this) {
                        closePeekPopup();
                    }
                });
            });
        </script>
    </body>
</html>
