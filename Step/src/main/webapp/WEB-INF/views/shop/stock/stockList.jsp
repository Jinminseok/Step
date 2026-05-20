<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 실시간 재고 현황</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
/* --- 🚨 핵심 디테일 수정: 모든 요소의 테두리/여백을 너비에 포함 --- */
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body { 
    background-color: #f8f9fa; 
    margin: 0; 
    font-family: 'Pretendard', sans-serif; 
    color: #333;
    overflow-y: scroll; /* 🚨 핵심 디테일: 페이지 전환 시 스크롤바 밀림 방지 */
}

/* 👇 사이드바 너비만큼 본문을 밀어줍니다 */
.main { 
    margin-left: 260px; 
    padding: 30px; 
    box-sizing: border-box;
    min-height: 100vh; 
    display: flex; 
    flex-direction: column; 
}

.content { 
    flex: 1; 
    width: 100%; 
    max-width: none; 
    margin: 0 auto; 
}	

/* PAGE HEADER */
.page-hdr { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-hdr-title { font-size: 24px; font-weight: bold; margin-bottom: 5px; color: #111827; }
.page-hdr-sub { font-size: 14px; color: #666; }

/* ── 🚨 검색 툴바 (높이 및 여백 완벽 균등화) ── */
.search-bar { 
    display: flex; 
    align-items: center; 
    gap: 12px; 
    margin-bottom: 20px; 
    flex-wrap: wrap; 
}
.search-select { 
    height: 40px; 
    padding: 0 30px 0 14px; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    outline: none; 
    background: #fff; 
    font-size: 13px; 
    color: #475569;
    cursor: pointer;
    flex-shrink: 0;
}
.search-input { 
    width: 320px; 
    height: 40px; 
    padding: 0 14px; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    outline: none; 
    font-size: 13px; 
    transition: all 0.2s ease;
    flex-shrink: 0;
}
.search-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

/* BUTTONS */
.btn-search { 
    height: 40px; 
    padding: 0 18px; 
    background: #111827; 
    color: #fff; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-weight: 600; 
    font-size: 13px; 
    display: inline-flex; 
    align-items: center; 
    gap: 6px; 
    flex-shrink: 0;
}
.btn-search:hover { background: #374151; }

.btn-reset { 
    height: 40px; 
    padding: 0 18px; 
    background: #fff; 
    color: #475569; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    cursor: pointer; 
    font-weight: 600; 
    font-size: 13px; 
    flex-shrink: 0;
}
.btn-reset:hover { border-color: #111827; color: #111827; }

/* TABLE LIST */
.table-container { background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
.admin-table { width: 100%; border-collapse: collapse; }
.admin-table th { background: #f8fafc; padding: 14px 16px; font-weight: 600; color: #475569; border-bottom: 1px solid #e2e8f0; font-size: 13px; text-align: center; }
.admin-table td { padding: 14px 16px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; color: #334155; font-size: 14px; text-align: center; }
.admin-table tr:last-child td { border-bottom: none; }
.admin-table tr:hover td { background: #f8fafc; }
.stock-num { font-weight: 700; font-family: 'Space Grotesk', sans-serif; color: #111827; }

/* BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
.badge-ok { background: #dcfce7; color: #059669; }    /* 정상 */
.badge-warn { background: #fff4e6; color: #d9480f; }  /* 부족 */
.badge-out { background: #fef2f2; color: #ef4444; }   /* 품절 */

/* 🌟 PAGINATION (새로 추가/수정된 스타일) 🌟 */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

/* ACTION BUTTON */
.btn-detail { background: #f0f4ff; color: #1a73e8; border: 1px solid #cce0ff; padding: 6px 12px; border-radius: 4px; font-weight: 700; font-size: 12px; cursor: pointer; transition: all 0.2s; white-space: nowrap; }
.btn-detail:hover { background: #1a73e8; color: #fff; border-color: #1a73e8; box-shadow: 0 2px 8px rgba(26,115,232,0.2); }

/* ── MODAL OVERLAY & BOX (통일감 구현) ── */
.modal-overlay { 
    position: fixed; inset: 0; background: rgba(0,0,0,0.5); 
    display: none; align-items: center; justify-content: center; 
    z-index: 3000; /* 탑바 영역보다 위에 위치 */
}
.modal-box { 
    background: #fff; width: 780px; border-radius: 12px; max-height: 90vh; 
    display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; 
}
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }

/* DETAIL LAYOUT */
.stock-detail-grid { display: grid; grid-template-columns: 260px 1fr; gap: 24px; }
.sd-info-box { background: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0; height: fit-content; }
.sd-info-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 13.5px; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px; }
.sd-info-row:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
.sd-label { color: #64748b; font-weight: 500; }
.sd-val { color: #0f172a; font-weight: 600; text-align: right; word-break: break-all; padding-left: 10px; }
.sd-sku-val { font-family: 'Consolas', monospace; color: #1a73e8; }

/* OPTION MATRIX UI */
.color-group { margin-bottom: 20px; }
.color-group:last-child { margin-bottom: 0; }
.color-title { font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 10px; border-bottom: 2px solid #0f172a; padding-bottom: 6px; }
.size-chips-grid { display: flex; flex-wrap: wrap; gap: 8px; }
.size-stock-chip { 
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    background: #fff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px 12px; min-width: 65px; height: 56px;
}
.ssc-size { font-size: 11px; color: #64748b; font-weight: 600; margin-bottom: 3px; }
.ssc-qty { font-size: 15px; font-weight: 700; color: #3b82f6; font-family: 'Space Grotesk', sans-serif; }
.ssc-out { color: #ef4444; font-size: 12px; font-weight: 600; } 
.size-stock-chip.out-of-stock { background: #fef2f2; border-color: #fecaca; }
</style>
</head>
<body>
    <%@ include file="../../common/shopAdminHeader.jsp"%>
    
<div class="main">
    <c:set var="pageTitle" value="재고 현황 조회" scope="request" />
    <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />
    
<div class="content">
    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">재고 현황 조회</div>
        <div class="page-hdr-sub">입고된 재고를 실시간으로 조회 합니다.</div>
      </div>      
    </div>

        <div class="search-bar">
            <select id="brandFilter" class="search-select" onchange="stockSearch()">
                <option value="ALL">전체 브랜드</option>
                <c:forEach var="brand" items="${brandList}">
                    <option value="${brand.brandName}">${brand.brandName}</option>
                </c:forEach>
            </select>

            <select id="searchType" class="search-select">
                <option value="name">상품명</option>
                <option value="sku">품번(SKU)</option>
            </select>
            
            <input type="text" id="searchKeyword" class="search-input" placeholder="검색어를 입력하세요..." onkeyup="if(event.keyCode==13) stockSearch();">
            
            <button type="button" class="btn-search" onclick="stockSearch()"><i class="fa-solid fa-magnifying-glass"></i> 검색</button>
            <button type="button" class="btn-reset" onclick="stockReset()"><i class="fa-solid fa-rotate-right"></i> 초기화</button>
        </div>

        <div class="table-container">
            <table class="admin-table">
                <colgroup>
                    <col style="width: 140px;">
                    <col style="width: 160px;">
                    <col style="width: auto;">
                    <col style="width: 140px;">
                    <col style="width: 120px;">
                    <col style="width: 120px;">
                    <col style="width: 120px;">
                </colgroup>
                <thead>
                    <tr>
                        <th>브랜드</th>
                        <th>품번(SKU)</th>
                        <th style="text-align: left; padding-left: 15px;">상품명</th>
                        <th>카테고리</th>
                        <th>총 재고</th>
                        <th>재고 상태</th>
                        <th>조회</th>
                    </tr>
                </thead>
                <tbody id="stockTbody">
                    <c:forEach var="item" items="${stockList}">
                        <tr class="stock-row" 
                            data-num="${item.prodNum}"
                            data-brand="${item.brandName}" 
                            data-name="${item.prodName}" 
                            data-sku="${item.sku}"
                            data-cat="${item.catName}"
                            data-qty="${item.stockQty}">
                            
                            <td style="font-weight: 600; color: #1a73e8;">${item.brandName}</td>
                            <td style="font-family: 'Consolas', monospace; font-size: 13px;">${item.sku}</td>
                            <td style="text-align: left; font-weight: 500; padding-left: 15px;">${item.prodName}</td>
                            <td>${item.catName}</td>
                            <td class="stock-num">
                                <fmt:formatNumber value="${item.stockQty}" pattern="#,###"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.stockQty <= 0}">
                                        <span class="badge badge-out">● 품절</span>
                                    </c:when>
                                    <c:when test="${item.stockQty < 10}">
                                        <span class="badge badge-warn">● 부족</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-ok">● 정상</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn-detail" onclick="openStockDetailModal(this.closest('tr'))">상세 보기 🔍</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty stockList}">
                        <tr><td colspan="7" style="padding: 100px; color: #999;"><i class="fa-solid fa-box-open" style="font-size:32px; display:block; margin-bottom:12px; color:#dee2e6;"></i>데이터가 없습니다.</td></tr>
                    </c:if>
                </tbody>
            </table>
            
            <%-- 🌟 PAGINATION HTML (새로 추가/수정됨) 🌟 --%>
            <div class="pagination-wrap" id="stockPagination" style="display:none;">
                <div class="page-info" id="stockPageInfo">총 <strong>0</strong>건</div>
                <div class="page-btns" id="stockPageBtns"></div>
            </div>

        </div>

    </div>
</div>

<div class="modal-overlay" id="stockDetailModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <div class="modal-title">📦 상품 재고 상세</div>
            <button type="button" class="modal-close" onclick="closeStockDetailModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <div class="modal-body">
            <div class="stock-detail-grid">
                <div class="sd-info-box">
                    <div class="sd-info-row"><span class="sd-label">브랜드</span><span class="sd-val" id="mdlBrand"></span></div>
                    <div class="sd-info-row"><span class="sd-label">품번(SKU)</span><span class="sd-val sd-sku-val" id="mdlSku"></span></div>
                    <div class="sd-info-row"><span class="sd-label">카테고리</span><span class="sd-val" id="mdlCat"></span></div>
                    <div class="sd-info-row"><span class="sd-label">상품명</span><span class="sd-val" id="mdlName" style="font-family:'Pretendard'; text-align: left;"></span></div>
                    <div class="sd-info-row" style="margin-top:20px; border-top: 2px solid #0f172a; padding-top:15px;">
                        <span class="sd-label" style="font-weight:700; color:#0f172a;">총 재고량</span>
                        <span class="sd-val" id="mdlTotalStock" style="font-size: 20px; color:#059669; font-family:'Space Grotesk';">0개</span>
                    </div>
                </div>

                <div id="stockMatrixArea" style="max-height: 400px; overflow-y: auto; padding-right: 10px;">
                    <div style="text-align:center; padding: 50px; color:#999;">데이터를 불러오는 중입니다... ⏳</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // ── 데이터 및 페이징 설정 (새로운 디자인 로직 적용) ──
    let currentStockPage = 1;
    const itemsPerPage = 10;
    let allRows = [];

    window.addEventListener('load', function() {
        const tbody = document.getElementById('stockTbody');
        if (tbody) {
            allRows = Array.from(tbody.querySelectorAll('tr.stock-row'));
            allRows.forEach(row => row.setAttribute('data-visible', 'true')); // 초기화
            if (allRows.length > 0) {
                renderTable();
            } else {
                document.getElementById('stockPagination').style.display = 'none';
            }
        }
    });

    function renderTable() {
        const activeRows = allRows.filter(row => row.getAttribute('data-visible') === 'true');
        allRows.forEach(row => row.style.display = 'none');
        
        const start = (currentStockPage - 1) * itemsPerPage;
        const end = start + itemsPerPage;
        
        for (let i = start; i < end && i < activeRows.length; i++) {
            activeRows[i].style.display = '';
        }
        renderPagination(activeRows.length);
    }

    function renderPagination(totalItems) {
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        const pw = document.getElementById('stockPagination');
        const pi = document.getElementById('stockPageInfo');
        const pb = document.getElementById('stockPageBtns');
        
        if (!pw || !pb) return;

        if (totalItems === 0) {
            pw.style.display = 'none';
            return;
        }
        
        pw.style.display = 'flex';
        const sn = (currentStockPage - 1) * itemsPerPage + 1;
        const en = Math.min(currentStockPage * itemsPerPage, totalItems);
        
        // JSP 처리 방지를 위해 \${} 이스케이프 사용
        pi.innerHTML = `총 <strong style="color:#0f172a">\${totalItems}</strong>건 · \${sn}-\${en}`;

        let h = `<div class="pg-btn \${currentStockPage === 1 ? 'disabled' : ''}" onclick="changePage(\${currentStockPage - 1})">‹</div>`;

        // 최대 9개의 버튼만 보여지도록 제한
        let maxVisible = 9;
        let startPage = Math.max(1, currentStockPage - Math.floor(maxVisible / 2));
        let endPage = Math.min(totalPages, startPage + maxVisible - 1);

        if (endPage - startPage + 1 < maxVisible) {
            startPage = Math.max(1, endPage - maxVisible + 1);
        }

        for (let i = startPage; i <= endPage; i++) {
            h += `<div class="pg-btn \${i === currentStockPage ? 'on' : ''}" onclick="changePage(\${i})">\${i}</div>`;
        }

        h += `<div class="pg-btn \${currentStockPage === totalPages ? 'disabled' : ''}" onclick="changePage(\${currentStockPage + 1})">›</div>`;
        pb.innerHTML = h;
    }

    function changePage(p) {
        const activeRows = allRows.filter(row => row.getAttribute('data-visible') === 'true');
        const totalPages = Math.ceil(activeRows.length / itemsPerPage);
        if (p < 1 || p > totalPages) return;
        currentStockPage = p;
        renderTable();
    }

    // ── 검색 로직 ──
    function stockSearch() {
        const brand = document.getElementById('brandFilter').value;
        const type = document.getElementById('searchType').value;
        const key = document.getElementById('searchKeyword').value.toLowerCase().trim();

        allRows.forEach(row => {
            const rowBrand = row.getAttribute('data-brand');
            const rowText = row.getAttribute('data-' + type).toLowerCase();
            
            const isBrandMatch = (brand === 'ALL' || rowBrand === brand);
            const isKeyMatch = rowText.includes(key);

            if (isBrandMatch && isKeyMatch) {
                row.setAttribute('data-visible', 'true');
            } else {
                row.setAttribute('data-visible', 'false');
            }
        });

        currentStockPage = 1;
        renderTable();
    }

    function stockReset() {
        document.getElementById('brandFilter').value = 'ALL';
        document.getElementById('searchType').value = 'name';
        document.getElementById('searchKeyword').value = '';
        allRows.forEach(row => row.setAttribute('data-visible', 'true'));
        currentStockPage = 1;
        renderTable();
    }

    // ── 🚨 상세 모달 구동 로직 ──
    function openStockDetailModal(trElement) {
        var prodNum = trElement.getAttribute('data-num');
        var brand = trElement.getAttribute('data-brand');
        var name = trElement.getAttribute('data-name');
        var sku = trElement.getAttribute('data-sku');
        var catName = trElement.getAttribute('data-cat');
        var totalStock = trElement.getAttribute('data-qty');

        // 기본 텍스트 배치
        document.getElementById('mdlBrand').innerText = brand;
        document.getElementById('mdlName').innerText = name;
        document.getElementById('mdlSku').innerText = sku;
        document.getElementById('mdlCat').innerText = catName;
        document.getElementById('mdlTotalStock').innerText = Number(totalStock).toLocaleString() + '개';

        // AJAX 렌더링 영역 초기화 안내
        const matrixArea = document.getElementById('stockMatrixArea');
        matrixArea.innerHTML = '<div style="text-align:center; padding:50px; color:#999;"><i class="fa-solid fa-spinner fa-spin" style="font-size:24px; margin-bottom:8px; display:block;"></i>데이터 로딩 중...</div>';
        document.getElementById('stockDetailModal').style.display = 'flex';

        // 서버 Fetch API 호출
        fetch('${pageContext.request.contextPath}/shop/stock/getDetail.do?prodNum=' + prodNum)
            .then(res => res.json())
            .then(data => {
                renderRealStockMatrix(data);
            })
            .catch(err => {
                console.error(err);
                matrixArea.innerHTML = '<div style="padding:50px; text-align:center; color:#ef4444;">정보를 불러오지 못했습니다.</div>';
            });
    }

    function closeStockDetailModal() {
        document.getElementById('stockDetailModal').style.display = 'none';
    }

    window.addEventListener('click', function(e) {
        if (e.target == document.getElementById('stockDetailModal')) {
            closeStockDetailModal();
        }
    });

    // ── 서버에서 받아온 상세 재고 정보를 그리는 렌더링 함수 ──
    function renderRealStockMatrix(data) {
        const stockArray = Array.isArray(data) ? data : data.list;
        const matrixArea = document.getElementById('stockMatrixArea');
        
        if (!stockArray || stockArray.length === 0) {
            matrixArea.innerHTML = '<div style="padding:50px; text-align:center; color:#999;">상세 옵션 정보가 없습니다.</div>';
            return;
        }
    
        // 컬러별 그룹화
        const grouped = stockArray.reduce((acc, obj) => {
            if (!acc[obj.color]) acc[obj.color] = [];
            acc[obj.color].push(obj);
            return acc;
        }, {});
    
        // 동적 HTML 바인딩
        let html = '';
        for (const color in grouped) {
            html += '<div class="color-group">' +
                    '<div class="color-title">🎨 ' + color + '</div>' +
                    '<div class="size-chips-grid">';
            
            grouped[color].forEach(opt => {
                const isOut = opt.qty === 0;
                const chipClass = isOut ? 'size-stock-chip out-of-stock' : 'size-stock-chip';
                const qtyHtml = isOut ? '<span class="ssc-out">품절</span>' : '<span class="ssc-qty">' + opt.qty + '</span>';
    
                html += '<div class="' + chipClass + '">' +
                        '<div class="ssc-size">' + opt.size + ' mm</div>' + 
                        qtyHtml +
                        '</div>';
            });
            
            html += '</div></div>';
        }
        matrixArea.innerHTML = html;
    }
</script>
</body>
</html>