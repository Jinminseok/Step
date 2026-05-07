<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&display=swap"
	rel="stylesheet">
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
			<div class="nav-item active"
				onclick="location.href='${pageContext.request.contextPath}/shop/main/main.do'">
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

	<main class="main">
		<div class="topbar">
			<div class="topbar-title">Dashboard Overview</div>
		</div>

		<div class="content">
			<div class="page-hdr">
				<div>
					<h1 class="page-hdr-title">통계 개요</h1>
					<p style="color: #999; font-size: 12px; margin-top: 4px;">실시간
						판매 및 운영 현황</p>
				</div>
			</div>

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

			<div class="page-hdr" style="margin-top: 40px;">
				<h2 class="page-hdr-title" style="font-size: 18px;">최근 등록 상품
					(8개)</h2>
			</div>
			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th>상품번호</th>
							<th>이미지</th>
							<th>브랜드</th>
							<th>상품명</th>
							<th>판매가</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty productList}">
							<tr>
								<td colspan="6" style="text-align: center;">등록된 상품이 없습니다.</td>
							</tr>
						</c:if>
						<c:forEach var="item" items="${productList}">
							<tr>
								<td>${item.prodNum}</td>
								<td><c:if test="${not empty item.mainImgUrl}">
										<img
											src="${pageContext.request.contextPath}/upload/${item.mainImgUrl}"
											width="50" style="border-radius: 4px;">
									</c:if></td>
								<td>${item.brandName}</td>
								<td style="text-align: left; font-weight: bold;">${item.prodName}</td>
								<td><fmt:formatNumber value="${item.prodPrice}"
										pattern="#,###" />원</td>
								<td>
									<button class="logout-btn"
										style="padding: 4px 8px; font-size: 11px;"
										onclick="location.href='detail.do?prod_num=${item.prodNum}'">상세보기</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</main>
</body>
</html>