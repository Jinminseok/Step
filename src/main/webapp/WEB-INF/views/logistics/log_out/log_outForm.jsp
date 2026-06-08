<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출고 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* ══ 기본 레이아웃 ══ */
.main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ══ 탭 바 ══ */
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab-btn{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{background:var(--amber);color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}
.tab-cnt-gray{background:var(--gray4)}

/* ══ 알럿 ══ */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-green{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.alert-blue{background:var(--blue-lt);border-color:#93C5FD;color:#1E3A8A}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}

/* ══ KPI 요약 카드 ══ */
.kpi-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px}
.kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:18px 20px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden}
.kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.kpi.amber::before{background:var(--amber)}
.kpi.green::before{background:var(--green)}
.kpi.blue::before{background:var(--blue)}
.kpi.gray::before{background:var(--gray4)}
.kpi-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.kpi-val{font-family:'DM Mono',monospace;font-size:28px;font-weight:700;margin-bottom:4px;letter-spacing:-1px}
.kpi-val.c-amber{color:var(--amber)}
.kpi-val.c-green{color:var(--green)}
.kpi-val.c-blue{color:var(--blue)}
.kpi-val.c-gray{color:var(--gray3)}
.kpi-sub{font-size:11px;color:var(--gray4)}

/* ══ 툴바 & 검색 ══ */
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;min-width:200px;max-width:280px}
.search-wrap input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;}

