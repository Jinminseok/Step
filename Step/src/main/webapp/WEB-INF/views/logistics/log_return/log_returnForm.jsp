<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반품/교환 재고반영</title>
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
<!-- ═══ MAIN ═══ -->
<main class="main">
  <!-- TOPBAR -->
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur" id="pg-title">반품/교환 재고반영</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->      
    </div>
  </div>
  
  <div class="content">

    <!-- TAB BAR -->
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-wait-btn" onclick="switchTab('wait')">
        📦 재고 반영 대기
        <span class="tab-cnt" id="waitTabCnt" style="background:var(--red)">3</span>
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchTab('hist')">
        📋 사이 보기
        <span class="tab-cnt" style="background:var(--gray3)">15</span>
      </div>
    </div>

    <!-- ════════ 재고 반영 대기 탭 ════════ -->
    <div id="sec-wait">

      <!-- 알림 -->
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div>관리자가 승인 처리한 반품·교환 상품이 <strong id="waitNum">3</strong>건 재고 반영 대기 중입니다. 상품 검수 후 처리해 주세요.</div>
      </div>

      <!-- KPI -->
      <div class="kpi-row">
        <div class="kpi red">
          <div class="kpi-label">재고 반영 대기</div>
          <div class="kpi-val c-red" id="kpiWait">3</div>
          <div class="kpi-sub">즉시 검수 필요</div>
        </div>
        <div class="kpi amber">
          <div class="kpi-label">이번 달 반품</div>
          <div class="kpi-val c-amber">12</div>
          <div class="kpi-sub">반품률 4.2%</div>
        </div>
        <div class="kpi blue">
          <div class="kpi-label">이번 달 교환</div>
          <div class="kpi-val c-blue">8</div>
          <div class="kpi-sub">교환 처리 건수</div>
        </div>
        <div class="kpi green">
          <div class="kpi-label">재고 복구 완료</div>
          <div class="kpi-val c-green">17</div>
          <div class="kpi-sub">양품 복구 누계</div>
        </div>
      </div>

      <!-- TABLE -->
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">반품/교환 재고 반영 대기 — 총 <strong id="waitTotal">3</strong>건</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:40px">번호</th>
                <th>주문번호</th>
                <th>유형</th>
                <th>상품명 / 옵션</th>
                <th>수량</th>
                <th>사유</th>
                <th>처리상태</th>
                <th>재고 반영</th>
                <th>처리</th>
              </tr>
            </thead>
            <tbody id="waitTbody"></tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- ════════ 사이 보기(이력) 탭 ════════ -->
    <div id="sec-hist" style="display:none">

      <!-- 필터 -->
      <div class="filter-bar">
        <span class="f-label">기간</span>
        <input type="date" class="date-in" value="2025-04-01">
        <span style="font-size:12px;color:var(--gray4)">~</span>
        <input type="date" class="date-in" value="2025-04-24">
        <select class="sel"><option>유형 전체</option><option>반품</option><option>교환</option></select>
        <select class="sel"><option>상태 전체</option><option>양품 복구</option><option>불량 폐기</option><option>교환 출고</option></select>
        <div class="search-wrap" style="max-width:220px">
          <span class="search-ico">🔍</span>
          <input type="text" placeholder="주문번호, 상품명 검색">
        </div>
        <button class="btn btn-blue btn-sm" onclick="showToast('조회 완료')">조회</button>
        <button class="btn btn-ghost btn-sm">초기화</button>
        <div style="margin-left:auto"><button class="btn btn-ghost btn-sm">📥 엑셀</button></div>
      </div>

      <!-- 요약 pills -->
      <div class="pills">
        <div class="pill" style="background:var(--blue-lt);border-color:#93C5FD;color:var(--blue)"><div class="pill-num">15</div>전체</div>
        <div class="pill" style="background:var(--red-lt);border-color:#FECACA;color:#991B1B"><div class="pill-num">10</div>반품</div>
        <div class="pill" style="background:var(--amber-lt);border-color:#FCD34D;color:#92400E"><div class="pill-num">5</div>교환</div>
        <div class="pill" style="background:var(--green-lt);border-color:#6EE7B7;color:#065F46"><div class="pill-num">12</div>양품 복구</div>
        <div class="pill" style="background:var(--red-lt);border-color:#FECACA;color:#991B1B"><div class="pill-num">3</div>불량 폐기</div>
      </div>

      <!-- Inner Tabs -->
      <div class="inner-tabs">
        <div class="inner-tab on" onclick="setInnerTab(this,'t-all')">전체 <span class="inner-cnt" style="background:var(--gray3)">15</span></div>
        <div class="inner-tab" onclick="setInnerTab(this,'t-ret')">반품 <span class="inner-cnt" style="background:var(--red)">10</span></div>
        <div class="inner-tab" onclick="setInnerTab(this,'t-exc')">교환 <span class="inner-cnt" style="background:var(--amber)">5</span></div>
      </div>

      <!-- 이력 테이블 -->
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong>15</strong>건 · 페이지 <strong>1 / 3</strong></div>
          <div style="display:flex;gap:6px"><button class="btn btn-xs btn-ghost">📥 엑셀 다운로드</button></div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:36px"><input type="checkbox"></th>
                <th>번호</th><th>유형</th><th>날짜</th><th>주문번호</th>
                <th>상품명</th><th>사이즈/컬러</th><th>처리 수량</th><th>재고 처리</th><th>상태</th><th>담당자</th>
              </tr>
            </thead>
            <tbody id="histTbody"></tbody>
          </table>
        </div>
        <div class="pagination-wrap">
          <div class="page-info">1 – 5 / 15건</div>
          <div class="page-btns">
            <div class="pg-btn">‹</div>
            <div class="pg-btn on">1</div><div class="pg-btn">2</div><div class="pg-btn">3</div>
            <div class="pg-btn">›</div>
          </div>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- ══ 검수 처리 모달 ══ -->
