<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입고 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* ═══ CONTENT AREA ══════════════════ */
.content{flex:1;overflow-y:auto;padding:22px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ─── TAB SWITCH BAR ──────────────── */
.tab-bar{
  display:flex;gap:0;margin-bottom:20px;
  border-bottom:2px solid var(--gray6);
}
.tab-btn{
  padding:10px 24px;font-size:12.5px;font-weight:700;
  color:var(--gray4);cursor:pointer;
  border-bottom:2px solid transparent;margin-bottom:-2px;
  transition:all .18s;letter-spacing:.03em;
  display:flex;align-items:center;gap:7px;
}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{
  background:var(--red);color:#fff;
  font-size:9px;font-weight:700;padding:1px 5px;border-radius:10px;
}
.tab-cnt-blue{background:var(--blue)}

/* ─── MAIN GRID ───────────────────── */
.main-grid{display:grid;grid-template-columns:400px 1fr;gap:18px;align-items:start}

/* ─── CARD ────────────────────────── */
.card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;box-shadow:0 1px 3px rgba(15,32,68,.07),0 4px 14px rgba(15,32,68,.05);overflow:hidden}
.card-hdr{display:flex;align-items:center;justify-content:space-between;padding:14px 18px;border-bottom:1px solid var(--gray7)}
.card-title{font-size:13px;font-weight:700;color:var(--gray1);display:flex;align-items:center;gap:7px}
.card-title-ico{width:24px;height:24px;background:var(--blue-lt);border-radius:5px;display:flex;align-items:center;justify-content:center;font-size:12px}
.card-body{padding:18px}

/* ─── FORM ────────────────────────── */
.fg-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.fg-full{grid-column:1/-1}
.fg{display:flex;flex-direction:column;gap:5px}
.fg label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.req{color:var(--red);margin-left:2px}
.fi{
  padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);
  border-radius:7px;font-size:13px;font-family:'Pretendard',sans-serif;
  color:var(--gray1);outline:none;width:100%;transition:all .15s;
}
.fi:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.1)}
.fi::placeholder{color:var(--gray4)}
.fi:read-only{background:var(--gray7);color:var(--gray3);cursor:default}
select.fi option{background:var(--white)}
textarea.fi{resize:vertical;min-height:80px;line-height:1.6}
.fi-prefix-wrap{position:relative}
.fi-prefix{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:12px;color:var(--gray4);pointer-events:none}
.fi-prefix+.fi{padding-left:28px}
.fi-hint{font-size:10px;color:var(--gray4);margin-top:3px}

/* ─── SIZE CHIPS ──────────────────── */
.chip-wrap{display:flex;flex-wrap:wrap;gap:6px;margin-top:2px}
.chip{
  padding:5px 11px;border:1.5px solid var(--gray5);border-radius:6px;
  font-size:12px;cursor:pointer;font-family:'Pretendard',sans-serif;
  font-weight:500;background:var(--white);color:var(--gray3);transition:all .15s;
}
.chip.on{border-color:var(--blue);color:var(--blue);background:var(--blue-lt);font-weight:700}
.chip:hover:not(.on){border-color:var(--gray3);color:var(--gray2)}

/* ─── BUTTONS ─────────────────────── */
.btn{
  padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;
  font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;
  transition:all .15s;display:inline-flex;align-items:center;gap:6px;
}
.btn-blue{background:var(--blue);color:#fff}
.btn-blue:hover{background:var(--navy2)}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}
.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-sm{padding:6px 12px;font-size:12px}
.btn-xs{padding:3px 9px;font-size:11px}
.btn-ghost{background:transparent;color:var(--gray3);border:1.5px solid var(--gray5)}
.btn-ghost:hover{color:var(--gray1);border-color:var(--gray3)}
/* 추가된 삭제버튼 스타일 */
.btn-danger{background:var(--red-lt);color:var(--red);border:1.5px solid #FECACA}
.btn-danger:hover{background:var(--red);color:#fff}

/* ─── ALERT BOX ───────────────────── */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 14px;border-radius:7px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:14px}
.alert-blue{background:var(--blue-lt);border-color:#93C5FD;color:#1E3A8A}
.alert-green{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-ico{flex-shrink:0;font-size:14px;margin-top:1px}

/* ─── HISTORY TABLE ───────────────── */
.history-section{display:none}
.history-section.active{display:block}

.filter-bar{
  display:flex;align-items:center;gap:8px;
  padding:14px 18px;background:var(--white);
  border:1px solid var(--gray6);border-radius:10px;
  margin-bottom:14px;flex-wrap:wrap;
  box-shadow:0 1px 3px rgba(15,32,68,.05);
}
.filter-group{display:flex;align-items:center;gap:6px}
.filter-label{font-size:11px;font-weight:700;color:var(--gray3);white-space:nowrap;text-transform:uppercase;letter-spacing:.05em}
.date-input{
  padding:7px 10px;border:1.5px solid var(--gray5);background:var(--white);
  font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);
  outline:none;border-radius:6px;transition:border .15s;
}
.date-input:focus{border-color:var(--blue)}
.date-sep{font-size:12px;color:var(--gray4)}
.sel{
  padding:7px 10px;border:1.5px solid var(--gray5);background:var(--white);
  font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);
  outline:none;border-radius:6px;cursor:pointer;transition:border .15s;
}
.sel:focus{border-color:var(--blue)}
.search-wrap{position:relative;min-width:180px}
.search-wrap input{
  width:100%;padding:7px 12px 7px 30px;
  border:1.5px solid var(--gray5);background:var(--white);
  border-radius:6px;font-size:12.5px;color:var(--gray1);
  font-family:'Pretendard',sans-serif;outline:none;transition:border .15s;
}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:9px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}

