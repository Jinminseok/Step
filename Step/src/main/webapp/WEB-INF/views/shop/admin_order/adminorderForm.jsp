<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 주문 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
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

/* 👇 사이드바 너비만큼 본문을 밀어줍니다 */
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

/* CARD CONTAINER */
.card { background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }

/* ── 🚨 필터 툴바 (높이 및 배치 완벽 정렬) ── */
.filter-grid { display: flex; flex-wrap: wrap; gap: 16px; align-items: center; }
.filter-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #475569; font-weight: 500; }

.fi-input, .fi-select { 
    height: 40px; /* 높이 40px 통일 */
    padding: 0 12px; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    outline: none; 
    font-size: 13px; 
    background: #fff;
    color: #1e293b;
    transition: all 0.2s ease;
}
.fi-select { padding-right: 30px; cursor: pointer; }
.fi-input:focus, .fi-select:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

/* BUTTONS */
.btn-dark { 
    height: 40px; 
    padding: 0 20px; 
    background: #111827; 
    color: #fff; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-weight: 600; 
    font-size: 13px; 
    transition: background 0.2s;
}
.btn-dark:hover { background: #374151; }

.btn-light { 
    height: 40px; 
    padding: 0 20px; 
    background: #fff; 
    color: #475569; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    cursor: pointer; 
    font-weight: 600; 
    font-size: 13px; 
    transition: all 0.2s;
}
.btn-light:hover { border-color: #111827; color: #111827; }
.btn-xs { height: 28px; padding: 0 10px; font-size: 11px; }

/* ORDER TABLE LIST */
.ord-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.ord-table th { text-align: left; background: #f8fafc; padding: 14px 16px; font-weight: 600; color: #475569; border-bottom: 1px solid #e2e8f0; }
.ord-table td { text-align: left; padding: 14px 16px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; color: #334155; white-space: nowrap; }
.ord-table tbody tr:hover { background: #f8fafc; }
.ord-table th:first-child, .ord-table td:first-child { text-align: center; width: 50px; padding: 14px 8px; }
.ord-table th:last-child, .ord-table td:last-child { text-align: center; width: 90px; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
.b-paid    { background: #dcfce7; color: #059669; }   /* 결제완료 (그린) */
.b-pending { background: #fff4e6; color: #d9480f; }   /* 상품준비중 (오렌지) */
.b-ship    { background: #dbeafe; color: #2563eb; }   /* 배송중 (블루) */
.b-done    { background: #f1f5f9; color: #64748b; }   /* 배송완료 (그레이) */
.b-cancel  { background: #fef2f2; color: #ef4444; }   /* 주문취소 (레드) */

/* 🌟 PAGINATION (새로 추가된 스타일) 🌟 */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 0 0 0;border-top:1px solid #e2e8f0;background:#fff;margin-top:16px;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

.txt-bold { font-weight: 600; color: #0f172a; }
.txt-mono { font-family: 'Space Grotesk', sans-serif; font-weight: 700; }

/* ── MODAL OVERLAY & BOX (통일감 구현) ── */
.modal-overlay { 
    position: fixed; inset: 0; background: rgba(0,0,0,0.5); 
    display: none; align-items: center; justify-content: center; 
    z-index: 3000; 
}
.modal-box { 
    background: #fff; width: 840px; border-radius: 12px; max-height: 90vh; 
    display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; 
}
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }

/* MODAL DETAILS */
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
.info-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 18px; }
.info-box-title { font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 12px; border-bottom: 2px solid #0f172a; padding-bottom: 6px; }
.info-row { display: flex; font-size: 13.5px; margin-bottom: 10px; border-bottom: 1px dashed #e2e8f0; padding-bottom: 6px; }
.info-row:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
.info-label { width: 95px; color: #64748b; font-weight: 500; flex-shrink: 0; }
.info-val { flex: 1; color: #0f172a; font-weight: 600; }

.mdl-table { width: 100%; border-collapse: collapse; font-size: 13.5px; margin-bottom: 10px; }
.mdl-table th { background: #f8fafc; padding: 12px 10px; font-weight: 600; color: #475569; border-top: 1px solid #e2e8f0; border-bottom: 1px solid #e2e8f0; }
.mdl-table td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; color: #334155; }
.mdl-table tr:last-child td { border-bottom: none; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>

	<div class="main">
		<c:set var="pageTitle" value="주문 관리" scope="request" />
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
		
			 <div class="page-hdr">
		      <div>
		        <div class="page-hdr-title">주문 관리</div>
		        <div class="page-hdr-sub">고객 주문을 관리합니다. 상세 버튼을 통해 주문 상세를 확인 가능합니다.</div>
		      </div>
		    </div>
			
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
								<option value="1" ${param.sStatus == '1' ? 'selected' : ''}>결제완료</option>
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
							<button type="button" class="btn-light" onclick="location.href='adminorderForm.do'"><i class="fa-solid fa-rotate-right"></i> 초기화</button>
							<button type="submit" class="btn-dark"><i class="fa-solid fa-magnifying-glass"></i> 검색</button>
						</div>
					</div>
				</form>
			</div>

			<div class="card">
				<div style="margin-bottom: 16px; font-size: 14px; font-weight: 600; color:#475569;">
					총 검색 결과: <span style="color: #ef4444; font-family:'Space Grotesk', sans-serif; font-weight:700;">${count}</span> 건
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
						<%-- 🌟 id="orderTbody" 추가 🌟 --%>
						<tbody id="orderTbody">
							<c:if test="${empty orderList}">
								<tr><td colspan="9" style="text-align:center; padding:60px 0; color:#94a3b8;"><i class="fa-solid fa-folder-open" style="font-size:32px; margin-bottom:12px; display:block; color:#e2e8f0;"></i>조회된 주문 내역이 없습니다.</td></tr>
							</c:if>
							
							<c:forEach var="item" items="${orderList}">
							<%-- 🌟 class="order-row" 추가 🌟 --%>
							<tr class="order-row">
								<td><input type="checkbox"></td>
								<td style="color:#64748b; font-size:13px;">${item.orderDate}</td>
								<td class="txt-bold txt-mono" style="color:#1a73e8;">${item.ordNum}</td>
								<td style="font-weight: 500; color:#0f172a;">${item.prodTitle}</td>
								<td>${item.orderName}</td>
								<td class="txt-bold" style="font-family:'Space Grotesk';"><fmt:formatNumber value="${item.payPrice}" pattern="#,###"/>원</td>
								<td style="color:#475569; font-size:13px;">${item.payMethod}</td>
								<td>
									<c:choose>
										<c:when test="${item.orderStatus == 1}"><span class="badge b-paid">● 결제완료</span></c:when>
										<c:when test="${item.orderStatus == 2}"><span class="badge b-pending">● 상품준비중</span></c:when>
										<c:when test="${item.orderStatus == 3}"><span class="badge b-ship">● 배송중</span></c:when>
										<c:when test="${item.orderStatus == 4}"><span class="badge b-done">● 배송완료</span></c:when>
										<c:when test="${item.orderStatus == 5 || item.orderStatus == 9}"><span class="badge b-cancel">● 주문취소</span></c:when>
										<c:otherwise><span class="badge b-pending">● 알수없음</span></c:otherwise>
									</c:choose>
								</td>
								<td><button type="button" class="btn-light btn-xs" onclick="openOrderModal('${item.ordNum}')">상세</button></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<%-- 🌟 PAGINATION HTML (새로 교체됨) 🌟 --%>
				<div class="pagination-wrap" id="orderPagination" style="display:none;">
					<div class="page-info" id="orderPageInfo">총 <strong>0</strong>건</div>
					<div class="page-btns" id="orderPageBtns"></div>
				</div>

			</div>

		</div>
	 </div> 

	<div class="modal-overlay" id="orderModal">
		<div class="modal-box">
			<div class="modal-hdr">
				<div class="modal-title">📋 주문 상세 정보 (<span id="mdlOrdNum" class="txt-mono" style="color:#1a73e8;"></span>)</div>
				<button type="button" class="modal-close" onclick="closeOrderModal()"><i class="fa-solid fa-xmark"></i></button>
			</div>

			<div class="modal-body">
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
						<div class="info-row"><div class="info-label">총 결제금액</div><div class="info-val" id="mdlPayPrice" style="color:#ef4444; font-size:16px; font-family:'Space Grotesk'; font-weight: 700;"></div></div>
					</div>
				</div>
	
				<div class="info-box-title" style="margin-bottom: 12px;">📦 주문 상품 목록</div>
				<table class="mdl-table">
					<thead>
						<tr>
							<th style="width:100px;">상품번호</th>
							<th style="text-align: left;">상품명 / 옵션</th>
							<th style="width:80px;">수량</th>
							<th style="width:120px;">상품단가</th>
							<th style="width:140px;">주문금액</th>
						</tr>
					</thead>
					<tbody id="mdlItemsTbody">
	                </tbody>
				</table>
	
				<div style="text-align: right; margin-top: 24px;">
					<button type="button" class="btn-dark" onclick="closeOrderModal()">닫기</button>
				</div>
			</div>
		</div>
	 </div>

	 <script>
		function openOrderModal(ordNum) {
			document.getElementById('mdlOrdNum').innerText = ordNum;
            document.getElementById('mdlItemsTbody').innerHTML = '<tr><td colspan="5" style="padding:30px; text-align:center; color:#999;"><i class="fa-solid fa-spinner fa-spin" style="font-size:20px; margin-bottom:8px; display:block;"></i>데이터를 불러오는 중입니다... ⏳</td></tr>';
			document.getElementById('orderModal').style.display = 'flex';

            fetch('${pageContext.request.contextPath}/shop/admin_order/orderDetail.do?ordNum=' + ordNum)
                .then(res => res.json())
                .then(data => {
                    if(data.result === 'error') {
                        alert("서버 에러 발생!\n내용: " + data.message);
                        document.getElementById('mdlItemsTbody').innerHTML = '<tr><td colspan="5" style="color:#ef4444; font-weight:bold; text-align:center;">데이터 조회 실패</td></tr>';
                        return; 
                    }

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
                    if(m.orderStatus == 1) statusHtml = '<span class="badge b-paid">● 결제완료</span>';
                    else if(m.orderStatus == 2) statusHtml = '<span class="badge b-pending">● 상품준비중</span>';
                    else if(m.orderStatus == 3) statusHtml = '<span class="badge b-ship">● 배송중</span>';
                    else if(m.orderStatus == 4) statusHtml = '<span class="badge b-done">● 배송완료</span>';
                    else if(m.orderStatus == 5 || m.orderStatus == 9) statusHtml = '<span class="badge b-cancel">● 주문취소</span>';
                    document.getElementById('mdlOrderStatus').innerHTML = statusHtml;

                    let itemHtml = '';
                    if(data.items && data.items.length > 0) {
                        data.items.forEach(item => {
                            let itemTotal = item.price * item.qty;
                            itemHtml += '<tr>' +
                                '<td class="txt-mono">' + item.prodNum + '</td>' +
                                '<td style="text-align: left; font-weight:500;">' + item.prodName + '<br><span style="color:#64748b; font-size:11px;">옵션: ' + item.color + ' / ' + item.size + '</span></td>' +
                                '<td>' + item.qty + '</td>' +
                                '<td style="font-family:\'Space Grotesk\';">' + Number(item.price).toLocaleString() + ' 원</td>' +
                                '<td class="txt-bold" style="font-family:\'Space Grotesk\';">' + itemTotal.toLocaleString() + ' 원</td>' +
                                '</tr>';
                        });
                    } else {
                        itemHtml = '<tr><td colspan="5" style="padding:30px; text-align:center; color:#94a3b8;">주문 상품 정보가 없습니다.</td></tr>';
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

		// 🌟 PAGINATION JAVASCRIPT LOGIC (새로 추가됨) 🌟
		let currentOrderPage = 1;
		const orderItemsPerPage = 10; // 한 페이지에 보여줄 개수
		let allOrderRows = [];

		window.addEventListener('load', function() {
			const tbody = document.getElementById('orderTbody');
			if (tbody) {
				allOrderRows = Array.from(tbody.querySelectorAll('tr.order-row'));
				if (allOrderRows.length > 0) {
					renderOrderTable();
				} else {
					document.getElementById('orderPagination').style.display = 'none';
				}
			}
		});

		function renderOrderTable() {
			allOrderRows.forEach(r => r.style.display = 'none');
			const start = (currentOrderPage - 1) * orderItemsPerPage;
			const end = start + orderItemsPerPage;
			
			for (let i = start; i < end && i < allOrderRows.length; i++) {
				allOrderRows[i].style.display = '';
			}
			renderOrderPagination();
		}

		function renderOrderPagination() {
			const totalPages = Math.ceil(allOrderRows.length / orderItemsPerPage);
			const pw = document.getElementById('orderPagination');
			const pi = document.getElementById('orderPageInfo');
			const pb = document.getElementById('orderPageBtns');

			if (!pw || !pb) return;

			if (allOrderRows.length === 0) {
				pw.style.display = 'none';
				return;
			}

			pw.style.display = 'flex';
			const sn = (currentOrderPage - 1) * orderItemsPerPage + 1;
			const en = Math.min(currentOrderPage * orderItemsPerPage, allOrderRows.length);
			
			// JSP 처리 방지를 위해 \${} 이스케이프 사용
			pi.innerHTML = `총 <strong style="color:#0f172a">\${allOrderRows.length}</strong>건 · \${sn}-\${en}`;

			let h = `<div class="pg-btn \${currentOrderPage === 1 ? 'disabled' : ''}" onclick="changeOrderPage(\${currentOrderPage - 1})">‹</div>`;

			// 최대 9개의 버튼만 보여지도록 제한
			let maxVisible = 9;
			let startPage = Math.max(1, currentOrderPage - Math.floor(maxVisible / 2));
			let endPage = Math.min(totalPages, startPage + maxVisible - 1);

			if (endPage - startPage + 1 < maxVisible) {
				startPage = Math.max(1, endPage - maxVisible + 1);
			}

			for (let i = startPage; i <= endPage; i++) {
				h += `<div class="pg-btn \${i === currentOrderPage ? 'on' : ''}" onclick="changeOrderPage(\${i})">\${i}</div>`;
			}

			h += `<div class="pg-btn \${currentOrderPage === totalPages ? 'disabled' : ''}" onclick="changeOrderPage(\${currentOrderPage + 1})">›</div>`;
			pb.innerHTML = h;
		}

		function changeOrderPage(p) {
			const totalPages = Math.ceil(allOrderRows.length / orderItemsPerPage);
			if (p < 1 || p > totalPages) return;
			currentOrderPage = p;
			renderOrderTable();
		}
	 </script>
</body>
</html>