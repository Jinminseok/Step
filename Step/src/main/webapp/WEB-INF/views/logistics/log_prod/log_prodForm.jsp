<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 마스터 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>

/* ═══ MAIN ═════════════════════════════════════ */
.main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}

/* ═══ BODY LAYOUT ═══════════════════════════════ */
.body-wrap{flex:1;display:flex;overflow:hidden;position:relative}
.body-wrap{flex:1;overflow-y:auto;padding:24px}
.body-wrap::-webkit-scrollbar{width:5px}
.body-wrap::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ─── LIST PANEL ────────────────────────────────── */
.list-panel{
  display:flex;flex-direction:column;
  background:var(--bg);
  transition:width .3s cubic-bezier(.4,0,.2,1);
  width:100%;
  overflow:hidden;
  flex-shrink:0;
}
.list-panel.shrunk{width:calc(100% - 560px)}

.list-toolbar{
  display:flex;align-items:center;gap:8px;
  padding:14px 18px;background:var(--white);
  border-bottom:1px solid var(--gray6);flex-shrink:0;
  flex-wrap:wrap;
}
.search-wrap{position:relative;flex:1;min-width:180px;max-width:260px}
.search-wrap input{
  width:100%;padding:8px 12px 8px 32px;
  border:1px solid var(--gray5);background:var(--white);border-radius:6px;
  font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;
  transition:border .15s;
}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{
  padding:7px 10px;border:1px solid var(--gray5);background:var(--white);
  font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);
  outline:none;border-radius:6px;cursor:pointer;
}
.btn{
  padding:7px 14px;border:none;border-radius:6px;
  font-size:12px;font-weight:700;cursor:pointer;
  font-family:'Pretendard',sans-serif;transition:all .15s;
  display:inline-flex;align-items:center;gap:5px;
}
.btn-blue{background:var(--blue);color:#fff}
.btn-blue:hover{background:var(--navy2)}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--gray5)}
.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-danger{background:var(--red-lt);color:var(--red);border:1px solid #FECACA}
.btn-danger:hover{background:var(--red);color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px}

/* TABLE */
.tbl-outer{flex:1;overflow-y:auto}
.tbl-outer::-webkit-scrollbar{width:4px}
.tbl-outer::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:2px}
table{width:100%;border-collapse:collapse;background:var(--white)}
thead{position:sticky;top:0;z-index:10}
th{
  padding:10px 14px;font-size:10px;font-weight:700;
  color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;
  background:var(--gray7);border-bottom:1px solid var(--gray6);
  text-align:left;white-space:nowrap;
}
td{
  padding:13px 14px;border-bottom:1px solid var(--gray7);
  font-size:12.5px;color:var(--gray2);vertical-align:middle;
}
tr:last-child td{border-bottom:none}

.prod-row{cursor:pointer;transition:background .12s}
.prod-row:hover td{background:#F5F8FF}
.prod-row.selected td{background:var(--blue-lt)}
.prod-row.selected td:first-child{
  border-left:3px solid var(--blue);
  padding-left:11px;
}
td:first-child{border-left:3px solid transparent;padding-left:11px}

/* BADGES */
.bdg{
  display:inline-flex;align-items:center;padding:2px 8px;
  border-radius:100px;font-size:10px;font-weight:700;white-space:nowrap;
}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}

/* PROGRESS */
.prog-wrap{display:flex;align-items:center;gap:6px}
.prog-track{flex:1;height:4px;background:var(--gray6);border-radius:2px;overflow:hidden;min-width:50px}
.prog-fill{height:100%;border-radius:2px}
.prog-ok{background:var(--blue)}
.prog-warn{background:var(--amber)}
.prog-low{background:var(--red)}
.prog-num{font-family:'DM Mono',monospace;font-size:10px;color:var(--gray3);width:30px;text-align:right;flex-shrink:0}

/* LIST FOOTER */
.list-footer{
  padding:10px 18px;border-top:1px solid var(--gray6);background:var(--white);
  display:flex;align-items:center;justify-content:space-between;flex-shrink:0;
}
.list-footer-info{font-size:11px;color:var(--gray4)}
.pagination{display:flex;gap:4px}
.pg-btn{
  width:28px;height:28px;border:1px solid var(--gray5);border-radius:5px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;
  font-size:11px;font-weight:600;color:var(--gray3);background:var(--white);
  transition:all .15s;
}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* ─── DETAIL PANEL ───────────────────────────────── */
.detail-panel{
  width:0;overflow:hidden;flex-shrink:0;
  display:flex;flex-direction:column;
  border-left:1px solid var(--gray6);background:var(--white);
  transition:width .3s cubic-bezier(.4,0,.2,1);
  position:relative;
}
.detail-panel.open{width:560px}

