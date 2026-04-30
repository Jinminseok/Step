<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 마스터 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/MS_style.css"
	type="text/css">
<style>
/* ── 툴바 ─────────────────────────────────────────── */
.toolbar {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 16px 24px;
	background: var(--white);
	border-bottom: 1px solid var(--gray6);
	flex-shrink: 0;
}

/* 검색창 */
.search-wrap {
	position: relative;
	flex: 1;
	max-width: 300px;
}

.search-wrap .search-ico {
	position: absolute;
	left: 12px;
	top: 50%;
	transform: translateY(-50%);
	color: var(--gray4);
	font-size: 14px;
}

.search-wrap input {
	width: 100%;
	padding: 9px 14px 9px 36px;
	border: 1.5px solid var(--gray5);
	border-radius: 7px;
	font-size: 13px;
	font-family: inherit;
	outline: none;
	background: var(--white);
	color: var(--gray1);
	transition: border .15s;
}

.search-wrap input:focus {
	border-color: var(--blue);
	box-shadow: 0 0 0 3px rgba(29, 111, 228, .08);
}

.search-wrap input::placeholder {
	color: var(--gray4);
}

/* 셀렉트 */
.sel {
	padding: 9px 12px;
	border: 1.5px solid var(--gray5);
	border-radius: 7px;
	font-size: 13px;
	font-family: inherit;
	color: var(--gray2);
	background: var(--white);
	outline: none;
	cursor: pointer;
	transition: border .15s;
}

.sel:focus {
	border-color: var(--blue);
}

/* 오른쪽 버튼들 */
.toolbar-right {
	margin-left: auto;
	display: flex;
	gap: 8px;
}