/* SUMMARY PILLS */
.summary-pills{display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.pill{
  display:flex;align-items:center;gap:6px;
  padding:7px 14px;border-radius:8px;border:1px solid;
  font-size:12px;font-weight:600;
}
.pill-total{background:var(--blue-lt);border-color:#93C5FD;color:var(--blue)}
.pill-done{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.pill-pend{background:var(--amber-lt);border-color:#FCD34D;color:#92400E}
.pill-cancel{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.pill-num{font-family:'DM Mono',monospace;font-size:16px;font-weight:700}

/* TABLE */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2)}
.tbl-top-info{font-size:12px;color:var(--gray3)}
.tbl-top-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
thead{position:sticky;top:0;z-index:5}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}
.tbl-row{cursor:pointer;transition:background .12s}
.tbl-row:hover td{background:var(--blue-lt)}
.tbl-row:hover td:first-child{border-left:3px solid var(--blue);padding-left:14px}
td:first-child{border-left:3px solid transparent;padding-left:14px}

/* BADGE */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-purple{background:var(--purple-lt);color:var(--purple)}
.bdg::before{content:'●';font-size:7px}

/* PAGINATION */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* MODAL */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.45);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:520px;max-height:88vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:15px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* DETAIL TABLE in MODAL */
.detail-row{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7)}
.detail-row:last-child{border-bottom:none}
.detail-key{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:120px;flex-shrink:0;padding-top:1px}
.detail-val{font-size:13px;color:var(--gray1);flex:1}

