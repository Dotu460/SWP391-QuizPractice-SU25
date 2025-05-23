<%-- 
    Author     : 4USER-FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <c:forEach items="${mapUser}" var="entry">
            
            Id: ${entry.key}
            Username: ${entry.value.username}
            Role: ${mapRole.get(entry.value.roleId).name}
            <br>

        </c:forEach>


    </body>
</html>
