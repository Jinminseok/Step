<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 실시간 재고 현황</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
	/*top bar*/
	.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
	.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;gap:12px;background:var(--black);position:sticky;top:0;z-index:50}
	.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;letter-spacing:.02em}
	.topbar-path{font-size:11px;color:#444}
	.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
	.t-btn{width:32px;height:32px;border:1px solid #333;background:transparent;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:14px;color:#888;border-radius:2px}
	.t-btn:hover{border-color:#555;color:#fff}
	.content{padding:24px;flex:1}	
	
	/* PAGE HEADER */
	.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
	.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
	.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}
	
/* ── 기본 레이아웃 ── */
    body { background-color: #f4f6f9; margin: 0; font-family: 'Noto Sans KR', sans-serif; }
    .admin-dashboard { max-width: 1400px; width: 95%; margin: 30px auto; background: #ffffff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #000; }
    .admin-title { font-size: 24px; font-weight: 700; color: #000; margin: 0; }
    
    .search-bar { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
    .search-select { padding: 10px; border: 1px solid #ddd; border-radius: 4px; outline: none; background: #fff; font-size: 14px; }
    .search-input { flex: 1; padding: 10px 15px; border: 1px solid #ddd; border-radius: 4px; outline: none; font-size: 14px; }
    .btn-search { background: #000; color: #fff; border: none; padding: 10px 25px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-reset { background: #fff; color: #000; border: 1px solid #ddd; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: 500; }

    .table-container { border: 1px solid #eee; border-radius: 8px; overflow: hidden; }
    .admin-table { width: 100%; border-collapse: collapse; text-align: center; }
    .admin-table th { background: #f8f9fa; padding: 15px; font-weight: 700; color: #333; border-bottom: 1px solid #eee; font-size: 14px; }
    
    .admin-table td { padding: 14px; border-bottom: 1px solid #eee; vertical-align: middle; color: #555; font-size: 14px; white-space: nowrap; }
    .stock-num { font-weight: 700; font-family: 'Consolas', monospace; color: #333; }

    .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; display: inline-block; }
    .badge-ok { background: #e6f4ea; color: #1e8e3e; }    /* 정상 */
    .badge-warn { background: #fff7e6; color: #d48806; }  /* 부족 */
    .badge-out { background: #fce8e6; color: #d93025; }   /* 품절 */

    .pagination-wrap { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; flex-wrap: nowrap; }
    .page-info { font-size: 14px; color: #666; white-space: nowrap; flex-shrink: 0; }
    .page-btns { display: flex; gap: 5px; flex-wrap: nowrap; }
    .pg-btn { padding: 8px 12px; border: 1px solid #ddd; background: #fff; cursor: pointer; border-radius: 4px; font-size: 13px; min-width: 35px; text-align: center; }
    .pg-btn.on { background: #000; color: #fff; border-color: #000; font-weight: 700; }
    .pg-btn.disabled { color: #ccc; cursor: default; }
    
    /* ── 세련되고 작아진 상세 버튼 스타일 ── */
    .btn-detail { background: #f0f4ff; color: #1a73e8; border: 1px solid #cce0ff; padding: 5px 10px; border-radius: 4px; font-weight: 700; font-size: 12px; cursor: pointer; transition: all 0.2s; white-space: nowrap; }
    .btn-detail:hover { background: #1a73e8; color: #fff; border-color: #1a73e8; box-shadow: 0 2px 8px rgba(26,115,232,0.3); }

    /* ── 모달 Fixed Positioning (화면 위에 띄우기) ── */
    .modal-overlay { 
        position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; 
        z-index: 10000;  /* 다른 요소보다 무조건 위에 뜨게! */
    }
    
    .modal-content { 
        position: fixed; max-width: 800px; width: 90%; background: #fff; padding: 25px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
        z-index: 10001; /* 오버레이보다 1 높게 */
    }
    
    .modal-header { border-bottom: 2px solid #000; padding-bottom: 15px; }
    .btn-close { position: absolute; top: 15px; right: 20px; background: none; border: none; font-size: 24px; cursor: pointer; }

    /* ── 상세 모달 전용 레이아웃 ── */
    .stock-detail-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; margin-top: 10px; }
    .sd-info-box { background: #f8f9fa; padding: 20px; border-radius: 8px; border: 1px solid #eee; }
    .sd-info-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px dashed #ddd; padding-bottom: 8px; }
    .sd-info-row:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
    .sd-label { color: #666; font-weight: 500; }
    .sd-val { color: #111; font-weight: 700; font-family: 'Consolas', monospace; }

    /* ── 컬러별 재고 카드 UI ── */
    .color-group { margin-bottom: 20px; }
    .color-title { font-size: 15px; font-weight: 700; color: #333; margin-bottom: 10px; display: flex; align-items: center; gap: 6px; border-bottom: 2px solid #000; padding-bottom: 5px; }
    .size-chips-grid { display: flex; flex-wrap: wrap; gap: 8px; }
    .size-stock-chip { 
        display: flex; flex-direction: column; align-items: center; justify-content: center;
        background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 10px 15px; min-width: 60px;
    }
    .ssc-size { font-size: 12px; color: #666; font-weight: 700; margin-bottom: 4px; }
    .ssc-qty { font-size: 16px; font-weight: 900; color: #1a73e8; font-family: 'Consolas', monospace; }
    .ssc-out { color: #d93025; font-size: 14px; } /* 품절 시 빨간색 */
    .size-stock-chip.out-of-stock { background: #fce8e6; border-color: #fce8e6; opacity: 0.8; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>
    
<div class="main">
  <div class="topbar">
    <div class="topbar-title">재고 현황 조회</div>
    <div class="topbar-path">Admin > 재고 현황 조회</div>
    <div class="topbar-right">
      <div class="t-btn">🔔</div>
    </div>
  </div>

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
            
            <button class="btn-search" onclick="stockSearch()">🔍 검색</button>
            <button class="btn-reset" onclick="stockReset()">🔄 초기화</button>
        </div>

        <div class="table-container">
            <table class="admin-table">
                <colgroup>
                    <col style="width: 120px;">
                    <col style="width: 150px;">
                    <col style="width: auto;">
                    <col style="width: 150px;">
                    <col style="width: 120px;">
                    <col style="width: 120px;">
                    <col style="width: 120px;">
                </colgroup>
                <thead>
                    <tr>
                        <th>브랜드</th>
                        <th>품번(SKU)</th>
                        <th>상품명</th>
                        <th>카테고리</th>
                        <th>총 재고</th>
                        <th>재고 상태</th>
                        <th>조회</th>
                    </tr>
                </thead>
                <tbody id="stockTbody">
                    <c:forEach var="item" items="${stockList}" varStatus="status">
                        <tr class="stock-row" 
                            data-num="${item.prodNum}"
                            data-brand="${item.brandName}" 
                            data-name="${item.prodName}" 
                            data-sku="${item.sku}"
                            data-cat="${item.catName}"
                            data-qty="${item.stockQty}">
                            
                            <td style="font-weight: 700; color: #1a73e8;">${item.brandName}</td>
                            <td style="font-family: 'Consolas', monospace; font-size: 13px;">${item.sku}</td>
                            <td style="text-align: left; font-weight: 500;">${item.prodName}</td>
                            <td>${item.catName}</td>
                            <td class="stock-num">
                                <fmt:formatNumber value="${item.stockQty}" pattern="#,###"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.stockQty <= 0}">
                                        <span class="badge badge-out">품절</span>
                                    </c:when>
                                    <c:when test="${item.stockQty < 10}">
                                        <span class="badge badge-warn">부족</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-ok">정상</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn-detail" onclick="openStockDetailModal(this.closest('tr'))">
                                    상세 보기 🔍
                                
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty stockList}">
                        <tr><td colspan="7" style="padding: 100px; color: #999;">데이터가 없습니다.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="pagination-wrap" id="stockPagination" style="display:none;">
            <div class="page-info" id="stockPageInfo">0 - 0 / 0건</div>
            <div class="page-btns" id="stockPageBtns"></div>
        </div>
    </div>
    
    <div class="modal-overlay" id="stockDetailModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="margin: 0; font-size: 22px;">📦 상품 재고 상세</h3>
                <button class="btn-close" onclick="closeStockDetailModal()">&times;</button>
            </div>
            
            <div class="modal-body" style="padding-top: 20px;">
                <div class="stock-detail-grid">
                    <div class="sd-info-box">
                        <div class="sd-info-row"><span class="sd-label">브랜드</span><span class="sd-val" id="mdlBrand"></span></div>
                        <div class="sd-info-row"><span class="sd-label">품번(SKU)</span><span class="sd-val" id="mdlSku" style="color:#1a73e8;"></span></div>
                        <div class="sd-info-row"><span class="sd-label">카테고리</span><span class="sd-val" id="mdlCat"></span></div>
                        <div class="sd-info-row"><span class="sd-label">상품명</span><span class="sd-val" id="mdlName" style="font-family:'Noto Sans KR';"></span></div>
                        <div class="sd-info-row" style="margin-top:15px; border-top: 2px solid #000; padding-top:15px;"><span class="sd-label" style="font-weight:900; color:#000;">총 재고량</span><span class="sd-val" id="mdlTotalStock" style="font-size: 20px; color:#1e8e3e;">0개</span></div>
                    </div>

                    <div id="stockMatrixArea" style="max-height: 400px; overflow-y: auto; padding-right: 10px;">
                        <div style="text-align:center; padding: 50px; color:#999;">데이터를 불러오는 중입니다... ⏳</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>


<script>
    // ── 데이터 및 페이징 설정 ──
    let currentStockPage = 1;
    const itemsPerPage = 10;
    let allRows = [];

    window.onload = function() {
        allRows = Array.from(document.querySelectorAll('.stock-row'));
        renderTable();
    };

    function renderTable() {
        const activeRows = allRows.filter(row => row.getAttribute('data-visible') !== 'false');
        
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
        
        if (totalItems === 0) {
            pw.style.display = 'none';
            return;
        }
        
        pw.style.display = 'flex';
        const sn = (currentStockPage - 1) * itemsPerPage + 1;
        const en = Math.min(currentStockPage * itemsPerPage, totalItems);
        pi.innerHTML = sn + ' - ' + en + ' / ' + totalItems + '건';

        const blockSize = 10;
        const currentBlock = Math.ceil(currentStockPage / blockSize);
        const startPage = (currentBlock - 1) * blockSize + 1;
        const endPage = Math.min(startPage + blockSize - 1, totalPages);

        let h = '';
        // [이전 10개]
        if (startPage > 1) {
            h += '<div class="pg-btn" onclick="changePage(' + (startPage - 1) + ')">‹</div>';
        } else {
            h += '<div class="pg-btn disabled">‹</div>';
        }

        for (let i = startPage; i <= endPage; i++) {
            const onCls = (i === currentStockPage) ? 'on' : '';
            h += '<div class="pg-btn ' + onCls + '" onclick="changePage(' + i + ')">' + i + '</div>';
        }

        // [다음 10개]
        if (endPage < totalPages) {
            h += '<div class="pg-btn" onclick="changePage(' + (endPage + 1) + ')">›</div>';
        } else {
            h += '<div class="pg-btn disabled">›</div>';
        }
        pb.innerHTML = h;
    }

    function changePage(p) {
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
        document.getElementById('searchKeyword').value = '';
        allRows.forEach(row => row.setAttribute('data-visible', 'true'));
        currentStockPage = 1;
        renderTable();
    }

    // ── 상세 모달 구동 로직 (데이터 연동 버그 수정) ──
    function openStockDetailModal(trElement) {
        // 1. tr 태그에 숨겨둔 데이터 안전하게 빼오기
        var brand = trElement.getAttribute('data-brand');
        var name = trElement.getAttribute('data-name');
        var sku = trElement.getAttribute('data-sku');
        var catName = trElement.getAttribute('data-cat');
        var totalStock = trElement.getAttribute('data-qty');

        // 2. 모달창 안의 텍스트 교체하기 (이전 데이터 삭제 효과)
        document.getElementById('mdlBrand').innerText = brand;
        document.getElementById('mdlName').innerText = name;
        document.getElementById('mdlSku').innerText = sku;
        document.getElementById('mdlCat').innerText = catName;
        document.getElementById('mdlTotalStock').innerText = Number(totalStock).toLocaleString() + '개';

        // 3. 모달 띄우기 (CSS Fixed Positioning 필수!)
        document.getElementById('stockDetailModal').style.display = 'flex';

        // 4. 우측 옵션별 재고 UI 그리기 (더미 데이터 - 🌟 mm mm 버그 수정)
        // 🌟 "mm mm" 문제를 해결하기 위해 안전한 문자열 결합 방식으로 더미 데이터를 생성합니다.
        renderFixedStockMatrix(); 
    }

    function closeStockDetailModal() {
        document.getElementById('stockDetailModal').style.display = 'none';
    }

    // 모달 바깥 영역 클릭 시 닫기
    window.addEventListener('click', function(e) {
        if (e.target == document.getElementById('stockDetailModal')) {
            closeStockDetailModal();
        }
    });

 // ──  재고 상세 모달 열기 ──
    function openStockDetailModal(trElement) {
        var prodNum = trElement.getAttribute('data-num');
        var brand = trElement.getAttribute('data-brand');
        var name = trElement.getAttribute('data-name');
        var sku = trElement.getAttribute('data-sku');
        var catName = trElement.getAttribute('data-cat');
        var totalStock = trElement.getAttribute('data-qty');

        // 기본 정보 세팅
        document.getElementById('mdlBrand').innerText = brand;
        document.getElementById('mdlName').innerText = name;
        document.getElementById('mdlSku').innerText = sku;
        document.getElementById('mdlCat').innerText = catName;
        document.getElementById('mdlTotalStock').innerText = Number(totalStock).toLocaleString() + '개';

        // AJAX 호출
        const matrixArea = document.getElementById('stockMatrixArea');
        matrixArea.innerHTML = '<div style="text-align:center; padding:50px;">데이터 로딩 중...</div>';

        fetch('${pageContext.request.contextPath}/shop/stock/getDetail.do?prodNum=' + prodNum)
            .then(res => res.json())
            .then(data => {
                // 가져온 데이터를 컬러별로 그룹화해서 그립니다.
                renderRealStockMatrix(data);
                document.getElementById('stockDetailModal').style.display = 'flex';
            })
            .catch(err => {
                console.error(err);
                alert("재고 상세 정보를 불러오는 데 실패했습니다.");
            });
    }

    // ── 🌟 서버에서 받은 데이터를 화면에 그리는 함수 ──
	function renderRealStockMatrix(data) {
	    // 🌟 핵심 방어 코드: 넘어온 data가 순수 배열이 아니면(즉 껍데기 객체라면), 알맹이인 data.list를 꺼냅니다!
	    const stockArray = Array.isArray(data) ? data : data.list;
	
	    const matrixArea = document.getElementById('stockMatrixArea');
	    
	    // 만약 데이터가 없거나 텅 비어있으면 안내 메시지 출력
	    if (!stockArray || stockArray.length === 0) {
	        matrixArea.innerHTML = '<div style="padding:50px; text-align:center; color:#999;">상세 옵션 정보가 없습니다.</div>';
	        return;
	    }
	
	    // 1. 데이터를 컬러별로 예쁘게 묶기 (이제 에러 안 납니다!)
	    const grouped = stockArray.reduce((acc, obj) => {
	        if (!acc[obj.color]) acc[obj.color] = [];
	        acc[obj.color].push(obj);
	        return acc;
	    }, {});
	
	    // 2. 화면 그리기 (문자열 결합)
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