/* DETAIL HEADER */
.dp-hdr{
  height:50px;background:var(--navy);
  display:flex;align-items:center;padding:0 18px;gap:10px;
  flex-shrink:0;white-space:nowrap;overflow:hidden;
}
.dp-hdr-ico{
  width:28px;height:28px;background:rgba(255,255,255,.1);border-radius:5px;
  display:flex;align-items:center;justify-content:center;font-size:12px;flex-shrink:0;
}
.dp-hdr-title{font-size:13.5px;font-weight:700;color:#fff;flex:1;overflow:hidden;text-overflow:ellipsis}
.dp-hdr-sku{font-size:10px;font-family:'DM Mono',monospace;color:rgba(255,255,255,.4);padding:2px 7px;background:rgba(255,255,255,.07);border-radius:3px;white-space:nowrap}
.dp-close{
  width:28px;height:28px;border:none;background:rgba(255,255,255,.08);
  border-radius:5px;color:rgba(255,255,255,.6);font-size:14px;cursor:pointer;
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
  transition:all .15s;
}
.dp-close:hover{background:rgba(255,255,255,.16);color:#fff}

/* DETAIL TABS */
.dp-tabs{
  display:flex;border-bottom:2px solid var(--gray6);flex-shrink:0;
  background:var(--bg2);overflow:hidden;
}
.dp-tab{
  padding:9px 16px;font-size:11.5px;font-weight:600;color:var(--gray4);
  cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;
  transition:all .15s;text-transform:uppercase;letter-spacing:.05em;
  white-space:nowrap;
}
.dp-tab.on{color:var(--blue);border-bottom-color:var(--blue)}
.dp-tab:hover{color:var(--gray2)}

/* DETAIL BODY */
.dp-body{flex:1;overflow-y:auto;padding:20px}
.dp-body::-webkit-scrollbar{width:4px}
.dp-body::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:2px}

/* SECTION GROUP */
.dp-section{margin-bottom:22px}
.dp-section-title{
  font-size:10px;font-weight:700;color:var(--gray3);
  text-transform:uppercase;letter-spacing:.1em;
  margin-bottom:12px;padding-bottom:8px;
  border-bottom:1px solid var(--gray7);
  display:flex;align-items:center;gap:6px;
}
.dp-section-title::before{
  content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block;
}

/* FORM GRID */
.fg-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.fg-full{grid-column:1/-1}
.fg{display:flex;flex-direction:column;gap:5px}
.fg label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.fi{
  padding:9px 11px;border:1px solid var(--gray5);background:var(--white);
  border-radius:6px;font-size:12.5px;font-family:'Pretendard',sans-serif;
  color:var(--gray1);outline:none;width:100%;transition:border .15s;
}
.fi:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.fi::placeholder{color:var(--gray4)}
.fi:read-only{background:var(--gray7);color:var(--gray3);cursor:default}
select.fi option{background:var(--white)}
textarea.fi{resize:vertical;min-height:72px}

/* IMAGE ZONE */
.img-zone{
  border:2px dashed var(--gray5);border-radius:8px;
  height:130px;display:flex;flex-direction:column;
  align-items:center;justify-content:center;gap:6px;
  cursor:pointer;transition:all .18s;background:var(--bg2);
}
.img-zone:hover{border-color:var(--blue);background:var(--blue-lt)}
.img-zone-ico{font-size:24px;color:var(--gray4)}
.img-zone-txt{font-size:11px;color:var(--gray4);font-weight:500}
.img-zone-sub{font-size:10px;color:var(--gray5)}

/* IMAGE PREVIEWS */
.img-previews{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
.img-thumb{
  width:64px;height:64px;border-radius:6px;
  background:var(--gray7);border:1px solid var(--gray5);
  display:flex;align-items:center;justify-content:center;
  font-size:22px;position:relative;overflow:hidden;cursor:pointer;
  transition:border .15s;
}
.img-thumb:hover{border-color:var(--blue)}
.img-thumb.main-img{border:2px solid var(--blue)}
.img-thumb-del{
  position:absolute;top:3px;right:3px;width:15px;height:15px;
  background:var(--red);border-radius:50%;color:#fff;font-size:8px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;
  font-weight:700;opacity:0;transition:opacity .15s;
}
.img-thumb:hover .img-thumb-del{opacity:1}
.img-main-badge{
  position:absolute;bottom:0;left:0;right:0;background:var(--blue);
  color:#fff;font-size:9px;font-weight:700;text-align:center;padding:2px;
  letter-spacing:.05em;
}

/* CHIPS */
.chip-row{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px}
.chip{
  padding:5px 11px;border:1.5px solid var(--gray5);border-radius:5px;
  font-size:11.5px;cursor:pointer;font-family:'Pretendard',sans-serif;
  font-weight:500;background:var(--white);color:var(--gray3);transition:all .15s;
}
.chip.on{border-color:var(--blue);color:var(--blue);background:var(--blue-lt);font-weight:700}
.chip:hover:not(.on){border-color:var(--gray3);color:var(--gray2)}
.chip.color-chip{display:flex;align-items:center;gap:5px}
.color-dot{width:10px;height:10px;border-radius:50%;border:1px solid rgba(0,0,0,.1);flex-shrink:0}

/* STOCK TABLE */
.stock-mini-table{width:100%;border-collapse:collapse}
.stock-mini-table th{
  padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);
  text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);
  border-bottom:1px solid var(--gray6);text-align:left;
}
.stock-mini-table td{
  padding:9px 10px;font-size:12px;color:var(--gray2);
  border-bottom:1px solid var(--gray7);
}
.stock-mini-table tr:last-child td{border-bottom:none}
.stock-mini-table .qty-ok{color:var(--gray1);font-weight:600;font-family:'DM Mono',monospace}
.stock-mini-table .qty-warn{color:var(--amber);font-weight:700;font-family:'DM Mono',monospace}
.stock-mini-table .qty-low{color:var(--red);font-weight:700;font-family:'DM Mono',monospace}
.stock-input{
  width:70px;padding:5px 8px;border:1px solid var(--gray5);
  background:var(--white);border-radius:5px;font-size:12px;
  font-family:'DM Mono',monospace;color:var(--gray1);outline:none;text-align:right;
}
.stock-input:focus{border-color:var(--blue)}

