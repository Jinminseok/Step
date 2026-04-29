<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 회원가입</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <form action="${pageContext.request.contextPath}/shop/user/register.do" method="post" id="register_form">
            <div class="auth-wrap" style="max-width:480px">
                <div class="auth-logo">회원가입</div>
                <div class="auth-sub">ShoeMall 회원이 되어보세요</div>
                
                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <div class="input-with-btn">
                        <input class="form-input" type="text" name="id" id="id" placeholder="아이디" required>
                        <button type="button" class="btn btn-outline btn-sm">중복확인</button>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">비밀번호</label>
                        <input class="form-input" type="password" name="passwd" id="passwd" placeholder="비밀번호" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">비밀번호 확인</label>
                        <input class="form-input" type="password" id="passwd_check" placeholder="확인" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input class="form-input" type="text" name="name" id="name" placeholder="이름" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">연락처</label>
                        <input class="form-input" type="text" name="phone" id="phone" placeholder="010-0000-0000" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input class="form-input" type="email" name="email" id="email" placeholder="hong@email.com" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">주소</label>
                    <div class="input-with-btn" style="margin-bottom:6px">
                        <input class="form-input" type="text" name="zipcode" id="zipcode" placeholder="우편번호" style="width:110px;flex:0 0 110px" readonly required>
                        <button type="button" class="btn btn-outline btn-sm" onclick="/* 우편번호 API 연동 로직 */">우편번호 찾기</button>
                    </div>
                    <input class="form-input" type="text" name="addr1" id="addr1" placeholder="기본주소" style="margin-bottom:6px" readonly required>
                    <input class="form-input" type="text" name="addr2" id="addr2" placeholder="상세주소">
                </div>
                
                <button type="submit" class="btn btn-black btn-full" style="margin-top:6px">회원가입 완료</button>
                
                <div style="text-align:center;font-size:13px;color:var(--gray4);margin-top:14px">
                    이미 회원이신가요? 
                    <a href="${pageContext.request.contextPath}/user/loginForm.do" class="auth-link" style="text-decoration:none;">로그인</a>
                </div>
            </div>
        </form>
    </div>
</body>
</html>