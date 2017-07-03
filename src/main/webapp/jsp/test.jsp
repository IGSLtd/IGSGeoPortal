<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test</title>
</head>
<body>

<div>

</div>

<br/>

				<select class="form-control" id="cat">
					<c:forEach var="row" items="${rockCatgories}">
						<option value="${row.categoryName}">${row.categoryName}</option>
					</c:forEach>
				</select>
</body>
</html>