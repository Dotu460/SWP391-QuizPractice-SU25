<%-- 
    Document   : quiz-handle-menu
    Created on : 14 thg 6, 2025, 00:44:45
    Author     : kenngoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Quiz Menu</title>
        <meta name="description" content="SkillGro - Quiz Menu">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
            <style>
                .quiz-card {
                    transition: transform 0.2s;
                    cursor: pointer;
                    width: 100%;
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                }
                .quiz-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                }
                .card-body {
                    padding: 20px;
                    display: flex;
                    flex-direction: column;
                    height: 100%;
                }
                .quiz-level {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    padding: 5px 10px;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: bold;
                }
                .level-easy {
                    background-color: #28a745;
                    color: white;
                }
                .level-medium {
                    background-color: #ffc107;
                    color: black;
                }
                .level-hard {
                    background-color: #dc3545;
                    color: white;
                }
                .quiz-info {
                    font-size: 0.9rem;
                    color: #6c757d;
                }
                .quiz-title {
                    font-size: 1.2rem;
                    font-weight: bold;
                    margin-bottom: 10px;
                    min-height: 2.6em;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }
                .quiz-score {
                    background-color: #f8f9fa;
                    border-radius: 8px;
                    padding: 10px;
                    margin-top: 15px;
                    text-align: center;
                }
                .score-value {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: #007bff;
                }
                .score-label {
                    font-size: 0.9rem;
                    color: #6c757d;
                    margin-bottom: 5px;
                }
                .no-score {
                    color: #6c757d;
                    font-style: italic;
                }
                .header-top-wrap{
                    background:#1A1B3D;
                    padding:8px 0;
                    color:#fff;
                    position:relative
                }
                .header-logo{
                    position:relative;
                    z-index:2;
                    display:flex;
                    align-items:center
                }
                .header-logo a{
                    display:block;
                    width:auto;
                    height:100%
                }
                .header-logo img{
                    max-height:50px;
                    width:auto;
                    height:auto;
                    display:block;
                    object-fit:contain;
                    filter:brightness(0) invert(1)
                }
                .header-top{
                    display:flex;
                    align-items:center;
                    justify-content:space-between;
                    min-height:60px
                }
                .header-right{
                    display:flex;
                    align-items:center;
                    gap:15px
                }
                .user-menu,.settings-menu{
                    position:relative
                }
                .user-icon,.settings-icon{
                    width:40px;
                    height:40px;
                    border-radius:50%;
                    background:#5751E1;
                    display:flex;
                    align-items:center;
                    justify-content:center;
                    cursor:pointer;
                    transition:all .3s ease
                }
                .user-icon i,.settings-icon i{
                    color:#fff;
                    font-size:18px
                }
                .user-icon:hover,.settings-icon:hover{
                    background:#7A6DC0;
                    transform:translateY(-1px)
                }
                .dropdown-menu,.settings-dropdown{
                    position:absolute;
                    top:120%;
                    right:0;
                    width:280px;
                    background:#fff;
                    border-radius:8px;
                    box-shadow:0 5px 15px rgba(0,0,0,.15);
                    opacity:0;
                    visibility:hidden;
                    transform:translateY(10px);
                    transition:all .3s ease;
                    z-index:1000
                }
                .settings-dropdown{
                    width:200px
                }
                .dropdown-menu.show,.settings-dropdown.show{
                    opacity:1;
                    visibility:visible;
                    transform:translateY(0)
                }
                .dropdown-header{
                    padding:16px;
                    border-bottom:1px solid #eee
                }
                .user-info{
                    display:flex;
                    align-items:center;
                    gap:12px
                }
                .user-avatar{
                    width:40px;
                    height:40px;
                    border-radius:50%;
                    overflow:hidden
                }
                .user-avatar img{
                    width:100%;
                    height:100%;
                    object-fit:cover
                }
                .user-details{
                    display:flex;
                    flex-direction:column
                }
                .user-name{
                    font-weight:600;
                    color:#1A1B3D;
                    font-size:14px
                }
                .user-email{
                    color:#666;
                    font-size:12px
                }
                .dropdown-body{
                    padding:8px 0
                }
                .dropdown-item{
                    display:flex;
                    align-items:center;
                    padding:10px 16px;
                    color:#1A1B3D;
                    text-decoration:none;
                    transition:background-color .3s ease
                }
                .dropdown-item:hover{
                    background-color:#f8f9fa
                }
                .dropdown-item i{
                    width:20px;
                    margin-right:12px;
                    font-size:16px
                }
                .dropdown-item span{
                    font-size:14px
                }
                .text-danger{
                    color:#dc3545!important
                }
                .dropdown-divider{
                    height:1px;
                    background-color:#eee;
                    margin:8px 0
                }

                /* Simple quiz status styles */
                .quiz-status {
                    display: inline-block;
                    margin-top: 5px;
                    font-size: 0.9rem;
                }

                .status-graded {
                    color: #28a745;
                }

                .status-in-process {
                    color: #ffc107;
                }

                /* Styles for waiting for grading message */
                .waiting-for-grading-note {
                    font-size: 0.85rem;
                    padding: 5px 0;
                }

                .waiting-for-grading-note small {
                    display: block;
                    text-align: center;
                }

                /* Style for disabled review button */
                .disabled-review-btn {
                    background-color: #e9ecef;
                    border-color: #ced4da;
                    color: #6c757d;
                    cursor: not-allowed;
                    opacity: 0.65;
                    position: relative;
                }

                /* Style for disabled retake button */
                .disabled-retake-btn {
                    background-color: #e9ecef;
                    border-color: #ced4da;
                    color: #6c757d;
                    cursor: not-allowed;
                    opacity: 0.65;
                    position: relative;
                }

                /* Add custom tooltip styling */
                .disabled-retake-btn:hover::after {
                    content: attr(title);
                    position: absolute;
                    bottom: 100%;
                    left: 50%;
                    transform: translateX(-50%);
                    background-color: rgba(0, 0, 0, 0.8);
                    color: white;
                    padding: 5px 10px;
                    border-radius: 4px;
                    font-size: 12px;
                    white-space: nowrap;
                    z-index: 10;
                    margin-bottom: 5px;
                }

                /* Add arrow to tooltip */
                .disabled-retake-btn:hover::before {
                    content: "";
                    position: absolute;
                    bottom: 100%;
                    left: 50%;
                    transform: translateX(-50%);
                    border-width: 5px;
                    border-style: solid;
                    border-color: rgba(0, 0, 0, 0.8) transparent transparent transparent;
                    margin-bottom: -5px;
                    transform: translateX(-50%) rotate(180deg);
                }
                .selected-package-banner {
                    background: #fff;
                    color: #5751e1;
                    padding: 20px 38px;
                    border-radius: 12px;
                    font-size: 1.35rem;
                    font-weight: 700;
                    margin-bottom: 32px;
                    display: flex;
                    align-items: center;
                    gap: 18px;
                    border: 2.5px solid #8B7FD2;
                    box-shadow: 0 4px 16px rgba(87,81,225,0.10);
                    letter-spacing: 0.3px;
                }
                .selected-package-banner i {
                    font-size: 2rem;
                    margin-right: 12px;
                    color: #8B7FD2;
                }
                .selected-package-banner b {
                    color: #3d38a1;
                    font-weight: 800;
                    letter-spacing: 0.7px;
                }
                .dashboard__area.section-pb-120 {
                    padding-top: 18px !important;
                    padding-bottom: 24px !important;
                }
                .subject-title {
                    font-size: 1.3rem;
                    font-weight: 700;
                    color: #5751e1;
                    margin-bottom: 18px;
                    margin-top: 28px;
                    letter-spacing: 0.5px;
                    padding: 10px 18px 10px 32px;
                    background: #f6f7fb;
                    border-left: 6px solid #8B7FD2;
                    border-radius: 6px 12px 12px 6px;
                    position: relative;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    box-shadow: 0 2px 8px rgba(87,81,225,0.04);
                }
                .subject-title:before {
                    content: '\f02d'; /* fa-book-open icon */
                    font-family: 'Font Awesome 5 Free';
                    font-weight: 900;
                    color: #8B7FD2;
                    font-size: 1.2em;
                    margin-right: 10px;
                    display: inline-block;
                }
                .accordion-item {
                    border-radius: 10px;
                    overflow: hidden;
                    border: 1.5px solid #e0e0e0;
                    margin-bottom: 18px;
                    background: #fff;
                }
                /* Search box styling */
                #quizSearchInput {
                    border: 2px solid #8B7FD2;
                    border-radius: 8px;
                    font-size: 1.08rem;
                    padding: 10px 18px;
                    color: #3d38a1;
                    background: #f6f7fb;
                    transition: border-color 0.2s;
                    box-shadow: 0 2px 8px rgba(87,81,225,0.04);
                }
                #quizSearchInput:focus {
                    border-color: #5751e1;
                    outline: none;
                    background: #fff;
                }
                /* Accordion subject styling */
                .accordion-item {
                    border-radius: 12px;
                    overflow: hidden;
                    border: 2px solid #e0e0e0;
                    margin-bottom: 22px;
                    background: #fff;
                    box-shadow: 0 2px 8px rgba(87,81,225,0.04);
                }
                .accordion-button {
                    font-size: 1.18rem;
                    font-weight: 700;
                    color: #5751e1;
                    background: #f6f7fb;
                    border: none;
                    padding: 18px 28px;
                    letter-spacing: 0.2px;
                    transition: background 0.2s, color 0.2s;
                }
                .accordion-button:not(.collapsed) {
                    background: linear-gradient(90deg, #8B7FD2 0%, #5751e1 100%);
                    color: #fff;
                    box-shadow: 0 4px 16px rgba(87,81,225,0.10);
                }
                .accordion-button:focus {
                    box-shadow: 0 0 0 2px #8B7FD2;
                }
                .accordion-button i {
                    color: #8B7FD2;
                    font-size: 1.3em;
                    margin-right: 10px;
                    transition: color 0.2s;
                }
                .accordion-button:not(.collapsed) i {
                    color: #ffd700;
                }
                /* Subject title inside accordion */
                .subject-title {
                    font-size: 1.18rem;
                    font-weight: 800;
                    color: #3d38a1;
                    margin-bottom: 0;
                    margin-top: 0;
                    letter-spacing: 0.7px;
                    display: inline-block;
                    background: transparent;
                    border: none;
                    padding: 0;
                }
                #searchMode option {
                    white-space: normal;
                }
                .badge.level-easy {
                    background: #e6f9e6;
                    color: #28a745;
                    border: 1.5px solid #28a745;
                }
                .badge.level-medium {
                    background: #fffbe6;
                    color: #ffc107;
                    border: 1.5px solid #ffc107;
                }
                .badge.level-hard {
                    background: #ffe6e6;
                    color: #dc3545;
                    border: 1.5px solid #dc3545;
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
                <section class="dashboard__area section-pb-120">
                    <div class="container-fluid">
                        <div class="dashboard__inner-wrap">
                            <div class="row">
                            <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>

                                <div class="col-xl-9">
                                    <div class="dashboard__content-area">
                                    <c:if test="${not empty packageName}">
                                        <div class="selected-package-banner">
                                            <i class="fas fa-gift"></i>
                                            <span>Package: <b>${packageName}</b></span>
                                        </div>
                                    </c:if>
                                    <div class="dashboard__content-title mb-4">
                                        <h4 class="title">Available Quizzes</h4>
                                    </div>
                                    <!-- Search and Filter -->
                                    <div class="mb-4 d-flex align-items-center gap-3">
                                        <select id="searchMode" class="form-select" style="min-width: 100px; max-width: 145px; font-size: 0.98rem;">
                                            <option value="quiz" title="Quiz name">Quiz name</option>
                                            <option value="subject" title="Subject name">Subject name</option>
                                        </select>
                                        <input id="quizSearchInput" type="text" class="form-control" style="max-width: 350px;" placeholder="Search..." oninput="filterQuizzesByName()">
                                        <select id="levelSort" class="form-select" style="min-width: 100px; max-width: 145px; font-size: 0.98rem;" onchange="sortQuizzesByLevel()">
                                            <option value="all">All Levels</option>
                                            <option value="easy">Easy</option>
                                            <option value="medium">Medium</option>
                                            <option value="hard">Hard</option>
                                        </select>
                                    </div>
                                    <script>
                                        function sortQuizzesByLevel() {
                                            const level = document.getElementById('levelSort').value;
                                            const subjectSections = document.querySelectorAll('.subject-section');
                                            subjectSections.forEach(section => {
                                                const quizCards = section.querySelectorAll('.quiz-card-wrapper');
                                                let visibleCount = 0;
                                                quizCards.forEach((card, idx) => {
                                                    const quizLevel = card.querySelector('.quiz-level').textContent.trim().toLowerCase();
                                                    if (level === 'all' || quizLevel === level) {
                                                        card.style.display = (visibleCount < 3 || card.classList.contains('show-all')) ? 'block' : 'none';
                                                        visibleCount++;
                                                    } else {
                                                        card.style.display = 'none';
                                                    }
                                                });
                                                // Hide/show Show more button
                                                const showMoreBtn = section.querySelector('.show-more-btn');
                                                if (showMoreBtn) {
                                                    showMoreBtn.style.display = (visibleCount > 3) ? '' : 'none';
                                                    showMoreBtn.textContent = 'Show more';
                                                    showMoreBtn.setAttribute('data-showing', 'less');
                                                }
                                                // Hide subject section if no quiz visible
                                                section.style.display = visibleCount > 0 ? '' : 'none';
                                            });
                                        }
                                    </script>

                                    <!-- Quiz List as Accordion -->
                                    <div class="accordion" id="subjectAccordion">
                                        <c:forEach var="subjectId" items="${quizzesBySubject.keySet()}" varStatus="status">
                                            <div class="accordion-item mb-3 subject-section" data-subject-id="${subjectId}" data-subject-title="${fn:toLowerCase(subjectTitles[subjectId])}">
                                                <h2 class="accordion-header" id="heading${subjectId}">
                                                    <button class="accordion-button${status.first ? '' : ' collapsed'}"
                                                            type="button"
                                                            data-bs-toggle="collapse"
                                                            data-bs-target="#collapse${subjectId}"
                                                            aria-expanded="${status.first ? 'true' : 'false'}"
                                                            aria-controls="collapse${subjectId}">
                                                        <i class="fas fa-book-open me-2"></i> ${subjectTitles[subjectId]}
                                                    </button>
                                                </h2>
                                                <div id="collapse${subjectId}" class="accordion-collapse collapse${status.first ? ' show' : ''}"
                                                     aria-labelledby="heading${subjectId}">
                                                    <div class="accordion-body">
                                                        <!-- Progress status for subject -->
                                                        <c:set var="totalQuiz" value="${fn:length(quizzesBySubject[subjectId])}" />
                                                        <c:set var="doneQuiz" value="0" />
                                                        <c:forEach var="quiz" items="${quizzesBySubject[subjectId]}">
                                                            <c:if test="${not empty quizScores[quiz.id]}">
                                                                <c:set var="doneQuiz" value="${doneQuiz + 1}" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <div class="mb-2" style="font-size: 1.01rem; color: #5751e1; font-weight: 500;">
                                                            <i class="fas fa-check-circle me-1"></i> Completed <b>${doneQuiz}</b>/<b>${totalQuiz}</b> quiz
                                                        </div>
                                                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 quiz-list" data-subject-id="${subjectId}">
                                                            <c:forEach var="quiz" items="${quizzesBySubject[subjectId]}" varStatus="quizStatus">
                                                                <c:set var="displayClass" value="${quizStatus.index < 3 ? '' : 'd-none'}" />
                                                                <div class="col quiz-card-wrapper ${displayClass}" data-quiz-name="${fn:toLowerCase(quiz.name)}">
                                                                    <div class="card h-100 quiz-card">
                                                                        <div class="card-body">
                                                                            <span class="quiz-level level-${quiz.level.toLowerCase()}">${quiz.level}</span>
                                                                            <!-- Lesson badge -->
                                                                            <span class="badge lesson-badge mb-2" 
                                                                                  style="font-size:0.98em; font-weight:600; background:linear-gradient(90deg,#e9e6fa,#cfc6f7);color:#4b2991; border:1.5px solid #8B7FD2; padding:6px 14px; display:inline-flex; align-items:center; gap:6px; cursor:pointer;"
                                                                                  title="Lesson: ${lessonTitles[quiz.lesson_id]} - thuộc subject: ${subjectTitles[lessonToSubject[quiz.lesson_id]]}">
                                                                                <i class="fas fa-book-open me-1" style="color:#8B7FD2;"></i> ${lessonTitles[quiz.lesson_id]}
                                                                            </span>
                                                                            <h5 class="quiz-title">${quiz.name}</h5>
                                                                            <div class="quiz-info flex-grow-1">
                                                                                <p><i class="fas fa-question-circle"></i> Questions: ${questionCounts[quiz.id]}</p>
                                                                                <p><i class="fas fa-signal"></i> Level: 
                                                                                  <c:choose>
                                                                                    <c:when test="${quiz.level eq 'Easy'}">
                                                                                      <span class="badge level-easy" style="font-size:1em;">Easy</span>
                                                                                    </c:when>
                                                                                    <c:when test="${quiz.level eq 'Medium'}">
                                                                                      <span class="badge level-medium" style="font-size:1em;">Medium</span>
                                                                                    </c:when>
                                                                                    <c:when test="${quiz.level eq 'Hard'}">
                                                                                      <span class="badge level-hard" style="font-size:1em;">Hard</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                      <span class="badge bg-secondary" style="font-size:1em;">${quiz.level}</span>
                                                                                    </c:otherwise>
                                                                                  </c:choose>
                                                                                </p>
                                                                                <c:if test="${not empty quizScores[quiz.id] && quizHasEssay[quiz.id]}">
                                                                                    <c:choose>
                                                                                        <c:when test="${quizAttemptStatus[quiz.id] eq 'completed'}">
                                                                                            <p><i class="fas fa-check-circle"></i> Status: <span class="status-graded">Graded</span></p>
                                                                                        </c:when>
                                                                                        <c:when test="${quizAttemptStatus[quiz.id] eq 'partially_graded'}">
                                                                                            <p><i class="fas fa-hourglass-half"></i> Status: <span class="status-in-process">In process</span></p>
                                                                                        </c:when>
                                                                                    </c:choose>
                                                                                </c:if>
                                                                            </div>
                                                                            <div class="quiz-score">
                                                                                <div class="score-label">Your Score</div>
                                                                                <c:choose>
                                                                                    <c:when test="${not empty quizScores[quiz.id]}">
                                                                                        <div class="score-value">${quizScores[quiz.id]}%</div>
                                                                                        <c:if test="${quizAttemptStatus[quiz.id] eq 'partially_graded'}">
                                                                                            <div class="waiting-for-grading-note mt-2">
                                                                                                <small class="text-warning">
                                                                                                    <i class="fas fa-info-circle"></i> 
                                                                                                    This is a temporary score. Waiting for the essay score...
                                                                                                </small>
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <div class="no-score">Not attempted yet</div>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                            <div class="mt-3" style="margin-top:auto !important;">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty quizScores[quiz.id]}">
                                                                                        <div class="d-flex gap-2">
                                                                                            <c:choose>
                                                                                                <c:when test="${quizAttemptStatus[quiz.id] eq 'partially_graded'}">
                                                                                                    <button class="btn btn-primary flex-grow-1 disabled-retake-btn" 
                                                                                                            disabled 
                                                                                                            title="Available when expert graded the essay quiz">
                                                                                                        Retake Quiz
                                                                                                    </button>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <button class="btn btn-primary flex-grow-1" onclick="startQuiz('${quiz.id}', true)">Retake Quiz</button>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                            <button class="btn btn-secondary flex-grow-1" onclick="reviewQuiz('${quiz.id}')">Review Quiz</button>
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <button class="btn btn-primary w-100" onclick="startQuiz('${quiz.id}', false)">Start Quiz</button>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                        <c:if test="${fn:length(quizzesBySubject[subjectId]) > 3}">
                                                            <div class="d-flex justify-content-center mt-3">
                                                                <button class="btn btn-outline-primary btn-sm show-more-btn" data-subject-id="${subjectId}" onclick="toggleShowMore(this, '${fn:length(quizzesBySubject[subjectId])}')">Show more</button>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- main-area-end -->  

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
            <script>
                function startQuiz(quizId, isRetake) {
                    const urlParams = new URLSearchParams(window.location.search);
                    const packageId = urlParams.get('packageId');
                    let url = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId;
                    if (packageId) url += '&packageId=' + packageId;
                    if (isRetake) url += '&retake=true&t=' + new Date().getTime();
                    window.location.href = url;
                }

                function reviewQuiz(quizId) {
                    console.log("Reviewing quiz with ID:", quizId);
                    window.location.href = '${pageContext.request.contextPath}/quiz-review?quizId=' + quizId;
                }

                $(document).ready(function () {
                    if ($.fn.select2) {
                        $('.select2').select2();
                    }
                });

                function toggleDropdown() {
                    const dropdown = document.querySelector('.user-menu .dropdown-menu');
                    dropdown.classList.toggle('show');
                }

                function toggleSettingsDropdown() {
                    const dropdown = document.querySelector('.settings-menu .settings-dropdown');
                    dropdown.classList.toggle('show');
                }

                document.addEventListener('click', function (event) {
                    if (!event.target.closest('.user-menu')) {
                        document.querySelector('.user-menu .dropdown-menu').classList.remove('show');
                    }
                    if (!event.target.closest('.settings-menu')) {
                        document.querySelector('.settings-menu .settings-dropdown').classList.remove('show');
                    }
                });
        </script>

        <script>
            //hiển thị điểm vừa đạt
            document.addEventListener('DOMContentLoaded', function () {
                const score = sessionStorage.getItem('quizScore');
                if (score) {
                    // Using iziToast for consistency
                    iziToast.success({
                        title: 'Quiz Completed!',
                        message: 'Your score: ' + score,
                        position: 'topRight',
                        timeout: 7000
                    });
                    sessionStorage.removeItem('quizScore');
                }
            });
        </script>

        <script>
            // SEARCH/FILTER
            function filterQuizzesByName() {
                const search = document.getElementById('quizSearchInput').value.trim().toLowerCase();
                const mode = document.getElementById('searchMode').value;
                const subjectSections = document.querySelectorAll('.subject-section');
                subjectSections.forEach(section => {
                    const subjectId = section.getAttribute('data-subject-id');
                    const subjectTitle = section.getAttribute('data-subject-title') || '';
                    const quizCards = section.querySelectorAll('.quiz-card-wrapper');
                    let anyVisible = false;
                    let visibleCount = 0;

                    if (mode === 'quiz') {
                        quizCards.forEach((card, idx) => {
                            const quizName = card.getAttribute('data-quiz-name');
                            if (quizName.includes(search)) {
                                if (visibleCount < 3 || card.classList.contains('show-all')) {
                                    card.style.display = 'block';
                                } else {
                                    card.style.display = 'none';
                                }
                                anyVisible = true;
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }
                        });
                        section.style.display = anyVisible ? '' : 'none';
                    } else if (mode === 'subject') {
                        if (subjectTitle.includes(search)) {
                            section.style.display = '';
                            quizCards.forEach((card, idx) => {
                                if (visibleCount < 3 || card.classList.contains('show-all')) {
                                    card.style.display = 'block';
                                } else {
                                    card.style.display = 'none';
                                }
                                visibleCount++;
                            });
                        } else {
                            section.style.display = 'none';
                        }
                    }

                    // Hide/show Show more button
                    const showMoreBtn = section.querySelector('.show-more-btn');
                    if (showMoreBtn) {
                        showMoreBtn.style.display = (visibleCount > 3) ? '' : 'none';
                        showMoreBtn.textContent = 'Show more';
                        showMoreBtn.setAttribute('data-showing', 'less');
                    }
                });
            }

            // SHOW MORE/LESS
            function toggleShowMore(btn, total) {
                const subjectId = btn.getAttribute('data-subject-id');
                const section = document.querySelector('.subject-section[data-subject-id="' + subjectId + '"]');
                const quizCards = section.querySelectorAll('.quiz-card-wrapper');
                const isShowingMore = btn.getAttribute('data-showing') === 'more';
                if (!isShowingMore) {
                    // Show all
                    quizCards.forEach(card => card.style.display = 'block');
                    btn.textContent = 'Show less';
                    btn.setAttribute('data-showing', 'more');
                } else {
                    // Show only first 3
                    quizCards.forEach((card, idx) => {
                        card.style.display = idx < 3 ? 'block' : 'none';
                    });
                    btn.textContent = 'Show more';
                    btn.setAttribute('data-showing', 'less');
                }
            }
        </script>
    </body>
</html>