<div class="modal-bg" id="inspectModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">🔍 반품 검수 처리</div>
      <button class="modal-x" onclick="closeInspect()">✕</button>
    </div>
    <div class="modal-body" id="inspectBody"></div>
    <div class="modal-foot" id="inspectFoot"></div>
  </div>
</div>

<!-- ══ 교환 출고 모달 ══ -->
<div class="modal-bg" id="exchangeModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">🔄 교환 출고 처리</div>
      <button class="modal-x" onclick="closeExchange()">✕</button>
    </div>
    <div class="modal-body" id="exchangeBody"></div>
    <div class="modal-foot" id="exchangeFoot"></div>
  </div>
</div>

<!-- ══ 이력 상세 모달 ══ -->
<div class="modal-bg" id="histDetailModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">📋 처리 상세 정보</div>
      <button class="modal-x" onclick="document.getElementById('histDetailModal').classList.remove('open')">✕</button>
    </div>
    <div class="modal-body" id="histDetailBody"></div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="document.getElementById('histDetailModal').classList.remove('open')">닫기</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>
  

  
  
<script>
function updateClock() {
    const now = new Date();
    
    // 년, 월, 일 구하기
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    
    // 시, 분 구하기
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    
    // 🚨 수정한 부분: JSP가 가로채지 못하게 + 기호로 안전하게 문자열 연결!
    const timeString = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    
    // 화면에 밀어넣기
    document.getElementById("realTimeClock").innerText = timeString;
}

// 화면이 켜지자마자 바로 시계 표시
updateClock();

// 1분(60000ms)마다 갱신
setInterval(updateClock, 60000);

//── 대기 데이터 ────────────────────────────────────
let waitData = [
  {no:1, ordNo:'ORD-20250421-0051', type:'반품', name:'나이키 에어포스1',    size:'260mm',color:'화이트', qty:1, reason:'단순 변심',      stockStatus:'검수 전',  approvedBy:'쇼핑몰 관리자', approvedAt:'2025-04-24 08:30'},
  {no:2, ordNo:'ORD-20250420-0038', type:'교환', name:'아디다스 삼바 OG',   size:'265→270mm',color:'블랙', qty:1, reason:'사이즈 불일치', stockStatus:'검수 전', approvedBy:'쇼핑몰 관리자', approvedAt:'2025-04-23 17:10'},
  {no:3, ordNo:'ORD-20250420-0031', type:'반품', name:'뉴발란스 990v5',     size:'255mm',color:'네이비', qty:1, reason:'상품 불량',       stockStatus:'검수 전',  approvedBy:'쇼핑몰 관리자', approvedAt:'2025-04-23 16:50'},
];