/* TOAST */
.toast{
  position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);
  background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;
  font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;
  display:flex;align-items:center;gap:8px;
}
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
      <span class="breadcrumb-cur" id="pg-title">입고 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
    </div>
  </div>
 
 <div class="content">

    <!-- TAB BAR -->
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-reg-btn" onclick="switchMain('reg')">
        📥 입고 등록
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchMain('hist')">
        📋 입고 이력 조회
        <span class="tab-cnt tab-cnt-blue" id="todayCountBadge">0</span>
      </div>
    </div>

    <!-- ══════════════ 입고 등록 탭 ══════════════ -->
    <div id="reg-section">
      <div class="main-grid">

        <!-- LEFT: 등록 폼 -->
        <form id="inboundForm" action="${pageContext.request.contextPath}/logistics/log_in/log_inInsert.do" method="post" onsubmit="return false;">
          <input type="hidden" id="hidden_prodNum" name="prodNum" value="">
          <input type="hidden" id="hidden_sizes" name="sizes" value="">          
        <div class="card">
          <div class="card-hdr">
            <div class="card-title">
              <div class="card-title-ico">📥</div>
              입고 대상 정보
            </div>
            <button type="button" class="btn btn-ghost btn-sm" onclick="resetForm()">초기화</button>
          </div>
          <div class="card-body">

            <div class="fg-grid">
              
              <!-- 상품 검색 영역 -->
              <div class="fg fg-full" id="searchWrapDiv">
                <label>마스터 상품 검색 <span class="req">*</span></label>
                <div class="search-wrap" style="min-width:unset">
                  <span class="search-ico">🔍</span>
                  <input type="text" id="prodSearch" placeholder="품번(SKU) 또는 상품명 입력" oninput="searchProd(this.value)">
                </div>
                <!-- 검색 드롭다운 -->
                <div id="searchDrop" style="display:none;border:1.5px solid var(--blue);border-radius:7px;margin-top:4px;overflow:hidden;box-shadow:0 4px 16px rgba(15,32,68,.1)">
                </div>
              </div>

              <!-- 상품 선택 시 나타나는 프로필 카드 -->
              <div class="fg fg-full" id="selectedProdWrap" style="display:none; margin-bottom: 8px;">
                <label>선택된 상품 <span class="req">*</span></label>
                <div style="border:1.5px solid var(--blue); background:var(--blue-lt); border-radius:8px; padding:16px; position:relative;">
                  <button type="button" class="btn btn-xs btn-outline" onclick="clearProd()" style="position:absolute; top:16px; right:16px; background:#fff;">🔄 변경</button>
                  <div style="display:flex; gap:14px; align-items:center;">
                    <div style="width:54px; height:54px; background:#fff; border:1px solid #93C5FD; border-radius:6px; display:flex; align-items:center; justify-content:center; font-size:24px;">👟</div>
                    <div>
                      <div style="font-size:11.5px; color:var(--blue); font-family:'DM Mono',monospace; font-weight:700; margin-bottom:3px;" id="selProdSku"></div>
                      <div style="font-size:14px; font-weight:700; color:var(--gray1); margin-bottom:6px;" id="selProdName"></div>
                      <div style="display:flex; gap:6px;">
                        <span class="bdg bdg-gray" id="selProdBrand"></span>
                        <span class="bdg bdg-gray" id="selProdCat"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="fg-full" style="height:1px; background:var(--gray6); margin: 6px 0;"></div>

              <!-- 컬러 -->
              <div class="fg fg-full">
                <label>입고 컬러 <span class="req">*</span></label>
                <select class="fi" id="fi-color" name="color">
                  <option value="">컬러 선택</option>
                  <option>화이트</option><option>블랙</option><option>그레이</option>
                  <option>네이비</option><option>베이지</option><option>레드</option><option>그린</option>
                </select>
              </div>

              <!-- 사이즈 -->
              <div class="fg fg-full">
                <label>입고 사이즈 (mm) <span class="req">*</span></label>
                <div class="chip-wrap" id="sizeChips">
                  <div class="chip" onclick="selSize(this)">225</div>
                  <div class="chip" onclick="selSize(this)">230</div>
                  <div class="chip" onclick="selSize(this)">235</div>
                  <div class="chip" onclick="selSize(this)">240</div>
                  <div class="chip" onclick="selSize(this)">245</div>
                  <div class="chip" onclick="selSize(this)">250</div>
                  <div class="chip" onclick="selSize(this)">255</div>
                  <div class="chip" onclick="selSize(this)">260</div>
                  <div class="chip" onclick="selSize(this)">265</div>
                  <div class="chip" onclick="selSize(this)">270</div>
                  <div class="chip" onclick="selSize(this)">275</div>
                  <div class="chip" onclick="selSize(this)">280</div>
                </div>
                <div class="fi-hint">복수 선택 가능 · 선택된 사이즈: <strong id="selSizeTxt">없음</strong></div>
              </div>

              <!-- 수량 -->
              <div class="fg">
                <label>입고 수량 <span class="req">*</span></label>
                <div class="fi-prefix-wrap">
                  <input class="fi" id="fi-qty" type="number" name="inQty" placeholder="0" min="1" style="padding-left:14px">
                </div>
                <div class="fi-hint">사이즈별 개 단위 입력</div>
              </div>

              <!-- 입고일 -->
              <div class="fg">
				  <label>입고일 <span class="req">*</span></label>				  
				  <input class="fi" id="fi-date" type="date" name="inDate">
				</div>

              <!-- 공급업체 -->
              <div class="fg fg-full">
                <label>공급업체</label>
                <select class="fi" id="fi-supplier" name="supplier">
                  <option value="">공급업체 선택 (선택)</option>
                  <option>나이키</option>
                  <option>아디다스</option>
                  <option>뉴발란스</option>                  
                  <option>퓨마</option>
                </select>
              </div>

              <!-- 메모 -->
              <div class="fg fg-full">
                <label>메모 (선택)</label>
                <textarea class="fi" id="fi-memo" placeholder="특이사항 또는 입고 관련 메모" name="inMemo"></textarea>
              </div>

              <!-- 버튼 -->
              <div class="fg fg-full" style="display:flex;gap:8px;justify-content:flex-end;margin-top:10px">
                <button type="button" class="btn btn-outline" onclick="resetForm()">취소</button>
                <button type="button" class="btn btn-blue" onclick="submitInbound()">📥 입고 완료</button>
              </div>
            </div>
          </div>
        </div>
        </form>

        <!-- RIGHT: 오늘 입고 + 알림 -->
        <div style="display:flex;flex-direction:column;gap:14px">

          <!-- 재입고 알림 -->
          <div class="alert alert-blue">
            <span class="alert-ico">🔔</span>
            <div>
              <strong>재입고 알림 대기 5건(알림 기능 구현 시 수정 필요)</strong><br>
              재입고 신청 사용자가 있는 옵션에 입고 처리 시 자동으로 알림이 발송됩니다.
            </div>
          </div>

          <!-- 오늘 입고 요약 -->
          <div class="card">
            <div class="card-hdr">
              <div class="card-title">
                <div class="card-title-ico">📊</div>
                오늘 입고 요약
              </div>
              <span id="summaryDate" style="font-size:11px;color:var(--gray4);font-family:'DM Mono',monospace"></span>
            </div>
            <!-- 🚨 수정: 중복된 card-body 태그 하나로 통합 -->
            <div class="card-body" style="padding:14px 18px">
				  <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:14px">
				    <div style="text-align:center;padding:12px;background:var(--blue-lt);border-radius:8px;border:1px solid #93C5FD">
				      <div id="summaryTotalQty" style="font-family:'DM Mono',monospace;font-size:22px;font-weight:700;color:var(--blue)">0</div>
				      <div style="font-size:10px;color:var(--gray3);margin-top:3px;font-weight:600;text-transform:uppercase">총 입고 수량</div>
				    </div>
				    <div style="text-align:center;padding:12px;background:var(--green-lt);border-radius:8px;border:1px solid #6EE7B7">
				      <div id="summaryTotalCount" style="font-family:'DM Mono',monospace;font-size:22px;font-weight:700;color:var(--green)">0</div>
				      <div style="font-size:10px;color:var(--gray3);margin-top:3px;font-weight:600;text-transform:uppercase">처리 건수</div>
				    </div>
				    <div style="text-align:center;padding:12px;background:var(--amber-lt);border-radius:8px;border:1px solid #FCD34D">
				      <div id="summaryAlertCount" style="font-family:'DM Mono',monospace;font-size:22px;font-weight:700;color:var(--amber)">0</div>
				      <div style="font-size:10px;color:var(--gray3);margin-top:3px;font-weight:600;text-transform:uppercase">알림 발송</div>
				    </div>
				  </div>

              <!-- 오늘 목록 -->
              <div style="font-size:10.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px">오늘 입고 내역</div>
              <table style="width:100%;border-collapse:collapse">
                <thead>
                  <tr>
                  	<th style="padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left">시간</th>
                    <th style="padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left">상품명</th>
                    <th style="padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left">사이즈</th>
                    <th style="padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:right">수량</th>
                  </tr>
                </thead>
                <tbody id="todayInboundTbody">
                                  
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ══════════════ 입고 이력 조회 탭 ══════════════ -->
    <div id="hist-section" style="display:none">

      <!-- 필터 바 -->
      <div class="filter-bar">
		<div class="filter-group">
		    <span class="filter-label">기간</span>		    
		    <input type="date" class="date-input" id="searchStartDate">
		    <span class="date-sep">~</span>
		    <input type="date" class="date-input" id="searchEndDate">
		</div>
        <div style="width:1px;height:20px;background:var(--gray6);margin:0 4px"></div>
        <select class="sel" id="searchBrand">
          <option>전체 브랜드</option>
          <option>나이키</option><option>아디다스</option><option>퓨마</option><option>뉴발란스</option>
        </select>
        <select class="sel" id="searchStatus">
          <option>전체 상태</option>
          <option>완료</option><option>취소</option><option>대기</option>
        </select>
        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" id="searchKeyword" placeholder="입고번호, 상품명 검색">
        </div>
        <button type="button" class="btn btn-blue btn-sm" onclick="searchHistory()">조회</button>
  		<button type="button" class="btn btn-outline btn-sm" onclick="resetSearch()">초기화</button>
      </div>

      <!-- 요약 pills -->
      <div class="summary-pills">
        <div class="pill pill-total"><div class="pill-num" id="pillTotalNum">0</div>전체</div>
        <div class="pill pill-done"><div class="pill-num" id="pillDoneNum">0</div>완료</div>
        <div class="pill pill-pend"><div class="pill-num">0</div>대기</div>
        <div class="pill pill-cancel"><div class="pill-num">0</div>취소</div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">총 <strong id="totalCountDisplay">0</strong>건</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>입고 번호</th>
                <th>입고일</th>
                <th>브랜드</th>
                <th>상품명</th>
                <th>사이즈 / 컬러</th>
                <th>수량</th>
                <th>공급업체</th>
                <th>상태</th>
                <th>담당자</th>
                <th>관리</th>
              </tr>
            </thead>
            <tbody id="histTbody"></tbody>
          </table>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- ═══ UPDATE MODAL (수정용 폼) ═══ -->
