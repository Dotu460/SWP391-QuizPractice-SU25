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


        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/5ynsnptn3yryfyduzpqdheibiiqvgbz5oe6ypn6t4vnl1154/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>

        <style>
            .post-details-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
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

            .media-item {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                background: #f8f9fa;
            }

            .media-preview {
                max-width: 150px;
                max-height: 100px;
                border-radius: 5px;
                margin-top: 10px;
            }

            .btn-remove-media {
                background: #dc3545;
                color: white;
                border: none;
                border-radius: 5px;
                padding: 5px 10px;
                font-size: 12px;
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

            .drag-drop-area {
                border: 2px dashed #6C5CE7;
                border-radius: 10px;
                padding: 40px;
                text-align: center;
                background: #f8f9ff;
                margin-bottom: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .drag-drop-area:hover {
                background: #f0f0ff;
                border-color: #5a4fcf;
            }

            .drag-drop-area.dragover {
                background: #e8e5ff;
                border-color: #5a4fcf;
            }

            .upload-section {
                background: #f8f9fa;
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                transition: all 0.3s ease;
                margin-bottom: 15px;
            }

            .upload-section:hover {
                border-color: #6C5CE7;
                background: #f0f2ff;
            }

            .upload-section h5 {
                color: #6C5CE7;
                margin-bottom: 15px;
            }

            #media_url {
                min-height: 400px;
            }

            #mediaContainer {
                max-height: 400px;
                overflow-y: auto;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                background: #fafafa;
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, #6C5CE7 0%, #764ba2 100%);
                border: none;
                color: white;
                padding: 10px 25px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(108, 92, 231, 0.4);
                color: white;
            }
        </style>
    </head>

    <body>
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
                    <button type="submit" form="postDetailsForm" class="btn btn-primary-custom">
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
                                    <option value="archived" ${post.status == 'archived' ? 'selected' : ''}>Archived</option>
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            let mediaCounter = 0;
            
            // Initialize TinyMCE with the specified selector
            function initTinyMCE(selector = '#media_url') {
                tinymce.init({
                    selector: selector,
                    height: 500,
                    menubar: true,
                    plugins: [
                        'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'print', 'preview',
                        'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                        'insertdatetime', 'media', 'table', 'paste', 'code', 'help', 'wordcount'
                    ],
                    toolbar: 'undo redo | formatselect | ' +
                        'bold italic backcolor | alignleft aligncenter ' +
                        'alignright alignjustify | bullist numlist outdent indent | ' +
                        'removeformat | help | image media | code fullscreen | uploadmedia',
                    content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
                    
                    // Enhanced image handling
                    image_advtab: true,
                    image_uploadtab: true,
                    image_title: true,
                    image_description: true,
                    image_dimensions: true,
                    
                    // Enhanced media handling
                    media_live_embeds: true,
                    media_alt_source: true,
                    media_poster: true,
                    media_dimensions: true,
                    
                    // File picker for both images and videos
                    file_picker_types: 'image media',
                    file_picker_callback: function (cb, value, meta) {
                        var input = document.createElement('input');
                        input.setAttribute('type', 'file');
                        
                        // Set accept attribute based on file type
                        if (meta.filetype === 'image') {
                            input.setAttribute('accept', 'image/*');
                        } else if (meta.filetype === 'media') {
                            input.setAttribute('accept', 'video/*,audio/*');
                        } else {
                            input.setAttribute('accept', 'image/*,video/*,audio/*');
                        }

                        input.onchange = function () {
                            var file = this.files[0];
                            var reader = new FileReader();
                            
                            reader.onload = function () {
                                var id = 'blobid' + (new Date()).getTime();
                                var blobCache = tinymce.activeEditor.editorUpload.blobCache;
                                var base64 = reader.result.split(',')[1];
                                var blobInfo = blobCache.create(id, file, base64);
                                blobCache.add(blobInfo);
                                
                                // Return the file URL and metadata
                                cb(blobInfo.blobUri(), { 
                                    title: file.name,
                                    alt: file.name
                                });
                            };
                            
                            reader.readAsDataURL(file);
                        };

                        input.click();
                    },
                    
                    // Media URL resolver for custom video handling
                    media_url_resolver: function (data, resolve) {
                        if (data.url.indexOf('blob:') === 0) {
                            // Handle blob URLs (local files)
                            resolve({
                                html: '<video controls style="max-width: 100%; height: auto;">' +
                                      '<source src="' + data.url + '" type="video/mp4">' +
                                      'Your browser does not support the video tag.' +
                                      '</video>'
                            });
                        } else {
                            // Let TinyMCE handle other URLs (YouTube, Vimeo, etc.)
                            resolve({url: data.url});
                        }
                    },
                    
                    setup: function (editor) {
                        editor.on('change', function () {
                            editor.save();
                        });
                        
                        // Add custom button for local media upload
                        editor.ui.registry.addButton('uploadmedia', {
                            text: 'Upload Media',
                            icon: 'upload',
                            tooltip: 'Upload Image/Video from Computer',
                            onAction: function () {
                                openMediaUploadDialog(editor);
                            }
                        });
                    }
                });
            }
            
            // Custom media upload dialog
            function openMediaUploadDialog(editor) {
                editor.windowManager.open({
                    title: 'Upload Media from Computer',
                    body: {
                        type: 'panel',
                        items: [
                            {
                                type: 'htmlpanel',
                                html: '<div style="padding: 20px;">' +
                                      '<div style="margin-bottom: 15px;">' +
                                      '<label><strong>Select Media File:</strong></label>' +
                                      '<input type="file" id="mediaUploadInput" accept="image/*,video/*,audio/*" style="width: 100%; margin-top: 5px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">' +
                                      '</div>' +
                                      '<div id="mediaPreviewDialog" style="margin-top: 15px; text-align: center; min-height: 100px; border: 2px dashed #ddd; border-radius: 8px; padding: 20px;">' +
                                      '<p style="color: #666; margin: 0;">Select a file to see preview</p>' +
                                      '</div>' +
                                      '<div style="margin-top: 15px;">' +
                                      '<label><strong>Alt Text / Caption:</strong></label>' +
                                      '<input type="text" id="mediaAltTextDialog" placeholder="Enter description..." style="width: 100%; margin-top: 5px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">' +
                                      '</div>' +
                                      '</div>'
                            }
                        ]
                    },
                    buttons: [
                        {
                            type: 'cancel',
                            text: 'Cancel'
                        },
                        {
                            type: 'submit',
                            text: 'Insert Media',
                            primary: true
                        }
                    ],
                    onSubmit: function (api) {
                        var input = document.getElementById('mediaUploadInput');
                        var altText = document.getElementById('mediaAltTextDialog').value;
                        
                        if (input.files && input.files[0]) {
                            var file = input.files[0];
                            var reader = new FileReader();
                            
                            reader.onload = function () {
                                var fileUrl = reader.result;
                                var isVideo = file.type.startsWith('video/');
                                var isAudio = file.type.startsWith('audio/');
                                var isImage = file.type.startsWith('image/');
                                
                                var content = '';
                                
                                if (isVideo) {
                                    content = '<p><video controls style="max-width: 100%; height: auto;">' +
                                             '<source src="' + fileUrl + '" type="' + file.type + '">' +
                                             'Your browser does not support the video tag.' +
                                             '</video></p>';
                                } else if (isAudio) {
                                    content = '<p><audio controls style="width: 100%;">' +
                                             '<source src="' + fileUrl + '" type="' + file.type + '">' +
                                             'Your browser does not support the audio tag.' +
                                             '</audio></p>';
                                } else if (isImage) {
                                    content = '<p><img src="' + fileUrl + '" alt="' + (altText || file.name) + '" style="max-width: 100%; height: auto;"></p>';
                                }
                                
                                if (content) {
                                    editor.insertContent(content);
                                    api.close();
                                    showSuccessMessage('Media inserted successfully!');
                                } else {
                                    alert('Unsupported file type. Please select an image, video, or audio file.');
                                }
                            };
                            
                            reader.readAsDataURL(file);
                        } else {
                            alert('Please select a file to upload.');
                        }
                    }
                });
                
                // Add event listener after dialog opens
                setTimeout(function() {
                    var input = document.getElementById('mediaUploadInput');
                    if (input) {
                        input.addEventListener('change', function() {
                            var preview = document.getElementById('mediaPreviewDialog');
                            
                            if (this.files && this.files[0]) {
                                var file = this.files[0];
                                var reader = new FileReader();
                                
                                reader.onload = function() {
                                    var isVideo = file.type.startsWith('video/');
                                    var isAudio = file.type.startsWith('audio/');
                                    var isImage = file.type.startsWith('image/');
                                    
                                    if (isVideo) {
                                        preview.innerHTML = '<video controls style="max-width: 100%; max-height: 200px;"><source src="' + reader.result + '" type="' + file.type + '">Your browser does not support the video tag.</video>';
                                    } else if (isAudio) {
                                        preview.innerHTML = '<audio controls style="width: 100%;"><source src="' + reader.result + '" type="' + file.type + '">Your browser does not support the audio tag.</audio>';
                                    } else if (isImage) {
                                        preview.innerHTML = '<img src="' + reader.result + '" style="max-width: 100%; max-height: 200px; border-radius: 4px;">';
                                    } else {
                                        preview.innerHTML = '<p style="color: #666;">Unsupported file type</p>';
                                    }
                                };
                                
                                reader.readAsDataURL(file);
                            }
                        });
                    }
                }, 200);
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

            // Handle video upload
            function handleVideoUpload(input) {
                if (input.files && input.files.length > 0) {
                    Array.from(input.files).forEach(file => {
                        if (file.type.startsWith('video/')) {
                            addMediaToContainer(file, 'video');
                        } else {
                            alert('Please select only video files.');
                        }
                    });
                }
            }
            
            // Handle image upload
            function handleImageUpload(input) {
                if (input.files && input.files.length > 0) {
                    Array.from(input.files).forEach(file => {
                        if (file.type.startsWith('image/')) {
                            addMediaToContainer(file, 'image');
                        } else {
                            alert('Please select only image files.');
                        }
                    });
                }
            }

            // Drag and drop functionality
            const dropArea = document.getElementById('mediaDropArea');
            const mediaInput = document.getElementById('mediaFiles');

            dropArea.addEventListener('click', () => mediaInput.click());

            dropArea.addEventListener('dragover', (e) => {
                e.preventDefault();
                dropArea.classList.add('dragover');
            });

            dropArea.addEventListener('dragleave', () => {
                dropArea.classList.remove('dragover');
            });

            dropArea.addEventListener('drop', (e) => {
                e.preventDefault();
                dropArea.classList.remove('dragover');
                const files = e.dataTransfer.files;
                handleMediaUpload(files);
            });

            function handleMediaUpload(files) {
                Array.from(files).forEach(file => {
                    if (file.type.startsWith('image/') || file.type.startsWith('video/')) {
                        addMediaToContainer(file, file.type.startsWith('video/') ? 'video' : 'image');
                    }
                });
            }

            // Add media to container
            function addMediaToContainer(file, type) {
                const mediaId = 'media_' + (++mediaCounter);
                const fileSize = (file.size / 1024 / 1024).toFixed(2);
                const fileUrl = URL.createObjectURL(file);
                
                let mediaPreview = '';
                let icon = '';
                
                if (type === 'video') {
                    mediaPreview = `<video class="media-preview" controls><source src="${fileUrl}" type="${file.type}">Your browser does not support the video tag.</video>`;
                    icon = '<i class="fas fa-video text-primary"></i>';
                } else {
                    mediaPreview = `<img class="media-preview" src="${fileUrl}" alt="${file.name}">`;
                    icon = '<i class="fas fa-image text-success"></i>';
                }
                
                const mediaItem = `
                    <div class="media-item" id="${mediaId}">
                        <div class="row align-items-center">
                            <div class="col-md-3">
                                ${mediaPreview}
                            </div>
                            <div class="col-md-6">
                                <h6>${icon} ${file.name}</h6>
                                <p class="text-muted mb-1">Size: ${fileSize} MB</p>
                                <p class="text-muted mb-0">Type: ${file.type}</p>
                                <button type="button" class="btn btn-outline-primary btn-sm mt-2" onclick="insertMediaToEditor('${mediaId}', '${file.name}', '${type == 'video'}')">
                                    <i class="fas fa-plus"></i> Insert to Content
                                </button>
                            </div>
                            <div class="col-md-3 text-end">
                                <button type="button" class="btn-remove-media" onclick="removeMedia('${mediaId}')">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                
                document.getElementById('mediaContainer').insertAdjacentHTML('beforeend', mediaItem);
                showSuccessMessage(`${type.charAt(0).toUpperCase() + type.slice(1)} uploaded successfully: ${file.name}`);
            }

            // Insert media to TinyMCE editor
            function insertMediaToEditor(mediaId, fileName, isVideo) {
                if (tinymce.activeEditor) {
                    const mediaElement = document.getElementById(mediaId);
                    if (mediaElement) {
                        let content = '';
                        if (isVideo) {
                            const videoElement = mediaElement.querySelector('video source');
                            if (videoElement) {
                                content = `<p><video controls style="max-width: 100%; height: auto;"><source src="${videoElement.src}" type="${videoElement.type}">Your browser does not support the video tag.</video></p>`;
                            }
                        } else {
                            const imgElement = mediaElement.querySelector('img');
                            if (imgElement) {
                                content = `<p><img src="${imgElement.src}" alt="${fileName}" style="max-width: 100%; height: auto;"></p>`;
                            }
                        }
                        
                        if (content) {
                            tinymce.activeEditor.insertContent(content);
                            showSuccessMessage('Media inserted into content successfully!');
                        }
                    }
                } else {
                    alert('Editor is not ready. Please try again.');
                }
            }

            // Remove media
            function removeMedia(mediaId) {
                document.getElementById(mediaId).remove();
                showSuccessMessage('Media removed successfully!');
            }

            // Show success message
            function showSuccessMessage(message) {
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
                alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                alertDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button>`;
                
                document.body.appendChild(alertDiv);
                
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        alertDiv.parentNode.removeChild(alertDiv);
                    }
                }, 3000);
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
    </body>
</html>
