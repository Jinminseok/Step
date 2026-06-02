<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반품/교환 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* CONTENT */
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ══ TAB BAR ══ */
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab:hover:not(.on){color:var(--gray2)}

.date-input{
  padding:7px 10px;border:1.5px solid var(--gray5);background:var(--white);
  font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);
  outline:none;border-radius:6px;transition:border .15s;
}
.date-input:focus{border-color:var(--blue)}

/* ══ TOOLBAR & FILTER BAR ══ */
.filter-container {
  background: #fff; padding: 15px 20px; border-radius: 8px; 
  box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 20px;
}
.filter-form {
  display: flex; align-items: center; justify-content: flex-start; 
  gap: 15px; flex-wrap: wrap;
}
.filter-group {
  display: flex; align-items: center; gap: 8px;
}
.filter-label {
  font-size: 13px; font-weight: 600; color: var(--navy); white-space: nowrap;
}
.filter-select {
  padding: 5px 10px; border: 1px solid var(--gray5); border-radius: 4px; 
  font-size: 13px; cursor: pointer; background: #fff; height: 30px;
}
.filter-input {
  width: 160px; padding: 5px 10px; border: 1px solid var(--gray5); 
  border-radius: 4px; font-size: 13px; height: 30px; box-sizing: border-box;
}

/* ══ BUTTONS ══ */
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-green{background:var(--green);color:#fff}.btn-green:hover{background:#059669}
.btn-red{background:var(--red);color:#fff}.btn-red:hover{background:#DC2626}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-sm{padding:7px 13px;font-size:12px}
.btn-xs{padding:4px 10px;font-size:11px}

/* ══ TABLE ══ */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:8px;flex-wrap:wrap}
.tbl-top-info{font-size:12px;color:var(--gray3)}.tbl-top-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}

/* ══ BADGE ══ */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-gray{background:var(--gray7);color:var(--gray3)}

/* ══ PAGINATION ══ */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* DETAIL ROWS */
.dr{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7)}
.dr:last-child{border-bottom:none}
.dk{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:110px;flex-shrink:0;padding-top:1px}
.dv{font-size:13px;color:var(--gray1);flex:1}

/* SECTION TITLE */
.sec-title{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px}
.sec-title::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/log_header.jsp"/>
<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur">반품 / 교환 관리</span>
    </div>
        <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>      
    </div>
  </div>

  <div class="content">
    <div class="tab-bar">
      <div class="tab on" onclick="switchTab('sec-claim', this)">접수된 클레임 처리</div>
      <div class="tab" onclick="switchTab('sec-hist', this)">클레임 처리 이력 조회</div>
    </div>

  <div id="sec-claim">
    <div class="filter-container">
      <form id="searchFilterForm" onsubmit="applyFilters(event)" class="filter-form">
        <div class="filter-group">
          <span class="filter-label">📅 접수 기간</span>
          <input type="date" id="filter-start-date" class="date-input">
          <span style="color: var(--gray3);">~</span>
          <input type="date" id="filter-end-date" class="date-input">
        </div>
        <div class="filter-group">
          <span class="filter-label">🔄 구분</span>
          <select id="filter-tp" class="filter-select">
            <option value="ALL">전체</option>
            <option value="1">반품</option>
            <option value="2">교환</option>
          </select>
        </div>
        <div class="filter-group">
          <span class="filter-label">🔢 검색 조건</span>
          <select id="filter-search-type" class="filter-select">
            <option value="RET_NUM">접수 번호</option>
            <option value="ORDER_NUM">주문 번호</option>
            <option value="PROD_NAME">상품명</option>
          </select>
          <input type="text" id="filter-search-keyword" placeholder="검색어 입력..." class="filter-input">
        </div>
        <div style="display: flex; gap: 6px; margin-left: auto;">
          <button type="button" class="btn btn-gray btn-sm" onclick="resetFilters()">🔄 초기화</button>
          <button type="submit" class="btn btn-blue btn-sm">🔍 필터 적용</button>
        </div>
      </form>
    </div>

    <div class="tbl-card">
      <div class="tbl-top">
        <div class="tbl-top-info">검색 결과 대기 목록 (총 <strong id="filteredWaitCnt">0</strong>건)</div>
      </div>
      <div class="tbl-wrap">
        <table>
          <thead>
            <tr>
              <th>접수번호</th>
              <th>주문번호</th>
              <th>구분</th>
              <th>상품명</th>
              <th>신청 사유</th>
              <th>상태</th>
              <th>처리하기</th>
            </tr>
          </thead>
          <tbody id="claimWaitTbody">
          </tbody>
        </table>
      </div>
      <div class="pagination-wrap">
        <div class="page-info" id="claimPageInfo">1 / 1 페이지</div>
        <div class="page-btns" id="claimPageBtns"></div>
      </div>
    </div>
  </div>

  <div id="sec-hist" style="display:none">
    <div class="filter-container">
      <form id="histFilterForm" onsubmit="applyHistFilters(event)" class="filter-form">
        <div class="filter-group">
          <span class="filter-label">📅 완료 기간</span>
          <input type="date" id="hist-start-date" class="date-input">
          <span style="color: var(--gray3);">~</span>
          <input type="date" id="hist-end-date" class="date-input">
        </div>
        <div class="filter-group">
          <span class="filter-label">🔄 구분</span>
          <select id="hist-tp" class="filter-select">
            <option value="ALL">전체</option>
            <option value="1">반품</option>
            <option value="2">교환</option>
          </select>
        </div>
        <div class="filter-group">
          <span class="filter-label">🚦 처리 상태</span>
          <select id="hist-status" class="filter-select">
            <option value="ALL">전체 상태</option>
            <option value="4">✨ 양품 복구 완료</option>
            <option value="5">🗑️ 불량 폐기 완료</option>
          </select>
        </div>
        <div class="filter-group">
          <span class="filter-label">🔢 검색 조건</span>
          <select id="hist-search-type" class="filter-select">
            <option value="RET_NUM">접수 번호</option>
            <option value="ORDER_NUM">주문 번호</option>
            <option value="PROD_NAME">상품명</option>
          </select>
          <input type="text" id="hist-search-keyword" placeholder="이력 검색어 입력..." class="filter-input" style="width: 170px;">
        </div>
        <div style="display: flex; gap: 6px; margin-left: auto;">
          <button type="button" class="btn btn-gray btn-sm" onclick="resetHistFilters()">🔄 초기화</button>
          <button type="submit" class="btn btn-blue btn-sm">🔍 이력 검색</button>
        </div>
      </form>
    </div>

    <div class="tbl-card">
      <div class="tbl-top">
        <div class="tbl-top-info">최종 완결 이력 목록 (총 <strong id="filteredHistCnt">0</strong>건)</div>
      </div>
      <div class="tbl-wrap">
        <table>
          <thead>
            <tr>
              <th>접수번호</th>
              <th>주문번호</th>
              <th>구분</th>
              <th>상품명</th>
              <th>처리방식</th>
              <th>교환 운송장</th>
              <th>관리자 메모</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody id="histTbody">
          </tbody>
        </table>
      </div>
      <div class="pagination-wrap">
        <div class="page-info" id="histPageInfo">1 / 1 페이지</div>
        <div class="page-btns" id="histPageBtns"></div>
      </div>
    </div>
  </div>
