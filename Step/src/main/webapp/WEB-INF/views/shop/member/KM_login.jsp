<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 로그인</title>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/KM_MS_validation.js"></script>
</head>
<body>

	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-logo"
				onclick="location.href='${pageContext.request.contextPath}/main.do'">
				Shoe<span>Mall</span>
			</div>
			<p class="auth-sub">반가워요! 로그인하세요.</p>

			<form action="${pageContext.request.contextPath}/member/login.do"
				method="post" id="login_form">
				<div class="form-group">
					<label class="form-label">아이디</label> <input type="text"
						class="form-input" name="id" id="id" placeholder="아이디를 입력하세요"
						required>
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호</label> <input type="password"
						class="form-input" name="passwd" id="passwd"
						placeholder="비밀번호를 입력하세요" required>
				</div>

				<div class="form-helper">
					<label class="remember-me"> <input type="checkbox"
						name="remember"> 아이디 저장
					</label>
					<%-- 비밀번호 찾기 경로도 KM.properties에 등록된 주소인지 확인 --%>
					<a href="${pageContext.request.contextPath}/member/findPw.do"
						class="find-link">비밀번호를 잊으셨나요?</a>
				</div>

				<%-- 에러 메시지 출력 부분 --%>
				<c:if test="${!empty msg}">
					<div
						style="color: red; font-size: 12px; margin-top: 10px; text-align: center;">
						${msg}</div>
				</c:if>

				<button type="submit" class="btn-black">로그인</button>
			</form>


			<div class="auth-footer">
				아직 회원이 아니신가요? <a
					href="${pageContext.request.contextPath}/member/join.do"
					class="auth-link">회원가입 하기</a>
			</div>
		</div>

		<p class="auth-copy">&copy; 2026 ShoeMall. All rights reserved.</p>
	</div>

</body>
</html>