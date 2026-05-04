<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 마스터 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
.main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}
.body-wrap{flex:1;display:flex;overflow:hidden;position:relative}
.list-panel{display:flex;flex-direction:column;background:var(--bg);transition:width .3s cubic-bezier(.4,0,.2,1);width:100%;overflow:hidden;flex-shrink:0;}
.list-panel.shrunk{width:calc(100% - 560px)}
.list-toolbar{display:flex;align-items:center;gap:8px;padding:14px 18px;background:var(--white);border-bottom:1px solid var(--gray6);flex-shrink:0;flex-wrap:wrap;}
.search-wrap{position:relative;flex:1;min-width:180px;max-width:260px}
.search-wrap input{width:100%;padding:8px 12px 8px 32px;border:1px solid var(--gray5);background:var(--white);border-radius:6px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:border .15s;}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:7px 10px;border:1px solid var(--gray5);background:var(--white);font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:6px;cursor:pointer;}
.btn{padding:7px 14px;border:none;border-radius:6px;font-size:12px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:5px;}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-danger{background:var(--red-lt);color:var(--red);border:1px solid #FECACA}.btn-danger:hover{background:var(--red);color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px}
.tbl-outer{flex:1;overflow-y:auto}
.tbl-outer::-webkit-scrollbar{width:4px}
.tbl-outer::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:2px}
table{width:100%;border-collapse:collapse;background:var(--white)}
thead{position:sticky;top:0;z-index:10}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap;}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle;}
tr:last-child td{border-bottom:none}
.prod-row{cursor:pointer;transition:background .12s}
.prod-row:hover td{background:#F5F8FF}
.prod-row.selected td{background:var(--blue-lt)}
.prod-row.selected td:first-child{border-left:3px solid var(--blue);padding-left:11px;}
td:first-child{border-left:3px solid transparent;padding-left:11px}
.bdg{display:inline-flex;align-items:center;padding:2px 8px;border-radius:100px;font-size:10px;font-weight:700;white-space:nowrap;}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.prog-wrap{display:flex;align-items:center;gap:6px}
.prog-track{flex:1;height:4px;background:var(--gray6);border-radius:2px;overflow:hidden;min-width:50px}
.prog-fill{height:100%;border-radius:2px}
.prog-ok{background:var(--blue)}.prog-warn{background:var(--amber)}.prog-low{background:var(--red)}
.prog-num{font-family:'DM Mono',monospace;font-size:10px;color:var(--gray3);width:30px;text-align:right;flex-shrink:0}
.list-footer{padding:10px 18px;border-top:1px solid var(--gray6);background:var(--white);display:flex;align-items:center;justify-content:space-between;flex-shrink:0;}
.list-footer-info{font-size:11px;color:var(--gray4)}
.pagination{display:flex;gap:4px}
.pg-btn{width:28px;height:28px;border:1px solid var(--gray5);border-radius:5px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:11px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s;}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}
.detail-panel{width:0;overflow:hidden;flex-shrink:0;display:flex;flex-direction:column;border-left:1px solid var(--gray6);background:var(--white);transition:width .3s cubic-bezier(.4,0,.2,1);position:relative;}
.detail-panel.open{width:560px}
.dp-hdr{height:50px;background:var(--navy);display:flex;align-items:center;padding:0 18px;gap:10px;flex-shrink:0;white-space:nowrap;overflow:hidden;}
.dp-hdr-ico{width:28px;height:28px;background:rgba(255,255,255,.1);border-radius:5px;display:flex;align-items:center;justify-content:center;font-size:12px;flex-shrink:0;}
.dp-hdr-title{font-size:13.5px;font-weight:700;color:#fff;flex:1;overflow:hidden;text-overflow:ellipsis}
.dp-hdr-sku{font-size:10px;font-family:'DM Mono',monospace;color:rgba(255,255,255,.4);padding:2px 7px;background:rgba(255,255,255,.07);border-radius:3px;white-space:nowrap}
.dp-close{width:28px;height:28px;border:none;background:rgba(255,255,255,.08);border-radius:5px;color:rgba(255,255,255,.6);font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .15s;}
.dp-close:hover{background:rgba(255,255,255,.16);color:#fff}
.dp-tabs{display:flex;border-bottom:2px solid var(--gray6);flex-shrink:0;background:var(--bg2);overflow:hidden;}
.dp-tab{padding:9px 16px;font-size:11.5px;font-weight:600;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .15s;text-transform:uppercase;letter-spacing:.05em;white-space:nowrap;}
.dp-tab.on{color:var(--blue);border-bottom-color:var(--blue)}
.dp-tab:hover{color:var(--gray2)}
.dp-body{flex:1;overflow-y:auto;padding:20px}
.dp-body::-webkit-scrollbar{width:4px}
.dp-body::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:2px}
.dp-section{margin-bottom:22px}
.dp-section-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px;}
.dp-section-title::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block;}
.fg-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.fg-full{grid-column:1/-1}
.fg{display:flex;flex-direction:column;gap:5px}
.fg label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.fi{padding:9px 11px;border:1px solid var(--gray5);background:var(--white);border-radius:6px;font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray1);outline:none;width:100%;transition:border .15s;}
.fi:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.fi::placeholder{color:var(--gray4)}
.fi:read-only{background:var(--gray7);color:var(--gray3);cursor:default}
select.fi option{background:var(--white)}
textarea.fi{resize:vertical;min-height:72px}
.img-zone{border:2px dashed var(--gray5);border-radius:8px;height:130px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;cursor:pointer;transition:all .18s;background:var(--bg2);}
.img-zone:hover{border-color:var(--blue);background:var(--blue-lt)}
.img-previews{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
.img-thumb{width:64px;height:64px;border-radius:6px;background:var(--gray7);border:1px solid var(--gray5);display:flex;align-items:center;justify-content:center;font-size:22px;position:relative;overflow:hidden;cursor:pointer;transition:border .15s;}
.img-thumb:hover{border-color:var(--blue)}
.img-thumb.main-img{border:2px solid var(--blue)}
.img-thumb-del{position:absolute;top:3px;right:3px;width:15px;height:15px;background:var(--red);border-radius:50%;color:#fff;font-size:8px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-weight:700;opacity:0;transition:opacity .15s;}
.img-thumb:hover .img-thumb-del{opacity:1}
.img-main-badge{position:absolute;bottom:0;left:0;right:0;background:var(--blue);color:#fff;font-size:9px;font-weight:700;text-align:center;padding:2px;letter-spacing:.05em;}
.chip-row{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px}
.chip{padding:5px 11px;border:1.5px solid var(--gray5);border-radius:5px;font-size:11.5px;cursor:pointer;font-family:'Pretendard',sans-serif;font-weight:500;background:var(--white);color:var(--gray3);transition:all .15s;}
.chip.on{border-color:var(--blue);color:var(--blue);background:var(--blue-lt);font-weight:700}
.chip:hover:not(.on){border-color:var(--gray3);color:var(--gray2)}
.chip.color-chip{display:flex;align-items:center;gap:5px}
.color-dot{width:10px;height:10px;border-radius:50%;border:1px solid rgba(0,0,0,.1);flex-shrink:0}
.stock-mini-table{width:100%;border-collapse:collapse}
.stock-mini-table th{padding:7px 10px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;}
.stock-mini-table td{padding:9px 10px;font-size:12px;color:var(--gray2);border-bottom:1px solid var(--gray7);}
.stock-mini-table tr:last-child td{border-bottom:none}
.qty-ok{color:var(--gray1);font-weight:600;font-family:'DM Mono',monospace}
.qty-warn{color:var(--amber);font-weight:700;font-family:'DM Mono',monospace}
.qty-low{color:var(--red);font-weight:700;font-family:'DM Mono',monospace}
.stock-input{width:70px;padding:5px 8px;border:1px solid var(--gray5);background:var(--white);border-radius:5px;font-size:12px;font-family:'DM Mono',monospace;color:var(--gray1);outline:none;text-align:right;}
.stock-input:focus{border-color:var(--blue)}
.dp-footer{padding:12px 20px;border-top:1px solid var(--gray6);background:var(--bg2);display:flex;gap:8px;justify-content:flex-end;flex-shrink:0;}
.review-item{border:1px solid var(--gray6);border-radius:6px;padding:12px;margin-bottom:10px;background:var(--bg2);}
.review-hdr{display:flex;align-items:center;gap:8px;margin-bottom:8px}
.review-av{width:28px;height:28px;border-radius:50%;background:var(--navy2);display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#fff;flex-shrink:0;}
.review-user{font-size:12px;font-weight:600;color:var(--gray1)}
.review-date{font-size:10px;color:var(--gray4);margin-left:auto}
.review-stars{color:var(--amber);font-size:12px;letter-spacing:1px}
.review-body{font-size:12px;color:var(--gray2);line-height:1.6}
.dp-tab-content{display:none}
.dp-tab-content.active{display:block}
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/log_header.jsp" />

<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur">상품 마스터 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
    </div>
  </div>

  <div class="body-wrap">

    <!-- ─── LIST PANEL ─── -->
    <div class="list-panel" id="listPanel">
      <div class="list-toolbar">
        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" id="searchInput" placeholder="품번·상품명·브랜드 검색"
                 oninput="filterTable(this.value)">
        </div>
        <select class="sel" id="brandFilter" onchange="filterTable()">
          <option value="">전체 브랜드</option>
          <c:choose>
            <c:when test="${not empty brandList}">
              <c:forEach var="b" items="${brandList}">
                <option value="${b.brandName}">${b.brandName}</option>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <option>나이키</option>
              <option>아디다스</option>
              <option>뉴발란스</option>
              <option>호카</option>
              <option>버켄스탁</option>
            </c:otherwise>
          </c:choose>
        </select>
        <select class="sel" id="statusFilter" onchange="filterTable()">
          <option value="">전체 상태</option>
          <option>판매중</option>
          <option>주의</option>
          <option>품절</option>
          <option>숨김</option>
        </select>
        <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
          <div id="syncTime" style="font-size:11px;color:var(--gray4);font-family:'DM Mono',monospace;">최종 동기화: -</div>
          <div style="display:flex;gap:7px;">
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
            <c:choose>
              <c:when test="${not empty list}">
                <c:forEach var="p" items="${list}">
                  <c:set var="maxStk" value="${p.maxStock > 0 ? p.maxStock : 100}"/>
                  <c:set var="pct"    value="${p.stockQty * 100 / maxStk}"/>
                  <c:set var="progCls" value="${p.stockQty == 0 ? 'prog-low' : pct < 15 ? 'prog-low' : pct < 30 ? 'prog-warn' : 'prog-ok'}"/>
                  <c:set var="bdgCls"  value="${p.stockQty == 0 ? 'bdg-red'  : p.prodStatus == 2 ? 'bdg-gray' : pct < 20 ? 'bdg-amber' : 'bdg-green'}"/>
                  <c:set var="bdgTxt"  value="${p.stockQty == 0 ? '품절' : p.prodStatus == 2 ? '숨김' : pct < 20 ? '주의' : '판매중'}"/>
                  <tr class="prod-row" data-id="${p.prodNum}"
                      onclick="openDetailFromServer(${p.prodNum},'${p.prodName}','${p.sku}','${p.brandName}','${p.catName}',${p.prodPrice},${p.prodStatus})">
                    <td onclick="event.stopPropagation()">
                      <input type="checkbox" class="row-chk" onchange="updateSelCount()">
                    </td>
                    <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3);">${p.sku}</td>
                    <td>${p.brandName}</td>
                    <td style="font-weight:600;color:var(--gray1);">${p.prodName}</td>
                    <td><span class="bdg bdg-gray">${p.catName}</span></td>
                    <td style="font-family:'DM Mono',monospace;font-size:11px;">-</td>
                    <td style="text-align:center;">-</td>
                    <td style="font-family:'DM Mono',monospace;font-weight:600;">${p.stockQty}</td>
                    <td style="min-width:100px;">
                      <div class="prog-wrap">
                        <div class="prog-track">
                          <div class="prog-fill ${progCls}" style="width:${pct}%"></div>
                        </div>
                        <div class="prog-num">${pct}%</div>
                      </div>
                    </td>
                    <td><span class="bdg ${bdgCls}">${bdgTxt}</span></td>
                    <td onclick="event.stopPropagation()" style="display:flex;gap:4px;align-items:center;">
                      <button class="btn btn-outline btn-xs"
                              onclick="openDetailFromServer(${p.prodNum},'${p.prodName}','${p.sku}','${p.brandName}','${p.catName}',${p.prodPrice},${p.prodStatus})">상세</button>
                      <button class="btn btn-danger btn-xs"
                              onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logistics/log_prod/log_prodDel.do?prodNum=${p.prodNum}'">삭제</button>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise><%-- DB 연동 전 비워둠 --%></c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- FOOTER -->
      <div class="list-footer">
        <div class="list-footer-info">
          총 <strong>${not empty count ? count : 0}</strong>개 상품 ·
          선택 <strong id="selCount">0</strong>개
        </div>
        <div class="pagination">
          <div class="pg-btn">‹</div>
          <div class="pg-btn on">1</div>
          <div class="pg-btn">2</div>
          <div class="pg-btn">3</div>
          <div class="pg-btn">›</div>
        </div>
      </div>
    </div><%-- /list-panel --%>

    <!-- ─── DETAIL PANEL ─── -->
    <div class="detail-panel" id="detailPanel">
      <div class="dp-hdr">
        <div class="dp-hdr-ico" id="dpIco">📑</div>
        <div class="dp-hdr-title" id="dpTitle">상품 상세정보</div>
        <div class="dp-hdr-sku" id="dpSku"></div>
        <button class="dp-close" onclick="closeDetail()">✕</button>
      </div>
      <div class="dp-tabs">
        <div class="dp-tab on" onclick="switchTab(this,'tab-info')">기본 정보</div>
        <div class="dp-tab" onclick="switchTab(this,'tab-stock')">옵션 / 재고</div>
        <div class="dp-tab" onclick="switchTab(this,'tab-review')">리뷰</div>
      </div>

      <%-- ★ form 시작 — dp-tabs 아래, dp-footer 포함 --%>
      <form id="prodRegForm" action="" method="post"
            style="flex:1;display:flex;flex-direction:column;overflow:hidden;">

        <%-- 히든 필드 --%>
        <input type="hidden" id="h-prodNum"  name="prodNum"  value="">
        <input type="hidden" id="h-catNum"   name="catNum"   value="">
        <input type="hidden" id="h-brandNum" name="brandNum" value="">
        <input type="hidden" id="h-colors"   name="colors"   value="">
        <input type="hidden" id="h-sizes"    name="sizes"    value="">

        <div class="dp-body">

          <!-- TAB: 기본 정보 -->
          <div class="dp-tab-content active" id="tab-info">
            <div class="dp-section">
              <div class="dp-section-title">상품 이미지</div>
              <div class="img-previews" id="imgPreviews">
                <div class="img-thumb main-img">👟<div class="img-main-badge">대표</div><div class="img-thumb-del">✕</div></div>
                <div class="img-thumb">👟<div class="img-thumb-del">✕</div></div>
                <div class="img-thumb">👟<div class="img-thumb-del">✕</div></div>
                <div class="img-zone" style="width:64px;height:64px;border-radius:6px;font-size:18px;" onclick="document.getElementById('fileInput').click()">
                  <span style="color:var(--gray4);font-size:20px">＋</span>
                </div>
              </div>
              <div style="font-size:10px;color:var(--gray4);margin-top:6px">첫 번째 이미지가 대표 이미지로 설정됩니다.</div>
              <input type="file" id="fileInput" accept="image/*" multiple style="display:none">
            </div>

            <div class="dp-section">
              <div class="dp-section-title">기본 정보</div>
              <div class="fg-grid">
                <div class="fg">
                  <label>상품 고유코드 (SKU) <span style="color:var(--red)">*</span></label>
                  <div style="display:flex;gap:6px;">
                    <input class="fi" id="fi-sku" name="sku" placeholder="예: NK-AM270-GRY">
                    <button type="button" class="btn btn-outline" style="flex-shrink:0;padding:9px 12px;" onclick="generateSKU()">자동 생성</button>
                  </div>
                </div>
                <div class="fg">
                  <label>품번 등록일</label>
                  <input class="fi" id="fi-regdate" readonly style="background:var(--gray7);color:var(--gray3)">
                </div>
                <div class="fg fg-full">
                  <label>상품명 <span style="color:var(--red)">*</span></label>
                  <input class="fi" id="fi-name" name="prodName" placeholder="상품명을 입력하세요">
                </div>
                <div class="fg">
                  <label>브랜드 <span style="color:var(--red)">*</span></label>
                  <select class="fi" id="fi-brand">
    				<option value="">브랜드 선택</option>
   					 <c:forEach var="b" items="${brandList}">
      			    <option value="${b.brandName}" data-num="${b.brandNum}">${b.brandName}</option>
        			 </c:forEach>
				</select>
                </div>
                <div class="fg">
                  <label>카테고리 <span style="color:var(--red)">*</span></label>
                  <select class="fi" id="fi-cat">
    				<option value="">카테고리 선택</option>
   					 <c:forEach var="c" items="${catList}">
    			    <option value="${c.catName}" data-num="${c.catNum}">${c.catName}</option>
    				</c:forEach>
				</select>
                </div>
                <div class="fg">
                  <label>정가 (원) <span style="color:var(--red)">*</span></label>
                  <input class="fi" id="fi-price" name="prodPrice" type="number" placeholder="0">
                </div>
                <div class="fg">
                  <label>할인율 (%)</label>
                  <input class="fi" id="fi-sale" name="saleRate" type="number" placeholder="0" min="0" max="100">
                </div>
                <div class="fg">
                  <label>성별</label>
                  <select class="fi" id="fi-gender" name="gender">
                    <option value="0">공용</option>
                    <option value="1">남성</option>
                    <option value="2">여성</option>
                  </select>
                </div>
                <div class="fg">
                  <label>판매 상태</label>
                  <select class="fi" id="fi-status" name="prodStatus">
                    <option value="1">판매중</option>
                    <option value="2">숨김</option>
                    <option value="3">품절</option>
                  </select>
                </div>
                <div class="fg fg-full">
                  <label>상품 설명</label>
                  <textarea class="fi" id="fi-desc" name="prodText" placeholder="상품에 대한 상세 설명을 입력하세요"></textarea>
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
          </div><%-- /tab-info --%>

          <!-- TAB: 옵션 / 재고 -->
          <div class="dp-tab-content" id="tab-stock">
            <div class="dp-section">
              <div class="dp-section-title">컬러 × 사이즈별 재고 현황</div>
              <table class="stock-mini-table">
                <thead>
                  <tr><th>컬러</th><th>사이즈</th><th>현재 재고</th><th>부족기준</th><th>상태</th><th>수정</th></tr>
                </thead>
                <tbody id="stockTbody"></tbody>
              </table>
            </div>
            <div class="dp-section">
              <div class="dp-section-title">재고 수동 조정</div>
              <div class="fg-grid">
                <div class="fg"><label>조정 대상 옵션</label><select class="fi"><option>옵션 선택</option></select></div>
                <div class="fg"><label>조정 유형</label><select class="fi"><option>증가 (+)</option><option>감소 (-)</option></select></div>
                <div class="fg"><label>조정 수량</label><input class="fi" type="number" placeholder="0" min="0"></div>
                <div class="fg"><label>사유 (필수)</label><input class="fi" placeholder="예: 오손파손 처리"></div>
              </div>
              <div style="margin-top:10px;display:flex;justify-content:flex-end">
                <button type="button" class="btn btn-blue btn-sm">재고 조정 적용</button>
              </div>
            </div>
          </div><%-- /tab-stock --%>

          <!-- TAB: 리뷰 -->
          <div class="dp-tab-content" id="tab-review">
            <div class="dp-section">
              <div class="dp-section-title">고객 리뷰</div>
              <div class="review-item">
                <div class="review-hdr">
                  <div class="review-av">홍</div>
                  <div><div class="review-user">hong1234</div><div class="review-stars">★★★★★</div></div>
                  <div class="review-date">2025-04-20</div>
                </div>
                <div class="review-body">사이즈가 딱 맞고 쿠션감이 좋아요. 배송도 빠르고 포장도 꼼꼼했습니다.</div>
              </div>
            </div>
          </div><%-- /tab-review --%>

        </div><%-- /dp-body --%>

        <!-- DETAIL FOOTER -->
        <div class="dp-footer">
          <button type="button" class="btn btn-danger btn-sm" id="dpDeleteBtn">삭제</button>
          <div style="display:flex;gap:8px;margin-left:auto">
            <button type="button" class="btn btn-outline" onclick="closeDetail()">취소</button>
            <button type="button" class="btn btn-blue" id="dpSaveBtn" onclick="submitProd()">저장</button>
          </div>
        </div>

      </form><%-- /prodRegForm --%>

    </div><%-- /detail-panel --%>

  </div><%-- /body-wrap --%>
</main>

<div class="toast" id="toast"></div>

<script>
var selectedId = null;
var isNew      = false;

// ── 브랜드 / 카테고리 번호 매핑 ──────────────────
var brandMap = {"나이키":1,"아디다스":2,"퓨마":3,"뉴발란스":4,"호카":5,"버켄스탁":6};
var catMap   = {"운동화":1,"샌들":2,"구두":3,"부츠":4,"러닝화":5,"농구화":6};

// ── 시간 ──────────────────────────────────────────
function updateClock() {
    var now = new Date();
    var s = now.getFullYear() + "-"
          + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + "  "
          + String(now.getHours()).padStart(2,'0') + ":"
          + String(now.getMinutes()).padStart(2,'0');
    var el = document.getElementById("realTimeClock");
    if(el) el.innerText = s;
}
updateClock();
setInterval(updateClock, 60000);

// ── TOAST ─────────────────────────────────────────
function showToast(msg) {
    var t = document.getElementById('toast');
    if(!t) return;
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

// ── 동기화 ────────────────────────────────────────
function updateSyncTime() {
    var now = new Date();
    var s = now.getFullYear() + "-"
          + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + " "
          + String(now.getHours()).padStart(2,'0') + ":"
          + String(now.getMinutes()).padStart(2,'0') + ":"
          + String(now.getSeconds()).padStart(2,'0');
    var el = document.getElementById("syncTime");
    if(el) el.innerText = "최종 동기화: " + s;
    showToast('상품 동기화 완료');
}

// ── SKU 자동 생성 ──────────────────────────────────
function generateSKU() {
    var brand = document.getElementById('fi-brand').value;
    if(!brand){ alert("브랜드를 먼저 선택해 주세요."); return; }
    var map = {"나이키":"NK","아디다스":"AD","뉴발란스":"NB","호카":"HK","버켄스탁":"BK"};
    var prefix = map[brand] || "PRD";
    var now = new Date();
    var yy = String(now.getFullYear()).slice(2);
    var mm = String(now.getMonth()+1).padStart(2,'0');
    var dd = String(now.getDate()).padStart(2,'0');
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var rand = '';
    for(var i=0;i<4;i++) rand += chars.charAt(Math.floor(Math.random()*chars.length));
    document.getElementById('fi-sku').value = prefix + "-" + yy + mm + dd + "-" + rand;
    showToast('상품 고유코드가 자동 생성되었습니다.');
}

// ── 등록 / 수정 submit ────────────────────────────
function submitProd() {
    var sku   = document.getElementById('fi-sku').value.trim();
    var name  = document.getElementById('fi-name').value.trim();
    var brand = document.getElementById('fi-brand').value;
    var cat   = document.getElementById('fi-cat').value;
    var price = document.getElementById('fi-price').value;

    if(!sku)   { alert('SKU를 입력하세요.');      return; }
    if(!name)  { alert('상품명을 입력하세요.');    return; }
    if(!brand) { alert('브랜드를 선택하세요.');    return; }
    if(!cat)   { alert('카테고리를 선택하세요.');  return; }
    if(!price) { alert('정가를 입력하세요.');      return; }

    var brandSel = document.getElementById('fi-brand');
    var catSel   = document.getElementById('fi-cat');
    document.getElementById('h-brandNum').value =
        brandSel.options[brandSel.selectedIndex].getAttribute('data-num') || 0;
    document.getElementById('h-catNum').value =
        catSel.options[catSel.selectedIndex].getAttribute('data-num') || 0;

    // 선택된 컬러 수집
    var colors = [];
    document.querySelectorAll('#colorChips .chip.on').forEach(function(c){
        colors.push(c.innerText.trim());
    });
    document.getElementById('h-colors').value = colors.join(',');

    // 선택된 사이즈 수집
    var sizes = [];
    document.querySelectorAll('#sizeChips .chip.on').forEach(function(c){
        sizes.push(c.innerText.trim());
    });
    document.getElementById('h-sizes').value = sizes.join(',');

    var form = document.getElementById('prodRegForm');
    var cp   = '${pageContext.request.contextPath}';

    if(isNew) {
        // 신규 등록
        document.getElementById('h-prodNum').value = '';
        form.action = cp + '/logistics/log_prod/log_prodReg.do';
    } else {
        // 수정
        document.getElementById('h-prodNum').value = selectedId;
        form.action = cp + '/logistics/log_prod/log_prodMod.do';
    }
    form.submit();
}

// ── DB 데이터로 상세 패널 열기 ─────────────────────
function openDetailFromServer(prodNum, prodName, sku, brandName, catName, prodPrice, prodStatus) {
    isNew      = false;
    selectedId = prodNum;

    document.getElementById('dpIco').textContent         = '📝';
    document.getElementById('dpTitle').textContent       = prodName;
    document.getElementById('dpSku').textContent         = sku;
    document.getElementById('dpSaveBtn').textContent     = '수정 저장';
    document.getElementById('dpDeleteBtn').style.display = '';

    document.getElementById('fi-sku').value    = sku;
    document.getElementById('fi-regdate').value= '';
    document.getElementById('fi-name').value   = prodName;
    document.getElementById('fi-brand').value  = brandName;
    document.getElementById('fi-cat').value    = catName;
    document.getElementById('fi-price').value  = prodPrice;
    document.getElementById('fi-sale').value   = 0;
    document.getElementById('fi-status').value = prodStatus;
    document.getElementById('fi-desc').value   = '';

    switchTabById('tab-info');
    openPanel();

    document.querySelectorAll('.prod-row').forEach(function(r){
        r.classList.toggle('selected', parseInt(r.dataset.id) === prodNum);
    });
}

// ── 신규 등록 ─────────────────────────────────────
function openNew() {
    isNew      = true;
    selectedId = null;

    document.getElementById('dpIco').textContent         = '＋';
    document.getElementById('dpTitle').textContent       = '신규 상품 등록';
    document.getElementById('dpSku').textContent         = '';
    document.getElementById('dpSaveBtn').textContent     = '등록';
    document.getElementById('dpDeleteBtn').style.display = 'none';

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
    isNew = false;
}

// ── 탭 전환 ───────────────────────────────────────
function switchTab(el, tabId) {
    el.closest('.dp-tabs').querySelectorAll('.dp-tab').forEach(function(t){ t.classList.remove('on'); });
    el.classList.add('on');
    switchTabById(tabId);
}
function switchTabById(tabId) {
    document.querySelectorAll('.dp-tab-content').forEach(function(t){ t.classList.remove('active'); });
    document.getElementById(tabId).classList.add('active');
}

// ── 검색 필터 ─────────────────────────────────────
function filterTable(val) {
    var q = (val || document.getElementById('searchInput').value).toLowerCase();
    document.querySelectorAll('.prod-row').forEach(function(row) {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}

// ── 체크박스 ──────────────────────────────────────
function toggleAll(cb) {
    document.querySelectorAll('.row-chk').forEach(function(c){ c.checked = cb.checked; });
    updateSelCount();
}
function updateSelCount() {
    document.getElementById('selCount').textContent =
        document.querySelectorAll('.row-chk:checked').length;
}
</script>

</body>
</html>