/* ══ 버튼 ══ */
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}
.btn-blue:hover{background:var(--navy2)}
.btn-blue:disabled{background:var(--gray5);cursor:not-allowed}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}
.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-ghost{background:transparent;color:var(--gray3);border:1.5px solid var(--gray5)}
.btn-ghost:hover{color:var(--gray1);border-color:var(--gray3)}
.btn-danger{background:var(--red-lt);color:var(--red);border:1.5px solid #FECACA}
.btn-sm{padding:7px 13px;font-size:12px}
.btn-xs{padding:4px 10px;font-size:11px}
.btn-green{background:var(--green);color:#fff}
.btn-green:hover{background:#059669}

/* ══ 테이블 ══ */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:10px;flex-wrap:wrap}
.tbl-top-info{font-size:12px;color:var(--gray3)}
.tbl-top-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
thead{position:sticky;top:0;z-index:5}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
.tbl-row{transition:background .12s;cursor:pointer}
.tbl-row:hover td{background:#F5F8FF}
.tbl-row.checked td{background:#EFF6FF}
td:first-child{border-left:3px solid transparent;padding-left:11px}
.tbl-row.checked td:first-child{border-left:3px solid var(--blue)}
tr:last-child td{border-bottom:none}

/* 배지 */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}

/* 페이징 */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}
.pg-btn.disabled{opacity:.4;cursor:not-allowed}

/* ══ 모달 ══ */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:560px;max-height:88vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* 컨펌 모달 (일괄 처리) */
.confirm-modal{width:420px}
.confirm-icon{width:56px;height:56px;border-radius:50%;background:var(--amber-lt);border:2px solid var(--amber-lt);display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 16px}
.confirm-title{font-size:17px;font-weight:800;color:var(--gray1);text-align:center;margin-bottom:8px}
.confirm-desc{font-size:13px;color:var(--gray3);text-align:center;line-height:1.7;margin-bottom:20px}

/* 모달 내부 테이블 */
.dr{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7); align-items:center;}
.dr:last-child{border-bottom:none}
.dk{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:110px;flex-shrink:0;padding-top:1px}
.dv{font-size:13px;color:var(--gray1);flex:1}
.modal-input{width:100%; padding:8px 12px; border:1.5px solid var(--gray5); border-radius:6px; font-size:13px; outline:none; transition:border .15s;}
.modal-input:focus{border-color:var(--blue);}

/* 토스트 알림 */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* 섹션 타이틀 */
.sec-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;display:flex;align-items:center;gap:6px; margin-top:20px;}
.sec-title:first-child{margin-top:0;}
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
      <span class="breadcrumb-cur" id="pg-title">출고 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>      
    </div>
  </div>
  
  <div class="content">
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-out-btn" onclick="switchTab('out')">
        📤 출고 처리 <span class="tab-cnt" id="waitCnt">${pendingList.size()}</span>
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchTab('hist')">
        📋 출고 이력 조회 <span class="tab-cnt tab-cnt-gray">${historyList.size()}</span>
      </div>
    </div>

    <div id="sec-out">

      <div class="kpi-row">
        <div class="kpi amber">
          <div class="kpi-label">출고 대기</div>
          <div class="kpi-val c-amber" id="kpiWait">${pendingList.size()}</div>
          <div class="kpi-sub">즉시 처리 필요</div>
        </div>
        <div class="kpi green">
          <div class="kpi-label">전체 출고 완료</div>
          <div class="kpi-val c-green">${historyList.size()}</div>
          <div class="kpi-sub">완료된 주문 건수</div>
        </div>
        <div class="kpi blue">
          <div class="kpi-label">배송 중</div>
          <div class="kpi-val c-blue">${shippingCnt != null ? shippingCnt : 0}</div>
          <div class="kpi-sub">진행 중인 배송</div>
        </div>
        <div class="kpi gray">
          <div class="kpi-label">배송 완료</div>
          <div class="kpi-val c-gray">${deliveredCnt != null ? deliveredCnt : 0}</div>
          <div class="kpi-sub">도착 완료</div>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/logistics/log_out/log_outForm.do" method="get" class="toolbar">
        <div style="display:flex; align-items:center; gap:6px;">
          <input type="date" name="startDate" value="${startDate}" class="sel">
          <span style="color:var(--gray4); font-size:12px;">~</span>
          <input type="date" name="endDate" value="${endDate}" class="sel">
        </div>

        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" name="keyword" value="${keyword}" placeholder="주문번호·상품명 검색">
        </div>

        <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>

        <div style="margin-left:auto; display:flex; gap:8px">
          <button type="button" class="btn btn-blue" id="bulkBtn" onclick="openBulkConfirm()" disabled>
            선택 항목 일괄 출고 <span id="bulkCnt"></span>
          </button>
        </div>
      </form>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong id="totalCnt">${pendingList.size()}</strong>건 · 선택 <strong id="selCnt">0</strong>건</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:40px"><input type="checkbox" id="chkAll" onchange="toggleAll(this)"></th>
                <th>주문번호</th>
                <th>주문일시</th>
                <th>상품명</th>
                <th>사이즈 / 컬러</th>
                <th>수량</th>
                <th>배송지</th>
                <th>상태</th>
                <th>처리</th>
              </tr>
            </thead>
            <tbody id="orderTbody"></tbody>
          </table>
        </div>
        
        <div class="pagination-wrap">
          <div class="page-info" id="pageInfo">0건</div>
          <div class="page-btns" id="pageBtns"></div>
        </div>        
      </div>
    </div>
    
    <div id="sec-hist" style="display:none">
      <form action="${pageContext.request.contextPath}/logistics/log_out/log_outForm.do" method="get" class="toolbar" style="padding:14px 18px;background:var(--white);border:1px solid var(--gray6);border-radius:10px;box-shadow:0 1px 3px rgba(15,32,68,.05)">
        <input type="hidden" name="tab" value="hist">
        <span style="font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.05em">기간</span>
        <input type="date" name="histStartDate" value="${histStartDate}" class="sel">
        <span style="font-size:12px;color:var(--gray4)">~</span>
        <input type="date" name="histEndDate" value="${histEndDate}" class="sel">
        
        <div class="search-wrap" style="max-width:220px">
          <span class="search-ico">🔍</span>
          <input type="text" name="histKeyword" value="${histKeyword}" placeholder="주문번호·상품명 검색">
        </div>
        
        <button type="submit" class="btn btn-blue btn-sm">조회</button>
        <a href="${pageContext.request.contextPath}/logistics/log_out/log_outForm.do?tab=hist" class="btn btn-ghost btn-sm">초기화</a>
      </form>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong id="totalHistCnt">0</strong>건</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>출고 번호</th><th>주문번호</th><th>출고일시</th><th>상품명</th>
                <th>사이즈/컬러</th><th>수량</th><th>택배사</th><th>송장번호</th><th>상태</th><th>담당자</th>
              </tr>
            </thead>
            <tbody id="histTbody"></tbody>
          </table>
        </div>
        
        <div class="pagination-wrap">
          <div class="page-info" id="histPageInfo">0건</div>
          <div class="page-btns" id="histPageBtns"></div>
        </div>
      </div>
    </div> 
  </div>
