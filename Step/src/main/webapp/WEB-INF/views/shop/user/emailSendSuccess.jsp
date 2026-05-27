<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<c:if test="${check}">
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 이메일 발송 완료</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="wrap" style="display:flex; justify-content:center; align-items:center; min-height:60vh;">
        <div class="auth-wrap" style="width:100%; max-width:480px; text-align:center; padding: 60px 40px;">
            <div style="font-size:40px; margin-bottom:16px;">✉️</div>
            <div style="font-size:22px; font-weight:700; margin-bottom:16px;">이메일 발송 완료</div>
            <div style="font-size:14px; color:var(--gray3); line-height:1.6; margin-bottom:40px;">
                입력하신 이메일 주소로 <strong>임시 비밀번호</strong>가 발송되었습니다.<br>
                로그인 후 반드시 비밀번호를 변경해 주세요.
            </div>
            
            <button onclick="location.href='${pageContext.request.contextPath}/shop/user/loginForm.do'" class="btn btn-black btn-full" style="height:48px; font-size:14px;">로그인하러 가기</button>
        </div>
    </div>
</body>
</html>
</c:if>
<c:if test="${!check}">
    <script>
        alert('입력하신 아이디 또는 이메일 정보가 일치하지 않습니다.');
        history.go(-1);
    </script>
</c:if>