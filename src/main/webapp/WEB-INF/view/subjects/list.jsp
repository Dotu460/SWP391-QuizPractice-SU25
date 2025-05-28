<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Subjects</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .filters {
            margin: 20px 0;
            padding: 15px;
            background-color: #f9f9f9;
        }
        .actions {
            margin: 20px 0;
        }
        .add-button {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Subject List</h1>

    <!-- Filters Section -->
    <div class="filters">
        <form method="get" action="${pageContext.request.contextPath}/subjects">
            <!-- Category Filter -->
            <label for="category">Category:</label>
            <select name="category" id="category">
                <option value="">All Categories</option>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.id}" ${categoryFilter == category.id ? 'selected' : ''}>${category.name}</option>
                </c:forEach>
            </select>

            <!-- Status Filter -->
            <label for="status">Status:</label>
            <select name="status" id="status">
                <option value="">All Status</option>
                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                <option value="draft" ${statusFilter == 'draft' ? 'selected' : ''}>Draft</option>
            </select>

            <!-- Search by Name -->
            <label for="search">Search:</label>
            <input type="text" id="search" name="search" placeholder="Search by name..." value="${searchTerm}">

            <button type="submit">Apply Filters</button>
        </form>
    </div>

    <!-- Add Subject Button -->
    <div class="actions">
        <a href="${pageContext.request.contextPath}/subject/new" class="add-button">Add New Subject</a>
    </div>

    <!-- Subjects Table -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Category</th>
                <th>Number of Lessons</th>
                <th>Owner</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="subject" items="${subjects}">
                <tr>
                    <td>${subject.subjectId}</td>
                    <td>${subject.title}</td>
                    <td>
                        <c:forEach var="category" items="${categories}">
                            <c:if test="${category.id == subject.categoryId}">
                                ${category.name}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>${lessonCounts[subject.subjectId]}</td>
<%--                    <td>${ownerNames[subject.ownerId]}</td>--%>
                    <td>${UserDAO.findById}</td>
                    <td>${subject.status}</td>

                    <td>
                        <a href="${pageContext.request.contextPath}/subject/details?id=${subject.subjectId}">Edit</a>
                        <a href="${pageContext.request.contextPath}/subject/view?id=${subject.subjectId}">View</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Pagination -->
    <div class="pagination">
        <c:if test="${page > 1}">
            <a href="${pageContext.request.contextPath}/subjects?page=${page - 1}&pageSize=${pageSize}&category=${categoryFilter}&status=${statusFilter}&search=${searchTerm}">Previous</a>
        </c:if>

        <span>Page ${page} of ${totalPages}</span>

        <c:if test="${page < totalPages}">
            <a href="${pageContext.request.contextPath}/subjects?page=${page + 1}&pageSize=${pageSize}&category=${categoryFilter}&status=${statusFilter}&search=${searchTerm}">Next</a>
        </c:if>
    </div>
</body>
</html>