</main>

<form id="outboundForm" method="post" action="${pageContext.request.contextPath}/logistics/log_out/log_outProcess.do" style="display:none;"></form>

<div class="modal-bg" id="singleModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">📦 출고 처리</div>
      <button class="modal-x" onclick="closeSingle()">✕</button>
    </div>
    <div class="modal-body" id="singleBody"></div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="closeSingle()">취소</button>
      <button class="btn btn-green" onclick="confirmSingle()">✅ 출고 확정</button>
    </div>
  </div>
</div>

<div class="modal-bg" id="bulkModal">
  <div class="modal confirm-modal" style="width:460px">
    <div class="modal-hdr">
      <div class="modal-title">📦 일괄 출고 처리</div>
      <button class="modal-x" onclick="closeBulk()">✕</button>
    </div>
    <div class="modal-body" style="text-align:center; padding:30px 22px;">
      <div class="confirm-icon" style="font-size:42px; margin-bottom:12px;">📦</div>
      <div class="confirm-title" style="font-size:18px; font-weight:700; margin-bottom:8px; color:var(--gray1);">선택 주문 일괄 출고</div>
      <div class="confirm-desc" id="bulkDesc" style="font-size:13px; color:var(--gray3); margin-bottom:24px;"></div>
      
      <div class="alert alert-amber" style="margin:0; text-align:left; display:flex; gap:8px; align-items:flex-start; line-height:1.5;">
        <span class="alert-ico" style="flex-shrink:0; margin-top:2px;">⚠</span>
        <div style="flex:1; font-size:12.5px;">
          출고 처리 시 재고가 즉시 차감되며<br>
          주문 상태가 <strong style="color:#92400E;">'출고 완료'</strong>로 변경됩니다.
        </div>
      </div>
    </div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="closeBulk()">취소</button>
      <button class="btn btn-green" onclick="doBulk()">✅ 일괄 출고 확정</button>
    </div>
  </div>
</div>

<div class="modal-bg" id="histModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">📋 출고 상세 정보</div>
      <button class="modal-x" onclick="document.getElementById('histModal').classList.remove('open')">✕</button>
    </div>
    <div class="modal-body">
      <div style="text-align:center; padding:30px; color:var(--gray4);">상세 정보 출력 영역</div>
    </div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="document.getElementById('histModal').classList.remove('open')">닫기</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
function updateClock() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const el = document.getElementById("realTimeClock");
    if(el) el.innerText = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
}
updateClock();
setInterval(updateClock, 60000);

function showToast(msg) {
    const t = document.getElementById('toast');
    if(!t) return;
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 2800);
}

function switchTab(tab) {
    const isOut = tab === 'out';
    document.getElementById('sec-out').style.display  = isOut ? '' : 'none';
    document.getElementById('sec-hist').style.display = isOut ? 'none' : '';
    document.getElementById('tab-out-btn').classList.toggle('on', isOut);
    document.getElementById('tab-hist-btn').classList.toggle('on', !isOut);
}

const orders = [
	  <c:forEach var="p" items="${pendingList}">
	  { 
	    uid: '${p.orderNum}_${p.optNum}', // 주문번호와 옵션번호를 합친 중복 안 되는 키값
	    id: '#${p.orderNum}', 
	    rawId: ${p.orderNum}, 
	    optNum: ${p.optNum}, 
	    qty: ${p.orderItemQty}, 
	    time: '${p.orderCreatedAt}'.substring(0, 16), 
	    name: '${p.prodName}', 
	    size: '${p.sizeVal}mm', 
	    color: '${p.color}', 
	    addr: '${p.recvAddr1}'.split(' ').slice(0, 2).join(' '), 
	    recv: '${p.recvName}' 
	  },
	  </c:forEach>
	];

const histories = [
  <c:forEach var="h" items="${historyList}">
  { 
    outNum: ${h.outNum}, 
    orderNum: ${h.orderNum}, 
    outDate: '${h.outDate}', 
    name: '${h.prodName}', 
    size: '${h.sizeVal}mm', 
    color: '${h.color}', 
    qty: ${h.orderItemQty}, 
    courier: '${empty h.courier ? "-" : h.courier}', 
    invoice: '${empty h.invoiceNo ? "미등록" : h.invoiceNo}',
    adminNum: '${h.adminNum}'
  },
  </c:forEach>
];

