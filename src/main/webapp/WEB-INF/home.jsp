<%-- 
    Document   : home
    Created on : May 22, 2025, 8:03:58 PM
    Author     : LENOVO
--%>

<!-- File: web/home.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Slider, entity.Post, entity.Subject" %>
<html>
<head>
    <title>Home Page</title>
</head>
<body>
<h2>Slider</h2>
<c:forEach var="s" items="${sliders}">
    <div>
        <a href="${s.backlink}"><img src="${s.image}" alt="${s.title}"/></a>
        <h3>${s.title}</h3>
    </div>
</c:forEach>

<h2>Hot Posts</h2>
<c:forEach var="p" items="${hotPosts}">
    <div>
        <a href="post-detail?id=${p.id}"><img src="${p.thumbnail}" alt="${p.title}"/></a>
        <h4>${p.title}</h4>
        <p>${p.postDate}</p>
    </div>
</c:forEach>

<h2>Featured Subjects</h2>
<c:forEach var="sub" items="${featuredSubjects}">
    <div>
        <a href="subject-detail?id=${sub.id}"><img src="${sub.thumbnail}" alt="${sub.title}"/></a>
        <h4>${sub.title}</h4>
        <p>${sub.tagline}</p>
    </div>
</c:forEach>

<h2>Latest Posts (Sidebar)</h2>
<!-- You can reuse hotPosts for sidebar too -->
<ul>
    <c:forEach var="p" items="${hotPosts}">
        <li><a href="post-detail?id=${p.id}">${p.title}</a></li>
    </c:forEach>
</ul>

<h2>Contact Info</h2>
<p>Email: contact@quizpractice.com</p>
<p>Phone: +84 123 456 789</p>
<p>Address: 123 FPT Street, Da Nang, Vietnam</p>
</body>
</html>
