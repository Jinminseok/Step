<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고현황 조회</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* CONTENT */
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* TAB BAR */
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab-btn{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}

/* SUMMARY CARDS */
.sum-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px}
.sum-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:18px 20px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden;cursor:pointer;transition:all .18s}
.sum-card:hover{box-shadow:0 4px 16px rgba(15,32,68,.1);transform:translateY(-1px)}
.sum-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.sum-card.blue::before{background:var(--blue)}.sum-card.amber::before{background:var(--amber)}.sum-card.red::before{background:var(--red)}.sum-card.green::before{background:var(--green)}
.sum-card.active-card{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.12)}
.sum-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px}
.sum-val{font-family:'DM Mono',monospace;font-size:28px;font-weight:700;margin-bottom:4px;letter-spacing:-1px}
.sum-val.c-blue{color:var(--blue)}.sum-val.c-amber{color:var(--amber)}.sum-val.c-red{color:var(--red)}.sum-val.c-green{color:var(--green)}
.sum-sub{font-size:11px;color:var(--gray4)}
.sum-icon{position:absolute;right:16px;top:50%;transform:translateY(-50%);font-size:32px;opacity:.12}

/* ALERT */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}

/* TOOLBAR */
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.sw{position:relative;flex:1;min-width:180px;max-width:260px}
.sw input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.sw input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.sw input::placeholder{color:var(--gray4)}
.sw-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;transition:border .15s}
.sel:focus{border-color:var(--blue)}

/* BUTTONS */
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-amber{background:var(--amber);color:#fff}.btn-amber:hover{background:#D97706}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-ghost{background:transparent;color:var(--gray3);border:1.5px solid var(--gray5)}.btn-ghost:hover{color:var(--gray1);border-color:var(--gray3)}
.btn-sm{padding:7px 13px;font-size:12px}
.btn-xs{padding:4px 10px;font-size:11px}

/* TABLE */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:8px;flex-wrap:wrap}
.tbl-info{font-size:12px;color:var(--gray3)}.tbl-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
thead{position:sticky;top:0;z-index:5}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:12px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}
.trow{cursor:pointer;transition:background .12s}
.trow:hover td{background:#F5F8FF}
td:first-child{border-left:3px solid transparent;padding-left:11px}
.trow:hover td:first-child{border-left-color:var(--blue)}

/* BADGE */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-gray{background:var(--gray7);color:var(--gray3)}

/* PROGRESS */
.prog-wrap{display:flex;align-items:center;gap:8px}
.prog-track{flex:1;height:6px;background:var(--gray6);border-radius:3px;overflow:hidden;min-width:60px}
.prog-fill{height:100%;border-radius:3px;transition:width .4s ease}
.p-ok{background:var(--blue)}.p-warn{background:var(--amber)}.p-low{background:var(--red)}.p-zero{background:var(--gray5)}
.prog-num{font-family:'DM Mono',monospace;font-size:10px;color:var(--gray3);width:28px;text-align:right;flex-shrink:0}

/* SIZE GRID */
.size-grid{display:flex;flex-wrap:wrap;gap:4px}
.sz{
  font-family:'DM Mono',monospace;font-size:10px;font-weight:600;
  padding:3px 7px;border-radius:4px;border:1px solid var(--gray6);
  background:var(--bg2);color:var(--gray2);white-space:nowrap;
}
.sz.low{background:var(--amber-lt);border-color:#FCD34D;color:#92400E}
.sz.zero{background:var(--red-lt);border-color:#FECACA;color:#991B1B}

/* MINI KPI (부족 탭) */
.mini-kpi-row{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:18px}
.mini-kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:16px 18px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden}
.mini-kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.mk-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:6px}
.mk-val{font-family:'DM Mono',monospace;font-size:30px;font-weight:700;letter-spacing:-1px}
.mk-sub{font-size:11px;color:var(--gray4);margin-top:3px}

/* PAGINATION */
.pg-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.pg-info{font-size:12px;color:var(--gray3)}
.pg-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* MODAL */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:620px;max-height:90vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* SECTION TITLE */
.sec-ttl{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px}
.sec-ttl::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}

