<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고현황 조회</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab-btn{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}
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
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.sw{position:relative;flex:1;min-width:180px;max-width:260px}
.sw input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.sw input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.sw input::placeholder{color:var(--gray4)}
.sw-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;}
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-amber{background:var(--amber);color:#fff}.btn-amber:hover{background:#D97706}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-sm{padding:7px 13px;font-size:12px}.btn-xs{padding:4px 10px;font-size:11px}
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
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-green{background:var(--green-lt);color:#065F46}.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}.bdg-blue{background:var(--blue-lt);color:var(--blue)}.bdg-gray{background:var(--gray7);color:var(--gray3)}
.prog-wrap{display:flex;align-items:center;gap:8px}
.prog-track{flex:1;height:6px;background:var(--gray6);border-radius:3px;overflow:hidden;min-width:60px}
.prog-fill{height:100%;border-radius:3px}
.p-ok{background:var(--blue)}.p-warn{background:var(--amber)}.p-low{background:var(--red)}.p-zero{background:var(--gray5)}
.prog-num{font-family:'DM Mono',monospace;font-size:10px;color:var(--gray3);width:28px;text-align:right;flex-shrink:0}
.mini-kpi-row{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:18px}
.mini-kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:16px 18px;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.mk-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:6px}
.mk-val{font-family:'DM Mono',monospace;font-size:30px;font-weight:700;letter-spacing:-1px}
.mk-sub{font-size:11px;color:var(--gray4);margin-top:3px}
.pg-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.pg-info{font-size:12px;color:var(--gray3)}
.pg-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}
.pg-btn.disabled{opacity:.4;cursor:not-allowed}
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:620px;max-height:90vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}
.sec-ttl{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px}
.sec-ttl::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}
.sz-tbl{width:100%;border-collapse:collapse}
.sz-tbl th{padding:8px 12px;font-size:9.5px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left}
.sz-tbl td{padding:10px 12px;font-size:12.5px;color:var(--gray2);border-bottom:1px solid var(--gray7)}
.sz-tbl tr:last-child td{border-bottom:none}
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>
<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur">재고현황 조회</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>      
    </div>
  </div>

  <div class="content">

    <div class="sum-row">
      <div class="sum-card blue" id="card-all" onclick="switchTab('all')">
        <div class="sum-icon">📦</div>
        <div class="sum-label">전체 재고</div>
        <div class="sum-val c-blue">${totalStock}</div>
        <div class="sum-sub">켤레 보유 중</div>
      </div>
      <div class="sum-card amber" id="card-low" onclick="switchTab('low')">
        <div class="sum-icon">⚠️</div>
        <div class="sum-label">재고 부족 옵션</div>
        <div class="sum-val c-amber">${lowStockCount}</div>
        <div class="sum-sub">기준 수량(10개) 미만</div>
      </div>
      <div class="sum-card red" id="card-zero" onclick="switchTab('zero')">
        <div class="sum-icon">🚫</div>
        <div class="sum-label">품절 옵션</div>
        <div class="sum-val c-red">${zeroCount}</div>
        <div class="sum-sub">재고 0개 옵션</div>
      </div>
      <div class="sum-card green" id="card-ok" onclick="switchTab('all')">
        <div class="sum-icon">✅</div>
        <div class="sum-label">정상 재고</div>
        <div class="sum-val c-green">${okCount}</div>
        <div class="sum-sub">정상 보유 옵션</div>
      </div>
    </div>

    <div class="tab-bar">
      <div class="tab-btn on" id="tab-all" onclick="switchTab('all')">
        🗃️ 전체 재고 <span class="tab-cnt" style="background:var(--blue)">${stockList.size()}</span>
      </div>
      <div class="tab-btn" id="tab-low" onclick="switchTab('low')">
        ⚠️ 재고 부족 <span class="tab-cnt" style="background:var(--amber)">${lowStockCount}</span>
      </div>
      <div class="tab-btn" id="tab-zero" onclick="switchTab('zero')">
        🚫 품절 옵션 <span class="tab-cnt" style="background:var(--red)">${zeroCount}</span>
      </div>
    </div>

    <div id="sec-all">
      <form action="${pageContext.request.contextPath}/logistics/log_stk/log_stkForm.do" method="get" class="toolbar">
        <input type="hidden" name="tab" value="all">
        <div class="sw">
          <span class="sw-ico">🔍</span>
          <input type="text" name="keyword" value="${keyword}" placeholder="상품명·품번·브랜드 검색">
        </div>
        <select class="sel" name="brand">
          <option value="">전체 브랜드</option>
          <c:forEach var="b" items="${brandList}">
            <option value="${b.brandName}" ${brandSel eq b.brandName ? 'selected':''}>${b.brandName}</option>
          </c:forEach>
        </select>
        <select class="sel" name="status">
          <option value="">전체 상태</option>
          <option value="정상"  ${statusSel eq '정상'  ? 'selected':''}>정상</option>
          <option value="부족"  ${statusSel eq '부족'  ? 'selected':''}>부족</option>
          <option value="품절"  ${statusSel eq '품절'  ? 'selected':''}>품절</option>
        </select>
        <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>
        <div style="margin-left:auto;display:flex;gap:7px">
          <button type="button" class="btn btn-blue btn-sm" onclick="updateSyncTime()">🔄 재고 동기화</button>
        </div>
      </form>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">전체 상품 <strong>${stockList.size()}</strong>개 · 옵션 <strong>${totalOptCount}</strong>개</div>
          <div id="syncTime" style="font-size:11px;color:var(--gray4);font-family:'DM Mono',monospace">최종 동기화: 방금 전</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>카테고리</th>
                <th>컬러 수</th><th>사이즈 범위</th><th>전체 재고</th><th>재고율</th><th>상태</th><th>상세</th>
              </tr>
            </thead>
            <tbody id="allTbody">
              <c:forEach var="p" items="${stockList}">
                <c:set var="pct" value="${p.stockQty > 0 ? (p.stockQty > 100 ? 100 : p.stockQty) : 0}"/>
                <c:set var="progCls" value="${p.stockQty == 0 ? 'p-zero' : p.stockQty < 10 ? 'p-low' : p.stockQty < 30 ? 'p-warn' : 'p-ok'}"/>
                <c:set var="bdgCls"  value="${p.stockQty == 0 ? 'bdg-red' : p.stockQty < 10 ? 'bdg-red' : p.stockQty < 30 ? 'bdg-amber' : 'bdg-green'}"/>
                <c:set var="bdgTxt"  value="${p.stockQty == 0 ? '품절' : p.stockQty < 10 ? '부족' : p.stockQty < 30 ? '주의' : '정상'}"/>
                <tr class="trow" onclick="openDetail(${p.prodNum}, '${p.prodName}', '${p.sku}', '${p.brandName}', '${p.catName}', ${p.stockQty}, ${p.colorCnt}, '${p.sizeRange}')">
                  <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">${p.sku}</td>
                  <td>${p.brandName}</td>
                  <td style="font-weight:600;color:var(--gray1)">${p.prodName}</td>
                  <td><span class="bdg bdg-gray" style="font-size:10px">${p.catName}</span></td>
                  <td style="text-align:center;font-family:'DM Mono',monospace;font-weight:600">${p.colorCnt}색</td>
                  <td style="font-family:'DM Mono',monospace;font-size:11px">${not empty p.sizeRange ? p.sizeRange : '-'}</td>
                  <td style="font-family:'DM Mono',monospace;font-weight:700;font-size:13px">${p.stockQty}</td>
                  <td style="min-width:110px">
                    <div class="prog-wrap">
                      <div class="prog-track"><div class="prog-fill ${progCls}" style="width:${pct}%"></div></div>
                      <div class="prog-num">${pct}%</div>
                    </div>
                  </td>
                  <td><span class="bdg ${bdgCls}">${bdgTxt}</span></td>
                  <td onclick="event.stopPropagation()">
                    <button class="btn btn-outline btn-xs" onclick="openDetail(${p.prodNum},'${p.prodName}','${p.sku}','${p.brandName}','${p.catName}',${p.stockQty},${p.colorCnt},'${p.sizeRange}')">사이즈별</button>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty stockList}">
                <tr><td colspan="10" style="text-align:center;padding:40px;color:var(--gray4)">📭 등록된 상품이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
        
        <div class="pg-wrap" id="stkPagination" style="display:none;">
          <div class="pg-info" id="stkPageInfo"></div>
          <div class="pg-btns" id="stkPageBtns"></div>
        </div>
        
      </div>
    </div>

    <div id="sec-low" style="display:none">
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div>재고 기준 수량(10개) 미만 옵션이 <strong>${lowStockCount}개</strong>입니다. 입고 등록을 통해 재고를 보충하세요.</div>
      </div>
      <div class="mini-kpi-row">
        <div class="mini-kpi" style="border-top:3px solid var(--amber)">
          <div class="mk-label">재고 부족 옵션</div>
          <div class="mk-val" style="color:var(--amber)">${lowStockCount}</div>
          <div class="mk-sub">10개 미만 옵션 수</div>
        </div>
        <div class="mini-kpi" style="border-top:3px solid var(--blue)">
          <div class="mk-label">부족 옵션 총 재고</div>
          <div class="mk-val" style="color:var(--blue)">
            <c:set var="lowTotal" value="0"/>
            <c:forEach var="l" items="${lowStockList}"><c:set var="lowTotal" value="${lowTotal + l.stockQty}"/></c:forEach>
            ${lowTotal}
          </div>
          <div class="mk-sub">켤레 합계</div>
        </div>
        <div class="mini-kpi" style="border-top:3px solid var(--red)">
          <div class="mk-label">품절 옵션</div>
          <div class="mk-val" style="color:var(--red)">${zeroCount}</div>
          <div class="mk-sub">재고 0개 옵션</div>
        </div>
      </div>

      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">재고 부족 옵션 <strong>${lowStockCount}</strong>개</div>
          <button class="btn btn-amber btn-sm" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">📥 입고 등록</button>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>사이즈</th><th>컬러</th>
                <th>현재 재고</th><th>기준 수량</th><th>재고율</th><th>상태</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="l" items="${lowStockList}">
                <c:set var="lpct" value="${l.stockQty * 10}"/>
                <tr class="trow">
                  <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">${l.sku}</td>
                  <td>${l.brandName}</td>
                  <td style="font-weight:600;color:var(--gray1)">${l.prodName}</td>
                  <td style="font-family:'DM Mono',monospace;font-weight:600">${l.sizeVal}mm</td>
                  <td>${l.color}</td>
                  <td>
                    <span style="font-family:'DM Mono',monospace;font-size:15px;font-weight:800;color:${l.stockQty <= 3 ? 'var(--red)' : 'var(--amber)'}">
                      ${l.stockQty}
                    </span>
                    <span style="font-size:10px;color:var(--gray4)">개</span>
                  </td>
                  <td style="font-family:'DM Mono',monospace;font-size:12px;color:var(--gray3)">10개</td>
                  <td style="min-width:100px">
                    <div class="prog-wrap">
                      <div class="prog-track"><div class="prog-fill p-low" style="width:${lpct}%"></div></div>
                      <div class="prog-num">${lpct}%</div>
                    </div>
                  </td>
                  <td><span class="bdg bdg-amber">부족</span></td>
                </tr>
              </c:forEach>
              <c:if test="${empty lowStockList}">
                <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--gray4)">✅ 재고 부족 옵션이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div id="sec-zero" style="display:none">
      <div class="alert alert-red">
        <span class="alert-ico">🚫</span>
        <div>재고 <strong>0개</strong>인 품절 옵션이 <strong>${zeroCount}개</strong>입니다. 즉시 입고 처리가 필요합니다.</div>
      </div>
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-info">품절 옵션 <strong>${zeroCount}</strong>개</div>
          <button class="btn btn-blue btn-sm" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">📥 즉시 입고 등록</button>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>품번 (SKU)</th><th>브랜드</th><th>상품명</th><th>사이즈</th><th>컬러</th>
                <th>재고</th><th>마지막 입고일</th><th>상태</th><th>처리</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="z" items="${zeroStockList}">
                <tr class="trow">
                  <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">${z.sku}</td>
                  <td>${z.brandName}</td>
                  <td style="font-weight:600;color:var(--gray1)">${z.prodName}</td>
                  <td style="font-family:'DM Mono',monospace;font-weight:600">${z.sizeVal}mm</td>
                  <td>${z.color}</td>
                  <td><span style="font-family:'DM Mono',monospace;font-size:15px;font-weight:800;color:var(--red)">0</span><span style="font-size:10px;color:var(--gray4)">개</span></td>
                  <td style="font-size:11px;color:var(--gray3)">${z.lastInDate}</td>
                  <td><span class="bdg bdg-red">품절</span></td>
                  <td><button class="btn btn-blue btn-xs" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">📥 즉시 입고</button></td>
                </tr>
              </c:forEach>
              <c:if test="${empty zeroStockList}">
                <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--gray4)">✅ 품절 옵션이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div>
