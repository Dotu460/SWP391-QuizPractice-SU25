<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Edit Subject - Admin Panel</title>
  <meta name="description" content="Edit Subject">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

  <!-- CSS here -->
  <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

  <!-- TinyMCE CDN -->
  <script src="https://cdn.tiny.cloud/1/1u2sqtwzv5mnznfeh0gp0y5wnpqarxf9yx4bn0pjzvot8xy2/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
  
  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background: #f8f9fa;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      color: #333;
    }

    .course-form-container {
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      overflow: hidden;
      margin-bottom: 30px;
    }

    .form-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px;
      text-align: center;
    }

    .form-header h1 {
      font-size: 2.5rem;
      margin-bottom: 10px;
      font-weight: 700;
    }

    .form-header p {
      opacity: 0.9;
      font-size: 1.1rem;
    }

    .form-content {
      padding: 20px;
    }

    .form-section {
      margin-bottom: 40px;
      border: 1px solid #e9ecef;
      border-radius: 10px;
      overflow: hidden;
    }

    .section-header {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 20px;
      border-bottom: 1px solid #dee2e6;
    }

    .section-title {
      font-size: 1.3rem;
      font-weight: 600;
      color: #495057;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .section-title i {
      color: #667eea;
    }

    .section-content {
      padding: 20px;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 25px;
      margin-bottom: 25px;
    }

    .form-row.single {
      grid-template-columns: 1fr;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-label {
      display: block;
      font-weight: 600;
      margin-bottom: 8px;
      color: #495057;
    }

    .required {
      color: #dc3545;
    }

    .form-control {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e9ecef;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s ease;
      background-color: #fff;
    }

    .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
      outline: none;
    }

    .checkbox-group {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
    }

    .checkbox-group input[type="checkbox"] {
      width: 18px;
      height: 18px;
      border-radius: 4px;
    }

    .info-box {
      background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
      border: 1px solid #bbdefb;
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 25px;
    }

    .info-box h4 {
      color: #1976d2;
      margin-bottom: 15px;
      font-size: 1.1rem;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .info-box ul {
      margin: 0;
      padding-left: 20px;
      color: #424242;
    }

    .info-box li {
      margin-bottom: 8px;
      line-height: 1.5;
    }

    .media-item {
      display: grid;
      grid-template-columns: 2fr 3fr 1fr;
      gap: 15px;
      align-items: end;
      margin-bottom: 15px;
      padding: 15px;
      background: white;
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }

    .media-item:last-child {
      margin-bottom: 0;
    }

    .remove-media {
      background: #dc3545;
      color: white;
      border: none;
      padding: 8px 12px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 12px;
      height: fit-content;
    }

    .remove-media:hover {
      background: #c82333;
    }

    .add-media {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-top: 15px;
    }

    .add-media:hover {
      background: linear-gradient(135deg, #218838 0%, #1ea085 100%);
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
    }

    .existing-media {
      margin-bottom: 20px;
    }

    .existing-media-item {
      display: flex;
      align-items: center;
      gap: 15px;
      padding: 10px;
      background: #f8f9fa;
      border: 1px solid #e9ecef;
      border-radius: 8px;
      margin-bottom: 10px;
      position: relative;
    }

    .existing-media-item .btn-danger {
      margin-left: auto;
      padding: 4px 8px;
      font-size: 12px;
    }

    .existing-media-item img {
      width: 60px;
      height: 60px;
      object-fit: cover;
      border-radius: 5px;
    }

    .existing-media-item video {
      width: 60px;
      height: 60px;
      object-fit: cover;
      border-radius: 5px;
    }

    .media-info {
      flex: 1;
    }

    .media-notes {
      font-style: italic;
      color: #6c757d;
      font-size: 0.9em;
    }

    .form-actions {
      display: flex;
      gap: 15px;
      justify-content: center;
      padding: 30px;
      background: #f8f9fa;
      border-top: 1px solid #dee2e6;
    }

    .btn {
      padding: 12px 30px;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      text-align: center;
      transition: all 0.3s ease;
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    .btn-secondary {
      background: #6c757d;
      color: white;
    }

    .btn-secondary:hover {
      background: #5a6268;
      transform: translateY(-2px);
    }

    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border: 1px solid transparent;
      border-radius: 8px;
    }

    .alert-success {
      color: #155724;
      background-color: #d4edda;
      border-color: #c3e6cb;
    }

    .alert-danger {
      color: #721c24;
      background-color: #f8d7da;
      border-color: #f5c6cb;
    }

    @media (max-width: 768px) {
      .form-row {
        grid-template-columns: 1fr;
        gap: 15px;
      }

      .media-item {
        grid-template-columns: 1fr;
        gap: 10px;
      }

      .form-actions {
        flex-direction: column;
        align-items: center;
      }
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
<main class="main-area fix">
  <!-- dashboard-area -->
  <section class="dashboard__area section-pb-120">
    <div class="dashboard__bg"><img src="${pageContext.request.contextPath}/assets/img/bg/dashboard_bg.jpg" alt=""></div>
    <div class="container">
      <div class="dashboard__inner-wrap">
        <div class="row">
          <div class="col-lg-3">
            <jsp:include page="../adminSidebar.jsp">
              <jsp:param name="active" value="subjects"/>
            </jsp:include>
          </div>
          <div class="col-lg-9">
            <div class="dashboard__content-wrap">
              <div class="course-form-container">
      <!-- Header -->
      <div class="form-header">
        <h1><i class="fas fa-edit"></i> Edit Subject</h1>
        <p>Update the course information and manage media content</p>
      </div>

      <!-- Hiển thị thông báo lỗi nếu có -->
      <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger" style="margin: 20px; font-size: 1.1rem;">
          ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
      </c:if>

      <!-- Form -->
      <form id="courseForm" action="${pageContext.request.contextPath}/admin/subject/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${subject.id}">
        
        <div class="form-content">
          <!-- Subject Information Section -->
          <div class="form-section">
            <div class="section-header">
              <h3 class="section-title">
                <i class="fas fa-info-circle"></i>
                Subject Information
              </h3>
            </div>
            <div class="section-content">
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="title">Subject Name <span class="required">*</span></label>
                  <input type="text" id="title" name="title" class="form-control" 
                         value="${subject.title}" required placeholder="Enter subject name" maxlength="255">
                </div>
                <div class="form-group">
                  <label class="form-label" for="category_id">Category <span class="required">*</span></label>
                  <select id="category_id" name="category_id" class="form-control" required>
                    <option value="" disabled>Select a category</option>
                    <c:forEach var="category" items="${categories}">
                      <option value="${category.id}" ${category.id == subject.category_id ? 'selected' : ''}>
                        ${category.name}
                      </option>
                    </c:forEach>
                  </select>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="tag_line">Tag Line</label>
                  <input type="text" id="tag_line" name="tag_line" class="form-control" 
                         value="${subject.tag_line}" placeholder="Short catchy phrase about the subject">
                </div>
                <div class="form-group">
                  <label class="form-label" for="status">Status</label>
                  <select id="status" name="status" class="form-control">
                    <option value="draft" ${subject.status == 'draft' ? 'selected' : ''}>Draft</option>
                    <option value="active" ${subject.status == 'active' ? 'selected' : ''}>Active</option>
                    <option value="inactive" ${subject.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                  </select>
                </div>
              </div>

              <div class="form-row single">
                <div class="form-group">
                  <label class="form-label" for="brief_info">Brief Information</label>
                  <textarea id="brief_info" name="brief_info" class="form-control" rows="3" 
                            placeholder="Brief summary of the subject">${subject.brief_info}</textarea>
                </div>
              </div>

              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" id="featured_flag" name="featured_flag" 
                         ${subject.featured_flag ? 'checked' : ''}>
                  <label for="featured_flag" class="form-label">
                    <i class="fas fa-star"></i> Featured Subject
                    <small style="display: block; color: #6c757d; font-weight: normal;">
                      Featured subjects appear prominently on the homepage
                    </small>
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- Existing Media Section -->
          <c:if test="${not empty subjectImages or not empty subjectVideos}">
            <div class="form-section">
              <div class="section-header">
                <h3 class="section-title">
                  <i class="fas fa-images"></i>
                  Existing Media Content
                </h3>
              </div>
              <div class="section-content">
                <div class="existing-media">
                  <!-- Existing Images -->
                  <c:if test="${not empty subjectImages}">
                    <h4 style="margin-bottom: 15px; color: #495057;">
                      <i class="fas fa-image"></i> Images (${subjectImages.size()})
                    </h4>
                    <c:forEach var="image" items="${subjectImages}">
                      <div class="existing-media-item" id="media-${image.id}">
                        <img src="${image.link}" alt="Subject Image" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.jpg'">
                        <div class="media-info">
                          <div><strong>Image File</strong></div>
                          <div class="media-notes">${not empty image.notes ? image.notes : 'No notes'}</div>
                          <div style="font-size: 0.8em; color: #6c757d; margin-top: 5px;">
                            ID: ${image.id} | Link: ${image.link}
                          </div>
                        </div>
                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteMedia('${image.id}', 'image')" title="Delete this image">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </c:forEach>
                  </c:if>

                  <!-- Existing Videos -->
                  <c:if test="${not empty subjectVideos}">
                    <h4 style="margin-bottom: 15px; margin-top: 20px; color: #495057;">
                      <i class="fas fa-video"></i> Videos (${subjectVideos.size()})
                    </h4>
                    <c:forEach var="video" items="${subjectVideos}">
                      <div class="existing-media-item" id="media-${video.id}">
                        <video controls style="width: 60px; height: 60px;">
                          <source src="${video.link}" type="video/mp4">
                          Your browser does not support the video tag.
                        </video>
                        <div class="media-info">
                          <div><strong>Video File</strong></div>
                          <div class="media-notes">${not empty video.notes ? video.notes : 'No notes'}</div>
                          <div style="font-size: 0.8em; color: #6c757d; margin-top: 5px;">
                            ID: ${video.id} | Link: ${video.link}
                          </div>
                        </div>
                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteMedia('${video.id}', 'video')" title="Delete this video">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </c:forEach>
                  </c:if>
                </div>
              </div>
            </div>
          </c:if>

          <!-- Subject Images Section -->
          <div class="form-section">
            <div class="section-header">
              <h3 class="section-title">
                <i class="fas fa-images"></i>
                Subject Images
              </h3>
            </div>
            <div class="section-content">
              <div class="info-box">
                <h4><i class="fas fa-lightbulb"></i> Image Guidelines</h4>
                <ul>
                  <li>Upload multiple images for your subject</li>
                  <li>Recommended size: 1280x720 pixels (16:9 aspect ratio)</li>
                  <li>Supported formats: JPG, PNG, GIF</li>
                  <li>Maximum file size: 5MB per image</li>
                  <li>Add optional notes/descriptions for each image</li>
                </ul>
              </div>
              
              <div id="imageContainer">
                <div class="media-item">
                  <div class="form-group">
                    <label class="form-label">Image File</label>
                    <input type="file" name="image_0" class="form-control" accept="image/*">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Notes</label>
                    <input type="text" name="image_notes_0" class="form-control" placeholder="Optional notes about this image">
                  </div>
                  <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
                </div>
              </div>
              
              <button type="button" class="add-media" onclick="addImageItem()">
                <i class="fas fa-plus"></i> Add Image
              </button>
            </div>
          </div>

          <!-- Subject Videos Section -->
          <div class="form-section">
            <div class="section-header">
              <h3 class="section-title">
                <i class="fas fa-video"></i>
                Subject Videos
              </h3>
            </div>
            <div class="section-content">
              <div class="info-box">
                <h4><i class="fas fa-play-circle"></i> Video Guidelines</h4>
                <ul>
                  <li>Upload multiple videos for your subject</li>
                  <li>Supported: YouTube URLs or direct video upload</li>
                  <li>Supported formats: MP4, WebM, OGG</li>
                  <li>Maximum file size: 100MB per video</li>
                  <li>Add optional notes/descriptions for each video</li>
                </ul>
              </div>
              
              <div id="videoContainer">
                <div class="media-item">
                  <div class="form-group">
                    <label class="form-label">Video File</label>
                    <input type="file" name="video_0" class="form-control" accept="video/*">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Notes</label>
                    <input type="text" name="video_notes_0" class="form-control" placeholder="Optional notes about this video">
                  </div>
                  <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
                </div>
              </div>
              
              <button type="button" class="add-media" onclick="addVideoItem()">
                <i class="fas fa-plus"></i> Add Video
              </button>

              <!-- Video URL Section -->
              <div style="margin-top: 20px;">
                <h5 style="margin-bottom: 10px; color: #495057;">Or Add Video URLs</h5>
                <div id="videoUrlContainer">
                  <div class="media-item">
                    <div class="form-group">
                      <label class="form-label">Video URL</label>
                      <input type="url" name="video_url_0" class="form-control" placeholder="https://example.com/video.mp4">
                    </div>
                    <div class="form-group">
                      <label class="form-label">Notes</label>
                      <input type="text" name="video_notes_0" class="form-control" placeholder="Optional notes about this video">
                    </div>
                    <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
                  </div>
                </div>
                <button type="button" class="add-media" onclick="addVideoUrlItem()">
                  <i class="fas fa-plus"></i> Add Another Video URL
                </button>
              </div>
            </div>
          </div>

          <!-- Subject Description Section -->
          <div class="form-section">
            <div class="section-header">
              <h3 class="section-title">
                <i class="fas fa-align-left"></i>
                Subject Description
              </h3>
            </div>
            <div class="section-content">
              <div class="info-box">
                <h4><i class="fas fa-edit"></i> Description Guidelines</h4>
                <ul>
                  <li>Use this field to provide a detailed description of the subject.</li>
                  <li>You can use plain text, up to 2000 characters.</li>
                </ul>
              </div>
              
              <div class="form-group">
                <label class="form-label" for="description">Subject Description & Content <span class="required">*</span></label>
                <textarea id="description" name="description" class="form-control" rows="7" maxlength="2000" 
                          placeholder="Enter subject description..." required>${subject.description}</textarea>
                <small style="color: #6c757d; margin-top: 10px; display: block;">
                  You can use plain text for the subject description.
                </small>
              </div>
            </div>
          </div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save"></i> Update Subject
          </button>
          <a href="${pageContext.request.contextPath}/admin/subjects" class="btn btn-secondary">
            <i class="fas fa-times"></i> Cancel
          </a>
        </div>
      </form>
    </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- dashboard-area-end -->
  </div>

</main>
<!-- main-area-end -->

<!-- footer-area -->
<jsp:include page="../../common/user/footer.jsp"></jsp:include>
<!-- footer-area-end -->

<!-- JS here -->
<jsp:include page="../../common/js/"></jsp:include>

<script>
  // Initialize TinyMCE for description
  tinymce.init({
    selector: '#description',
    height: 400,
    plugins: 'lists link image table code help wordcount',
    toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image | table | code | help',
    content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }'
  });

  // Media management functions
  let imageCounter = 1;
  let videoCounter = 1;
  let videoUrlCounter = 1;

  function addImageItem() {
    const container = document.getElementById('imageContainer');
    const div = document.createElement('div');
    div.className = 'media-item';
    div.innerHTML = `
      <div class="form-group">
        <label class="form-label">Image File</label>
        <input type="file" name="image_${imageCounter}" class="form-control" accept="image/*">
      </div>
      <div class="form-group">
        <label class="form-label">Notes</label>
        <input type="text" name="image_notes_${imageCounter}" class="form-control" placeholder="Optional notes about this image">
      </div>
      <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
    `;
    container.appendChild(div);
    imageCounter++;
  }

  function addVideoItem() {
    const container = document.getElementById('videoContainer');
    const div = document.createElement('div');
    div.className = 'media-item';
    div.innerHTML = `
      <div class="form-group">
        <label class="form-label">Video File</label>
        <input type="file" name="video_${videoCounter}" class="form-control" accept="video/*">
      </div>
      <div class="form-group">
        <label class="form-label">Notes</label>
        <input type="text" name="video_notes_${videoCounter}" class="form-control" placeholder="Optional notes about this video">
      </div>
      <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
    `;
    container.appendChild(div);
    videoCounter++;
  }

  function addVideoUrlItem() {
    const container = document.getElementById('videoUrlContainer');
    const div = document.createElement('div');
    div.className = 'media-item';
    div.innerHTML = `
      <div class="form-group">
        <label class="form-label">Video URL</label>
        <input type="url" name="video_url_${videoUrlCounter}" class="form-control" placeholder="https://example.com/video.mp4">
      </div>
      <div class="form-group">
        <label class="form-label">Notes</label>
        <input type="text" name="video_notes_${videoUrlCounter}" class="form-control" placeholder="Optional notes about this video">
      </div>
      <button type="button" class="remove-media" onclick="removeMediaItem(this)">Remove</button>
    `;
    container.appendChild(div);
    videoUrlCounter++;
  }

  function removeMediaItem(button) {
    const container = button.parentElement.parentElement;
    const item = button.parentElement;
    
    // Only remove if there's more than one item
    if (container.children.length > 1) {
      item.remove();
    } else {
      // Clear the inputs instead of removing the last item
      const inputs = item.querySelectorAll('input');
      inputs.forEach(input => input.value = '');
    }
  }

  // Form validation
  function validateForm() {
    const title = document.getElementById('title').value.trim();
    const category = document.getElementById('category_id').value;
    const description = document.getElementById('description').value.trim();
    
    if (!title) {
      alert('Please enter a subject name');
      document.getElementById('title').focus();
      return false;
    }
    
    if (!category) {
      alert('Please select a category');
      document.getElementById('category_id').focus();
      return false;
    }
    
    if (!description) {
      alert('Please enter a subject description');
      document.getElementById('description').focus();
      return false;
    }
    
    return true;
  }

  // Attach validation to form
  document.getElementById('courseForm').addEventListener('submit', function(e) {
    if (!validateForm()) {
      e.preventDefault();
    }
  });

  // Delete media function
  function deleteMedia(mediaId, mediaType) {
    if (confirm('Are you sure you want to delete this ' + mediaType + '? This action cannot be undone.')) {
      // Make AJAX call to delete media
      fetch('${pageContext.request.contextPath}/admin/subject/deleteMedia', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'mediaId=' + encodeURIComponent(mediaId)
      })
      .then(response => response.text())
      .then(data => {
        if (data === 'success') {
          // Remove the media item from DOM
          document.getElementById('media-' + mediaId).remove();
          alert(mediaType.charAt(0).toUpperCase() + mediaType.slice(1) + ' deleted successfully!');
        } else {
          alert('Failed to delete ' + mediaType + '. Please try again.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Error deleting ' + mediaType + '. Please try again.');
      });
    }
  }

  SVGInject(document.querySelectorAll("img.injectable"));
</script>

</body>
</html> 