/* SIZE STOCK TABLE IN MODAL */
.sz-tbl{width:100%;border-collapse:collapse}
.sz-tbl th{padding:8px 12px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left}
.sz-tbl td{padding:10px 12px;font-size:12.5px;color:var(--gray2);border-bottom:1px solid var(--gray7)}
.sz-tbl tr:last-child td{border-bottom:none}
.sz-tbl .qty-ok{color:var(--gray1);font-weight:700;font-family:'DM Mono',monospace}
.sz-tbl .qty-warn{color:var(--amber);font-weight:700;font-family:'DM Mono',monospace}
.sz-tbl .qty-zero{color:var(--red);font-weight:700;font-family:'DM Mono',monospace}

/* TOAST */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
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
      <span class="breadcrumb-cur" id="pg-title">재고현황 조회</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->      
    </div>
  </div>
  <div class="content">

    <!-- 요약 카드 4개 (클릭으로 탭 이동) -->
    <div class="sum-row">
      <div class="sum-card blue active-card" id="card-all" onclick="switchTab('all')">
        <div class="sum-icon">📦</div>
        <div class="sum-label">전체 재고</div>
        <div class="sum-val c-blue">4,821</div>
        <div class="sum-sub">켤레 보유 중</div>
      </div>
      <div class="sum-card amber" id="card-low" onclick="switchTab('low')">
        <div class="sum-icon">⚠️</div>
        <div class="sum-label">재고 부족 옵션</div>
        <div class="sum-val c-amber">26</div>
        <div class="sum-sub">기준 수량(10개) 미만</div>
      </div>
      <div class="sum-card red" id="card-zero" onclick="switchTab('zero')">
        <div class="sum-icon">🚫</div>
        <div class="sum-label">품절 상품</div>
        <div class="sum-val c-red">8</div>
        <div class="sum-sub">재고 0개 옵션</div>
      </div>
      <div class="sum-card green" id="card-ok" onclick="switchTab('all')">
        <div class="sum-icon">✅</div>
        <div class="sum-label">정상 재고</div>
        <div class="sum-val c-green">312</div>
        <div class="sum-sub">정상 보유 옵션</div>
      </div>
    </div>

    <!-- TAB BAR -->
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-all" onclick="switchTab('all')">
        🗃️ 전체 재고 <span class="tab-cnt" style="background:var(--blue)">346</span>
      </div>
      <div class="tab-btn" id="tab-low" onclick="switchTab('low')">
        ⚠️ 재고 부족 <span class="tab-cnt" style="background:var(--amber)">26</span>
      </div>
      <div class="tab-btn" id="tab-zero" onclick="switchTab('zero')">
        🚫 품절 상품 <span class="tab-cnt" style="background:var(--red)">8</span>
      </div>
    </div>

    <!-- ═══ 전체 재고 탭 ═══ -->
    <div id="sec-all">
      <div class="toolbar">
        <div class="sw"><span class="sw-ico">🔍</span><input type="text" placeholder="상품명·품번·브랜드 검색" oninput="filterAll(this.value)"></div>
        <select class="sel" id="sel-brand" onchange="filterAll()">
          <option>전체 브랜드</option>
          <option>나이키</option><option>아디다스</option><option>뉴발란스</option><option>호카</option><option>버켄스탁</option>
        </select>
        <select class="sel" id="sel-cat" onchange="filterAll()">
          <option>전체 카테고리</option>
          <option>운동화</option><option>러닝화</option><option>농구화</option><option>샌들</option><option>부츠</option>
        </select>
        <select class="sel" id="sel-status" onchange="filterAll()">
          <option>전체 상태</option>
          <option>정상</option><option>주의</option><option>부족</option><option>품절</option>
        </select>
        <div style="margin-left:auto;display:flex;gap:7px">
          <button class="btn btn-ghost btn-sm">📥 엑셀 다운로드</button>
          <button class="btn btn-blue btn-sm" onclick="showToast('재고 동기화 완료')">🔄 재고 동기화</button>
        </div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">전체 상품 <strong id="allCount">12</strong>개 · 옵션(사이즈×컬러) <strong>346</strong>개</div>
          <div style="font-size:11px;color:var(--gray4);font-family:'DM Mono',monospace">최종 동기화: 09:14:32</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>카테고리</th>
                <th>컬러 수</th><th>사이즈 범위</th><th>전체 재고</th><th>재고율</th><th>상태</th><th>상세</th>
              </tr>
            </thead>
            <tbody id="allTbody"></tbody>
          </table>
        </div>
        <div class="pg-wrap">
          <div class="pg-info" id="allPageInfo">1 – 10 / 12개</div>
          <div class="pg-btns"><div class="pg-btn">‹</div><div class="pg-btn on">1</div><div class="pg-btn">2</div><div class="pg-btn">›</div></div>
        </div>
      </div>
    </div>

    <!-- ═══ 재고 부족 탭 ═══ -->
    <div id="sec-low" style="display:none">
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div>재고 기준 수량(10개) 미만 옵션이 <strong>26개</strong>입니다. 입고 등록을 통해 재고를 보충하세요.</div>
      </div>
      <div class="mini-kpi-row">
        <div class="mini-kpi" style="border-top:3px solid var(--amber)">
          <div class="mk-label">재고 부족 옵션</div>
          <div class="mk-val" style="color:var(--amber)">26</div>
          <div class="mk-sub">10개 미만 옵션 수</div>
        </div>
        <div class="mini-kpi" style="border-top:3px solid var(--blue)">
          <div class="mk-label">부족 옵션 총 재고</div>
          <div class="mk-val" style="color:var(--blue)">127</div>
          <div class="mk-sub">켤레 합계</div>
        </div>
        <div class="mini-kpi" style="border-top:3px solid var(--red)">
          <div class="mk-label">재입고 신청 대기</div>
          <div class="mk-val" style="color:var(--red)">8</div>
          <div class="mk-sub">알림 발송 대기 사용자</div>
        </div>
      </div>
      <div class="toolbar">
        <div class="sw"><span class="sw-ico">🔍</span><input type="text" placeholder="상품명·품번 검색"></div>
        <select class="sel"><option>전체 브랜드</option><option>나이키</option><option>아디다스</option><option>뉴발란스</option></select>
        <div style="margin-left:auto;display:flex;gap:7px">
          <button class="btn btn-ghost btn-sm">📥 엑셀</button>
          <button class="btn btn-amber btn-sm" onclick="showToast('입고 관리 페이지로 이동합니다')">📥 입고 등록</button>
        </div>
      </div>
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">재고 부족 옵션 <strong>26</strong>개</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>사이즈</th><th>컬러</th>
                <th>현재 재고</th><th>부족 기준</th><th>재고율</th><th>재입고 신청</th><th>처리</th>
              </tr>
            </thead>
            <tbody id="lowTbody"></tbody>
          </table>
        </div>
        <div class="pg-wrap">
          <div class="pg-info">1 – 10 / 26개</div>
          <div class="pg-btns"><div class="pg-btn">‹</div><div class="pg-btn on">1</div><div class="pg-btn">2</div><div class="pg-btn">3</div><div class="pg-btn">›</div></div>
        </div>
      </div>
    </div>

    <!-- ═══ 품절 상품 탭 ═══ -->
    <div id="sec-zero" style="display:none">
      <div class="alert alert-red">
        <span class="alert-ico">🚫</span>
        <div>재고 <strong>0개</strong>인 품절 옵션이 <strong>8개</strong>입니다. 즉시 입고 처리가 필요한 옵션을 확인하세요.</div>
      </div>
      <div class="toolbar">
        <div class="sw"><span class="sw-ico">🔍</span><input type="text" placeholder="상품명·품번 검색"></div>
        <select class="sel"><option>전체 브랜드</option><option>나이키</option><option>아디다스</option><option>버켄스탁</option></select>
        <div style="margin-left:auto;display:flex;gap:7px">
          <button class="btn btn-ghost btn-sm">📥 엑셀</button>
          <button class="btn btn-blue btn-sm" onclick="showToast('입고 등록으로 이동')">📥 즉시 입고 등록</button>
        </div>
      </div>
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">품절 옵션 <strong>8</strong>개</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>사이즈</th><th>컬러</th>
                <th>재고</th><th>마지막 입고일</th><th>재입고 신청 수</th><th>상태</th><th>처리</th>
              </tr>
            </thead>
            <tbody id="zeroTbody"></tbody>
          </table>
        </div>
        <div class="pg-wrap">
          <div class="pg-info">1 – 8 / 8개</div>
          <div class="pg-btns"><div class="pg-btn on">1</div></div>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- ═══ 상품 상세 재고 모달 ═══ -->
