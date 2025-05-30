<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${subject.title}</title>
</head>
<body>
    <h1>${subject.title}</h1>
    <img src="${subject.thumbnailUrl}" alt="${subject.title}" width="200" height="200" />
    <p>${subject.description}</p>
    <p>Category: ${category.name}</p>

    <h3>Available Packages</h3>
    <ul>
        <c:forEach var="package" items="${packages}">
            <li>
                <strong>${package.package_name}</strong> -
                List Price: ${package.list_price}, Sale Price: ${package.sale_price}
                <a href="${pageContext.request.contextPath}/subject/register?id=${subject.subjectId}&packageId=${package.id}">Register</a>
            </li>
        </c:forEach>
    </ul>

    <a href="${pageContext.request.contextPath}/subjects">Back to Subjects</a>
</body>
</html>