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
                    background: #5751E1;
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

                .question-box.marked {
                    border-color: #ffd700;
                    background: #fffbeb;
                    z-index: 2;
                }

                .question-box.answered {
                    border-color: #28a745;
                    background: #f0fff4;
                    z-index: 1;
                }

                /* Ưu tiên hiển thị màu của marked */
                .question-box.marked.answered {
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
                        grid-template-columns: repeat(4, 1fr);
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

                /* Review buttons styles */
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

                .btn-marked {
                    border-color: #ffd700;
                    color: #8a7703;
                }

                .btn-marked:hover {
                    background: #fffbeb;
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

                .btn-marked.active {
                    background-color: #ffd700;
                    color: #8a7703;
                }

                .btn-all.active {
                    background-color: #8B7FD2;
                }

                /* Score Exam Popup Styles */
                .score-exam-popup {
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

                .score-exam-popup .popup-content {
                    background: white;
                    border-radius: 12px;
                    width: 90%;
                    max-width: 500px;
                    padding: 24px;
                    position: relative;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                }

                .score-exam-popup .popup-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    padding-bottom: 12px;
                    border-bottom: 1px solid #eee;
                }

                .score-exam-popup .popup-header h3 {
                    font-size: 24px;
                    font-weight: 600;
                    color: #1A1B3D;
                    margin: 0;
                }

                .score-exam-popup .answered-count {
                    color: #dc3545;
                    font-size: 16px;
                    margin-bottom: 16px;
                    font-weight: 500;
                }

                .score-exam-popup .popup-message {
                    font-size: 16px;
                    line-height: 1.6;
                    color: #4B5563;
                    margin-bottom: 24px;
                }

                .score-exam-popup .popup-buttons {
                    display: flex;
                    justify-content: flex-end;
                    gap: 12px;
                }

                .score-exam-popup .btn-back {
                    padding: 10px 24px;
                    border: 2px solid #5751E1;
                    background: white;
                    color: #5751E1;
                    border-radius: 8px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .score-exam-popup .btn-back:hover {
                    background: #f8f7ff;
                }

                .score-exam-popup .btn-confirm {
                    padding: 10px 24px;
                    border: none;
                    background: #5751E1;
                    color: white;
                    border-radius: 8px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .score-exam-popup .btn-confirm:hover {
                    background: #7A6DC0;
                }

                .score-exam-popup .close-btn {
                    background: none;
                    border: none;
                    font-size: 20px;
                    color: #666;
                    cursor: pointer;
                    padding: 4px;
                    transition: color 0.3s ease;
                }

                .score-exam-popup .close-btn:hover {
                    color: #1A1B3D;
                }

                /* Essay Question Styles */
                .essay-answer-container {
                    width: 100%;
                    margin-top: 20px;
                }

                .essay-answer {
                    width: 100%;
                    padding: 15px;
                    border: 2px solid #e0e0e0;
                    border-radius: 8px;
                    font-size: 16px;
                    line-height: 1.6;
                    resize: vertical;
                    min-height: 200px;
                    transition: all 0.3s ease;
                }

                .essay-answer:focus {
                    border-color: #8B7FD2;
                    box-shadow: 0 0 0 2px rgba(139, 127, 210, 0.1);
                    outline: none;
                }

                .essay-controls {
                    display: flex;
                    justify-content: flex-end;
                    color: #666;
                    font-size: 14px;
                }

                .word-count {
                    padding: 4px 8px;
                    background: #f8f9fa;
                    border-radius: 4px;
                }

                /* Score Result Popup Styles */
                .score-result-popup {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    z-index: 1100;
                    justify-content: center;
                    align-items: center;
                }

                .score-result-popup .popup-content {
                    background: white;
                    border-radius: 12px;
                    width: 90%;
                    max-width: 500px;
                    padding: 24px;
                    text-align: center;
                }

                .score-display {
                    margin: 20px 0;
                }

                .score-circle {
                    width: 150px;
                    height: 150px;
                    border-radius: 50%;
                    background: #f8f7ff;
                    border: 8px solid #5751E1;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto;
                    position: relative;
                }

                #finalScore {
                    font-size: 48px;
                    font-weight: bold;
                    color: #5751E1;
                }

                .score-label {
                    font-size: 24px;
                    color: #666;
                    margin-left: 4px;
                }

                .score-message {
                    font-size: 18px;
                    color: #1A1B3D;
                    margin: 20px 0;
                    padding: 10px;
                    border-radius: 8px;
                }

                .popup-buttons {
                    display: flex;
                    justify-content: center;
                    gap: 16px;
                    margin-top: 24px;
                }

                .btn-review-answers,
                .btn-return-dashboard {
                    padding: 12px 24px;
                    border-radius: 8px;
                    font-weight: 500;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .btn-review-answers {
                    background: #5751E1;
                    color: white;
                    border: none;
                }

                .btn-return-dashboard {
                    background: white;
                    color: #5751E1;
                    border: 2px solid #5751E1;
                }

                .btn-review-answers:hover {
                    background: #7A6DC0;
                }

                .btn-return-dashboard:hover {
                    background: #f8f7ff;
                }

                @media (max-width: 576px) {
                    .score-circle {
                        width: 120px;
                        height: 120px;
                        border-width: 6px;
                    }

                    #finalScore {
                        font-size: 36px;
                    }

                    .score-label {
                        font-size: 18px;
                    }

                    .popup-buttons {
                        flex-direction: column;
                    }

                    .btn-review-answers,
                    .btn-return-dashboard {
                        width: 100%;
                        justify-content: center;
                    }
                }

                /* --- New Answer Option Styles --- */
                .form-check-input { display: none; }
                .form-check-label {
                    display: flex;
                    align-items: center;
                    padding: 1rem 1.25rem;
                    border: 1px solid #dee2e6;
                    border-radius: 0.5rem;
                    margin-bottom: 0.75rem;
                    transition: all 0.2s ease-in-out;
                    cursor: pointer;
                    position: relative;
                    background-color: #f8f9fa;
                }
                .form-check-label::before {
                    font-family: "Font Awesome 5 Free";
                    font-weight: 900;
                    font-size: 1.2em;
                    width: 24px;
                    margin-right: 1rem;
                    content: '\f111'; /* circle */
                    color: #adb5bd;
                    transition: all 0.2s ease-in-out;
                }
                .form-check-label:hover {
                    border-color: #8B7FD2;
                    background-color: #f8f7ff;
                }
                .form-check-input:checked + .form-check-label {
                    background-color: #f8f7ff;
                    border-color: #5751E1;
                    color: #5751E1;
                    font-weight: 500;
                }
                .form-check-input:checked + .form-check-label::before {
                    content: '\f058'; /* check-circle */
                    color: #5751E1;
                }

                /* Style cho nút Peek */
                .btn-peek:hover {
                    background: #f0f0f0;
                }

                .settings-menu {
                    position: relative !important;
                }
                .settings-dropdown {
                    left: 50% !important;
                    right: auto !important;
                    transform: translateX(-50%) !important;
                    top: 120% !important;
                    min-width: 180px;
                }

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
                <!-- Header removed. -->
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
                    <div class="question-info" style="display: flex; align-items: center; justify-content: space-between; gap: 16px;">
                        <div class="question-number">Question ${currentNumber}/${totalQuestions}</div>
                        <div class="settings-menu" style="display: flex; align-items: center; justify-content: center; flex: 1;">
                            <div class="settings-icon" onclick="toggleSettingsDropdown()" style="margin: 0 auto;">
                                <i class="fas fa-cog"></i>
                            </div>
                            <div class="settings-dropdown">
                                <a href="#" class="dropdown-item" onclick="exitQuiz()">
                                    <i class="fas fa-sign-out-alt"></i>
                                    <span>Exit Quiz</span>
                                </a>
                            </div>
                        </div>
                        <div class="question-id">Question ID: ${question.id}</div>
                    </div>
                </div>

                <!-- Question Content Area -->
                <div class="question-content">
                    <div class="question-text">
                        ${question.content}
                    </div>
                    
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

                    <!-- Answer Options -->
                    <div class="answers-container mt-4">
                        <form id="answerForm" method="POST" action="${pageContext.request.contextPath}/quiz-handle">
                            <input type="hidden" name="action" value="saveAnswer">
                            <input type="hidden" name="questionNumber" value="${currentNumber}">
                            <input type="hidden" name="questionId" value="${question.id}">
                            <input type="hidden" name="nextAction" id="nextAction" value="">
                            
                            <c:choose>
                                <c:when test="${empty question.type}">
                                    <!-- Hiển thị thông báo lỗi khi type là null -->
                                    <div class="alert alert-danger" role="alert">
                                        <strong><i class="fas fa-exclamation-circle"></i> ERROR:</strong>
                                        <div>
                                            This question has not been set the type in the database.<br>
                                            Please contact to the admin for the technical support.<br>
                                            Question ID: ${question.id}
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${question.type eq 'multiple'}">
                                    <%-- Count correct options to determine input type (radio/checkbox) --%>
                                    <c:set var="correctOptionsCount" value="0" />
                                    <c:forEach items="${question.questionOptions}" var="opt">
                                        <c:if test="${opt.correct_key}">
                                            <c:set var="correctOptionsCount" value="${correctOptionsCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <!-- Multiple Choice Question -->
                                    <c:forEach items="${question.questionOptions}" var="option">
                                        <div class="answer-option mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" 
                                                       type="${correctOptionsCount > 1 ? 'checkbox' : 'radio'}"
                                                       name="answer" 
                                                       id="option${option.id}" 
                                                       value="${option.id}"
                                                       <c:if test="${not empty selectedAnswers && selectedAnswers.contains(option.id)}">checked</c:if>>
                                                <label class="form-check-label" for="option${option.id}">
                                                    ${option.option_text}
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Essay Question -->
                                    <div class="essay-answer-container">
                                        <textarea class="form-control essay-answer" 
                                                  name="essay_answer" 
                                                  rows="6" 
                                                  placeholder="Type your answer here...">${selectedAnswers}</textarea>
                                        <div class="essay-controls mt-2">
                                            <span class="word-count">0 words</span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>

                <!-- Navigation Footer Section: Chứa các nút điều hướng -->
                <div class="navigation-footer">
                    <!-- Nút Review Progress-->
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
                                             data-question-id="${questions[i-1].id}"
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
                                    <button type="button" class="btn-nav btn-prev" onclick="handleNavigation('previous')">
                                        <i class="fas fa-arrow-left"></i>
                                        Previous
                                    </button>
                                </c:if>
                                <c:if test="${currentNumber < totalQuestions}">
                                    <button type="button" class="btn-nav btn-next" onclick="handleNavigation('next')">
                                        Next
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </c:if>
                                <c:if test="${currentNumber == totalQuestions}">
                                    <button type="button" class="btn-nav btn-score" onclick="openScoreExamConfirmation()">
                                        Submit Exam
                                        <i class="fas fa-check"></i>
                                    </button>
                                </c:if>
                                <input type="hidden" name="action" value="saveAnswer">
                                <input type="hidden" name="nextAction" id="nextAction" value="">
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

                <!-- Score Exam Confirmation Popup -->
                <div id="scoreExamPopup" class="score-exam-popup">
                    <div class="popup-content">
                        <div class="popup-header">
                            <h3 id="popupTitle"></h3>
                            <button class="close-btn" onclick="closeScoreExamPopup()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="popup-body">
                            <div id="answeredCount" class="answered-count"></div>
                            <p id="popupMessage" class="popup-message"></p>
                            <div class="popup-buttons">
                                <button class="btn-back" onclick="closeScoreExamPopup()">Back</button>
                                <button id="confirmButton" class="btn-confirm"></button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Score Result Popup -->
                <div id="scoreResultPopup" class="score-result-popup">
                    <div class="popup-content">
                        <div class="popup-header">
                            <h3>Quiz Result</h3>
                            <button class="close-btn" onclick="closeScoreResultPopup()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="popup-body">
                            <div class="score-display">
                                <div class="score-circle">
                                    <span id="finalScore">0</span>
                                    <span class="score-label">/10</span>
                                </div>
                            </div>
                            <div id="scoreMessage" class="score-message"></div>
                            <div class="popup-buttons">
                                <button class="btn-review-answers" onclick="reviewAnswers()">
                                    <i class="fas fa-search"></i>
                                    Review Answers
                                </button>
                                <button class="btn-return-dashboard" onclick="returnToDashboard()">
                                    <i class="fas fa-home"></i>
                                    Return to Dashboard
                                </button>
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
            
                            .media-content{
                    width: 40%;
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
                color: #1A1B3D;
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

            .settings-menu {
                position: relative !important;
            }
            .settings-dropdown {
                left: 50% !important;
                right: auto !important;
                transform: translateX(-50%) !important;
                top: 120% !important;
                min-width: 180px;
            }

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
        </style>
        <!-- main-area-end -->

        <!-- Simple footer: hidden or minimal -->
        <footer style="text-align:center; font-size:12px; color:#aaa; padding:10px 0; background:none; border:none;">
            <!-- Footer intentionally left blank -->
        </footer>

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
            function exitQuiz() {
                // Lấy packageId từ URL hiện tại
                const urlParams = new URLSearchParams(window.location.search);
                const packageId = urlParams.get('packageId');
                let redirectUrl = '${pageContext.request.contextPath}/quiz-handle-menu';
                if (packageId) {
                    redirectUrl += '?packageId=' + encodeURIComponent(packageId);
                }
                if (confirm('Are you sure you want to exit the quiz? Your progress will not be saved.')) {
                    window.location.href = redirectUrl;
                }
            }
        </script>
        
        <script>
            // Khởi tạo trạng thái câu hỏi
            let questionStates = {
                answered: new Set(),
                marked: new Set()
            };

            document.addEventListener('DOMContentLoaded', function() {
                // Khôi phục trạng thái từ sessionStorage thay vì localStorage
                const savedAnswered = JSON.parse(sessionStorage.getItem('answeredQuestions') || '{}');
                const savedMarked = JSON.parse(sessionStorage.getItem('markedQuestions') || '{}');
                const savedSelectedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                
                // Khởi tạo trạng thái từ dữ liệu đã lưu
                questionStates = {
                    answered: new Set(Object.keys(savedAnswered).map(Number)),
                    marked: new Set(Object.keys(savedMarked).map(Number))
                };

                // Khôi phục đáp án đã chọn cho câu hỏi hiện tại
                const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                if (savedSelectedAnswers[currentQuestionId]) {
                    const selectedAnswerIds = savedSelectedAnswers[currentQuestionId];
                    document.querySelectorAll('input[name="answer"]').forEach(input => {
                        input.checked = selectedAnswerIds.includes(parseInt(input.value));
                    });
                }

                // Kiểm tra câu trả lời hiện tại và cập nhật trạng thái
                const hasSelectedAnswer = Array.from(document.querySelectorAll('input[name="answer"]')).some(input => input.checked);
                
                if (hasSelectedAnswer) {
                    questionStates.answered.add(currentQuestionId);
                    saveAnsweredStates();
                }

                // Cập nhật trạng thái nút Mark cho câu hỏi hiện tại
                const markButton = document.querySelector('.btn-mark');
                if (questionStates.marked.has(currentQuestionId)) {
                    markButton.classList.add('marked');
                }

                // Cập nhật hiển thị của các ô câu hỏi
                updateQuestionBoxStates();

                // Thêm event listener cho các input radio/checkbox
                document.querySelectorAll('input[name="answer"]').forEach(input => {
                    input.addEventListener('change', function() {
                        const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                        const selectedAnswers = Array.from(document.querySelectorAll('input[name="answer"]'))
                            .filter(input => input.checked)
                            .map(input => parseInt(input.value));
                        
                        // Lưu đáp án đã chọn vào sessionStorage
                        const savedSelectedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                        savedSelectedAnswers[currentQuestionId] = selectedAnswers;
                        sessionStorage.setItem('selectedAnswers', JSON.stringify(savedSelectedAnswers));
                        
                        if (selectedAnswers.length > 0) {
                            questionStates.answered.add(currentQuestionId);
                        } else {
                            questionStates.answered.delete(currentQuestionId);
                        }
                        
                        saveAnsweredStates();
                        updateQuestionBoxStates();
                    });
                });
                
            });

            // Hàm lưu trạng thái answered vào sessionStorage
            function saveAnsweredStates() {
                const answeredQuestions = {};
                questionStates.answered.forEach(id => {
                    answeredQuestions[id] = true;
                });
                sessionStorage.setItem('answeredQuestions', JSON.stringify(answeredQuestions));
            }

            // Hàm lưu trạng thái marked vào sessionStorage
            function saveMarkedStates() {
                const markedQuestions = {};
                questionStates.marked.forEach(id => {
                    markedQuestions[id] = true;
                });
                sessionStorage.setItem('markedQuestions', JSON.stringify(markedQuestions));
            }

            // Hàm lọc câu hỏi theo trạng thái
            function filterQuestions(type) {
                const boxes = document.querySelectorAll('.question-box');
                
                boxes.forEach(box => {
                    const questionId = parseInt(box.getAttribute('data-question-id'));
                    let shouldShow = false;
                    
                    switch(type) {
                        case 'unanswered':
                            shouldShow = !questionStates.answered.has(questionId);
                            break;
                        case 'answered':
                            shouldShow = questionStates.answered.has(questionId);
                            break;
                        case 'marked':
                            shouldShow = questionStates.marked.has(questionId);
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

            // Hàm cập nhật trạng thái các ô câu hỏi
            function updateQuestionBoxStates() {
                const boxes = document.querySelectorAll('.question-box');
                const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                
                boxes.forEach(box => {
                    const questionId = parseInt(box.getAttribute('data-question-id'));
                    
                    // Reset classes
                    box.classList.remove('answered', 'unanswered', 'marked', 'current');
                    
                    // Mặc định là unanswered
                    box.classList.add('unanswered');
                    
                    // Thêm class phù hợp
                    if (questionStates.marked.has(questionId)) {
                        box.classList.add('marked');
                        box.classList.remove('unanswered');
                    }
                    if (questionStates.answered.has(questionId)) {
                        box.classList.add('answered');
                        box.classList.remove('unanswered');
                    }
                    
                    // Đánh dấu câu hiện tại
                    if (questionId === currentQuestionId) {
                        box.classList.add('current');
                    }
                });
            }
        </script>

        <!-- Thêm input hidden để lưu dữ liệu câu trả lời -->
        <input type="hidden" id="userAnswersData" 
               value='${fn:replace(not empty sessionScope.userAnswers ? sessionScope.userAnswers : "{}", "'", "\\'")}'>

        <script>
            // Thêm event listeners cho các nút filter
            document.addEventListener('DOMContentLoaded', function() {
                // Thêm click handlers cho các nút filter
                document.querySelector('.btn-unanswered').addEventListener('click', () => {
                    filterQuestions('unanswered');
                    highlightActiveButton('btn-unanswered');
                });
                document.querySelector('.btn-answered').addEventListener('click', () => {
                    filterQuestions('answered');
                    highlightActiveButton('btn-answered');
                });
                document.querySelector('.btn-marked').addEventListener('click', () => {
                    filterQuestions('marked');
                    highlightActiveButton('btn-marked');
                });
                document.querySelector('.btn-all').addEventListener('click', () => {
                    filterQuestions('all');
                    highlightActiveButton('btn-all');
                });
            });

            // Hàm highlight nút đang active
            function highlightActiveButton(activeClass) {
                const buttons = document.querySelectorAll('.review-btn');
                buttons.forEach(button => {
                    button.classList.remove('active');
                    if (button.classList.contains(activeClass)) {
                        button.classList.add('active');
                    }
                });
            }
        </script>

        <script>
            // Các hàm xử lý popup
            function openReviewPopup() {
                document.getElementById('reviewPopup').classList.add('show');
            }

            function closeReviewPopup() {
                document.getElementById('reviewPopup').classList.remove('show');
            }

            // Đóng popup khi click bên ngoài
            document.addEventListener('click', function(event) {
                const popup = document.getElementById('reviewPopup');
                if (event.target === popup) {
                    closeReviewPopup();
                }
            });

            // Hàm xử lý popup Peek
            function openPeekPopup() {
                document.getElementById('peekPopup').style.display = 'flex';
            }

            function closePeekPopup() {
                document.getElementById('peekPopup').style.display = 'none';
            }

            // Đóng popup Peek khi click bên ngoài
            document.addEventListener('click', function(event) {
                const peekPopup = document.getElementById('peekPopup');
                if (event.target === peekPopup) {
                    closePeekPopup();
                }
            });

            // Hàm lưu trạng thái marked vào sessionStorage
            function saveMarkedStates() {
                const markedQuestions = {};
                questionStates.marked.forEach(id => {
                    markedQuestions[id] = true;
                });
                sessionStorage.setItem('markedQuestions', JSON.stringify(markedQuestions));
            }

            // Hàm xử lý đánh dấu câu hỏi
            function toggleMarkForReview(button) {
                const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                
                if (button.classList.contains('marked')) {
                    questionStates.marked.delete(currentQuestionId);
                    button.classList.remove('marked');
                } else {
                    questionStates.marked.add(currentQuestionId);
                    button.classList.add('marked');
                }
                
                saveMarkedStates();
                updateQuestionBoxStates();
            }

            // Hàm điều hướng đến câu hỏi
            function navigateToQuestion(questionNumber) {
                saveCurrentState();
                
                // Lấy quizId và packageId từ URL hiện tại
                const urlParams = new URLSearchParams(window.location.search);
                const quizId = urlParams.get('id');
                const packageId = urlParams.get('packageId');
                
                // Tạo URL điều hướng với packageId
                let url = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId + '&questionNumber=' + questionNumber;
                if (packageId) {
                    url += '&packageId=' + packageId;
                }
                window.location.href = url;
            }

            // Hàm xử lý điều hướng
            function handleNavigation(action) {
                console.log('=== handleNavigation Debug ===');
                console.log('Action:', action);
                saveCurrentState();
                
                const form = document.getElementById('answerForm');
                const formData = new FormData(form);
                
                console.log('Form elements:', {
                    action: form.querySelector('input[name="action"]').value,
                    nextAction: document.getElementById('nextAction').value,
                    questionId: formData.get('questionId'),
                    questionNumber: formData.get('questionNumber'),
                    answers: formData.getAll('answer')
                });
                
                form.querySelector('input[name="action"]').value = 'saveAnswer';
                document.getElementById('nextAction').value = action;
                
                // Lấy quizId từ URL và thêm vào form nếu chưa có
                const urlParams = new URLSearchParams(window.location.search);
                const quizId = urlParams.get('id');
                const packageId = urlParams.get('packageId');
                
                let quizIdInput = form.querySelector('input[name="quizId"]');
                if (!quizIdInput) {
                    quizIdInput = document.createElement('input');
                    quizIdInput.type = 'hidden';
                    quizIdInput.name = 'quizId';
                    form.appendChild(quizIdInput);
                }
                quizIdInput.value = quizId;
                
                // Thêm packageId vào form nếu có
                if (packageId) {
                    let packageIdInput = form.querySelector('input[name="packageId"]');
                    if (!packageIdInput) {
                        packageIdInput = document.createElement('input');
                        packageIdInput.type = 'hidden';
                        packageIdInput.name = 'packageId';
                        form.appendChild(packageIdInput);
                    }
                    packageIdInput.value = packageId;
                }
                
                console.log('Updated form data:', {
                    action: form.querySelector('input[name="action"]').value,
                    nextAction: document.getElementById('nextAction').value,
                    quizId: quizIdInput.value
                });
                
                form.submit();
            }

            // Hàm lưu trạng thái hiện tại
            function saveCurrentState() {
                const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                const selectedAnswers = Array.from(document.querySelectorAll('input[name="answer"]'))
                    .filter(input => input.checked)
                    .map(input => parseInt(input.value));
                
                // Lưu đáp án đã chọn vào sessionStorage
                const savedSelectedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                savedSelectedAnswers[currentQuestionId] = selectedAnswers;
                sessionStorage.setItem('selectedAnswers', JSON.stringify(savedSelectedAnswers));
                
                const markButton = document.querySelector('.btn-mark');

                // Lưu trạng thái answered
                if (selectedAnswers.length > 0) {
                    questionStates.answered.add(currentQuestionId);
                    saveAnsweredStates();
                }

                // Lưu trạng thái marked
                if (markButton.classList.contains('marked')) {
                    questionStates.marked.add(currentQuestionId);
                    saveMarkedStates();
                }
            }
        </script>

        <script>
            // Hàm xử lý popup xác nhận score exam
            function openScoreExamConfirmation() {
                const popup = document.getElementById('scoreExamPopup');
                const title = document.getElementById('popupTitle');
                const message = document.getElementById('popupMessage');
                const answeredCount = document.getElementById('answeredCount');
                const confirmButton = document.getElementById('confirmButton');
                
                // Đếm số câu đã trả lời
                const totalQuestionsCount = document.querySelectorAll('.question-box').length;
                const answeredQuestionsCount = questionStates.answered.size;
                
                // Xác định trường hợp và cập nhật nội dung popup
                if (answeredQuestionsCount === 0) {
                    // Trường hợp 1: Không trả lời câu nào
                    title.textContent = 'Exit Exam?';
                    message.textContent = 'You haven\'t answered any questions. Are you sure you want to exit the exam?';
                    answeredCount.style.display = 'none';
                    confirmButton.textContent = 'Exit Exam';
                } else if (answeredQuestionsCount < totalQuestionsCount) {
                    // Trường hợp 2: Chưa trả lời hết
                    title.textContent = 'Score Exam?';
                    answeredCount.textContent = answeredQuestionsCount + ' of ${totalQuestions} questions answered';
                    answeredCount.style.display = 'block';
                    message.textContent = 'You haven\'t answered all questions. Do you want to submit your answers and score the exam?';
                    confirmButton.textContent = 'Score Exam';
                } else {
                    // Trường hợp 3: Đã trả lời hết
                    title.textContent = 'Score Exam?';
                    answeredCount.style.display = 'none';
                    message.textContent = 'Are you ready to submit your answers and see your score?';
                    confirmButton.textContent = 'Score Exam';
                }
                
                // Thêm event listener cho nút confirm
                confirmButton.onclick = function() {
                    console.log('=== Score Exam Debug ===');
                    closeScoreExamPopup();
                    
                    const form = document.getElementById('answerForm');
                    const formData = new FormData(form);
                    
                    // Log form data trước khi thay đổi
                    console.log('Initial form data:', {
                        action: formData.get('action'),
                        questionId: formData.get('questionId'),
                        questionNumber: formData.get('questionNumber'),
                        answers: formData.getAll('answer')
                    });
                    
                    // Lấy dữ liệu từ sessionStorage
                    const savedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                    console.log('Saved answers from session:', savedAnswers);
                    
                    // Thêm hidden input cho userAnswers nếu chưa có
                    let userAnswersInput = form.querySelector('input[name="userAnswers"]');
                    if (!userAnswersInput) {
                        userAnswersInput = document.createElement('input');
                        userAnswersInput.type = 'hidden';
                        userAnswersInput.name = 'userAnswers';
                        form.appendChild(userAnswersInput);
                    }
                    userAnswersInput.value = JSON.stringify(savedAnswers);
                    
                    // Thêm quizId từ URL nếu có
                    const urlParams = new URLSearchParams(window.location.search);
                    const quizId = urlParams.get('id');
                    if (quizId) {
                        let quizIdInput = form.querySelector('input[name="quizId"]');
                        if (!quizIdInput) {
                            quizIdInput = document.createElement('input');
                            quizIdInput.type = 'hidden';
                            quizIdInput.name = 'quizId';
                            quizIdInput.value = quizId;
                            form.appendChild(quizIdInput);
                        }
                    }
                    
                    form.querySelector('input[name="action"]').value = 'score';
                    
                    // Log form data sau khi thay đổi
                    const updatedFormData = new FormData(form);
                    console.log('Updated form data:', {
                        action: updatedFormData.get('action'),
                        quizId: updatedFormData.get('quizId'),
                        userAnswers: updatedFormData.get('userAnswers')
                    });
                    
                    form.submit();
                };
                
                // Hiển thị popup
                popup.style.display = 'flex';

                console.log('Total questions:', totalQuestionsCount);
                console.log('Answered questions:', answeredQuestionsCount);
                console.log('Question states:', questionStates);
            }

            // Hàm đóng popup
            function closeScoreExamPopup() {
                document.getElementById('scoreExamPopup').style.display = 'none';
            }

            // Đóng popup khi click bên ngoài
            document.addEventListener('click', function(event) {
                const popup = document.getElementById('scoreExamPopup');
                if (event.target === popup) {
                    closeScoreExamPopup();
                }
            });
        </script>

        <!-- Thêm hàm để xóa session khi rời khỏi trang -->
        <script>
            window.addEventListener('beforeunload', function() {
                // Xóa session khi người dùng rời khỏi trang
                sessionStorage.removeItem('quizStarted');
            });
        </script>

        <script>
            // Add word count functionality for essay answers
            document.addEventListener('DOMContentLoaded', function() {
                const essayAnswer = document.querySelector('.essay-answer');
                const wordCount = document.querySelector('.word-count');
                
                if (essayAnswer && wordCount) {
                    function updateWordCount() {
                        const text = essayAnswer.value.trim();
                        const words = text ? text.split(/\s+/).length : 0;
                        wordCount.textContent = words + ' words';
                    }
                    
                    essayAnswer.addEventListener('input', updateWordCount);
                    // Initial count
                    updateWordCount();
                }
                
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
        </script>

        <!-- Thêm script để xử lý tự động lưu câu trả lời -->
        <script>
            // Thêm debounce để tránh gửi quá nhiều request
            let timeoutId;
            
            document.addEventListener('DOMContentLoaded', function() {
                const essayInput = document.querySelector('.essay-answer');
                
                if (essayInput) {
                    essayInput.addEventListener('input', function(e) {
                        clearTimeout(timeoutId);
                        
                        // Tự động lưu sau 500ms khi người dùng ngừng nhập
                        timeoutId = setTimeout(() => {
                            autoSaveEssayAnswer(e.target.value);
                        }, 500);
                    });
                }
            });

            function autoSaveEssayAnswer(answer) {
                const form = document.getElementById('answerForm');
                const formData = new FormData(form);
                
                // Đặt action là saveAnswer
                formData.set('action', 'saveAnswer');
                
                // Đảm bảo essay_answer được đưa vào formData
                formData.set('essay_answer', answer);
                
                // Thêm nextAction với giá trị mặc định là 'autosave'
                formData.set('nextAction', 'autosave');
                
                // Lấy ID câu hỏi hiện tại
                const currentQuestionId = parseInt(document.querySelector('input[name="questionId"]').value);
                
                // Thêm packageId vào formData nếu có
                const urlParams = new URLSearchParams(window.location.search);
                const packageId = urlParams.get('packageId');
                if (packageId) {
                    formData.set('packageId', packageId);
                }
                
                // Gửi request để lưu câu trả lời
                fetch('${pageContext.request.contextPath}/quiz-handle', {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if (response.ok) {
                        console.log('Essay answer saved successfully');
                        
                        // Cập nhật trạng thái answered
                        if (answer.trim() !== '') {
                            // Thêm câu hỏi vào danh sách đã trả lời
                            questionStates.answered.add(currentQuestionId);
                            saveAnsweredStates();
                        } else {
                            // Nếu câu trả lời trống, xóa khỏi danh sách đã trả lời
                            questionStates.answered.delete(currentQuestionId);
                            saveAnsweredStates();
                        }
                        
                        // Cập nhật hiển thị của các ô câu hỏi
                        updateQuestionBoxStates();
                    } else {
                        console.error('Error response from server:', response.status);
                        
                        // Thêm code để hiển thị chi tiết lỗi
                        response.text().then(text => {
                            console.error('Error details:', text);
                        });
                    }
                }).catch(error => {
                    console.error('Error saving essay answer:', error);
                });
            }
        </script>

        <script>
            // Hàm xử lý khi bấm nút Score Exam trong popup xác nhận
            function handleScoreExam() {
                try {
                    // Đóng popup xác nhận
                    closeScoreExamPopup();
                    
                    // Lấy dữ liệu từ sessionStorage và chuyển thành object
                    const savedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                    
                    // Tạo object chứa dữ liệu gửi đi
                    const requestData = {
                        action: 'score',
                        userAnswers: savedAnswers
                    };
                    
                    // Log để debug
                    console.log('Sending data:', requestData);
                    
                    // Gửi request bằng fetch API
                    fetch('${pageContext.request.contextPath}/quiz-handle', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(requestData)
                    })
                    .then(response => response.json())
                    .then(data => {
                        console.log('Success:', data);
                        if (data.score !== undefined) {
                            // Lưu điểm vào sessionStorage
                            sessionStorage.setItem('quizScore', data.score);
                            // Redirect về trang quiz-handle-menu với packageId
                            const urlParams = new URLSearchParams(window.location.search);
                            const packageId = urlParams.get('packageId');
                            let url = '${pageContext.request.contextPath}/quiz-handle-menu';
                            if (packageId) {
                                url += '?packageId=' + packageId;
                            }
                            window.location.href = url;
                            
                            // Xóa dữ liệu trong sessionStorage sau khi chấm điểm thành công
                            sessionStorage.removeItem('selectedAnswers');
                            sessionStorage.removeItem('answeredQuestions');
                            sessionStorage.removeItem('markedQuestions');
                        } else if (data.error) {
                            throw new Error(data.error);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Đã xảy ra lỗi khi chấm điểm: ' + error.message);
                    });
                    
                } catch (error) {
                    console.error('Error in handleScoreExam:', error);
                    alert('Đã xảy ra lỗi khi xử lý dữ liệu: ' + error.message);
                }
            }

            // Tách logic chấm điểm ra thành hàm riêng
            function submitQuiz() {
                // Đóng popup xác nhận
                closeScoreExamPopup();
                
                // Lấy tất cả câu trả lời từ sessionStorage
                const savedAnswers = JSON.parse(sessionStorage.getItem('selectedAnswers') || '{}');
                
                // Debug: Log dữ liệu gửi đi
                console.log('Submitting answers:', savedAnswers);
                
                // Tạo FormData object
                const formData = new FormData();
                formData.append('action', 'scoreExam');
                
                // Thêm quizId từ URL nếu có
                const urlParams = new URLSearchParams(window.location.search);
                const quizId = urlParams.get('id');
                if (quizId) {
                    formData.append('quizId', quizId);
                }
                
                // Chuyển đổi object thành mảng các câu trả lời
                const answersArray = Object.entries(savedAnswers).map(([questionId, answers]) => ({
                    questionId: parseInt(questionId),
                    selectedOptions: Array.isArray(answers) ? answers : [answers]
                }));
                
                formData.append('userAnswers', JSON.stringify(answersArray));
                
                // Debug: Log FormData
                for (let pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }
                
                // Gọi API để chấm điểm
                fetch('${pageContext.request.contextPath}/quiz-handle', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(text => {
                    try {
                        const data = JSON.parse(text);
                        // Lưu điểm vào sessionStorage (hoặc localStorage)
                        sessionStorage.setItem('quizScore', data.score);
                        // Redirect về trang quiz-handle-menu với packageId
                        const urlParams = new URLSearchParams(window.location.search);
                        const packageId = urlParams.get('packageId');
                        let url = '${pageContext.request.contextPath}/quiz-handle-menu';
                        if (packageId) {
                            url += '?packageId=' + packageId;
                        }
                        window.location.href = url;
                        
                        // Xóa dữ liệu trong sessionStorage sau khi chấm điểm thành công
                        sessionStorage.removeItem('selectedAnswers');
                        sessionStorage.removeItem('answeredQuestions');
                        sessionStorage.removeItem('markedQuestions');
                    } catch (e) {
                        console.error('Error parsing response:', e);
                        throw new Error('Invalid response format');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Đã xảy ra lỗi khi chấm điểm');
                });
            }

            // Hàm đóng popup kết quả
            function closeScoreResultPopup() {
                document.getElementById('scoreResultPopup').style.display = 'none';
            }

            // Hàm xem lại câu trả lời
            function reviewAnswers() {
                // Lấy packageId từ URL hiện tại
                const urlParams = new URLSearchParams(window.location.search);
                const packageId = urlParams.get('packageId');
                let url = '${pageContext.request.contextPath}/quiz-review?quizId=${quiz.id}';
                if (packageId) {
                    url += '&packageId=' + packageId;
                }
                window.location.href = url;
            }

            // Hàm trở về dashboard
            function returnToDashboard() {
                // Lấy packageId từ URL hiện tại
                const urlParams = new URLSearchParams(window.location.search);
                const packageId = urlParams.get('packageId');
                let url = '${pageContext.request.contextPath}/quiz-handle-menu';
                if (packageId) {
                    url += '?packageId=' + packageId;
                }
                window.location.href = url;
            }
        </script>
        
        <script>
        function toggleSettingsDropdown() {
            const settingsMenu = document.querySelector('.settings-menu');
            const dropdown = settingsMenu.querySelector('.settings-dropdown');
            dropdown.classList.toggle('show');
            // Đóng dropdown khi click ra ngoài
            function handleClickOutside(event) {
                if (!settingsMenu.contains(event.target)) {
                    dropdown.classList.remove('show');
                    document.removeEventListener('click', handleClickOutside);
                }
            }
            setTimeout(() => {
                document.addEventListener('click', handleClickOutside);
            }, 0);
        }
        </script>

    </body>
</html>