<div class="modal-bg" id="detailModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title" id="modalTitle">📦 재고 상세 현황</div>
      <button class="modal-x" onclick="closeModal()">✕</button>
    </div>
    <div class="modal-body" id="modalBody"></div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="closeModal()">닫기</button>
      <button class="btn btn-amber btn-sm" onclick="closeModal();showToast('입고 등록 페이지로 이동')">📥 입고 등록</button>
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

// ── 데이터 ─────────────────────────────────────────
const allProds = [
  {sku:'NK-AF1-WHT',   brand:'나이키',   name:'에어포스 1 로우',   cat:'운동화', colors:3, sizes:'225~280', stock:148, max:200, sizes_data:[{sz:225,qty:12},{sz:230,qty:18},{sz:235,qty:22},{sz:240,qty:30},{sz:245,qty:24},{sz:250,qty:20},{sz:255,qty:14},{sz:260,qty:8}]},
  {sku:'AD-UB22-BLK',  brand:'아디다스', name:'울트라부스트 22',    cat:'러닝화', colors:5, sizes:'230~280', stock:32,  max:100, sizes_data:[{sz:240,qty:2},{sz:245,qty:3},{sz:250,qty:5},{sz:255,qty:8},{sz:260,qty:7},{sz:265,qty:4},{sz:270,qty:3}]},
  {sku:'NK-AM270-GRY', brand:'나이키',   name:'에어맥스 270',       cat:'운동화', colors:3, sizes:'225~280', stock:11,  max:100, sizes_data:[{sz:240,qty:3},{sz:245,qty:2},{sz:250,qty:8},{sz:255,qty:19},{sz:260,qty:24}]},
  {sku:'NB-990V5-NVY', brand:'뉴발란스', name:'990v5',              cat:'운동화', colors:3, sizes:'230~285', stock:87,  max:100, sizes_data:[{sz:250,qty:14},{sz:255,qty:22},{sz:260,qty:30},{sz:265,qty:21}]},
  {sku:'HK-CLIFF9-WHT',brand:'호카',     name:'클리프턴 9',         cat:'러닝화', colors:5, sizes:'225~280', stock:44,  max:80,  sizes_data:[{sz:250,qty:8},{sz:255,qty:12},{sz:260,qty:14},{sz:265,qty:10}]},
  {sku:'AD-SAMBA-BLK', brand:'아디다스', name:'삼바 OG',            cat:'운동화', colors:2, sizes:'220~280', stock:67,  max:80,  sizes_data:[{sz:250,qty:10},{sz:255,qty:14},{sz:260,qty:20},{sz:265,qty:23}]},
  {sku:'BK-BOSTON-BEG',brand:'버켄스탁', name:'보스턴 스웨이드',    cat:'샌들',   colors:4, sizes:'230~275', stock:12,  max:60,  sizes_data:[{sz:240,qty:2},{sz:245,qty:4},{sz:250,qty:6}]},
  {sku:'NK-SBJRD-RED', brand:'나이키',   name:'에어 조던 1 레트로', cat:'농구화', colors:4, sizes:'240~285', stock:0,   max:60,  sizes_data:[{sz:255,qty:0},{sz:260,qty:0},{sz:265,qty:0}]},
  {sku:'NB-327-GRY',   brand:'뉴발란스', name:'327',                cat:'운동화', colors:3, sizes:'225~275', stock:55,  max:80,  sizes_data:[{sz:250,qty:14},{sz:255,qty:18},{sz:260,qty:23}]},
  {sku:'HK-BOND-BLK',  brand:'호카',     name:'본다이 8',           cat:'러닝화', colors:3, sizes:'225~280', stock:38,  max:60,  sizes_data:[{sz:250,qty:12},{sz:255,qty:14},{sz:260,qty:12}]},
  {sku:'AD-GZLST-WHT', brand:'아디다스', name:'가젤 스탠스미스',    cat:'운동화', colors:2, sizes:'230~275', stock:22,  max:50,  sizes_data:[{sz:250,qty:6},{sz:255,qty:9},{sz:260,qty:7}]},
  {sku:'NK-FREE-GRY',  brand:'나이키',   name:'프리런 5.0',         cat:'러닝화', colors:2, sizes:'230~280', stock:16,  max:50,  sizes_data:[{sz:250,qty:5},{sz:255,qty:6},{sz:260,qty:5}]},
];