let currentSingleId = null;
let currentHistOutNum = null;

let currentPage = 1;
const itemsPerPage = 8;
let filteredOrders = [...orders];

let currentHistPage = 1;
const histItemsPerPage = 10;
let filteredHistories = [...histories];

function renderTable() {
	  const tbody = document.getElementById('orderTbody');
	  if(!tbody) return;
	  
	  const start = (currentPage - 1) * itemsPerPage;
	  const end = start + itemsPerPage;
	  const pageData = filteredOrders.slice(start, end);

	  if(!pageData.length) {
	    tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:40px;color:var(--gray4);font-size:13px">📭 출고 대기 주문이 없습니다</td></tr>';
	    if(document.getElementById('totalCnt')) document.getElementById('totalCnt').textContent = filteredOrders.length;
	    renderPagination();
	    return;
	  }

	  let html = '';
	  for(let i=0; i<pageData.length; i++) {
	    const o = pageData[i];
	    // o.id 가 아니라 o.uid 를 파라미터로 넘김
	    const actionBtn = '<button type="button" class="btn btn-blue btn-xs" onclick="openSingle(\'' + o.uid + '\')">출고 처리</button>';
	    html += '<tr class="tbl-row" data-id="' + o.uid + '" onclick="rowClick(this)">'
	      + '<td onclick="event.stopPropagation()"><input type="checkbox" class="row-chk" data-id="' + o.uid + '" onchange="updateSel()"></td>'
	      + '<td style="font-family:\'DM Mono\',monospace;font-size:11.5px;font-weight:700;color:var(--blue)">' + o.id + '</td>'
	      + '<td style="font-size:11px;color:var(--gray3)">' + o.time + '</td>'
	      + '<td style="font-weight:600;color:var(--gray1)">' + o.name + '</td>'
	      + '<td><span class="bdg bdg-gray" style="font-family:\'DM Mono\',monospace;font-size:10px">' + o.size + '</span> <span style="font-size:11px;color:var(--gray4)">' + o.color + '</span></td>'
	      + '<td style="font-family:\'DM Mono\',monospace;font-weight:700;font-size:13px">' + o.qty + '</td>'
	      + '<td style="font-size:12px">' + o.addr + '</td>'
	      + '<td><span class="bdg bdg-amber">출고 대기</span></td>'
	      + '<td onclick="event.stopPropagation()">' + actionBtn + '</td>'
	      + '</tr>';
	  }
	  tbody.innerHTML = html;

	  if(document.getElementById('totalCnt')) document.getElementById('totalCnt').textContent = filteredOrders.length;
	  renderPagination();
	}

function renderPagination() {
  const totalPages = Math.ceil(filteredOrders.length / itemsPerPage) || 1;
  const pageInfo = document.getElementById('pageInfo');
  const pageBtns = document.getElementById('pageBtns');

  const startNum = filteredOrders.length === 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
  const endNum = Math.min(currentPage * itemsPerPage, filteredOrders.length);
  if(pageInfo) pageInfo.textContent = startNum + ' – ' + endNum + ' / ' + filteredOrders.length + '건';

  if(!pageBtns) return;
  let btnsHTML = '<div class="pg-btn ' + (currentPage === 1 ? 'disabled' : '') + '" onclick="changePage(' + (currentPage - 1) + ')">‹</div>';
  for(let i=1; i<=totalPages; i++) {
      btnsHTML += '<div class="pg-btn ' + (i === currentPage ? 'on' : '') + '" onclick="changePage(' + i + ')">' + i + '</div>';
  }
  btnsHTML += '<div class="pg-btn ' + (currentPage === totalPages ? 'disabled' : '') + '" onclick="changePage(' + (currentPage + 1) + ')">›</div>';
  pageBtns.innerHTML = btnsHTML;
}

function changePage(page) {
  const totalPages = Math.ceil(filteredOrders.length / itemsPerPage) || 1;
  if(page < 1 || page > totalPages) return;
  currentPage = page;
  renderTable();
  if(document.getElementById('chkAll')) document.getElementById('chkAll').checked = false;
  updateSel();
}

