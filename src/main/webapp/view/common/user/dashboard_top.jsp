<%-- 
    Document   : dashboard_top
    Created on : 23 thg 5, 2025, 23:42:23
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="dashboard__top-wrap">
                            <div class="dashboard__top-bg" data-background="assets/img/bg/instructor_dashboard_bg.jpg"></div>
                            <div class="dashboard__instructor-info">
                                <div class="dashboard__instructor-info-left">
                                    <div class="thumb">
                                        <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors01.jpg" alt="img">
                                    </div>
                                    <div class="content">
                                        <h4 class="title">John Due</h4>
                                        <div class="review__wrap review__wrap-two">
                                            <div class="rating">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <span>(10 Reviews)</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="dashboard__instructor-info-right">
                                    <a href="#" class="btn btn-two arrow-btn">Create a New Course <img src="assets/img/icons/right_arrow.svg" alt="img" class="injectable"></a>
                                </div>
                            </div>
                        </div>
