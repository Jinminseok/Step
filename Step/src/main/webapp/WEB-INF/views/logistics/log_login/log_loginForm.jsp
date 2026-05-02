<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    // 로그인 에러 메시지 처리용 변수
    String loginError = (String) request.getAttribute("loginError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Step WMS — 물류 담당자 로그인</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap"
	rel="stylesheet">

<!-- 물류 전용 CSS (피그마 디자인 스타일) -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

	<!-- ══ 탑 헤더 ══════════════════════════════════════ -->
	<header class="log-top-header">
		<div class="log-logo">
			<div class="log-logo-mark">S</div>
			<div class="log-logo-name">
				Step<span>WMS</span>
			</div>
			<div class="log-logo-sub">Warehouse Management System</div>
		</div>
	</header>

	<!-- ══ 메인 영역 ═════════════════════════════════════ -->
	<div class="log-main">

		<!-- ─── 왼쪽 소개 패널 (피그마 디자인 유지) ────────────── -->
		<div class="log-left">
			<div class="log-left-bg"></div>
			<div class="log-left-grid"></div>
			<div class="log-left-content">

				<div class="log-sys-badge">
					<div class="log-badge-pulse"></div>
					<div class="log-badge-txt">실시간 운영 중</div>
				</div>

				<h1 class="log-left-title">
					신발 물류<br> <span class="log-accent">통합 관리 시스템</span>
				</h1>
				<p class="log-left-desc">
					입고부터 출고, 재고 현황, 반품 처리까지<br> 신발 물류 전 과정을 하나의 플랫폼에서.
				</p>

				<div class="log-feat-list">
					<div class="log-feat-item">
						<div class="log-feat-ico">📥</div>
						<div class="log-feat-txt">
							<strong>입고 관리</strong> <span>상품·사이즈·컬러별 입고 처리 및 이력 추적</span>
						</div>
					</div>
					<div class="log-feat-item">
						<div class="log-feat-ico">📤</div>
						<div class="log-feat-txt">
							<strong>출고 / 배송 관리</strong> <span>주문 연동 자동 출고, 송장 등록, 배송
								상태 추적</span>
						</div>
					</div>
					<div class="log-feat-item">
						<div class="log-feat-ico">📊</div>
						<div class="log-feat-txt">
							<strong>실시간 재고 현황</strong> <span>사이즈·컬러별 재고 수량, 부족 알림, 조정
								이력</span>
						</div>
					</div>
					<div class="log-feat-item">
						<div class="log-feat-ico">↩️</div>
						<div class="log-feat-txt">
							<strong>반품 / 교환 처리</strong> <span>반품 검수, 양품·불량 구분, 재고 복구
								자동화</span>
						</div>
					</div>
				</div>

			</div>
		</div>

		<!-- ─── 오른쪽 로그인 폼 ─────────────────────── -->
		<div class="log-right">
			<div class="log-right-top">
				<div class="log-right-top-ico">🔒</div>
				<div class="log-right-top-txt">물류 담당자 전용</div>
			</div>

			<div class="log-form-wrap">
				<div class="log-form-title">로그인</div>
				<div class="log-form-sub">
					물류 전용 계정으로 로그인하세요.<br> 쇼핑몰 관리자·사용자 계정과 별도로 운영됩니다.
				</div>

				<% if (loginError != null) { %>
				<script>
       			 alert('<%= loginError %>');
    			</script>
				<% } %>


				<form
					action="${pageContext.request.contextPath}/logistics/log_login/log_login.do"
					method="post" id="login_form">

					<div class="log-field">
						<label class="log-field-label" for="id">담당자 아이디</label>
						<div class="log-field-wrap">
							<span class="log-field-ico">👤</span>
							<!-- 기능 유지: name="id", id="id" -->
							<input class="log-field-input" type="text" name="id" id="id"
								placeholder="아이디를 입력하세요" required>
						</div>
					</div>

					<div class="log-field">
						<label class="log-field-label" for="passwd">비밀번호</label>
						<div class="log-field-wrap">
							<span class="log-field-ico" id="logPwdToggle"
								style="cursor: pointer" title="비밀번호 표시">🔑</span>
							<!-- 기능 유지: name="passwd", id="passwd" -->
							<input class="log-field-input" type="password" name="passwd"
								id="passwd" placeholder="비밀번호를 입력하세요" required>
						</div>
					</div>

					<div class="log-form-row">
						<label class="log-check-label"> <input type="checkbox"
							name="rememberMe"> 로그인 상태 유지
						</label> <span class="log-forgot">비밀번호 찾기</span>
					</div>

					<!-- 기능 유지: type="submit" -->
					<button type="submit" class="log-btn-login">로그인</button>

					<!-- 기능 유지: 회원가입 링크 연동 -->
					<div
						style="text-align: center; font-size: 13px; color: #94A3B8; margin-top: 15px;">
						아직 회원이 아니신가요? <a
							href="${pageContext.request.contextPath}/shop/user/registerForm.do"
							style="color: #1D6FE4; text-decoration: none; font-weight: 600;">회원가입</a>
					</div>

				</form>


			</div>
		</div>
	</div>

	<!-- JS -->
	<script src="${pageContext.request.contextPath}/js/logis_login.js"></script>

</body>
</html>