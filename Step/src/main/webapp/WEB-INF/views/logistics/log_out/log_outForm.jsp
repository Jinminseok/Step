<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출고 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* ══ MAIN ══ */
.main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}
.breadcrumb{display:flex;align-items:center;gap:6px;font-size:13px}
.breadcrumb-root{color:var(--gray4);font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.06em}
.breadcrumb-sep{color:var(--gray5);font-size:12px}
.breadcrumb-cur{font-size:14px;font-weight:700;color:var(--gray1)}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.tb-btn{
  width:34px;height:34px;border:1px solid var(--gray6);
  background:var(--bg2);border-radius:7px;
  display:flex;align-items:center;justify-content:center;
  cursor:pointer;font-size:14px;
  transition:all .15s;position:relative;
}
.tb-btn:hover{background:var(--gray6);border-color:var(--gray5)}
.notif-dot{
  position:absolute;top:6px;right:6px;
  width:6px;height:6px;border-radius:50%;
  background:var(--red);border:1.5px solid var(--white);
}
.tb-date{font-size:12px;color:var(--gray3);font-family:'DM Mono',monospace;padding:6px 12px;background:var(--bg2);border:1px solid var(--gray6);border-radius:7px}
.content{flex:1;overflow-y:auto;padding:22px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ══ TAB BAR ══ */
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab-btn{padding:10px 24px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{background:var(--amber);color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}
.tab-cnt-gray{background:var(--gray3)}

/* ══ ALERT ══ */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-green{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.alert-blue{background:var(--blue-lt);border-color:#93C5FD;color:#1E3A8A}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}

/* ══ KPI ROW ══ */
.kpi-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px}
.kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:16px 18px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden}
.kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.kpi.amber::before{background:var(--amber)}
.kpi.green::before{background:var(--green)}
.kpi.blue::before{background:var(--blue)}
.kpi.gray::before{background:var(--gray4)}
.kpi-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px}
.kpi-val{font-family:'DM Mono',monospace;font-size:26px;font-weight:700;margin-bottom:4px}
.kpi-val.c-amber{color:var(--amber)}.kpi-val.c-green{color:var(--green)}.kpi-val.c-blue{color:var(--blue)}.kpi-val.c-gray{color:var(--gray3)}
.kpi-sub{font-size:11px;color:var(--gray4)}

/* ══ TOOLBAR ══ */
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;min-width:200px;max-width:280px}
.search-wrap input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}

/* CUSTOM SELECT */
.sel-wrap{position:relative}
.sel-btn{
  display:flex;align-items:center;gap:6px;padding:9px 12px;
  border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;
  font-size:12.5px;color:var(--gray2);cursor:pointer;font-family:'Pretendard',sans-serif;
  font-weight:500;transition:all .15s;white-space:nowrap;user-select:none;min-width:120px;
  justify-content:space-between;
}
.sel-btn:hover{border-color:var(--gray3)}
.sel-btn.open{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.sel-drop{
  position:absolute;top:calc(100% + 6px);left:0;min-width:150px;
  background:var(--white);border:1.5px solid var(--gray5);border-radius:8px;
  box-shadow:0 4px 20px rgba(15,32,68,.12);z-index:100;overflow:hidden;
  display:none;
}
.sel-drop.open{display:block}
.sel-opt{
  padding:10px 14px;font-size:12.5px;color:var(--gray2);cursor:pointer;
  font-family:'Pretendard',sans-serif;font-weight:500;transition:background .12s;
  display:flex;align-items:center;gap:8px;
}
.sel-opt:hover{background:var(--blue-lt);color:var(--blue)}
.sel-opt.selected{background:var(--blue-lt);color:var(--blue);font-weight:700}
.sel-opt::before{content:'';width:8px;height:8px;border-radius:50%;flex-shrink:0}
.sel-opt.opt-all::before{background:var(--gray3)}
.sel-opt.opt-wait::before{background:var(--amber)}
.sel-opt.opt-done::before{background:var(--green)}
.sel-opt.opt-cancel::before{background:var(--red)}
.sel-arrow{font-size:10px;color:var(--gray4);transition:transform .15s}
.sel-btn.open .sel-arrow{transform:rotate(180deg)}

/* ══ BUTTONS ══ */
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

/* ══ TABLE ══ */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:10px;flex-wrap:wrap}
.tbl-top-info{font-size:12px;color:var(--gray3)}
.tbl-top-info strong{color:var(--gray1)}
.sel-summary{
  display:flex;align-items:center;gap:8px;
  padding:6px 12px;background:var(--blue-lt);border:1.5px solid var(--blue);
  border-radius:6px;font-size:12px;color:var(--blue);font-weight:700;
  transition:all .2s;
}
.tbl-actions{display:flex;gap:6px;margin-left:auto}
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

