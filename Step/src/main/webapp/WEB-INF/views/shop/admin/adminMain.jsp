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
<style type="text/css">
.dashboard-container {
	padding: 24px;
	background-color: #f8f9fa;
	min-height: 100vh;
}

.section-title {
	font-size: 18px;
	font-weight: 700;
	color: #222;
	margin-bottom: 16px;
	display: flex;
	align-items: center;
	gap: 8px;
}
/* 오늘의 할 일 컨테이너 */
.todo-container {
	background: #fff;
	border-radius: 12px;
	padding: 24px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	margin-bottom: 24px;
}

.todo-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 16px;
}

.todo-item {
	background: #fdfdfd;
	border: 1px solid #eaeaea;
	border-radius: 8px;
	padding: 20px;
	text-align: center;
	cursor: pointer;
	transition: all 0.2s ease;
}

.todo-item:hover {
	transform: translateY(-3px);
	border-color: #4a90e2;
	box-shadow: 0 4px 12px rgba(74, 144, 226, 0.1);
}

.todo-label {
	font-size: 14px;
	color: #666;
	margin-bottom: 8px;
}

.todo-count {
	font-size: 28px;
	font-weight: 700;
	color: #222;
}

.todo-count.highlight {
	color: #e74c3c;
}
/* 하단 요약 인포 바 */
.info-summary-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 16px;
}

.info-card {
	background: #fff;
	border-radius: 12px;
	padding: 20px 24px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.info-text .info-title {
	font-size: 14px;
	color: #888;
	margin-bottom: 4px;
}

.info-text .info-value {
	font-size: 22px;
	font-weight: 700;
	color: #333;
}

.info-icon {
	width: 48px;
	height: 48px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 20px;
}
</style>
<script type="text/javascript">
	function goMenu(target) {
		if (target === 'order') {
			// [수정] 요청한 경로인 /shop/admin_order/adminorderForm.do 로 변경함
			location.href = '${pageContext.request.contextPath}/shop/admin_order/adminorderForm.do';
		} else if (target === 'product') {
			location.href = '${pageContext.request.contextPath}/shop/admin/productList.do';
		}
	}
</script>
</head>
<body>
	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="dashboard-container">
			<div class="todo-container">
				<div class="section-title">
					<i class="fa-solid fa-clipboard-list" style="color: #4a90e2;"></i>
					오늘의 할 일
				</div>
				<div class="todo-grid">
					<div class="todo-item" onclick="goMenu('order')">
						<div class="todo-label">신규 주문</div>
						<div class="todo-count highlight">
							<fmt:formatNumber value="${todayOrderCount}" pattern="#,###" />
						</div>
					</div>
					<div class="todo-item" onclick="goMenu('order')">
						<div class="todo-label">결제 대기</div>
						<div class="todo-count">
							<fmt:formatNumber value="${pendingPaymentCount}" pattern="#,###" />
						</div>
					</div>
					<div class="todo-item" onclick="goMenu('order')">
						<div class="todo-label">배송 준비중</div>
						<div class="todo-count">
							<fmt:formatNumber value="${readyForShippingCount}"
								pattern="#,###" />
						</div>
					</div>
					<div class="todo-item" onclick="goMenu('order')">
						<div class="todo-label">취소/반품 요청</div>
						<div class="todo-count">
							<fmt:formatNumber value="${cancelRequestCount}" pattern="#,###" />
						</div>
					</div>
				</div>
			</div>

			<div class="section-title">
				<i class="fa-solid fa-chart-pie" style="color: #2ecc71;"></i> 시스템 운영
				현황
			</div>
			<div class="info-summary-grid">
				<div class="info-card" onclick="goMenu('product')"
					style="cursor: pointer;">
					<div class="info-text">
						<div class="info-title">마스터 등록 상품 수</div>
						<div class="info-value">
							<fmt:formatNumber value="${totalProductCount}" pattern="#,###" />
							개
						</div>
					</div>
					<div class="info-icon" style="background: #e8f4fd; color: #4a90e2;">
						<i class="fa-solid fa-box"></i>
					</div>
				</div>

				<div class="info-card" onclick="goMenu('product')"
					style="cursor: pointer;">
					<div class="info-text">
						<div class="info-title">품절 위험 품목 (재고 5개 미만)</div>
						<div class="info-value" style="color: #e74c3c;">
							<fmt:formatNumber value="${lowStockCount}" pattern="#,###" />
							개
						</div>
					</div>
					<div class="info-icon" style="background: #fdf2f2; color: #e74c3c;">
						<i class="fa-solid fa-triangle-exclamation"></i>
					</div>
				</div>
			</div>

		</div>
	</div>
</body>
</html>