.btn {
	padding: 9px 16px;
	border: none;
	border-radius: 7px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
	font-family: inherit;
	transition: all .15s;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.btn-outline {
	background: var(--white);
	color: var(--gray2);
	border: 1.5px solid var(--gray5);
}

.btn-outline:hover {
	border-color: var(--gray3);
	color: var(--gray1);
}

.btn-blue {
	background: var(--blue);
	color: #fff;
}

.btn-blue:hover {
	background: var(--navy2);
}

/* ── 콘텐츠 스크롤 영역 ─────────────────────────── */
.content {
	flex: 1;
	overflow-y: auto;
	padding: 20px 24px;
}

.content::-webkit-scrollbar {
	width: 5px;
}

.content::-webkit-scrollbar-thumb {
	background: var(--gray5);
	border-radius: 3px;
}

/* ── 테이블 카드 (수정된 부분) ────────────────────── */
.tbl-card {
	background: var(--white);
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}

.tbl-wrap {
	overflow-x: auto;
}

table {
	width: 100%;
	border-collapse: collapse;
	border-spacing: 0;
	margin-top: 0;
	border: none;
}

thead {
	position: sticky;
	top: 0;
	z-index: 5;
}

th {
	padding: 14px 16px;
	font-size: 13px;
	font-weight: 600;
	color: #64748b;
	background: #f8fafc;
	border: none;
	border-bottom: 1px solid #e2e8f0;
	text-align: center;
	white-space: nowrap;
}

/* 텍스트 길이가 긴 컬럼(품번, 브랜드, 상품명)은 좌측 정렬 유지 */
th:nth-child(2), td:nth-child(2),
th:nth-child(3), td:nth-child(3),
th:nth-child(4), td:nth-child(4) {
	text-align: left;
}

td {
	padding: 16px;
	border: none;
	border-bottom: 1px solid #f1f5f9;
	font-size: 13px;
	color: #334155;
	vertical-align: middle;
	text-align: center;
}

tr:last-child td {
	border-bottom: none;
}

tr:hover td {
	background: #f8fafc;
}

/* ── 배지 ────────────────────────────────────────── */
.bdg {
	display: inline-flex;
	align-items: center;
	padding: 3px 9px;
	border-radius: 100px;
	font-size: 11px;
	font-weight: 700;
	white-space: nowrap;
}

.bdg-green {
	background: var(--green-lt);
	color: #065F46;
}

.bdg-amber {
	background: var(--amber-lt);
	color: #92400E;
}

.bdg-red {
	background: var(--red-lt);
	color: #991B1B;
}

.bdg-gray {
	background: var(--gray7);
	color: var(--gray3);
}

.cat-bdg {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 4px;
	font-size: 11px;
	font-weight: 600;
	background: var(--blue-lt);
	color: var(--blue);
}

/* ── 재고율 바 ───────────────────────────────────── */
.prog-wrap {
	display: flex;
	align-items: center;
	gap: 8px;
}

.prog-track {
	flex: 1;
	height: 6px;
	background: var(--gray6);
	border-radius: 3px;
	overflow: hidden;
	min-width: 80px;
}

.prog-fill {
	height: 100%;
	border-radius: 3px;
}

.prog-ok   { background: var(--blue);  }
.prog-warn { background: var(--amber); }
.prog-low  { background: var(--red);   }
.prog-zero { background: var(--gray5); }

.prog-pct {
	font-size: 11px;
	color: var(--gray3);
	width: 34px;
	text-align: right;
	font-family: 'DM Mono', monospace;
	flex-shrink: 0;
}

/* ── 관리 버튼 ───────────────────────────────────── */
.btn-detail {
	padding: 4px 10px;
	font-size: 11px;
	font-weight: 600;
	border: 1.5px solid var(--gray5);
	border-radius: 5px;
	background: var(--white);
	color: var(--gray2);
	cursor: pointer;
	transition: all .15s;
}

.btn-detail:hover {
	border-color: var(--blue);
	color: var(--blue);
}

.btn-delete {
	padding: 4px 10px;
	font-size: 11px;
	font-weight: 600;
	border: 1.5px solid #FECACA;
	border-radius: 5px;
	background: var(--red-lt);
	color: var(--red);
	cursor: pointer;
	transition: all .15s;
}

.btn-delete:hover {
	background: var(--red);
	color: #fff;
}

.stock-num {
	font-family: 'DM Mono', monospace;
	font-size: 15px;
	font-weight: 700;
	color: var(--gray1);
}

.stock-num.zero {
	color: var(--red);
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/log_header.jsp" />

	<!-- ═══ MAIN ═══ -->
	<main class="main">

		<!-- TOPBAR -->
		<div class="topbar">
			<div class="breadcrumb">
				<span class="breadcrumb-root">Step WMS</span>
				<span class="breadcrumb-sep">›</span>
				<span class="breadcrumb-root">재고 관리</span>
				<span class="breadcrumb-sep">›</span>
				<span class="breadcrumb-cur">상품 마스터 관리</span>
			</div>
			<div class="topbar-right">
				<div class="tb-date">2025-04-24 &nbsp;09:14</div>
				<div class="tb-btn">🔔
					<div class="notif-dot"></div>
				</div>
			</div>
		</div>

		<!-- 툴바 -->
		<div class="toolbar">
			<form action="${pageContext.request.contextPath}/logis/prod"
				method="get"
				style="display:flex; align-items:center; gap:10px; flex:1;">

				<div class="search-wrap">
					<span class="search-ico">🔍</span>
					<input type="text" name="keyword" value="${param.keyword}"
						placeholder="품번·상품명·브랜드 검색">
				</div>

				<select class="sel" name="brand">
					<option value="">전체 브랜드</option>
					<option value="나이키"   ${param.brand eq '나이키'   ? 'selected' : ''}>나이키</option>
					<option value="아디다스" ${param.brand eq '아디다스' ? 'selected' : ''}>아디다스</option>
					<option value="뉴발란스" ${param.brand eq '뉴발란스' ? 'selected' : ''}>뉴발란스</option>
					<option value="호카"     ${param.brand eq '호카'     ? 'selected' : ''}>호카</option>
					<option value="버켄스탁" ${param.brand eq '버켄스탁' ? 'selected' : ''}>버켄스탁</option>
				</select>

				<select class="sel" name="status">
					<option value="">전체 상태</option>
					<option value="1" ${param.status eq '1' ? 'selected' : ''}>판매중</option>
					<option value="2" ${param.status eq '2' ? 'selected' : ''}>숨김</option>
					<option value="3" ${param.status eq '3' ? 'selected' : ''}>품절</option>
				</select>

				<button type="submit" style="display:none;"></button>
			</form>

			<div class="toolbar-right">
				<button class="btn btn-blue"
					onclick="location.href='${pageContext.request.contextPath}/logis/prod/reg'">
					+ 상품 등록
				</button>
			</div>
		</div>

		<!-- 콘텐츠 -->
		<div class="content">
			<div class="tbl-card">
				<div class="tbl-wrap">
					<table>
						<thead>
							<tr>
								<th style="width:36px">
									<input type="checkbox" id="chkAll"
										onchange="document.querySelectorAll('.row-chk').forEach(c=>c.checked=this.checked)">
								</th>
								<th>품번 (SKU)</th>
								<th>브랜드</th>
								<th>상품명</th>
								<th>카테고리</th>
								<th>사이즈 범위</th>
								<th>컬러</th>
								<th>총 재고</th>
								<th>재고율</th>
								<th>상태</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<%-- DB 연동 후 list에 데이터가 오면 자동으로 행 추가됨 --%>
							<c:forEach var="prod" items="${list}">
								<c:set var="pct"
									value="${prod.maxQty > 0 ? prod.stockQty * 100 / prod.maxQty : 0}" />
								<c:set var="progCls"
									value="${prod.stockQty == 0 ? 'prog-zero' : pct < 15 ? 'prog-low' : pct < 35 ? 'prog-warn' : 'prog-ok'}" />
								<c:set var="bdgCls"
									value="${prod.prodStatus == 3 ? 'bdg-red' : pct < 20 ? 'bdg-amber' : 'bdg-green'}" />
								<c:set var="bdgTxt"
									value="${prod.prodStatus == 1 ? '판매중' : prod.prodStatus == 2 ? '숨김' : '품절'}" />
								<tr>
									<td><input type="checkbox" class="row-chk"></td>
									<td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--gray3);">${prod.sku}</td>
									<td>${prod.brandName}</td>
									<td style="font-weight:600; color:var(--gray1);">${prod.prodName}</td>
									<td><span class="cat-bdg">${prod.catName}</span></td>
									<td style="font-family:'DM Mono',monospace; font-size:12px;">${prod.sizeRange}</td>
									<td style="text-align:center;">${prod.colorCnt}색</td>
									<td><span class="stock-num ${prod.stockQty == 0 ? 'zero' : ''}">${prod.stockQty}</span></td>
									<td style="min-width:130px;">
										<div class="prog-wrap">
											<div class="prog-track">
												<div class="prog-fill ${progCls}" style="width:${pct}%"></div>
											</div>
											<div class="prog-pct">${pct}%</div>
										</div>
									</td>
									<td><span class="bdg ${bdgCls}">${bdgTxt}</span></td>
									<td style="display:flex; gap:5px; justify-content: center;">
										<button class="btn-detail"
											onclick="location.href='${pageContext.request.contextPath}/logis/prod/detail?prodNum=${prod.prodNum}'">상세</button>
										<button class="btn-delete"
											onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logis/prod/del?prodNum=${prod.prodNum}'">삭제</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>

			<%-- 하단 건수 + 페이징 — DB 연동 후 데이터 있을 때만 표시 --%>
			<c:if test="${not empty list}">
				<div style="display:flex; align-items:center; justify-content:space-between; padding:12px 4px;">
					<div style="font-size:12px; color:var(--gray3);">
						총 <strong style="color:var(--gray1);">${count}</strong>개 상품
						&nbsp;·&nbsp;
						선택 <strong style="color:var(--gray1);" id="selCount">0</strong>개
					</div>
					<div>${page}</div>
				</div>
			</c:if>
		</div>
		<%-- /content --%>

	</main>

<script>
/* 선택 개수 카운트 */
document.querySelectorAll('.row-chk').forEach(function(chk) {
    chk.addEventListener('change', function() {
        var n = document.querySelectorAll('.row-chk:checked').length;
        var el = document.getElementById('selCount');
        if (el) el.textContent = n;
    });
});
</script>

</body>
</html>