<div class="modal-bg" id="updateModal">
  <div class="modal" style="max-width:500px;">
    <form id="updateForm" action="${pageContext.request.contextPath}/logistics/log_in/log_inUpdate.do" method="post">
      <!-- 🚨 서버로 넘길 진짜 PK (입고번호) -->
      <input type="hidden" id="upd_inNum" name="inNum">
      
      <div class="modal-hdr">
        <div class="modal-title">📝 입고 내역 수정</div>
        <button type="button" class="modal-x" onclick="closeUpdateModal()">✕</button>
      </div>
      
      <div class="modal-body">
        <div class="fg-grid">
          <!-- 1. 입고일 -->
          <div class="fg fg-full"><label>입고일 <span class="req">*</span></label>
            <input type="date" class="fi" id="upd_date" name="inDate" required>
          </div>
          
          <!-- 2. 상품 정보 (변경 불가 처리 - readonly) -->
          <div class="fg"><label>브랜드</label>
            <input type="text" class="fi" id="upd_brand" style="background:var(--gray7);color:var(--gray4)" readonly>
          </div>
          <div class="fg"><label>상품명</label>
            <input type="text" class="fi" id="upd_name" style="background:var(--gray7);color:var(--gray4)" readonly>
          </div>
          
          <!-- 3. 사이즈 & 컬러 -->
          <div class="fg"><label>사이즈 (mm)</label>
            <select class="fi" id="upd_size" name="sizeVal">
              <option value="225">225</option>
              <option value="230">230</option>
              <option value="235">235</option>
              <option value="240">240</option>
              <option value="245">245</option>
              <option value="250">250</option>
              <option value="255">255</option>
              <option value="260">260</option>
              <option value="265">265</option>
              <option value="270">270</option>
              <option value="275">275</option>
              <option value="280">280</option>
            </select>
          </div>
          <div class="fg"><label>컬러</label>
            <select class="fi" id="upd_color" name="color">
              <option value="화이트">화이트</option>
              <option value="블랙">블랙</option>
              <option value="그레이">그레이</option>
              <option value="네이비">네이비</option>
              <option value="베이지">베이지</option>
              <option value="레드">레드</option>
              <option value="그린">그린</option>
            </select>
          </div>

          <!-- 4. 수량 & 상태 -->
          <div class="fg"><label>입고 수량 <span class="req">*</span></label>
            <input type="number" class="fi" id="upd_qty" name="inQty" required>
          </div>
          <div class="fg"><label>상태</label>
            <select class="fi" id="upd_status" name="status">
              <option value="1">대기</option>
              <option value="2">완료</option>
              <option value="3">취소</option>
            </select>
          </div>
          
          <!-- 5. 공급업체 & 메모 -->
          <div class="fg fg-full"><label>공급업체</label>
            <select class="fi" id="upd_supplier" name="supplier">
              <option value="나이키">나이키</option>
              <option value="아디다스">아디다스</option>
              <option value="퓨마">퓨마</option>
              <option value="뉴발란스">뉴발란스</option>
            </select>
          </div>
          <div class="fg fg-full"><label>메모</label>
            <textarea class="fi" id="upd_memo" name="inMemo"></textarea>
          </div>
        </div>
      </div>
      
      <div class="modal-foot">
        <button type="button" class="btn btn-outline" onclick="closeUpdateModal()">취소</button>
        <button type="submit" class="btn btn-blue">수정 완료</button>
      </div>
    </form>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