// ── 이력 데이터 ─────────────────────────────────────
const histData = [
  {no:'반품-20250412', type:'반품', date:'2025/04/25', ordNo:'ORD-20260412', name:'나이키 에어포스1', size:'260mm', color:'화이트', qty:10, stock:'양품 복구',    status:'처리완료', manager:'이지훈'},
  {no:'교환-20250412', type:'교환', date:'2025/04/20', ordNo:'ORD-20250422', name:'아디다스 삼바',   size:'270mm', color:'블랙',   qty:20, stock:'교환 출고',   status:'처리완료', manager:'이지훈'},
  {no:'반품-20250411', type:'반품', date:'2025/04/21', ordNo:'ORD-20250423', name:'뉴발란스 990v5',  size:'255mm', color:'네이비', qty:15, stock:'불량 폐기',   status:'처리완료', manager:'박수진'},
  {no:'교환-20250410', type:'교환', date:'2025/04/19', ordNo:'ORD-20250418', name:'호카 클리프턴 9', size:'260mm', color:'화이트', qty:5,  stock:'교환 출고',   status:'처리완료', manager:'박수진'},
  {no:'반품-20250409', type:'반품', date:'2025/04/18', ordNo:'ORD-20250415', name:'나이키 조던 1',   size:'265mm', color:'레드',   qty:8,  stock:'양품 복구',   status:'처리완료', manager:'이지훈'},
];

const stockBdg = {
  '검수 전':  '<span class="bdg bdg-gray">검수 전</span>',
  '양품 복구':'<span class="bdg bdg-green">양품 복구</span>',
  '불량 폐기':'<span class="bdg bdg-red">불량 폐기</span>',
  '교환 출고':'<span class="bdg bdg-teal">교환 출고</span>',
  '처리완료': '<span class="bdg bdg-green">처리 완료</span>',
};

function renderWait() {
  const tbody = document.getElementById('waitTbody');
  const remaining = waitData.filter(d=>d.stockStatus==='검수 전');
  document.getElementById('waitTotal').textContent = remaining.length;
  document.getElementById('waitNum').textContent   = remaining.length;
  document.getElementById('kpiWait').textContent   = remaining.length;
  document.getElementById('waitTabCnt').textContent= remaining.length;

  if(!remaining.length){
    tbody.innerHTML=`<tr><td colspan="9" style="text-align:center;padding:40px;color:var(--gray4);font-size:13px">✅ 모든 반품/교환 재고 반영이 완료되었습니다.</td></tr>`;
    document.querySelector('.alert-amber').className='alert alert-green';
    document.querySelector('.alert-green').innerHTML='<span class="alert-ico">✅</span><div>모든 반품/교환 재고 반영이 완료되었습니다.</div>';
    return;
  }

  tbody.innerHTML = remaining.map(d => `
    <tr class="tbl-row" onclick="openInspect(\${d.no})" data-no="\${d.no}">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">\${String(d.no).padStart(2,'0')}</td>
      <td style="font-family:'DM Mono',monospace;font-size:11px;font-weight:600;color:var(--blue)">\${d.ordNo}</td>
      <td><span class="type-chip \${d.type==='반품'?'type-ret':'type-exc'}">\${d.type==='반품'?'↩':'🔄'} \${d.type}</span></td>
      <td>
        <div style="font-weight:600;color:var(--gray1);font-size:13px">\${d.name}</div>
        <div style="font-size:11px;color:var(--gray4);margin-top:2px;font-family:'DM Mono',monospace">\${d.size} / \${d.color}</div>
      </td>
      <td style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</td>
      <td style="font-size:12px;color:var(--gray3);max-width:120px">\${d.reason}</td>
      <td>\${stockBdg[d.stockStatus]||''}</td>
      <td>
        <div class="stock-ind">
          <div class="stock-dot s-pend"></div>
          <span style="color:var(--gray3)">대기 중</span>
        </div>
      </td>
      <td onclick="event.stopPropagation()" style="display:flex;gap:5px;align-items:center">
        \${d.type==='반품'
          ? `<button class="btn btn-green btn-xs" onclick="openInspect(\${d.no})">양품 복구</button>
             <button class="btn btn-red btn-xs" onclick="openInspect(\${d.no})">불량 폐기</button>`
          : `<button class="btn btn-amber btn-xs" onclick="openExchange(\${d.no})">교환 출고</button>`
        }
      </td>
    </tr>
  `).join('');
}