/* DETAIL FOOTER */
.dp-footer{
  padding:12px 20px;border-top:1px solid var(--gray6);background:var(--bg2);
  display:flex;gap:8px;justify-content:flex-end;flex-shrink:0;
}

/* ─── REVIEW SECTION (Tab) ────── */
.review-item{
  border:1px solid var(--gray6);border-radius:6px;padding:12px;
  margin-bottom:10px;background:var(--bg2);
}
.review-hdr{display:flex;align-items:center;gap:8px;margin-bottom:8px}
.review-av{
  width:28px;height:28px;border-radius:50%;
  background:var(--navy2);display:flex;align-items:center;
  justify-content:center;font-size:11px;font-weight:700;color:#fff;flex-shrink:0;
}
.review-user{font-size:12px;font-weight:600;color:var(--gray1)}
.review-date{font-size:10px;color:var(--gray4);margin-left:auto}
.review-stars{color:var(--amber);font-size:12px;letter-spacing:1px}
.review-body{font-size:12px;color:var(--gray2);line-height:1.6}

/* TOOLTIP */
.tooltip{
  position:absolute;background:var(--gray1);color:#fff;
  font-size:11px;padding:5px 10px;border-radius:4px;pointer-events:none;
  white-space:nowrap;z-index:999;opacity:0;transform:translateY(4px);
  transition:all .15s;
}
.tooltip.show{opacity:1;transform:translateY(0)}

/* PANEL TAB CONTENT */
.dp-tab-content{display:none}
.dp-tab-content.active{display:block}

/* CONTENT */
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* 🚨 추가된 TOAST 알림 스타일 🚨 */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/log_header.jsp" />

	<!-- ═══ MAIN ═══ -->
