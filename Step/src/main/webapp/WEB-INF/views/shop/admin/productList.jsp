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

	<!-- SIDEBAR (9개 메뉴 유지) -->
	<aside class="sidebar">
		<div class="sb-logo">
			<div class="sb-logo-mark">A</div>
			<div>
				<div class="sb-logo-txt">
					Shoe<span>Mall</span>
				</div>
			</div>
		</div>
		<nav class="nav">
			<div class="nav-section">대시보드</div>
			<div class="nav-item"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/main.do'">📊통계
				/ 대시보드</div>
			<div class="nav-section">상품</div>
			<div class="nav-item active"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/productList.do'">👟상품
				관리</div>
			<div class="nav-item">🏷️카테고리 관리</div>
			<div class="nav-section">재고 / 물류</div>
			<div class="nav-item">📦재고 관리</div>
			<div class="nav-item">🧾주문 관리</div>
			<div class="nav-item">🚚배송 관리</div>
			<div class="nav-item">↩️반품/교환 관리</div>
			<div class="nav-section">고객</div>
			<div class="nav-item">👤회원 관리</div>
			<div class="nav-item">🎫쿠폰 관리</div>
			<div class="nav-item">💬채팅 문의</div>
		</nav>
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
									<td colspan="8" style="text-align: center; padding: 50px 0;">등록된
										상품이 없습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="prod" items="${productList}">
									<tr>
										<td>${prod.prod_num}</td>
										<td>${prod.sku}</td>
										<td>${prod.cat_name}</td>
										<td>${prod.brand_name}</td>
										<td style="font-weight: 700;">${prod.name}</td>
										<td><fmt:formatNumber value="${prod.price}"
												pattern="#,###" />원</td>
										<td><c:if test="${prod.status == 1}">판매중</c:if> <c:if
												test="${prod.status == 2}">품절</c:if> <c:if
												test="${prod.status == 3}">숨김</c:if></td>
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