</div>
</main>

<form id="claimProcessForm" method="post" action="${pageContext.request.contextPath}/logistics/claim/process.do" style="display:none;">
  <input type="hidden" name="retNum" id="f-retNum">
  <input type="hidden" name="orderNum" id="f-orderNum">
  <input type="hidden" name="tp" id="f-tp">
  <input type="hidden" name="processType" id="f-processType"> 
  <input type="hidden" name="courier" id="f-courier">
  <input type="hidden" name="invoiceNo" id="f-invoiceNo">
  <input type="hidden" name="adminMemo" id="f-adminMemo">
  <input type="hidden" name="exColor" id="f-exColor"> <input type="hidden" name="exSize" id="f-exSize">   </form>

<div class="modal-bg" id="claimModal">
  <div class="modal" style="width:520px;">
    <div class="modal-hdr">
      <div class="modal-title" id="m-title">📦 반품/교환 상세 검수</div>
      <button class="modal-x" onclick="closeModal()">✕</button>
    </div>
    <div class="modal-body" style="max-height: 60vh; overflow-y: auto; padding-right: 10px;">
      <div class="sec-title">👤 수령자(주문자) 배송 정보</div>
      <div class="dr"><div class="dk">수령인</div><div class="dv" id="m-recvName"></div></div>
      <div class="dr"><div class="dk">연락처</div><div class="dv" id="m-recvPhone"></div></div>
      <div class="dr"><div class="dk">반송 주소</div><div class="dv" id="m-recvAddr"></div></div>
      <hr style="border:0; border-top:1px solid var(--gray6); margin:15px 0;">
      <div class="sec-title">👟 검수 대상 상품 및 클레임 정보</div>
      <div class="dr"><div class="dk">접수/주문번호</div><div class="dv" id="m-nums"></div></div>
      <div class="dr"><div class="dk">상품명</div><div class="dv" id="m-prodName" style="font-weight:700;"></div></div>
      <div class="dr"><div class="dk">색상 / 사이즈</div><div class="dv" id="m-option"></div></div>
      <hr style="border:0; border-top:1px dashed var(--gray6); margin:10px 0;">
      <div class="dr"><div class="dk">고객 신청사유</div><div class="dv" id="m-reason" style="color:var(--red); font-weight:600;"></div></div>
      <div class="dr"><div class="dk">쇼핑몰 판정</div><div class="dv" id="m-isGood" style="color:var(--blue); font-weight:600;"></div></div>
      <div class="dr" style="align-items:flex-start;">
        <div class="dk" style="margin-top:4px;">특이사항</div>
        <div class="dv" id="m-retNote" style="background:#f4f6fa; padding:10px; border-radius:6px; font-size:12.5px; line-height:1.4; white-space:pre-wrap; width:100%;"></div>
      </div>
      
      <div id="exchange-delivery-area" style="display:none; background: #f8faff; padding: 15px; border-radius: 8px; border: 1px solid #e1e8f5; margin-top: 10px;">
        
        <div class="sec-title" style="color:var(--blue); font-size: 13px; margin-bottom: 10px;">🔄 교환 출고 상품 옵션 변경 (동일 브랜드 한정)</div>
        
        <div class="dr" style="margin-bottom: 8px;">
          <div class="dk" style="font-size: 12px; width: 80px; color:#1e3a8a;">변경 컬러</div>
          <div class="dv">
            <select id="m-excolor-sel" class="modal-input" style="width: 100%; padding: 6px; cursor:pointer; font-weight: 600; border: 1px solid var(--blue);">
              </select>
          </div>
        </div>

        <div class="dr" style="margin-bottom: 15px;">
          <div class="dk" style="font-size: 12px; width: 80px; color:#1e3a8a;">변경 사이즈</div>
          <div class="dv">
            <select id="m-exsize-sel" class="modal-input" style="width: 100%; padding: 6px; cursor:pointer; font-weight: 600; border: 1px solid var(--blue);">
              </select>
          </div>
        </div>

        <div class="sec-title" style="color:var(--blue); font-size: 13px; margin-bottom: 10px; border-top:1px dashed #ced4da; padding-top:10px;">🚚 교환 상품 재출고 정보 (필수)</div>
        <div class="dr" style="margin-bottom: 8px;">
          <div class="dk" style="font-size: 12px; width: 80px;">택배사</div>
          <div class="dv">
            <select id="m-courier-sel" class="modal-input" style="width: 100%; padding: 6px; cursor:pointer;">
              <option value="">택배사 선택</option>
              <option value="CJ대한통운">CJ대한통운</option>
              <option value="롯데택배">롯데택배</option>
              <option value="한진택배">한진택배</option>
              <option value="우체국택배">우체국택배</option>
            </select>
          </div>
        </div>
        <div class="dr">
          <div class="dk" style="font-size: 12px; width: 80px;">송장번호</div>
          <div class="dv" style="display:flex; gap:6px;">
            <input type="text" id="m-invoice-input" class="modal-input" placeholder="우측 버튼 클릭" readonly style="flex:1; background:#fff; border:1px solid var(--gray5); padding:6px;">
            <button type="button" class="btn btn-outline btn-xs" onclick="generateExchangeInvoice()" style="white-space:nowrap;">번호 생성</button>
          </div>
        </div>
      </div>
      
      <hr style="border:0; border-top:1px solid var(--gray6); margin:15px 0;">
      <div class="sec-title">📝 물류 담당자 특이사항 기록 (특수문자 허용)</div>
      <div style="margin-top:6px;">
        <textarea id="m-memo" style="width:100%; height:80px; padding:10px; border:1px solid var(--gray5); border-radius:6px; resize:none; font-size:13px;" placeholder="물류창고 상품 입고 상태 및 폐기 사유 기입..."></textarea>
      </div>
    </div>
    <div class="modal-foot" style="display:flex; gap:10px; justify-content:flex-end;">
      <button class="btn btn-outline" onclick="closeModal()">닫기</button>
      <button class="btn btn-red" onclick="submitProcess('DISPOSAL')">🗑️ 불량 폐기 처리</button>
      <button class="btn btn-green" onclick="submitProcess('RECOVERY')">✨ 양품 복구 입고</button>
    </div>
  </div>