/* BADGE */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-purple{background:var(--purple-lt);color:var(--purple)}

/* STEP FLOW */
.flow{display:flex;align-items:center;gap:0;margin-bottom:20px}
.flow-step{
  display:flex;align-items:center;gap:6px;
  padding:8px 14px;font-size:12px;font-weight:600;
  background:var(--gray7);border:1px solid var(--gray6);
  color:var(--gray3);position:relative;
  clip-path:polygon(0 0,calc(100% - 10px) 0,100% 50%,calc(100% - 10px) 100%,0 100%,10px 50%);
  padding-left:20px;
}
.flow-step:first-child{clip-path:polygon(0 0,calc(100% - 10px) 0,100% 50%,calc(100% - 10px) 100%,0 100%);padding-left:14px;border-radius:5px 0 0 5px}
.flow-step:last-child{clip-path:polygon(0 0,100% 0,100% 100%,0 100%,10px 50%);border-radius:0 5px 5px 0}
.flow-step.done{background:var(--blue-lt);border-color:#93C5FD;color:var(--blue)}
.flow-step.active{background:var(--blue);border-color:var(--blue);color:#fff}
.flow-step-num{width:18px;height:18px;border-radius:50%;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:9px;font-weight:800;flex-shrink:0}
.flow-step.done .flow-step-num{background:var(--blue);color:#fff}
.flow-step.active .flow-step-num{background:rgba(255,255,255,.3)}

/* PAGINATION */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* MODAL */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:560px;max-height:88vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* CONFIRM MODAL */
.confirm-modal{width:420px}
.confirm-icon{width:56px;height:56px;border-radius:50%;background:var(--amber-lt);border:2px solid var(--amber-lt);display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 16px}
.confirm-title{font-size:17px;font-weight:800;color:var(--gray1);text-align:center;margin-bottom:8px}
.confirm-desc{font-size:13px;color:var(--gray3);text-align:center;line-height:1.7;margin-bottom:20px}
.confirm-items{background:var(--bg2);border:1px solid var(--gray6);border-radius:8px;overflow:hidden;margin-bottom:4px}
.ci-row{display:flex;justify-content:space-between;align-items:center;padding:9px 14px;border-bottom:1px solid var(--gray6);font-size:12.5px}
.ci-row:last-child{border-bottom:none}
.ci-key{color:var(--gray3);font-weight:500}
.ci-val{color:var(--gray1);font-weight:700}

/* DETAIL ROWS */
.dr{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7)}
.dr:last-child{border-bottom:none}
.dk{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:110px;flex-shrink:0;padding-top:1px}
.dv{font-size:13px;color:var(--gray1);flex:1}

/* PROGRESS STEP in MODAL */
.order-flow{display:flex;align-items:center;margin:16px 0;gap:0}
.of-step{flex:1;text-align:center;position:relative}
.of-step::after{content:'';position:absolute;top:13px;left:50%;width:100%;height:2px;background:var(--gray5);z-index:0}
.of-step:last-child::after{display:none}
.of-dot{
  width:26px;height:26px;border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:11px;font-weight:800;margin:0 auto 4px;
  position:relative;z-index:1;border:2px solid var(--gray5);background:var(--white);color:var(--gray4);
}
.of-step.done .of-dot{background:var(--blue);border-color:var(--blue);color:#fff}
.of-step.done::after{background:var(--blue)}
.of-step.active .of-dot{background:var(--amber);border-color:var(--amber);color:#fff}
.of-lbl{font-size:10px;color:var(--gray4);font-weight:600;letter-spacing:.03em}
.of-step.done .of-lbl,.of-step.active .of-lbl{color:var(--gray2)}

/* TOAST */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* INVOICE INPUT */
.inv-input{padding:7px 10px;border:1.5px solid var(--gray5);border-radius:6px;font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray1);outline:none;width:130px;transition:border .15s}
.inv-input:focus{border-color:var(--blue)}
.inv-input::placeholder{color:var(--gray4);font-size:11px}

/* SECTION TITLE */
.sec-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;display:flex;align-items:center;gap:6px}
.sec-title::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}


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
      <span class="breadcrumb-cur" id="pg-title">출고 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->      
    </div>
  </div>
    <div class="content">
  <!-- TAB BAR -->
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-out-btn" onclick="switchTab('out')">
        📤 출고 처리 <span class="tab-cnt" id="waitCnt">5</span>
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchTab('hist')">
        📋 출고 이력 조회 <span class="tab-cnt tab-cnt-gray">84</span>
      </div>
    </div>

    <!-- ════════ 출고 처리 탭 ════════ -->
    <div id="sec-out">

      <!-- 알림 -->
      <div class="alert alert-amber" id="waitAlert">
        <span class="alert-ico">⚠</span>
        <div>출고 대기 주문이 <strong id="waitNum">5</strong>건 있습니다. 출고 처리 시 주문 상태가 <strong>'배송 중'</strong>으로 변경되며 재고가 자동 차감됩니다.</div>
      </div>

      <!-- KPI -->
      <div class="kpi-row">
        <div class="kpi amber">
          <div class="kpi-label">출고 대기</div>
          <div class="kpi-val c-amber" id="kpiWait">5</div>
          <div class="kpi-sub">즉시 처리 필요</div>
        </div>
        <div class="kpi green">
          <div class="kpi-label">오늘 출고 완료</div>
          <div class="kpi-val c-green">84</div>
          <div class="kpi-sub">↑ 11건 전일 대비</div>
        </div>
        <div class="kpi blue">
          <div class="kpi-label">배송 중</div>
          <div class="kpi-val c-blue">31</div>
          <div class="kpi-sub">진행 중인 배송</div>
        </div>
        <div class="kpi gray">
          <div class="kpi-label">배송 완료</div>
          <div class="kpi-val c-gray">53</div>
          <div class="kpi-sub">오늘 기준</div>
        </div>
      </div>

      <!-- 배송 프로세스 -->
      <div class="flow" style="margin-bottom:18px">
        <div class="flow-step done"><div class="flow-step-num">✓</div>결제 완료</div>
        <div class="flow-step active"><div class="flow-step-num">2</div>출고 대기</div>
        <div class="flow-step"><div class="flow-step-num">3</div>출고 완료</div>
        <div class="flow-step"><div class="flow-step-num">4</div>배송 중</div>
        <div class="flow-step"><div class="flow-step-num">5</div>배송 완료</div>
      </div>

      <!-- TOOLBAR -->
      <div class="toolbar">
        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" placeholder="주문번호·상품명 검색" oninput="filterOrders(this.value)">
        </div>

        <!-- 커스텀 셀렉트 -->
        <div class="sel-wrap">
          <div class="sel-btn" id="statusSelBtn" onclick="toggleSel()">
            <span id="selLabel">전체 상태</span>
            <span class="sel-arrow">▼</span>
          </div>
          <div class="sel-drop" id="statusDrop">
            <div class="sel-opt opt-all selected" onclick="setStatus('전체 상태',this)">전체 상태</div>
            <div class="sel-opt opt-wait" onclick="setStatus('출고 대기',this)">출고 대기</div>
            <div class="sel-opt opt-done" onclick="setStatus('출고 완료',this)">출고 완료</div>
            <div class="sel-opt opt-cancel" onclick="setStatus('취소',this)">취소</div>
          </div>
        </div>

        <div style="margin-left:auto;display:flex;gap:8px">
          <button class="btn btn-ghost btn-sm">📥 엑셀 다운로드</button>
          <button class="btn btn-blue" id="bulkBtn" onclick="openBulkConfirm()" disabled>
            선택 항목 일괄 출고 <span id="bulkCnt"></span>
          </button>
        </div>
      </div>

      <!-- TABLE -->
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong id="totalCnt">5</strong>건 · 선택 <strong id="selCnt">0</strong>건</div>
          <div class="sel-summary" id="selSummary" style="opacity:0;pointer-events:none">
            <span>📦</span><span id="selSummaryTxt">0건 선택됨</span>
          </div>
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
                <th>송장번호</th>
                <th>상태</th>
                <th>처리</th>
              </tr>
            </thead>
            <tbody id="orderTbody"></tbody>
          </table>
        </div>
        <div class="pagination-wrap">
          <div class="page-info" id="pageInfo">1 – 5 / 5건</div>
          <div class="page-btns">
            <div class="pg-btn">‹</div>
            <div class="pg-btn on">1</div>
            <div class="pg-btn">›</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ════════ 출고 이력 탭 ════════ -->
    <div id="sec-hist" style="display:none">
      <div style="display:flex;align-items:center;gap:8px;padding:14px 18px;background:var(--white);border:1px solid var(--gray6);border-radius:10px;margin-bottom:14px;flex-wrap:wrap;box-shadow:0 1px 3px rgba(15,32,68,.05)">
        <span style="font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.05em">기간</span>
        <input type="date" value="2025-04-01" style="padding:7px 10px;border:1.5px solid var(--gray5);border-radius:6px;font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none">
        <span style="font-size:12px;color:var(--gray4)">~</span>
        <input type="date" value="2025-04-24" style="padding:7px 10px;border:1.5px solid var(--gray5);border-radius:6px;font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none">
        <select style="padding:7px 10px;border:1.5px solid var(--gray5);background:var(--white);font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:6px;cursor:pointer">
          <option>전체 상태</option><option>출고 완료</option><option>배송 중</option><option>배송 완료</option><option>취소</option>
        </select>
        <div class="search-wrap" style="max-width:220px">
          <span class="search-ico">🔍</span>
          <input type="text" placeholder="주문번호·상품명 검색">
        </div>
        <button class="btn btn-blue btn-sm">조회</button>
        <button class="btn btn-ghost btn-sm">초기화</button>
        <div style="margin-left:auto"><button class="btn btn-ghost btn-sm">📥 엑셀</button></div>
      </div>

      <!-- 요약 pills -->
      <div style="display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap">
        <div style="display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid #93C5FD;background:var(--blue-lt);font-size:12px;font-weight:600;color:var(--blue)"><span style="font-family:'DM Mono',monospace;font-size:16px;font-weight:700">84</span>오늘 출고</div>
        <div style="display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid #6EE7B7;background:var(--green-lt);font-size:12px;font-weight:600;color:#065F46"><span style="font-family:'DM Mono',monospace;font-size:16px;font-weight:700">53</span>배송 완료</div>
        <div style="display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid #FCD34D;background:var(--amber-lt);font-size:12px;font-weight:600;color:#92400E"><span style="font-family:'DM Mono',monospace;font-size:16px;font-weight:700">31</span>배송 중</div>
        <div style="display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid #FECACA;background:var(--red-lt);font-size:12px;font-weight:600;color:#991B1B"><span style="font-family:'DM Mono',monospace;font-size:16px;font-weight:700">3</span>취소</div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong>84</strong>건 · 페이지 <strong>1 / 17</strong></div>
          <div style="display:flex;gap:6px"><button class="btn btn-xs btn-ghost">선택 엑셀</button></div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:36px"><input type="checkbox"></th>
                <th>출고 번호</th><th>주문번호</th><th>출고일시</th><th>상품명</th>
                <th>사이즈/컬러</th><th>수량</th><th>택배사</th><th>송장번호</th><th>상태</th><th>담당자</th>
              </tr>
            </thead>
            <tbody>
              <tr class="tbl-row" onclick="openHistDetail()"><td><input type="checkbox"></td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue)">OUT-20250424-084</td><td style="font-family:'DM Mono',monospace;font-size:11px">#0082</td><td style="font-size:11px;color:var(--gray3)">09:30</td><td style="font-weight:600">나이키 에어맥스 270</td><td><span class="bdg bdg-gray" style="font-size:10px">265mm / 그레이</span></td><td style="font-family:'DM Mono',monospace;font-weight:700">1</td><td>CJ대한통운</td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">591234567890</td><td><span class="bdg bdg-green">배송 완료</span></td><td>이지훈</td></tr>
              <tr class="tbl-row" onclick="openHistDetail()"><td><input type="checkbox"></td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue)">OUT-20250424-083</td><td style="font-family:'DM Mono',monospace;font-size:11px">#0081</td><td style="font-size:11px;color:var(--gray3)">09:15</td><td style="font-weight:600">아디다스 삼바 OG</td><td><span class="bdg bdg-gray" style="font-size:10px">270mm / 블랙</span></td><td style="font-family:'DM Mono',monospace;font-weight:700">1</td><td>롯데택배</td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">441234567890</td><td><span class="bdg bdg-amber">배송 중</span></td><td>이지훈</td></tr>
              <tr class="tbl-row" onclick="openHistDetail()"><td><input type="checkbox"></td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue)">OUT-20250424-082</td><td style="font-family:'DM Mono',monospace;font-size:11px">#0079</td><td style="font-size:11px;color:var(--gray3)">08:55</td><td style="font-weight:600">뉴발란스 990v5</td><td><span class="bdg bdg-gray" style="font-size:10px">255mm / 네이비</span></td><td style="font-family:'DM Mono',monospace;font-weight:700">2</td><td>한진택배</td><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">333987654321</td><td><span class="bdg bdg-green">배송 완료</span></td><td>박수진</td></tr>
            </tbody>
          </table>
        </div>
        <div class="pagination-wrap">
          <div class="page-info">1 – 5 / 84건</div>
          <div class="page-btns">
            <div class="pg-btn">‹</div>
            <div class="pg-btn on">1</div><div class="pg-btn">2</div><div class="pg-btn">3</div><div class="pg-btn">…</div><div class="pg-btn">17</div>
            <div class="pg-btn">›</div>
          </div>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- ══ 개별 출고 처리 모달 ══ -->
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

