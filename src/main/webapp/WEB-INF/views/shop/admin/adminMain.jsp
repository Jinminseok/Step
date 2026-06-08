<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall 어드민 - 대시보드</title>
<link
	href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
*, *::before, *::after {
	box-sizing: border-box;
}

body {
	background-color: #f4f6f8;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
	overflow-y: scroll;
}

.main {
	margin-left: 260px;
	padding: 30px;
	min-height: 100vh;
}

.content-wrapper {
	max-width: 1400px;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	gap: 24px;
}

.summary-container {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	background: #fff;
	border: 1px solid #e2e6ee;
	border-radius: 4px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
}

.summary-item {
	padding: 24px;
	border-right: 1px solid #e2e6ee;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.summary-item:last-child {
	border-right: none;
}

.summary-title {
	font-size: 13px;
	font-weight: 600;
	color: #666;
	margin-bottom: 12px;
}

.summary-value {
	font-size: 28px;
	font-weight: 700;
	letter-spacing: -0.5px;
	margin-bottom: 12px;
}

.summary-value .unit {
	font-size: 18px;
	font-weight: 600;
	margin-left: 4px;
}

.summary-desc {
	font-size: 12px;
	font-weight: 500;
}

.text-blue {
	color: #3b82f6;
}

.text-red {
	color: #ef4444;
}

.text-gray {
	color: #888;
}

.text-black {
	color: #111;
}

.chart-container {
	display: grid;
	grid-template-columns: 3fr 2fr;
	gap: 24px;
}

.chart-card {
	background: #fff;
	border: 1px solid #e2e6ee;
	border-radius: 4px;
	padding: 24px;
}

.chart-header {
	font-size: 15px;
	font-weight: 700;
	margin-bottom: 24px;
	color: #111;
}

.bar-row {
	display: flex;
	align-items: center;
	margin-bottom: 16px;
	gap: 16px;
}

.bar-label {
	width: 60px;
	font-size: 13px;
	color: #555;
	text-align: right;
}

.bar-track {
	flex: 1;
	height: 24px;
	background: #f1f3f5;
	border-radius: 2px;
	overflow: hidden;
	position: relative;
}

.bar-fill {
	height: 100%;
	background: #111;
	display: flex;
	align-items: center;
	padding-left: 8px;
	color: #fff;
	font-size: 11px;
	font-weight: 600;
}

.bar-fill.current {
	background: #ef4444;
}

.bar-value {
	width: 40px;
	font-size: 12px;
	color: #999;
}

.table-card {
	background: #fff;
	border: 1px solid #e2e6ee;
	border-radius: 4px;
	padding: 24px;
}

.table-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.table-title {
	font-size: 15px;
	font-weight: 700;
}

.btn-more {
	font-size: 12px;
	color: #333;
	text-decoration: none;
	border: 1px solid #ddd;
	padding: 6px 12px;
	border-radius: 4px;
}

.btn-more:hover {
	background: #f9f9f9;
}

.order-table {
	width: 100%;
	border-collapse: collapse;
}

.order-table th {
	text-align: left;
	font-size: 13px;
	color: #666;
	font-weight: 600;
	padding: 12px 8px;
	border-bottom: 1px solid #e2e6ee;
}

.order-table td {
	padding: 16px 8px;
	font-size: 13px;
	color: #333;
	border-bottom: 1px solid #f1f3f5;
	vertical-align: middle;
}

.order-table tr:last-child td {
	border-bottom: none;
}

.badge {
	display: inline-block;
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: 600;
}

.badge-pay {
	background: #fff0ed;
	color: #ff5722;
	border: 1px solid #ffccbc;
}

.badge-shipping {
	background: #e3f2fd;
	color: #1e88e5;
	border: 1px solid #bbdefb;
}

