<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 로그인</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">

<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
</head>
<body>
<div class="auth-container">
  <div class="auth-card">
    <div class="auth-logo" onclick="location.href='${pageContext.request.contextPath}/member/main.do'">Shoe<span>Mall</span></div>
    <p style="text-align:center; color:#999999; margin-bottom:40px;">반가워요! 로그인하세요.</p>
    
    <form action="${pageContext.request.contextPath}/member/login.do" method="post">
      <div class="form-group">
        <label class="form-label">아이디</label>
        <input type="text" class="form-input" name="id" placeholder="아이디를 입력하세요" required>
      </div>
      
      <div class="form-group">
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-input" name="passwd" placeholder="비밀번호를 입력하세요" required>
      </div>

      <button type="submit" class="btn-black">로그인</button>
    </form>

    <div style="text-align:center; margin-top:32px; font-size:14px;">
      아직 회원이 아니신가요? 
      <a href="${pageContext.request.contextPath}/member/KM_join.do" style="color:#0057ff; font-weight:700; text-decoration:none;">회원가입 하기</a>
    </div>
  </div>
</div>
</body>
</html>