// 1. 실시간 시계
function updateClock() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeString = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    const el = document.getElementById("realTimeClock");
    if(el) el.innerText = timeString;
}
updateClock();
setInterval(updateClock, 60000);

// 2. 데이터 초기화 (JSP -> JS)
const prods = [
  <c:forEach var="p" items="${prodList}">
    { sku: '${p.sku}', name: '${p.prodName}', brand: '${p.brandName}', prodNum: '${p.prodNum}' },
  </c:forEach>
];

function getStatusText(code) {
    if (code == '1') return '대기';
    if (code == '2') return '완료';
    if (code == '3') return '취소';
    return '완료'; // 값이 없거나 0일 때의 기본값
}

const histData = [
	  <c:forEach var="item" items="${inboundList}">
	    {
	      no: 'IN-${item.inNum}', 
	      date: '${item.inDate}', 
	      brand: '${item.brandName}', 
	      name: '${item.prodName}',
	      size: '${item.sizeVal}mm', 
	      color: '${item.color}', 
	      qty: ${item.inQty}, 
	      supplier: '${item.supplier}',
	      
	      // 💡 여기가 핵심! 숫자로 넘어온 값을 위 함수를 거쳐서 글자로 바꿔 담습니다.
	      status: getStatusText('${item.inStatus}'), 
	      
	      manager: '${item.userName}', 
	      memo: '${item.inMemo}'
	    },
	  </c:forEach>
	];

const statusBdg = { '완료': '<span class="bdg bdg-green">완료</span>', '대기': '<span class="bdg bdg-amber">대기</span>', '취소': '<span class="bdg bdg-red">취소</span>' };

// 3. 날짜 포맷 함수
function getTodayStr() {
    const now = new Date();
    return now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
}

function initDates() {
    const todayStr = getTodayStr();
    const lastMonth = new Date();
    lastMonth.setMonth(lastMonth.getMonth() - 1);
    const lastMonthStr = lastMonth.getFullYear() + '-' + String(lastMonth.getMonth() + 1).padStart(2, '0') + '-' + String(lastMonth.getDate()).padStart(2, '0');

    const fiDate = document.getElementById('fi-date');
    if(fiDate) fiDate.value = todayStr;

    const summaryDate = document.getElementById('summaryDate');
    if(summaryDate) summaryDate.innerText = todayStr;

    const sDate = document.getElementById('searchStartDate');
    const eDate = document.getElementById('searchEndDate');
    if(sDate) sDate.value = lastMonthStr;
    if(eDate) eDate.value = todayStr;
}

