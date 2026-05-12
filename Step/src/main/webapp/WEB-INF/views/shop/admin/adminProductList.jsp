<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 관리 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="page-main">
		<h2>상품 관리 목록</h2>

		<form action="adminProductList.do" id="search_form" method="get"
			style="margin-bottom: 20px;">
			<select name="search_type">
				<option value="prod_name"
					${param.search_type == 'prod_name' ? 'selected' : ''}>상품명</option>
				<option value="sku" ${param.search_type == 'sku' ? 'selected' : ''}>품번(SKU)</option>
			</select> <input type="search" name="keyword" id="keyword"
				value="${param.keyword}"> <input type="submit" value="검색">
			<input type="button" value="목록"
				onclick="location.href='adminProductList.do'">
		</form>

		<div class="result-display">
			표시할 상품 수: <b>${count}</b>건
		</div>

		<c:if test="${count == 0}">
			<div class="result-none">등록된 상품이 없습니다.</div>
		</c:if>

		<c:if test="${count > 0}">
			<table border="1" style="width: 100%; border-collapse: collapse;">
				<thead>
					<tr>
						<th>상품번호</th>
						<th>이미지</th>
						<th>브랜드</th>
						<th>상품명</th>
						<th>가격</th>
						<th>상태</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="product" items="${list}">
						<tr align="center">
							<td>${product.prod_num}</td>
							<td><img
								src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
								width="50" height="50"></td>
							<td>${product.brand_name}</td>
							<td align="left"><a
								href="adminProductDetail.do?prod_num=${product.prod_num}">${product.prod_name}</a>
							</td>
							<td><fmt:formatNumber value="${product.prod_price}" />원</td>
							<td><c:choose>
									<c:when test="${product.prod_status == 1}">판매중</c:when>
									<c:when test="${product.prod_status == 2}">판매중단</c:when>
									<c:otherwise>기타</c:otherwise>
								</c:choose></td>
							<td>${product.prod_created_at}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<div class="align-center" style="margin-top: 15px;">${page}</div>
		</c:if>

		<div class="align-right" style="margin-top: 15px;">
			<input type="button" value="상품 등록"
				onclick="location.href='adminProductWrite.do'">
		</div>
	</div>
</body>
</html>