<main class="main">

  <!-- TOPBAR -->
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur" id="pg-title">상품 마스터 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
    </div>
  </div>

  <!-- BODY -->
  <div class="body-wrap">

    <!-- ─── LIST PANEL ─── -->
    <div class="list-panel" id="listPanel">
      
      <!-- TOOLBAR -->
      <div class="list-toolbar">
        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" placeholder="품번·상품명·브랜드 검색" oninput="filterTable(this.value)">
        </div>
        <select class="sel" onchange="filterTable()">
          <option>전체 브랜드</option>
          <option>나이키</option>
          <option>아디다스</option>
          <option>뉴발란스</option>
          <option>호카</option>
          <option>버켄스탁</option>
        </select>
        <select class="sel">
          <option>전체 상태</option>
          <option>판매중</option>
          <option>재고주의</option>
          <option>품절</option>
          <option>숨김</option>
        </select>
        
        <!-- 오른쪽 버튼 영역 및 동기화 시간 -->
        <div style="margin-left:auto; display:flex; align-items:center; gap:12px;">
          <!-- 동기화 시간 표시 영역 -->
          <div id="syncTime" style="font-size:11px; color:var(--gray4); font-family:'DM Mono',monospace;">최종 동기화: -</div>
          
          <!-- 버튼 그룹 -->
          <div style="display:flex; gap:7px;">
            <button class="btn btn-outline btn-sm" onclick="updateSyncTime()">🔄 상품 동기화</button>
            <button class="btn btn-blue btn-sm" onclick="openNew()">＋ 상품 등록</button>
          </div>
        </div>
      </div>

      <!-- TABLE -->
      <div class="tbl-outer">
        <table id="prodTable">
          <thead>
            <tr>
              <th style="width:36px"><input type="checkbox" onchange="toggleAll(this)"></th>
              <th>품번 (SKU)</th>
              <th>브랜드</th>
              <th>상품명</th>
              <th>카테고리</th>
              <th>사이즈 범위</th>
              <th>컬러</th>
              <th>총 재고</th>
              <th>재고율</th>
              <th>상태</th>
              <th>관리</th>
            </tr>
          </thead>
          <tbody id="prodTbody">
          </tbody>
        </table>
      </div>

      <!-- FOOTER -->
      <div class="list-footer">
        <div class="list-footer-info">총 <strong>12</strong>개 상품 · 선택 <strong id="selCount">0</strong>개</div>
        <div class="pagination">
          <div class="pg-btn">‹</div>
          <div class="pg-btn on">1</div>
          <div class="pg-btn">2</div>
          <div class="pg-btn">3</div>
          <div class="pg-btn">›</div>
        </div>
      </div>
    </div>

    <!-- ─── DETAIL PANEL ─── -->
    <div class="detail-panel" id="detailPanel">
      <!-- HEADER -->
      <div class="dp-hdr">
        <div class="dp-hdr-ico" id="dpIco">📑</div>
        <div class="dp-hdr-title" id="dpTitle">상품 상세정보</div>
        <div class="dp-hdr-sku" id="dpSku"></div>
        <button class="dp-close" onclick="closeDetail()">✕</button>
      </div>

      <!-- TABS -->
      <div class="dp-tabs">
        <div class="dp-tab on" onclick="switchTab(this,'tab-info')">기본 정보</div>
        <div class="dp-tab" onclick="switchTab(this,'tab-stock')">옵션 / 재고</div>
        <div class="dp-tab" onclick="switchTab(this,'tab-review')">리뷰</div>
      </div>

      <!-- BODY -->
      <div class="dp-body">

        <!-- TAB: 기본 정보 -->
        <div class="dp-tab-content active" id="tab-info">

          <div class="dp-section">
            <div class="dp-section-title">상품 이미지</div>
            <div style="display:flex;gap:10px;align-items:flex-start">
              <div style="flex:1">
                <div class="img-previews" id="imgPreviews">
                  <div class="img-thumb main-img">👟<div class="img-main-badge">대표</div><div class="img-thumb-del">✕</div></div>
                  <div class="img-thumb">👟<div class="img-thumb-del">✕</div></div>
                  <div class="img-thumb">👟<div class="img-thumb-del">✕</div></div>
                  <div class="img-zone" style="width:64px;height:64px;border-radius:6px;font-size:18px;gap:2px" onclick="document.getElementById('fileInput').click()">
                    <span style="color:var(--gray4);font-size:20px">＋</span>
                  </div>
                </div>
                <div style="font-size:10px;color:var(--gray4);margin-top:6px">첫 번째 이미지가 대표 이미지로 설정됩니다.</div>
              </div>
            </div>
            <input type="file" id="fileInput" accept="image/*" multiple style="display:none">
          </div>

          <div class="dp-section">
            <div class="dp-section-title">기본 정보</div>
            <div class="fg-grid">
              
              <!-- 🚨 변경된 부분: 상품 고유코드(SKU) 자동 생성 버튼 추가 🚨 -->
              <div class="fg">
                <label>상품 고유코드 (SKU) <span style="color:var(--red)">*</span></label>
                <div style="display:flex; gap:6px;">
                  <input class="fi" id="fi-sku" placeholder="예: NK-AM270-GRY">
                  <button type="button" class="btn btn-outline" style="flex-shrink:0; padding:9px 12px;" onclick="generateSKU()">자동 생성</button>
                </div>
              </div>

              <div class="fg">
                <label>품번 등록일</label>
                <input class="fi" id="fi-regdate" value="" readonly style="background:var(--gray7);color:var(--gray3)">
              </div>
              <div class="fg fg-full">
                <label>상품명 <span style="color:var(--red)">*</span></label>
                <input class="fi" id="fi-name" placeholder="상품명을 입력하세요">
              </div>
              <div class="fg">
                <label>브랜드 <span style="color:var(--red)">*</span></label>
                <select class="fi" id="fi-brand">
                  <option value="">브랜드 선택</option>
                  <option value="나이키">나이키</option>
                  <option value="아디다스">아디다스</option>
                  <option value="뉴발란스">뉴발란스</option>
                  <option value="호카">호카</option>
                  <option value="버켄스탁">버켄스탁</option>
                </select>
              </div>
              <div class="fg">
                <label>카테고리 <span style="color:var(--red)">*</span></label>
                <select class="fi" id="fi-cat">
                  <option value="">카테고리 선택</option>
                  <option>운동화</option>
                  <option>러닝화</option>
                  <option>농구화</option>
                  <option>샌들</option>
                  <option>부츠</option>
                </select>
              </div>
              <div class="fg">
                <label>정가 (원) <span style="color:var(--red)">*</span></label>
                <input class="fi" id="fi-price" type="number" placeholder="0">
              </div>
              <div class="fg">
                <label>할인율 (%)</label>
                <input class="fi" id="fi-sale" type="number" placeholder="0" min="0" max="100">
              </div>
              <div class="fg">
                <label>성별</label>
                <select class="fi" id="fi-gender">
                  <option value="0">공용</option>
                  <option value="1">남성</option>
                  <option value="2">여성</option>
                </select>
              </div>
              <div class="fg">
                <label>판매 상태</label>
                <select class="fi" id="fi-status">
                  <option value="1">판매중</option>
                  <option value="2">숨김</option>
                  <option value="3">품절</option>
                </select>
              </div>
              <div class="fg fg-full">
                <label>상품 설명</label>
                <textarea class="fi" id="fi-desc" placeholder="상품에 대한 상세 설명을 입력하세요"></textarea>
              </div>
            </div>
          </div>

          <div class="dp-section">
            <div class="dp-section-title">컬러 옵션</div>
            <div class="chip-row" id="colorChips">
              <div class="chip color-chip on" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#fff;border-color:#ccc"></div>화이트</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#111"></div>블랙</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#888"></div>그레이</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#c8a87a"></div>베이지</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#2255aa"></div>네이비</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#cc2222"></div>레드</div>
              <div class="chip color-chip" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#44aa44"></div>그린</div>
            </div>
          </div>

          <div class="dp-section">
            <div class="dp-section-title">사이즈 옵션 (mm)</div>
            <div class="chip-row" id="sizeChips">
              <div class="chip" onclick="this.classList.toggle('on')">220</div>
              <div class="chip" onclick="this.classList.toggle('on')">225</div>
              <div class="chip on" onclick="this.classList.toggle('on')">230</div>
              <div class="chip on" onclick="this.classList.toggle('on')">235</div>
              <div class="chip on" onclick="this.classList.toggle('on')">240</div>
              <div class="chip on" onclick="this.classList.toggle('on')">245</div>
              <div class="chip on" onclick="this.classList.toggle('on')">250</div>
              <div class="chip on" onclick="this.classList.toggle('on')">255</div>
              <div class="chip on" onclick="this.classList.toggle('on')">260</div>
              <div class="chip on" onclick="this.classList.toggle('on')">265</div>
              <div class="chip on" onclick="this.classList.toggle('on')">270</div>
              <div class="chip" onclick="this.classList.toggle('on')">275</div>
              <div class="chip" onclick="this.classList.toggle('on')">280</div>
              <div class="chip" onclick="this.classList.toggle('on')">285</div>
            </div>
          </div>
        </div>

        <!-- TAB: 옵션 / 재고 -->
        <div class="dp-tab-content" id="tab-stock">
          <div class="dp-section">
            <div class="dp-section-title">컬러 × 사이즈별 재고 현황</div>
            <table class="stock-mini-table">
              <thead>
                <tr><th>컬러</th><th>사이즈</th><th>현재 재고</th><th>부족기준</th><th>상태</th><th>수정</th></tr>
              </thead>
              <tbody>
                <tr><td><span class="bdg bdg-gray">화이트</span></td><td style="font-family:'DM Mono',monospace">240mm</td><td class="qty-low">3</td><td>10</td><td><span class="bdg bdg-red">부족</span></td><td><input class="stock-input" value="3" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">화이트</span></td><td style="font-family:'DM Mono',monospace">245mm</td><td class="qty-low">2</td><td>10</td><td><span class="bdg bdg-red">부족</span></td><td><input class="stock-input" value="2" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">화이트</span></td><td style="font-family:'DM Mono',monospace">250mm</td><td class="qty-warn">8</td><td>10</td><td><span class="bdg bdg-amber">주의</span></td><td><input class="stock-input" value="8" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">화이트</span></td><td style="font-family:'DM Mono',monospace">255mm</td><td class="qty-ok">24</td><td>10</td><td><span class="bdg bdg-green">정상</span></td><td><input class="stock-input" value="24" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">화이트</span></td><td style="font-family:'DM Mono',monospace">260mm</td><td class="qty-ok">18</td><td>10</td><td><span class="bdg bdg-green">정상</span></td><td><input class="stock-input" value="18" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">그레이</span></td><td style="font-family:'DM Mono',monospace">255mm</td><td class="qty-ok">12</td><td>10</td><td><span class="bdg bdg-green">정상</span></td><td><input class="stock-input" value="12" type="number" min="0"></td></tr>
                <tr><td><span class="bdg bdg-gray">그레이</span></td><td style="font-family:'DM Mono',monospace">260mm</td><td class="qty-ok">19</td><td>10</td><td><span class="bdg bdg-green">정상</span></td><td><input class="stock-input" value="19" type="number" min="0"></td></tr>
              </tbody>
            </table>
          </div>
          <div class="dp-section">
            <div class="dp-section-title">재고 수동 조정</div>
            <div class="fg-grid">
              <div class="fg"><label>조정 대상 옵션</label><select class="fi"><option>화이트 / 240mm</option><option>화이트 / 245mm</option><option>그레이 / 255mm</option></select></div>
              <div class="fg"><label>조정 유형</label><select class="fi"><option>증가 (+)</option><option>감소 (-)</option></select></div>
              <div class="fg"><label>조정 수량</label><input class="fi" type="number" placeholder="0" min="0"></div>
              <div class="fg"><label>사유 (필수)</label><input class="fi" placeholder="예: 오손파손 처리"></div>
            </div>
            <div style="margin-top:10px;display:flex;justify-content:flex-end">
              <button class="btn btn-blue btn-sm">재고 조정 적용</button>
            </div>
          </div>
        </div>

        <!-- TAB: 리뷰 -->
        <div class="dp-tab-content" id="tab-review">
          <div class="dp-section">
            <div class="dp-section-title">고객 리뷰 <span style="font-weight:400;font-size:10px;color:var(--gray4);margin-left:4px">총 3건 · 평균 ⭐ 4.3</span></div>
            <div class="review-item">
              <div class="review-hdr">
                <div class="review-av">홍</div>
                <div>
                  <div class="review-user">hong1234</div>
                  <div class="review-stars">★★★★★</div>
                </div>
                <div class="review-date">2025-04-20</div>
              </div>
              <div class="review-body">사이즈가 딱 맞고 신었을 때 쿠션감이 정말 좋아요. 배송도 빠르고 포장도 꼼꼼했습니다. 재구매 의사 있어요!</div>
            </div>
            <div class="review-item">
              <div class="review-hdr">
                <div class="review-av">김</div>
                <div>
                  <div class="review-user">kim5678</div>
                  <div class="review-stars">★★★★☆</div>
                </div>
                <div class="review-date">2025-04-17</div>
              </div>
              <div class="review-body">색상이 사진이랑 거의 동일해서 좋았어요. 사이즈는 평소보다 반 사이즈 크게 주문하는 걸 추천해요.</div>
            </div>
            <div class="review-item">
              <div class="review-hdr">
                <div class="review-av">이</div>
                <div>
                  <div class="review-user">lee9012</div>
                  <div class="review-stars">★★★★☆</div>
                </div>
                <div class="review-date">2025-04-12</div>
              </div>
              <div class="review-body">가격 대비 퀄리티가 좋습니다. 디자인이 깔끔해서 데일리로 신기 좋아요.</div>
            </div>
          </div>
        </div>

      </div><!-- /dp-body -->

      <!-- DETAIL FOOTER -->
      <div class="dp-footer">
        <button class="btn btn-danger btn-sm" id="dpDeleteBtn">삭제</button>
        <div style="display:flex;gap:8px;margin-left:auto">
          <button class="btn btn-outline" onclick="closeDetail()">취소</button>
          <button class="btn btn-blue" id="dpSaveBtn">저장</button>
        </div>
      </div>
    </div><!-- /detail-panel -->

  </div><!-- /body-wrap -->
