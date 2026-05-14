<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
body {
	background-color: #f5f5f5;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
}

.content {
	width: 98%;
	max-width: none;
	margin: 0 auto;
	padding: 20px 0;
}

/* 상단 탭 메뉴 */
.tab-menu {
	display: flex;
	gap: 10px;
	border-bottom: 1px solid #ddd;
	margin-bottom: 25px;
	background: #fff;
	padding: 0 10px;
}

.tab-item {
	padding: 15px 25px;
	cursor: pointer;
	color: #888;
	font-weight: 500;
	font-size: 15px;
	border-bottom: 3px solid transparent;
	transition: all 0.2s;
}

.tab-item:hover {
	color: #333;
}

.tab-item.active {
	color: #000;
	border-bottom: 3px solid #000;
	font-weight: bold;
}

/* 검색 영역 */
.search-box {
	background: #fff;
	padding: 15px 20px;
	display: flex;
	justify-content: flex-start; /* 버튼 제거 후 왼쪽 정렬로 변경 */
	align-items: center;
	border: 1px solid #eee;
	margin-bottom: 20px;
}

.search-input-wrapper {
	position: relative;
	width: 400px;
}

.search-input-wrapper i {
	position: absolute;
	left: 12px;
	top: 50%;
	transform: translateY(-50%);
	color: #aaa;
}

.search-input-wrapper input {
	width: 100%;
	padding: 10px 10px 10px 40px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

/* 검색 버튼 스타일 */
.btn-edit {
	background: #fff;
	color: #555;
	padding: 10px 20px;
	border: 1px solid #ddd;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 500;
}

.btn-edit:hover {
	background: #f9f9f9;
}

/* 테이블 스타일 */
.tbl-wrap {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 4px;
}

table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
	font-size: 14px;
}

thead {
	background: #fcfcfc;
	border-bottom: 2px solid #eee;
}

th {
	padding: 18px 10px;
	color: #333;
}

td {
	padding: 15px 10px;
	border-bottom: 1px solid #f2f2f2;
}

.prod-img {
	width: 60px;
	height: 60px;
	object-fit: cover;
	border: 1px solid #eee;
	border-radius: 4px;
}

.prod-info {
	text-align: left;
	padding-left: 20px;
}

.prod-name {
	font-weight: bold;
	display: block;
	margin-bottom: 4px;
}

.prod-sku {
	color: #999;
	font-size: 12px;
}

/* 상태 배지 */
.status-badge {
	display: inline-block;
	min-width: 60px;
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 500;
}

.status-sale {
	color: #2ecc71;
	background: #eafaf1;
	border: 1px solid #2ecc71;
}

.status-soldout {
	color: #e67e22;
	background: #fdf2e9;
	border: 1px solid #e67e22;
}

.status-hide {
	color: #95a5a6;
	background: #f4f6f7;
	border: 1px solid #95a5a6;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
			<div class="tab-menu">
				<div class="tab-item ${empty param.search_status ? 'active' : ''}"
					onclick="location.href='productList.do'">전체 상품</div>

				<div class="tab-item ${param.search_status == '1' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=1'">판매중</div>

				<div class="tab-item ${param.search_status == '2' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=2'">품절</div>

				<div class="tab-item ${param.search_status == '3' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=3'">숨김</div>
			</div>

			<div class="search-box">
				<form action="productList.do" method="get"
					style="display: flex; align-items: center; gap: 15px;">
					<input type="hidden" name="search_status"
						value="${param.search_status}">

					<div class="search-input-wrapper">
						<i class="fa fa-search"></i> <input type="text" name="keyword"
							placeholder="상품명 또는 상품코드 검색..." value="${param.keyword}">
					</div>
					<button type="submit" class="btn-edit">검색</button>
				</form>
				<!-- 신규 상품 등록 버튼 제거됨 -->
			</div>

			<div class="tbl-wrap">
				<c:if test="${count == 0}">
					<div align="center">
								<i
									class="fa fa-info-circle"
									style="font-size: 30px; margin-bottom: 10px; display: block;"></i>
									조회된 상품이 없음</td>
					<div>
				</c:if>
				<c:if test="${count > 0}">
				<table>
					<thead>
						<tr>
							<th width="100">이미지</th>
							<th style="text-align: left; padding-left: 20px;">상품명</th>
							<th width="120">카테고리</th>
							<th width="120">사이즈</th>
							<th width="120">색깔</th>
							<th width="150">판매가</th>
							<th width="120">상태</th>
							<th width="120">판매여부</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="product" items="${list}" varStatus="status">
							<tr>
								<td><c:choose>
										<c:when test="${!empty product.prod_img_url}">
											<img
												src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
												class="prod-img">
										</c:when>
										<c:otherwise>
											<div
												style="width: 60px; height: 60px; background: #eee; line-height: 60px; font-size: 10px; color: #aaa; border-radius: 4px; margin: 0 auto;">No
												Image</div>
										</c:otherwise>
									</c:choose></td>
								<td class="prod-info"><span class="prod-name">${product.prod_name}</span>
									<span class="prod-sku">SKU: ${product.sku}</span></td>
								<td align="center">카테고리</td>
								<td align="center">사이즈</td>
								<td align="center">색깔</td>	
								<td><strong><fmt:formatNumber
											value="${product.prod_price}" pattern="#,###" />원</strong></td>
								<td><c:choose>
										<c:when test="${product.prod_status == 1}">
											<span class="status-badge status-sale">판매중</span>
										</c:when>
										<c:when test="${product.prod_status == 2}">
											<span class="status-badge status-soldout">품절</span>
										</c:when>
										<c:otherwise>
											<span class="status-badge status-hide">숨김</span>
										</c:otherwise>
									</c:choose></td>
								<td>
									<c:choose>
										<c:when test="${product.stock_qty > 0}">
											<span class="status-badge status-sale">가능</span>
										</c:when>
										<c:otherwise>
											<span class="status-badge status-hide">불가능</span>
										</c:otherwise>
									</c:choose>	
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div class="paging-area"
				style="margin-top: 40px; text-align: center;">${page}</div>
				</c:if>
			</div>

			
		</div>
	</div>

</body>
</html>