</div>

<div class="modal-bg" id="historyModal">
  <div class="modal" style="width:460px;">
    <div class="modal-hdr" style="background:var(--gray1);">
      <div class="modal-title">⚙️ 완결 이력 수정 / 취소 처리</div>
      <button class="modal-x" onclick="closeHistoryModal()">✕</button>
    </div>
    <div class="modal-body">
      <div class="sec-title">📄 선택된 이력 정보</div>
      <div class="dr"><div class="dk">접수 / 주문</div><div class="dv" id="h-m-nums"></div></div>
      <div class="dr"><div class="dk">품목명</div><div class="dv" id="h-m-prodName" style="font-weight:700;"></div></div>
      <div class="dr"><div class="dk">기존 처리</div><div class="dv" id="h-m-procType"></div></div>
      <hr style="border:0; border-top:1px solid var(--gray6); margin:15px 0;">
      <div class="sec-title">📝 물류 담당자 특이사항 메모 수정</div>
      <div style="margin-top:6px;">
        <textarea id="h-m-memo" style="width:100%; height:75px; padding:10px; border:1px solid var(--gray5); border-radius:6px; resize:none; font-size:13px;"></textarea>
      </div>
      <div style="background:#fff5f5; border:1px solid #feb2b2; padding:12px; border-radius:6px; margin-top:15px;">
        <span style="font-size:12px; font-weight:700; color:#c53030;">⚠️ 처리 취소(삭제) 경고</span>
        <p style="font-size:11.5px; color:#742a2a; margin-top:4px; line-height:1.4;">이력 취소 시 해당 품목은 다시 <b>'접수된 클레임 처리(대기)'</b> 목록으로 돌아가며, 변동되었던 창고 재고 및 교환 운송장 정보가 자동으로 완벽하게 역산 원상복구 됩니다.</p>
      </div>
    </div>
    <div class="modal-foot" style="background:var(--gray7); display:flex; gap:8px;">
      <button class="btn btn-red btn-sm" onclick="submitHistoryModify('CANCEL')" style="margin-right:auto;">🗑️ 이력 취소(삭제)</button>
      <button class="btn btn-outline btn-sm" onclick="closeHistoryModal()">닫기</button>
      <button class="btn btn-blue btn-sm" onclick="submitHistoryModify('UPDATE')">💾 메모 저장</button>
    </div>
  </div>