</main>

<div class="modal-bg" id="detailModal">
  <div class="modal">
    <div class="modal-hdr">
      <div class="modal-title" id="modalTitle">📦 재고 상세 현황</div>
      <button class="modal-x" onclick="closeModal()">✕</button>
    </div>
    <div class="modal-body" id="modalBody">
      <div style="text-align:center;padding:30px;color:var(--gray4)">불러오는 중...</div>
    </div>
    <div class="modal-foot">
      <button class="btn btn-outline" onclick="closeModal()">닫기</button>
      <button class="btn btn-amber btn-sm" onclick="closeModal();location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">📥 입고 등록</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>


<script>
var cp = '${pageContext.request.contextPath}';

// ── 시계 ────────────────────────────────────────────
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

// ── 탭 전환 ──────────────────────────────────────────
function switchTab(tab) {
    ['all','low','zero'].forEach(function(t) {
        document.getElementById('sec-' + t).style.display = (t === tab) ? '' : 'none';
        document.getElementById('tab-' + t).classList.toggle('on', t === tab);
    });
    document.getElementById('card-all').classList.toggle('active-card',  tab === 'all');
    document.getElementById('card-low').classList.toggle('active-card',  tab === 'low');
    document.getElementById('card-zero').classList.toggle('active-card', tab === 'zero');
    document.getElementById('card-ok').classList.remove('active-card');
}