const lowOpts = [
  {sku:'NK-AM270-GRY', brand:'나이키',   name:'에어맥스 270',     sz:'240mm', color:'그레이', qty:3, min:10, restockCnt:2},
  {sku:'NK-AM270-GRY', brand:'나이키',   name:'에어맥스 270',     sz:'245mm', color:'그레이', qty:2, min:10, restockCnt:3},
  {sku:'AD-UB22-BLK',  brand:'아디다스', name:'울트라부스트 22',  sz:'240mm', color:'블랙',   qty:2, min:10, restockCnt:1},
  {sku:'AD-UB22-BLK',  brand:'아디다스', name:'울트라부스트 22',  sz:'245mm', color:'블랙',   qty:3, min:10, restockCnt:0},
  {sku:'BK-BOSTON-BEG',brand:'버켄스탁', name:'보스턴 스웨이드',  sz:'240mm', color:'베이지', qty:2, min:10, restockCnt:1},
  {sku:'NK-AM270-GRY', brand:'나이키',   name:'에어맥스 270',     sz:'250mm', color:'그레이', qty:8, min:10, restockCnt:0},
  {sku:'AD-UB22-BLK',  brand:'아디다스', name:'울트라부스트 22',  sz:'260mm', color:'블랙',   qty:7, min:10, restockCnt:0},
  {sku:'NK-FREE-GRY',  brand:'나이키',   name:'프리런 5.0',       sz:'250mm', color:'그레이', qty:5, min:10, restockCnt:0},
  {sku:'AD-GZLST-WHT', brand:'아디다스', name:'가젤 스탠스미스',  sz:'250mm', color:'화이트', qty:6, min:10, restockCnt:0},
  {sku:'BK-BOSTON-BEG',brand:'버켄스탁', name:'보스턴 스웨이드',  sz:'245mm', color:'베이지', qty:4, min:10, restockCnt:0},
];

