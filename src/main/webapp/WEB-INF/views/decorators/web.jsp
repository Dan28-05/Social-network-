<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="Mạng Xã Hội" /></title>

    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Global CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css">

    <!-- Các thẻ head riêng của từng trang con -->
    <dec:head />
</head>
<body>
    <!-- Header chung -->
    <%@ include file="/WEB-INF/views/commons/header.jsp" %>

    <!-- Nội dung chính được render tự động từ các JSP con -->
    <main class="page-body">
        <dec:body />
    </main>

    <!-- Footer chung -->
    <%@ include file="/WEB-INF/views/commons/footer.jsp" %>
</body>
</html>