.badge-done {
	background: #e8f5e9;
	color: #43a047;
	border: 1px solid #c8e6c9;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<div class="content-wrapper">

			<div class="summary-container">
				<div class="summary-item">
					<div class="summary-title">오늘 매출</div>
					<div class="summary-value text-black">
						₩
						<fmt:formatNumber value="${todaySalesAmount}" pattern="#,###" />
					</div>
					<div class="summary-desc text-blue">결제완료 기준 합계</div>
				</div>

				<div class="summary-item">
					<div class="summary-title">오늘 주문</div>
					<div class="summary-value text-blue">${todayOrderCount}<span
							class="unit">건</span>
					</div>
					<div class="summary-desc text-gray">당일 접수 주문</div>
				</div>

				<div class="summary-item">
					<div class="summary-title">취소/반품 요청</div>
					<div class="summary-value text-red">${cancelRequestCount}<span
							class="unit">건</span>
					</div>
					<div class="summary-desc text-red">처리 대기 중</div>
				</div>

				<div class="summary-item">
					<div class="summary-title">재고 부족 (5개 미만)</div>
					<div class="summary-value text-red">${lowStockCount}<span
							class="unit">개</span>
					</div>
					<div class="summary-desc text-red">즉시 입고 요망</div>
				</div>

				<div class="summary-item">
					<div class="summary-title">신규 회원</div>
					<div class="summary-value text-black">${todayNewUserCount}<span
							class="unit">명</span>
					</div>
					<div class="summary-desc text-gray">당일 가입 기준</div>
				</div>
			</div>

			<div class="chart-container">
				<div class="chart-card">
					<div class="chart-header">최근 4개월 쇼핑몰 매출</div>
					<div class="bar-wrapper">
						<c:choose>
							<c:when test="${not empty monthlySales}">
								<c:forEach var="item" items="${monthlySales}" varStatus="status">
									<div class="bar-row">
										<div class="bar-label">
											<c:out value="${item.MONTH}" />
											월
										</div>
										<div class="bar-track">
											<div class="bar-fill ${status.last ? 'current' : ''}"
												style="width: ${(item.SALES / maxSales) * 100}%;">
												₩
												<fmt:formatNumber value="${item.SALES}" pattern="#,###" />
											</div>
										</div>
										<div class="bar-value">
											₩
											<fmt:formatNumber value="${item.SALES}" pattern="#,###" />
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div style="text-align: center; color: #999; padding: 40px 0;">매출
									데이터가 없습니다.</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="chart-card">
					<div class="chart-header">인기 상품 TOP 4</div>
					<div class="bar-wrapper">
						<c:choose>
							<c:when test="${not empty topProducts}">
								<c:forEach var="item" items="${topProducts}" varStatus="status">
									<div class="bar-row">
										<div class="bar-label"
											style="width: 100px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
											<c:out value="${item.PROD_NAME}" />
										</div>
										<div class="bar-track">
											<div class="bar-fill"
												style="width: ${(item.SALES_COUNT / maxTopCount) * 100}%; background: ${status.index >= 2 ? '#666' : '#111'};">
												<fmt:formatNumber value="${item.SALES_COUNT}"
													pattern="#,###" />
												건
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div style="text-align: center; color: #999; padding: 40px 0;">판매
									데이터가 없습니다.</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>

			<div class="table-card">
				<div class="table-header">
					<div class="table-title">최근 주문 목록</div>
					<a
						href="${pageContext.request.contextPath}/shop/admin_order/adminorderForm.do"
						class="btn-more">전체 보기 &rarr;</a>
				</div>
				<table class="order-table">
					<thead>
						<tr>
							<th>주문번호</th>
							<th>회원 아이디</th>
							<th>상품명</th>
							<th>결제금액</th>
							<th>상태</th>
							<th>주문일시</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty recentOrders}">
								<c:forEach var="order" items="${recentOrders}">
									<tr>
										<td>#<c:out value="${order.ORDER_NUM}" /></td>
										<td><c:out value="${order.USER_ID}" /></td>
										<td><c:out value="${order.PROD_NAME}" /></td>
										<td>₩<fmt:formatNumber value="${order.PAY_PRICE}"
												pattern="#,###" /></td>
										<td><c:choose>
												<c:when test="${order.ORDER_STATUS == 1}">
													<span class="badge badge-pay">결제대기</span>
												</c:when>
												<c:when test="${order.ORDER_STATUS == 2}">
													<span class="badge badge-shipping">배송준비</span>
												</c:when>
												<c:when test="${order.ORDER_STATUS == 3}">
													<span class="badge badge-shipping">배송중</span>
												</c:when>
												<c:when test="${order.ORDER_STATUS == 4}">
													<span class="badge badge-done">배송완료</span>
												</c:when>
												<c:when test="${order.ORDER_STATUS == 5}">
													<span class="badge"
														style="background: #fff0ed; color: #ef4444; border: 1px solid #fca5a5;">취소요청</span>
												</c:when>
												<c:otherwise>
													<span class="badge"
														style="background: #f1f3f5; color: #666; border: 1px solid #ddd;">취소/기타</span>
												</c:otherwise>
											</c:choose></td>
										<td><fmt:formatDate value="${order.ORDER_DATE}"
												pattern="yyyy-MM-dd HH:mm" /></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="6" style="text-align: center; padding: 30px;">최근
										주문 내역이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

		</div>
	</div>

</body>
</html>