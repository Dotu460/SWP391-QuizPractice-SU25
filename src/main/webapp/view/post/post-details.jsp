<%-- 
    Document   : post-details
    Created on : Jun 26, 2025, 3:14:27 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SkillGro - Post Details</title>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        
        <!-- Include common CSS -->
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">

        
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/5ynsnptn3yryfyduzpqdheibiiqvgbz5oe6ypn6t4vnl1154/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>

        <style>
            /* Main content area */
            .post-details-main {
                padding: 100px 0 50px;
                background-color: #f8f9fa;
                min-height: calc(100vh - 200px);
            }
            
            .post-details-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            }

            .form-section {
                background: #fff;
                border-radius: 10px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

                        .section-title {
                color: #6C5CE7;
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 20px;
                border-bottom: 2px solid #6C5CE7;
                padding-bottom: 10px;
            }

            .thumbnail-preview {
                max-width: 200px;
                max-height: 150px;
                border-radius: 8px;
                margin-top: 10px;
            }

 

            .status-toggle {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .featured-toggle {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .switch {
                position: relative;
                display: inline-block;
                width: 60px;
                height: 34px;
            }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: .4s;
                border-radius: 34px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 26px;
                width: 26px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #6C5CE7;
            }

            input:checked + .slider:before {
                transform: translateX(26px);
            }

            #media_url {
                min-height: 400px;
            }

            
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>
        
        <!-- Main Content -->
        <main class="post-details-main">
            <div class="container">
                <div class="post-details-container">
            <!-- Success/Error Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <c:choose>
                        <c:when test="${param.success == 'updated'}">Post updated successfully!</c:when>
                        <c:when test="${param.success == 'post_created'}">Post created successfully!</c:when>
                        <c:otherwise>Operation completed successfully!</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    <c:choose>
                        <c:when test="${param.error == 'post_not_found'}">Post not found!</c:when>
                        <c:when test="${param.error == 'invalid_id'}">Invalid post ID!</c:when>
                        <c:when test="${param.error == 'title_required'}">Title is required!</c:when>
                        <c:when test="${param.error == 'category_required'}">Category is required!</c:when>
                        <c:when test="${param.error == 'create_failed'}">Failed to create post. Please try again.</c:when>
                        <c:when test="${param.error == 'update_failed'}">Failed to update post. Please try again.</c:when>
                        <c:when test="${param.error == 'system_error'}">System error occurred. Please try again.</c:when>
                        <c:otherwise>An error occurred. Please try again.</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>
                    <i class="fas fa-edit"></i> 
                    <c:choose>
                        <c:when test="${isNewPost}">Create New Post</c:when>
                        <c:otherwise>Edit Post</c:otherwise>
                    </c:choose>
                </h2>
                <div>
                    <a href="${pageContext.request.contextPath}/blog" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Blog
                    </a>
                    <button type="submit" form="postDetailsForm" class="btn btn-secondary">
                        <i class="fas fa-save"></i> 
                        <c:choose>
                            <c:when test="${isNewPost}">Create Post</c:when>
                            <c:otherwise>Save Changes</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>

            <form id="postDetailsForm" action="${pageContext.request.contextPath}/post-details" method="post" enctype="multipart/form-data">
                <c:if test="${not isNewPost}">
                    <input type="hidden" name="postId" value="${post.id}">
                </c:if>

                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-info-circle"></i> Basic Information</h3>

                                        <div class="row">
                        <div class="col-md-8">
                            <!-- Title -->
                            <div class="mb-3">
                                <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="${post.title}" required maxlength="255">
                            </div>

                            <!-- Author -->
                            <div class="mb-3">
                                <label for="author" class="form-label">Author <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="author" name="author" 
                                       value="${post.author}" required maxlength="100" 
                                       placeholder="Enter author name">
                                <div class="form-text">Enter the author name for this post (can be any name)</div>
                            </div>

                            <!-- Category -->
                            <div class="mb-3">
                                <label for="category" class="form-label">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">Select Category</option>
                                    <option value="Grammar" ${post.category == 'Grammar' ? 'selected' : ''}>Grammar</option>
                                    <option value="Vocabulary" ${post.category == 'Vocabulary' ? 'selected' : ''}>Vocabulary</option>
                                    <option value="Listening" ${post.category == 'Listening' ? 'selected' : ''}>Listening</option>
                                </select>
                            </div>
                            
                                

                            <!-- Brief Information -->
                            <div class="mb-3">
                                <label for="briefInfo" class="form-label">Brief Information</label>
                                <textarea class="form-control" id="briefInfo" name="briefInfo" rows="3" 
                                          maxlength="500" placeholder="Brief description of the post...">${post.brief_info}</textarea>
                                <div class="form-text">Maximum 500 characters</div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <!-- Thumbnail -->
                            <div class="mb-3">
                                <label for="thumbnail" class="form-label">Thumbnail Image</label>
                                <input type="file" class="form-control" id="thumbnail" name="thumbnail" 
                                       accept="image/*" onchange="previewThumbnail(this)">
                                <c:if test="${not isNewPost and not empty post.thumbnail_url}">
                                    <img src="${pageContext.request.contextPath}${post.thumbnail_url}" 
                                         class="thumbnail-preview" id="thumbnailPreview" alt="Current thumbnail">
                                </c:if>
                                <div id="thumbnailPreviewContainer" style="display: none;">
                                    <img id="newThumbnailPreview" class="thumbnail-preview" alt="New thumbnail">
                                </div>
                                <c:if test="${isNewPost}">
                                    <div class="form-text">Upload a thumbnail image for your post</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content Section with TinyMCE -->
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-edit"></i> Content Description</h3>

                    
                    

                    <!-- TinyMCE Editor -->
                    <div class="mb-3 mt-4">
                        <label for="media_url" class="form-label"><span class="text-danger">*</span></label>
                        <textarea id="media_url" name="description">${post.content}</textarea>
                    </div>
                </div>

                <!-- Settings Section -->
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-cogs"></i> Post Settings</h3>

                    <div class="row">
                        <div class="col-md-6">
                            <!-- Featured Flag -->
                            <div class="mb-3">
                                <label class="form-label">Featured Post</label>
                                <div class="featured-toggle">
                                    <label class="switch">
                                        <input type="checkbox" id="featuredFlag" name="featuredFlag" 
                                               ${post.featured_flag ? 'checked' : ''}>
                                        <span class="slider"></span>
                                    </label>
                                    <span class="ms-2">Enable featuring for this post</span>
                                </div>
                                <div class="form-text">Featured posts appear in special sections</div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <!-- Status -->
                            <div class="mb-3">
                                <label for="status" class="form-label">Post Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="draft" ${post.status == 'draft' ? 'selected' : ''}>Draft</option>
                                    <option value="published" ${post.status == 'published' ? 'selected' : ''}>Published</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Timestamps (Read-only) - Only show for existing posts -->
                    <c:if test="${not isNewPost}">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Created Date</label>
                                    <input type="text" class="form-control" readonly 
                                           value="<fmt:formatDate value='${post.created_at}' pattern='MMM dd, yyyy HH:mm'/>">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Published Date</label>
                                    <input type="text" class="form-control" readonly 
                                           value="<fmt:formatDate value='${post.published_at}' pattern='MMM dd, yyyy HH:mm'/>">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Last Updated</label>
                                    <input type="text" class="form-control" readonly 
                                           value="<fmt:formatDate value='${post.updated_at}' pattern='MMM dd, yyyy HH:mm'/>">
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </form>
                </div>
            </div>
        </main>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Initialize TinyMCE with image upload functionality
            function initTinyMCE(selector = '#media_url') {
                tinymce.init({
                    selector: selector,
                    height: 500,
                    menubar: true,
                    plugins: [
                        'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                        'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                        'insertdatetime', 'media', 'table', 'paste', 'help', 'wordcount'
                    ],
                    toolbar: 'undo redo | formatselect | ' +
                        'bold italic backcolor | alignleft aligncenter ' +
                        'alignright alignjustify | bullist numlist outdent indent | ' +
                        'removeformat | help | image media link | code fullscreen',
                    content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
                    
                    // Image handling with file picker
                    image_advtab: true,
                    image_title: true,
                    image_description: true,
                    
                    // File picker callback for browsing local files
                    file_picker_callback: function (callback, value, meta) {
                        // Create file input element
                        const input = document.createElement('input');
                        input.setAttribute('type', 'file');
                        input.setAttribute('accept', 'image/*');
                        
                        input.addEventListener('change', function (e) {
                            const file = e.target.files[0];
                            if (file) {
                                const reader = new FileReader();
                                reader.onload = function () {
                                    // Create a blob URL for immediate preview
                                    const id = 'blobid' + (new Date()).getTime();
                                    const blobCache = tinymce.activeEditor.editorUpload.blobCache;
                                    const base64 = reader.result.split(',')[1];
                                    const blobInfo = blobCache.create(id, file, base64);
                                    blobCache.add(blobInfo);
                                    
                                    // Call the callback with the blob URL
                                    callback(blobInfo.blobUri(), { title: file.name });
                                };
                                reader.readAsDataURL(file);
                            }
                        });
                        
                        input.click();
                    },
                    
                    // Automatic upload of pasted images
                    automatic_uploads: true,
                    
                    // Images upload handler
                    images_upload_handler: function (blobInfo, success, failure, progress) {
                        const formData = new FormData();
                        formData.append('file', blobInfo.blob(), blobInfo.filename());
                        
                        // Upload to server
                        fetch('${pageContext.request.contextPath}/upload-image', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(result => {
                            if (result.success) {
                                success(result.location);
                            } else {
                                failure('Image upload failed: ' + (result.error || 'Unknown error'));
                            }
                        })
                        .catch(error => {
                            failure('Image upload failed: ' + error.message);
                        });
                    },
                    
                    // Basic media handling
                    media_live_embeds: true,
                    
                    setup: function (editor) {
                        editor.on('change', function () {
                            editor.save();
                        });
                    }
                });
            }
            // Initialize TinyMCE when page loads
            document.addEventListener('DOMContentLoaded', function() {
                initTinyMCE('#media_url');
            });

            // Thumbnail preview
            function previewThumbnail(input) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const preview = document.getElementById('newThumbnailPreview');
                        const container = document.getElementById('thumbnailPreviewContainer');
                        preview.src = e.target.result;
                        container.style.display = 'block';

                        // Hide old thumbnail
                        const oldPreview = document.getElementById('thumbnailPreview');
                        if (oldPreview) {
                            oldPreview.style.display = 'none';
                        }
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }

            // Form submission
            document.getElementById('postDetailsForm').addEventListener('submit', function (e) {
                // Update description field with editor content
                if (tinymce.activeEditor) {
                    tinymce.triggerSave();
                }
                
                const title = document.getElementById('title').value.trim();
                const category = document.getElementById('category').value.trim();
                const content = tinymce.activeEditor ? tinymce.activeEditor.getContent() : '';
                
                if (!title) {
                    alert('Please enter a title for the post.');
                    e.preventDefault();
                    return false;
                }
                
                if (!category) {
                    alert('Please select a category for the post.');
                    e.preventDefault();
                    return false;
                }
                
                if (!content || content === '<p></p>' || content === '<p><br></p>') {
                    alert('Please enter content for the post.');
                    e.preventDefault();
                    return false;
                }
                
                console.log('Form submitted with content:', content);
            });
        </script>
        
        <!-- Footer -->
        <jsp:include page="../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>