const zeroOpts = [
  {sku:'NK-SBJRD-RED', brand:'나이키',   name:'에어 조던 1 레트로', sz:'255mm', color:'레드',   lastIn:'2025-03-15', restockCnt:5},
  {sku:'NK-SBJRD-RED', brand:'나이키',   name:'에어 조던 1 레트로', sz:'260mm', color:'레드',   lastIn:'2025-03-15', restockCnt:3},
  {sku:'NK-SBJRD-RED', brand:'나이키',   name:'에어 조던 1 레트로', sz:'265mm', color:'블랙',   lastIn:'2025-03-10', restockCnt:2},
  {sku:'AD-UB22-BLK',  brand:'아디다스', name:'울트라부스트 22',    sz:'230mm', color:'블랙',   lastIn:'2025-04-01', restockCnt:0},
  {sku:'BK-BOSTON-BEG',brand:'버켄스탁', name:'보스턴 스웨이드',    sz:'235mm', color:'베이지', lastIn:'2025-03-20', restockCnt:1},
  {sku:'NK-AM270-GRY', brand:'나이키',   name:'에어맥스 270',       sz:'225mm', color:'화이트', lastIn:'2025-04-10', restockCnt:0},
  {sku:'HK-CLIFF9-WHT',brand:'호카',     name:'클리프턴 9',         sz:'225mm', color:'화이트', lastIn:'2025-04-05', restockCnt:1},
  {sku:'AD-GZLST-WHT', brand:'아디다스', name:'가젤 스탠스미스',    sz:'230mm', color:'화이트', lastIn:'2025-03-28', restockCnt:0},
];