</div>

<form id="historyModifyForm" method="post" action="${pageContext.request.contextPath}/logistics/claim/historyModify.do" style="display:none;">
  <input type="hidden" name="mode" id="h-f-mode">
  <input type="hidden" name="retNum" id="h-f-retNum">
  <input type="hidden" name="orderNum" id="h-f-orderNum">
  <input type="hidden" name="tp" id="h-f-tp">
  <input type="hidden" name="currentStatus" id="h-f-status">
  <input type="hidden" name="adminMemo" id="h-f-memo">
</form>

<div class="toast" id="toast"></div>

<script>
//── 시계 ────────────────────────────────────────────
function updateClock() {
    var now = new Date();
    var s = now.getFullYear() + "-"
          + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + " "
          + String(now.getHours()).padStart(2,'0') + ":"
          + String(now.getMinutes()).padStart(2,'0');
    document.getElementById("realTimeClock").innerText = s;
}
updateClock(); setInterval(updateClock, 60000);

function updateSyncTime() {
    var now = new Date();
    var s = now.getFullYear() + "-"
          + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + " "
          + String(now.getHours()).padStart(2,'0') + ":"
          + String(now.getMinutes()).padStart(2,'0') + ":"
          + String(now.getSeconds()).padStart(2,'0');
    document.getElementById("syncTime").innerText = "최종 동기화: " + s;
    showToast('✅ 재고 동기화 완료');
}

// 📦 [1] 대기 데이터 파싱
const rawClaimList = [
      <c:forEach var="c" items="${claimList}">
      {
        ret_num: "${c.ret_num}",
        order_num: "${c.order_num}",
        prod_num: "${c.prod_num}",
        tp: "${c.tp}",
        prod_name: `<c:out value="${c.prod_name}" escapeXml="true"/>`,
        color: `<c:out value="${c.color}" escapeXml="true"/>`,
        size_val: "${c.size_val}",
        recv_name: `<c:out value="${c.recv_name}" escapeXml="true"/>`,
        recv_phone: "${c.recv_phone}",
        recv_addr: `<c:out value="${c.recv_addr}" escapeXml="true"/>`,
        reason: `<c:out value="${c.reason}" escapeXml="true"/>`,
        ret_note: `<c:out value="${c.ret_note}" escapeXml="true"/>`,
        is_good_str: "${c.is_good_str}",
        created_at: "2026-05-21" 
      },
      </c:forEach>
    ];

// 📋 [2] 이력 데이터 파싱
const historyData = [
  <c:forEach var="h" items="${historyList}">
  {
    ret_num: "${h.ret_num}",
    order_num: "${h.order_num}",
    tp: "${h.tp == 1 ? '1' : '2'}", 
    tp_text: "${h.tp == 1 ? '반품' : '교환'}",
    proc_type: "${h.reason}", 
    prod_name: `<c:out value="${h.prod_name}" escapeXml="true"/>`,
    invoice: "${empty h.invoice_no ? '-' : h.invoice_no}",
    memo: `<c:out value="${h.ret_note}" escapeXml="true"/>`,
    ret_status: "${h.ret_status}", 
    created_at: "2026-05-21"
  },
  </c:forEach>
];

let filteredClaimList = [...rawClaimList]; 
let filteredHistList = [...historyData]; 

let currentClaimPage = 1;
let currentHistPage = 1;
const itemsPerPage = 10;

function getDateFormat(date) {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `\${y}-\${m}-\${d}`;
}

window.addEventListener('DOMContentLoaded', () => {
    const today = new Date();
    const lastMonth = new Date();
    lastMonth.setMonth(today.getMonth() - 1); 
    
    const formattedToday = getDateFormat(today);
    const formattedLastMonth = getDateFormat(lastMonth);
    
    document.getElementById('filter-start-date').value = formattedLastMonth;
    document.getElementById('filter-end-date').value = formattedToday;
    
    document.getElementById('hist-start-date').value = formattedLastMonth;
    document.getElementById('hist-end-date').value = formattedToday;
    
    applyFilters(null);
    applyHistFilters(null); 
});

function resetFilters() {
    document.getElementById('filter-tp').value = "ALL";
    document.getElementById('filter-search-type').value = "RET_NUM";
    document.getElementById('filter-search-keyword').value = "";
    
    const today = new Date();
    const lastMonth = new Date();
    lastMonth.setMonth(today.getMonth() - 1);
    
    document.getElementById('filter-start-date').value = getDateFormat(lastMonth);
    document.getElementById('filter-end-date').value = getDateFormat(today);
    
    applyFilters(null);
}

function resetHistFilters() {
    document.getElementById('hist-tp').value = "ALL";
    document.getElementById('hist-status').value = "ALL";
    document.getElementById('hist-search-type').value = "RET_NUM";
    document.getElementById('hist-search-keyword').value = "";
    
    const today = new Date();
    const lastMonth = new Date();
    lastMonth.setMonth(today.getMonth() - 1);
    
    document.getElementById('hist-start-date').value = getDateFormat(lastMonth);
    document.getElementById('hist-end-date').value = getDateFormat(today);
    
    applyHistFilters(null);
}

