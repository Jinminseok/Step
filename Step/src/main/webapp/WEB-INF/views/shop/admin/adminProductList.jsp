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
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
}

.content {
	width: 98%;
	max-width: none;
	margin: 0 auto;
	padding: 20px 0;
}

.tab-menu {
	display: flex;
	gap: 10px;
	border-bottom: 1px solid #e9ecef;
	margin-bottom: 25px;
	background: #fff;
	padding: 0 10px;
}

.tab-item {
	padding: 15px 25px;
	cursor: pointer;
	color: #868e96;
	font-weight: 500;
	font-size: 15px;
	border-bottom: 3px solid transparent;
	transition: all 0.2s;
}

.tab-item:hover {
	color: #212529;
}

.tab-item.active {
	color: #1a73e8;
	border-bottom: 3px solid #1a73e8;
	font-weight: bold;
}

.tbl-wrap {
	background: #fff;
	border: 1px solid #e9ecef;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
	margin-top: 10px;
}

table {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

thead {
	background: #f8f9fa;
	border-bottom: 1px solid #e9ecef;
}

th {
	padding: 16px 12px;
	color: #495057;
	font-weight: 600;
	text-align: center;
	font-size: 13px;
}

td {
	padding: 14px 12px;
	border-bottom: 1px solid #f1f3f5;
	vertical-align: middle;
	text-align: center;
	color: #343a40;
}

.td-img {
	display: flex;
	justify-content: center;
	align-items: center;
}

.prod-img {
	width: 55px;
	height: 55px;
	object-fit: cover;
	border: 1px solid #e9ecef;
	border-radius: 6px;
	background: #fff;
}

.no-img {
	width: 55px;
	height: 55px;
	background: #f1f3f5;
	line-height: 55px;
	font-size: 10px;
	color: #868e96;
	border-radius: 6px;
}

.sku-text {
	font-family: 'Courier New', monospace;
	font-weight: 500;
	color: #495057;
}

.prod-name-cell {
	text-align: left;
	padding-left: 15px;
	font-weight: 600;
	color: #121212;
}

.cat-badge {
	display: inline-block;
	background: #f1f3f5;
	color: #495057;
	padding: 4px 12px;
	border-radius: 12px;
	font-size: 13px;
	font-weight: 500;
}

.status-badge {
	display: inline-block;
	min-width: 60px;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: 600;
	text-align: center;
}

.status-sale {
	color: #0ca678;
	background: #e6fcf5;
}

.status-hide {
	color: #748ffc;
	background: #edf2ff;
}

.status-soldout {
	color: #f03e3e;
	background: #fff5f5;
}

.status-attention {
	color: #d9480f;
	background: #fff4e6;
}

/* PAGE HEADER */
.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}

</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
		
		    <div class="page-hdr">
		      <div>
		        <div class="page-hdr-title">상품 관리</div>
		        <div class="page-hdr-sub">쇼핑몰에 등록된 상품을 조회합니다. 상품 마스터 관리(물류관리) 등록시 상품 목록에 반영됩니다.</div>
		      </div>		      
		    </div>
		
			<div class="tab-menu">
				<div class="tab-item ${empty param.search_status ? 'active' : ''}"
					onclick="location.href='productList.do'">전체 상품</div>
				<div class="tab-item ${param.search_status == '1' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=1'">판매중</div>
				<div class="tab-item ${param.search_status == '2' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=2'">숨김</div>
				<div class="tab-item ${param.search_status == '3' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=3'">품절</div>
				<div class="tab-item ${param.search_status == '4' ? 'active' : ''}"
					onclick="location.href='productList.do?search_status=4'">주의</div>
			</div>

			<div class="tbl-wrap">
				<c:if test="${count == 0}">
					<div align="center" style="padding: 50px 0;">
						<i class="fa fa-info-circle"
							style="font-size: 30px; margin-bottom: 10px; display: block; color: #ccc;"></i>
						조건에 매칭되는 입고 완료 상품 내역이 존재하지 않습니다.
					</div>
				</c:if>
				<c:if test="${count > 0}">
					<table>
						<thead>
							<tr>
								<th width="80">사진</th>
								<th width="150">품번 (SKU)</th>
								<th width="100">브랜드</th>
								<th style="text-align: left; padding-left: 15px;">상품명 (같은 상품명인경우 하나로 묶어서 표기)</th>
								<th width="120">카테고리</th>
								<th width="90">색상 (같은 상품명인 경우 등록된 모든 색상 표기)</th>
								<th width="90">사이즈 (같은 상품명인경우 모든 사이즈를 범위로 표시 220~280 이런식으로)</th>
								<th width="130">판매가</th>
								<th width="100">상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="product" items="${list}">
								<tr>
									<td>
										<div class="td-img">
											<c:choose>
												<c:when test="${!empty product.prod_img_url}">
													<img
														src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
														class="prod-img">
												</c:when>
												<c:otherwise>
													<div class="no-img">No Image</div>
												</c:otherwise>
											</c:choose>
										</div>
									</td>
									<td class="sku-text">${product.sku}</td>
									<td>${empty product.brand_name ? '-' : product.brand_name}</td>
									<td class="prod-name-cell">${product.prod_name}</td>
									<td><span class="cat-badge"> <i
											class="fa-regular fa-circle"
											style="font-size: 8px; margin-right: 4px; vertical-align: middle; color: #868e96;"></i>
											${empty product.cat_name ? '미지정' : product.cat_name}
									</span></td>
									<td>${empty product.color ? '-' : product.color}</td>
									<td>${product.size_val == 0 ? '-' : product.size_val}</td>
									<td><strong><fmt:formatNumber
												value="${product.prod_price}" pattern="#,###" />원</strong></td>
									<td><c:choose>
											<c:when test="${product.prod_status == 1}">
												<span class="status-badge status-sale">• 판매중</span>
											</c:when>
											<c:when test="${product.prod_status == 2}">
												<span class="status-badge status-hide">• 숨김</span>
											</c:when>
											<c:when test="${product.prod_status == 3}">
												<span class="status-badge status-soldout">• 품절</span>
											</c:when>
											<c:when test="${product.prod_status == 4}">
												<span class="status-badge status-attention">• 주의</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge"
													style="background: #f1f3f5; color: #868e96;">• 미지정</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="paging-area"
						style="margin-top: 40px; margin-bottom: 20px; text-align: center;">${page}</div>
				</c:if>
			</div>
		</div>
	</div>

</body>
</html>