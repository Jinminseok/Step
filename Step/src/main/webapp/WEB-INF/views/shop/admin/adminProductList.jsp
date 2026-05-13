
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 관리 리스트</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script type="text/javascript">
		function go(menu) {
			if (menu === 'dashboard')
				location.href = 'main.do';
			else if (menu === 'product')
				location.href = 'productList.do';
		}
	</script>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<header class="topbar">
			<div class="breadcrumb">Admin > Product Management</div>
		</header>

		<main class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">상품 리스트 (${count})</h1>
				<button class="btn btn-black"
					onclick="location.href='productInsertForm.do'">상품 등록</button>
			</div>

			<!-- 검색 필터 영역 -->
			<div class="search-area"
				style="background: #fff; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);">
				<form action="productList.do" method="get"
					style="display: flex; gap: 10px; align-items: center;">
					<select name="search_type" class="input-select"
						style="width: 120px;">
						<option value="prod_name"
							<c:if test="${param.search_type == 'prod_name'}">selected</c:if>>상품명</option>
						<option value="sku"
							<c:if test="${param.search_type == 'sku'}">selected</c:if>>SKU(품번)</option>
					</select> <input type="text" name="keyword" value="${param.keyword}"
						class="input-txt" placeholder="검색어를 입력하세요" style="flex: 1;">
					<button type="submit" class="btn btn-black">조회</button>
					<button type="button" class="btn btn-outline"
						onclick="location.href='productList.do'">초기화</button>
				</form>
			</div>

			<div class="tbl-wrap">
				<table>
					<thead>
						<tr>
							<th width="60">번호</th>
							<th width="100">이미지</th>
							<th>상품 정보(명/SKU)</th>
							<th>카테고리/브랜드</th>
							<th>판매가</th>
							<th>상태</th>
							<th width="100">관리</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${count == 0}">
							<tr>
								<td colspan="7" style="padding: 50px 0;">검색 결과가 없음</td>
							</tr>
						</c:if>
						<c:forEach var="product" items="${list}">
							<tr>
								<td>${product.prod_num}</td>
								<td><c:if test="${!empty product.prod_img_url}">
										<img
											src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
											width="60" height="60"
											style="object-fit: cover; border-radius: 5px;">
									</c:if> <c:if test="${empty product.prod_img_url}">
										<div
											style="width: 60px; height: 60px; background: #eee; line-height: 60px; font-size: 11px; color: #aaa; border-radius: 5px;">No
											Image</div>
									</c:if></td>
								<td style="text-align: left;">
									<div style="font-weight: bold;">${product.prod_name}</div>
									<div style="font-size: 0.85em; color: #888; margin-top: 4px;">${product.sku}</div>
								</td>
								<td>${product.cat_name}/${product.brand_name}</td>
								<td><fmt:formatNumber value="${product.prod_price}"
										pattern="#,###" />원 <c:if test="${product.sale_rate > 0}">
										<div style="color: red; font-size: 0.8em;">${product.sale_rate}%
											OFF</div>
									</c:if></td>
								<td><c:choose>
										<c:when test="${product.prod_status == 1}">
											<span class="badge"
												style="background: #e3f2fd; color: #1976d2; padding: 4px 8px; border-radius: 4px;">판매중</span>
										</c:when>
										<c:when test="${product.prod_status == 2}">
											<span class="badge"
												style="background: #fff3e0; color: #fb8c00; padding: 4px 8px; border-radius: 4px;">품절</span>
										</c:when>
										<c:otherwise>
											<span class="badge"
												style="background: #f5f5f5; color: #9e9e9e; padding: 4px 8px; border-radius: 4px;">숨김</span>
										</c:otherwise>
									</c:choose></td>
								<td>
									<button class="btn btn-outline" style="font-size: 0.9em;"
										onclick="location.href='productUpdate.do?prod_num=${product.prod_num}'">수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div class="paging-area"
				style="margin-top: 30px; text-align: center;">${page}</div>
		</main>
	</div>

</body>
</html>