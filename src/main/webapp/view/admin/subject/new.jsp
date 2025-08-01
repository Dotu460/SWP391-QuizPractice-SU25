<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Create New Subject - Admin Panel</title>
  <meta name="description" content="Create New Subject">
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
      margin-top: 10px;
    }

    .checkbox-group input[type="checkbox"] {
      transform: scale(1.2);
    }

    /* Image Upload Sections */
    .image-upload-container {
      border: 2px dashed #dee2e6;
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 20px;
      background: #f8f9fa;
      transition: all 0.3s ease;
    }

    .image-upload-container:hover {
      border-color: #667eea;
      background: #f0f2ff;
    }

    .image-item {
      background: #fff;
      border: 1px solid #dee2e6;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 15px;
      position: relative;
    }

    .image-item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
    }

    .image-item-title {
      font-weight: 600;
      color: #495057;
    }

    .remove-image-btn {
      background: #dc3545;
      color: white;
      border: none;
      border-radius: 50%;
      width: 30px;
      height: 30px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }

    .remove-image-btn:hover {
      background: #c82333;
      transform: scale(1.1);
    }

    .add-image-btn {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      border: none;
      padding: 12px 25px;
      border-radius: 25px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .add-image-btn:hover {
      background: linear-gradient(135deg, #218838 0%, #1ea085 100%);
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
    }

    .file-upload-wrapper {
      position: relative;
      display: inline-block;
      width: 100%;
    }

    .file-upload-input {
      position: absolute;
      opacity: 0;
      width: 100%;
      height: 100%;
      cursor: pointer;
    }

    .file-upload-display {
      background: #fff;
      border: 2px dashed #dee2e6;
      border-radius: 8px;
      padding: 20px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .file-upload-display:hover {
      border-color: #667eea;
      background: #f0f2ff;
    }

    .file-upload-display i {
      font-size: 2rem;
      color: #6c757d;
      margin-bottom: 10px;
    }

    .preview-container {
      margin-top: 15px;
      text-align: center;
    }

    .preview-image {
      max-width: 200px;
      max-height: 150px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    /* Form Actions */
    .form-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 30px;
      background: #f8f9fa;
      border-top: 1px solid #dee2e6;
    }

    .btn {
      padding: 12px 30px;
      border: none;
      border-radius: 25px;
      font-weight: 600;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }

    .btn-secondary {
      background: #6c757d;
      color: white;
    }

    .btn-secondary:hover {
      background: #5a6268;
      color: white;
      text-decoration: none;
    }

    /* Info boxes */
    .info-box {
      background: #e7f3ff;
      border: 1px solid #b3d9ff;
      border-radius: 8px;
      padding: 15px;
      margin-bottom: 20px;
    }

    .info-box h4 {
      color: #0066cc;
      margin-bottom: 10px;
      font-size: 1rem;
    }

    .info-box p {
      margin: 5px 0;
      font-size: 0.9rem;
      color: #004080;
    }

    .info-box ul {
      margin: 10px 0;
      padding-left: 20px;
    }

    .info-box li {
      margin: 5px 0;
      font-size: 0.9rem;
      color: #004080;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .container {
        padding: 0;
        margin: 0;
        width: 100%;
      }

      .form-content {
        padding: 15px;
      }

      .form-row {
        grid-template-columns: 1fr;
        gap: 15px;
      }

      .form-header h1 {
        font-size: 1.8rem;
      }

      .form-actions {
        flex-direction: column;
        gap: 15px;
        padding: 20px;
      }
    }

    /* Đảm bảo dashboard content wrap chiếm full width */
    .dashboard__content-wrap {
      width: 100%;
      padding: 0;
    }

    /* Animation for dynamic content */
    .fade-in {
      animation: fadeIn 0.3s ease-in;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>

<body>
<!-- Scroll-top -->
<button class="scroll__top scroll-to-target" data-target="html">
  <i class="tg-flaticon-arrowhead-up"></i>
</button>

<!-- header-area -->
<jsp:include page="../../common/user/header.jsp"></jsp:include>
<!-- header-area-end -->

<!-- main-area -->
<main class="main-area">
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
              <!-- Form Container -->
              <div class="course-form-container">
                <!-- Hiển thị thông báo lỗi nếu có -->
                <c:if test="${not empty sessionScope.errorMessage}">
                  <div class="alert alert-danger" style="margin: 20px; font-size: 1.1rem;">
                    ${sessionScope.errorMessage}
                  </div>
                  <c:remove var="errorMessage" scope="session"/>
                </c:if>
                <!-- Form Header -->
                <div class="form-header">
                  <h1><i class="fas fa-plus-circle"></i> Create New Subject</h1>
                  <p>Build comprehensive learning experiences with multimedia content</p>
                </div>

                <!-- Form Content -->
                <form id="courseForm" method="post" action="${pageContext.request.contextPath}/admin/subject/create" enctype="multipart/form-data">
                  <div class="form-content">
                    
                    <!-- Basic Information Section -->
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
                            <label for="title" class="form-label">Subject Name <span class="required">*</span></label>
                            <input type="text" id="title" name="title" class="form-control" required 
                                   placeholder="Enter subject name" maxlength="255">
                          </div>
                          <div class="form-group">
                            <label for="category" class="form-label">Category <span class="required">*</span></label>
                            <select id="category" name="category_id" class="form-control" required>
                              <option value="" disabled selected>Select a category</option>
                              <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                              </c:forEach>
                            </select>
                          </div>
                        </div>
                        <div class="form-row">
                          <div class="form-group">
                            <label for="status" class="form-label">Status</label>
                            <select id="status" name="status" class="form-control">
                              <option value="draft">Draft</option>
                              <option value="active">Active</option>
                              <option value="inactive">Inactive</option>
                            </select>
                          </div>
                          <div class="form-group">
                            <!-- Owner will be automatically set from current logged-in user -->
                            <label class="form-label">Subject Owner</label>
                            <div class="form-control" style="background-color: #f8f9fa; color: #6c757d;">
                              <i class="fas fa-user"></i> ${sessionScope.account.full_name} (Current User)
                            </div>
                          </div>
                        </div>
                        <div class="form-row">
                          <div class="form-group">
                            <label for="price_package_id" class="form-label">Price Package</label>
                            <select id="price_package_id" name="price_package_id" class="form-control">
                              <option value="" disabled selected>Select a price package (optional)</option>
                              <c:forEach var="pricePackage" items="${pricePackages}">
                                <option value="${pricePackage.id}">
                                  ${pricePackage.name} - $${pricePackage.sale_price}
                                </option>
                              </c:forEach>
                            </select>
                          </div>
                          <div class="form-group">
                            <!-- Empty space for layout balance -->
                          </div>
                        </div>
                        <div class="form-group">
                          <div class="checkbox-group">
                            <input type="checkbox" name="featured_flag" id="featured_flag">
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
                        
                        <div id="imagesContainer">
                          <!-- Dynamic image uploads will be added here -->
                        </div>
                        
                        <button type="button" class="add-image-btn" onclick="addImageUpload()">
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
                        
                        <div id="videosContainer">
                          <!-- Dynamic video uploads will be added here -->
                        </div>
                        
                        <button type="button" class="add-image-btn" onclick="addVideoUpload()">
                          <i class="fas fa-plus"></i> Add Video
                        </button>
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
                          <label for="description" class="form-label">Subject Description & Content <span class="required">*</span></label>
                          <textarea id="description" name="description" class="form-control" rows="7" maxlength="2000" placeholder="Enter subject description..." required></textarea>
                          <small style="color: #6c757d; margin-top: 10px; display: block;">
                            You can use plain text for the subject description.
                          </small>
                        </div>
                      </div>
                    </div>

                  </div>

                  <!-- Form Actions -->
                  <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/subjects" class="btn btn-secondary">
                      <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                      <i class="fas fa-save"></i> Create Subject
                    </button>
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
</main>
<!-- main-area-end -->

<!-- footer-area -->
<jsp:include page="../../common/user/footer.jsp"></jsp:include>
<!-- footer-area-end -->

<!-- JS here -->
<jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>

<!-- JavaScript for Dynamic Media Management -->
<script>
    // Global counters for dynamic content
    let imageCounter = 0;
    let videoCounter = 0;

    // Initialize form
    document.addEventListener('DOMContentLoaded', function() {
      // Add initial image and video upload sections
      addImageUpload();
      addVideoUpload();
      
      // Form validation
      document.getElementById('courseForm').addEventListener('submit', function(e) {
        if (!validateForm()) {
          e.preventDefault();
        }
      });
    });

    // Add image upload functionality
    function addImageUpload() {
      const container = document.getElementById('imagesContainer');
      const imageDiv = document.createElement('div');
      imageDiv.className = 'image-item fade-in';
      imageDiv.id = 'image_' + imageCounter;
      
      imageDiv.innerHTML = 
        '<div class="image-item-header">' +
          '<span class="image-item-title">Image ' + (imageCounter + 1) + '</span>' +
          '<button type="button" class="remove-image-btn" onclick="removeImageUpload(' + imageCounter + ')">' +
            '<i class="fas fa-times"></i>' +
          '</button>' +
        '</div>' +
        '<div class="form-group">' +
          '<label class="form-label">Upload Image</label>' +
          '<div class="file-upload-wrapper">' +
            '<input type="file" name="image_' + imageCounter + '" class="file-upload-input" ' +
                   'accept="image/*" onchange="previewImage(this, ' + imageCounter + ')">' +
            '<div class="file-upload-display">' +
              '<i class="fas fa-cloud-upload-alt"></i>' +
              '<div>Click to upload image or drag and drop</div>' +
              '<small>JPG, PNG, GIF up to 5MB</small>' +
            '</div>' +
          '</div>' +
          '<div id="preview_' + imageCounter + '" class="preview-container"></div>' +
        '</div>' +
        '<div class="form-group">' +
          '<label for="image_notes_' + imageCounter + '" class="form-label">Image Notes/Description</label>' +
          '<textarea name="image_notes_' + imageCounter + '" id="image_notes_' + imageCounter + '" ' +
                    'class="form-control" rows="3" ' +
                    'placeholder="Add description, context, or learning notes for this image..."></textarea>' +
        '</div>';
      
      container.appendChild(imageDiv);
      imageCounter++;
    }

    // Remove image upload
    function removeImageUpload(index) {
      const imageDiv = document.getElementById('image_' + index);
      if (imageDiv) {
        imageDiv.remove();
      }
    }

    // Preview uploaded image
    function previewImage(input, index) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
          const previewContainer = document.getElementById('preview_' + index);
          const file = input.files[0];
          const fileSizeMB = (file.size / 1024 / 1024).toFixed(2);
          
          previewContainer.innerHTML = 
            '<img src="' + e.target.result + '" class="preview-image" alt="Preview">' +
            '<div style="margin-top: 10px; font-size: 0.9rem; color: #6c757d;">' +
            'File: ' + file.name + ' (' + fileSizeMB + ' MB)' +
            '</div>';
        }
        reader.readAsDataURL(input.files[0]);
      }
    }

    // Add video upload functionality
    function addVideoUpload() {
      const container = document.getElementById('videosContainer');
      const videoDiv = document.createElement('div');
      videoDiv.className = 'image-item fade-in';
      videoDiv.id = 'video_' + videoCounter;
      
      videoDiv.innerHTML = 
        '<div class="image-item-header">' +
          '<span class="image-item-title">Video ' + (videoCounter + 1) + '</span>' +
          '<button type="button" class="remove-image-btn" onclick="removeVideoUpload(' + videoCounter + ')">' +
            '<i class="fas fa-times"></i>' +
          '</button>' +
        '</div>' +
        '<div class="form-group">' +
          '<label class="form-label">Video URL or Upload</label>' +
          '<input type="text" name="video_url_' + videoCounter + '" class="form-control" ' +
                 'placeholder="Enter YouTube URL or upload file below" style="margin-bottom: 10px;">' +
          '<div class="file-upload-wrapper">' +
            '<input type="file" name="video_' + videoCounter + '" class="file-upload-input" ' +
                   'accept="video/*" onchange="previewVideo(this, ' + videoCounter + ')">' +
            '<div class="file-upload-display">' +
              '<i class="fas fa-video"></i>' +
              '<div>Click to upload video or drag and drop</div>' +
              '<small>MP4, WebM, OGG up to 100MB</small>' +
            '</div>' +
          '</div>' +
          '<div id="video_preview_' + videoCounter + '" class="preview-container"></div>' +
        '</div>' +
        '<div class="form-group">' +
          '<label for="video_notes_' + videoCounter + '" class="form-label">Video Notes/Description</label>' +
          '<textarea name="video_notes_' + videoCounter + '" id="video_notes_' + videoCounter + '" ' +
                    'class="form-control" rows="3" ' +
                    'placeholder="Add description, context, or learning notes for this video..."></textarea>' +
        '</div>';
      
      container.appendChild(videoDiv);
      videoCounter++;
    }

    // Remove video upload
    function removeVideoUpload(index) {
      const videoDiv = document.getElementById('video_' + index);
      if (videoDiv) {
        videoDiv.remove();
      }
    }

    // Preview uploaded video
    function previewVideo(input, index) {
      if (input.files && input.files[0]) {
        const file = input.files[0];
        const fileSizeMB = (file.size / 1024 / 1024).toFixed(2);
        const previewContainer = document.getElementById('video_preview_' + index);
        
        const videoUrl = URL.createObjectURL(file);
        
        previewContainer.innerHTML = 
          '<video controls style="max-width: 300px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">' +
            '<source src="' + videoUrl + '" type="' + file.type + '">' +
            'Your browser does not support the video tag.' +
          '</video>' +
          '<div style="margin-top: 10px; font-size: 0.9rem; color: #6c757d;">' +
          'File: ' + file.name + ' (' + fileSizeMB + ' MB)' +
          '</div>';
      }
    }

    // Form validation
    function validateForm() {
      const title = document.getElementById('title').value.trim();
      const category = document.getElementById('category').value;
      
      if (!title) {
        alert('Please enter a subject name');
        document.getElementById('title').focus();
        return false;
      }
      
      if (!category) {
        alert('Please select a category');
        document.getElementById('category').focus();
        return false;
      }
      
      return true;
    }
  </script>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- dashboard-area-end -->
  </main>
  <!-- main-area-end -->

  <!-- footer-area -->
  <jsp:include page="../../common/user/footer.jsp"></jsp:include>
  <!-- footer-area-end -->

  <!-- JS here -->
  <jsp:include page="../../common/js/"></jsp:include>
</body>
</html>