</main>

<!-- 🚨 TOAST 영역 (Body 안쪽 하단) 🚨 -->
<div class="toast" id="toast"></div>

<script>
// ── 시간 관련 함수 ────────────────────────────────
function updateClock() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeString = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    
    const clockEl = document.getElementById("realTimeClock");
    if(clockEl) clockEl.innerText = timeString;
}

updateClock();
setInterval(updateClock, 60000);

// ── TOAST 알림 함수 ───────────────────────────────
function showToast(msg) {
  const t = document.getElementById('toast');
  if(!t) return;
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

// ── 동기화 함수 ───────────────────────────────────
function updateSyncTime() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    
    // 포맷 맞춤 (yyyy-mm-dd hh:mm:ss)
    const timeString = year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
    
    // 시간 표시 텍스트 변경
    const syncEl = document.getElementById("syncTime");
    if(syncEl) syncEl.innerText = "최종 동기화: " + timeString;
    
    // 알림 띄우기
    showToast('상품 동기화 완료');
    
    // 리스트도 검색창 초기화하며 다시 렌더링되게 처리
    document.querySelector('.search-wrap input').value = '';
    renderTable(products);
}


function generateSKU() {
    const brandSelect = document.getElementById('fi-brand').value;
    
    // 브랜드를 선택하지 않았을 경우 얼럿을 띄우고 함수 종료
    if (!brandSelect) {
        alert("브랜드를 먼저 선택해 주세요.");
        return;
    }

    let prefix = "PRD"; // 기본값
    if (brandSelect === "나이키") prefix = "NK";
    else if (brandSelect === "아디다스") prefix = "AD";
    else if (brandSelect === "뉴발란스") prefix = "NB";
    else if (brandSelect === "호카") prefix = "HK";
    else if (brandSelect === "버켄스탁") prefix = "BK";

    const now = new Date();
    const yy = String(now.getFullYear()).slice(2);
    const mm = String(now.getMonth() + 1).padStart(2, '0');
    const dd = String(now.getDate()).padStart(2, '0');
    
    // 영문 대문자 + 숫자 조합 4자리 난수 생성
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let randomStr = '';
    for (let i = 0; i < 4; i++) {
        randomStr += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    
    // 조합: 브랜드접두사 - 년월일 - 난수
    const autoSku = prefix + "-" + yy + mm + dd + "-" + randomStr;
    document.getElementById('fi-sku').value = autoSku;
    
    showToast('상품 고유코드가 자동 생성되었습니다.');
}

//─── 상품 데이터 ────────────────────────────────────
const products = [
  {id:1, sku:'NK-AF1-WHT',    brand:'나이키',   name:'에어포스 1 로우',      cat:'운동화', sizes:'225~280', colors:3, stock:148, maxStock:200, status:1},
  {id:2, sku:'AD-UB22-BLK',   brand:'아디다스', name:'울트라부스트 22',       cat:'러닝화', sizes:'230~280', colors:5, stock:32,  maxStock:100, status:1},
  {id:3, sku:'NK-AM270-GRY',  brand:'나이키',   name:'에어맥스 270',          cat:'운동화', sizes:'225~280', colors:3, stock:11,  maxStock:100, status:1},
  {id:4, sku:'NB-990V5-NVY',  brand:'뉴발란스', name:'990v5 메이드 인 USA',   cat:'운동화', sizes:'230~285', colors:3, stock:87,  maxStock:100, status:1},
  {id:5, sku:'HK-CLIFF9-WHT', brand:'호카',     name:'클리프턴 9',            cat:'러닝화', sizes:'225~280', colors:5, stock:44,  maxStock:80,  status:1},
  {id:6, sku:'AD-SAMBA-BLK',  brand:'아디다스', name:'삼바 OG',               cat:'운동화', sizes:'220~280', colors:2, stock:67,  maxStock:80,  status:1},
  {id:7, sku:'BK-BOSTON-BEG', brand:'버켄스탁', name:'보스턴 스웨이드',       cat:'샌들',   sizes:'230~275', colors:4, stock:12,  maxStock:60,  status:1},
  {id:8, sku:'NK-SBJRD-RED',  brand:'나이키',   name:'에어 조던 1 레트로',    cat:'농구화', sizes:'240~285', colors:4, stock:0,   maxStock:60,  status:3},
];
 
let selectedId = null;
let isNew = false;
 
function getStatusBdg(s, stock) {
  if(stock === 0) return '<span class="bdg bdg-red">품절</span>';
  if(stock < 10)  return '<span class="bdg bdg-red">부족</span>';
  if(s === 2)     return '<span class="bdg bdg-gray">숨김</span>';
  if(stock < 20)  return '<span class="bdg bdg-amber">주의</span>';
  return '<span class="bdg bdg-green">판매중</span>';
}
 
function getProg(stock, max) {
  const pct = Math.min(100, Math.round(stock / max * 100));
  const cls = pct < 15 ? 'prog-low' : pct < 30 ? 'prog-warn' : 'prog-ok';
  return '<div class="prog-wrap">'
    + '<div class="prog-track"><div class="prog-fill ' + cls + '" style="width:' + pct + '%"></div></div>'
    + '<div class="prog-num">' + pct + '%</div>'
    + '</div>';
}
 
function renderTable(data) {
  const tbody = document.getElementById('prodTbody');
  tbody.innerHTML = data.map(function(p) {
    const isSelected = selectedId === p.id ? 'selected' : '';
    const actionBtn =
        '<button class="btn btn-outline btn-xs" onclick="openDetail(' + p.id + ')">상세</button>'
      + '<button class="btn btn-danger btn-xs">삭제</button>';
    return '<tr class="prod-row ' + isSelected + '" onclick="openDetail(' + p.id + ')" data-id="' + p.id + '">'
      + '<td onclick="event.stopPropagation()"><input type="checkbox" class="row-chk" onchange="updateSelCount()"></td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11px;color:var(--gray3)">' + p.sku + '</td>'
      + '<td>' + p.brand + '</td>'
      + '<td style="font-weight:600;color:var(--gray1)">' + p.name + '</td>'
      + '<td><span class="bdg bdg-gray">' + p.cat + '</span></td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-size:11px">' + p.sizes + '</td>'
      + '<td style="text-align:center">' + p.colors + '색</td>'
      + '<td style="font-family:\'DM Mono\',monospace;font-weight:600">' + p.stock.toLocaleString() + '</td>'
      + '<td style="min-width:100px">' + getProg(p.stock, p.maxStock) + '</td>'
      + '<td>' + getStatusBdg(p.status, p.stock) + '</td>'
      + '<td onclick="event.stopPropagation()" style="display:flex;gap:4px;align-items:center">' + actionBtn + '</td>'
      + '</tr>';
  }).join('');
}
 
function filterTable(val) {
  const q = (val || document.querySelector('.search-wrap input').value).toLowerCase();
  const filtered = products.filter(function(p) {
    return p.name.toLowerCase().includes(q)
        || p.sku.toLowerCase().includes(q)
        || p.brand.toLowerCase().includes(q);
  });
  renderTable(filtered);
}
 
function toggleAll(cb) {
  document.querySelectorAll('.row-chk').forEach(function(c){ c.checked = cb.checked; });
  updateSelCount();
}
 
function updateSelCount() {
  const n = document.querySelectorAll('.row-chk:checked').length;
  document.getElementById('selCount').textContent = n;
}
 
// ─── 상세 열기 ─────────────────────────────────────
function openDetail(id) {
  const p = products.find(function(x){ return x.id === id; });
  if(!p) return;
  isNew = false;
  selectedId = id;
 
  document.getElementById('dpIco').textContent   = '📝';
  document.getElementById('dpTitle').textContent = p.name;
  document.getElementById('dpSku').textContent   = p.sku;
  document.getElementById('dpSaveBtn').textContent       = '수정 저장';
  document.getElementById('dpDeleteBtn').style.display   = '';
 
  document.getElementById('fi-sku').value     = p.sku;
  document.getElementById('fi-regdate').value = '2025-03-12';
  document.getElementById('fi-name').value    = p.name;
  document.getElementById('fi-brand').value   = p.brand;
  document.getElementById('fi-cat').value     = p.cat;
  document.getElementById('fi-price').value   = 189000;
  document.getElementById('fi-sale').value    = 0;
  document.getElementById('fi-status').value  = p.status;
  document.getElementById('fi-desc').value    = p.brand + '의 ' + p.name + '. 편안한 착화감과 세련된 디자인을 겸비한 프리미엄 신발입니다.';
 
  switchTabById('tab-info');
  openPanel();
 
  document.querySelectorAll('.prod-row').forEach(function(r) {
    r.classList.toggle('selected', parseInt(r.dataset.id) === id);
  });
}
 
function openNew() {
  isNew = true;
  selectedId = null;
 
  document.getElementById('dpIco').textContent          = '＋';
  document.getElementById('dpTitle').textContent        = '신규 상품 등록';
  document.getElementById('dpSku').textContent          = '';
  document.getElementById('dpSaveBtn').textContent      = '등록';
  document.getElementById('dpDeleteBtn').style.display  = 'none';
 
  ['fi-sku','fi-regdate','fi-name','fi-price','fi-sale','fi-desc']
    .forEach(function(id){ document.getElementById(id).value = ''; });
  document.getElementById('fi-brand').value  = '';
  document.getElementById('fi-cat').value    = '';
  document.getElementById('fi-gender').value = '0';
  document.getElementById('fi-status').value = '1';
 
  document.querySelectorAll('#colorChips .chip').forEach(function(c){ c.classList.remove('on'); });
  document.querySelectorAll('#sizeChips .chip').forEach(function(c){ c.classList.remove('on'); });
 
  switchTabById('tab-info');
  openPanel();
  document.querySelectorAll('.prod-row').forEach(function(r){ r.classList.remove('selected'); });
}
 
function openPanel() {
  document.getElementById('detailPanel').classList.add('open');
  document.getElementById('listPanel').classList.add('shrunk');
}
 
function closeDetail() {
  document.getElementById('detailPanel').classList.remove('open');
  document.getElementById('listPanel').classList.remove('shrunk');
  document.querySelectorAll('.prod-row').forEach(function(r){ r.classList.remove('selected'); });
  selectedId = null;
}
 
function switchTab(el, tabId) {
  el.closest('.dp-tabs').querySelectorAll('.dp-tab').forEach(function(t){ t.classList.remove('on'); });
  el.classList.add('on');
  switchTabById(tabId);
}
 
function switchTabById(tabId) {
  document.querySelectorAll('.dp-tab-content').forEach(function(t){ t.classList.remove('active'); });
  document.getElementById(tabId).classList.add('active');
}
 
// ─── 초기 렌더 ─────────────────────────────────────
renderTable(products);
</script>

</body>
</html>