function renderHist(data) {
  document.getElementById('histTbody').innerHTML = data.map(d => `
    <tr class="tbl-row" onclick="openHistDetail('\${d.no}')">
      <td onclick="event.stopPropagation()"><input type="checkbox"></td>
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue)">\${d.no}</td>
      <td><span class="type-chip \${d.type==='반품'?'type-ret':'type-exc'}">\${d.type==='반품'?'↩':'🔄'} \${d.type}</span></td>
      <td style="font-size:11px;color:var(--gray3)">\${d.date}</td>
      <td style="font-family:'DM Mono',monospace;font-size:11px">\${d.ordNo}</td>
      <td style="font-weight:600;color:var(--gray1)">\${d.name}</td>
      <td><span class="bdg bdg-gray" style="font-family:'DM Mono',monospace;font-size:10px">\${d.size}</span></td>
      <td style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</td>
      <td>\${stockBdg[d.stock]||''}</td>
      <td><span class="bdg bdg-green">처리 완료</span></td>
      <td>\${d.manager}</td>
    </tr>
  `).join('');
}

// ── 검수 처리 모달 (반품) ─────────────────────────
let currentNo = null;
function openInspect(no) {
  const d = waitData.find(x=>x.no===no);
  if(!d||d.type!=='반품') return;
  currentNo = no;
  document.getElementById('inspectBody').innerHTML = `
    <div class="alert alert-blue" style="margin-bottom:18px">
      <span class="alert-ico">🔍</span>
      <div>반품 상품을 검수한 후 양품 또는 불량 여부를 선택하세요. 결과에 따라 재고 처리가 달라집니다.</div>
    </div>
    <div style="margin-bottom:18px">
      <div class="sec-ttl">반품 정보</div>
      <div class="dr"><div class="dk">주문번호</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700;color:var(--blue)">\${d.ordNo}</div></div>
      <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
      <div class="dr"><div class="dk">사이즈/컬러</div><div class="dv">\${d.size} / \${d.color}</div></div>
      <div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</div></div>
      <div class="dr"><div class="dk">반품 사유</div><div class="dv">\${d.reason}</div></div>
      <div class="dr"><div class="dk">승인자</div><div class="dv">\${d.approvedBy}</div></div>
      <div class="dr"><div class="dk">승인일시</div><div class="dv" style="font-size:12px;color:var(--gray3)">\${d.approvedAt}</div></div>
    </div>
    <div class="sec-ttl">검수 결과 선택</div>
    <div class="action-box action-box-good">
      <div class="action-box-title" style="color:#065F46">✅ 양품 — 재고 복구</div>
      <div class="action-box-desc">상품 상태가 정상(미사용·미착용)인 경우 선택합니다.<br>선택 시 해당 옵션 재고가 <strong>+\${d.qty}개</strong> 자동 증가합니다.</div>
    </div>
    <div class="action-box action-box-bad" style="margin-top:8px">
      <div class="action-box-title" style="color:#991B1B">❌ 불량 — 재고 폐기</div>
      <div class="action-box-desc">상품이 훼손·착용·불량인 경우 선택합니다.<br>선택 시 재고 복구 없이 폐기 이력만 기록됩니다.</div>
    </div>
  `;
  document.getElementById('inspectFoot').innerHTML = `
    <button class="btn btn-outline" onclick="closeInspect()">취소</button>
    <button class="btn btn-red btn-sm" onclick="processReturn(\${no},'bad')">❌ 불량 폐기</button>
    <button class="btn btn-green btn-sm" onclick="processReturn(\${no},'good')">✅ 양품 복구</button>
  `;
  document.getElementById('inspectModal').classList.add('open');
}
function closeInspect(){ document.getElementById('inspectModal').classList.remove('open') }