// ── 상세 모달 (AJAX로 사이즈별 데이터 조회) ──────────────
function openDetail(prodNum, prodName, sku, brandName, catName, stockQty, colorCnt, sizeRange) {
    document.getElementById('modalTitle').textContent = '📦 ' + prodName + ' — 사이즈별 재고';
    document.getElementById('detailModal').classList.add('open');

    var sizeDetails = {
          <c:forEach var="entry" items="${sizeDetailMap}" varStatus="vs">
            "${entry.key}": [
              <c:forEach var="s" items="${entry.value}" varStatus="ss">
                { sizeVal: ${s.sizeVal}, color: '${s.color}', stockQty: ${s.stockQty} }<c:if test="${!ss.last}">,</c:if>
              </c:forEach>
            ]<c:if test="${!vs.last}">,</c:if>
          </c:forEach>
    };
    
    var data = sizeDetails[prodNum] || [];
    
    var rows = '';
    data.forEach(function(s) {
        var cls   = s.stockQty === 0 ? 'color:var(--red);font-weight:800' : s.stockQty < 10 ? 'color:var(--amber);font-weight:800' : 'color:var(--gray1);font-weight:700';
        var bdgCls= s.stockQty === 0 ? 'bdg-red' : s.stockQty < 10 ? 'bdg-amber' : 'bdg-green';
        var bdgTxt= s.stockQty === 0 ? '품절' : s.stockQty < 10 ? '부족' : '정상';
        var pct   = Math.min(100, s.stockQty);
        var pcls  = s.stockQty === 0 ? 'p-zero' : s.stockQty < 10 ? 'p-low' : 'p-ok';
        rows += '<tr>'
            + '<td style="font-family:\'DM Mono\',monospace;font-weight:600">' + s.sizeVal + 'mm</td>'
            + '<td>' + s.color + '</td>'
            + '<td style="' + cls + ';font-family:\'DM Mono\',monospace">' + s.stockQty + '개</td>'
            + '<td style="min-width:120px"><div class="prog-wrap"><div class="prog-track" style="height:5px"><div class="prog-fill ' + pcls + '" style="width:' + pct + '%"></div></div><div class="prog-num">' + pct + '%</div></div></td>'
            + '<td><span class="bdg ' + bdgCls + '">' + bdgTxt + '</span></td>'
            + '</tr>';
    });

    var valColor = stockQty === 0 ? 'var(--red)' : stockQty < 10 ? 'var(--amber)' : 'var(--green)';
    document.getElementById('modalBody').innerHTML =
        '<div style="display:flex;gap:20px;margin-bottom:18px;flex-wrap:wrap">'
        + '<div style="flex:1;min-width:200px"><div class="sec-ttl">상품 정보</div>'
        + '<div style="display:flex;flex-direction:column;gap:7px">'
        + '<div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">품번 (SKU)</span><span style="font-family:\'DM Mono\',monospace;font-weight:600;color:var(--blue)">' + sku + '</span></div>'
        + '<div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">브랜드</span><span style="font-weight:600">' + brandName + '</span></div>'
        + '<div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">카테고리</span><span>' + catName + '</span></div>'
        + '<div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">컬러 종류</span><span>' + colorCnt + '색</span></div>'
        + '<div style="display:flex;justify-content:space-between;font-size:13px"><span style="color:var(--gray3)">사이즈 범위</span><span style="font-family:\'DM Mono\',monospace">' + sizeRange + 'mm</span></div>'
        + '</div></div>'
        + '<div style="flex:1;min-width:180px"><div class="sec-ttl">재고 요약</div>'
        + '<div style="text-align:center;padding:14px;background:var(--bg2);border-radius:8px">'
        + '<div style="font-family:\'DM Mono\',monospace;font-size:32px;font-weight:700;color:' + valColor + '">' + stockQty + '</div>'
        + '<div style="font-size:11px;color:var(--gray3);margin-top:4px">총 재고 (켤레)</div>'
        + '</div></div></div>'
        + '<div class="sec-ttl">사이즈 × 컬러별 재고 현황</div>'
        + '<table class="sz-tbl"><thead><tr><th>사이즈</th><th>컬러</th><th>재고 수량</th><th>재고 바</th><th>상태</th></tr></thead>'
        + '<tbody>' + (rows || '<tr><td colspan="5" style="text-align:center;color:var(--gray4);padding:20px">등록된 옵션이 없습니다.</td></tr>') + '</tbody></table>';
}

