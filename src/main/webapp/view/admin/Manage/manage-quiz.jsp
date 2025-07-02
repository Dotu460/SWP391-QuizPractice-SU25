<%-- 
    Document   : manage-quiz
    Created on : 13 thg 6, 2025, 23:36:52
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quiz Management</title>
    <meta name="description" content="SkillGro - Quiz Management">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    
    <!-- TinyMCE CDN -->
            <script src="https://cdn.tiny.cloud/1/5ynsnptn3yryfyduzpqdheibiiqvgbz5oe6ypn6t4vnl1154/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px 15px;
            width: 100%;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: linear-gradient(145deg, #ffffff, #f3f3f3);
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            color: #2c3e50;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 3px 3px 6px #e8e8e8, -3px -3px 6px #ffffff;
        }
        
        .back-button:hover {
            transform: translateX(-5px);
            box-shadow: 5px 5px 10px #e8e8e8, -5px -5px 10px #ffffff;
            color: #1976d2;
        }
        
        .back-button i {
            transition: transform 0.3s ease;
        }
        
        .back-button:hover i {
            transform: translateX(-4px);
        }
        
        .questions-list {
            margin-top: 20px;
        }
        
        .question-item {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .question-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-title {
            font-weight: 500;
            color: #2c3e50;
            margin: 0;
        }
        
        .question-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .btn-delete {
            background-color: #ffebee;
            color: #d32f2f;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .btn-edit:hover {
            background-color: #1976d2;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #d32f2f;
            color: white;
        }
        
        .floating-action-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: linear-gradient(45deg, #1976d2, #2196f3);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
            z-index: 1000;
            text-decoration: none;
        }
        
        .floating-action-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
            color: white;
        }
        
        .floating-action-btn i {
            font-size: 24px;
        }
        
        .answer-option {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            padding: 15px;
            background: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .answer-option.removing {
            transform: translateX(100%);
            opacity: 0;
        }
        
        .answer-option:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-color: #2196f3;
        }
        
        .answer-option:before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: #2196f3;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .answer-option:hover:before {
            opacity: 1;
        }
        
        .answer-option input[type="checkbox"] {
            width: 22px;
            height: 22px;
            margin: 0;
            cursor: pointer;
            position: relative;
            border: 2px solid #2196f3;
            border-radius: 4px;
            appearance: none;
            -webkit-appearance: none;
            transition: all 0.3s ease;
        }
        
        .answer-option input[type="checkbox"]:checked {
            background-color: #2196f3;
            border-color: #2196f3;
        }
        
        .answer-option input[type="checkbox"]:checked:after {
            content: '✓';
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 14px;
            font-weight: bold;
        }
        
        .answer-option .form-control {
            flex: 1;
            border: none;
            border-bottom: 2px solid #e0e0e0;
            border-radius: 0;
            padding: 10px 5px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: transparent;
        }
        
        .answer-option .form-control:focus {
            outline: none;
            border-color: #2196f3;
            box-shadow: none;
        }
        
        .answer-option .form-control::placeholder {
            color: #9e9e9e;
            font-style: italic;
        }
        
        .answer-option .btn-remove-option {
            background: none;
            border: none;
            color: #ff5252;
            width: 35px;
            height: 35px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0.7;
        }
        
        .answer-option .btn-remove-option:hover {
            background-color: #ffebee;
            color: #d32f2f;
            opacity: 1;
            transform: rotate(90deg);
        }
        
        .answer-option .btn-remove-option i {
            font-size: 18px;
        }
        
        .btn-add-option {
            margin-top: 15px;
            padding: 10px 20px;
            background: linear-gradient(45deg, #2196f3, #1976d2);
            border: none;
            border-radius: 25px;
            color: white;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .btn-add-option:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
            background: linear-gradient(45deg, #1976d2, #1565c0);
        }
        
        .btn-add-option i {
            font-size: 18px;
        }
        
        .answers-container {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-top: 10px;
        }
        
        .answers-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .answers-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
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

    <!-- main-area -->
    <main class="main-area">
        <section class="course-details-area pt-120 pb-100">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12 col-lg-12">
                        <div class="form-container">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="mb-0">Quiz Management: ${quiz.name}</h4>
                                <a href="${pageContext.request.contextPath}/manage-subjects/view?id=${subject.id}" class="back-button">
                                    <i class="fa fa-arrow-left"></i> Back to Subject Content
                                </a>
                            </div>
                            
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" style="margin-bottom: 20px;">${errorMessage}</div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/manage-subjects/update-quiz" method="post" id="quizForm" enctype="multipart/form-data">
                                <input type="hidden" name="quizId" value="${quiz.id}">
                                <input type="hidden" name="lessonId" value="${quiz.lesson_id}">
                                
                                <div class="form-section">
                                    <div class="form-section-title">Quiz Information</div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Quiz Name</label>
                                        <input type="text" class="form-control" name="name" value="${quiz.name}" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Level</label>
                                        <select class="form-control" name="level" required>
                                            <option value="easy" ${quiz.level == 'easy' ? 'selected' : ''}>Easy</option>
                                            <option value="medium" ${quiz.level == 'medium' ? 'selected' : ''}>Medium</option>
                                            <option value="hard" ${quiz.level == 'hard' ? 'selected' : ''}>Hard</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Duration (minutes)</label>
                                        <input type="number" class="form-control" name="duration_minutes" value="${quiz.duration_minutes != null ? quiz.duration_minutes : 30}" required min="1">
                                    </div>


                                    
                                    <div class="form-group">
                                        <label class="form-label">Status</label>
                                        <select class="form-control" name="status" required>
                                            <option value="active" ${quiz.status == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="hidden" ${quiz.status == 'hidden' ? 'selected' : ''}>Hidden</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <div class="form-section-title">Questions</div>
                                    <div class="questions-list">
                                        <c:forEach var="question" items="${questions}" varStatus="status">
                                            <div class="question-item" data-question-id="${question.id}">
                                                <div class="question-header">
                                                    <h5 class="question-title">Question ${status.index + 1}</h5>
                                                    <div class="question-actions">
                                                        <button type="button" class="btn-action btn-delete" onclick="deleteQuestion('${question.id}')">
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                
                                                <div class="form-group">
                                                    <label class="form-label">Question Content</label>
                                                    <input type="text" class="form-control" name="questions[${status.index}].content" 
                                                           value="${question.content}" required>
                                                    <input type="hidden" name="questions[${status.index}].id" value="${question.id}">
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">Media (Images/Video)</label>
                                                    <textarea id="media_url_${status.index}" name="questions[${status.index}].media_url" 
                                                              class="form-control media-editor"><c:out value="${question.media_url}" escapeXml="false"/></textarea>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">Question Type</label>
                                                    <select class="form-control" name="questions[${status.index}].type" required>
                                                        <option value="multiple" ${question.type == 'multiple' ? 'selected' : ''}>Multiple Choice</option>
                                                        <option value="essay" ${question.type == 'essay' ? 'selected' : ''}>Essay</option>
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">Question Level</label>
                                                    <select class="form-control" name="questions[${status.index}].level" required>
                                                        <option value="easy" ${question.level == 'easy' ? 'selected' : ''}>Easy</option>
                                                        <option value="medium" ${question.level == 'medium' ? 'selected' : ''}>Medium</option>
                                                        <option value="hard" ${question.level == 'hard' ? 'selected' : ''}>Hard</option>
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">Answer Type</label>
                                                    <c:set var="hasAnswerText" value="false" />
                                                    <c:forEach var="option" items="${question.questionOptions}">
                                                        <c:if test="${not empty option.answer_text}">
                                                            <c:set var="hasAnswerText" value="true" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <select class="form-control answer-type-select" name="questions[${status.index}].answer_type" required onchange="toggleAnswerType('${status.index}')">
                                                        <option value="option_text" <c:if test="${hasAnswerText eq false}">selected</c:if>>Option Text</option>
                                                        <option value="answer_text" <c:if test="${hasAnswerText eq true}">selected</c:if>>Answer Text</option>
                                                    </select>
                                                    <small class="form-text">Option Text: Simple text answers | Answer Text: Rich text answers with formatting</small>
                                                </div>

                                                <div class="form-group">
                                                    <div class="answers-container">
                                                        <div class="answers-header">
                                                            <h6 class="answers-title">Answer Options</h6>
                                                        </div>
                                                        <div class="options-list" data-question="${status.index}">
                                                            <small class="form-text">Tick multiple checkboxes to select multiple correct answers</small>
                                                            <c:forEach var="option" items="${question.questionOptions}" varStatus="optionStatus">
                                                                <div class="answer-option">
                                                                    <input type="checkbox" name="questions[${status.index}].correctAnswers" 
                                                                           value="${optionStatus.index}" ${option.correct_key ? 'checked' : ''}>
                                                                    <input type="hidden" name="questions[${status.index}].options[${optionStatus.index}].id" 
                                                                           value="${option.id}">
                                                                    <c:choose>
                                                                        <c:when test="${not empty option.answer_text}">
                                                                            <input type="text" class="form-control" 
                                                                                   name="questions[${status.index}].options[${optionStatus.index}].answer_text" 
                                                                                   value="${option.answer_text}" 
                                                                                   required>
                                                                            <input type="hidden" name="questions[${status.index}].options[${optionStatus.index}].option_text" value="">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <input type="text" class="form-control" 
                                                                                   name="questions[${status.index}].options[${optionStatus.index}].option_text" 
                                                                                   value="${option.option_text}" 
                                                                                   required>
                                                                            <input type="hidden" name="questions[${status.index}].options[${optionStatus.index}].answer_text" value="">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <button type="button" class="btn-remove-option" 
                                                                            onclick="removeOption('${status.index}', '${optionStatus.index}', '${option.id}')">
                                                                        <i class="fas fa-times"></i>
                                                                    </button>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                        <button type="button" class="btn btn-primary mt-2 add-option-btn" data-question="${status.index}">
                                                            <i class="fas fa-plus"></i> Add Answer Option
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">Explanation</label>
                                                    <textarea class="form-control" name="questions[${status.index}].explanation" 
                                                              rows="3">${question.explanation}</textarea>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <button type="button" class="btn btn-primary mt-3" onclick="addQuestion()">
                                        <i class="fas fa-plus"></i> Add New Question
                                    </button>
                                </div>
                                
                                <div class="form-actions">
                                    <button type="button" class="btn btn-outline-secondary" onclick="history.back()">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Quiz</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Add Question Floating Button -->
    <a href="${pageContext.request.contextPath}/questions-list/add?quizId=${quiz.id}" class="floating-action-btn">
        <i class="fa fa-plus"></i>
    </a>

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize TinyMCE for all media editors
            $('.media-editor').each(function() {
                var editorId = '#' + $(this).attr('id');
                initTinyMCE(editorId);
                fixOldMediaUrls(editorId);
            });

            // Use event delegation for add option buttons to avoid conflicts
            $(document).on('click', '.add-option-btn', function() {
                const questionIndex = $(this).data('question');
                addOption(questionIndex);
            });

            // Use event delegation for remove option buttons
            $(document).on('click', '.btn-remove-option', function() {
                const optionElement = $(this).closest('.answer-option');
                const optionsContainer = optionElement.closest('.options-list');
                const questionIndex = optionsContainer.data('question');
                const optionIndex = optionsContainer.find('.answer-option').index(optionElement);
                const optionId = optionElement.find('input[name*="].id"]').val();
                
                removeOption(questionIndex, optionIndex, optionId || null);
            });

            // Form validation and submit
            $('#quizForm').submit(function(e) {
                e.preventDefault();
                
                // Save all TinyMCE content before submit
                tinymce.triggerSave();
                
                // Force save content for all TinyMCE instances
                tinymce.get().forEach(function(editor) {
                    editor.save();
                });
                
                if (!validateForm()) {
                    return false;
                }

                // Submit form normally instead of using AJAX
                this.submit();
            });
        });

        function fixOldMediaUrls(selector) {
            setTimeout(function() {
                if (selector) {
                    var editor = tinymce.get(selector.replace('#', ''));
                    if (editor) {
                        var content = editor.getContent();
                        // Fix image URLs that start with uploads/media but don't have the prefix
                        content = content.replace(/src="uploads\/media\//g, 'src="/SWP391_QUIZ_PRACTICE_SU25/uploads/media/');
                        // Fix video source URLs
                        content = content.replace(/<source[^>]+src="uploads\/media\/([^"]+)"/g, '<source src="/SWP391_QUIZ_PRACTICE_SU25/uploads/media/$1"');
                        editor.setContent(content);
                    }
                }
            }, 1000);
        }
        
        function normalizeUploadUrl(url) {
            if (!url) return url;
            
            // Remove any leading relative paths and normalize
            url = url.replace(/^\.\.\//, '').replace(/^\.\//, '');
            
            // Handle different URL formats
            if (url.startsWith('uploads/media/')) {
                return '/SWP391_QUIZ_PRACTICE_SU25/' + url;
            } else if (url.startsWith('/uploads/media/')) {
                return '/SWP391_QUIZ_PRACTICE_SU25' + url;
            } else if (url.startsWith('/SWP391_QUIZ_PRACTICE_SU25/')) {
                return url; // Already has correct prefix
            } else {
                // Default case: add prefix and clean up any leading slashes
                return '/SWP391_QUIZ_PRACTICE_SU25/' + url.replace(/^\/+/, '');
            }
        }
        
        function initTinyMCE(selector) {
            tinymce.init({
                selector: selector,
                plugins: 'image media link code table lists preview paste',
                toolbar: 'undo redo | styles | bold italic | alignleft aligncenter alignright | image media | preview code | removeformat',
                height: 400,
                
                images_upload_url: '/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/upload-media',
                automatic_uploads: true,
                file_picker_types: 'image media',
                
                media_live_embeds: true,
                paste_data_images: true,
                paste_as_text: false,
                paste_enable_default_filters: true,
                paste_word_valid_elements: "b,strong,i,em,h1,h2,h3,p,br,img[src],video,source",
                paste_retain_style_properties: "all",
                extended_valid_elements: 'img[class|src|alt|title|width|height|style],video[*],source[*]',
                content_style: 'img { max-width: 100%; height: auto; } video { max-width: 100%; height: auto; }',
                
                images_upload_handler: function (blobInfo, progress) {
                    return new Promise((resolve, reject) => {
                        if (blobInfo.blob().type.indexOf('image') !== -1) {
                            const formData = new FormData();
                            formData.append('file', blobInfo.blob(), blobInfo.filename());

                            fetch('/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/upload-media', {
                                method: 'POST',
                                body: formData
                            })
                            .then(response => response.json())
                            .then(result => {
                                if (result.location) {
                                    var url = normalizeUploadUrl(result.location);
                                    resolve(url);
                                } else {
                                    reject({ message: result.message || 'Upload failed' });
                                }
                            })
                            .catch(error => {
                                reject({ message: 'HTTP Error: ' + error.message });
                            });
                        } 
                        else if (blobInfo.blob() instanceof String || typeof blobInfo.blob() === 'string') {
                            resolve(blobInfo.blob());
                        }
                    });
                },
                paste_preprocess: function(plugin, args) {
                    var content = args.content;
                    content = content.replace(/<img[^>]+src="([^">]+)"[^>]*>/g, function(match, src) {
                        return '<img src="' + src + '" style="max-width: 100%; height: auto;">';
                    });
                    args.content = content;
                },
                paste_postprocess: function(plugin, args) {
                    args.node.querySelectorAll('img').forEach(function(img) {
                        if (img.src.startsWith('data:')) {
                            // Upload directly instead of using blobCache
                            var base64Data = img.src.split(',')[1];
                            var filename = 'pasted-image-' + (new Date()).getTime() + '.png';
                            
                            // Convert base64 to blob
                            var byteCharacters = atob(base64Data);
                            var byteNumbers = new Array(byteCharacters.length);
                            for (var i = 0; i < byteCharacters.length; i++) {
                                byteNumbers[i] = byteCharacters.charCodeAt(i);
                            }
                            var byteArray = new Uint8Array(byteNumbers);
                            var blob = new Blob([byteArray], {type: 'image/png'});
                            
                            // Upload blob directly
                            var formData = new FormData();
                            formData.append('file', blob, filename);
                            
                            fetch('/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/upload-media', {
                                method: 'POST',
                                body: formData
                            })
                            .then(response => response.json())
                            .then(result => {
                                if (result.location) {
                                    var url = normalizeUploadUrl(result.location);
                                    img.src = url;
                                }
                            })
                            .catch(error => {
                                console.error('Error uploading pasted image:', error);
                            });
                        }
                        img.className = 'img-fluid';
                        img.style.maxWidth = '100%';
                        img.style.height = 'auto';
                    });
                },
                file_picker_callback: function(cb, value, meta) {
                    var input = document.createElement('input');
                    input.setAttribute('type', 'file');
                    
                    if (meta.filetype === 'image') {
                        input.setAttribute('accept', 'image/*');
                    } else if (meta.filetype === 'media') {
                        input.setAttribute('accept', 'video/*');
                    }

                    input.onchange = function() {
                        var file = this.files[0];
                        var formData = new FormData();
                        formData.append('file', file);

                        fetch('/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/upload-media', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(result => {
                            if (result.location) {
                                var url = normalizeUploadUrl(result.location);
                                
                                if (meta.filetype === 'image') {
                                    cb(url, { title: file.name });
                                } else {
                                    var videoHtml = '<video controls width="100%"><source src="' + url + '" type="' + file.type + '"></video>';
                                    tinymce.activeEditor.insertContent(videoHtml);
                                }
                            } else {
                                throw new Error(result.message || 'Upload failed');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Upload failed: ' + error.message);
                        });
                    };

                    input.click();
                },
                                                setup: function(editor) {
                                    editor.on('init', function() {
                                        editor.on('click', function(e) {
                                            var target = e.target;
                                            
                                            var existingButtons = editor.getBody().getElementsByClassName('delete-button');
                                            while(existingButtons[0]) {
                                                existingButtons[0].parentNode.removeChild(existingButtons[0]);
                                            }
                                            
                                            if (target.nodeName === 'IMG' || target.nodeName === 'VIDEO' || target.nodeName === 'P') {
                                                var deleteButton = editor.dom.create('button', {
                                                    'class': 'delete-button',
                                                    'style': 'position: absolute; top: 0; right: 0; background: red; color: white; border: none; padding: 2px 5px; cursor: pointer; z-index: 1000;'
                                                }, 'X');
                                                
                                                deleteButton.onclick = function(e) {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    target.remove();
                                                    deleteButton.remove();
                                                    editor.fire('change');
                                                };
                                                
                                                var wrapper = editor.dom.create('div', {
                                                    'style': 'position: relative; display: inline-block;'
                                                });
                                                target.parentNode.insertBefore(wrapper, target);
                                                wrapper.appendChild(target);
                                                wrapper.appendChild(deleteButton);
                                            }
                                        });
                                    });

                                    // Auto-save content when changed
                                    editor.on('change keyup', function() {
                                        editor.save();
                                    });
                                    
                                    // Save content before form submit
                                    editor.on('BeforeSubmit', function() {
                                        editor.save();
                                    });
                                    

                                }
            });
        }

        function deleteQuestion(questionId) {
            if (confirm('Are you sure you want to delete this question?')) {
                const questionElement = $('[data-question-id="' + questionId + '"]');
                
                $.ajax({
                    url: '/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/delete-question',
                    type: 'POST',
                    data: {
                        questionId: questionId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Remove the question element from DOM immediately
                            questionElement.fadeOut(300, function() {
                                $(this).remove();
                                // Reindex remaining questions
                                $('.question-item').each(function(index) {
                                    $(this).find('.question-title').text('Question ' + (index + 1));
                                });
                            });
                            
                            iziToast.success({
                                title: 'Success',
                                message: 'Question deleted successfully',
                                position: 'topRight'
                            });
                        } else {
                            iziToast.error({
                                title: 'Error',
                                message: response.message || 'Failed to delete question',
                                position: 'topRight'
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Delete question error:', error);
                        iziToast.error({
                            title: 'Error',
                            message: 'Failed to delete question: ' + error,
                            position: 'topRight'
                        });
                    }
                });
            }
        }

        function toggleAnswerType(questionIndex) {
            const answerType = $('select[name="questions[' + questionIndex + '].answer_type"]').val();
            const optionsContainer = $('.options-list[data-question="' + questionIndex + '"]');
            
            optionsContainer.find('.answer-option').each(function(optionIndex) {
                const optionDiv = $(this);
                const textInput = optionDiv.find('input[type="text"]');
                const hiddenInput = optionDiv.find('input[type="hidden"][name*="answer_text"], input[type="hidden"][name*="option_text"]');
                
                if (answerType === 'answer_text') {
                    // Switch to answer_text (rich text)
                    textInput.attr('name', 'questions[' + questionIndex + '].options[' + optionIndex + '].answer_text');
                    textInput.attr('placeholder', 'Enter rich text answer...');
                    hiddenInput.attr('name', 'questions[' + questionIndex + '].options[' + optionIndex + '].option_text');
                } else {
                    // Switch to option_text (simple text)
                    textInput.attr('name', 'questions[' + questionIndex + '].options[' + optionIndex + '].option_text');
                    textInput.attr('placeholder', 'Enter answer option...');
                    hiddenInput.attr('name', 'questions[' + questionIndex + '].options[' + optionIndex + '].answer_text');
                }
            });
        }

        function addOption(questionIndex) {
            const optionsContainer = $('.options-list[data-question="' + questionIndex + '"]');
            
            // Remove the "No answer options" message if it exists
            optionsContainer.find('p.text-muted').remove();
            
            const optionIndex = optionsContainer.children('.answer-option').length;
            const answerType = $('select[name="questions[' + questionIndex + '].answer_type"]').val() || 'option_text';
            
            let textInputName, hiddenInputName, placeholder;
            if (answerType === 'answer_text') {
                textInputName = 'questions[' + questionIndex + '].options[' + optionIndex + '].answer_text';
                hiddenInputName = 'questions[' + questionIndex + '].options[' + optionIndex + '].option_text';
                placeholder = 'Enter rich text answer...';
            } else {
                textInputName = 'questions[' + questionIndex + '].options[' + optionIndex + '].option_text';
                hiddenInputName = 'questions[' + questionIndex + '].options[' + optionIndex + '].answer_text';
                placeholder = 'Enter answer option...';
            }
            
            const newOptionHtml = '<div class="answer-option">' +
                '<input type="checkbox" name="questions[' + questionIndex + '].correctAnswers" value="' + optionIndex + '">' +
                '<input type="hidden" name="questions[' + questionIndex + '].options[' + optionIndex + '].id" value="">' +
                '<input type="text" class="form-control option-input" ' +
                       'name="' + textInputName + '" ' +
                       'placeholder="' + placeholder + '" required>' +
                '<input type="hidden" name="' + hiddenInputName + '" value="">' +
                '<button type="button" class="btn-remove-option" data-question="' + questionIndex + '" data-option="' + optionIndex + '">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
                '</div>';
            
            const newOption = $(newOptionHtml);
            
            optionsContainer.append(newOption);
            
            // Auto-check the first checkbox if it's the first option
            if (optionIndex === 0) {
                newOption.find('input[type="checkbox"]').prop('checked', true);
            }
        }

        function removeOption(questionIndex, optionIndex, optionId) {
            if (optionId && optionId !== 'null') {
                if (confirm('Are you sure you want to delete this answer option?')) {
                    const optionsContainer = $('.options-list[data-question="' + questionIndex + '"]');
                    const optionToRemove = optionsContainer.children('.answer-option').eq(optionIndex);
                    
                    $.ajax({
                        url: '/SWP391_QUIZ_PRACTICE_SU25/manage-subjects/delete-option',
                        type: 'POST',
                        data: { optionId: optionId },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                                            // Remove from UI with animation
                            optionToRemove.fadeOut(300, function() {
                                $(this).remove();
                                reindexOptions(questionIndex);
                                
                                // If no more options, show the "no options" message
                                if (optionsContainer.children('.answer-option').length === 0) {
                                    optionsContainer.append('<p class="text-muted"><em>No answer options yet. Click "Add Answer Option" to create answers for this question.</em></p>');
                                }
                            });
                                
                                iziToast.success({
                                    title: 'Success',
                                    message: 'Answer option deleted successfully',
                                    position: 'topRight'
                                });
                            } else {
                                iziToast.error({
                                    title: 'Error',
                                    message: response.message || 'Failed to delete answer option',
                                    position: 'topRight'
                                });
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error('Delete option error:', error);
                            iziToast.error({
                                title: 'Error',
                                message: 'Failed to delete answer option: ' + error,
                                position: 'topRight'
                            });
                        }
                    });
                }
            } else {
                // For new options that haven't been saved yet
                const optionsContainer = $('.options-list[data-question="' + questionIndex + '"]');
                const optionToRemove = optionsContainer.children('.answer-option').eq(optionIndex);
                optionToRemove.fadeOut(300, function() {
                    $(this).remove();
                    reindexOptions(questionIndex);
                    
                    // If no more options, show the "no options" message
                    if (optionsContainer.children('.answer-option').length === 0) {
                        optionsContainer.append('<p class="text-muted"><em>No answer options yet. Click "Add Answer Option" to create answers for this question.</em></p>');
                    }
                });
            }
        }

        function reindexOptions(questionIndex) {
            const optionsContainer = $('.options-list[data-question="' + questionIndex + '"]');
            const options = optionsContainer.children('.answer-option');
            
            options.each(function(idx) {
                const option = $(this);
                const optionId = option.find('input[name*="].id"]').val();
                
                // Update all form elements
                option.find('input[type="checkbox"]').attr({
                    'value': idx,
                    'name': 'questions[' + questionIndex + '].correctAnswers'
                });
                
                option.find('input[name*="].id"]').attr(
                    'name', 'questions[' + questionIndex + '].options[' + idx + '].id'
                );
                
                // Update text input name - determine if it's option_text or answer_text
                const textInput = option.find('input[type="text"]');
                const currentName = textInput.attr('name');
                let fieldType = 'option_text'; // default
                
                if (currentName && currentName.includes('answer_text')) {
                    fieldType = 'answer_text';
                }
                
                textInput.attr('name', 'questions[' + questionIndex + '].options[' + idx + '].' + fieldType);
            });
        }

        function addQuestion() {
            const questionIndex = $('.question-item').length;
            const questionHtml = '<div class="question-item" id="question-new-' + questionIndex + '">' +
                '<div class="question-header">' +
                    '<h5 class="question-title">Question ' + (questionIndex + 1) + '</h5>' +
                    '<div class="question-actions">' +
                        '<button type="button" class="btn-action btn-delete" onclick="$(this).closest(\'.question-item\').remove()">' +
                            '<i class="fa fa-trash"></i>' +
                        '</button>' +
                    '</div>' +
                '</div>' +
                
                '<div class="form-group">' +
                    '<label class="form-label">Question Content</label>' +
                    '<input type="text" class="form-control" name="questions[' + questionIndex + '].content" required>' +
                    '<input type="hidden" name="questions[' + questionIndex + '].quiz_id" value="${quiz.id}">' +
                '</div>' +

                '<div class="form-group">' +
                    '<label class="form-label">Media (Images/Video)</label>' +
                    '<textarea id="media_url_' + questionIndex + '" name="questions[' + questionIndex + '].media_url" ' +
                              'class="form-control media-editor"></textarea>' +
                '</div>' +

                '<div class="form-group">' +
                    '<label class="form-label">Question Type</label>' +
                    '<select class="form-control" name="questions[' + questionIndex + '].type" required>' +
                        '<option value="multiple">Multiple Choice</option>' +
                        '<option value="essay">Essay</option>' +
                    '</select>' +
                '</div>' +

                '<div class="form-group">' +
                    '<label class="form-label">Question Level</label>' +
                    '<select class="form-control" name="questions[' + questionIndex + '].level" required>' +
                        '<option value="easy">Easy</option>' +
                        '<option value="medium">Medium</option>' +
                        '<option value="hard">Hard</option>' +
                    '</select>' +
                '</div>' +

                '<div class="form-group">' +
                    '<label class="form-label">Explanation</label>' +
                    '<textarea class="form-control" name="questions[' + questionIndex + '].explanation" rows="3"></textarea>' +
                '</div>' +
            '</div>';
            
            const newQuestion = $(questionHtml);
            
            $('.questions-list').append(newQuestion);
            initTinyMCE('#media_url_' + questionIndex);
            fixOldMediaUrls('#media_url_' + questionIndex);
        }

        function validateForm() {
            // Force save all TinyMCE editors before validation
            if (typeof tinymce !== 'undefined') {
                tinymce.triggerSave();
                tinymce.get().forEach(function(editor) {
                    editor.save();
                });
            }
            
            var name = $('input[name="name"]').val();
            if (!name || name.trim() === '') {
                iziToast.error({
                    title: 'Error',
                    message: 'Quiz name cannot be empty',
                    position: 'topRight'
                });
                return false;
            }
            
            var duration = $('input[name="duration_minutes"]').val();
            if (!duration || duration < 1) {
                iziToast.error({
                    title: 'Error',
                    message: 'Duration must be at least 1 minute',
                    position: 'topRight'
                });
                return false;
            }
            
            // Validate questions
            var valid = true;
            $('.question-item').each(function(index) {
                // Check question content
                var content = $(this).find('input[name^="questions["][name$="].content"]').val();
                if (!content || !content.trim()) {
                    iziToast.error({
                        title: 'Error',
                        message: `Question ${index + 1} content cannot be empty`,
                        position: 'topRight'
                    });
                    valid = false;
                    return false;
                }
                
                // Check answer options only if they exist
                var answerOptions = $(this).find('.answer-option');
                if (answerOptions.length > 0) {
                    // Check if at least one correct answer is selected
                    var checkedAnswers = $(this).find('input[type="checkbox"]:checked');
                    if (checkedAnswers.length === 0) {
                        iziToast.error({
                            title: 'Error',
                            message: `Question ${index + 1} must have at least one correct answer`,
                            position: 'topRight'
                        });
                        valid = false;
                        return false;
                    }
                    
                    // Check if all answer options have text
                    var emptyOptions = $(this).find('.answer-option input[type="text"]').filter(function() {
                        return !$(this).val() || !$(this).val().trim();
                    });
                    if (emptyOptions.length > 0) {
                        iziToast.error({
                            title: 'Error',
                            message: `All answer options for question ${index + 1} must have text`,
                            position: 'topRight'
                        });
                        valid = false;
                        return false;
                    }
                }
            });
            
            return valid;
        }
    </script>
</body>
</html>