// ── 상태 계산 ──────────────────────────────────────
function getStatus(stock, max) {
  const pct = max>0?stock/max:0;
  if(stock===0) return {lbl:'품절',cls:'bdg-red',  pcls:'p-zero',pct:0};
  if(stock<10)  return {lbl:'부족',cls:'bdg-red',  pcls:'p-low', pct:Math.round(pct*100)};
  if(pct<0.3)   return {lbl:'주의',cls:'bdg-amber',pcls:'p-warn',pct:Math.round(pct*100)};
  return               {lbl:'정상',cls:'bdg-green',pcls:'p-ok',  pct:Math.round(pct*100)};
}

// ── 전체 재고 렌더 ─────────────────────────────────
function renderAll(data) {
  document.getElementById('allCount').textContent = data.length;
  document.getElementById('allTbody').innerHTML = data.map(p => {
    const st = getStatus(p.stock, p.max);
    return `<tr class="trow" onclick="openDetail('` + p.sku + `')">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">` + p.sku + `</td>
      <td style="font-weight:500">` + p.brand + `</td>
      <td style="font-weight:600;color:var(--gray1)">` + p.name + `</td>
      <td><span class="bdg bdg-gray" style="font-size:10px">` + p.cat + `</span></td>
      <td style="text-align:center;font-family:'DM Mono',monospace;font-weight:600">` + p.colors + `색</td>
      <td style="font-family:'DM Mono',monospace;font-size:11px">` + p.sizes + `</td>
      <td style="font-family:'DM Mono',monospace;font-weight:700;font-size:13px">` + p.stock.toLocaleString() + `</td>
      <td style="min-width:110px">
        <div class="prog-wrap">
          <div class="prog-track"><div class="prog-fill ` + st.pcls + `" style="width:` + st.pct + `%"></div></div>
          <div class="prog-num">` + st.pct + `%</div>
        </div>
      </td>
      <td><span class="bdg ` + st.cls + `">` + st.lbl + `</span></td>
      <td><button class="btn btn-outline btn-xs" onclick="event.stopPropagation();openDetail('` + p.sku + `')">사이즈별</button></td>
    </tr>`;
  }).join('');
}

function filterAll(q) {
  const val = (q || document.querySelector('#sec-all .sw input').value).toLowerCase();
  const filtered = allProds.filter(p =>
    p.name.toLowerCase().includes(val) || p.sku.toLowerCase().includes(val) || p.brand.toLowerCase().includes(val)
  );
  renderAll(filtered);
}

