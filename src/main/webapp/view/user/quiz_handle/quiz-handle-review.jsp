<%-- 
    Document   : quiz-handle-review
    Created on : Jun 24, 2025, 10:30:50 PM
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
        <title>SkillGro - Quiz Review: ${quiz.name}</title>
        <meta name="description" content="SkillGro - Quiz Review">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        
        <!-- All styles from quiz-handle.jsp -->
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
                display: none;
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
                display: none;
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
                background: #5751E1;
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
            
            /* --- Improved Review Mode Styles --- */
            .form-check-input { display: none; }
            .form-check-label {
                display: flex;
                align-items: center;
                padding: 1rem 1.25rem;
                border: 1px solid #dee2e6;
                border-radius: 0.5rem;
                margin-bottom: 0.75rem;
                transition: all 0.2s ease-in-out;
                cursor: default;
                position: relative;
                background-color: #f8f9fa;
            }
            .form-check-label::before {
                font-family: "Font Awesome 5 Free";
                font-weight: 900;
                font-size: 1.2em;
                width: 24px;
                margin-right: 1rem;
            }
            /* Style for CORRECT answer selected by user */
            .form-check-label.correct-answer {
                background-color: #e9f7ef;
                border-color: #28a745;
                color: #155724;
                font-weight: 500;
                box-shadow: 0 0 10px rgba(40, 167, 69, 0.15);
            }
            .form-check-label.correct-answer::before {
                content: '\f058'; /* check-circle */
                color: #28a745;
            }
            /* Style for INCORRECT answer selected by user */
            .form-check-label.incorrect-answer {
                background-color: #fdeeee;
                border-color: #dc3545;
                color: #721c24;
                font-weight: 500;
                box-shadow: 0 0 10px rgba(220, 53, 69, 0.15);
            }
            .form-check-label.incorrect-answer::before {
                content: '\f057'; /* times-circle */
                color: #dc3545;
            }
            /* Style for the correct answer that user MISSED */
            .form-check-label.missed-correct-answer {
                background-color: #fff;
                border: 2px solid #28a745;
            }
            .form-check-label.missed-correct-answer::before {
                content: '\f00c'; /* check */
                color: #28a745;
            }
            /* Style for other incorrect, unselected options */
            .form-check-label.unselected-option::before {
                content: '\f10c'; /* circle (empty) */
                color: #adb5bd;
            }
            .essay-answer-review { background-color: #f8f9fa; border: 1px solid #dee2e6; color: #495057; padding: 1rem; border-radius: 0.5rem;}
            .explanation { margin-top: 20px; padding: 20px; background-color: #f1f7fe; border-left: 5px solid #007bff; border-radius: 0 8px 8px 0; }
            
            /* Expert feedback styles */
            .expert-feedback {
                margin-top: 25px;
                padding: 20px;
                background-color: #f8f1fe;
                border-left: 5px solid #8B7FD2;
                border-radius: 0 8px 8px 0;
                position: relative;
            }

            .expert-feedback-header {
                display: flex;
                align-items: center;
                margin-bottom: 12px;
                font-weight: 600;
                color: #5751E1;
            }

            .expert-feedback-header i {
                margin-right: 10px;
                font-size: 1.2em;
            }

            .expert-feedback-content {
                color: #333;
                line-height: 1.6;
                font-size: 16px;
            }

            .expert-feedback-score {
                position: absolute;
                top: 15px;
                right: 20px;
                background: #5751E1;
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 16px;
                box-shadow: 0 2px 10px rgba(87, 81, 225, 0.2);
            }

            .no-feedback {
                color: #6c757d;
                font-style: italic;
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
                font-size: 22px;
                color: #5751e1;
                line-height: 1.6;
                margin-bottom: 30px;
                font-weight: 700;
                background: #f6f7fb;
                border-radius: 8px;
                padding: 18px 24px;
                border-bottom: 2.5px solid #8B7FD2;
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
            
            /* HTML Media Content Styles */
            .html-media-content {
                max-width: 100%;
                overflow: hidden;
            }
            
            .html-media-content video {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
            }
            
            .html-media-content img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                display: block;
                margin: 10px 0;
            }
            
            .html-media-content p {
                margin: 10px 0;
                line-height: 1.6;
                color: #1A1B3D;
            }
            
            .html-media-content div {
                margin: 10px 0;
            }
            
            /* Bootstrap img-fluid class support */
            .img-fluid {
                max-width: 100%;
                height: auto;
            }

            /* Question Header Styles */
            .question-header {
                background: #f6f7fb;
                border-radius: 16px 16px 0 0;
                box-shadow: 0 2px 8px rgba(87,81,225,0.04);
                margin-bottom: 0;
                padding: 24px 0 18px 0;
                width: 100vw;
                max-width: 100vw;
                position: relative;
                left: 50%;
                right: 50%;
                margin-left: -50vw;
                margin-right: -50vw;
            }

            .settings-icon {
                background: #8B7FD2;
                color: #fff;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                box-shadow: 0 2px 8px rgba(87,81,225,0.10);
                transition: background 0.2s;
            }

            .settings-icon:hover {
                background: #5751e1;
            }

            .question-header .question-info {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 16px;
                padding: 0 32px;
                box-sizing: border-box;
            }
            
            /* Review Popup Styles */
            .peek-popup {
                display: none !important;
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
                display: flex !important;
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

            /* Review buttons styles */
            .btn-review {
                background: #5751E1;
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

            .review-buttons {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                margin-bottom: 20px;
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
            }

            .btn-unanswered {
                border-color: #dc3545;
                color: #dc3545;
            }

            .btn-unanswered:hover {
                background: #fff5f5;
            }

            .btn-answered {
                border-color: #28a745;
                color: #28a745;
            }

            .btn-answered:hover {
                background: #f0fff4;
            }

            .btn-all {
                border-color: #8B7FD2;
                color: #8B7FD2;
            }

            .btn-all:hover {
                background: #f8f7ff;
            }

            .review-btn.active {
                color: white;
            }

            .btn-unanswered.active {
                background-color: #dc3545;
            }

            .btn-answered.active {
                background-color: #28a745;
            }

            .btn-all.active {
                background-color: #8B7FD2;
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
                position: relative;
            }

            .question-box:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
                font-weight: 700;
            }

            .question-box.current {
                border-color: #8B7FD2;
                background: #f8f7ff;
                box-shadow: 0 2px 8px rgba(139, 127, 210, 0.2);
            }

            @media (max-width: 576px) {
                .question-grid {
                    grid-template-columns: repeat(4, 1fr);
                    gap: 8px;
                    padding: 12px;
                }

                .question-number {
                    font-size: 14px;
                }
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
            
            /* Style cho nút Back to Quizzes */
            .btn-review-back {
                background: #5751E1;
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
                text-decoration: none;
            }
            
            .btn-review-back:hover {
                background: #7A6DC0;
                transform: translateY(-1px);
            }
            
            /* Style cho nút Review Progress */
            .btn-review {
                background: #5751E1;
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
            
            /* Style cho left buttons container */
            .left-buttons {
                display: flex;
                align-items: center;
                gap: 16px;
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
                border: 2px solid #5751E1;
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
        </style>
    </head>

    <body>
        <c:set var="currentNumber" value="${not empty param.questionNumber ? param.questionNumber : 1}" />
        <c:set var="question" value="${questions[currentNumber - 1]}" />

        <!-- header-area -->
        <header>
            <!-- Header removed. -->
        </header>

        <main>
            <div class="container">
                <!-- Question Header Section: Hiển thị số thứ tự câu hỏi và ID -->
                <div class="question-header">
                    <div class="question-info" style="display: flex; align-items: center; justify-content: space-between; gap: 16px;">
                        <div class="question-number">Question ${currentNumber}/${fn:length(questions)}</div>
                        <div class="question-id">Question ID: ${question.id}</div>
                    </div>
                </div>

                <div class="question-content">
                    <div class="question-text">${question.content}</div>
                    

                    
                    <!-- Media URL nếu có (video / ảnh) -->
                    <c:if test="${not empty question.media_url}">
                        <div class="media-content mt-3">
                            <c:choose>
                                <c:when test="${fn:contains(question.media_url, '<') && (fn:contains(question.media_url, 'video') || fn:contains(question.media_url, 'img') || fn:contains(question.media_url, '<p>'))}">
                                    <!-- HTML Content - render directly -->
                                    <div class="html-media-content">
                                        ${question.media_url}
                                    </div>
                                </c:when>
                                <c:when test="${fn:contains(question.media_url, 'youtube.com') || fn:contains(question.media_url, 'youtu.be')}">
                                    <!-- YouTube Video Embed -->
                                    <div class="youtube-embed-container" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px;">
                                        <iframe 
                                            style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 8px;"
                                            src="${fn:replace(fn:replace(question.media_url, 'watch?v=', 'embed/'), 'youtu.be/', 'youtube.com/embed/')}" 
                                            frameborder="0" 
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                            allowfullscreen>
                                        </iframe>
                                    </div>
                                </c:when>
                                <c:when test="${fn:endsWith(question.media_url, '.mp4') 
                                            || fn:endsWith(question.media_url, '.webm') 
                                            || fn:endsWith(question.media_url, '.ogg')
                                            || fn:endsWith(question.media_url, '.mov')
                                            || fn:endsWith(question.media_url, '.MOV')}">
                                    <video controls playsinline style="max-width:100%; border-radius:8px;">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(question.media_url, 'http://') || fn:startsWith(question.media_url, 'https://')}">
                                                <source src="${question.media_url}" type="video/mp4">
                                            </c:when>
                                            <c:otherwise>
                                                <source src="${pageContext.request.contextPath}/media/${question.media_url}" type="video/mp4">
                                            </c:otherwise>
                                        </c:choose>
                                        <p>Your browser does not support HTML5 video.</p>
                                    </video>
                                    
                                    <div id="videoError" style="display:none; color: red; margin-top: 10px; padding: 10px; background: #fff5f5; border-radius: 4px;"></div>
                                    
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function() {
                                            const video = document.querySelector('video');
                                            const errorDiv = document.getElementById('videoError');
                                            
                                            if (video) {
                                                video.addEventListener('error', function(e) {
                                                    console.error('Video error:', e);
                                                    errorDiv.style.display = 'block';
                                                    errorDiv.innerHTML = `
                                                        <strong>Error loading video:</strong><br>
                                                        Path: ${question.media_url}<br>
                                                        Error: ${video.error ? video.error.message : 'Unknown error'}<br>
                                                        <small>Please check if the URL is correct and accessible.</small>
                                                    `;
                                                });
                                            }
                                        });
                                    </script>
                                </c:when>
                                <c:otherwise>
                                    <!-- Image with error handling -->
                                    <c:choose>
                                        <c:when test="${fn:startsWith(question.media_url, 'http://') || fn:startsWith(question.media_url, 'https://')}">
                                            <img src="${question.media_url}" 
                                                 alt="Question Media" 
                                                 class="img-fluid" 
                                                 style="max-width:100%; border-radius:8px;"
                                                 onerror="this.onerror=null; this.style.display='none'; document.getElementById('imageError').style.display='block';">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/media/${question.media_url}" 
                                                 alt="Question Media" 
                                                 class="img-fluid" 
                                                 style="max-width:100%; border-radius:8px;"
                                                 onerror="this.onerror=null; this.style.display='none'; document.getElementById('imageError').style.display='block';">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div id="imageError" style="display:none; color: red; margin-top: 10px; padding: 10px; background: #fff5f5; border-radius: 4px;">
                                        <strong>Error loading image:</strong><br>
                                        Path: ${question.media_url}<br>
                                        <small>Please check if the URL is correct and accessible.</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                       
                    <div class="answers-container mt-4">
                        <form id="answerForm">
                             <c:choose>
                                <c:when test="${question.type eq 'multiple'}">
                                    <%-- Count correct options to determine input type (radio/checkbox) --%>
                                    <c:set var="correctOptionsCount" value="0" />
                                    <c:forEach items="${question.questionOptions}" var="opt">
                                        <c:if test="${opt.correct_key}">
                                            <c:set var="correctOptionsCount" value="${correctOptionsCount + 1}" />
                                        </c:if>
                                    </c:forEach>

                                    <c:forEach items="${question.questionOptions}" var="option">
                                        <c:set var="isUserSelected" value="${fn:contains(userAnswerMap[question.id], option.id)}" />
                                        <c:set var="isCorrect" value="${option.correct_key}" />
                                        
                                        <c:set var="labelClass" value="" />
                                        <c:if test="${isUserSelected && isCorrect}"><c:set var="labelClass" value="correct-answer" /></c:if>
                                        <c:if test="${isUserSelected && !isCorrect}"><c:set var="labelClass" value="incorrect-answer" /></c:if>
                                        <c:if test="${!isUserSelected && isCorrect}"><c:set var="labelClass" value="missed-correct-answer" /></c:if>
                                        <c:if test="${!isUserSelected && !isCorrect}"><c:set var="labelClass" value="unselected-option" /></c:if>

                                        <div class="form-check">
                                            <input class="form-check-input" 
                                                   type="${correctOptionsCount > 1 ? 'checkbox' : 'radio'}"
                                                   name="answer_${question.id}" 
                                                   id="option${option.id}" 
                                                   value="${option.id}"
                                                   <c:if test="${isUserSelected}">checked</c:if>
                                                   disabled>
                                            <label class="form-check-label ${labelClass}" for="option${option.id}">
                                                ${option.option_text}
                                            </label>
                                        </div>
                                    </c:forEach>
                                    

                                </c:when>
                                <c:otherwise>
                                     <!-- Essay Review not fully implemented, showing readonly textarea -->
                                     <div class="essay-answer-container">
                                        <textarea class="form-control essay-answer-review" 
                                                  name="essay_answer" 
                                                  rows="6" 
                                                  readonly>${essayAnswerMap[question.id]}</textarea>
                                    </div>
                                    
                                    <!-- Expert feedback section for essay questions -->
                                    <c:if test="${question.type eq 'essay'}">
                                        <c:set var="hasExpertFeedback" value="false" />
                                        <c:forEach items="${allUserAnswers}" var="answer">
                                            <c:if test="${answer.quiz_question_id eq question.id && (not empty answer.essay_score || not empty answer.essay_feedback)}">
                                                <c:set var="hasExpertFeedback" value="true" />
                                                <div class="expert-feedback">
                                                    <div class="expert-feedback-header">
                                                        <i class="fas fa-comment-dots"></i> Expert Feedback
                                                    </div>
                                                    <div class="expert-feedback-content">
                                                        <c:choose>
                                                            <c:when test="${not empty answer.essay_feedback}">
                                                                ${answer.essay_feedback}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-feedback">No feedback provided</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${not empty answer.essay_score}">
                                                        <div class="expert-feedback-score">${answer.essay_score}/10</div>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:if test="${!hasExpertFeedback && attempt.status eq 'partially_graded'}">
                                            <div class="expert-feedback">
                                                <div class="expert-feedback-header">
                                                    <i class="fas fa-hourglass-half"></i> Grading in Progress
                                                </div>
                                                <div class="expert-feedback-content">
                                                    <span class="no-feedback">Your essay is still being graded by our experts. Please check back later.</span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>

                <div class="navigation-footer">
                     <div class="left-buttons">
                         <a href="${pageContext.request.contextPath}/quiz-handle-menu${not empty param.packageId ? '?packageId='.concat(param.packageId) : ''}" class="btn-review-back">
                            <i class="fas fa-arrow-left"></i>
                            Back to Quizzes
                        </a>
                        <!-- Review Progress Button -->
                        <button class="btn-review" onclick="openReviewPopup()">
                            <i class="fas fa-tasks"></i>
                            Review Progress
                        </button>
                     </div>

                    <div class="navigation-buttons">
                        <div class="action-buttons">
                            <button class="btn-action btn-peek" onclick="openPeekPopup()">
                                <i class="fas fa-eye"></i>
                                Explanation
                            </button>
                        </div>
                        <div class="nav-buttons">
                            <div class="nav-group">
                                <c:if test="${currentNumber > 1}">
                                    <a href="quiz-review?quizId=${quiz.id}&questionNumber=${currentNumber - 1}${not empty param.packageId ? '&packageId='.concat(param.packageId) : ''}" class="btn-nav btn-prev">
                                        <i class="fas fa-arrow-left"></i>
                                        Previous
                                    </a>
                                </c:if>
                                <c:if test="${currentNumber < fn:length(questions)}">
                                    <a href="quiz-review?quizId=${quiz.id}&questionNumber=${currentNumber + 1}${not empty param.packageId ? '&packageId='.concat(param.packageId) : ''}" class="btn-nav btn-next">
                                        Next
                                        <i class="fas fa-arrow-right"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

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
                            <p class="review-subtitle">Filter questions:</p>
                            <div class="review-buttons">
                                <button class="review-btn btn-unanswered" onclick="filterQuestions('unanswered')">
                                    Incorrect
                                </button>
                                <button class="review-btn btn-answered" onclick="filterQuestions('answered')">
                                    Correct
                                </button>
                                <button class="review-btn btn-all active" onclick="filterQuestions('all')">
                                    All Questions
                                </button>
                            </div>
                            
                            <!-- Question Grid -->
                            <div class="question-grid">
                                <c:forEach begin="1" end="${fn:length(questions)}" var="i">
                                    <c:set var="currentQ" value="${questions[i-1]}" />
                                    <c:set var="isCorrect" value="false" />
                                    
                                    <c:if test="${not empty userAnswerMap[currentQ.id]}">
                                        <c:set var="hasAllCorrectAnswers" value="true" />
                                        <c:set var="hasIncorrectAnswers" value="false" />
                                        
                                        <c:forEach items="${currentQ.questionOptions}" var="opt">
                                            <c:if test="${opt.correct_key && !fn:contains(userAnswerMap[currentQ.id], opt.id)}">
                                                <c:set var="hasAllCorrectAnswers" value="false" />
                                            </c:if>
                                            <c:if test="${!opt.correct_key && fn:contains(userAnswerMap[currentQ.id], opt.id)}">
                                                <c:set var="hasIncorrectAnswers" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:if test="${hasAllCorrectAnswers && !hasIncorrectAnswers}">
                                            <c:set var="isCorrect" value="true" />
                                        </c:if>
                                    </c:if>
                                    
                                    <div class="question-box ${i == currentNumber ? 'current' : ''} ${isCorrect ? 'answered' : 'unanswered'}" 
                                         data-question-id="${questions[i-1].id}"
                                         data-status="${isCorrect ? 'correct' : 'incorrect'}"
                                         onclick="navigateToQuestion('${i}')">
                                        <span class="question-number">${i}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="peekPopup" class="peek-popup">
                    <div class="popup-content">
                        <div class="popup-header">
                            <h3>Explanation</h3>
                            <button class="close-btn" onclick="closePeekPopup()"><i class="fas fa-times"></i></button>
                        </div>
                        <div class="popup-body">
                            <div class="explanation-text">
                                ${not empty question.explanation ? question.explanation : 'No explanation available for this question.'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

        <script>
            function openPeekPopup() {
                console.log('Opening peek popup...');
                const popup = document.getElementById('peekPopup');
                if (popup) {
                    popup.classList.add('show');
                    console.log('Popup should be visible now');
                } else {
                    console.error('Peek popup element not found!');
                }
            }
            function closePeekPopup() {
                console.log('Closing peek popup...');
                const popup = document.getElementById('peekPopup');
                if (popup) {
                    popup.classList.remove('show');
                    console.log('Popup should be hidden now');
                } else {
                    console.error('Peek popup element not found!');
                }
            }
            document.addEventListener('click', function(event) {
                const peekPopup = document.getElementById('peekPopup');
                if (event.target === peekPopup) {
                    closePeekPopup();
                }
            });
            
            // Review Progress Functions
            function openReviewPopup() {
                document.getElementById('reviewPopup').classList.add('show');
            }
            
            function closeReviewPopup() {
                document.getElementById('reviewPopup').classList.remove('show');
            }
            
            // Close popup when clicking outside
            document.addEventListener('click', function(event) {
                const reviewPopup = document.getElementById('reviewPopup');
                if (event.target === reviewPopup) {
                    closeReviewPopup();
                }
            });
            
            // Filter questions by status (correct/incorrect/all)
            function filterQuestions(type) {
                const boxes = document.querySelectorAll('.question-box');
                
                boxes.forEach(box => {
                    const status = box.getAttribute('data-status');
                    let shouldShow = false;
                    
                    switch(type) {
                        case 'unanswered': // Incorrect
                            shouldShow = status === 'incorrect';
                            break;
                        case 'answered': // Correct
                            shouldShow = status === 'correct';
                            break;
                        case 'all':
                            shouldShow = true;
                            break;
                    }
                    
                    box.style.display = shouldShow ? 'flex' : 'none';
                });
                
                // Highlight active button
                const buttons = document.querySelectorAll('.review-btn');
                buttons.forEach(button => {
                    button.classList.remove('active');
                    if (button.classList.contains('btn-' + type)) {
                        button.classList.add('active');
                    }
                });
            }
            
            // Navigate to question
            function navigateToQuestion(questionNumber) {
                window.location.href = 'quiz-review?quizId=${quiz.id}&questionNumber=' + questionNumber;
            }
            
            // Initialize: set all questions button as active initially
            document.addEventListener('DOMContentLoaded', function() {
                // Ensure popup is hidden on page load
                const popup = document.getElementById('peekPopup');
                if (popup) {
                    popup.classList.remove('show');
                    console.log('Ensuring popup is hidden on page load');
                }
                
                document.querySelector('.btn-all').classList.add('active');
                
                // Fix relative paths in HTML media content
                const htmlMediaContent = document.querySelector('.html-media-content');
                if (htmlMediaContent) {
                    // Fix video sources
                    const videos = htmlMediaContent.querySelectorAll('video source');
                    videos.forEach(source => {
                        const src = source.getAttribute('src');
                        if (src && src.startsWith('/SWP391_QUIZ_PRACTICE_SU25/uploads/')) {
                            source.setAttribute('src', '${pageContext.request.contextPath}' + src);
                        } else if (src && src.startsWith('../uploads/')) {
                            source.setAttribute('src', '${pageContext.request.contextPath}/' + src.substring(3));
                        }
                    });
                    
                    // Fix image sources
                    const images = htmlMediaContent.querySelectorAll('img');
                    images.forEach(img => {
                        const src = img.getAttribute('src');
                        if (src && src.startsWith('/SWP391_QUIZ_PRACTICE_SU25/uploads/')) {
                            img.setAttribute('src', '${pageContext.request.contextPath}' + src);
                        } else if (src && src.startsWith('../uploads/')) {
                            img.setAttribute('src', '${pageContext.request.contextPath}/' + src.substring(3));
                        }
                    });
                }
            });
            
            // Settings dropdown functionality
            function toggleSettingsDropdown() {
                const dropdown = document.querySelector('.settings-dropdown');
                dropdown.classList.toggle('show');
            }
            
            function exitQuiz() {
                if (confirm('Are you sure you want to exit the quiz? Your progress will be saved.')) {
                    window.location.href = '${pageContext.request.contextPath}/quiz-handle-menu';
                }
            }
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                const settingsMenu = document.querySelector('.settings-menu');
                const dropdown = document.querySelector('.settings-dropdown');
                
                if (settingsMenu && dropdown && !settingsMenu.contains(event.target)) {
                    dropdown.classList.remove('show');
                }
            });
        </script>
    </body>
</html>
