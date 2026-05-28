<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
.list-panel{display:flex;flex-direction:column;background:var(--bg);transition:width .3s cubic-bezier(.4,0,.2,1);width:100%;overflow:hidden;flex-shrink:0;padding:24px;gap:16px;}
.list-panel.shrunk{width:calc(100% - 560px)}
.toolbar{display:flex;align-items:center;gap:8px;flex-shrink:0;flex-wrap:wrap;}
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
.btn-sm{padding:5px 10px;font-size:11px}.btn-xs{padding:3px 8px;font-size:10px}
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06);display:flex;flex-direction:column;flex:1;min-height:0;}
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
.bdg-green{background:var(--green-lt);color:#065F46}.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-red{background:var(--red-lt);color:#991B1B}.bdg-gray{background:var(--gray7);color:var(--gray3)}.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.prog-wrap{display:flex;align-items:center;gap:6px}
.prog-track{flex:1;height:4px;background:var(--gray6);border-radius:2px;overflow:hidden;min-width:50px}
.prog-fill{height:100%;border-radius:2px}
.prog-ok{background:var(--blue)}.prog-warn{background:var(--amber)}.prog-low{background:var(--red)}
.prog-num{font-family:'DM Mono',monospace;font-size:10px;color:var(--gray3);width:30px;text-align:right;flex-shrink:0}
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 18px;border-top:1px solid var(--gray6);background:var(--white);flex-shrink:0;}
.page-info{font-size:12px;color:var(--gray3)}.page-info strong{color:var(--gray1)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}
.pg-btn.disabled{opacity:0.4;cursor:not-allowed}
.detail-panel{width:0;overflow:hidden;flex-shrink:0;display:flex;flex-direction:column;border-left:1px solid var(--gray6);background:var(--white);transition:width .3s cubic-bezier(.4,0,.2,1);position:relative;}
.detail-panel.open{width:560px}
.dp-hdr{height:50px;background:var(--navy);display:flex;align-items:center;padding:0 18px;gap:10px;flex-shrink:0;white-space:nowrap;overflow:hidden;}
.dp-hdr-ico{width:28px;height:28px;background:rgba(255,255,255,.1);border-radius:5px;display:flex;align-items:center;justify-content:center;font-size:12px;flex-shrink:0;overflow:hidden;}
.dp-hdr-title{font-size:13.5px;font-weight:700;color:#fff;flex:1;overflow:hidden;text-overflow:ellipsis}
.dp-hdr-sku{font-size:10px;font-family:'DM Mono',monospace;color:rgba(255,255,255,.4);padding:2px 7px;background:rgba(255,255,255,.07);border-radius:3px;white-space:nowrap}
.dp-close{width:28px;height:28px;border:none;background:rgba(255,255,255,.08);border-radius:5px;color:rgba(255,255,255,.6);font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .15s;}
.dp-close:hover{background:rgba(255,255,255,.16);color:#fff}
.dp-tabs{display:flex;border-bottom:2px solid var(--gray6);flex-shrink:0;background:var(--bg2);overflow:hidden;}
.dp-tab{padding:9px 16px;font-size:11.5px;font-weight:600;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .15s;text-transform:uppercase;letter-spacing:.05em;white-space:nowrap;}
.dp-tab.on{color:var(--blue);border-bottom-color:var(--blue)}.dp-tab:hover{color:var(--gray2)}
.dp-body{flex:1;overflow-y:auto;padding:20px}
.dp-body::-webkit-scrollbar{width:4px}.dp-body::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:2px}
.dp-section{margin-bottom:22px}
.dp-section-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px;}
.dp-section-title::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block;}
.fg-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.fg-full{grid-column:1/-1}
.fg{display:flex;flex-direction:column;gap:5px}
.fg label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.fi{padding:9px 11px;border:1px solid var(--gray5);background:var(--white);border-radius:6px;font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray1);outline:none;width:100%;transition:border .15s;}
.fi:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.fi::placeholder{color:var(--gray4)}.fi:read-only{background:var(--gray7);color:var(--gray3);cursor:default}
select.fi option{background:var(--white)}
textarea.fi{resize:vertical;min-height:72px}
.img-zone-btn{border:2px dashed var(--gray5);border-radius:8px;padding:8px 16px;display:inline-flex;align-items:center;gap:6px;cursor:pointer;transition:all .18s;background:var(--bg2);font-size:12px;color:var(--gray4);}
.img-zone-btn:hover{border-color:var(--blue);background:var(--blue-lt);color:var(--blue)}
.img-previews{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
.img-thumb{width:64px;height:64px;border-radius:6px;background:var(--gray7);border:1px solid var(--gray5);display:flex;align-items:center;justify-content:center;font-size:22px;position:relative;overflow:hidden;transition:border .15s;}
.img-thumb.main-img{border:2px solid var(--blue)}
.img-main-badge{position:absolute;bottom:0;left:0;right:0;background:var(--blue);color:#fff;font-size:9px;font-weight:700;text-align:center;padding:2px;letter-spacing:.05em;}
.chip-row{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px}
.chip{padding:5px 11px;border:1.5px solid var(--gray5);border-radius:5px;font-size:11.5px;cursor:pointer;font-family:'Pretendard',sans-serif;font-weight:500;background:var(--white);color:var(--gray3);transition:all .15s;}
.chip.on{border-color:var(--blue);color:var(--blue);background:var(--blue-lt);font-weight:700}
.chip:hover:not(.on){border-color:var(--gray3);color:var(--gray2)}
.chip.color-chip{display:flex;align-items:center;gap:5px}
.color-dot{width:10px;height:10px;border-radius:50%;border:1px solid rgba(0,0,0,.1);flex-shrink:0}
.dp-footer{padding:12px 20px;border-top:1px solid var(--gray6);background:var(--bg2);display:flex;gap:8px;justify-content:flex-end;flex-shrink:0;}
.dp-tab-content{display:none}.dp-tab-content.active{display:block}
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
    </div>
  </div>

  <div class="body-wrap">
    <div class="list-panel" id="listPanel">
      <form class="toolbar" action="${pageContext.request.contextPath}/logistics/log_prod/log_prodForm.do" method="get">
        <div class="search-wrap">
          <span class="search-ico">🔍</span>
          <input type="text" name="keyword" value="${keyword}" placeholder="품번·상품명·브랜드 검색">
        </div>
        <select class="sel" name="brand">
          <option value="">전체 브랜드</option>
          <c:forEach var="b" items="${brandList}">
            <option value="${b.brandName}" ${brandSel eq b.brandName ? 'selected':''}>${b.brandName}</option>
          </c:forEach>
        </select>
        <select class="sel" name="status">
          <option value="">전체 상태</option>
          <option value="판매중" ${statusSel eq '판매중' ? 'selected':''}>판매중</option>
          <option value="주의"   ${statusSel eq '주의'   ? 'selected':''}>주의</option>
          <option value="품절"   ${statusSel eq '품절'   ? 'selected':''}>품절</option>
          <option value="숨김"   ${statusSel eq '숨김'   ? 'selected':''}>숨김</option>
        </select>
        <div style="margin-left:auto;display:flex;gap:7px;">
          <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>
          <button type="button" class="btn btn-blue btn-sm" onclick="openNew()">＋ 상품 등록</button>
        </div>
      </form>

      <div class="tbl-card">
        <div class="tbl-outer">
          <table>
            <thead>
              <tr>
                <th style="width:36px"><input type="checkbox" onchange="toggleAll(this)"></th>
                <th>이미지</th><th>품번(SKU)</th><th>브랜드</th><th>상품명</th>
                <th>카테고리</th><th>사이즈 범위</th><th>컬러</th>
                <th>총 재고</th><th>재고율</th><th>상태</th><th>관리</th>
              </tr>
            </thead>
            <tbody id="prodTbody">
              <c:choose>
                <c:when test="${not empty list}">
                  <c:forEach var="p" items="${list}">
                    <c:set var="maxStk"  value="${p.maxStock > 0 ? p.maxStock : 100}"/>
                    <c:set var="pct"     value="${p.stockQty * 100 / maxStk}"/>
                    <c:set var="progCls" value="${p.stockQty==0?'prog-low':pct<15?'prog-low':pct<30?'prog-warn':'prog-ok'}"/>
                    
                    <%-- 🚨 수정한 부분: 숨김(2) 상태를 최우선으로 검사하도록 변경! 🚨 --%>
                    <c:set var="bdgCls"  value="${p.prodStatus==2?'bdg-gray':p.stockQty==0?'bdg-red':pct<20?'bdg-amber':'bdg-green'}"/>
                    <c:set var="bdgTxt"  value="${p.prodStatus==2?'숨김':p.stockQty==0?'품절':pct<20?'주의':'판매중'}"/>
                    
                    <tr class="prod-row" data-id="${p.prodNum}"
                        data-desc="${p.prodText}" data-colors="${p.colorList}"
                        data-sizes="${p.sizeList}" data-img="${p.prodImgUrl}"
                        data-imgs="${p.prodImgListStr}"
                        data-regdate="${p.prodCreatedAt}"
                        data-gender="${p.gender}"
                        onclick="openDetailFromServer(${p.prodNum},'${p.prodName}','${p.sku}','${p.brandName}','${p.catName}',${p.prodPrice},${p.prodStatus},this)">
                      <td onclick="event.stopPropagation()"><input type="checkbox" class="row-chk" onchange="updateSelCount()"></td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty p.prodImgUrl}">
                            <img src="${pageContext.request.contextPath}/upload/${p.prodImgUrl}" style="width:36px;height:36px;border-radius:4px;object-fit:cover;border:1px solid var(--gray6);">
                          </c:when>
                          <c:otherwise>
                            <div style="width:36px;height:36px;background:var(--bg2);border-radius:4px;display:flex;align-items:center;justify-content:center;border:1px solid var(--gray6);font-size:16px;">👟</div>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3);">${p.sku}</td>
                      <td>${p.brandName}</td>
                      <td style="font-weight:600;color:var(--gray1);">${p.prodName}</td>
                      <td><span class="bdg bdg-gray">${p.catName}</span></td>
                      <td style="font-family:'DM Mono',monospace;font-size:11px;">${not empty p.sizeRange ? p.sizeRange : '-'}</td>
                      <td style="text-align:center;">${p.colorCnt>0?p.colorCnt:'-'}<c:if test="${p.colorCnt>0}">색</c:if></td>
                      <td style="font-family:'DM Mono',monospace;font-weight:600;">${p.stockQty}</td>
                      <td style="min-width:100px;">
                        <div class="prog-wrap">
                          <div class="prog-track"><div class="prog-fill ${progCls}" style="width:${pct}%"></div></div>
                          <div class="prog-num">${pct}%</div>
                        </div>
                      </td>
                      <td><span class="bdg ${bdgCls}">${bdgTxt}</span></td>
                      <td onclick="event.stopPropagation()" style="display:flex;gap:4px;align-items:center;">
                        <button class="btn btn-outline btn-xs" onclick="openDetailFromServer(${p.prodNum},'${p.prodName}','${p.sku}','${p.brandName}','${p.catName}',${p.prodPrice},${p.prodStatus},document.querySelector('[data-id=\'${p.prodNum}\']'))">상세</button>
                        <button class="btn btn-danger btn-xs" onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logistics/log_prod/log_prodDel.do?prodNum=${p.prodNum}'">삭제</button>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="12" style="text-align:center;padding:40px;color:var(--gray4);">📭 등록된 상품이 없습니다.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
        <div class="pagination-wrap" id="prodPagination" style="display:none;">
          <div class="page-info" id="prodPageInfo">총 <strong>0</strong>개 · 선택 <strong id="selCount">0</strong>개</div>
          <div class="page-btns" id="prodPageBtns"></div>
        </div>
      </div>
    </div>

    <div class="detail-panel" id="detailPanel">
      <div class="dp-hdr">
        <div class="dp-hdr-ico" id="dpIco">📑</div>
        <div class="dp-hdr-title" id="dpTitle">상품 상세정보</div>
        <div class="dp-hdr-sku"   id="dpSku"></div>
        <button class="dp-close" onclick="closeDetail()">✕</button>
      </div>
      <div class="dp-tabs">
        <div class="dp-tab on" onclick="switchTab(this,'tab-info')">기본 정보</div>
        <div class="dp-tab"    onclick="switchTab(this,'tab-stock')">옵션 / 재고</div>
      </div>
      <form id="prodRegForm" action="" method="post" enctype="multipart/form-data" style="flex:1;display:flex;flex-direction:column;overflow:hidden;">
        <input type="hidden" id="h-prodNum"  name="prodNum"  value="">
        <input type="hidden" id="h-catNum"   name="catNum"   value="">
        <input type="hidden" id="h-brandNum" name="brandNum" value="">
        <input type="hidden" id="h-colors"   name="colors"   value="">
        <input type="hidden" id="h-sizes"    name="sizes"    value="">

        <div class="dp-body">
          <div class="dp-tab-content active" id="tab-info">

            <div class="dp-section">
              <div class="dp-section-title">상품 이미지 (최대 5장 · 한 번에 여러 장을 드래그하여 선택하세요)</div>

              <div class="img-previews" id="imgPreviews">
                <div class="img-thumb main-img">
                  <span style="font-size:22px;">👟</span>
                  <div class="img-main-badge">대표</div>
                </div>
              </div>

              <div style="margin-top:10px;display:flex;align-items:center;gap:10px;">
                <div class="img-zone-btn" onclick="document.getElementById('fileInput').click()">
                  <span style="font-size:16px;">＋</span> 이미지 추가 (최대 5장)
                </div>
                <span style="font-size:11px;color:var(--gray4);" id="imgCount">0 / 5장</span>
              </div>
              <div style="font-size:10px;color:var(--gray4);margin-top:6px;">
                첫 번째 이미지가 대표입니다. 이미지를 다시 선택하면 전체 교체됩니다.
              </div>

              <input type="file" id="fileInput" name="uploadFile"
                     accept="image/*" multiple style="display:none"
                     onchange="previewImages(this)">
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
                <div class="fg"><label>품번 등록일</label><input class="fi" id="fi-regdate" readonly></div>
                <div class="fg fg-full"><label>상품명 <span style="color:var(--red)">*</span></label><input class="fi" id="fi-name" name="prodName" placeholder="상품명을 입력하세요"></div>
                <div class="fg">
                  <label>브랜드 <span style="color:var(--red)">*</span></label>
                  <select class="fi" id="fi-brand">
                    <option value="">브랜드 선택</option>
                    <c:forEach var="b" items="${brandList}"><option value="${b.brandName}" data-num="${b.brandNum}">${b.brandName}</option></c:forEach>
                  </select>
                </div>
                <div class="fg">
                  <label>카테고리 <span style="color:var(--red)">*</span></label>
                  <select class="fi" id="fi-cat">
                    <option value="">카테고리 선택</option>
                    <c:forEach var="c" items="${catList}"><option value="${c.catName}" data-num="${c.catNum}">${c.catName}</option></c:forEach>
                  </select>
                </div>
                <div class="fg"><label>정가 (원) <span style="color:var(--red)">*</span></label><input class="fi" id="fi-price" name="prodPrice" type="number" placeholder="0"></div>
                <div class="fg"><label>할인율 (%)</label><input class="fi" id="fi-sale" name="saleRate" type="number" placeholder="0" min="0" max="100"></div>
                <div class="fg">
                  <label>성별</label>
                  <select class="fi" id="fi-gender" name="gender"><option value="0">공용</option><option value="1">남성</option><option value="2">여성</option></select>
                </div>
                <div class="fg">
                  <label>판매 상태</label>
                  <select class="fi" id="fi-status" name="prodStatus"><option value="1">판매중</option><option value="2">숨김</option><option value="3">품절</option></select>
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
                <div class="chip" onclick="this.classList.toggle('on')">220</div><div class="chip" onclick="this.classList.toggle('on')">225</div>
                <div class="chip on" onclick="this.classList.toggle('on')">230</div><div class="chip on" onclick="this.classList.toggle('on')">235</div>
                <div class="chip on" onclick="this.classList.toggle('on')">240</div><div class="chip on" onclick="this.classList.toggle('on')">245</div>
                <div class="chip on" onclick="this.classList.toggle('on')">250</div><div class="chip on" onclick="this.classList.toggle('on')">255</div>
                <div class="chip on" onclick="this.classList.toggle('on')">260</div><div class="chip on" onclick="this.classList.toggle('on')">265</div>
                <div class="chip on" onclick="this.classList.toggle('on')">270</div><div class="chip" onclick="this.classList.toggle('on')">275</div>
                <div class="chip" onclick="this.classList.toggle('on')">280</div><div class="chip" onclick="this.classList.toggle('on')">285</div>
              </div>
            </div>

          </div>

          <div class="dp-tab-content" id="tab-stock">
            <div style="padding:40px;text-align:center;color:var(--gray4);font-size:12px;">옵션/재고 관리 기능 준비중</div>
          </div>
        </div>

        <div class="dp-footer">
          <button type="button" class="btn btn-danger btn-sm" id="dpDeleteBtn" onclick="deleteProd()">삭제</button>
          <div style="display:flex;gap:8px;margin-left:auto">
            <button type="button" class="btn btn-outline" onclick="closeDetail()">취소</button>
            <button type="button" class="btn btn-blue" id="dpSaveBtn" onclick="submitProd()">저장</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</main>