<!-- ══ 일괄 출고 확인 모달 ══ -->
<div class="modal-bg" id="bulkModal">
  <div class="modal confirm-modal" style="width:420px">
    <div class="modal-hdr">
      <div class="modal-title">📦 일괄 출고 처리</div>
      <button class="modal-x" onclick="closeBulk()">✕</button>
    </div>
    <div class="modal-body">
      <div class="confirm-icon">📦</div>
      <div class="confirm-title">선택 주문 일괄 출고</div>
      <div class="confirm-desc" id="bulkDesc"></div>
      <div class="confirm-items" id="bulkItems"></div>
      <div class="alert alert-amber" style="margin-top:14px;margin-bottom:0">
        <span class="alert-ico">⚠</span>
        출고 처리 시 재고가 즉시 차감되며 주문 상태가 <strong>'배송 중'</strong>으로 변경됩니다.
      </div>
    </div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="closeBulk()">취소</button>
      <button class="btn btn-green" onclick="doBulk()">✅ 일괄 출고 확정</button>
    </div>
  </div>
</div>

<!-- ══ 출고 이력 상세 모달 ══ -->
<div class="modal-bg" id="histModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title">📋 출고 상세 정보</div>
      <button class="modal-x" onclick="document.getElementById('histModal').classList.remove('open')">✕</button>
    </div>
    <div class="modal-body">
      <div class="order-flow">
        <div class="of-step done"><div class="of-dot">✓</div><div class="of-lbl">결제완료</div></div>
        <div class="of-step done"><div class="of-dot">✓</div><div class="of-lbl">출고완료</div></div>
        <div class="of-step active"><div class="of-dot">●</div><div class="of-lbl">배송 중</div></div>
        <div class="of-step"><div class="of-dot">4</div><div class="of-lbl">배송완료</div></div>
      </div>
      <div style="margin-bottom:16px">
        <div class="sec-title">출고 정보</div>
        <div class="dr"><div class="dk">출고 번호</div><div class="dv" style="font-family:'DM Mono',monospace;color:var(--blue)">OUT-20250424-084</div></div>
        <div class="dr"><div class="dk">주문 번호</div><div class="dv" style="font-family:'DM Mono',monospace">#20250421-0082</div></div>
        <div class="dr"><div class="dk">출고 일시</div><div class="dv">2025-04-24 09:30</div></div>
        <div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">나이키 에어맥스 270</div></div>
        <div class="dr"><div class="dk">사이즈/컬러</div><div class="dv">265mm / 그레이</div></div>
        <div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:700;font-size:15px">1 <span style="font-size:11px;font-weight:400;color:var(--gray3)">개</span></div></div>
        <div class="dr"><div class="dk">담당자</div><div class="dv">이지훈</div></div>
      </div>
      <div>
        <div class="sec-title">배송 정보</div>
        <div class="dr"><div class="dk">수령인</div><div class="dv">김민준</div></div>
        <div class="dr"><div class="dk">배송지</div><div class="dv">서울특별시 강남구 테헤란로 123 (역삼동)</div></div>
        <div class="dr"><div class="dk">연락처</div><div class="dv">010-1234-5678</div></div>
        <div class="dr"><div class="dk">택배사</div><div class="dv">CJ대한통운</div></div>
        <div class="dr"><div class="dk">송장번호</div><div class="dv" style="font-family:'DM Mono',monospace;font-weight:600;color:var(--blue)">591234567890</div></div>
        <div class="dr"><div class="dk">배송 상태</div><div class="dv"><span class="bdg bdg-green">배송 완료</span></div></div>
      </div>
    </div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="document.getElementById('histModal').classList.remove('open')">닫기</button>
      <button class="btn btn-blue btn-sm">송장 수정</button>
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