// 4. 오늘 입고 요약 렌더링 (시간 T 포함 해결본)
function renderTodayDashboard() {
    const today = getTodayStr();
    const todayData = histData.filter(d => d.date.startsWith(today));
    
    let totalQty = 0;
    todayData.forEach(d => { totalQty += d.qty; });
    
    const qtyEl = document.getElementById('summaryTotalQty') || document.getElementById('summary-total-qty');
    const cntEl = document.getElementById('summaryTotalCount') || document.getElementById('summary-total-count');
    const badgeEl = document.getElementById('todayCountBadge') || document.getElementById('todayCount');
    
    if(qtyEl) qtyEl.innerText = totalQty;
    if(cntEl) cntEl.innerText = todayData.length;
    if(badgeEl) badgeEl.innerText = todayData.length;

    const tbody = document.getElementById('todayInboundTbody');
    if(tbody) {
        if(todayData.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:20px; color:var(--gray4);">오늘 입고 내역이 없습니다.</td></tr>';
        } else {
            tbody.innerHTML = todayData.map(d => {
                let time = '--:--';
                if (d.date.includes(' ')) {
                    time = d.date.split(' ')[1].substring(0, 5);
                } else if (d.date.includes('T')) {
                    time = d.date.split('T')[1].substring(0, 5);
                } else if (d.date.length >= 16) {
                    time = d.date.substring(11, 16);
                }
                return '<tr>'
                    + '<td style="padding:9px 10px;border-bottom:1px solid var(--gray7);font-family:\'DM Mono\',monospace;font-size:11px;color:var(--gray3)">' + time + '</td>'
                    + '<td style="padding:9px 10px;border-bottom:1px solid var(--gray7);font-size:12px">' + d.name + '</td>'
                    + '<td style="padding:9px 10px;border-bottom:1px solid var(--gray7);font-size:11px;font-family:\'DM Mono\',monospace">' + d.size + '</td>'
                    + '<td style="padding:9px 10px;border-bottom:1px solid var(--gray7);text-align:right"><span class="bdg bdg-blue">' + d.qty + '개</span></td>'
                    + '</tr>';
            }).join('');
        }
    }
}

// 5. 이력 조회 리스트 렌더링 (수정 모달 연결 완벽 처리)
function renderHistList(data) {
    const histTbody = document.getElementById('histTbody');
    if(!histTbody) return;
    
    histTbody.innerHTML = data.map(d => `
        <tr class="tbl-row" onclick="openUpdateModal('\${d.no}')">
          <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--blue);font-weight:600">\${d.no}</td>
          <td style="font-size:12px">\${d.date.substring(0, 10)}</td>
          <td>\${d.brand}</td>
          <td style="font-weight:600">\${d.name}</td>
          <td><span class="bdg bdg-gray">\${d.size}</span> \${d.color}</td>
          <td style="font-weight:700">\${d.qty}개</td>
          <td style="font-size:12px">\${d.supplier || '-'}</td>
          <td>\${statusBdg[d.status] || ''}</td>
          <td>\${d.manager}</td>
          <td onclick="event.stopPropagation()">
            <button type="button" class="btn btn-xs btn-outline" onclick="openUpdateModal('\${d.no}')">수정</button>
            <button type="button" class="btn btn-xs btn-danger" onclick="deleteHist('\${d.no}')">삭제</button>
          </td>
        </tr>`).join('');

	    const pillTotal = document.querySelector('.pill-total .pill-num');
	    const pillDone = document.querySelector('.pill-done .pill-num');
	    const pillPend = document.querySelector('.pill-pend .pill-num');
	    const pillCancel = document.querySelector('.pill-cancel .pill-num');
	    const totalDisplay = document.getElementById('totalCountDisplay');
	
	    if(pillTotal) pillTotal.innerText = data.length;
	    if(totalDisplay) totalDisplay.innerText = data.length;
	    
	    // data.filter 를 돌려서 각각의 상태 개수를 정확히 꽂아줍니다.
	    if(pillDone) pillDone.innerText = data.filter(x => x.status === '완료').length;
	    if(pillPend) pillPend.innerText = data.filter(x => x.status === '대기').length;
	    if(pillCancel) pillCancel.innerText = data.filter(x => x.status === '취소').length;

}