function closeModal() { document.getElementById('detailModal').classList.remove('open'); }
document.getElementById('detailModal').addEventListener('click', function(e) {
    if (e.target === e.currentTarget) closeModal();
});

function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg; t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

// ── 전체 재고 탭 페이징 로직  ───────────────────────
let currentStkPage = 1;
const stkItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allStkRows = []; 

window.addEventListener('load', function() {
    const tbody = document.getElementById('allTbody');
    if(tbody) {
        // 데이터가 없는 경우의 안내 행을 제외하고 데이터 행만 가져옴
        allStkRows = Array.from(tbody.querySelectorAll('.trow'));
        if(allStkRows.length > 0) {
            renderStkTable();
        } else {
            document.getElementById('stkPagination').style.display = 'none';
        }
    }
});

function renderStkTable() {
    // 모든 행을 숨김 처리
    allStkRows.forEach(row => row.style.display = 'none');
    
    // 현재 페이지에 해당하는 행만 표시
    const start = (currentStkPage - 1) * stkItemsPerPage;
    const end = start + stkItemsPerPage;
    for(let i = start; i < end && i < allStkRows.length; i++) {
        allStkRows[i].style.display = '';
    }
    
    // 페이지 버튼 다시 렌더링
    renderStkPagination();
}

function renderStkPagination() {
    const totalPages = Math.ceil(allStkRows.length / stkItemsPerPage);
    const paginWrap = document.getElementById('stkPagination');
    const pageInfo = document.getElementById('stkPageInfo');
    const pageBtns = document.getElementById('stkPageBtns');
    
    if (!paginWrap || !pageBtns) return;
    paginWrap.style.display = 'flex';

    // 건수 정보 업데이트 (예: 1 - 10 / 44건)
    const startNum = (currentStkPage - 1) * stkItemsPerPage + 1;
    const endNum = Math.min(currentStkPage * stkItemsPerPage, allStkRows.length);
    pageInfo.innerHTML = `총 <strong style="color:var(--gray1)">\${allStkRows.length}</strong>건 · \${startNum} - \${endNum} / \${allStkRows.length}건`;

    let btnsHTML = '';
    // 이전 버튼
    btnsHTML += `<div class="pg-btn \${currentStkPage === 1 ? 'disabled' : ''}" onclick="changeStkPage(\${currentStkPage - 1})">‹</div>`;
    
    // 숫자 버튼
    for (let i = 1; i <= totalPages; i++) {
        btnsHTML += `<div class="pg-btn \${i === currentStkPage ? 'on' : ''}" onclick="changeStkPage(\${i})">\${i}</div>`;
    }
    
    // 다음 버튼
    btnsHTML += `<div class="pg-btn \${currentStkPage === totalPages ? 'disabled' : ''}" onclick="changeStkPage(\${currentStkPage + 1})">›</div>`;
    
    pageBtns.innerHTML = btnsHTML;
}

function changeStkPage(page) {
    const totalPages = Math.ceil(allStkRows.length / stkItemsPerPage);
    if (page < 1 || page > totalPages) return; 
    currentStkPage = page;
    renderStkTable();
    document.querySelector('.tbl-wrap').scrollTo(0,0);
}

// 초기 탭 세팅
switchTab('${activeTab}' || 'all');
</script>
</body>
</html>