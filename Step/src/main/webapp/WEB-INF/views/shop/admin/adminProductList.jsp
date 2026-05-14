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

/* 화면을 꽉 채우기 위해 max-width를 해제하고 여백 조정 */
.content {
	width: 98%; /* 좌우 약간의 여백만 남기고 꽉 채움 */
	max-width: none; /* 기존 1200px 제한 해제 */
	margin: 0 auto;
	padding: 20px 0;
}

/* 상단 탭 메뉴 */
.tab-menu {
	display: flex;
	gap: 30px;
	border-bottom: 1px solid #ddd;
	margin-bottom: 20px;
	padding-left: 10px;
	background: #fff; /* 탭 영역 구분 */
}

.tab-item {
	padding: 15px 10px;
	cursor: pointer;
	color: #888;
	font-weight: 500;
	font-size: 15px;
	border-bottom: 3px solid transparent;
}

.tab-item.active {
	color: #000;
	border-bottom: 3px solid #000;
	font-weight: bold;
}

/* 검색 영역: 양 끝으로 배치 */
.search-box {
	background: #fff;
	padding: 15px 20px;
	display: flex;
	justify-content: space-between; /* 검색창과 등록버튼 양 끝 정렬 */
	align-items: center;
	border: 1px solid #eee;
	margin-bottom: 20px;
}

.search-input-wrapper {
	position: relative;
	width: 400px; /* 검색창 너비 확장 */
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

/* 버튼 스타일 */
.btn-insert {
	background: #000;
	color: #fff;
	padding: 12px 25px; /* 버튼 크기 키움 */
	border-radius: 4px;
	border: none;
	font-size: 14px;
	cursor: pointer;
	font-weight: bold;
	transition: background 0.2s;
}

.btn-insert:hover {
	background: #333;
}

/* 테이블 스타일: 너비 100% 사용 */
.tbl-wrap {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 4px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
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
	font-weight: 600;
}

td {
	padding: 15px 10px;
	border-bottom: 1px solid #f2f2f2;
}

.prod-img {
	width: 60px; /* 이미지 크기 살짝 키움 */
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
	font-size: 15px;
	display: block;
	margin-bottom: 6px;
}

.prod-sku {
	color: #999;
	font-size: 12px;
}

/* 상태 배지 */
.status-badge {
	display: inline-block;
	min-width: 60px;
	padding: 5px 8px;
	border-radius: 20px; /* 둥근 형태로 변경 */
	font-size: 12px;
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

/* 관리 버튼 */
.btn-group {
	display: flex;
	justify-content: center;
	gap: 5px;
}

.btn-edit, .btn-del {
	padding: 6px 12px;
	border-radius: 4px;
	font-size: 13px;
	cursor: pointer;
}

.btn-edit {
	border: 1px solid #ddd;
	background: #fff;
	color: #555;
}

.btn-del {
	border: 1px solid #e74c3c;
	background: #fff;
	color: #e74c3c;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
			<div class="tab-menu">
				<div class="${currentStatus == 'sale' ? 'active' : ''}">전체 상품</div>
				<div class="">판매중</div>
				<div class="">숨김/품절</div>
			</div>

			<div class="search-box">
				<form action="productList.do" method="get"
					style="display: flex; align-items: center; gap: 15px;">
					<select name="search_status"
						style="padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
						<option value="">상태 전체</option>
					</select>
					<div class="search-input-wrapper">
						<i class="fa fa-search"></i> <input type="text" name="keyword"
							placeholder="상품명 또는 상품코드 검색..." value="${param.keyword}">
					</div>
					<button type="submit" style="display: none;"></button>
				</form>

				<button type="button" class="btn-insert"
					onclick="location.href='productInsertForm.do'">
					<i class="fa fa-plus"></i> 신규 상품 등록
				</button>
			</div>

			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th width="60">번호</th>
							<th width="100">이미지</th>
							<th style="text-align: left; padding-left: 20px;">상품정보</th>
							<th width="150">판매가</th>
							<th width="100">재고</th>
							<th width="120">상태</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${count == 0}">
							<tr>
								<td colspan="7"
									style="padding: 150px 0; color: #999; font-size: 16px;"><i
									class="fa fa-info-circle"
									style="display: block; font-size: 40px; margin-bottom: 15px;"></i>
									등록된 상품이 없습니다.</td>
							</tr>
						</c:if>
						<c:forEach var="product" items="${list}">
							<tr>
								<td>${product.prod_num}</td>
								<td><c:if test="${!empty product.prod_img_url}">
										<img
											src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
											class="prod-img">
									</c:if> <c:if test="${empty product.prod_img_url}">
										<div class="no-img"
											style="width: 60px; height: 60px; line-height: 60px; background: #f9f9f9; border: 1px solid #eee; display: inline-block; border-radius: 4px; color: #ccc; font-size: 11px;">No
											Image</div>
									</c:if></td>
								<td class="prod-info"><span class="prod-name">${product.prod_name}</span>
									<span class="prod-sku">SKU: ${product.sku}</span></td>
								<td><strong><fmt:formatNumber
											value="${product.prod_price}" pattern="#,###" />원</strong></td>
								<td>42</td>
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
							
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div class="paging-area"
				style="margin-top: 40px; text-align: center;">${page}</div>
		</div>
	</div>

</body>
</html>