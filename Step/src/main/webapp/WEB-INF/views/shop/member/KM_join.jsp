<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 회원가입</title>
<link rel="stylesheet" href="css/MS_style.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/MS_style.css">
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-logo"
				onclick="location.href='${pageContext.request.contextPath}/main/main.do'">
				Shoe<span>Mall</span>
			</div>
			<p class="auth-sub">가장 완벽한 한 걸음을 위한 시작</p>

			<form action="${pageContext.request.contextPath}/member/join.do"
				method="post" id="join_form">
				<div class="form-group">
					<label class="form-label">이름</label> <input type="text"
						class="form-input" name="userName" placeholder="이름을 입력하세요"
						required>
				</div>

				<div class="form-group">
					<label class="form-label">이메일(아이디)</label> <input type="email"
						class="form-input" name="userEmail" id="userEmail"
						placeholder="example@shoemall.com" required>
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호</label> <input type="password"
						class="form-input" name="userPw" id="userPw"
						placeholder="비밀번호를 입력하세요" required>
				</div>

				<div class="form-group">
					<label class="form-label">연락처</label> <input type="tel"
						class="form-input" name="userPhone" placeholder="010-0000-0000"
						required>
				</div>

				<div class="form-group">
					<label class="form-label">주소</label>
					<div class="address-row">
						<input type="text" class="form-input" name="zipCode" id="zipCode"
							placeholder="우편번호" readonly>
						<button type="button" class="btn-outline" onclick="execPostcode()">번호
							찾기</button>
					</div>
					<input type="text" class="form-input" name="baseAddr" id="baseAddr"
						placeholder="기본주소" style="margin-bottom: 10px" readonly> <input
						type="text" class="form-input" name="detailAddr" id="detailAddr"
						placeholder="상세주소를 입력하세요">
				</div>

				<button type="submit" class="btn-black">가입하기</button>
			</form>

			<div class="auth-footer">
				이미 계정이 있으신가요? <a
					href="${pageContext.request.contextPath}/member/login.do"
					class="auth-link">로그인 하기</a>
			</div>
		</div>

		<p class="auth-copy">&copy; 2026 ShoeMall. All rights reserved.</p>
	</div>

	<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/KM_MS_validation.js"></script>
</body>
</html>