// ── 재고 부족 렌더 ─────────────────────────────────
function renderLow() {
  document.getElementById('lowTbody').innerHTML = lowOpts.map(o => {
    const pct = Math.round(o.qty/o.min*100);
    return `<tr class="trow">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">` + o.sku + `</td>
      <td>` + o.brand + `</td>
      <td style="font-weight:600;color:var(--gray1)">` + o.name + `</td>
      <td style="font-family:'DM Mono',monospace;font-weight:600">` + o.sz + `</td>
      <td>` + o.color + `</td>
      <td>
        <span style="font-family:'DM Mono',monospace;font-size:15px;font-weight:800;color:` + (o.qty<=3?'var(--red)':'var(--amber)') + `">` + o.qty + `</span>
        <span style="font-size:10px;color:var(--gray4)">개</span>
      </td>
      <td style="font-family:'DM Mono',monospace;font-size:12px;color:var(--gray3)">` + o.min + `개</td>
      <td style="min-width:100px">
        <div class="prog-wrap">
          <div class="prog-track"><div class="prog-fill p-low" style="width:` + pct + `%"></div></div>
          <div class="prog-num">` + pct + `%</div>
        </div>
      </td>
      <td>` + (o.restockCnt>0 ? `<span class="bdg bdg-amber">` + o.restockCnt + `명 신청</span>` : `<span class="bdg bdg-gray">없음</span>`) + `</td>
      <td><button class="btn btn-amber btn-xs" onclick="showToast('입고 등록 페이지로 이동')">📥 입고 등록</button></td>
    </tr>`;
  }).join('');
}

// ── 품절 렌더 ──────────────────────────────────────
function renderZero() {
  document.getElementById('zeroTbody').innerHTML = zeroOpts.map(o =>
    `<tr class="trow">
      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">` + o.sku + `</td>
      <td>` + o.brand + `</td>
      <td style="font-weight:600;color:var(--gray1)">` + o.name + `</td>
      <td style="font-family:'DM Mono',monospace;font-weight:600">` + o.sz + `</td>
      <td>` + o.color + `</td>
      <td><span style="font-family:'DM Mono',monospace;font-size:15px;font-weight:800;color:var(--red)">0</span><span style="font-size:10px;color:var(--gray4)">개</span></td>
      <td style="font-size:11px;color:var(--gray3)">` + o.lastIn + `</td>
      <td>` + (o.restockCnt>0 ? `<span class="bdg bdg-red">` + o.restockCnt + `명 신청</span>` : `<span class="bdg bdg-gray">없음</span>`) + `</td>
      <td><span class="bdg bdg-red">품절</span></td>
      <td><button class="btn btn-blue btn-xs" onclick="showToast('입고 등록 페이지로 이동')">📥 즉시 입고</button></td>
    </tr>`
  ).join('');
}