function applyFilters(e) {
    if(e) e.preventDefault();
    
    const startDt = document.getElementById('filter-start-date').value;
    const endDt = document.getElementById('filter-end-date').value;
    const tp = document.getElementById('filter-tp').value;
    const searchType = document.getElementById('filter-search-type').value;
    const keyword = document.getElementById('filter-search-keyword').value.trim().toLowerCase();
    
    filteredClaimList = rawClaimList.filter(item => {
        if(startDt && item.created_at < startDt) return false;
        if(endDt && item.created_at > endDt) return false;
        if(tp !== "ALL" && item.tp !== tp) return false;
        
        if(keyword !== "") {
            if(searchType === "RET_NUM" && !item.ret_num.toLowerCase().includes(keyword)) return false;
            if(searchType === "ORDER_NUM" && !item.order_num.toLowerCase().includes(keyword)) return false;
            if(searchType === "PROD_NAME" && !item.prod_name.toLowerCase().includes(keyword)) return false;
        }
        return true;
    });
    
    currentClaimPage = 1; 
    renderClaimTable();
}

function applyHistFilters(e) {
    if(e) e.preventDefault();
    
    const startDt = document.getElementById('hist-start-date').value;
    const endDt = document.getElementById('hist-end-date').value;
    const tp = document.getElementById('hist-tp').value;
    const status = document.getElementById('hist-status').value;
    const searchType = document.getElementById('hist-search-type').value;
    const keyword = document.getElementById('hist-search-keyword').value.trim().toLowerCase();
    
    filteredHistList = historyData.filter(item => {
        if(startDt && item.created_at < startDt) return false;
        if(endDt && item.created_at > endDt) return false;
        if(tp !== "ALL" && item.tp !== tp) return false;
        if(status !== "ALL" && item.ret_status !== status) return false;
        if(keyword !== "") {
            if(searchType === "RET_NUM" && !item.ret_num.toLowerCase().includes(keyword)) return false;
            if(searchType === "ORDER_NUM" && !item.order_num.toLowerCase().includes(keyword)) return false;
            if(searchType === "PROD_NAME" && !item.prod_name.toLowerCase().includes(keyword)) return false;
        }
        return true;
    });
    
    currentHistPage = 1;
    renderHistTable();
}