//── 주문 데이터 ────────────────────────────────────
const orders = [
  {id:'#20250421-0082', time:'09:30', name:'나이키 에어맥스 270',   size:'265mm', color:'그레이', qty:1, addr:'서울 강남구',   status:'출고 대기', recv:'김민준', phone:'010-1234-5678', fullAddr:'서울 강남구 테헤란로 123'},
  {id:'#20250421-0081', time:'09:15', name:'아디다스 울트라부스트', size:'270mm', color:'블랙',   qty:1, addr:'경기 수원시',   status:'출고 대기', recv:'이수진', phone:'010-2345-6789', fullAddr:'경기 수원시 영통구 매탄로 45'},
  {id:'#20250421-0079', time:'08:55', name:'나이키 조던 1 레트로',  size:'260mm', color:'레드',   qty:2, addr:'부산 해운대구', status:'출고 대기', recv:'박지호', phone:'010-3456-7890', fullAddr:'부산 해운대구 해운대로 789'},
  {id:'#20250421-0077', time:'08:40', name:'뉴발란스 990v5',        size:'270mm', color:'네이비', qty:1, addr:'서울 마포구',   status:'출고 대기', recv:'최예린', phone:'010-4567-8901', fullAddr:'서울 마포구 홍대입구로 22'},
  {id:'#20250421-0075', time:'08:20', name:'호카 클리프턴 9',       size:'255mm', color:'화이트', qty:1, addr:'대구 수성구',   status:'출고 대기', recv:'정민호', phone:'010-5678-9012', fullAddr:'대구 수성구 수성로 100'},
];
 
