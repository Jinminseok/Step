<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loginError = (String) request.getAttribute("loginError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 로그인</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="auth-page-wrap">
        <form action="${pageContext.request.contextPath}/shop/user/login.do" method="post" id="login_form">
            <div class="auth-wrap">

                <div class="auth-logo">Shoe<span>Mall</span></div>
                <div class="auth-sub">ShoeMall에 오신 것을 환영합니다</div>

                <% if (loginError != null) { %>
                <div class="auth-error">⚠️ <%= loginError %></div>
                <% } %>

                <div class="form-group">
                    <label class="form-label" for="id">아이디</label>
                    <input class="form-input" type="text" name="id" id="id"
                           placeholder="아이디를 입력하세요" required autocomplete="username">
                </div>

                <div class="form-group" style="margin-bottom:24px">
                    <label class="form-label" for="passwd">비밀번호</label>
                    <input class="form-input" type="password" name="passwd" id="passwd"
                           placeholder="비밀번호를 입력하세요" required autocomplete="current-password">
                </div>

                <button type="submit" class="btn btn-black btn-full">로그인</button>

                <div class="auth-divider">또는</div>

                <div style="text-align:center; font-size:13px; color:var(--gray4)">
                    아직 회원이 아니신가요?&nbsp;
                    <a href="${pageContext.request.contextPath}/shop/user/registerForm.do" class="auth-link">회원가입</a>
                </div>

            </div>
        </form>
    </div>
</body>
</html>
