<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script type="text/javascript">
	function go(menu) {
		if (menu === 'dashboard')
			location.href = 'main.do';
		else if (menu === 'product')
			location.href = 'productList.do';
		else
			alert('준비 중인 메뉴임');
	}
</script>
</head>
<body>

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
			<div class="nav-item active" onclick="go('dashboard')">
				<span class="nav-icon">📊</span>통계 / 대시보드
			</div>

			<div class="nav-section">상품</div>
			<div class="nav-item" onclick="go('product')">
				<span class="nav-icon">👟</span>상품 관리
			</div>
			<div class="nav-item" onclick="go('category')">
				<span class="nav-icon">🏷️</span>카테고리 관리
			</div>

			<div class="nav-section">재고 / 물류</div>
			<div class="nav-item" onclick="go('stock')">
				<span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span>
			</div>
			<div class="nav-item" onclick="go('order')">
				<span class="nav-icon">🧾</span>주문 관리
			</div>

			<div class="nav-section">고객</div>
			<div class="nav-item" onclick="go('member')">
				<span class="nav-icon">👤</span>회원 관리
			</div>
			<div class="nav-item" onclick="go('chat')">
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
				<div class="logout-btn"
					onclick="location.href='${pageContext.request.contextPath}/member/logout.do'">로그아웃</div>
			</div>
		</div>
	</aside>

	<div class="main">
		<header class="topbar">
			<div class="breadcrumb">Admin > Dashboard</div>
		</header>

		<main class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">쇼핑몰 운영 현황</h1>
			</div>

			<!-- 요약 통계 카드 영역 -->
			<div class="stats-row"
				style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
				<div class="stat-card"
					style="background: #fff; padding: 25px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-left: 5px solid var(--blue);">
					<div class="stat-label" style="color: #888; font-size: 0.9em;">전체
						등록 상품</div>
					<div class="stat-val"
						style="font-size: 1.8em; font-weight: bold; margin-top: 10px;">
						<fmt:formatNumber value="${totalProductCount}" pattern="#,###" />
						<span style="font-size: 0.6em;">건</span>
					</div>
				</div>
				<div class="stat-card"
					style="background: #fff; padding: 25px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-left: 5px solid var(--red);">
					<div class="stat-label" style="color: #888; font-size: 0.9em;">오늘
						신규 주문</div>
					<div class="stat-val"
						style="font-size: 1.8em; font-weight: bold; margin-top: 10px;">
						0 <span style="font-size: 0.6em;">건</span>
					</div>
				</div>
				<div class="stat-card"
					style="background: #fff; padding: 25px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-left: 5px solid var(--orange);">
					<div class="stat-label" style="color: #888; font-size: 0.9em;">결제
						대기중</div>
					<div class="stat-val"
						style="font-size: 1.8em; font-weight: bold; margin-top: 10px;">
						0 <span style="font-size: 0.6em;">건</span>
					</div>
				</div>
				<div class="stat-card"
					style="background: #fff; padding: 25px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border-left: 5px solid #333;">
					<div class="stat-label" style="color: #888; font-size: 0.9em;">품절
						임박(5개 미만)</div>
					<div class="stat-val"
						style="font-size: 1.8em; font-weight: bold; margin-top: 10px;">
						0 <span style="font-size: 0.6em;">건</span>
					</div>
				</div>
			</div>

			<!-- 퀵 메뉴 -->
			<div class="quick-access"
				style="background: #f9f9f9; padding: 30px; border-radius: 15px;">
				<h3 style="margin-bottom: 20px;">주요 기능 바로가기</h3>
				<div style="display: flex; gap: 15px;">
					<button class="btn btn-black" style="padding: 15px 30px;"
						onclick="location.href='productList.do'">상품 관리하기</button>
					<button class="btn btn-outline" style="padding: 15px 30px;"
						onclick="location.href='productInsert.do'">신규 상품 등록</button>
					<button class="btn btn-outline" style="padding: 15px 30px;">배송
						상태 업데이트</button>
				</div>
			</div>
		</main>
	</div>

</body>
</html>