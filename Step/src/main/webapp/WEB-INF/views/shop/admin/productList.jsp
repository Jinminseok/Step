<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 관리 - ShoeMall Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
</head>
<body>

	<!-- SIDEBAR (대시보드와 동일하게 유지) -->
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
			<div class="nav-item"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/main.do'">
				<span class="nav-icon">📊</span>통계 / 대시보드
			</div>

			<div class="nav-section">상품</div>
			<div class="nav-item active"
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


	<main class="main">
		<div class="topbar">
			<div class="topbar-title">Product Management</div>
		</div>
		<div class="content">
			<div class="page-hdr"
				style="display: flex; justify-content: space-between; align-items: center;">
				<div>
					<h1 class="page-hdr-title">상품 목록</h1>
				</div>
				<button type="button" class="btn btn-black"
					onclick="location.href='${pageContext.request.contextPath}/shop/admin/productForm.do'">
					신규 상품 등록</button>
			</div>

			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th>No</th>
							<th>이미지</th>
							<!-- 이미지 열 추가 -->
							<th>SKU</th>
							<th>카테고리</th>
							<th>브랜드</th>
							<th>상품명</th>
							<th>판매가</th>
							<th>상태</th>
							<th>등록일</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty productList}">
								<tr>
									<td colspan="9" style="text-align: center; padding: 50px 0;">등록된
										상품이 없습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="prod" items="${productList}">
									<tr>
										<td>${prod.prod_num}</td>
										<!-- 상품 이미지 출력 섹션 -->
										<td style="width: 80px; text-align: center;"><c:if
												test="${!empty prod.prod_img_url}">
												<%-- filename -> prod_img_url 수정 --%>
												<img
													src="${pageContext.request.contextPath}/upload/${prod.prod_img_url}"
													alt="${prod.prod_name}"
													style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #eee;">
											</c:if> <c:if test="${empty prod.prod_img_url}">
												<%-- filename -> prod_img_url 수정 --%>
												<div
													style="width: 50px; height: 50px; background: #f5f5f5; line-height: 50px; font-size: 10px; color: #ccc; border-radius: 4px; margin: 0 auto;">No
													Img</div>
											</c:if></td>
										<td>${prod.sku}</td>
										<td>${prod.cat_name}</td>
										<td>${prod.brand_name}</td>
										<td style="font-weight: 700;">${prod.prod_name}</td>
										<%-- name -> prod_name 수정 --%>
										<td><fmt:formatNumber value="${prod.prod_price}"
												pattern="#,###" />원 <%-- price -> prod_price 수정 --%></td>
										<td><c:if test="${prod.prod_status == 1}">판매중</c:if> <%-- status -> prod_status 수정 --%>
											<c:if test="${prod.prod_status == 2}">품절</c:if> <c:if
												test="${prod.prod_status == 3}">숨김</c:if></td>
										<td>${prod.prod_created_at}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
	</main>
</body>
</html>