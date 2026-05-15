<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 주문 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
	/* ── TOP BAR 및 MAIN 스타일 ── */
	.main { margin-left:220px; flex:1; display:flex; flex-direction:column; min-height:100vh; background-color: #f8f9fa; }
	.topbar { height:54px; border-bottom:1px solid #1a1a1a; display:flex; align-items:center; padding:0 24px; gap:12px; background:var(--black, #111); position:sticky; top:0; z-index:50; }
	.topbar-title { font-family:'Space Grotesk',sans-serif; font-size:14px; font-weight:700; color:#fff; letter-spacing:.02em; }
	.topbar-path { font-size:11px; color:#444; }
	.topbar-right { margin-left:auto; display:flex; align-items:center; gap:8px; }
	.t-btn { width:32px; height:32px; border:1px solid #333; background:transparent; display:flex; align-items:center; justify-content:center; cursor:pointer; font-size:14px; color:#888; border-radius:2px; }
	.t-btn:hover { border-color:#555; color:#fff; }
	.content { padding:24px; flex:1; }

    /* ── 추가 UI 스타일 ── */
    .card { background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
    .filter-grid { display: flex; flex-wrap: wrap; gap: 15px; align-items: center; }
    .filter-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #333; font-weight: 500; }
    .fi-input, .fi-select { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; outline: none; font-size: 13px; }
    .btn-dark { background: #111; color: #fff; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 13px; }
    .btn-light { background: #fff; color: #111; border: 1px solid #ccc; padding: 8px 20px; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 13px; }

    /* 테이블 영역 (좌측 정렬) */
    .ord-table { width: 100%; border-collapse: collapse; font-size: 13px; }
    .ord-table th { text-align: left; background: #f1f3f5; padding: 14px 16px; font-weight: 700; color: #333; border-bottom: 2px solid #ddd; }
    .ord-table td { text-align: left; padding: 14px 16px; border-bottom: 1px solid #eee; vertical-align: middle; color: #555; white-space: nowrap; }
    .ord-table tbody tr:hover { background: #fafafa; }
    .ord-table th:first-child, .ord-table td:first-child { text-align: center; width: 40px; padding: 14px 8px; }
    .ord-table th:last-child, .ord-table td:last-child { text-align: center; width: 80px; }
    
    /* 상태 뱃지 */
    .badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; display: inline-block; }
    .b-pending { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
    .b-paid    { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .b-ship    { background: #cce5ff; color: #004085; border: 1px solid #b8daff; }
    .b-done    { background: #e2e3e5; color: #383d41; border: 1px solid #d6d8db; }
    .b-cancel  { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

    /* 🌟 페이징 스타일 (PagingUtil 호환) */
	.pagination-wrap { display: flex; justify-content: center; align-items: center; margin-top: 30px; gap: 5px; font-size: 14px; }
	.pagination-wrap a { padding: 6px 12px; border: 1px solid #ddd; color: #333; text-decoration: none; border-radius: 4px; }
	.pagination-wrap a:hover { background: #f1f1f1; }
	.pagination-wrap b span { padding: 6px 12px; border: 1px solid #111; background: #111; color: #fff !important; border-radius: 4px; }

    .txt-bold { font-weight: 700; color: #111; }
    .txt-mono { font-family: 'Consolas', monospace; }

	/* 모달 CSS 유지 */
	.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: none; justify-content: center; align-items: center; z-index: 9999; }
	.modal-content { background: #fff; width: 900px; max-height: 90vh; overflow-y: auto; border-radius: 10px; padding: 25px; position: relative; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
	.modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #111; padding-bottom: 15px; margin-bottom: 20px; }
	.modal-title { font-size: 18px; font-weight: 700; color: #111; }
	.btn-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #666; }
	.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px; }
	.info-box { background: #f8f9fa; border: 1px solid #eee; border-radius: 6px; padding: 15px; }
	.info-box-title { font-size: 14px; font-weight: 700; color: #111; margin-bottom: 12px; border-bottom: 1px dashed #ccc; padding-bottom: 8px; }
	.info-row { display: flex; font-size: 13px; margin-bottom: 8px; }
	.info-label { width: 90px; color: #666; font-weight: 500; }
	.info-val { flex: 1; color: #222; font-weight: 600; }
	.mdl-table { width: 100%; border-collapse: collapse; text-align: center; font-size: 13px; margin-bottom: 20px; }
	.mdl-table th { background: #f1f3f5; padding: 10px; font-weight: 700; color: #333; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; }
	.mdl-table td { padding: 10px; border-bottom: 1px solid #eee; vertical-align: middle; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>

	<div class="main">
		  <div class="topbar">
		    <div class="topbar-title">주문 관리</div>
		    <div class="topbar-path">Admin > 주문 관리</div>
		  </div>

		<div class="content">
			
			<div class="card">
                <form id="searchForm" action="adminorderForm.do" method="get">
					<div class="filter-grid">
						<div class="filter-item">
							<label>조회 기간</label>
							<input type="date" class="fi-input" name="sDate" value="${param.sDate}"> ~ 
                            <input type="date" class="fi-input" name="eDate" value="${param.eDate}">
						</div>
						
						<div class="filter-item">
							<label>주문 상태</label>
							<select class="fi-select" name="sStatus">
								<option value="ALL" ${param.sStatus == 'ALL' ? 'selected' : ''}>전체보기</option>
								<option value="1" ${param.sStatus == '1' ? 'selected' : ''}>결제대기/신규</option>
								<option value="2" ${param.sStatus == '2' ? 'selected' : ''}>상품준비중</option>
								<option value="3" ${param.sStatus == '3' ? 'selected' : ''}>배송중</option>
								<option value="4" ${param.sStatus == '4' ? 'selected' : ''}>배송완료</option>
								<option value="9" ${param.sStatus == '9' ? 'selected' : ''}>주문취소</option>
							</select>
						</div>

						<div class="filter-item">
							<label>검색어</label>
							<select class="fi-select" name="sKeywordType">
								<option value="ordNum" ${param.sKeywordType == 'ordNum' ? 'selected' : ''}>주문번호</option>
								<option value="orderName" ${param.sKeywordType == 'orderName' ? 'selected' : ''}>주문자명</option>
								<option value="recvName" ${param.sKeywordType == 'recvName' ? 'selected' : ''}>수령인명</option>
								<option value="recvPhone" ${param.sKeywordType == 'recvPhone' ? 'selected' : ''}>연락처</option>
							</select>
							<input type="text" class="fi-input" name="sKeyword" value="${param.sKeyword}" placeholder="검색어 입력" style="width:200px;">
						</div>

						<div class="filter-item" style="margin-left: auto;">
							<button type="button" class="btn-light" onclick="location.href='adminorderForm.do'">초기화</button>
							<button type="submit" class="btn-dark">검색</button>
						</div>
					</div>
				</form>
			</div>

			<div class="card">
				<div style="margin-bottom: 15px; font-size: 14px; font-weight: 600;">
					총 검색 결과: <span style="color: #e53935;">${count}</span> 건
				</div>
				
				<div style="overflow-x: auto;">
					<table class="ord-table">
						<thead>
							<tr>
								<th><input type="checkbox"></th>
								<th>주문일시</th>
								<th>주문번호</th>
								<th>주문상품</th>
								<th>주문자</th>
								<th>총 결제금액</th>
								<th>결제수단</th>
								<th>주문상태</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<%-- 🌟 JSTL을 이용한 실제 DB 데이터 출력 --%>
							<c:if test="${empty orderList}">
								<tr><td colspan="9" style="text-align:center; padding:50px;">조회된 주문 내역이 없습니다.</td></tr>
							</c:if>
							
							<c:forEach var="item" items="${orderList}">
							<tr>
								<td><input type="checkbox"></td>
								<td>${item.orderDate}</td>
								<td class="txt-bold txt-mono">${item.ordNum}</td>
								<td>${item.prodTitle}</td>
								<td>${item.orderName}</td>
								<td class="txt-bold"><fmt:formatNumber value="${item.payPrice}" pattern="#,###"/>원</td>
								<td>${item.payMethod}</td>
								<td>
									<c:choose>
										<c:when test="${item.orderStatus == 1}"><span class="badge b-paid">결제완료</span></c:when>
										<c:when test="${item.orderStatus == 2}"><span class="badge b-pending">상품준비중</span></c:when>
										<c:when test="${item.orderStatus == 3}"><span class="badge b-ship">배송중</span></c:when>
										<c:when test="${item.orderStatus == 4}"><span class="badge b-done">배송완료</span></c:when>
										<c:when test="${item.orderStatus == 5}"><span class="badge b-cancel">주문취소</span></c:when>
										<c:otherwise><span class="badge b-pending">알수없음</span></c:otherwise>
									</c:choose>
								</td>
								<td><button type="button" class="btn-light" style="padding: 4px 10px; font-size: 11px;" onclick="openOrderModal('${item.ordNum}')">상세</button></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="pagination-wrap">
					${page}
				</div>
			</div>

		</div>
	 </div> 

	 <div class="modal-overlay" id="orderModal">
		<div class="modal-content">
			<div class="modal-header">
				<div class="modal-title">📋 주문 상세 정보 (<span id="mdlOrdNum" class="txt-mono" style="color:#1a73e8;"></span>)</div>
				<button class="btn-close" onclick="closeOrderModal()">&times;</button>
			</div>

			<div class="info-grid">
				<div class="info-box">
					<div class="info-box-title">👤 주문자 및 배송지 정보</div>
                    <div class="info-row"><div class="info-label" style="color:#1a73e8; font-weight:700;">주문자명</div><div class="info-val" id="mdlOrderName" style="color:#1a73e8; font-weight:700;"></div></div>
					<div class="info-row"><div class="info-label">수령인명</div><div class="info-val" id="mdlRecvName"></div></div>
					<div class="info-row"><div class="info-label">연락처</div><div class="info-val" id="mdlRecvPhone"></div></div>
					<div class="info-row"><div class="info-label">우편번호</div><div class="info-val" id="mdlRecvZip"></div></div>
					<div class="info-row"><div class="info-label">주소</div><div class="info-val" id="mdlRecvAddr"></div></div>
				</div>

				<div class="info-box">
					<div class="info-box-title">💳 결제 및 주문 상태</div>
					<div class="info-row"><div class="info-label">주문일시</div><div class="info-val" id="mdlOrderDate"></div></div>
					<div class="info-row"><div class="info-label">결제상태</div><div class="info-val" id="mdlOrderStatus"></div></div>
					<div class="info-row"><div class="info-label">결제수단</div><div class="info-val" id="mdlPayMethod"></div></div>
					<div class="info-row"><div class="info-label">총 결제금액</div><div class="info-val" id="mdlPayPrice" style="color:#e53935; font-size:15px;"></div></div>
				</div>
			</div>

			<div class="info-box-title" style="margin-bottom: 10px;">📦 주문 상품 목록</div>
			<table class="mdl-table">
				<thead>
					<tr>
						<th>상품번호</th>
						<th>상품명 / 옵션</th>
						<th>수량</th>
						<th>상품단가</th>
						<th>주문금액</th>
					</tr>
				</thead>
				<tbody id="mdlItemsTbody">
                    </tbody>
			</table>

			<div style="text-align: right; margin-top: 20px;">
				<button type="button" class="btn-dark" onclick="closeOrderModal()">닫기</button>
			</div>
		</div>
	 </div>

	 <script>
		function openOrderModal(ordNum) {
			document.getElementById('mdlOrdNum').innerText = ordNum;
            document.getElementById('mdlItemsTbody').innerHTML = '<tr><td colspan="5" style="padding:30px; color:#999;">데이터를 불러오는 중입니다... ⏳</td></tr>';
			document.getElementById('orderModal').style.display = 'flex';

            fetch('${pageContext.request.contextPath}/shop/admin_order/orderDetail.do?ordNum=' + ordNum)
                .then(res => res.json())
                .then(data => {
                    if(data.result === 'error') {
                        alert("서버 에러 발생!\n내용: " + data.message);
                        document.getElementById('mdlItemsTbody').innerHTML = '<tr><td colspan="5" style="color:red; font-weight:bold;">데이터 조회 실패</td></tr>';
                        return; 
                    }

                    // ── 정상 데이터 세팅 ──
                    const m = data.master;
                    document.getElementById('mdlOrderName').innerText = m.orderName;
                    document.getElementById('mdlRecvName').innerText = m.recvName;
                    document.getElementById('mdlRecvPhone').innerText = m.recvPhone;
                    document.getElementById('mdlRecvZip').innerText = m.recvZip;
                    document.getElementById('mdlRecvAddr').innerHTML = m.recvAddr1 + '<br>' + m.recvAddr2;
                    document.getElementById('mdlOrderDate').innerText = m.orderDate;
                    document.getElementById('mdlPayMethod').innerText = m.payMethod;
                    document.getElementById('mdlPayPrice').innerText = Number(m.payPrice).toLocaleString() + ' 원';

                    let statusHtml = '';
                    if(m.orderStatus == 1) statusHtml = '<span class="badge b-paid">결제완료</span>';
                    else if(m.orderStatus == 2) statusHtml = '<span class="badge b-pending">상품준비중</span>';
                    else if(m.orderStatus == 3) statusHtml = '<span class="badge b-ship">배송중</span>';
                    else if(m.orderStatus == 4) statusHtml = '<span class="badge b-done">배송완료</span>';
                    else if(m.orderStatus == 9) statusHtml = '<span class="badge b-cancel">주문취소</span>';
                    document.getElementById('mdlOrderStatus').innerHTML = statusHtml;

                    let itemHtml = '';
                    if(data.items && data.items.length > 0) {
                        data.items.forEach(item => {
                            let itemTotal = item.price * item.qty;
                            itemHtml += '<tr>' +
                                '<td class="txt-mono">' + item.prodNum + '</td>' +
                                '<td style="text-align: left;">' + item.prodName + '<br><span style="color:#666; font-size:11px;">옵션: ' + item.color + ' / ' + item.size + '</span></td>' +
                                '<td>' + item.qty + '</td>' +
                                '<td>' + Number(item.price).toLocaleString() + ' 원</td>' +
                                '<td class="txt-bold">' + itemTotal.toLocaleString() + ' 원</td>' +
                                '</tr>';
                        });
                    } else {
                        itemHtml = '<tr><td colspan="5" style="padding:30px; color:#999;">주문 상품 정보가 없습니다.</td></tr>';
                    }
                    document.getElementById('mdlItemsTbody').innerHTML = itemHtml;
                })
                .catch(err => {
                    console.error("Fetch 에러:", err);
                    alert("서버와 통신하는 중 문제가 발생했습니다.");
                });
		}

		function closeOrderModal() {
			document.getElementById('orderModal').style.display = 'none';
		}

		window.onclick = function(event) {
			var modal = document.getElementById('orderModal');
			if (event.target == modal) {
				modal.style.display = "none";
			}
		}
	 </script>
</body>
</html>