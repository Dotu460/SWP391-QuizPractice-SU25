<%-- 
    Document   : question-edit
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
    <title>SkillGro - Quiz Question Editor</title>
    <meta name="description" content="SkillGro - Quiz Question Editor">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    
    <!-- TinyMCE CDN -->
    <script src="https://cdn.tiny.cloud/1/1u2sqtwzv5mnznfeh0gp0y5wnpqarxf9yx4bn0pjzvot8xy2/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    
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
        
        .question-container {
            border: 1px solid #eee;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            position: relative;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-title {
            margin: 0;
            color: #333;
        }
        
        .remove-question {
            cursor: pointer;
            color: #dc3545;
            font-size: 18px;
        }
        
        .answer-option {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            gap: 10px;
        }
        
        .answer-option input[type="radio"] {
            margin-right: 10px;
        }
        
        .add-question-btn {
            margin-top: 15px;
        }
        
        /* TinyMCE specific styles */
        .tox-tinymce {
            border-radius: 4px;
            border: 1px solid #ddd !important;
        }
        
        .tox-statusbar {
            border-top: 1px solid #eee !important;
        }
        
        .tox-tinymce-aux {
            z-index: 9999 !important;
        }

        .media-preview {
            max-width: 100%;
            margin-top: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
            padding: 10px;
        }

        .media-preview img {
            max-width: 100%;
            height: auto;
        }

        .media-preview audio,
        .media-preview video {
            width: 100%;
        }

        .btn-add-option {
            margin-top: 10px;
        }

        .btn-remove-option {
            color: #dc3545;
            cursor: pointer;
            padding: 5px;
        }

        .btn-remove-option:hover {
            color: #c82333;
        }

        .media-container {
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .media-container img {
            max-width: 100%;
            height: auto;
        }
        .media-container video {
            max-width: 100%;
            height: auto;
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
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${question.id == 0}">Thêm câu hỏi mới</c:when>
                                        <c:otherwise>Question details</c:otherwise>
                                    </c:choose>
                                </h4>
                                <a href="${pageContext.request.contextPath}/questions-list" class="btn btn-outline-secondary">
                                    <i class="fa fa-arrow-left"></i> Quay lại danh sách câu hỏi
                                </a>
                            </div>
                            
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" style="margin-bottom: 20px;">${errorMessage}</div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/questions-list" method="post" id="questionForm" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="saveQuestion">
                                <input type="hidden" name="questionId" value="${question.id}">
                                
                                <div class="form-section">
                                    <div class="form-section-title">Question Information</div>
                                    
                                     <div class="form-group">
                                        <label class="form-label">Quiz</label>
                                        <select class="form-control" id="quizId" name="quizId" required>
                                            <option value="">-- Select Quiz --</option>
                                            <c:forEach items="${quizzesList}" var="quiz">
                                                <option value="${quiz.id}" ${question.quiz_id == quiz.id ? 'selected' : ''}>
                                                    ${quiz.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Question Type -->
                                    <div class="form-group">
                                        <label class="form-label">Question Type</label>
                                        <select class="form-control" name="type" required>
                                            <option value="multiple" ${question.type == 'multiple' ? 'selected' : ''}>Multiple Choice</option>
                                            <option value="essay" ${question.type == 'essay' ? 'selected' : ''}>Essay</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Question Level -->
                                    <div class="form-group">
                                        <label class="form-label">Question Level</label>
                                        <select class="form-control" name="level" required>
                                            <option value="easy" ${question.level == 'easy' ? 'selected' : ''}>Easy</option>
                                            <option value="medium" ${question.level == 'medium' ? 'selected' : ''}>Medium</option>
                                            <option value="hard" ${question.level == 'hard' ? 'selected' : ''}>Hard</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Question Status -->
                                    <div class="form-group">
                                        <label class="form-label">Status</label>
                                        <select class="form-control" name="status" required>
                                            <option value="active" ${question.status == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="hidden" ${question.status == 'hidden' ? 'selected' : ''}>Hidden</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <div class="form-section-title">Question Content</div>
                                    <div class="form-group">
                                        <label class="form-label">Question Content</label>
                                        <input type="text" class="form-control" name="content" value="${question.content}" required>
                                    </div>

                                    <!-- Media URL -->
                                    <div class="form-group">
                                        <label class="form-label">Media (Images/Video)</label>
                                        <textarea id="media_url" name="media_url">${question.media_url}</textarea>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <div class="form-section-title">Answers</div>
                                    <div class="form-group">
                                        <label class="form-label">Answers</label>
                                        <div id="answers-container">
                                            <c:choose>
                                                <c:when test="${not empty question.questionOptions}">
                                                    <c:forEach items="${question.questionOptions}" var="option" varStatus="status">
                                                        <div class="answer-option" id="answer-${status.index + 1}">
                                                            <input type="radio" name="correctAnswer" value="${status.index + 1}" ${option.correct_key ? 'checked' : ''}>
                                                            <input type="text" class="form-control" name="optionText_${status.index + 1}" value="${option.option_text}" placeholder="Answer ${status.index + 1}" required>
                                                            <input type="hidden" name="optionId_${status.index + 1}" value="${option.id}">
                                                            <button type="button" class="btn-remove-option" onclick="removeOption(${status.index + 1})">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach begin="1" end="4" var="i">
                                                        <div class="answer-option" id="answer-${i}">
                                                            <input type="radio" name="correctAnswer" value="${i}" ${i == 1 ? 'checked' : ''}>
                                                            <input type="text" class="form-control" name="optionText_${i}" placeholder="Answer ${i}" required>
                                                            <input type="hidden" name="optionId_${i}" value="0">
                                                            <button type="button" class="btn-remove-option" onclick="removeOption(${i})">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <input type="hidden" id="optionCount" name="optionCount" value="${not empty question.questionOptions ? question.questionOptions.size() : 4}">
                                        <button type="button" class="btn btn-outline-primary btn-add-option" onclick="addOption()">
                                            <i class="fas fa-plus"></i> Add Answer
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <div class="form-section-title">Explanation</div>
                                    <div class="form-group">
                                        <label class="form-label">Explanation</label>
                                        <textarea class="form-control" name="explanation" rows="3" placeholder="Enter explanation for the correct answer...">${question.explanation}</textarea>
                                        <small class="form-text">Provide explanation for the correct answer.</small>
                                    </div>
                                </div>
                                
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/questions-list" class="btn btn-outline-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">Save Question</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize TinyMCE for media_url
            tinymce.init({
                selector: '#media_url',
                plugins: 'image media link code table lists',
                toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | indent outdent | bullist numlist | image media link | code',
                height: 300,
                images_upload_url: '${pageContext.request.contextPath}/upload-media',
                automatic_uploads: true,
                file_picker_types: 'image media',
                media_live_embeds: true,
                images_upload_handler: function (blobInfo, progress) {
                    return new Promise((resolve, reject) => {
                        const formData = new FormData();
                        formData.append('file', blobInfo.blob(), blobInfo.filename());

                        fetch('${pageContext.request.contextPath}/upload-media', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(result => {
                            if (result.location) {
                                resolve(result.location);
                            } else {
                                reject({ message: result.message || 'Upload failed' });
                            }
                        })
                        .catch(error => {
                            reject({ message: 'HTTP Error: ' + error.message });
                        });
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

                        fetch('${pageContext.request.contextPath}/upload-media', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(result => {
                            if (result.location) {
                                cb(result.location);
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
                    editor.on('change', function() {
                        editor.save();
                    });

                    // Xử lý khi paste hoặc drop ảnh
                    editor.on('paste drop', function(e) {
                        var clipboardData = e.clipboardData || e.dataTransfer;
                        if (clipboardData && clipboardData.files.length > 0) {
                            e.preventDefault();
                            var file = clipboardData.files[0];
                            var formData = new FormData();
                            formData.append('file', file);

                            fetch('${pageContext.request.contextPath}/upload-media', {
                                method: 'POST',
                                body: formData
                            })
                            .then(response => response.json())
                            .then(result => {
                                if (result.location) {
                                    editor.insertContent(result.location);
                                }
                            });
                        }
                    });
                },
                // Tắt các định dạng HTML mặc định
                paste_as_text: true,
                paste_data_images: false,
                // Chỉ cho phép các elements cần thiết
                valid_elements: 'p',
                // Không tự động thêm thẻ p
                forced_root_block: false,
                // Không convert URL thành link
                convert_urls: false,
                // Không tự động format
                verify_html: false
            });

            // Form validation
            $('#questionForm').submit(function(e) {
                tinymce.triggerSave();
                
                if (!validateForm()) {
                    e.preventDefault();
                    return false;
                }
                
                // Get media content và clean up
                var mediaContent = tinymce.get('media_url').getContent();
                // Extract only the URL from content
                var mediaUrl = '';
                if (mediaContent) {
                    // Tìm URL trong nội dung
                    var matches = mediaContent.match(/src="([^"]+)"|uploads\/media\/[^"'\s]+/g);
                    if (matches) {
                        // Lấy URL đầu tiên tìm được
                        mediaUrl = matches[0].replace(/src="|"/g, '');
                    } else {
                        // Nếu content là URL thuần
                        mediaUrl = mediaContent.trim();
                    }
                }
                
                // Update hidden input for media_url
                var mediaUrlInput = document.querySelector('input[name="media_url"]');
                if (!mediaUrlInput) {
                    mediaUrlInput = document.createElement('input');
                    mediaUrlInput.type = 'hidden';
                    mediaUrlInput.name = 'media_url';
                    this.appendChild(mediaUrlInput);
                }
                mediaUrlInput.value = mediaUrl;
                
                return true;
            });
        });

        function validateForm() {
            var content = $('input[name="content"]').val();
            if (!content || content.trim() === '') {
                iziToast.error({
                    title: 'Error',
                    message: 'Question content cannot be empty',
                    position: 'topRight',
                    timeout: 3000
                });
                return false;
            }
            
            if (!$('input[name="correctAnswer"]:checked').length) {
                iziToast.error({
                    title: 'Error',
                    message: 'Please select a correct answer',
                    position: 'topRight',
                    timeout: 3000
                });
                return false;
            }
            
            var allFilled = true;
            $('input[name^="optionText_"]').each(function() {
                if ($(this).val().trim() === '') {
                    allFilled = false;
                    return false;
                }
            });
            
            if (!allFilled) {
                iziToast.error({
                    title: 'Error',
                    message: 'All answer fields must be filled',
                    position: 'topRight',
                    timeout: 3000
                });
                return false;
            }
            
            return true;
        }

        function addOption() {
            var optionCount = parseInt($('#optionCount').val());
            optionCount++;
            var newOption = `
                <div class="answer-option" id="answer-${optionCount}">
                    <input type="radio" name="correctAnswer" value="${optionCount}">
                    <input type="text" class="form-control" name="optionText_${optionCount}" placeholder="Answer ${optionCount}" required>
                    <input type="hidden" name="optionId_${optionCount}" value="0">
                    <button type="button" class="btn-remove-option" onclick="removeOption(${optionCount})">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;
            $('#answers-container').append(newOption);
            $('#optionCount').val(optionCount);
        }

        function removeOption(optionNumber) {
            var optionCount = parseInt($('#optionCount').val());
            if (optionCount > 2) {
                $(`#answer-${optionNumber}`).remove();
                optionCount--;
                $('#optionCount').val(optionCount);
                
                // Reorder remaining options
                var index = 1;
                $('.answer-option').each(function() {
                    $(this).attr('id', `answer-${index}`);
                    $(this).find('input[type="radio"]').attr('value', index);
                    $(this).find('input[type="text"]').attr('name', `optionText_${index}`);
                    $(this).find('input[type="hidden"]').attr('name', `optionId_${index}`);
                    $(this).find('input[type="text"]').attr('placeholder', `Answer ${index}`);
                    index++;
                });
            } else {
                iziToast.warning({
                    title: 'Warning',
                    message: 'A question must have at least 2 answers',
                    position: 'topRight',
                    timeout: 3000
                });
            }
        }
    </script>
</body>
</html>