function processReturn(no, result) {
  const d = waitData.find(x=>x.no===no);
  if(!d) return;
  d.stockStatus = result==='good' ? '양품 복구' : '불량 폐기';
  closeInspect();
  renderWait();
  showToast(result==='good'
    ? `✅ \${d.name} 양품 복구 완료 (+\${d.qty}개 재고 반영)`
    : `🗑 \${d.name} 불량 폐기 처리 완료`);
}

// ── 교환 출고 모달 ────────────────────────────────
function openExchange(no) {
  const d = waitData.find(x=>x.no===no);
  if(!d||d.type!=='교환') return;
  currentNo = no;
  document.getElementById('exchangeBody').innerHTML = `
    <div class="alert alert-amber" style="margin-bottom:18px">
      <span class="alert-ico">🔄</span>
      <div>교환 신청 상품의 반품 재고를 검수 후, 새 옵션으로 출고 처리합니다.</div>
    </div>
    <div style="margin-bottom:18px">
      <div class="sec-ttl">교환 정보</div>
      <div class="dr"><div class="dk">주문번호</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700;color:var(--blue)">\${d.ordNo}</div></div>
      <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
      <div class="dr"><div class="dk">교환 옵션</div><div class="dv">
        <div style="display:flex;align-items:center;gap:8px">
          <span style="font-size:12px;color:var(--gray3);text-decoration:line-through">\${d.size.split('→')[0]}mm / \${d.color}</span>
          <span style="color:var(--gray4)">→</span>
          <span style="font-weight:700;color:var(--blue)">\${d.size.includes('→')?d.size.split('→')[1]+'mm':d.size} / \${d.color}</span>
        </div>
      </div></div>
      <div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</div></div>
      <div class="dr"><div class="dk">교환 사유</div><div class="dv">\${d.reason}</div></div>
      <div class="dr"><div class="dk">승인자</div><div class="dv">\${d.approvedBy}</div></div>
    </div>
    <div style="margin-bottom:14px">
      <div class="sec-ttl">출고 송장 정보</div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div style="display:flex;flex-direction:column;gap:5px">
          <label style="font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em">택배사</label>
          <select style="padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:13px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none">
            <option>택배사 선택</option><option>CJ대한통운</option><option>롯데택배</option><option>한진택배</option><option>우체국택배</option>
          </select>
        </div>
        <div style="display:flex;flex-direction:column;gap:5px">
          <label style="font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em">송장번호</label>
          <input placeholder="숫자 12자리" style="padding:9px 12px;border:1.5px solid var(--gray5);border-radius:7px;font-size:13px;font-family:'DM Mono',monospace;color:var(--gray1);outline:none">
        </div>
      </div>
    </div>
    <div class="inspect-card">
      <div class="inspect-hdr">처리 시 재고 변동</div>
      <div class="inspect-body">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
          <span style="font-size:12px;color:var(--gray3)">반품 옵션 (\${d.size.split('→')[0]}mm) 재고</span>
          <span style="font-family:'DM Mono',monospace;font-weight:700;color:var(--green)">+\${d.qty}개 복구 or 폐기</span>
        </div>
        <div style="display:flex;justify-content:space-between;align-items:center">
          <span style="font-size:12px;color:var(--gray3)">교환 옵션 (\${d.size.includes('→')?d.size.split('→')[1]+'mm':d.size}) 재고</span>
          <span style="font-family:'DM Mono',monospace;font-weight:700;color:var(--red)">-\${d.qty}개 차감</span>
        </div>
      </div>
    </div>
  `;
  document.getElementById('exchangeFoot').innerHTML = `
    <button class="btn btn-outline" onclick="closeExchange()">취소</button>
    <button class="btn btn-amber btn-sm" onclick="processExchange(\${no})">🔄 교환 출고 확정</button>
  `;
  document.getElementById('exchangeModal').classList.add('open');
}
function closeExchange(){ document.getElementById('exchangeModal').classList.remove('open') }