function rowClick(tr) { const chk = tr.querySelector('.row-chk'); chk.checked = !chk.checked; updateSel(); }
function toggleAll(cb) { document.querySelectorAll('.row-chk').forEach(c => c.checked = cb.checked); updateSel(); }
function updateSel() {
  const checked = document.querySelectorAll('.row-chk:checked');
  const n = checked.length;
  if(document.getElementById('selCnt')) document.getElementById('selCnt').textContent = n;
  if(document.getElementById('bulkBtn')) document.getElementById('bulkBtn').disabled = n === 0;
  if(document.getElementById('bulkCnt')) document.getElementById('bulkCnt').textContent = n > 0 ? '(' + n + '건)' : '';
  if(document.getElementById('chkAll')) document.getElementById('chkAll').checked = (n > 0 && n === document.querySelectorAll('.row-chk').length);
}

// 단일 출고 모달 열기 (택배사 선택 및 운송장 기입 폼)
function openSingle(uid) {
  const o = orders.find(x => x.uid === uid);
  if(!o) return;
  currentSingleId = uid; // 저장해둠
  
  if (o.stock !== undefined && o.qty > o.stock) {
      showToast(`⚠ 재고(${o.stock}개)가 주문 수량(${o.qty}개)보다 부족합니다.`, true);
      return;
  }
  
  document.getElementById('singleBody').innerHTML = 
      '<div class="sec-title">주문 정보</div>'
    + '<div class="dr"><div class="dk">주문번호</div><div class="dv"><b>' + o.id + '</b></div></div>'
    + '<div class="dr"><div class="dk">상품명</div><div class="dv">' + o.name + ' (' + o.size + ' / ' + o.color + ')</div></div>' // 이름에 옵션도 추가해줌
    + '<div class="dr"><div class="dk">수량</div><div class="dv"><b>' + o.qty + '개</b></div></div>'
    + '<hr style="border:0;border-top:1px solid var(--gray6);margin:15px 0">'
    + '<div class="sec-title">배송 정보 입력</div>'
    + '<div class="dr">'
    +   '<div class="dk">택배사</div>'
    +   '<div class="dv">'
    +     '<select id="modal-courier" class="modal-input" style="padding:8px 12px; cursor:pointer;">'
    +       '<option value="">택배사를 선택해주세요</option>'
    +       '<option value="CJ대한통운">CJ대한통운</option>'
    +       '<option value="롯데택배">롯데택배</option>'
    +       '<option value="한진택배">한진택배</option>'
    +       '<option value="우체국택배">우체국택배</option>'
    +     '</select>'
    +   '</div>'
    + '</div>'
    + '<div class="dr">'
    +   '<div class="dk">운송장 번호</div>'
    +   '<div class="dv" style="display:flex; gap:8px;">'
    +     '<input type="text" id="modal-invoice" class="modal-input" placeholder="운송장 번호 (자동생성 가능)" readonly style="background-color: var(--gray7);">'
    +     '<button type="button" class="btn btn-outline btn-sm" onclick="generateInvoice()" style="white-space:nowrap;">운송장번호 기입</button>'
    +   '</div>'
    + '</div>';
    
  document.getElementById('singleModal').classList.add('open');
}

// 직관적인 운송장 번호 랜덤 생성 로직
function generateInvoice() {
    const courier = document.getElementById('modal-courier').value;
    if (!courier) {
        showToast('⚠ 택배사를 먼저 선택해주세요.');
        document.getElementById('modal-courier').focus();
        return;
    }

    // 오늘 날짜를 YYYYMMDD 포맷으로 만들기
    const now = new Date();
    const yyyy = now.getFullYear();
    const mm = String(now.getMonth() + 1).padStart(2, '0');
    const dd = String(now.getDate()).padStart(2, '0');
    const dateStr = yyyy + mm + dd;

    // 택배사별 직관적인 영문 프리픽스 설정
    let prefix = "";
    if(courier === 'CJ대한통운') prefix = "CJ";
    else if(courier === '롯데택배') prefix = "LOTTE";
    else if(courier === '한진택배') prefix = "HJ";
    else if(courier === '우체국택배') prefix = "POST";

    // 랜덤 4자리 숫자 생성 (0000 ~ 9999)
    const randomNum = String(Math.floor(Math.random() * 10000)).padStart(4, '0');

    // 최종 운송장 번호 조합 (예: CJ-20260517-1234)
    const invoiceStr = prefix + "-" + dateStr + "-" + randomNum;

    document.getElementById('modal-invoice').value = invoiceStr;
    showToast('✅ 운송장 번호가 기입되었습니다.');
}

