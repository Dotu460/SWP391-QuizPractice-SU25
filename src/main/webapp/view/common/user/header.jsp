<%-- 
    Document   : header
    Created on : 23 thg 5, 2025, 23:36:22
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
    <div class="tg-header__top">
        <div class="container custom-container">
            <div class="row">
                <div class="col-lg-6">
                    <ul class="tg-header__top-info list-wrap">
                        <li><img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/map_marker.svg" alt="Icon"> <span>589 5th Ave, NY 10024, USA</span></li>
                        <li><img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/envelope.svg" alt="Icon"> <a href="mailto:info@skillgrodemo.com">info@skillgrodemo.com</a></li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <div class="tg-header__top-right">
                        <div class="tg-header__phone">
                            <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/phone.svg" alt="Icon">Call us: <a href="tel:0123456789">+123 599 8989</a>
                        </div>
                        <ul class="tg-header__top-social list-wrap">
                            <li>Follow Us On :</li>
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
                                <a href="index.html">
                                    <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/logo/logo.svg" alt="QuizPractice Logo" style="height: 50px;">
                                </a>
                            </div>
                            <div class="tgmenu__navbar-wrap tgmenu__main-menu d-none d-xl-flex">
                                <ul class="navigation">
                                    <li><a href="#" style="color: #6C5CE7">Home</a></li>
                                    <li><a href="#" style="color: #6C5CE7">Quizzes</a></li>
                                    <li><a href="#" style="color: #6C5CE7">Practice</a></li>
                                    <li><a href="#" style="color: #6C5CE7">Dashboard</a></li>
                                </ul>
                            </div>
                            <div class="auth-button" style="margin-left: auto;">
                                <c:choose>
                                    <c:when test="${sessionScope.user == null}">
                                        <a href="${pageContext.request.contextPath}/login" style="display: inline-block; padding: 10px 30px; background-color: #6C5CE7; color: white; text-decoration: none; border-radius: 50px; font-weight: bold; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">Log In</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/logout" style="display: inline-block; padding: 10px 30px; background-color: #8B7FD2; color: white; text-decoration: none; border-radius: 50px; font-weight: bold; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">Log Out</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>