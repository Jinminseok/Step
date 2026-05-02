<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin</title>
<!-- CSS 경로에 컨텍스트 패스 적용 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&display=swap"
	rel="stylesheet">
</head>
<body>

	<!-- ═════════ SIDEBAR ═════════ -->
	<aside class="sidebar">
		<div class="sb-logo">
			<div class="sb-logo-mark">A</div>
			<div>
				<div class="sb-logo-txt">
					Shoe<span>Mall</span>
				</div>
				<div class="sb-logo-badge">Admin Panel</div>
			</div>
		</div>

		<nav class="nav">
			<div class="nav-section">대시보드</div>
			<div class="nav-item active"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/main.do'">
				<span class="nav-icon">📊</span>통계 / 대시보드
			</div>

			<div class="nav-section">상품</div>
			<div class="nav-item"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/productList.do'">
				<span class="nav-icon">👟</span>상품 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">🏷️</span>카테고리 관리
			</div>

			<div class="nav-section">재고 / 물류</div>
			<div class="nav-item">
				<span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span>
			</div>
			<div class="nav-item">
				<span class="nav-icon">🧾</span>주문 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">🚚</span>배송 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">↩️</span>반품/교환 관리
			</div>

			<div class="nav-section">고객</div>
			<div class="nav-item">
				<span class="nav-icon">👤</span>회원 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">🎫</span>쿠폰 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">💬</span>채팅 문의<span class="nav-badge">3</span>
			</div>
		</nav>

		<div class="sb-footer">
			<div class="admin-row">
				<div class="admin-av">관</div>
				<div>
					<div class="admin-name">최슈퍼</div>
					<div class="admin-role">super admin</div>
				</div>
				<div class="logout-btn">로그아웃</div>
			</div>
		</div>
	</aside>

	<!-- ═════════ MAIN ═════════ -->
	<main class="main">
		<div class="topbar">
			<div class="topbar-title">Dashboard Overview</div>
		</div>

		<div class="content">
			<!-- ✅ '신규 상품 등록' 버튼이 삭제된 헤더 영역 -->
			<div class="page-hdr">
				<div>
					<h1 class="page-hdr-title">통계 개요</h1>
					<p style="color: #999; font-size: 12px; margin-top: 4px;">실시간
						판매 및 운영 현황</p>
				</div>
			</div>

			<!-- 요약 카드 섹션 -->
			<div class="stats-row">
				<div class="stat-card">
					<div class="stat-label">오늘의 매출</div>
					<div class="stat-val">₩ 1,240,000</div>
				</div>
				<div class="stat-card">
					<div class="stat-label">신규 주문</div>
					<div class="stat-val">12 건</div>
				</div>
				<div class="stat-card">
					<div class="stat-label">문의 사항</div>
					<div class="stat-val" style="color: var(--red)">3 건</div>
				</div>
				<div class="stat-card">
					<div class="stat-label">재고 부족</div>
					<div class="stat-val" style="color: var(--orange)">5 개</div>
				</div>
			</div>

			<!-- 최근 주문 테이블 -->
			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th>주문번호</th>
							<th>고객명</th>
							<th>상품명</th>
							<th>결제금액</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>#20260502-01</td>
							<td>김철수</td>
							<td>나이키 에어포스 1</td>
							<td>₩ 139,000</td>
							<td><span style="color: var(--blue)">배송중</span></td>
						</tr>
						<tr>
							<td>#20260502-02</td>
							<td>이영희</td>
							<td>아디다스 슈퍼스타</td>
							<td>₩ 109,000</td>
							<td><span>결제완료</span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</main>

</body>
</html>