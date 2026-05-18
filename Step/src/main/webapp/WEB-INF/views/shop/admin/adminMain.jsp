<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
body {
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
}

.content {
	width: 98%;
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px 0;
}

.dashboard-section {
	margin-bottom: 40px;
}

.section-title {
	font-size: 18px;
	font-weight: 600;
	color: #212529;
	margin-bottom: 15px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.card-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 20px;
}

.stat-card {
	background: #fff;
	border: 1px solid #e9ecef;
	border-radius: 12px;
	padding: 24px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
	display: flex;
	align-items: center;
	justify-content: space-between;
	transition: transform 0.2s, box-shadow 0.2s;
	cursor: pointer;
}

.stat-card:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.stat-info .stat-label {
	font-size: 14px;
	color: #868e96;
	font-weight: 500;
	margin-bottom: 8px;
}

.stat-info .stat-value {
	font-size: 28px;
	font-weight: 700;
	color: #212529;
}

.stat-value span {
	font-size: 16px;
	font-weight: 500;
	color: #495057;
	margin-left: 2px;
}

.icon-box {
	width: 48px;
	height: 48px;
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 20px;
}

/* 아이콘 색상 커스텀 */
.bg-blue {
	background: #e7f5ff;
	color: #1c7ed6;
}

.bg-orange {
	background: #fff4e6;
	color: #f76707;
}

.bg-green {
	background: #e6fcf5;
	color: #0ca678;
}

.bg-red {
	background: #fff5f5;
	color: #f03e3e;
}

.bg-indigo {
	background: #edf2ff;
	color: #4263eb;
}

.bg-teal {
	background: #e6fffa;
	color: #0b7285;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
			<!-- 1. 주문 및 배송 현황 세션 -->
			<!-- 2. 상품 및 재고 관리 세션 (IN_STATUS=1 & PROD_STATUS 1~4 기반 데이터 매칭 완료) -->
			<!-- 2. 상품 및 재고 관리 세션 (IN_STATUS=1 & PROD_STATUS 1~4 매칭) -->
			<div class="dashboard-section">
				<div class="section-title">
					<i class="fa-solid fa-boxes-stacked" style="color: #495057;"></i>					
					<b>재고현황 (재고상태별 count), 배송현황 (배송상태별 count),<br> 반품/교환 현황 (반품/교환 상태별 count), 채팅현황 (처리하지 않은 또는 읽지 않은 채팅방 count)</b>
					
				</div>
				
				<div class="section-title">
				<br><b>물류 대시보드 (logis_dashForm.jsp 참조하여 작성)</b>
				</div>
				
				<div class="card-grid"
					style="grid-template-columns: repeat(2, 1fr);">
					<div class="stat-card" onclick="location.href='productList.do'">
						<div class="stat-info">
							<div class="stat-label">전체 등록 상품 수 (판매/숨김/품절/주의)</div>
							<div class="stat-value">${dashboardProductTotalCount}<span>개</span>
							</div>
						</div>
						<div class="icon-box bg-indigo">
							<i class="fa-solid fa-box"></i>
						</div>
					</div>

					<div class="stat-card" onclick="location.href='lowStockList.do'">
						<div class="stat-info">
							<div class="stat-label">품절 임박 상품 (재고 5개 미만)</div>
							<div class="stat-value" style="color: #f03e3e;">${lowStockCount}<span>개</span>
							</div>
						</div>
						<div class="icon-box bg-teal">
							<i class="fa-solid fa-triangle-exclamation"></i>
						</div>
					</div>
				</div>
			</div>

			<!-- 2. 상품 및 재고 관리 세션 (IN_STATUS=2 기반 데이터 매칭 완료) -->
			<div class="dashboard-section">
				<div class="section-title">
					<i class="fa-solid fa-boxes-stacked" style="color: #495057;"></i>
					상품 및 재고 현황 (입고완료 기준)
				</div>
				<div class="card-grid"
					style="grid-template-columns: repeat(2, 1fr);">
					<div class="stat-card" onclick="location.href='productList.do'">
						<div class="stat-info">
							<div class="stat-label">전체 등록 상품 수 (판매/숨김/품절/주의 포함)</div>
							<div class="stat-value">${dashboardProductTotalCount}<span>개</span>
							</div>
						</div>
						<div class="icon-box bg-indigo">
							<i class="fa-solid fa-box"></i>
						</div>
					</div>

					<div class="stat-card" onclick="location.href='lowStockList.do'">
						<div class="stat-info">
							<div class="stat-label">품절 임박 상품 (재고 5개 미만)</div>
							<div class="stat-value" style="color: #f03e3e;">${lowStockCount}<span>개</span>
							</div>
						</div>
						<div class="icon-box bg-teal">
							<i class="fa-solid fa-triangle-exclamation"></i>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>