// 6. 검색 로직
function searchHistory() {
    const sDate = document.getElementById('searchStartDate')?.value;
    const eDate = document.getElementById('searchEndDate')?.value;
    const brand = document.getElementById('searchBrand')?.value;
    const keyword = document.getElementById('searchKeyword')?.value.trim().toLowerCase();

    const filtered = histData.filter(d => {
        let dDateOnly = d.date;
        if(d.date.includes(' ')) dDateOnly = d.date.split(' ')[0];
        else if(d.date.includes('T')) dDateOnly = d.date.split('T')[0];
        else dDateOnly = d.date.substring(0, 10);

        if (sDate && dDateOnly < sDate) return false;
        if (eDate && dDateOnly > eDate) return false;
        if (brand && brand !== '전체 브랜드' && d.brand !== brand) return false;
        if (keyword && !d.name.toLowerCase().includes(keyword) && !d.no.toLowerCase().includes(keyword)) return false;
        return true;
    });

    renderHistList(filtered);
}

// 7. 탭 전환
function switchMain(tab) {
    const isReg = tab === 'reg';
    const regSec = document.getElementById('reg-section');
    const histSec = document.getElementById('hist-section');
    
    if(regSec) regSec.style.display = isReg ? '' : 'none';
    if(histSec) histSec.style.display = isReg ? 'none' : '';
    
    const regBtn = document.getElementById('tab-reg-btn');
    const histBtn = document.getElementById('tab-hist-btn');
    if(regBtn) regBtn.classList.toggle('on', isReg);
    if(histBtn) histBtn.classList.toggle('on', !isReg);
    
    if(!isReg) searchHistory();
}

// 8. 수정 모달 열기/닫기
function openUpdateModal(no) {
    const d = histData.find(x => x.no === no);
    if(!d) return;

    // 모달에 값 세팅
    document.getElementById('upd_inNum').value = d.no.replace('IN-', '');
    
    let dateVal = d.date;
    if(d.date.includes(' ')) dateVal = d.date.split(' ')[0];
    else if(d.date.includes('T')) dateVal = d.date.split('T')[0];
    else dateVal = d.date.substring(0, 10);
    document.getElementById('upd_date').value = dateVal;
    
    document.getElementById('upd_brand').value = d.brand;
    document.getElementById('upd_name').value = d.name;    
    const sizeEl = document.getElementById('upd_size');
    if(sizeEl) sizeEl.value = d.size.replace('mm', '');
    const colorEl = document.getElementById('upd_color');
    if(colorEl) colorEl.value = d.color;    
    document.getElementById('upd_qty').value = d.qty;
    
    const statusEl = document.getElementById('upd_status');
    if(statusEl) {
        if(d.status === '대기') statusEl.value = "1";
        else if(d.status === '완료') statusEl.value = "2";
        else if(d.status === '취소') statusEl.value = "3";
    }
    
    const supplierEl = document.getElementById('upd_supplier');
    if(supplierEl) supplierEl.value = d.supplier || '';
    
    document.getElementById('upd_memo').value = d.memo || '';

    document.getElementById('updateModal').classList.add('open');
}

function closeUpdateModal() {
    document.getElementById('updateModal').classList.remove('open');
}

document.getElementById('updateModal').addEventListener('click', function(e) {
    if(e.target === e.currentTarget) closeUpdateModal();
});

// 9. 삭제 함수
function deleteHist(no) {
    const inNum = no.replace('IN-', '');
    if (confirm(no + ' 입고 내역을 정말 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.')) {
        saveSearchState(); // 👈 삭제 요청 보내기 직전에 날짜 킵(Keep)!
        window.location.href = '${pageContext.request.contextPath}/logistics/log_in/log_inDelete.do?inNum=' + inNum;
    }
}

// 수정 완료 버튼 누를 때도 날짜 저장하기!
const updateForm = document.getElementById('updateForm');
if(updateForm) {
    updateForm.addEventListener('submit', function() {
        saveSearchState(); // 👈 수정 폼이 전송되기 직전에 날짜 킵(Keep)!
    });
}
function saveSearchState() {
    const sDate = document.getElementById('searchStartDate');
    const eDate = document.getElementById('searchEndDate');
    if(sDate) sessionStorage.setItem('log_sDate', sDate.value);
    if(eDate) sessionStorage.setItem('log_eDate', eDate.value);
}

// 10. 기존 상품 검색 및 초기화 기능
function searchProd(q) {
  const drop = document.getElementById('searchDrop');
  if(!q) { drop.style.display='none'; return; }
  const matched = prods.filter(p => p.name.includes(q) || p.sku.toLowerCase().includes(q.toLowerCase()) || p.brand.includes(q));
  if(!matched.length) { drop.style.display='none'; return; }
  drop.innerHTML = matched.map(p => `
    <div onclick="selectProd('\${p.sku}')" style="padding:10px 14px;cursor:pointer;border-bottom:1.5px solid var(--gray7);display:flex;align-items:center;gap:10px">
      <span style="font-size:18px">👟</span>
      <div><div style="font-size:13px;font-weight:600;color:var(--gray1)">\${p.name}</div><div style="font-size:11px;font-family:'DM Mono',monospace;color:var(--gray3)">\${p.sku} · \${p.brand}</div></div>
    </div>`).join('');
  drop.style.display = 'block';
}

