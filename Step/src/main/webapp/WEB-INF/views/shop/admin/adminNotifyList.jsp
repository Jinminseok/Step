<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 알림 발송 이력</title>
<link
	href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
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
	margin: 0 auto;
}

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

/* 탭 메뉴 */
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

.tab-item.active {
	color: #3b82f6;
	border-bottom: 2px solid #3b82f6;
	font-weight: 600;
}

/* 버튼 스타일 */
.btn-primary {
	padding: 10px 18px;
	font-size: 13.5px;
	font-weight: 600;
	color: #fff;
	background-color: #3b82f6;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 8px;
	text-decoration: none;
	transition: background 0.2s;
}

.btn-primary:hover {
	background-color: #2563eb;
}

/* 필터 패널 */
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
	gap: 15px;
	align-items: flex-end;
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
}

.filter-select {
	padding: 9px 14px;
	font-size: 13.5px;
	color: #334155;
	background-color: #fff;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	min-width: 150px;
	outline: none;
}

.search-input {
	padding: 9px 14px;
	font-size: 13.5px;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	width: 280px;
	outline: none;
}

.btn-search {
	padding: 9px 16px;
	font-size: 13.5px;
	font-weight: 600;
	color: #fff;
	background-color: #1e293b;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	height: 38px;
}

/* 테이블 스타일 */
.tbl-wrap {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
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

tr:hover td {
	background: #f8fafc;
}

/* 배지 */
.type-badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 11.5px;
	font-weight: 600;
}

.type-delivery {
	color: #059669;
	background: #dcfce7;
}

.type-restock {
	color: #2563eb;
	background: #dbeafe;
}

.type-notice {
	color: #d9480f;
	background: #fff4e6;
}

.read-badge {
	font-size: 12px;
	font-weight: 500;
	color: #94a3b8;
}

.read-unread {
	color: #ef4444;
	font-weight: 600;
}

.pagination-wrap {
	padding: 20px;
	background: #fff;
	border-top: 1px solid #e2e8f0;
	display: flex;
	justify-content: center;
}
</style>
<script type="text/javascript">
	function changeType(type) {
		location.href = 'notifyList.do?notify_type=' + type;
	}
</script>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<div class="content">
			<div class="page-hdr">
				<div>
					<div class="page-hdr-title">알림 발송 관리</div>
					<div class="page-hdr-sub">고객에게 발송된 배송, 재입고, 공지 알림 내역을 실시간
						모니터링합니다.</div>
				</div>
				<a href="sendNotice.do" class="btn-primary"> <i
					class="fa-solid fa-paper-plane"></i> 전체 공지 알림 발송
				</a>
			</div>

			<div class="tab-filter-container">
				<div class="tab-menu">
					<div class="tab-item ${notify_type == 0 ? 'active' : ''}"
						onclick="changeType(0)">전체 내역</div>
					<div class="tab-item ${notify_type == 1 ? 'active' : ''}"
						onclick="changeType(1)">배송 알림</div>
					<div class="tab-item ${notify_type == 2 ? 'active' : ''}"
						onclick="changeType(2)">재입고 알림</div>
					<div class="tab-item ${notify_type == 3 ? 'active' : ''}"
						onclick="changeType(3)">공지 알림</div>
				</div>
			</div>

			<div class="filter-panel">
				<form action="notifyList.do" method="get" class="filter-form">
					<input type="hidden" name="notify_type" value="${notify_type}">
					<div class="filter-group">
						<label class="filter-label">통합 검색</label> <input type="text"
							name="keyword" class="search-input"
							placeholder="수신자 ID, 이름, 알림 제목 검색" value="${keyword}">
					</div>
					<button type="submit" class="btn-search">조회</button>
				</form>
			</div>

			<div class="tbl-wrap">
				<table class="notify-table">
					<thead>
						<tr>
							<th width="100">번호</th>
							<th width="120">유형</th>
							<th width="160">수신자 (ID/이름)</th>
							<th style="text-align: left; padding-left: 20px;">알림 내용 요약</th>
							<th width="180">발송 일시</th>
							<th width="100">읽음 여부</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${count == 0}">
							<tr>
								<td colspan="6" style="padding: 60px 0; color: #94a3b8;"><i
									class="fa-solid fa-bell-slash"
									style="font-size: 32px; margin-bottom: 12px; display: block; color: #cbd5e1;"></i>
									발송된 알림 내역이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${count > 0}">
							<c:forEach var="n" items="${list}">
								<tr>
									<td>${n.notify_num}</td>
									<td><c:choose>
											<c:when test="${n.notify_type == 1}">
												<span class="type-badge type-delivery">배송</span>
											</c:when>
											<c:when test="${n.notify_type == 2}">
												<span class="type-badge type-restock">재입고</span>
											</c:when>
											<c:otherwise>
												<span class="type-badge type-notice">공지</span>
											</c:otherwise>
										</c:choose></td>
									<td style="font-weight: 500;">${n.user_id}
										(${n.user_name})</td>
									<td style="text-align: left; padding-left: 20px;">
										<div
											style="font-weight: 600; color: #0f172a; margin-bottom: 2px;">${n.notify_title}</div>
										<div style="font-size: 13px; color: #64748b;">${n.notify_content}</div>
									</td>
									<td style="color: #64748b;"><fmt:formatDate
											value="${n.notify_created_at}" pattern="yyyy-MM-dd HH:mm" /></td>
									<td><c:choose>
											<c:when test="${n.read_yn == 'Y'}">
												<span class="read-badge">읽음</span>
											</c:when>
											<c:otherwise>
												<span class="read-badge real-unread">미읽음</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
				<div class="pagination-wrap">${page}</div>
			</div>
		</div>
	</div>
</body>
</html>