<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ShoeMall | 메인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MS_style.css">
    <style>
        .main-container {
            text-align: center;
            padding: 50px 20px;
        }
        .hero-section {
            margin-bottom: 40px;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-primary { background: var(--blue); color: white; }
        .btn-outline { border: 1px solid var(--blue); color: var(--blue); }
    </style>
</head>
<body>

    <div class="main-container">
        <div class="hero-section">
            <h1>ShoeMall</h1>
            <p>가장 완벽한 한 걸음을 위한 시작</p>
        </div>

        <div class="btn-group">
            <%-- 로그인 상태에 따라 버튼 분기 처리 --%>
            <c:choose>
                <c:when test="${empty sessionScope.user_id}">
                    <%-- 비로그인 상태: 회원가입 주소는 아까 설정한 .do 주소로 --%>
                    <a href="${pageContext.request.contextPath}/member/join.do" class="btn btn-primary">회원가입</a>
                    <a href="${pageContext.request.contextPath}/member/login.do" class="btn btn-outline">로그인</a>
                </c:when>
                <c:otherwise>
                    <%-- 로그인 상태 --%>
                    <p><strong>${sessionScope.user_name}</strong>님, 환영합니다!</p>
                    <a href="${pageContext.request.contextPath}/member/logout.do" class="btn btn-outline">로그아웃</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>