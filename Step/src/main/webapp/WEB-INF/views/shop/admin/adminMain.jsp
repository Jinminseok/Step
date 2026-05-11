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
	// 메뉴 이동 함수
	function go(menu, obj) {
		if (menu === 'dashboard')
			location.href = 'main.do';
		else if (menu === 'product')
			location.href = 'productList.do';
		// 추가 메뉴들에 대한 경로 설정 필요
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
			<div class="nav-item active" onclick="go('dashboard',this)">
				<span class="nav-icon">📊</span>통계 / 대시보드
			</div>

			<div class="nav-section">상품</div>
			<div class="nav-item" onclick="go('product',this)">
				<span class="nav-icon">👟</span>상품 관리
			</div>
			<div class="nav-item" onclick="go('category',this)">
				<span class="nav-icon">🏷️</span>카테고리 관리
			</div>

			<div class="nav-section">재고 / 물류</div>
			<div class="nav-item" onclick="go('stock',this)">
				<span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span>
			</div>
			<div class="nav-item" onclick="go('order',this)">
				<span class="nav-icon">🧾</span>주문 관리
			</div>
			<div class="nav-item" onclick="go('delivery',this)">
				<span class="nav-icon">🚚</span>배송 관리
			</div>
			<div class="nav-item" onclick="go('return',this)">
				<span class="nav-icon">↩️</span>반품/교환 관리
			</div>

			<div class="nav-section">고객</div>
			<div class="nav-item" onclick="go('member',this)">
				<span class="nav-icon">👤</span>회원 관리
			</div>
			<div class="nav-item" onclick="go('coupon',this)">
				<span class="nav-icon">🎫</span>쿠폰 관리
			</div>
			<div class="nav-item" onclick="go('chat',this)">
				<span class="nav-icon">💬</span>채팅 문의<span class="nav-badge">3</span>
			</div>

			<div class="nav-section">운영</div>
			<div class="nav-item" onclick="go('banner',this)">
				<span class="nav-icon">🖼️</span>UI / 배너 관리
			</div>
			<div class="nav-item" onclick="go('store',this)">
				<span class="nav-icon">🗺️</span>매장 정보 관리
			</div>
			<div class="nav-item" onclick="go('notify',this)">
				<span class="nav-icon">🔔</span>알림 발송 관리
			</div>
		</nav>
		<div class="sb-footer">
			<div class="admin-row">
				<div class="admin-av">관</div>
				<div>
					<div class="admin-name">최슈퍼</div>
					<div class="admin-role">super admin</div>
				</div>
				<div class="logout-btn" onclick="location.href='logout.do'">로그아웃</div>
			</div>
		</div>
	</aside>

	<div class="main">
		<header class="topbar">
			<div class="breadcrumb">Admin > Dashboard</div>
		</header>

		<main class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">상품 관리 현황</h1>
				<button class="btn btn-black"
					onclick="location.href='productWrite.do'">상품 등록</button>
			</div>

			<div class="stats-row">
				<div class="stat-card">
					<div class="stat-label">전체 상품</div>
					<div class="stat-val">${count}건</div>
				</div>
			</div>

			<div class="search-area" style="margin-bottom: 20px;">
				<form action="main.do" method="get" id="search_form"
					style="display: flex; gap: 10px;">
					<select name="search_type" class="input-select">
						<option value="prod_name"
							<c:if test="${param.search_type == 'prod_name'}">selected</c:if>>상품명</option>
						<option value="sku"
							<c:if test="${param.search_type == 'sku'}">selected</c:if>>SKU(품번)</option>
					</select> <input type="text" name="keyword" value="${param.keyword}"
						class="input-txt" placeholder="검색어 입력">
					<button type="submit" class="btn btn-outline">검색</button>
				</form>
			</div>

			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>이미지</th>
							<th>상품명(SKU)</th>
							<th>카테고리/브랜드</th>
							<th>가격</th>
							<th>상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${count == 0}">
							<tr>
								<td colspan="7" style="text-align: center; padding: 40px 0;">등록된
									상품이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${count > 0}">
							<c:forEach var="product" items="${list}">
								<tr>
									<td>${product.prod_num}</td>
									<td><c:if test="${!empty product.prod_img_url}">
											<img
												src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
												width="50" height="50"
												style="object-fit: cover; border-radius: 4px;">
										</c:if> <c:if test="${empty product.prod_img_url}">
											<div
												style="width: 50px; height: 50px; background: #eee; display: inline-block; line-height: 50px; font-size: 10px; color: #999;">No
												Img</div>
										</c:if></td>
									<td style="text-align: left;"><b>${product.prod_name}</b><br>
										<span style="font-size: 0.85em; color: #888;">${product.sku}</span>
									</td>
									<td>${product.cat_name}/${product.brand_name}</td>
									<td><fmt:formatNumber value="${product.prod_price}"
											pattern="#,###" />원 <c:if test="${product.sale_rate > 0}">
											<div style="color: var(--red); font-size: 0.8em;">-${product.sale_rate}%</div>
										</c:if></td>
									<td><c:choose>
											<c:when test="${product.prod_status == 1}">
												<span style="color: var(--blue);">판매중</span>
											</c:when>
											<c:when test="${product.prod_status == 2}">
												<span style="color: var(--orange);">품절</span>
											</c:when>
											<c:otherwise>
												<span style="color: #999;">숨김</span>
											</c:otherwise>
										</c:choose></td>
									<td>
										<button class="btn btn-outline"
											onclick="location.href='productUpdate.do?prod_num=${product.prod_num}'">수정</button>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
			</div>

			<div class="paging-area"
				style="text-align: center; margin-top: 30px;">${page}</div>
		</main>
	</div>

</body>
</html>