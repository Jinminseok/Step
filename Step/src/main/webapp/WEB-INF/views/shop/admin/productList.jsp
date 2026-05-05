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
<style>
/* 관리 버튼 스타일 */
.btn-edit {
	background: #4a90e2;
	color: #fff;
	border: none;
	padding: 5px 10px;
	border-radius: 3px;
	cursor: pointer;
	margin-right: 5px;
}

.btn-delete {
	background: #e74c3c;
	color: #fff;
	border: none;
	padding: 5px 10px;
	border-radius: 3px;
	cursor: pointer;
}

.btn-edit:hover {
	background: #357abd;
}

.btn-delete:hover {
	background: #c0392b;
}

/* 페이징 스타일 추가 (기존 레이아웃 유지하며 중앙 정렬) */
.paging-area {
	margin-top: 20px;
	text-align: center;
	width: 100%;
}
</style>
</head>
<body>

	<!-- SIDEBAR -->
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
					<h1 class="page-hdr-title">상품 목록 (총 ${count}개)</h1>
				</div>
				<button type="button" class="btn btn-black"
					onclick="location.href='${pageContext.request.contextPath}/shop/admin/insertProductForm.do'">
					신규 상품 등록</button>
			</div>

			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th>No</th>
							<th>이미지</th>
							<th>SKU</th>
							<th>카테고리</th>
							<th>브랜드</th>
							<th>상품명</th>
							<th>판매가</th>
							<th>상태</th>
							<th>등록일</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty productList}">
								<tr>
									<td colspan="10" style="text-align: center; padding: 50px 0;">등록된
										상품이 없습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="prod" items="${productList}">
									<tr>
										<td>${prod.prod_num}</td>
										<td style="width: 80px; text-align: center;"><c:if
												test="${!empty prod.prod_img_url}">
												<img
													src="${pageContext.request.contextPath}/upload/${prod.prod_img_url}"
													alt="${prod.prod_name}"
													style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #eee;">
											</c:if> <c:if test="${empty prod.prod_img_url}">
												<div
													style="width: 50px; height: 50px; background: #f5f5f5; line-height: 50px; font-size: 10px; color: #ccc; border-radius: 4px; margin: 0 auto;">No
													Img</div>
											</c:if></td>
										<td>${prod.sku}</td>
										<td>${prod.cat_name}</td>
										<td>${prod.brand_name}</td>
										<td style="font-weight: 700;">${prod.prod_name}</td>
										<td><fmt:formatNumber value="${prod.prod_price}"
												pattern="#,###" />원</td>
										<td><c:if test="${prod.prod_status == 1}">
												<span style="color: #2ecc71;">판매중</span>
											</c:if> <c:if test="${prod.prod_status == 2}">
												<span style="color: #e67e22;">품절</span>
											</c:if> <c:if test="${prod.prod_status == 3}">
												<span style="color: #95a5a6;">숨김</span>
											</c:if></td>
										<td>${prod.prod_created_at}</td>
										<td>
											<button type="button" class="btn-edit"
												onclick="location.href='productModifyForm.do?prod_num=${prod.prod_num}'">수정</button>
											<button type="button" class="btn-delete"
												onclick="deleteProduct(${prod.prod_num})">삭제</button>
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<!-- 페이징 영역 추가 -->
			<div class="paging-area">${page}</div>
		</div>
	</main>

	<script type="text/javascript">
		function deleteProduct(prod_num) {
			if (confirm("정말 이 상품을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
				location.href = 'productDelete.do?prod_num=' + prod_num;
			}
		}
	</script>
</body>
</html>