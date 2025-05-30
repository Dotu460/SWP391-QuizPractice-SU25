<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Practice Details - Quiz Practice</title>
    <meta name="description" content="Practice Details Page">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    
    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    <style>
        .practice-details {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 40px auto;
        }
        .practice-details h2 {
            margin-bottom: 25px;
            color: #333;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        .form-group select, .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .practice-btn {
            background: var(--tg-theme-primary);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background 0.3s;
        }
        .practice-btn:hover {
            background: var(--tg-theme-secondary);
        }
        
        /* Thêm style cho phần hiển thị chi tiết */
        .practice-info {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .info-row {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        .info-label {
            font-weight: 600;
            color: #666;
            width: 150px;
            flex-shrink: 0;
        }
        .info-value {
            color: #333;
            flex-grow: 1;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-draft { background-color: #e3e3e3; color: #666; }
        .status-active { background-color: #e3f2fd; color: #1976d2; }
        .status-completed { background-color: #e8f5e9; color: #2e7d32; }
    </style>
</head>

<body>
    <!-- header-area -->
    <jsp:include page="../../common/user/header.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area">
            <div class="container">
                <div class="practice-details">
                    <h2>Practice Details</h2>
                    <form action="practice" method="post">
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <select id="subject" name="subject" required>
                                <option value="">Select subject</option>
                                <c:forEach var="subject" items="${availableSubjects}">
                                    <option value="${subject.id}" ${not empty practice && practice.subject_id == subject.id ? 'selected' : ''}>${subject.title}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="numberOfQuestions">Number of practicing questions</label>
                            <input type="number" id="numberOfQuestions" name="numberOfQuestions" 
                                   value="${not empty practice ? practice.number_of_questions : 20}" min="1" max="100" required>
                        </div>

                        <div class="form-group">
                            <label for="questionSelectionType">Questions are selected by topic(s) or a specific dimension?</label>
                            <select id="questionSelectionType" name="questionSelectionType" required>
                                <option value="by_topic" ${practice.question_selection_type == 'by_topic' ? 'selected' : ''}>By subject topic</option>
                                <option value="by_dimension" ${practice.question_selection_type == 'by_dimension' ? 'selected' : ''}>By dimension</option>
                                <option value="random" ${practice.question_selection_type == 'Random' ? 'selected' : ''}>Random</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="questionGroup">Question group (choose one or all topic/dimension(s))</label>
                            <select id="questionGroup" name="questionGroup">
                                <option value="all">All</option>
                            </select>
                        </div>

                        <button type="submit" class="practice-btn">Practice</button>
                    </form>
                </div>
            </div>
        </section>
    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/js/"></jsp:include>
    
    <script>
        // Add dynamic behavior for question group selection based on selection type
        document.getElementById('questionSelectionType').addEventListener('change', function() {
            const questionGroup = document.getElementById('questionGroup');
            // Here you would typically make an AJAX call to get the appropriate options
            // based on whether topics or dimensions were selected
            questionGroup.innerHTML = '<option value="all">All</option>';
        });
    </script>
</body>
</html> 