function processExchange(no) {
  const d = waitData.find(x=>x.no===no);
  if(!d) return;
  d.stockStatus = '교환 출고';
  closeExchange();
  renderWait();
  showToast(`🔄 \${d.name} 교환 출고 처리 완료`);
}

// ── 이력 상세 ─────────────────────────────────────
function openHistDetail(no) {
  const d = histData.find(x=>x.no===no);
  if(!d) return;
  document.getElementById('histDetailBody').innerHTML = `
    <div class="alert alert-green" style="margin-bottom:18px">
      <span class="alert-ico">✅</span>
      <strong>처리 완료</strong> — \${d.no}
    </div>
    <div class="sec-ttl">처리 정보</div>
    <div class="dr"><div class="dk">처리 번호</div><div class="dv" style="font-family:'DM Mono',monospace;color:var(--blue)">\${d.no}</div></div>
    <div class="dr"><div class="dk">유형</div><div class="dv"><span class="type-chip \${d.type==='반품'?'type-ret':'type-exc'}">\${d.type==='반품'?'↩':'🔄'} \${d.type}</span></div></div>
    <div class="dr"><div class="dk">처리일</div><div class="dv">\${d.date}</div></div>
    <div class="dr"><div class="dk">주문번호</div><div class="dv" style="font-family:'DM Mono',monospace">\${d.ordNo}</div></div>
    <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">\${d.name}</div></div>
    <div class="dr"><div class="dk">사이즈/컬러</div><div class="dv">\${d.size} / \${d.color}</div></div>
    <div class="dr"><div class="dk">처리 수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700">\${d.qty}개</div></div>
    <div class="dr"><div class="dk">재고 처리</div><div class="dv">\${stockBdg[d.stock]||d.stock}</div></div>
    <div class="dr"><div class="dk">담당자</div><div class="dv">\${d.manager}</div></div>
    <div class="dr"><div class="dk">상태</div><div class="dv"><span class="bdg bdg-green">처리 완료</span></div></div>
  `;
  document.getElementById('histDetailModal').classList.add('open');
}

// ── 탭 전환 ──────────────────────────────────────
function switchTab(tab) {
  const isWait = tab==='wait';
  document.getElementById('sec-wait').style.display = isWait?'':'none';
  document.getElementById('sec-hist').style.display = isWait?'none':'';
  document.getElementById('tab-wait-btn').classList.toggle('on', isWait);
  document.getElementById('tab-hist-btn').classList.toggle('on', !isWait);
  if(!isWait) renderHist(histData);
}

function setInnerTab(el, id) {
  el.closest('.inner-tabs').querySelectorAll('.inner-tab').forEach(t=>t.classList.remove('on'));
  el.classList.add('on');
  if(id==='t-all') renderHist(histData);
  else if(id==='t-ret') renderHist(histData.filter(d=>d.type==='반품'));
  else renderHist(histData.filter(d=>d.type==='교환'));
}

// ── 모달 바깥 클릭 ────────────────────────────────
['inspectModal','exchangeModal','histDetailModal'].forEach(id=>{
  document.getElementById(id).addEventListener('click',e=>{
    if(e.target===e.currentTarget) e.currentTarget.classList.remove('open');
  });
});

// ── TOAST ─────────────────────────────────────────
function showToast(msg, warn=false) {
  const t=document.getElementById('toast');
  t.textContent=msg;
  t.style.background=warn?'var(--amber)':'var(--gray1)';
  t.classList.add('show');
  setTimeout(()=>t.classList.remove('show'),2800);
}

// ── 초기 렌더 ────────────────────────────────────
renderWait();
renderHist(histData);
</script>
</body>
</html>