function closeSingle(){ document.getElementById('singleModal').classList.remove('open'); }

// 출고 확정 전 유효성 검사
function confirmSingle() {
    const o = orders.find(x => x.uid === currentSingleId);
    if(!o) return;
    
    const courier = document.getElementById('modal-courier') ? document.getElementById('modal-courier').value : '';
    const invoice = document.getElementById('modal-invoice') ? document.getElementById('modal-invoice').value : '';
    
    if (!courier) { showToast('⚠ 택배사를 선택해주세요.'); document.getElementById('modal-courier').focus(); return; }
    if (!invoice) { showToast('⚠ 운송장 번호를 기입해주세요.'); return; }

    const form = document.getElementById('outboundForm');
    form.innerHTML = '<input type="hidden" name="orderNum" value="'+o.rawId+'">'
                   + '<input type="hidden" name="optNum" value="'+o.optNum+'">'
                   + '<input type="hidden" name="qty" value="'+o.qty+'">'
                   + '<input type="hidden" name="courier" value="'+courier+'">'
                   + '<input type="hidden" name="invoiceNo" value="'+invoice+'">';
    form.submit(); 
}

function openBulkConfirm() {
	  const checked = document.querySelectorAll('.row-chk:checked');
	  
	  const html = 
	      '<div class="confirm-icon" style="font-size:42px; margin-bottom:12px;">📦</div>'
	    + '<div class="confirm-title" style="font-size:18px; font-weight:700; margin-bottom:8px; color:var(--gray1);">선택 주문 일괄 출고</div>'
	    + '<div class="confirm-desc" style="font-size:13px; color:var(--gray3); margin-bottom:20px;">선택하신 ' + checked.length + '건의 상품을 일괄 출고합니다.</div>'
	    
	    // 단일 출고에 있던 택배사/운송장 폼 이식
	    + '<div style="text-align:left; background:var(--gray7); padding:16px; border-radius:8px; margin-bottom:20px;">'
	    +   '<div style="margin-bottom:12px;">'
	    +     '<div style="font-size:12px; font-weight:600; margin-bottom:6px;">일괄 적용 택배사</div>'
	    +     '<select id="bulk-courier" class="modal-input" style="padding:8px 12px; width:100%; cursor:pointer;">'
	    +       '<option value="">택배사를 선택해주세요</option>'
	    +       '<option value="CJ대한통운">CJ대한통운</option>'
	    +       '<option value="롯데택배">롯데택배</option>'
	    +       '<option value="한진택배">한진택배</option>'
	    +       '<option value="우체국택배">우체국택배</option>'
	    +     '</select>'
	    +   '</div>'
	    +   '<div>'
	    +     '<div style="font-size:12px; font-weight:600; margin-bottom:6px;">일괄 적용 운송장 번호</div>'
	    +     '<div style="display:flex; gap:8px;">'
	    +       '<input type="text" id="bulk-invoice" class="modal-input" placeholder="운송장 번호 기입" readonly style="background-color: var(--white);">'
	    +       '<button type="button" class="btn btn-outline btn-sm" onclick="generateBulkInvoice()" style="white-space:nowrap;">자동 생성</button>'
	    +     '</div>'
	    +   '</div>'
	    + '</div>'
	    
	    + '<div class="alert alert-amber" style="margin:0; text-align:left; display:flex; gap:8px; align-items:flex-start; line-height:1.5;">'
	    +   '<span class="alert-ico" style="flex-shrink:0; margin-top:2px;">⚠</span>'
	    +   '<div style="flex:1; font-size:12.5px;">출고 처리 시 재고가 즉시 차감되며<br>마지막 상품 출고 시 주문 상태가 변경됩니다.</div>'
	    + '</div>';

	  document.querySelector('#bulkModal .modal-body').innerHTML = html;
	  document.getElementById('bulkModal').classList.add('open');
	}
	
