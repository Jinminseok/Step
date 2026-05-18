<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall 어드민 - 대시보드</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
/* --- 🚨 핵심 디테일 수정: 모든 요소의 테두리/여백을 너비에 포함 --- */
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body {
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
	overflow-y: scroll; /* 🚨 핵심 디테일: 페이지 전환 시 스크롤바 밀림 방지 */
}

/* 👇 사이드바 너비만큼 본문을 완벽히 밀어줍니다 */
.main {
    margin-left: 260px; 
    padding: 30px;
    box-sizing: border-box;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.content {
	flex: 1;
	width: 100%;
	max-width: 1200px;
	margin: 0 auto;
}

/* DASHBOARD SECTION */
.dashboard-section {
	margin-bottom: 32px;
}

.section-title {
	font-size: 16px;
	font-weight: 700;
	color: #475569;
	margin-bottom: 16px;
	display: flex;
	align-items: center;
	gap: 8px;
	text-transform: uppercase;
	letter-spacing: -0.3px;
}
.section-title i {
	font-size: 16px;
	color: #64748b;
}

/* CARD GRID LAYOUT */
.card-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr); /* 2열 고정 그리드 정렬 */
	gap: 24px;
}

/* PREMIUM STAT CARD */
.stat-card {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 14px;
	padding: 24px 28px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02), 0 2px 4px -1px rgba(0, 0, 0, 0.01);
	display: flex;
	align-items: center;
	justify-content: space-between;
	transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
	cursor: pointer;
}

.stat-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 12px 20px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02);
	border-color: #cbd5e1;
}

.stat-info {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.stat-info .stat-label {
	font-size: 14px;
	color: #64748b;
	font-weight: 600;
	letter-spacing: -0.2px;
}

.stat-info .stat-value {
	font-family: 'Space Grotesk', sans-serif;
	font-size: 32px;
	font-weight: 700;
	color: #0f172a;
	line-height: 1;
}

.stat-value span {
	font-size: 15px;
	font-weight: 500;
	color: #475569;
	margin-left: 4px;
	font-family: 'Pretendard', sans-serif;
}

/* MODERN ICON CONTAINER */
.icon-box {
	width: 54px;
	height: 54px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 22px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.01);
}

/* THEME ACCENT COLORS */
.bg-indigo {
	background: #f0f5ff;
	color: #2563eb;
}
.bg-teal {
	background: #f0fdf4;
	color: #16a34a;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<c:set var="pageTitle" value="통계 / 대시보드" scope="request" />
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
			
			<div class="dashboard-section">
				<div class="section-title">
					<i class="fa-solid fa-boxes-stacked"></i>
					상품 및 재고 현황 (입고완료 기준)
				</div>
				<div class="card-grid">
					<div class="stat-card" onclick="location.href='productList.do'">
						<div class="stat-info">
							<div class="stat-label">전체 등록 상품 수 (판매/숨김/품절/주의)</div>
							<div class="stat-value">${dashboardProductTotalCount}<span>개</span></div>
						</div>
						<div class="icon-box bg-indigo">
							<i class="fa-solid fa-box"></i>
						</div>
					</div>

					<div class="stat-card" onclick="location.href='lowStockList.do'">
						<div class="stat-info">
							<div class="stat-label">품절 임박 상품 (재고 5개 미만)</div>
							<div class="stat-value" style="color: #ef4444;">${lowStockCount}<span>개</span></div>
						</div>
						<div class="icon-box bg-teal">
							<i class="fa-solid fa-triangle-exclamation" style="color: #ea580c;"></i>
						</div>
					</div>
				</div>
			</div>

			<div class="dashboard-section">
				<div class="section-title">
					<i class="fa-solid fa-layer-group"></i>
					물류 연동 현황 (가용고 기준)
				</div>
				<div class="card-grid">
					<div class="stat-card" onclick="location.href='productList.do'">
						<div class="stat-info">
							<div class="stat-label">전체 등록 상품 수 (판매/숨김/품절/주의 포함)</div>
							<div class="stat-value">${dashboardProductTotalCount}<span>개</span></div>
						</div>
						<div class="icon-box bg-indigo">
							<i class="fa-solid fa-boxes-packing"></i>
						</div>
					</div>

					<div class="stat-card" onclick="location.href='lowStockList.do'">
						<div class="stat-info">
							<div class="stat-label">품절 임박 상품 (재고 5개 미만)</div>
							<div class="stat-value" style="color: #ef4444;">${lowStockCount}<span>개</span></div>
						</div>
						<div class="icon-box bg-teal">
							<i class="fa-solid fa-triangle-exclamation" style="color: #ea580c;"></i>
						</div>
					</div>
				</div>
			</div>
			
		</div>
	</div>

</body>
</html>