function renderClaimTable() {
    const tbody = document.getElementById('claimWaitTbody');
    if(!tbody) return;
    
    document.getElementById('filteredWaitCnt').innerText = filteredClaimList.length;
    
    const start = (currentClaimPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageData = filteredClaimList.slice(start, end);
    
    if(pageData.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:50px; color:var(--gray4);">📥 조회 조건에 부합하는 클레임이 없습니다.</td></tr>';
        document.getElementById('claimPageInfo').textContent = "0 / 0 페이지";
        document.getElementById('claimPageBtns').innerHTML = "";
        return;
    }
    
    let html = '';
    pageData.forEach(c => {
        const tpBdg = (c.tp === '1') ? 'bdg-red' : 'bdg-blue';
        const tpText = (c.tp === '1') ? '반품' : '교환';
        
        html += `<tr>
            <td>\${c.ret_num}</td>
            <td>#\${c.order_num}</td>
            <td><span class="bdg \${tpBdg}">\${tpText}</span></td>
            <td style="text-align:left; font-weight:600;">\${c.prod_name}</td>
            <td style="color:var(--gray3);">\${c.reason}</td>
            <td><span class="bdg bdg-amber">쇼핑몰완료</span></td>
            <td>
              <button type="button" class="btn btn-blue btn-xs" 
                      data-retnum="\${c.ret_num}" data-ordernum="\${c.order_num}" data-tp="\${c.tp}"
                      data-prodnum="\${c.prod_num}" <%-- 🎯 [핵심 수술 부위] 자바스크립트가 오라클 실재고를 긁어갈 수 있도록 상품 일련번호 전격 주입! --%>
                      data-prodname="\${c.prod_name}" data-color="\${c.color}" data-sizeval="\${c.size_val}"
                      data-recvname="\${c.recv_name}" data-recvphone="\${c.recv_phone}" data-recvaddr="\${c.recv_addr}"
                      data-reason="\${c.reason}" data-retnote="\${c.ret_note}" data-isgood="\${c.is_good_str}"
                      onclick="openClaimModal(this)">
                검수 및 처리
              </button>
            </td>
        </tr>`;
    });
    
    tbody.innerHTML = html;
    renderClaimPagination();
}

function renderClaimPagination() {
    const totalPages = Math.ceil(filteredClaimList.length / itemsPerPage) || 1;
    document.getElementById('claimPageInfo').textContent = `\${currentClaimPage} / \${totalPages} 페이지`;
    
    let btnHtml = '';
    for(let i = 1; i <= totalPages; i++) {
        const isCurrent = (i === currentClaimPage);
        btnHtml += `<div class="pg-btn \${isCurrent ? 'on' : ''}" onclick="changeClaimPage(\${i})" 
                         style="cursor:pointer; padding:5px 11px; border:1px solid var(--gray5); border-radius:4px; font-size:12px; font-weight:600; 
                                background:\${isCurrent ? 'var(--blue)' : '#fff'}; color:\${isCurrent ? '#fff' : 'var(--gray2)'};">\${i}</div>`;
    }
    document.getElementById('claimPageBtns').innerHTML = btnHtml;
}

function changeClaimPage(page) {
    currentClaimPage = page;
    renderClaimTable();
}

function switchTab(tabId, btn) {
    const secClaim = document.getElementById('sec-claim');
    const secHist = document.getElementById('sec-hist');
    if(secClaim) secClaim.style.display = 'none';
    if(secHist) secHist.style.display = 'none';
    
    const targetSec = document.getElementById(tabId);
    if(targetSec) targetSec.style.display = 'block';
    
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(t => t.classList.remove('on'));
    if(btn) btn.classList.add('on');
}

// 🔄 상세 검수 모달 데이터 로드 및 토글
function openClaimModal(btn) {
    const retnum = btn.dataset.retnum;
    const ordernum = btn.dataset.ordernum;
    const tp = btn.dataset.tp;
    const prodname = btn.dataset.prodname;
    const color = btn.dataset.color;
    const sizeval = btn.dataset.sizeval;
    const recvname = btn.dataset.recvname;
    const recvphone = btn.dataset.recvphone;
    const recvaddr = btn.dataset.recvaddr;
    const reason = btn.dataset.reason;
    const retnote = btn.dataset.retnote; 
    const isgood = btn.dataset.isgood;

    if(document.getElementById('f-retNum')) document.getElementById('f-retNum').value = retnum;
    if(document.getElementById('f-orderNum')) document.getElementById('f-orderNum').value = ordernum;
    if(document.getElementById('f-tp')) document.getElementById('f-tp').value = tp;
    
    if(document.getElementById('m-title')) {
        document.getElementById('m-title').innerText = (tp == 1) ? "🔄 [반품] 상세 검수 및 재고 처리" : "🔄 [교환] 상세 검수 및 교환 출고";
    }
    if(document.getElementById('m-recvName')) document.getElementById('m-recvName').innerText = recvname;
    if(document.getElementById('m-recvPhone')) document.getElementById('m-recvPhone').innerText = recvphone;
    if(document.getElementById('m-recvAddr')) document.getElementById('m-recvAddr').innerText = recvaddr;
    if(document.getElementById('m-nums')) {
        document.getElementById('m-nums').innerHTML = `접수번호: <b>\${retnum}</b> / 주문번호: <b>#\${ordernum}</b>`;
    }
    if(document.getElementById('m-prodName')) document.getElementById('m-prodName').innerText = prodname;
    if(document.getElementById('m-option')) document.getElementById('m-option').innerText = `\${color} / \${sizeval}mm`;
    if(document.getElementById('m-reason')) document.getElementById('m-reason').innerText = reason;
    if(document.getElementById('m-isGood')) document.getElementById('m-isGood').innerText = isgood;

    let mallMemo = "";
    let logiMemo = "";
    
    if (retnote && retnote.trim() !== "" && retnote !== 'null') {
        const markerIndex = retnote.indexOf('\n'); 
        if (markerIndex > -1) {
            mallMemo = retnote.substring(0, markerIndex).trim();
            logiMemo = retnote.substring(markerIndex + 1).trim(); 
        } else {
            mallMemo = retnote;
        }
    }

    if(document.getElementById('m-retNote')) {
        document.getElementById('m-retNote').innerText = (mallMemo !== "") ? mallMemo : "등록된 특이사항 정보가 없습니다.";
    }
    if(document.getElementById('m-memo')) {
        document.getElementById('m-memo').value = logiMemo; 
    }

    const dlvArea = document.getElementById('exchange-delivery-area');
    if(dlvArea) {
        if(tp == 2) {
            dlvArea.style.setProperty("display", "block", "important");
            
            // 📌 [수정 완결] 기존 하드코딩 호출을 폐기하고, btn 데이터셋에 바인딩된 실제 prod_num까지 3개 인자로 전달!
            // (※ 만약 버튼 데이터셋에 prodnum이 없다면 c.prod_num을 루프 돌 때 버튼 태그에 data-prodnum="${c.prod_num}"으로 얹어주시면 됩니다!)
            const prodnum = btn.dataset.prodnum ? btn.dataset.prodnum : btn.dataset.retnum; // 예방 방어 코드
            setupExchangeOptions(prodnum, color, sizeval);
            
        } else {
            dlvArea.style.setProperty("display", "none", "important");
        }
    }
    
    document.getElementById('claimModal').classList.add('open');
}

let liveAvailableOptions = [];

// 🎯 [신규] 교환 가능한 옵션 세트를 셀렉트 박스에 동적으로 빌드하는 함수
function setupExchangeOptions(prodNum, currentColor, currentSize) {
    const colorSel = document.getElementById('m-excolor-sel');
    const sizeSel = document.getElementById('m-exsize-sel');
    if(!colorSel || !sizeSel) return;

    // 1. 매장 실재고를 긁어오기 전, 로딩 상태로 사용자 인터페이스 보호
    colorSel.innerHTML = '<option value="">가용 컬러 로딩중...</option>';
    sizeSel.innerHTML = '<option value="">가용 사이즈 로딩중...</option>';

    // 🎯 [핵심 수술 부위] 백틱(``)과 불완전한 템플릿 리터럴을 제거하고 
    // JSP 컨텍스트 패스 문자열과 순수 JS 변수 연산을 완벽하게 분리했습니다.
    var contextPath = "${pageContext.request.contextPath}";
    var ajaxUrl = contextPath + "/logistics/claim/getAvailableOptions.do?prodNum=" + prodNum;

    // 2. 아까 백엔드 매핑 프로퍼티에 등록한 주소로 AJAX(Fetch) 초고속 타격!
    fetch(ajaxUrl)
        .then(function(response) {
            // 🚨 404 Not Found 또는 500 Internal Error 방어막 설치
            if (!response.ok) {
                throw new Error("HTTP 에러 상태코드: " + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            // 자바 백엔드가 뱉어준 실시간 재고 옵션 풀(Array) 저장
            liveAvailableOptions = data; 

            if(liveAvailableOptions.length === 0) {
                colorSel.innerHTML = '<option value="">⚠️ 창고 품절 (교환 불가)</option>';
                sizeSel.innerHTML = '<option value="">⚠️ 창고 품절 (교환 불가)</option>';
                return;
            }

            // 3. 중복 제거된 순수 가용 컬러 리스트만 추출 (Set 객체 활용)
            var uniqueColors = [];
            for (var i = 0; i < liveAvailableOptions.length; i++) {
                var cUpper = liveAvailableOptions[i].color.toUpperCase();
                if (uniqueColors.indexOf(cUpper) === -1) {
                    uniqueColors.push(cUpper);
                }
            }

            // 4. 컬러 셀렉트 박스 빌드
            let colorHtml = '';
            uniqueColors.forEach(function(c) {
                // 기존 고객 주문 컬러와 일치하면 기본 selected 처리
                var selected = (c === currentColor.toUpperCase()) ? "selected" : "";
                colorHtml += '<option value="' + c + '" ' + selected + '>' + c + '</option>';
            });
            colorSel.innerHTML = colorHtml;

            // 5. [핵심 2단 체인] 현재 선택된 컬러에 종속된 진짜 남은 사이즈 목록 매핑 함수 호출
            updateSizeOptionsByColor(colorSel.value, currentSize);

            // 6. 이벤트 리스너 장착: 물류 담당자가 컬러를 변경할 때마다 사이즈 박스도 실시간 재필터링!
            colorSel.onchange = function() {
                updateSizeOptionsByColor(this.value, "");
            };
        })
        .catch(err => {
            colorSel.innerHTML = '<option value="">데이터 통신 실패</option>';
            sizeSel.innerHTML = '<option value="">데이터 통신 실패</option>';
        });
}

//🎯 [신규] 선택된 컬러에 맞는 실제 잔여 재고 사이즈만 발라내서 2단 박스를 그리는 함수
function updateSizeOptionsByColor(selectedColor, defaultSize) {
    const sizeSel = document.getElementById('m-exsize-sel');
    if(!sizeSel) return;

    // 현재 선택된 컬러와 일치하는 재고 로우만 스크리닝
    const matchedSizes = liveAvailableOptions.filter(opt => opt.color.toUpperCase() === selectedColor.toUpperCase());

    let sizeHtml = '';
    matchedSizes.forEach(opt => {
        // 기존 고객 주문 사이즈와 일치하면 기본 selected 처리
        var selected = (opt.size_val === defaultSize) ? "selected" : "";
        sizeHtml += '<option value="' + opt.size_val + '" ' + selected + '>' + opt.size_val + ' mm</option>';
    });
    
    sizeSel.innerHTML = sizeHtml;
}

function closeModal() {
    document.getElementById('claimModal').classList.remove('open');
}

function generateExchangeInvoice() {
    const courier = document.getElementById('m-courier-sel').value;
    if(!courier) {
        alert('택배사를 먼저 선택해야 송장 번호를 딸 수 있습니다!');
        document.getElementById('m-courier-sel').focus();
        return;
    }

    const now = new Date();
    const dateStr = now.getFullYear() + 
                    String(now.getMonth() + 1).padStart(2, '0') + 
                    String(now.getDate()).padStart(2, '0');

    let prefix = "CJ";
    if(courier === '롯데택배') prefix = "LOTTE";
    else if(courier === '한진택배') prefix = "HJ";
    else if(courier === '우체국택배') prefix = "POST";

    const randNum = String(Math.floor(Math.random() * 9000) + 1000);
    const finalInvoice = prefix + "-" + dateStr + "-EX-" + randNum;

    document.getElementById('m-invoice-input').value = finalInvoice;
}

// 최종 검수 승인 폼 전송
function submitProcess(type) {
    const tp = document.getElementById('f-tp').value;
    document.getElementById('f-processType').value = type;
    document.getElementById('f-adminMemo').value = document.getElementById('m-memo').value;
    
    if(tp === '2') {
        const courier = document.getElementById('m-courier-sel').value;
        const invoice = document.getElementById('m-invoice-input').value;
        if(!courier || !invoice) {
            alert('교환 상품 배송 보낼 택배사와 운송장 번호를 완성해 주셔야 합니다!');
            return;
        }
        document.getElementById('f-courier').value = courier;
        document.getElementById('f-invoiceNo').value = invoice;
        
        // 🎯 [옵션 레일 락인] 담당자가 최종 선택한 변경 색상/사이즈를 히든 태그에 바인딩하여 폼 전송!
        document.getElementById('f-exColor').value = document.getElementById('m-excolor-sel').value;
        document.getElementById('f-exSize').value = document.getElementById('m-exsize-sel').value;
    }
    
    if(!confirm(`해당 건을 정말로 \${type === 'DISPOSAL' ? '불량 폐기' : '양품 복구입고'} 처리 완료하시겠습니까?`)) return;
    
    document.getElementById('claimProcessForm').submit();
}

function renderHistTable() {
    const tbody = document.getElementById('histTbody');
    if(!tbody) return;
    
    document.getElementById('filteredHistCnt').innerText = filteredHistList.length;
    
    const start = (currentHistPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageData = filteredHistList.slice(start, end); 
    
    if(!pageData.length) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:50px; color:var(--gray4);">📭 조건에 부합하는 완료된 클레임 이력이 없습니다.</td></tr>';
        document.getElementById('histPageInfo').textContent = "0 / 0 페이지";
        document.getElementById('histPageBtns').innerHTML = "";
        return;
    }
    
    let html = '';
    pageData.forEach(h => {
        const procBdg = (h.proc_type === '양품복구') ? 'bdg-green' : 'bdg-red';
        const tpBdg = (h.tp_text === '반품') ? 'bdg-red' : 'bdg-blue';
        
        html += `<tr>
            <td>\${h.ret_num}</td>
            <td>#\${h.order_num}</td>
            <td><span class="bdg \${tpBdg}">\${h.tp_text}</span></td>
            <td style="text-align:left; font-weight:600;">\${h.prod_name}</td>
            <td><span class="bdg \${procBdg}">\${h.proc_type}</span></td>
            <td style="font-family:'DM Mono',monospace;">\${h.invoice}</td>
            <td style="text-align:left; color:var(--gray2);">\${h.memo}</td>
            <td>
                <button type="button" class="btn btn-outline btn-xs" 
                        data-retnum="\${h.ret_num}" data-ordernum="\${h.order_num}" data-tp="\${h.tp}" 
                        data-prodname="\${h.prod_name}" data-proctype="\${h.proc_type}" data-memo="\${h.memo}" data-status="\${h.ret_status}"
                        onclick="openHistoryModal(this)">⚙️ 관리</button>
            </td>
        </tr>`;
    });
    tbody.innerHTML = html;
    renderHistPagination(); 
}

function renderHistPagination() {
    const totalPages = Math.ceil(filteredHistList.length / itemsPerPage) || 1; 
    const pageBtns = document.getElementById('histPageBtns');
    if(!pageBtns) return;
    
    document.getElementById('histPageInfo').textContent = `\${currentHistPage} / \${totalPages} 페이지`;
    
    let btnHtml = '';
    for(let i=1; i<=totalPages; i++) {
        const isCurrent = (i === currentHistPage);
        btnHtml += `<div class="pg-btn \${isCurrent ? 'on' : ''}" onclick="changeHistPage(\${i})"
                         style="cursor:pointer; padding:5px 11px; border:1px solid var(--gray5); border-radius:4px; font-size:12px; font-weight:600; 
                                background:\${isCurrent ? 'var(--blue)' : '#fff'}; color:\${isCurrent ? '#fff' : 'var(--gray2)'};">\${i}</div>`;
    }
    pageBtns.innerHTML = btnHtml;
}

function changeHistPage(p) { 
    currentHistPage = p; 
    renderHistTable(); 
}

function openHistoryModal(btn) {
    const retnum = btn.dataset.retnum;
    const ordernum = btn.dataset.ordernum;
    const tp = btn.dataset.tp;
    const prodname = btn.dataset.prodname;
    const proctype = btn.dataset.proctype;
    const memo = btn.dataset.memo;
    const status = btn.dataset.status;

    document.getElementById('h-f-retNum').value = retnum;
    document.getElementById('h-f-orderNum').value = ordernum;
    document.getElementById('h-f-tp').value = tp;
    document.getElementById('h-f-status').value = status;

    document.getElementById('h-m-nums').innerHTML = `접수: <b>\${retnum}</b> / 주문: <b>#\${ordernum}</b> (\${tp == 1 ? '반품' : '교환'})`;
    document.getElementById('h-m-prodName').innerText = prodname;
    document.getElementById('h-m-procType').innerHTML = `<span class="bdg \${proctype === '양품복구' ? 'bdg-green' : 'bdg-red'}">\${proctype}완료</span>`;
    
    let logiMemo = "";
    if (memo && memo !== 'null') {
        const markerIndex = memo.indexOf('\n'); 
        logiMemo = (markerIndex > -1) ? memo.substring(markerIndex + 1).trim() : "";
    }
    document.getElementById('h-m-memo').value = logiMemo;

    document.getElementById('historyModal').classList.add('open');
}

function closeHistoryModal() {
    document.getElementById('historyModal').classList.remove('open');
}

function submitHistoryModify(mode) {
    document.getElementById('h-f-mode').value = mode;
    document.getElementById('h-f-memo').value = document.getElementById('h-m-memo').value;

    if (mode === 'CANCEL') {
        if (!confirm("🚨 이 결정을 취소하고 전산 및 실재고를 다시 대기 상태로 원상복구 하시겠습니까?\n(창고 실재고가 실시간으로 재계산됩니다.)")) return;
    } else {
        if (!confirm("물류 담당자 특이사항 메모를 수정하시겠습니까?")) return;
    }

    document.getElementById('historyModifyForm').submit();
}
</script>
</body>
</html>