function generateBulkInvoice() {
    const courier = document.getElementById('bulk-courier').value;
    if (!courier) {
        showToast('⚠ 택배사를 먼저 선택해주세요.');
        document.getElementById('bulk-courier').focus();
        return;
    }
    const dateStr = new Date().toISOString().slice(0,10).replace(/-/g,'');
    let prefix = "CJ";
    if(courier === '롯데택배') prefix = "LOTTE";
    else if(courier === '한진택배') prefix = "HJ";
    else if(courier === '우체국택배') prefix = "POST";

    const randomNum = String(Math.floor(Math.random() * 10000)).padStart(4, '0');
    // 일괄 출고용은 송장번호에 BULK 기호를 넣어 세팅
    document.getElementById('bulk-invoice').value = prefix + "-" + dateStr + "-BULK-" + randomNum;
    showToast('✅ 일괄 운송장 번호가 기입되었습니다.');
}
	
function closeBulk(){ document.getElementById('bulkModal').classList.remove('open'); }

function doBulk() {
    const courier = document.getElementById('bulk-courier') ? document.getElementById('bulk-courier').value : '';
    const invoice = document.getElementById('bulk-invoice') ? document.getElementById('bulk-invoice').value : '';

    if (!courier) { showToast('⚠ 택배사를 선택해주세요.'); return; }
    if (!invoice) { showToast('⚠ 운송장 번호를 기입해주세요.'); return; }

    const checked = Array.from(document.querySelectorAll('.row-chk:checked'));
    const uids = checked.map(c => c.dataset.id);
    const form = document.getElementById('outboundForm');
    form.innerHTML = '';
    
    uids.forEach(uid => {
        const o = orders.find(x => x.uid === uid);
        if(o) {
            form.innerHTML += '<input type="hidden" name="orderNum" value="'+o.rawId+'">'
                            + '<input type="hidden" name="optNum" value="'+o.optNum+'">'
                            + '<input type="hidden" name="qty" value="'+o.qty+'">'
                            + '<input type="hidden" name="courier" value="'+courier+'">' // 선택한 택배사
                            + '<input type="hidden" name="invoiceNo" value="'+invoice+'">'; // 선택한 송장
        }
    });
    form.submit();
}

function renderHistTable() {
  const tbody = document.getElementById('histTbody');
  if(!tbody) return;

  const start = (currentHistPage - 1) * histItemsPerPage;
  const end = start + histItemsPerPage;
  const pageData = filteredHistories.slice(start, end);

  if(!pageData.length) {
    tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;padding:40px;color:var(--gray4);">📭 조회된 출고 이력이 없습니다.</td></tr>';
    if(document.getElementById('totalHistCnt')) document.getElementById('totalHistCnt').textContent = "0";
    renderHistPagination();
    return;
  }

  let html = '';
  for(let i=0; i<pageData.length; i++) {
    const h = pageData[i];
    const outDateStr = h.outDate.substring(0, 10).replace(/-/g, '');
    html += '<tr class="tbl-row" onclick="openHistModal(' + h.outNum + ')">'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11px;color:var(--blue)">OUT-' + outDateStr + '-' + h.outNum + '</td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11px">#' + h.orderNum + '</td>'
      + '<td style="font-size:11px;color:var(--gray3)">' + h.outDate + '</td>'
      + '<td style="font-weight:600">' + h.name + '</td>'
      + '<td><span class="bdg bdg-gray" style="font-size:10px">' + h.size + ' / ' + h.color + '</span></td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-weight:700">' + h.qty + '</td>'
      + '<td>' + h.courier + '</td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11px;color:var(--gray3)">' + h.invoice + '</td>'
      + '<td><span class="bdg bdg-green">출고 완료</span></td>'
      + '<td>' + (h.adminNum || '관리자') + '</td>'
      + '</tr>';
  }
  tbody.innerHTML = html;

  if(document.getElementById('totalHistCnt')) document.getElementById('totalHistCnt').textContent = filteredHistories.length;
  renderHistPagination();
}