let currentOrders = [...orders];
let currentSingleId = null;
const couriers = ['CJ대한통운','롯데택배','한진택배','우체국택배'];
 
const statusBdg = {
  '출고 대기': '<span class="bdg bdg-amber">출고 대기</span>',
  '출고 완료': '<span class="bdg bdg-green">출고 완료</span>',
  '취소':      '<span class="bdg bdg-red">취소</span>',
};
 
// ── 주문 목록 렌더 ──────────────────────────────────
function renderOrders(data) {
  const tbody = document.getElementById('orderTbody');
  if(!data.length) {
    tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;padding:40px;color:var(--gray4);font-size:13px">📭 해당 조건의 주문이 없습니다</td></tr>';
    return;
  }
  tbody.innerHTML = data.map(function(o) {
    const invId = 'inv-' + o.id.replace(/#/g,'').replace(/-/g,'');
    const actionBtn = o.status === '출고 대기'
      ? '<button class="btn btn-blue btn-xs" onclick="openSingle(\'' + o.id + '\')">출고 처리</button>'
      : '<button class="btn btn-ghost btn-xs">상세 보기</button>';
    return '<tr class="tbl-row" data-id="' + o.id + '" onclick="rowClick(this)">'
      + '<td onclick="event.stopPropagation()">'
      +   '<input type="checkbox" class="row-chk" data-id="' + o.id + '" onchange="updateSel()">'
      + '</td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11.5px;font-weight:700;color:var(--blue)">' + o.id + '</td>'
      + '<td style="font-size:11px;color:var(--gray3)">' + o.time + '</td>'
      + '<td style="font-weight:600;color:var(--gray1)">' + o.name + '</td>'
      + '<td><span class="bdg bdg-gray" style="font-family:\'DM Mono\',monospace;font-size:10px">' + o.size + '</span> <span style="font-size:11px;color:var(--gray4)">' + o.color + '</span></td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-weight:700;font-size:13px">' + o.qty + '</td>'
      + '<td style="font-size:12px">' + o.addr + '</td>'
      + '<td><input class="inv-input" placeholder="송장번호 입력" onclick="event.stopPropagation()" id="' + invId + '"></td>'
      + '<td>' + (statusBdg[o.status]||'') + '</td>'
      + '<td onclick="event.stopPropagation()">' + actionBtn + '</td>'
      + '</tr>';
  }).join('');
  document.getElementById('totalCnt').textContent = data.length;
  document.getElementById('pageInfo').textContent = '1 – ' + data.length + ' / ' + data.length + '건';
}
 
function rowClick(tr) {
  const chk = tr.querySelector('.row-chk');
  chk.checked = !chk.checked;
  updateSel();
}
 
function toggleAll(cb) {
  document.querySelectorAll('.row-chk').forEach(function(c) {
    c.checked = cb.checked;
    c.closest('tr').classList.toggle('checked', cb.checked);
  });
  updateSel();
}
 
function updateSel() {
  const checked = document.querySelectorAll('.row-chk:checked');
  const n = checked.length;
  document.getElementById('selCnt').textContent = n;
 
  document.querySelectorAll('.row-chk').forEach(function(c) {
    c.closest('tr').classList.toggle('checked', c.checked);
  });
 
  const summary = document.getElementById('selSummary');
  summary.style.opacity = n > 0 ? '1' : '0';
  summary.style.pointerEvents = n > 0 ? 'auto' : 'none';
  document.getElementById('selSummaryTxt').textContent = n + '건 선택됨';
 
  const btn = document.getElementById('bulkBtn');
  btn.disabled = n === 0;
  document.getElementById('bulkCnt').textContent = n > 0 ? '(' + n + '건)' : '';
 
  const all = document.querySelectorAll('.row-chk').length;
  document.getElementById('chkAll').indeterminate = n > 0 && n < all;
  document.getElementById('chkAll').checked = n === all && all > 0;
}
 
function filterOrders(q) {
  const filtered = orders.filter(function(o) {
    return o.id.toLowerCase().includes(q.toLowerCase())
        || o.name.toLowerCase().includes(q.toLowerCase());
  });
  renderOrders(filtered);
}
 
// ── 커스텀 셀렉트 ──────────────────────────────────
function toggleSel() {
  document.getElementById('statusSelBtn').classList.toggle('open');
  document.getElementById('statusDrop').classList.toggle('open');
}
function setStatus(val, el) {
  document.getElementById('selLabel').textContent = val;
  document.querySelectorAll('.sel-opt').forEach(function(o){ o.classList.remove('selected'); });
  el.classList.add('selected');
  toggleSel();
  if(val === '전체 상태') renderOrders(orders);
  else renderOrders(orders.filter(function(o){ return o.status === val; }));
}
document.addEventListener('click', function(e) {
  const wrap = document.querySelector('.sel-wrap');
  if(!wrap.contains(e.target)) {
    document.getElementById('statusSelBtn').classList.remove('open');
    document.getElementById('statusDrop').classList.remove('open');
  }
});
 
// ── 개별 출고 처리 ─────────────────────────────────
function openSingle(id) {
  const o = orders.find(function(x){ return x.id === id; });
  if(!o) return;
  currentSingleId = id;
  const invId = 'inv-' + id.replace(/#/g,'').replace(/-/g,'');
  const invEl = document.getElementById(invId);
  const existInv = invEl ? invEl.value : '';
  const courierOptions = couriers.map(function(c){ return '<option>' + c + '</option>'; }).join('');
 
  document.getElementById('singleBody').innerHTML =
      '<div class="alert alert-blue" style="margin-bottom:18px">'
    +   '<span class="alert-ico">📋</span>'
    +   '<div>아래 주문을 출고 처리합니다. 송장번호를 입력하면 배송 추적이 활성화됩니다.</div>'
    + '</div>'
    + '<div style="margin-bottom:18px">'
    +   '<div class="sec-title">주문 정보</div>'
    +   '<div class="dr"><div class="dk">주문번호</div><div class="dv" style="font-family:\'DM Mono\',monospace;font-weight:700;color:var(--blue)">' + o.id + '</div></div>'
    +   '<div class="dr"><div class="dk">상품명</div><div class="dv" style="font-weight:600">' + o.name + '</div></div>'
    +   '<div class="dr"><div class="dk">사이즈/컬러</div><div class="dv">' + o.size + ' / ' + o.color + '</div></div>'
    +   '<div class="dr"><div class="dk">수량</div><div class="dv" style="font-family:\'DM Mono\',monospace;font-weight:700">' + o.qty + '개</div></div>'
    + '</div>'
    + '<div style="margin-bottom:18px">'
    +   '<div class="sec-title">배송 정보</div>'
    +   '<div class="dr"><div class="dk">수령인</div><div class="dv">' + o.recv + '</div></div>'
    +   '<div class="dr"><div class="dk">연락처</div><div class="dv">' + o.phone + '</div></div>'
    +   '<div class="dr"><div class="dk">배송지</div><div class="dv">' + o.fullAddr + '</div></div>'
    + '</div>'
    + '<div>'
    +   '<div class="sec-title">송장 정보 입력</div>'
    +   '<div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">'
    +     '<div style="display:flex;flex-direction:column;gap:5px">'
    +       '<label style="font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em">택배사</label>'
    +       '<select id="modal-courier" style="padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:13px;font-family:\'Pretendard\',sans-serif;color:var(--gray2);outline:none">'
    +         '<option value="">택배사 선택</option>'
    +         courierOptions
    +       '</select>'
    +     '</div>'
    +     '<div style="display:flex;flex-direction:column;gap:5px">'
    +       '<label style="font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em">송장번호</label>'
    +       '<input id="modal-invoice" value="' + existInv + '" placeholder="숫자 12자리 입력" style="padding:9px 12px;border:1.5px solid var(--gray5);border-radius:7px;font-size:13px;font-family:\'DM Mono\',monospace;color:var(--gray1);outline:none;transition:border .15s">'
    +     '</div>'
    +   '</div>'
    +   '<div style="font-size:11px;color:var(--gray4);margin-top:6px">* 송장번호 미입력 시 출고 처리 후 별도 입력 가능합니다.</div>'
    + '</div>';
  document.getElementById('singleModal').classList.add('open');
}
function closeSingle(){ document.getElementById('singleModal').classList.remove('open'); }
function confirmSingle() {
  closeSingle();
  const o = orders.find(function(x){ return x.id === currentSingleId; });
  if(o) o.status = '출고 완료';
  renderOrders(orders.filter(function(x){ return x.status === '출고 대기'; }));
  updateWait();
  showToast('✅ ' + currentSingleId + ' 출고 처리 완료');
}
 
// ── 일괄 출고 ──────────────────────────────────────
function openBulkConfirm() {
  const checked = Array.from(document.querySelectorAll('.row-chk:checked'));
  const ids = checked.map(function(c){ return c.dataset.id; });
  const selected = orders.filter(function(o){ return ids.includes(o.id); });
  document.getElementById('bulkDesc').textContent = '선택하신 ' + selected.length + '건의 주문을 일괄 출고 처리합니다.';
  document.getElementById('bulkItems').innerHTML = selected.map(function(o) {
    return '<div class="ci-row">'
      + '<div class="ci-key" style="font-family:\'DM Mono\',monospace;font-size:11px">' + o.id + '</div>'
      + '<div class="ci-val" style="font-size:12px">' + o.name + ' · ' + o.size + '</div>'
      + '</div>';
  }).join('');
  document.getElementById('bulkModal').classList.add('open');
}
function closeBulk(){ document.getElementById('bulkModal').classList.remove('open'); }
function doBulk() {
  const checked = Array.from(document.querySelectorAll('.row-chk:checked'));
  const ids = checked.map(function(c){ return c.dataset.id; });
  ids.forEach(function(id) {
    const o = orders.find(function(x){ return x.id === id; });
    if(o) o.status = '출고 완료';
  });
  closeBulk();
  renderOrders(orders.filter(function(x){ return x.status === '출고 대기'; }));
  updateWait();
  document.getElementById('chkAll').checked = false;
  updateSel();
  showToast('✅ ' + ids.length + '건 일괄 출고 처리 완료');
}
 
function updateWait() {
  const waitN = orders.filter(function(o){ return o.status === '출고 대기'; }).length;
  document.getElementById('kpiWait').textContent = waitN;
  document.getElementById('waitNum').textContent = waitN;
  document.getElementById('waitCnt').textContent = waitN;
  if(waitN === 0) {
    document.getElementById('waitAlert').className = 'alert alert-green';
    document.getElementById('waitAlert').innerHTML = '<span class="alert-ico">✅</span><div>모든 출고 대기 주문이 처리되었습니다.</div>';
  }
}
 
// ── 이력 상세 ──────────────────────────────────────
function openHistDetail(){ document.getElementById('histModal').classList.add('open'); }
 
// ── 탭 전환 ────────────────────────────────────────
function switchTab(tab) {
  const isOut = tab === 'out';
  document.getElementById('sec-out').style.display  = isOut ? '' : 'none';
  document.getElementById('sec-hist').style.display = isOut ? 'none' : '';
  document.getElementById('tab-out-btn').classList.toggle('on', isOut);
  document.getElementById('tab-hist-btn').classList.toggle('on', !isOut);
}
 
// ── TOAST ───────────────────────────────────────────
function showToast(msg) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(function(){ t.classList.remove('show'); }, 2800);
}
 
// ── 모달 바깥 클릭 ─────────────────────────────────
['singleModal','bulkModal','histModal'].forEach(function(id) {
  document.getElementById(id).addEventListener('click', function(e) {
    if(e.target === e.currentTarget) e.currentTarget.classList.remove('open');
  });
});
 
// ── 초기 렌더 ──────────────────────────────────────
renderOrders(orders);
</script>
</body>
</html>