// ── 상세 모달 ──────────────────────────────────────
function openDetail(sku) {
  const p = allProds.find(x=>x.sku===sku);
  if(!p) return;
  const st = getStatus(p.stock, p.max);
  document.getElementById('modalTitle').textContent = '📦 ' + p.name + ' — 사이즈별 재고';
  const bgColor = st.cls==='bdg-green' ? 'var(--green-lt)' : st.cls==='bdg-amber' ? 'var(--amber-lt)' : 'var(--red-lt)';
  const valColor = p.stock===0||p.stock<10 ? 'var(--red)' : st.pct<30 ? 'var(--amber)' : 'var(--green)';
  const rows = p.sizes_data.map(s => {
    const cls   = s.qty===0?'qty-zero':s.qty<10?'qty-warn':'qty-ok';
    const stLbl = s.qty===0?'품절':s.qty<10?'부족':'정상';
    const bdgCls= s.qty===0?'bdg-red':s.qty<10?'bdg-amber':'bdg-green';
    const pct   = Math.min(100, Math.round(s.qty/30*100));
    const pcls  = s.qty===0?'p-zero':s.qty<10?'p-low':'p-ok';
    return `<tr>
      <td style="font-family:'DM Mono',monospace;font-weight:600">` + s.sz + `mm</td>
      <td class="` + cls + `">` + s.qty + `개</td>
      <td style="min-width:120px">
        <div class="prog-wrap">
          <div class="prog-track" style="height:5px"><div class="prog-fill ` + pcls + `" style="width:` + pct + `%"></div></div>
          <div class="prog-num" style="font-size:10px">` + pct + `%</div>
        </div>
      </td>
      <td><span class="bdg ` + bdgCls + `">` + stLbl + `</span></td>
    </tr>`;
  }).join('');

  document.getElementById('modalBody').innerHTML =
    `<div style="display:flex;gap:20px;margin-bottom:18px;flex-wrap:wrap">
      <div style="flex:1;min-width:200px">
        <div class="sec-ttl">상품 정보</div>
        <div style="display:flex;flex-direction:column;gap:7px">
          <div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">품번 (SKU)</span><span style="font-family:'DM Mono',monospace;font-weight:600;color:var(--blue)">` + p.sku + `</span></div>
          <div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">브랜드</span><span style="font-weight:600">` + p.brand + `</span></div>
          <div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">카테고리</span><span>` + p.cat + `</span></div>
          <div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">컬러 종류</span><span>` + p.colors + `색</span></div>
          <div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">사이즈 범위</span><span style="font-family:'DM Mono',monospace">` + p.sizes + `mm</span></div>
        </div>
      </div>
      <div style="flex:1;min-width:180px">
        <div class="sec-ttl">재고 요약</div>
        <div style="text-align:center;padding:14px;background:` + bgColor + `;border-radius:8px">
          <div style="font-family:'DM Mono',monospace;font-size:32px;font-weight:700;color:` + valColor + `">` + p.stock + `</div>
          <div style="font-size:11px;color:var(--gray3);margin-top:4px">총 재고 (켤레)</div>
        </div>
        <div style="margin-top:10px">
          <div class="prog-wrap">
            <div class="prog-track" style="height:8px"><div class="prog-fill ` + st.pcls + `" style="width:` + st.pct + `%"></div></div>
            <div class="prog-num">` + st.pct + `%</div>
          </div>
        </div>
      </div>
    </div>
    <div class="sec-ttl">사이즈별 재고 현황</div>
    <table class="sz-tbl">
      <thead><tr><th>사이즈</th><th>재고 수량</th><th>재고 바</th><th>상태</th></tr></thead>
      <tbody>` + rows + `</tbody>
    </table>`;

  document.getElementById('detailModal').classList.add('open');
}
function closeModal(){ document.getElementById('detailModal').classList.remove('open'); }

// ── 탭 전환 ───────────────────────────────────────
function switchTab(tab) {
  ['all','low','zero'].forEach(t => {
    document.getElementById('sec-'+t).style.display = t===tab ? '' : 'none';
    document.getElementById('tab-'+t).classList.toggle('on', t===tab);
  });
  document.getElementById('card-all').classList.toggle('active-card',  tab==='all');
  document.getElementById('card-low').classList.toggle('active-card',  tab==='low');
  document.getElementById('card-zero').classList.toggle('active-card', tab==='zero');
  document.getElementById('card-ok').classList.remove('active-card');
  if(tab==='all')  renderAll(allProds);
  if(tab==='low')  renderLow();
  if(tab==='zero') renderZero();
}

// ── 모달 바깥 클릭 ────────────────────────────────
document.getElementById('detailModal').addEventListener('click', e => {
  if(e.target===e.currentTarget) closeModal();
});

// ── TOAST ──────────────────────────────────────────
function showToast(msg) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 2800);
}

// ── 초기 렌더 ─────────────────────────────────────
renderAll(allProds);
</script>
</body>
</html>