function renderHistPagination() {
  const totalPages = Math.ceil(filteredHistories.length / histItemsPerPage) || 1;
  const pageInfo = document.getElementById('histPageInfo');
  const pageBtns = document.getElementById('histPageBtns');

  const startNum = filteredHistories.length === 0 ? 0 : (currentHistPage - 1) * histItemsPerPage + 1;
  const endNum = Math.min(currentHistPage * histItemsPerPage, filteredHistories.length);
  if(pageInfo) pageInfo.textContent = startNum + ' – ' + endNum + ' / ' + filteredHistories.length + '건';

  if(!pageBtns) return;
  let btnsHTML = '<div class="pg-btn ' + (currentHistPage === 1 ? 'disabled' : '') + '" onclick="changeHistPage(' + (currentHistPage - 1) + ')">‹</div>';
  for(let i=1; i<=totalPages; i++) {
      btnsHTML += '<div class="pg-btn ' + (i === currentHistPage ? 'on' : '') + '" onclick="changeHistPage(' + i + ')">' + i + '</div>';
  }
  btnsHTML += '<div class="pg-btn ' + (currentHistPage === totalPages ? 'disabled' : '') + '" onclick="changeHistPage(' + (currentHistPage + 1) + ')">›</div>';
  
  pageBtns.innerHTML = btnsHTML;
}

function changeHistPage(page) {
  const totalPages = Math.ceil(filteredHistories.length / histItemsPerPage) || 1;
  if(page < 1 || page > totalPages) return;
  currentHistPage = page;
  renderHistTable();
}

function openHistModal(outNum) {
    const h = histories.find(x => x.outNum === outNum);
    if(!h) return;
    
    currentHistOutNum = h.outNum; 
    
    const histBody = document.querySelector('#histModal .modal-body');
    const histFoot = document.querySelector('#histModal .modal-foot');
    
    histBody.innerHTML = 
      '<div style="margin-bottom:16px">'
      + '<div class="sec-title">출고 기본 정보</div>'
      + '<div class="dr"><div class="dk">출고 번호</div><div class="dv" style="font-family:\'DM Mono\',monospace;color:var(--blue)">OUT-' + h.outNum + '</div></div>'
      + '<div class="dr"><div class="dk">주문 번호</div><div class="dv" style="font-family:\'DM Mono\',monospace">#' + h.orderNum + '</div></div>'
      + '<div class="dr"><div class="dk">출고 일시</div><div class="dv">' + h.outDate + '</div></div>'
      + '<hr style="border:0;border-top:1px solid var(--gray6);margin:15px 0">'
      + '<div class="sec-title">상품 및 배송 정보</div>'
      + '<div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">' + h.name + ' (' + h.size + ' / ' + h.color + ')</div></div>'
      + '<div class="dr"><div class="dk">수량</div><div class="dv"><b>' + h.qty + '개</b></div></div>'
      + '<div class="dr"><div class="dk">택배사</div><div class="dv">' + h.courier + '</div></div>'
      + '<div class="dr"><div class="dk">송장번호</div><div class="dv" style="font-family:\'DM Mono\',monospace;color:var(--gray3)">' + h.invoice + '</div></div>'
      + '</div>';

    histFoot.innerHTML = 
      '<button class="btn btn-outline" onclick="document.getElementById(\'histModal\').classList.remove(\'open\')">닫기</button>'
      + '<button class="btn btn-red" onclick="cancelHistory(' + h.outNum + ', ' + h.orderNum + ')">🗑️ 출고 취소(삭제)</button>';

    document.getElementById('histModal').classList.add('open');
}

function cancelHistory(outNum, orderNum) {
    if(!confirm("이 출고 이력을 삭제하고 다시 대기 상태로 되돌리시겠습니까?")) return;
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/logistics/log_out/log_outDelete.do';
    form.innerHTML = '<input type="hidden" name="outNum" value="' + outNum + '"><input type="hidden" name="orderNum" value="' + orderNum + '">';
    document.body.appendChild(form);
    form.submit();
}

['singleModal','bulkModal', 'histModal'].forEach(id => {
  const el = document.getElementById(id);
  if(el) {
      el.addEventListener('click', e => {
        if(e.target === e.currentTarget) e.currentTarget.classList.remove('open');
      });
  }
});

renderTable();
renderHistTable();

const activeTab = '${activeTab}' || 'out';
switchTab(activeTab);
</script>
</body>
</html>