<div class="toast" id="toast"></div>

<script>
var selectedId = null;
var isNew      = false;

function updateClock() {
    var now = new Date();
    var s = now.getFullYear() + "-" + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + "  "
          + String(now.getHours()).padStart(2,'0') + ":" + String(now.getMinutes()).padStart(2,'0');
    var el = document.getElementById("realTimeClock");
    if (el) el.innerText = s;
}
updateClock(); setInterval(updateClock, 60000);

function showToast(msg) {
    var t = document.getElementById('toast'); if (!t) return;
    t.textContent = msg; t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

function previewImages(input) {
    if (!input.files || input.files.length === 0) return;
    var files = Array.from(input.files);
    if (files.length > 5) {
        showToast('⚠ 이미지는 한 번에 최대 5장까지만 선택 가능합니다.');
        return;
    }
    var container = document.getElementById('imgPreviews');
    container.innerHTML = '';
    files.forEach(function(file, idx) {
        if (!file.type.startsWith('image/')) return;
        var reader = new FileReader();
        reader.onload = function(e) {
            var div = document.createElement('div');
            div.className = 'img-thumb' + (idx === 0 ? ' main-img' : '');
            div.innerHTML = '<img src="' + e.target.result
                + '" style="width:100%;height:100%;object-fit:cover;border-radius:5px;">'
                + (idx === 0 ? '<div class="img-main-badge">대표</div>' : '');
            container.appendChild(div);
            if (idx === 0) {
                document.getElementById('dpIco').innerHTML =
                    '<img src="' + e.target.result
                    + '" style="width:100%;height:100%;object-fit:cover;border-radius:5px;">';
            }
        };
        reader.readAsDataURL(file);
    });
    document.getElementById('imgCount').textContent = files.length + ' / 5장';
    showToast('✅ ' + files.length + '장 선택되었습니다. 저장 시 교체 반영됩니다.');
}
function resetImages() {
    document.getElementById('fileInput').value = '';
    document.getElementById('imgPreviews').innerHTML =
        '<div class="img-thumb main-img">'
        + '<span style="font-size:22px;">👟</span>'
        + '<div class="img-main-badge">대표</div></div>';
    document.getElementById('imgCount').textContent = '0 / 5장';
    document.getElementById('dpIco').innerHTML = '📑';
}

function openDetailFromServer(prodNum, prodName, sku, brandName, catName, prodPrice, prodStatus, rowEl) {
    isNew = false; selectedId = prodNum;
    resetImages();
    var cp = '${pageContext.request.contextPath}';
    var imgsStr = rowEl ? (rowEl.getAttribute('data-imgs') || '') : '';
    var container = document.getElementById('imgPreviews');
    container.innerHTML = '';

    if (imgsStr && imgsStr !== 'null' && imgsStr.trim() !== '') {
        var imgArr = imgsStr.split(',');
        imgArr.forEach(function(imgName, idx) {
            if(!imgName.trim()) return;
            var imgSrc = cp + '/upload/' + imgName.trim();
            var div = document.createElement('div');
            div.className = 'img-thumb' + (idx === 0 ? ' main-img' : '');
            div.innerHTML = '<img src="' + imgSrc + '" style="width:100%;height:100%;object-fit:cover;border-radius:5px;" onerror="this.src=\'\'">'
                + (idx === 0 ? '<div class="img-main-badge">대표</div>' : '');
            container.appendChild(div);
            if (idx === 0) {
                document.getElementById('dpIco').innerHTML = 
                    '<img src="' + imgSrc + '" style="width:100%;height:100%;object-fit:cover;border-radius:5px;" onerror="this.src=\'\'">';
            }
        });
        document.getElementById('imgCount').textContent = imgArr.length + ' / 5장';
    } else {
        resetImages();
    }

    document.getElementById('dpTitle').textContent       = prodName;
    document.getElementById('dpSku').textContent         = sku;
    document.getElementById('dpSaveBtn').textContent     = '수정 저장';
    document.getElementById('dpDeleteBtn').style.display = '';
    document.getElementById('fi-sku').value    = sku;
    document.getElementById('fi-name').value   = prodName;
    document.getElementById('fi-brand').value  = brandName;
    document.getElementById('fi-cat').value    = catName;
    document.getElementById('fi-price').value  = prodPrice;
    document.getElementById('fi-status').value = prodStatus;
    document.getElementById('fi-desc').value   = rowEl ? (rowEl.getAttribute('data-desc') || '') : '';
    
    var genderVal = rowEl ? (rowEl.getAttribute('data-gender') || '0') : '0';
    document.getElementById('fi-gender').value = genderVal;

    var regDate = rowEl ? (rowEl.getAttribute('data-regdate') || '') : '';
    document.getElementById('fi-regdate').value = regDate.substring(0, 10);
    document.querySelectorAll('.prod-row').forEach(r => r.classList.remove('selected'));
    if (rowEl) rowEl.classList.add('selected');
    document.querySelectorAll('.chip').forEach(c => c.classList.remove('on'));
    var colorArr = rowEl ? (rowEl.getAttribute('data-colors') || '').split(',') : [];
    document.querySelectorAll('#colorChips .chip').forEach(function(c) {
        if (colorArr.includes(c.innerText.trim())) c.classList.add('on');
    });
    var sizeArr = rowEl ? (rowEl.getAttribute('data-sizes') || '').split(',') : [];
    document.querySelectorAll('#sizeChips .chip').forEach(function(c) {
        if (sizeArr.includes(c.innerText.trim())) c.classList.add('on');
    });
    switchTabById('tab-info');
    openPanel();
}

function openNew() {
    isNew = true; selectedId = null;
    resetImages();
    document.getElementById('dpIco').innerHTML       = '＋';
    document.getElementById('dpTitle').textContent   = '신규 상품 등록';
    document.getElementById('dpSaveBtn').textContent = '등록';
    document.getElementById('dpDeleteBtn').style.display = 'none';
    ['fi-sku','fi-regdate','fi-name','fi-price','fi-sale','fi-desc'].forEach(function(id) {
        var el = document.getElementById(id); if (el) el.value = '';
    });
    document.getElementById('fi-brand').value  = '';
    document.getElementById('fi-cat').value    = '';
    document.getElementById('fi-gender').value = '0';
    document.getElementById('fi-status').value = '1';
    document.querySelectorAll('.chip').forEach(c => c.classList.remove('on'));
    switchTabById('tab-info');
    openPanel();
    document.querySelectorAll('.prod-row').forEach(r => r.classList.remove('selected'));
}

function submitProd() {
    var sku      = document.getElementById('fi-sku').value.trim();
    var name     = document.getElementById('fi-name').value.trim();
    var price    = document.getElementById('fi-price').value.trim();
    var brandSel = document.getElementById('fi-brand');
    var catSel   = document.getElementById('fi-cat');
    
    if (!sku) {
        alert('상품 고유코드(SKU)를 입력하거나 자동 생성해 주세요.');
        document.getElementById('fi-sku').focus();
        return;
    }
    if (!name) {
        alert('상품명을 입력해 주세요.');
        document.getElementById('fi-name').focus();
        return;
    }
    if (brandSel.selectedIndex <= 0) {
        alert('브랜드를 선택해 주세요.');
        brandSel.focus();
        return;
    }
    if (catSel.selectedIndex <= 0) {
        alert('카테고리를 선택해 주세요.');
        catSel.focus();
        return;
    }
    if (!price || price <= 0) {
        alert('정확한 상품 가격을 입력해 주세요.');
        document.getElementById('fi-price').focus();
        return;
    }

    if (isNew) {
        var fileInput = document.getElementById('fileInput');
        if (!fileInput.files || fileInput.files.length === 0) {
            alert('최소 1장 이상의 상품 사진을 등록해야 합니다.');
            return;
        }
    }

    var brandNum = brandSel.options[brandSel.selectedIndex].getAttribute('data-num');
    var catNum   = catSel.options[catSel.selectedIndex].getAttribute('data-num');

    document.getElementById('h-brandNum').value = brandNum;
    document.getElementById('h-catNum').value   = catNum;

    var colors = [];
    document.querySelectorAll('#colorChips .chip.on').forEach(c => colors.push(c.innerText.trim()));
    if (colors.length === 0) {
        alert('최소 하나 이상의 컬러 옵션을 선택해 주세요.');
        return;
    }
    document.getElementById('h-colors').value = colors.join(',');

    var sizes = [];
    document.querySelectorAll('#sizeChips .chip.on').forEach(c => sizes.push(c.innerText.trim()));
    if (sizes.length === 0) {
        alert('최소 하나 이상의 사이즈 옵션을 선택해 주세요.');
        return;
    }
    document.getElementById('h-sizes').value = sizes.join(',');

    var form = document.getElementById('prodRegForm');
    var cp   = '${pageContext.request.contextPath}';
    
    if (isNew) {
        document.getElementById('h-prodNum').value = '';
        form.action = cp + '/logistics/log_prod/log_prodReg.do';
    } else {
        document.getElementById('h-prodNum').value = selectedId;
        form.action = cp + '/logistics/log_prod/log_prodMod.do';
    }
    
    if(confirm('이대로 저장하시겠습니까?')) {
        form.submit();
    }
}

function deleteProd() {
    if (!selectedId || !confirm('삭제하시겠습니까?')) return;
    location.href = '${pageContext.request.contextPath}/logistics/log_prod/log_prodDel.do?prodNum=' + selectedId;
}

function openPanel() {
    document.getElementById('detailPanel').classList.add('open');
    document.getElementById('listPanel').classList.add('shrunk');
}
function closeDetail() {
    document.getElementById('detailPanel').classList.remove('open');
    document.getElementById('listPanel').classList.remove('shrunk');
    document.querySelectorAll('.prod-row').forEach(r => r.classList.remove('selected'));
    selectedId = null; isNew = false;
    resetImages();
}
function switchTab(el, tabId) {
    el.closest('.dp-tabs').querySelectorAll('.dp-tab').forEach(t => t.classList.remove('on'));
    el.classList.add('on'); switchTabById(tabId);
}
function switchTabById(tabId) {
    document.querySelectorAll('.dp-tab-content').forEach(t => t.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
}
function toggleAll(cb) {
    document.querySelectorAll('.prod-row:not([style*="display: none"]) .row-chk').forEach(c => c.checked = cb.checked);
    updateSelCount();
}
function updateSelCount() {
    document.getElementById('selCount').textContent = document.querySelectorAll('.row-chk:checked').length;
}

function generateSKU() {
    var brand = document.getElementById('fi-brand').value;
    if (!brand) { alert("브랜드를 먼저 선택해 주세요."); return; }
    function makePrefix(name) {
        var result = '';
        var choMap = ['ㄱ','ㄲ','ㄴ','ㄷ','ㄸ','ㄹ','ㅁ','ㅂ','ㅃ','ㅅ','ㅆ','ㅇ','ㅈ','ㅉ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ'];
        var engMap = {'ㄱ':'G','ㄲ':'G','ㄴ':'N','ㄷ':'D','ㄸ':'D','ㄹ':'R','ㅁ':'M','ㅂ':'B','ㅃ':'B',
                      'ㅅ':'S','ㅆ':'S','ㅇ':'Y','ㅈ':'J','ㅉ':'J','ㅊ':'C','ㅋ':'K','ㅌ':'T','ㅍ':'P','ㅎ':'H'};
        for (var i = 0; i < name.length && result.length < 2; i++) {
            var code = name.charCodeAt(i);
            if (code >= 65 && code <= 90) { result += name[i]; }
            else if (code >= 97 && code <= 122) { result += name[i].toUpperCase(); }
            else if (code >= 0xAC00 && code <= 0xD7A3) {
                var cho = choMap[Math.floor((code - 0xAC00) / 28 / 21)];
                result += (engMap[cho] || cho);
            }
        }
        while (result.length < 2) result += 'X';
        return result.toUpperCase();
    }
    var prefix = makePrefix(brand);
    var now = new Date();
    var rand = '';
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    for (var i = 0; i < 4; i++) rand += chars.charAt(Math.floor(Math.random() * chars.length));
    document.getElementById('fi-sku').value =
        prefix + "-" + String(now.getFullYear()).slice(2)
        + String(now.getMonth()+1).padStart(2,'0')
        + String(now.getDate()).padStart(2,'0') + "-" + rand;
    showToast('상품 고유코드가 자동 생성되었습니다. (' + prefix + ')');
}

let currentProdPage = 1;
const prodItemsPerPage = 10;
let allProdRows = [];

window.addEventListener('load', function() {
    var tbody = document.getElementById('prodTbody');
    if (tbody) {
        allProdRows = Array.from(tbody.querySelectorAll('.prod-row'));
        if (allProdRows.length > 0) { renderProdTable(); }
        else { document.getElementById('prodPagination').style.display = 'none'; }
    }
    
    const urlParams = new URLSearchParams(window.location.search);
    const resultMsg = urlParams.get('result');

    if (resultMsg === 'fk_error') {
        alert("해당 상품과 연결된 입출고 또는 재고 내역이 존재하여 삭제할 수 없습니다.\n상품 상세정보에서 '숨김' 상태를 이용해 주세요.");
        window.history.replaceState({}, document.title, window.location.pathname);
    } else if (resultMsg === 'deleted') {
        alert("상품이 성공적으로 삭제되었습니다.");
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

function renderProdTable() {
    allProdRows.forEach(r => r.style.display = 'none');
    var start = (currentProdPage - 1) * prodItemsPerPage;
    var end   = start + prodItemsPerPage;
    for (var i = start; i < end && i < allProdRows.length; i++) allProdRows[i].style.display = '';
    renderProdPagination();
}

function renderProdPagination() {
    var tot = Math.ceil(allProdRows.length / prodItemsPerPage);
    var pw  = document.getElementById('prodPagination');
    var pi  = document.getElementById('prodPageInfo');
    var pb  = document.getElementById('prodPageBtns');
    if (!pw || !pb) return;
    pw.style.display = 'flex';
    var sn = (currentProdPage - 1) * prodItemsPerPage + 1;
    var en = Math.min(currentProdPage * prodItemsPerPage, allProdRows.length);
    pi.innerHTML = `총 <strong style="color:var(--gray1)">\${allProdRows.length}</strong>개 · 선택 <strong id="selCount">0</strong>개 · \${sn}-\${en}`;
    var h = `<div class="pg-btn \${currentProdPage===1?'disabled':''}" onclick="changeProdPage(\${currentProdPage-1})">‹</div>`;
    for (var i = 1; i <= tot; i++)
        h += `<div class="pg-btn \${i===currentProdPage?'on':''}" onclick="changeProdPage(\${i})">\${i}</div>`;
    h += `<div class="pg-btn \${currentProdPage===tot?'disabled':''}" onclick="changeProdPage(\${currentProdPage+1})">›</div>`;
    pb.innerHTML = h;
}

function changeProdPage(p) {
    var tot = Math.ceil(allProdRows.length / prodItemsPerPage);
    if (p < 1 || p > tot) return;
    currentProdPage = p;
    renderProdTable();
    document.querySelectorAll('.row-chk').forEach(c => c.checked = false);
    updateSelCount();
}
</script>
</body>
</html>