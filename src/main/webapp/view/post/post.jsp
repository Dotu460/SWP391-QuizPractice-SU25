<%-- 
    Document   : post
    Created on : Jun 12, 2025, 4:45:12 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${post.title} - SkillGro</title>

        <!-- Include common CSS -->
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">

        <style>
            .post-detail {
                padding: 40px 0;
            }

            .post-header {
                margin-bottom: 30px;
            }

            .post-title {
                font-size: 36px;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
            }

            .post-meta {
                color: #666;
                font-size: 14px;
                margin-bottom: 20px;
            }

            .post-meta span {
                margin-right: 20px;
            }

            .post-meta i {
                margin-right: 5px;
            }

            .post-thumbnail {
                margin-bottom: 30px;
            }

            .post-thumbnail img {
                width: 100%;
                max-height: 500px;
                object-fit: cover;
                border-radius: 10px;
            }

            .post-content {
                font-size: 16px;
                line-height: 1.8;
                color: #444;
            }

            .post-content p {
                margin-bottom: 20px;
            }

            .post-content img {
                max-width: 100%;
                height: auto;
                margin: 20px 0;
            }

            .post-footer {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }

            .post-category {
                display: inline-block;
                padding: 5px 15px;
                background: #6C5CE7;
                color: #fff;
                border-radius: 20px;
                font-size: 14px;
                margin-bottom: 15px;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>

            <!-- Main Content -->
            <div class="container">
                <div class="post-detail">
                    <div class="row">
                        <div class="col-lg-8 mx-auto">
                            <!-- Post Header -->
                            <div class="post-header">
                                <span class="post-category">
                                ${post.category}
                            </span>

                            <h1 class="post-title">
                                ${post.title}
                            </h1>

                            <div class="post-meta">
                                <span>
                                    <i class="fas fa-calendar-alt"></i>
                                    <fmt:formatDate value="${post.published_at}" pattern="MMMM d, yyyy"/>
                                </span>
                                <span>
                                    <i class="fas fa-user"></i>
                                    Author Name
                                </span>
                            </div>
                        </div>

                        <!-- Post Thumbnail -->
                        <div class="post-thumbnail">
                            <img src="${pageContext.request.contextPath}${post.thumbnail_url}" 
                                 alt="${post.title}">
                        </div>

                        <!-- Brief Info -->
                        <div class="post-brief mb-4">
                            <p><strong>${post.brief_info}</strong></p>
                        </div>

                        <!-- Post Content -->
                        <div class="post-content">
                            ${post.content}
                        </div>

                        <!-- Post Footer -->
                        <div class="post-footer">
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="text-muted">
                                        <small>
                                            Last updated: 
                                            <fmt:formatDate value="${post.updated_at}" 
                                                            pattern="MMMM d, yyyy HH:mm"/>
                                        </small>
                                    </p>
                                </div>
                                <div class="col-md-6 text-end">
                                    <!-- Social Share Buttons -->
                                    <button class="btn btn-sm btn-outline-primary">
                                        <i class="fab fa-facebook-f"></i> Share
                                    </button>
                                    <button class="btn btn-sm btn-outline-info">
                                        <i class="fab fa-twitter"></i> Tweet
                                    </button>
                                    <button class="btn btn-sm btn-outline-success">
                                        <i class="fab fa-whatsapp"></i> Share
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="../common/user/footer.jsp"></jsp:include>

            <!-- Include common JS -->
        <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>