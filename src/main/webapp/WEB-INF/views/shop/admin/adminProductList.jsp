<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 상품 관리</title>
<link
	href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
/* --- 기본 레이아웃 및 뼈대 --- */
*, *::before, *::after {
	box-sizing: border-box;
}

body {
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
	overflow-y: scroll;
}

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

/* --- 상단 타이틀 및 필터 패널 --- */
.page-hdr {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 24px;
}

.page-hdr-title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 5px;
	color: #111827;
}

.page-hdr-sub {
	font-size: 14px;
	color: #666;
}

.tab-filter-container {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	border-bottom: 1px solid #e2e8f0;
	margin-bottom: 20px;
}

.tab-menu {
	display: flex;
	gap: 8px;
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
	margin-bottom: -1px;
}

.tab-item:hover {
	color: #0f172a;
}

.tab-item.active {
	color: #3b82f6;
	border-bottom: 2px solid #3b82f6;
	font-weight: 600;
}

.filter-panel {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 12px;
	padding: 18px 24px;
	margin-bottom: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
}

.filter-form {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	align-items: flex-end; /* 셀렉트박스와 초기화 버튼 하단 정렬을 위해 변경 */
}

.filter-group {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.filter-label {
	font-size: 11.5px;
	font-weight: 600;
	color: #64748b;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	display: flex;
	align-items: center;
	gap: 5px;
}

.filter-label i {
	color: #94a3b8;
	font-size: 12px;
}

.filter-select {
	padding: 9px 14px;
	font-size: 13.5px;
	font-family: 'Pretendard', sans-serif;
	color: #334155;
	background-color: #fff;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	outline: none;
	cursor: pointer;
	min-width: 160px;
	transition: all 0.2s ease;
}

.filter-select:focus {
	border-color: #3b82f6;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* 필터 초기화 버튼 스타일 추가 */
.btn-reset {
	padding: 9px 16px;
	font-size: 13.5px;
	font-family: 'Pretendard', sans-serif;
	font-weight: 600;
	color: #475569;
	background-color: #f8fafc;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.2s ease;
	display: flex;
	align-items: center;
	gap: 6px;
	height: 38px;
}

.btn-reset:hover {
	background-color: #e2e8f0;
	color: #0f172a;
}

/* --- 메인 테이블 영역 --- */
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

tr:last-child td {
	border-bottom: none;
}

tr:hover td {
	background: #f8fafc;
}

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
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
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

.status-sale {
	color: #059669;
	background: #dcfce7;
}

.status-hide {
	color: #2563eb;
	background: #dbeafe;
}

.status-soldout {
	color: #ef4444;
	background: #fef2f2;
}

.status-attention {
	color: #d9480f;
	background: #fff4e6;
}

/* 🌟 PAGINATION 🌟 */
.pagination-wrap {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 16px 20px;
	border-top: 1px solid #e2e8f0;
	background: #fff;
}

.page-info {
	font-size: 13px;
	color: #64748b;
}

.page-info strong {
	color: #0f172a;
}

.page-btns {
	display: flex;
	gap: 4px;
}

.pg-btn {
	width: 32px;
	height: 32px;
	border: 1px solid #e2e8f0;
	border-radius: 6px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	font-size: 13px;
	font-weight: 600;
	color: #64748b;
	background: #fff;
	transition: all .2s;
}

.pg-btn:hover {
	border-color: #3b82f6;
	color: #3b82f6;
}

.pg-btn.on {
	background: #3b82f6;
	color: #fff;
	border-color: #3b82f6;
}

.pg-btn.disabled {
	opacity: 0.4;
	cursor: not-allowed;
	pointer-events: none;
}

/* --- 모달 및 클릭 효과 --- */
.tr-clickable {
	cursor: pointer;
	transition: background 0.2s;
}

.tr-clickable:hover td {
	background: #f1f5f9 !important;
}

.modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(15, 23, 42, 0.4);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 9999;
	backdrop-filter: blur(2px);
}

.modal-content {
	background: #fff;
	width: 600px;	
	height: 520px; 
	
	border-radius: 12px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	display: flex;
	flex-direction: column;	
	resize: both;
	overflow: hidden; 
	
	min-width: 450px;
	min-height: 300px; 
	max-width: 95vw;
	max-height: 98vh; 
}

.modal-header {
	background: #1e293b;
	color: #fff;
	padding: 16px 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.modal-header h3 {
	margin: 0;
	font-size: 16px;
	font-weight: 600;
}

.close-btn {
	background: none;
	border: none;
	color: #94a3b8;
	font-size: 20px;
	cursor: pointer;
}

.close-btn:hover {
	color: #fff;
}

/* 모달 내부 테이블 영역 */
.modal-body {
	padding: 20px;
	flex: 1; 	
	overflow-y: auto;
}

.modal-footer {
	padding: 16px 20px;
	border-top: 1px solid #e2e8f0;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	background: #f8fafc;
}

.btn-cancel {
	padding: 8px 16px;
	border: 1px solid #cbd5e1;
	background: #fff;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 500;
}

.stock-table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
	font-size: 14px;
}

.stock-table th {
	background: #f8fafc;
	padding: 12px;
	color: #64748b;
	font-weight: 600;
	border-bottom: 2px solid #e2e8f0;
}

.stock-table td {
	padding: 12px;
	border-bottom: 1px solid #e2e8f0;
	vertical-align: middle;
}
</style>

<script type="text/javascript">
	function goFilter(status, cat, brand, order) {
		let url = 'productList.do?';
		let params = [];
		if (status) params.push('search_status=' + status);
		if (cat && cat !== '0') params.push('cat_num=' + cat);
		if (brand && brand !== '0') params.push('brand_num=' + brand);
		if (order && order !== '1') params.push('order_type=' + order);
		location.href = url + params.join('&');
	}

	function openStockModal(el) {
		let prodNum = el.dataset.prodnum;
		let prodName = el.dataset.prodname;
		
		document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-box"></i> ' + prodName + ' — 사이즈별 재고';
		document.getElementById('stockModal').style.display = 'flex';
		
		document.getElementById('stockTbody').innerHTML = '<tr><td colspan="5" style="padding:40px; color:#94a3b8;"><i class="fa-solid fa-spinner fa-spin"></i> 데이터 로딩중...</td></tr>';

		fetch('${pageContext.request.contextPath}/shop/admin/productStockAjax.do?prod_num=' + prodNum)
			.then(response => response.text())
			.then(html => {
				document.getElementById('stockTbody').innerHTML = html;
			})
			.catch(error => {
				document.getElementById('stockTbody').innerHTML = '<tr><td colspan="5" style="color:#ef4444;">실패</td></tr>';
			});
	}

	function closeStockModal() {
		document.getElementById('stockModal').style.display = 'none';
	}
</script>
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

			<div class="tab-filter-container">
				<div class="tab-menu">
					<div class="tab-item ${empty param.search_status ? 'active' : ''}"
						onclick="goFilter('', '${cat_num}', '${brand_num}', '${order_type}')">전체
						상품</div>
					<div class="tab-item ${param.search_status == '1' ? 'active' : ''}"
						onclick="goFilter('1', '${cat_num}', '${brand_num}', '${order_type}')">판매중</div>
					<div class="tab-item ${param.search_status == '2' ? 'active' : ''}"
						onclick="goFilter('2', '${cat_num}', '${brand_num}', '${order_type}')">숨김</div>
					<div class="tab-item ${param.search_status == '3' ? 'active' : ''}"
						onclick="goFilter('3', '${cat_num}', '${brand_num}', '${order_type}')">품절</div>
					<div class="tab-item ${param.search_status == '4' ? 'active' : ''}"
						onclick="goFilter('4', '${cat_num}', '${brand_num}', '${order_type}')">주의</div>
				</div>
			</div>

			<div class="filter-panel">
				<form action="productList.do" method="get" class="filter-form">
					<input type="hidden" name="search_status"
						value="${param.search_status}">
					<div class="filter-group">
						<label class="filter-label"><i
							class="fa-solid fa-arrow-down-short-wide"></i> 조회 정렬</label> <select
							name="order_type" class="filter-select"
							onchange="this.form.submit()">
							<option value="1" ${order_type == '1' ? 'selected' : ''}>최신입고순</option>
							<option value="2" ${order_type == '2' ? 'selected' : ''}>마지막입고순</option>
						</select>
					</div>
					<div class="filter-group">
						<label class="filter-label"><i
							class="fa-solid fa-copyright"></i> 브랜드 지정</label> <select
							name="brand_num" class="filter-select"
							onchange="this.form.submit()">
							<option value="0">전체 브랜드</option>
							<c:forEach var="b" items="${brandList}">
								<option value="${b.brand_num}"
									${brand_num == b.brand_num ? 'selected' : ''}>${b.brand_name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="filter-group">
						<label class="filter-label"><i
							class="fa-solid fa-layer-group"></i> 카테고리 지정</label> <select
							name="cat_num" class="filter-select"
							onchange="this.form.submit()">
							<option value="0">전체 카테고리</option>
							<c:forEach var="c" items="${categoryList}">
								<option value="${c.cat_num}"
									${cat_num == c.cat_num ? 'selected' : ''}>${c.cat_name}</option>
							</c:forEach>
						</select>
					</div>

					<div class="filter-group" style="margin-left: auto;">
						<button type="button" class="btn-reset"
							onclick="location.href='productList.do'">
							<i class="fa-solid fa-arrow-rotate-right"></i> 필터 초기화
						</button>
					</div>
				</form>
			</div>

			<div class="tbl-wrap">
				<c:if test="${count == 0}">
					<div align="center" style="padding: 90px 0; color: #64748b;">
						<i class="fa-solid fa-box-open"
							style="font-size: 42px; margin-bottom: 16px; display: block; color: #cbd5e1;"></i>
						조회 조건과 일치하는 마스터 상품이 없습니다.
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
								<th width="120">색상</th>
								<th width="110">사이즈</th>
								<th width="140" style="text-align: right; padding-right: 20px;">판매가</th>
								<th width="120">상태</th>
							</tr>
						</thead>
						<tbody id="productTbody">
							<c:forEach var="product" items="${list}">
								<tr class="tr-clickable product-row"
									data-prodnum="${product.prod_num}"
									data-prodname="${product.prod_name}"
									onclick="openStockModal(this)">
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
									<td style="font-weight: 500; color: #475569;">${empty product.brand_name ? '-' : product.brand_name}</td>
									<td class="prod-name-cell">${product.prod_name}</td>
									<td><span class="cat-badge">${empty product.cat_name ? '미지정' : product.cat_name}</span></td>
									<td
										style="color: #64748b; font-size: 13.5px; font-weight: 500;">
										<c:choose>
											<c:when test="${product.color_cnt > 1}">${product.color} 외 ${product.color_cnt - 1}색</c:when>
											<c:otherwise>${empty product.color ? '-' : product.color}</c:otherwise>
										</c:choose>
									</td>
									<td
										style="font-family: 'Space Grotesk'; font-weight: 600; color: #475569;">
										<c:choose>
											<c:when test="${product.min_size != product.max_size}">${product.min_size}~${product.max_size}</c:when>
											<c:otherwise>${product.min_size == 0 ? '-' : product.min_size}</c:otherwise>
										</c:choose>
									</td>
									<td
										style="text-align: right; padding-right: 20px; font-weight: 700; color: #0f172a;">
										<fmt:formatNumber value="${product.prod_price}"
											pattern="#,###" />원
									</td>
									<td><c:choose>
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
												<span class="status-badge"
													style="background: #f1f3f5; color: #868e96;">● 미지정</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<%-- 🌟 PAGINATION HTML 🌟 --%>
					<div class="pagination-wrap" id="productPagination"
						style="display: none;">
						<div class="page-info" id="productPageInfo">
							총 <strong>0</strong>건
						</div>
						<div class="page-btns" id="productPageBtns"></div>
					</div>
				</c:if>
			</div>
		</div>
	</div>

	<div id="stockModal" class="modal-overlay" style="display: none;">
		<div class="modal-content">
			<div class="modal-header">
				<h3 id="modalTitle">
					<i class="fa-solid fa-box"></i> 상품명 — 사이즈별 재고
				</h3>
				<button onclick="closeStockModal()" class="close-btn">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>
			<div class="modal-body">
				<table class="stock-table">
					<thead>
						<tr>
							<th width="20%">사이즈</th>
							<th width="20%">컬러</th>
							<th width="20%">재고 수량</th>
							<th width="25%">재고 바</th>
							<th width="15%">상태</th>
						</tr>
					</thead>
					<tbody id="stockTbody"></tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button onclick="closeStockModal()" class="btn-cancel">닫기</button>
			</div>
		</div>
	</div>

	<script>
let currentProductPage = 1;
const productItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allProductRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('productTbody');
    if (tbody) {
        allProductRows = Array.from(tbody.querySelectorAll('tr.product-row'));
        if (allProductRows.length > 0) {
            renderProductTable();
        } else {
            const pw = document.getElementById('productPagination');
            if(pw) pw.style.display = 'none';
        }
    }
});

function renderProductTable() {
    allProductRows.forEach(r => r.style.display = 'none');
    const start = (currentProductPage - 1) * productItemsPerPage;
    const end = start + productItemsPerPage;
    
    for (let i = start; i < end && i < allProductRows.length; i++) {
        allProductRows[i].style.display = '';
    }
    renderProductPagination();
}

function renderProductPagination() {
    const totalPages = Math.ceil(allProductRows.length / productItemsPerPage);
    const pw = document.getElementById('productPagination');
    const pi = document.getElementById('productPageInfo');
    const pb = document.getElementById('productPageBtns');

    if (!pw || !pb) return;

    if (allProductRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentProductPage - 1) * productItemsPerPage + 1;
    const en = Math.min(currentProductPage * productItemsPerPage, allProductRows.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allProductRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentProductPage === 1 ? 'disabled' : ''}" onclick="changeProductPage(\${currentProductPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentProductPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentProductPage ? 'on' : ''}" onclick="changeProductPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentProductPage === totalPages ? 'disabled' : ''}" onclick="changeProductPage(\${currentProductPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeProductPage(p) {
    const totalPages = Math.ceil(allProductRows.length / productItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentProductPage = p;
    renderProductTable();
}
</script>
</body>
</html>