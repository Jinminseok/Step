<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 상품 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
/* --- 🚨 핵심 디테일 수정: 모든 요소의 테두리/여백을 너비에 포함 --- */
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body {
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
	overflow-y: scroll; /* 🚨 핵심 디테일: 페이지 전환 시 스크롤바 밀림 방지 */
}

/* 👇 사이드바 너비만큼 본문을 완벽히 밀어줍니다 */
.main {
    margin-left: 260px;
    padding: 30px;
    box-sizing: border-box;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.content {
	flex: 1;
	width: 100%;
	max-width: none;
	margin: 0 auto;
}

/* PAGE HEADER */
.page-hdr { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-hdr-title { font-size: 24px; font-weight: bold; margin-bottom: 5px; color: #111827; }
.page-hdr-sub { font-size: 14px; color: #666; }

/* ── 📊 탭 메뉴 스타일 개편 ── */
.tab-menu {
	display: flex;
	gap: 8px;
	border-bottom: 1px solid #e2e8f0;
	margin-bottom: 24px;
	background: transparent;
	padding: 0;
}

.tab-item {
	padding: 12px 20px;
	cursor: pointer;
	color: #64748b;
	font-weight: 500;
	font-size: 14px;
	border-bottom: 2px solid transparent;
	transition: all 0.2s ease;
}

.tab-item:hover {
	color: #0f172a;
}

.tab-item.active {
	color: #3b82f6;
	border-bottom: 2px solid #3b82f6;
	font-weight: 600;
}

/* TABLE LIST */
.tbl-wrap {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 12px;
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
	background: #f8fafc;
	border-bottom: 1px solid #e2e8f0;
}

th {
	padding: 14px 16px;
	color: #475569;
	font-weight: 600;
	text-align: center;
	font-size: 13px;
}

td {
	padding: 14px 16px;
	border-bottom: 1px solid #f1f5f9;
	vertical-align: middle;
	text-align: center;
	color: #334155;
}
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }

/* 상품 이미지 미니어처 */
.td-img {
	display: flex;
	justify-content: center;
	align-items: center;
}

.prod-img {
	width: 52px;
	height: 52px;
	object-fit: cover;
	border: 1px solid #e2e8f0;
	border-radius: 6px;
	background: #fff;
	box-shadow: 0 1px 2px rgba(0,0,0,0.03);
}

.no-img {
	width: 52px;
	height: 52px;
	background: #f1f5f9;
	line-height: 52px;
	font-size: 11px;
	color: #94a3b8;
	border-radius: 6px;
	border: 1px solid #e2e8f0;
	font-weight: 500;
}

.sku-text {
	font-family: 'Space Grotesk', sans-serif;
	font-weight: 600;
	color: #475569;
	font-size: 13px;
}

.prod-name-cell {
	text-align: left;
	padding-left: 20px;
	font-weight: 600;
	color: #0f172a;
	font-size: 14.5px;
}

.cat-badge {
	display: inline-block;
	background: #f1f5f9;
	color: #475569;
	padding: 4px 12px;
	border-radius: 12px;
	font-size: 12.5px;
	font-weight: 500;
}

/* ── 🏷️ 상태 뱃지 글로벌 디자인 통일 ── */
.status-badge {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 11.5px;
	font-weight: 600;
	text-align: center;
}

.status-sale { color: #059669; background: #dcfce7; }       /* 판매중 (그린) */
.status-hide { color: #2563eb; background: #dbeafe; }       /* 숨김 (블루) */
.status-soldout { color: #ef4444; background: #fef2f2; }    /* 품절 (레드) */
.status-attention { color: #d9480f; background: #fff4e6; }  /* 주의 (오렌지) */

/* PAGINATION */
.paging-area {
	margin-top: 30px;
	margin-bottom: 10px;
	text-align: center;
	font-size: 14px;
}
/* PagingUtil 패키징 클래스 링크 간격 보정 */
.paging-area a, .paging-area b, .paging-area span {
	padding: 6px 12px;
	border: 1px solid #e2e8f0;
	color: #475569;
	text-decoration: none;
	border-radius: 4px;
	margin: 0 2px;
	transition: all 0.2s;
}
.paging-area a:hover { border-color: #111827; color: #111827; }
.paging-area b span { border-color: #111827; background: #111827; color: #fff !important; font-weight: 700; }
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<c:set var="pageTitle" value="상품 관리" scope="request" />
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
		
		    <div class="page-hdr">
		      <div>
		        <div class="page-hdr-title">상품 관리</div>
		        <div class="page-hdr-sub">쇼핑몰에 등록된 마스터 상품을 실시간 조회하고 필터링합니다.</div>
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
					<div align="center" style="padding: 80px 0; color: #94a3b8;">
						<i class="fa-solid fa-box-open" style="font-size: 36px; margin-bottom: 12px; display: block; color: #e2e8f0;"></i>
						조건에 매칭되는 입고 완료 상품 내역이 존재하지 않습니다.
					</div>
				</c:if>
				<c:if test="${count > 0}">
					<table>
						<thead>
							<tr>
								<th width="90">사진</th>
								<th width="160">품번 (SKU)</th>
								<th width="130">브랜드</th>
								<th style="text-align: left; padding-left: 20px;">상품명</th>
								<th width="140">카테고리</th>
								<th width="100">색상</th>
								<th width="90">사이즈</th>
								<th width="140" style="text-align: right; padding-right: 20px;">판매가</th>
								<th width="120">상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="product" items="${list}">
								<tr>
									<td>
										<div class="td-img">
											<c:choose>
												<c:when test="${!empty product.prod_img_url}">
													<img src="${pageContext.request.contextPath}/upload/${product.prod_img_url}" class="prod-img">
												</c:when>
												<c:otherwise>
													<div class="no-img">No Image</div>
												</c:otherwise>
											</c:choose>
										</div>
									</td>
									<td class="sku-text">${product.sku}</td>
									<td style="font-weight: 500; color: #475569;">${empty product.brand_name ? '-' : product.brand_name}</td>
									<td class="prod-name-cell">${product.prod_name}</td>
									<td>
										<span class="cat-badge">
											${empty product.cat_name ? '미지정' : product.cat_name}
										</span>
									</td>
									<td style="color: #64748b; font-size: 13.5px;">${empty product.color ? '-' : product.color}</td>
									<td style="font-family: 'Space Grotesk'; font-weight: 600; color: #475569;">${product.size_val == 0 ? '-' : product.size_val}</td>
									<td style="text-align: right; padding-right: 20px; font-weight: 700; font-family: 'Space Grotesk'; color: #0f172a;">
										<fmt:formatNumber value="${product.prod_price}" pattern="#,###" />원
									</td>
									<td>
										<c:choose>
											<c:when test="${product.prod_status == 1}">
												<span class="status-badge status-sale">● 판매중</span>
											</c:when>
											<c:when test="${product.prod_status == 2}">
												<span class="status-badge status-hide">● 숨김</span>
											</c:when>
											<c:when test="${product.prod_status == 3}">
												<span class="status-badge status-soldout">● 품절</span>
											</c:when>
											<c:when test="${product.prod_status == 4}">
												<span class="status-badge status-attention">● 주의</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge" style="background: #f1f3f5; color: #868e96;">● 미지정</span>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="paging-area">${page}</div>
				</c:if>
			</div>
		</div>
	</div>

</body>
</html>