function selectProd(sku) {
  const p = prods.find(x => x.sku === sku);
  if(!p) return;
  document.getElementById('searchDrop').style.display = 'none';
  document.getElementById('searchWrapDiv').style.display = 'none';
  document.getElementById('hidden_prodNum').value = p.prodNum; 
  document.getElementById('selProdName').textContent = p.name;
  document.getElementById('selProdSku').textContent  = p.sku;
  document.getElementById('selProdBrand').textContent = p.brand;
  document.getElementById('selectedProdWrap').style.display = 'block';
}

function clearProd() {
  document.getElementById('prodSearch').value = '';
  document.getElementById('searchWrapDiv').style.display = 'block';
  document.getElementById('selectedProdWrap').style.display = 'none';
  document.getElementById('hidden_prodNum').value = '';
}

const selSizes = new Set();
function selSize(el) {
  el.classList.toggle('on');
  const mm = el.textContent;
  selSizes.has(mm) ? selSizes.delete(mm) : selSizes.add(mm);
  document.getElementById('selSizeTxt').textContent = selSizes.size ? [...selSizes].sort((a,b) => a-b).join(', ') + 'mm' : '없음';
}

function resetForm() {
  ['fi-color','fi-qty','fi-memo','fi-supplier'].forEach(id => { 
      const el = document.getElementById(id); if(el) el.value=''; 
  });
  const fiDate = document.getElementById('fi-date');
  if(fiDate) fiDate.value = getTodayStr();
  clearProd();
  selSizes.clear();
  document.querySelectorAll('.chip').forEach(c => c.classList.remove('on'));
  document.getElementById('selSizeTxt').textContent = '없음';
}

function submitInbound() {
  const prodNum = document.getElementById('hidden_prodNum').value;
  const color = document.getElementById('fi-color').value;
  const qty = document.getElementById('fi-qty').value;
  
  if(!prodNum) { showToast('⚠ 입고할 상품을 검색 후 선택해주세요.', true); return; }
  if(!color || !qty || selSizes.size === 0) { showToast('⚠ 필수 항목을 모두 입력하세요.', true); return; }

  const sizeArr = Array.from(selSizes);
  document.getElementById('hidden_sizes').value = sizeArr.join(',');

  if(confirm(`총 \${sizeArr.length}개의 사이즈 옵션에 각각 \${qty}개씩 입고 처리하시겠습니까?`)) {
    showToast('✅ 성공적으로 입고 처리가 완료되었습니다!');
    setTimeout(function() { document.getElementById('inboundForm').submit(); }, 1500);
  }
}

function showToast(msg, warn) {
  const t = document.getElementById('toast');
  if(!t) return;
  t.textContent = msg; t.style.background = warn ? 'var(--amber)' : 'var(--gray1)';
  t.classList.add('show'); setTimeout(() => t.classList.remove('show'), 2800);
}

// 🚨 페이지 로드 시 최우선 실행
window.addEventListener('load', function() {
    initDates(); //기본 세팅 (오늘~한달전)

    const urlParams = new URLSearchParams(window.location.search);
    const result = urlParams.get('result');

    //삭제나 수정 후에 돌아온 거라면 브라우저 기억을 되살립니다
    if(result === 'deleted' || result === 'updated' || result === 'opt_error') {
        const savedSDate = sessionStorage.getItem('log_sDate');
        const savedEDate = sessionStorage.getItem('log_eDate');
        
        // 기억해둔 날짜가 있으면 화면 달력에 다시 꽂아줌
        if(savedSDate && savedEDate) {
            document.getElementById('searchStartDate').value = savedSDate;
            document.getElementById('searchEndDate').value = savedEDate;
        }
        
        // 한 번 복구했으니 기억은 깨끗하게 지워줍니다.
        sessionStorage.removeItem('log_sDate');
        sessionStorage.removeItem('log_eDate');
    }

    renderTodayDashboard();
    searchHistory(); //복구된 날짜를 바탕으로 리스트를 다시 그립니다.

    // 기존의 알림 및 탭 전환 로직
    if(result === 'updated') {
        alert('✅ 수정이 완료되었습니다.');
        window.history.replaceState({}, document.title, window.location.pathname);
        switchMain('hist'); 
    } else if (result === 'deleted') {
        alert('🗑️ 입고 내역이 성공적으로 삭제되었습니다.');
        window.history.replaceState({}, document.title, window.location.pathname);
        switchMain('hist'); 
    } else if (result === 'opt_error') {
        alert('❌ 선택하신 사이즈/컬러 옵션이 존재하지 않습니다.');
        window.history.replaceState({}, document.title, window.location.pathname);
        switchMain('hist'); 
    }
});
</script>
</body>
</html>