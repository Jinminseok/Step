<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
.tab-btn{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}

/* ══ ALERT ══ */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-green{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.alert-blue{background:var(--blue-lt);border-color:#93C5FD;color:#1E3A8A}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}

/* ══ KPI ══ */
.kpi-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px}
.kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:16px 18px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden}
.kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.kpi.red::before{background:var(--red)}.kpi.amber::before{background:var(--amber)}.kpi.blue::before{background:var(--blue)}.kpi.green::before{background:var(--green)}
.kpi-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px}
.kpi-val{font-family:'DM Mono',monospace;font-size:26px;font-weight:700;margin-bottom:4px}
.kpi-val.c-red{color:var(--red)}.kpi-val.c-amber{color:var(--amber)}.kpi-val.c-blue{color:var(--blue)}.kpi-val.c-green{color:var(--green)}
.kpi-sub{font-size:11px;color:var(--gray4)}

/* ══ TOOLBAR ══ */
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;min-width:200px;max-width:280px}
.search-wrap input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;transition:border .15s}
.sel:focus{border-color:var(--blue)}

/* ══ BUTTONS ══ */
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-green{background:var(--green);color:#fff}.btn-green:hover{background:#059669}
.btn-red{background:var(--red);color:#fff}.btn-red:hover{background:#DC2626}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-ghost{background:transparent;color:var(--gray3);border:1.5px solid var(--gray5)}.btn-ghost:hover{color:var(--gray1);border-color:var(--gray3)}
.btn-amber{background:var(--amber);color:#fff}.btn-amber:hover{background:#D97706}
.btn-sm{padding:7px 13px;font-size:12px}
.btn-xs{padding:4px 10px;font-size:11px}

/* ══ TABLE ══ */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:8px;flex-wrap:wrap}
.tbl-top-info{font-size:12px;color:var(--gray3)}.tbl-top-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
thead{position:sticky;top:0;z-index:5}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}
.tbl-row{cursor:pointer;transition:background .12s}
.tbl-row:hover td{background:#F5F8FF}
td:first-child{border-left:3px solid transparent;padding-left:11px}
.tbl-row.selected td{background:var(--blue-lt)}.tbl-row.selected td:first-child{border-left-color:var(--blue)}

/* ══ BADGE ══ */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-purple{background:var(--purple-lt);color:var(--purple)}
.bdg-orange{background:var(--orange-lt);color:var(--orange)}
.bdg-teal{background:var(--teal-lt);color:var(--teal)}

/* ══ TYPE CHIP ══ */
.type-chip{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:6px;font-size:11px;font-weight:700;white-space:nowrap}
.type-ret{background:var(--red-lt);color:#991B1B;border:1px solid #FECACA}
.type-exc{background:var(--amber-lt);color:#92400E;border:1px solid #FCD34D}

/* ══ STOCK STATUS INDICATOR ══ */
.stock-ind{display:flex;align-items:center;gap:5px;font-size:12px}
.stock-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.s-good{background:var(--green)}.s-bad{background:var(--red)}.s-pend{background:var(--gray4)}

/* ══ PAGINATION ══ */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* ══ INNER TABS (이력 탭 안) ══ */
.inner-tabs{display:flex;gap:0;border-bottom:1.5px solid var(--gray6);margin-bottom:14px}
.inner-tab{padding:8px 18px;font-size:12px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-1px;transition:all .15s;display:flex;align-items:center;gap:6px}
.inner-tab.on{color:var(--blue);border-bottom-color:var(--blue)}
.inner-tab:hover:not(.on){color:var(--gray2)}
.inner-cnt{font-size:9px;font-weight:700;padding:1px 5px;border-radius:10px;color:#fff}

/* ══ FILTER BAR ══ */
.filter-bar{display:flex;align-items:center;gap:8px;padding:12px 16px;background:var(--white);border:1px solid var(--gray6);border-radius:10px;margin-bottom:14px;flex-wrap:wrap;box-shadow:0 1px 3px rgba(15,32,68,.05)}
.f-label{font-size:11px;font-weight:700;color:var(--gray3);white-space:nowrap;text-transform:uppercase;letter-spacing:.05em}
.date-in{padding:7px 10px;border:1.5px solid var(--gray5);border-radius:6px;font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;transition:border .15s}
.date-in:focus{border-color:var(--blue)}

/* ══ MODAL ══ */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:560px;max-height:90vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* DETAIL ROWS */
.dr{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7)}
.dr:last-child{border-bottom:none}
.dk{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:110px;flex-shrink:0;padding-top:1px}
.dv{font-size:13px;color:var(--gray1);flex:1}

/* SECTION TITLE */
.sec-ttl{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px}
.sec-ttl::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}

/* INSPECTION CARD */
.inspect-card{border:1.5px solid var(--gray5);border-radius:8px;overflow:hidden;margin-bottom:14px}
.inspect-hdr{padding:10px 14px;background:var(--gray7);font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.inspect-body{padding:14px}

/* ACTION CONFIRM BOX */
.action-box{border-radius:8px;padding:14px 16px;margin-top:12px;border:1.5px solid}
.action-box-good{background:var(--green-lt);border-color:#6EE7B7}
.action-box-bad{background:var(--red-lt);border-color:#FECACA}
.action-box-title{font-size:12px;font-weight:700;margin-bottom:4px}
.action-box-desc{font-size:11.5px;color:var(--gray3);line-height:1.6}

/* TOAST */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* SUMMARY PILLS */
.pills{display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.pill{display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid;font-size:12px;font-weight:600}
.pill-num{font-family:'DM Mono',monospace;font-size:16px;font-weight:700}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>
<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur" id="pg-title">반품/교환 물류 검수</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
    </div>
  </div>
  
  <div class="content">
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-wait-btn" onclick="switchTab('wait')">
        📦 입고 대기 및 검수
        <span class="tab-cnt" id="waitTabCnt" style="background:var(--red)">0</span>
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchTab('hist')">
        📋 처리 내역 조회
        <span class="tab-cnt" id="histTabCnt" style="background:var(--gray3)">0</span>
      </div>
    </div>

    <div id="sec-wait">
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div>CS팀이 승인한 반품·교환 상품 <strong id="waitNum">0</strong>건이 회수되었습니다. 실물 검수 후 재고에 반영해 주세요.</div>
      </div>

      <div class="kpi-row">
        <div class="kpi red">
          <div class="kpi-label">검수 대기 (지연)</div>
          <div class="kpi-val c-red" id="kpiWait">0</div>
          <div class="kpi-sub">즉시 실물 확인 필요</div>
        </div>
        <div class="kpi amber">
          <div class="kpi-label">반품 처리 현황</div>
          <div class="kpi-val c-amber" id="kpiReturn">0</div>
          <div class="kpi-sub">총 반품 완료 건수</div>
        </div>
        <div class="kpi blue">
          <div class="kpi-label">교환 처리 현황</div>
          <div class="kpi-val c-blue" id="kpiExchange">0</div>
          <div class="kpi-sub">총 교환 완료 건수</div>
        </div>
        <div class="kpi green">
          <div class="kpi-label">재고 복구 완료</div>
          <div class="kpi-val c-green" id="kpiRecover">0</div>
          <div class="kpi-sub">양품 복구 누계</div>
        </div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">실물 검수 대기 목록 — 총 <strong id="waitTotal">0</strong>건</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:40px">No</th>
                <th>주문번호</th>
                <th>유형</th>
                <th>상품명 / 옵션</th>
                <th>수량</th>
                <th>고객 사유</th>
                <th>검수 상태</th>
                <th>관리</th>
              </tr>
            </thead>
            <tbody id="waitTbody"></tbody>
          </table>
        </div>
      </div>
    </div>

    <div id="sec-hist" style="display:none">
      <div class="filter-bar">
        <span class="f-label">조회 기간</span>
        <input type="date" class="date-in" value="2026-05-01">
        <span style="font-size:12px;color:var(--gray4)">~</span>
        <input type="date" class="date-in" value="2026-05-31">
        
        <select class="sel" style="margin-left:8px;"><option>전체 유형</option><option>반품만</option><option>교환만</option></select>
        <select class="sel"><option>상태 전체</option><option>양품 복구</option><option>불량 폐기</option><option>교환 출고</option></select>
        
        <div class="search-wrap" style="max-width:260px; margin-left:8px;">
          <span class="search-ico">🔍</span>
          <input type="text" placeholder="주문번호, 상품명 검색">
        </div>
        <button class="btn btn-blue btn-sm" onclick="showToast('조회 완료')">조회</button>
      </div>

      <div class="pills">
        <div class="pill" style="background:var(--blue-lt);border-color:#93C5FD;color:var(--blue)"><div class="pill-num" id="pillTotal">0</div>전체</div>
        <div class="pill" style="background:var(--red-lt);border-color:#FECACA;color:#991B1B"><div class="pill-num" id="pillReturn">0</div>반품</div>
        <div class="pill" style="background:var(--amber-lt);border-color:#FCD34D;color:#92400E"><div class="pill-num" id="pillExchange">0</div>교환</div>
        <div class="pill" style="background:var(--green-lt);border-color:#6EE7B7;color:#065F46"><div class="pill-num" id="pillGood">0</div>양품 복구</div>
        <div class="pill" style="background:var(--red-lt);border-color:#FECACA;color:#991B1B"><div class="pill-num" id="pillBad">0</div>불량 폐기</div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">이력 총 <strong id="histTotalTxt">0</strong>건</div>
          <button class="btn btn-xs btn-outline">📥 엑셀 다운로드</button>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>번호</th><th>유형</th><th>처리 날짜</th><th>주문번호</th>
                <th>상품명</th><th>옵션</th><th>수량</th><th>재고 처리 내역</th><th>담당자</th>
              </tr>
            </thead>
            <tbody id="histTbody"></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</main>

<div class="modal-bg" id="inspectModal">
  <form class="modal" id="inspectForm" action="${pageContext.request.contextPath}/logistics/processReturn.do" method="post">
    <input type="hidden" name="ret_num" id="inspect_ret_num">
    <input type="hidden" name="is_good" id="inspect_is_good">
    <input type="hidden" name="qty" id="inspect_qty">
    <input type="hidden" name="opt_num" id="inspect_opt_num">
    
    <div class="modal-hdr">
      <div class="modal-title">🔍 반품 실물 검수 처리</div>
      <button type="button" class="modal-x" onclick="closeInspect()">✕</button>
    </div>
    <div class="modal-body" id="inspectBody"></div>
    <div class="modal-foot" id="inspectFoot"></div>
  </form>
</div>

<div class="modal-bg" id="exchangeModal">
  <form class="modal" id="exchangeForm" action="${pageContext.request.contextPath}/logistics/processExchange.do" method="post">
    <input type="hidden" name="ret_num" id="exchange_ret_num">
    <input type="hidden" name="qty" id="exchange_qty">
    <input type="hidden" name="opt_num" id="exchange_opt_num">
    <input type="hidden" name="new_opt_num" id="exchange_new_opt_num">
    
    <div class="modal-hdr">
      <div class="modal-title">🔄 교환 검수 및 출고 처리</div>
      <button type="button" class="modal-x" onclick="closeExchange()">✕</button>
    </div>
    <div class="modal-body" id="exchangeBody"></div>
    <div class="modal-foot" id="exchangeFoot"></div>
  </form>
</div>

<div class="modal-bg" id="histDetailModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">📋 처리 상세 정보</div>
      <button type="button" class="modal-x" onclick="document.getElementById('histDetailModal').classList.remove('open')">✕</button>
    </div>
    <div class="modal-body" id="histDetailBody"></div>
    <div class="modal-foot">
      <button type="button" class="btn btn-outline" onclick="document.getElementById('histDetailModal').classList.remove('open')">닫기</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>
  
<script>
// 실시간 시계 업데이트
function updateClock() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    document.getElementById("realTimeClock").innerText = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
}
updateClock();
setInterval(updateClock, 60000);

// ── 🌟 백엔드(DB) 데이터 연동 ──
let waitData = [
  <c:forEach var="item" items="${waitList}">
  {
    no: ${item.ret_num}, 
    ordNo: 'ORD-${item.order_num}', 
    type: '${item.tp == 1 ? "반품" : "교환"}', 
    name: '${item.prod_name}', 
    size: '${item.opt_info}', 
    color: '', 
    qty: ${item.qty}, 
    reason: '${item.reason}', 
    stockStatus: '검수 전', 
    approvedBy: '시스템관리자', 
    approvedAt: '${item.ret_created_at}', 
    optNum: ${item.opt_num}, 
    newOptNum: '' 
  },
  </c:forEach>
];

const histData = [
  <c:forEach var="item" items="${histList}">
  {
    no: '${item.tp == 1 ? "반품" : "교환"}-${item.ret_num}', 
    rawType: ${item.tp},
    type: '${item.tp == 1 ? "반품" : "교환"}', 
    date: '${item.ret_updated_at}', 
    ordNo: 'ORD-${item.order_num}', 
    name: '${item.prod_name}', 
    size: '${item.opt_info}', 
    color: '', 
    qty: ${item.qty}, 
    isGood: ${item.is_good != null ? item.is_good : -1},
    stock: '${item.is_good == 1 ? (item.tp == 1 ? "양품 복구" : "교환 출고") : "불량 폐기"}', 
    status: '처리완료', 
    manager: '시스템관리자'
  },
  </c:forEach>
];

const stockBdg = {
  '검수 전':  '<span class="bdg bdg-gray">검수 전</span>',
  '양품 복구':'<span class="bdg bdg-green">양품 복구</span>',
  '불량 폐기':'<span class="bdg bdg-red">불량 폐기</span>',
  '교환 출고':'<span class="bdg bdg-teal">교환 출고</span>'
};

// ── 🌟 통계 숫자 업데이트 ──
function updateDashboardStats() {
    const waitCount = waitData.length;
    document.getElementById('waitTotal').textContent = waitCount;
    document.getElementById('waitNum').textContent = waitCount;
    document.getElementById('kpiWait').textContent = waitCount;
    document.getElementById('waitTabCnt').textContent = waitCount;

    const totalCount = histData.length;
    const returnCount = histData.filter(d => d.rawType === 1).length;
    const exchangeCount = histData.filter(d => d.rawType === 2).length;
    const goodCount = histData.filter(d => d.stock === '양품 복구').length;
    const badCount = histData.filter(d => d.stock === '불량 폐기').length;

    document.getElementById('kpiReturn').textContent = returnCount;
    document.getElementById('kpiExchange').textContent = exchangeCount;
    document.getElementById('kpiRecover').textContent = goodCount;

    document.getElementById('pillTotal').textContent = totalCount;
    document.getElementById('pillReturn').textContent = returnCount;
    document.getElementById('pillExchange').textContent = exchangeCount;
    document.getElementById('pillGood').textContent = goodCount;
    document.getElementById('pillBad').textContent = badCount;

    document.getElementById('histTabCnt').textContent = totalCount;
    document.getElementById('histTotalTxt').textContent = totalCount;
}

// ── 🌟 대기 리스트 렌더링 ──
function renderWait() {
  const tbody = document.getElementById('waitTbody');
  const remaining = waitData.filter(d=>d.stockStatus==='검수 전');

  if(!remaining.length){
    tbody.innerHTML=`<tr><td colspan="8" style="text-align:center;padding:50px;color:var(--gray4);font-size:13.5px">✅ 실물 검수를 대기 중인 상품이 없습니다.</td></tr>`;
    return;
  }

  tbody.innerHTML = remaining.map(d => `
    <tr class="tbl-row" onclick="\${d.type==='반품'?'openInspect':'openExchange'}(\${d.no})">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">\${String(d.no).padStart(2,'0')}</td>
      <td style="font-family:'DM Mono',monospace;font-size:12px;font-weight:600;color:var(--blue)">\${d.ordNo}</td>
      <td><span class="type-chip \${d.type==='반품'?'type-ret':'type-exc'}">\${d.type}</span></td>
      <td>
        <div style="font-weight:600;color:var(--gray1);font-size:13px">\${d.name}</div>
        <div style="font-size:11px;color:var(--gray4);margin-top:2px;">옵션: \${d.size}</div>
      </td>
      <td style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</td>
      <td style="font-size:12px;color:var(--gray3);max-width:140px;text-overflow:ellipsis;overflow:hidden;white-space:nowrap">\${d.reason}</td>
      <td>\${stockBdg[d.stockStatus]}</td>
      <td onclick="event.stopPropagation()" style="display:flex;gap:5px;">
        \${d.type==='반품'
          ? `<button class="btn btn-outline btn-xs" onclick="openInspect(\${d.no})">검수하기</button>`
          : `<button class="btn btn-amber btn-xs" onclick="openExchange(\${d.no})">교환출고</button>`
        }
      </td>
    </tr>
  `).join('');
}

// ── 🌟 이력 리스트 렌더링 ──
function renderHist(data) {
  const tbody = document.getElementById('histTbody');
  if(!data.length){
    tbody.innerHTML=`<tr><td colspan="9" style="text-align:center;padding:50px;color:var(--gray4);">조건에 맞는 처리 내역이 없습니다.</td></tr>`;
    return;
  }
  
  tbody.innerHTML = data.map(d => `
    <tr class="tbl-row" onclick="openHistDetail('\${d.no}')">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue)">\${d.no}</td>
      <td><span class="type-chip \${d.type==='반품'?'type-ret':'type-exc'}">\${d.type}</span></td>
      <td style="font-size:11px;color:var(--gray3)">\${d.date}</td>
      <td style="font-family:'DM Mono',monospace;font-size:11px">\${d.ordNo}</td>
      <td style="font-weight:600;color:var(--gray1)">\${d.name}</td>
      <td><span class="bdg bdg-gray">\${d.size}</span></td>
      <td style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</td>
      <td>\${stockBdg[d.stock]||''}</td>
      <td>\${d.manager}</td>
    </tr>
  `).join('');
}

// ── 🌟 검수(반품) 모달 제어 ──
function openInspect(no) {
  const d = waitData.find(x=>x.no===no);
  if(!d||d.type!=='반품') return;
  
  document.getElementById('inspect_ret_num').value = no;
  document.getElementById('inspect_qty').value = d.qty;
  document.getElementById('inspect_opt_num').value = d.optNum; 
  
  document.getElementById('inspectBody').innerHTML = `
    <div class="alert alert-blue" style="margin-bottom:18px">
      <span class="alert-ico">🔍</span>
      <div>실물 도착 상품을 검수한 후 양품 또는 불량 여부를 선택하세요.</div>
    </div>
    <div style="margin-bottom:18px">
      <div class="sec-ttl">반품 상품 정보</div>
      <div class="dr"><div class="dk">주문번호</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700;color:var(--blue)">\${d.ordNo}</div></div>
      <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
      <div class="dr"><div class="dk">사이즈</div><div class="dv">\${d.size}</div></div>
      <div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</div></div>
    </div>
    <div class="sec-ttl">실물 상태 체크</div>
    <div class="action-box action-box-good">
      <div class="action-box-title" style="color:#065F46">✅ 양품 (재고 자동 복구)</div>
      <div class="action-box-desc">미사용/정상 제품입니다. 해당 옵션 재고가 <strong>+\${d.qty}개</strong> 증가합니다.</div>
    </div>
    <div class="action-box action-box-bad" style="margin-top:8px">
      <div class="action-box-title" style="color:#991B1B">❌ 불량 (폐기 처리)</div>
      <div class="action-box-desc">오염/파손 제품입니다. 재고 증가 없이 불량 폐기로 기록됩니다.</div>
    </div>
  `;
  document.getElementById('inspectFoot').innerHTML = `
    <button type="button" class="btn btn-outline" onclick="closeInspect()">닫기</button>
    <button type="button" class="btn btn-red btn-sm" onclick="submitReturn('bad')">❌ 불량 폐기</button>
    <button type="button" class="btn btn-green btn-sm" onclick="submitReturn('good')">✅ 양품 복구</button>
  `;
  document.getElementById('inspectModal').classList.add('open');
}
function closeInspect(){ document.getElementById('inspectModal').classList.remove('open') }
function submitReturn(result) {
    document.getElementById('inspect_is_good').value = (result === 'good' ? 1 : 0);
    document.getElementById('inspectForm').submit();
}

// ── 🌟 교환 출고 모달 제어 ──
function openExchange(no) {
  const d = waitData.find(x=>x.no===no);
  if(!d||d.type!=='교환') return;
  
  document.getElementById('exchange_ret_num').value = no;
  document.getElementById('exchange_qty').value = d.qty;
  document.getElementById('exchange_opt_num').value = d.optNum; 
  document.getElementById('exchange_new_opt_num').value = d.newOptNum; 
  
  document.getElementById('exchangeBody').innerHTML = `
    <div class="alert alert-amber" style="margin-bottom:18px">
      <span class="alert-ico">🔄</span>
      <div>교환 상품 회수 확인 후, 새 상품 옵션으로 맞교환 출고를 진행합니다.</div>
    </div>
    <div style="margin-bottom:18px">
      <div class="sec-ttl">교환 요청 내역</div>
      <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
      <div class="dr"><div class="dk">변경 요청 옵션</div><div class="dv" style="font-weight:700;color:var(--blue)">\${d.size}</div></div>
      <div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</div></div>
      <div class="dr" style="margin-top:10px;"><div class="dk" style="color:var(--gray1)">회수품 상태</div>
        <div class="dv">
            <label style="margin-right:15px; cursor:pointer"><input type="radio" name="is_good" value="1" checked> 양품 (기존 재고에 복구)</label>
            <label style="cursor:pointer"><input type="radio" name="is_good" value="0"> 불량 (폐기)</label>
        </div>
      </div>
    </div>
    <div class="sec-ttl">새 상품 송장 입력</div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
      <select name="courier" id="exc_courier" class="sel">
        <option value="">택배사 선택</option><option value="CJ대한통운">CJ대한통운</option><option value="우체국">우체국택배</option>
      </select>
      <input type="text" name="tracking" id="exc_tracking" class="date-in" placeholder="송장번호 입력" style="font-family:'DM Mono',monospace">
    </div>
  `;
  document.getElementById('exchangeFoot').innerHTML = `
    <button type="button" class="btn btn-outline" onclick="closeExchange()">닫기</button>
    <button type="button" class="btn btn-amber btn-sm" onclick="submitExchange()">🔄 교환 출고 확정</button>
  `;
  document.getElementById('exchangeModal').classList.add('open');
}
function closeExchange(){ document.getElementById('exchangeModal').classList.remove('open') }
function submitExchange() {
  if(!document.getElementById('exc_courier').value || !document.getElementById('exc_tracking').value) {
      alert("택배사와 송장번호를 정확히 입력해주세요."); return;
  }
  document.getElementById('exchangeForm').submit();
}

// ── 🌟 이력 상세 ──
function openHistDetail(no) {
  const d = histData.find(x=>x.no===no);
  if(!d) return;
  document.getElementById('histDetailBody').innerHTML = `
    <div class="alert alert-green" style="margin-bottom:18px"><span class="alert-ico">✅</span><strong>처리 완료</strong> — \${d.no}</div>
    <div class="sec-ttl">처리 정보</div>
    <div class="dr"><div class="dk">처리일</div><div class="dv">\${d.date}</div></div>
    <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
    <div class="dr"><div class="dk">수량</div><div class="dv">\${d.qty}개</div></div>
    <div class="dr"><div class="dk">재고 처리</div><div class="dv">\${stockBdg[d.stock]}</div></div>
  `;
  document.getElementById('histDetailModal').classList.add('open');
}

// ── 🌟 탭 전환 ──
function switchTab(tab) {
  const isWait = tab==='wait';
  document.getElementById('sec-wait').style.display = isWait?'':'none';
  document.getElementById('sec-hist').style.display = isWait?'none':'';
  document.getElementById('tab-wait-btn').classList.toggle('on', isWait);
  document.getElementById('tab-hist-btn').classList.toggle('on', !isWait);
  if(!isWait) renderHist(histData);
}

// ── 🌟 공통 제어 ──
['inspectModal','exchangeModal','histDetailModal'].forEach(id=>{
  document.getElementById(id).addEventListener('click',e=>{ if(e.target===e.currentTarget) e.currentTarget.classList.remove('open'); });
});

function showToast(msg) {
  const t=document.getElementById('toast');
  t.textContent=msg; t.classList.add('show');
  setTimeout(()=>t.classList.remove('show'),2800);
}

// 초기화 가동
updateDashboardStats();
renderWait();
renderHist(histData);
</script>
</body>
</html>