<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 매장 관리</title>
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

/* ── 기본 레이아웃 ── */
    body { background-color: #f4f6f9; margin: 0; font-family: 'Noto Sans KR', sans-serif; }
    .admin-dashboard { max-width: 1600px; width: 95%; margin: 30px auto; background: #ffffff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    
    /* ── 헤더 영역 ── */
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #000; }
    .admin-title { font-size: 24px; font-weight: 700; color: #000; margin: 0; }
    .btn-register { background: #000; color: #fff; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 14px; transition: 0.2s; }
    .btn-register:hover { background: #333; }

    /* ── 브랜드 필터 탭 ── */
    .brand-filter-area { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 20px; }
    .btn-brand-tab { 
        padding: 8px 18px; border: 1px solid #ddd; background: #fff; 
        border-radius: 25px; cursor: pointer; font-size: 13px; font-weight: 500; color: #666; transition: 0.2s;
    }
    .btn-brand-tab:hover { background: #f8f9fa; border-color: #000; color: #000; }
    .btn-brand-tab.active { background: #000; color: #fff; border-color: #000; font-weight: 700; }

    /* ── 상세 검색 바 ── */
    .search-bar { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; margin-bottom: 20px; display: flex; gap: 10px; align-items: center; }
    .search-select { padding: 9px; border: 1px solid #ddd; border-radius: 4px; outline: none; background: #fff; }
    .search-input { flex: 1; padding: 9px 15px; border: 1px solid #ddd; border-radius: 4px; outline: none; }
    .btn-search { background: #000; color: #fff; border: none; padding: 9px 25px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-reset { background: #fff; color: #000; border: 1px solid #ddd; padding: 9px 20px; border-radius: 4px; cursor: pointer; font-weight: 500; }

    /* ── 메인 콘텐츠 그리드 ── */
    .admin-content { display: grid; grid-template-columns: 1.6fr 1fr; gap: 25px; }

    /* ── 테이블 디자인 ── */
    .table-container { height: 700px; overflow-y: auto; border: 1px solid #eee; border-radius: 8px; }
    .admin-table { width: 100%; border-collapse: collapse; text-align: center; }
    .admin-table th { background: #f8f9fa; padding: 15px; font-weight: 700; color: #333; position: sticky; top: 0; z-index: 10; border-bottom: 1px solid #eee; }
        
    .admin-table td { 
        padding: 14px; border-bottom: 1px solid #eee; vertical-align: middle; 
        color: #555; white-space: nowrap; /* 줄바꿈 절대 방지 */
    }
    /* 주소는 너무 길면 칸을 뚫고 나가니 주소만 자동 줄바꿈 허용 */
    .admin-table td.addr-cell { white-space: normal; text-align: left; font-size: 13px; line-height: 1.4; }

    .admin-table tbody tr { cursor: pointer; transition: 0.1s; }
    .admin-table tbody tr:hover { background: #f0f4ff; }
    .admin-table tbody tr.active-row { background: #e6f0ff; border-left: 4px solid #1a73e8; }

    /* ── 뱃지 및 버튼 ── */
    .badge-y { background: #e6f4ea; color: #1e8e3e; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; display: inline-block; }
    .badge-n { background: #fce8e6; color: #d93025; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; display: inline-block; }
    .btn-sm { padding: 6px 12px; border: 1px solid #ddd; border-radius: 4px; background: #fff; cursor: pointer; font-size: 12px; color: #333; font-weight: 500; }
    .btn-sm:hover { background: #f1f1f1; border-color: #999; }

    /* ── 지도 영역 ── */
    #adminMap { height: 700px; border-radius: 8px; border: 1px solid #eee; background: #fafafa; position: sticky; top: 0; }

    /* ── 모달 공통 스타일 ── */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; justify-content: center; align-items: center; }
    .modal-content { background: #fff; width: 600px; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); animation: popIn 0.2s ease-out; }
    @keyframes popIn { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    
    .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #000; padding-bottom: 10px; }
    .modal-header h3 { margin: 0; font-size: 20px; font-weight: 700; }
    .btn-close { background: none; border: none; font-size: 28px; cursor: pointer; color: #999; line-height: 1; }
    
    .form-group { margin-bottom: 15px; text-align: left; }
    .form-label { display: block; font-weight: 700; margin-bottom: 6px; color: #333; font-size: 13px; }
    .form-input, .form-select { width: 100%; padding: 11px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-family: inherit; font-size: 14px; }
    .addr-group { display: flex; gap: 8px; }
    .btn-addr { background: #fff; border: 1px solid #000; padding: 0 15px; border-radius: 6px; cursor: pointer; font-weight: bold; white-space: nowrap; font-size: 13px; }
    
    .modal-btns { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; align-items: center; }
    .btn-delete { background: #fff; color: #d32f2f; border: 1px solid #d32f2f; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; margin-right: auto; font-size: 14px; }
    .btn-delete:hover { background: #fff1f1; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>

	
<div class="main">
  <div class="topbar">
    <div class="topbar-title">매장 정보 관리</div>
    <div class="topbar-path">Admin > 매장 정보 관리</div>
    <div class="topbar-right">
      <div class="t-btn">🔔</div>
    </div>
  </div>

<div class="admin-dashboard">
        <div class="admin-header">
            <h2 class="admin-title">🏢 오프라인 매장 관리 대시보드</h2>
            <button class="btn-register" onclick="openInsertModal()">＋ 새 매장 등록</button>
        </div>

        <div class="brand-filter-area">
            <button class="btn-brand-tab active" onclick="filterByBrand('ALL', this)">전체보기</button>
            <c:forEach var="brand" items="${brandList}">
                <button class="btn-brand-tab" onclick="filterByBrand('${brand.brandName}', this)">${brand.brandName}</button>
            </c:forEach>
        </div>

        <div class="search-bar">
            <select id="searchType" class="search-select">
                <option value="brand">브랜드</option>
                <option value="name">매장명</option>
                <option value="addr">주소</option>
                <option value="status">상태 (Y/N)</option>
            </select>
            <input type="text" id="searchKeyword" class="search-input" placeholder="검색어를 입력하세요..." onkeyup="if(event.keyCode==13) adminSearch();">
            <button class="btn-search" onclick="adminSearch()">🔍 검색</button>
            <button class="btn-reset" onclick="adminReset()">🔄 초기화</button>
        </div>

        <div class="admin-content">
            <div class="table-container">
                <table class="admin-table">
                    <colgroup>
                        <col style="width: 120px;">
                        <col style="width: 180px;">
                        <col style="width: auto;">
                        <col style="width: 140px;">
                        <col style="width: 140px;">
                        <col style="width: 100px;">
                        <col style="width: 80px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>브랜드</th>
                            <th>매장명</th>
                            <th>주소</th>
                            <th>영업시간</th>
                            <th>전화번호</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="storeTbody">
                        <c:forEach var="store" items="${adminStoreList}" varStatus="status">
                            <tr class="store-row" 
                                data-num="${store.storeNum}" 
                                data-brandnum="${store.brandNum}" 
                                data-brand="${store.brandName}" 
                                data-name="${store.storeName}" 
                                data-addr="${store.storeAddr}" 
                                data-phone="${store.storePhone}" 
                                data-time="${store.openTime}" 
                                data-status="${store.storeUseYn}" 
                                id="row-${status.index}" 
                                onclick="focusStore('${store.storeAddr}', ${status.index})">
                                
                                <td style="font-weight: 700; color: #1a73e8;">${store.brandName}</td>
                                <td style="font-weight: 700; color: #333;">${store.storeName}</td>
                                <td class="addr-cell">${store.storeAddr}</td>
                                <td>${store.openTime}</td>
                                <td style="font-weight: 500;">${store.storePhone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${store.storeUseYn == 'Y'}"><span class="badge-y">운영중</span></c:when>
                                        <c:otherwise><span class="badge-n">미운영</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button type="button" class="btn-sm" onclick="event.stopPropagation(); openModifyModal(this.closest('tr'))">수정</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty adminStoreList}">
                            <tr><td colspan="7" style="padding: 100px; color: #999;">등록된 매장 데이터가 없습니다.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <div id="adminMap"></div>
        </div>
    </div>

    <div class="modal-overlay" id="insertModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🏢 새 매장 등록</h3>
                <button class="btn-close" onclick="closeInsertModal()">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/shop/admin/adminStoreInsert.do" method="post" id="insertForm">
                <div class="form-group">
                    <label class="form-label">소속 브랜드 <span style="color:red;">*</span></label>
                    <select name="brandNum" class="form-select" required>
                        <option value="">-- 브랜드를 선택하세요 --</option>
                        <c:forEach var="brand" items="${brandList}">
                            <option value="${brand.brandNum}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">매장명 <span style="color:red;">*</span></label>
                    <input type="text" name="storeName" class="form-input" placeholder="예: 나이키 홍대점" required>
                </div>
                <div class="form-group">
                    <label class="form-label">매장 주소 <span style="color:red;">*</span></label>
                    <div class="addr-group">
                        <input type="text" id="insertAddr" name="storeAddr" class="form-input" placeholder="검색을 이용하세요" readonly required>
                        <button type="button" class="btn-addr" onclick="searchAddress('insertAddr')">🔍 주소 검색</button>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group"><label class="form-label">전화번호</label><input type="text" name="storePhone" class="form-input" placeholder="02-123-4567"></div>
                    <div class="form-group"><label class="form-label">운영 시간</label><input type="text" name="openTime" class="form-input" placeholder="10:00 ~ 21:00"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">운영 상태 <span style="color:red;">*</span></label>
                    <select name="storeUseYn" class="form-select">
                        <option value="Y" selected>운영중 (Y)</option>
                        <option value="N">미운영 (N)</option>
                    </select>
                </div>
                <div class="modal-btns">
                    <button type="button" class="btn-reset" onclick="closeInsertModal()">취소</button>
                    <button type="submit" class="btn-search">✅ 등록 완료</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-overlay" id="modifyModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🛠️ 매장 정보 수정 / 삭제</h3>
                <button class="btn-close" onclick="closeModifyModal()">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/shop/admin/adminStoreUpdate.do" method="post" id="modifyForm">
                <input type="hidden" id="modStoreNum" name="storeNum">
                <div class="form-group">
                    <label class="form-label">소속 브랜드 <span style="color:red;">*</span></label>
                    <select id="modBrandNum" name="brandNum" class="form-select" required>
                        <c:forEach var="brand" items="${brandList}">
                            <option value="${brand.brandNum}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group"><label class="form-label">매장명 <span style="color:red;">*</span></label><input type="text" id="modStoreName" name="storeName" class="form-input" required></div>
                <div class="form-group">
                    <label class="form-label">매장 주소 <span style="color:red;">*</span></label>
                    <div class="addr-group">
                        <input type="text" id="modStoreAddr" name="storeAddr" class="form-input" readonly required>
                        <button type="button" class="btn-addr" onclick="searchAddress('modStoreAddr')">🔍 주소 검색</button>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group"><label class="form-label">전화번호</label><input type="text" id="modStorePhone" name="storePhone" class="form-input"></div>
                    <div class="form-group"><label class="form-label">운영 시간</label><input type="text" id="modOpenTime" name="openTime" class="form-input"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">운영 상태 <span style="color:red;">*</span></label>
                    <select id="modStoreUseYn" name="storeUseYn" class="form-select">
                        <option value="Y">운영중 (Y)</option>
                        <option value="N">미운영 (N)</option>
                    </select>
                </div>
                <div class="modal-btns">
                    <button type="button" class="btn-delete" onclick="adminDeleteStore()">🗑️ 매장 삭제</button>
                    <button type="button" class="btn-reset" onclick="closeModifyModal()">취소</button>
                    <button type="submit" class="btn-search">💾 수정 저장</button>
                </div>
            </form>
        </div>
    </div>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c976ca361528bd86cd80021916dd7c88&libraries=services"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
    /* 1. 모달 제어 로직 */
    function openInsertModal() { document.getElementById('insertModal').style.display = 'flex'; }
    function closeInsertModal() { document.getElementById('insertModal').style.display = 'none'; document.getElementById('insertForm').reset(); }
    
    function openModifyModal(trElement) {
        document.getElementById('modStoreNum').value = trElement.getAttribute('data-num');
        document.getElementById('modBrandNum').value = trElement.getAttribute('data-brandnum');
        document.getElementById('modStoreName').value = trElement.getAttribute('data-name');
        document.getElementById('modStoreAddr').value = trElement.getAttribute('data-addr');
        document.getElementById('modStorePhone').value = trElement.getAttribute('data-phone');
        document.getElementById('modOpenTime').value = trElement.getAttribute('data-time');
        document.getElementById('modStoreUseYn').value = trElement.getAttribute('data-status');
        document.getElementById('modifyModal').style.display = 'flex';
    }
    function closeModifyModal() { document.getElementById('modifyModal').style.display = 'none'; }

    // 배경 클릭 시 닫기
    window.onclick = function(event) {
        if (event.target == document.getElementById('insertModal')) closeInsertModal();
        if (event.target == document.getElementById('modifyModal')) closeModifyModal();
    }

    /* 2. 주소 검색 (다음 API) */
    function searchAddress(inputId) {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                document.getElementById(inputId).value = addr;
            }
        }).open();
    }

    /* 3. 삭제 처리 */
    function adminDeleteStore() {
        var storeNum = document.getElementById('modStoreNum').value;
        if(confirm("정말로 이 매장 정보를 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.")) {
            location.href = "${pageContext.request.contextPath}/shop/admin/adminStoreDelete.do?storeNum=" + storeNum;
        }
    }

    /* 4. 필터 및 검색 로직 */
    function filterByBrand(brandName, btn) {
        document.querySelectorAll('.btn-brand-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('searchKeyword').value = ''; // 검색어 초기화

        var rows = document.querySelectorAll('.store-row');
        rows.forEach(row => {
            var rowBrand = row.getAttribute('data-brand');
            row.style.display = (brandName === 'ALL' || rowBrand === brandName) ? '' : 'none';
        });
    }

    function adminSearch() {
        // 검색 시 브랜드 탭은 '전체'로 초기화
        document.querySelectorAll('.btn-brand-tab').forEach(b => b.classList.remove('active'));
        document.querySelector('.btn-brand-tab:first-child').classList.add('active');

        var type = document.getElementById('searchType').value; 
        var key = document.getElementById('searchKeyword').value.toLowerCase().trim(); 
        document.querySelectorAll('.store-row').forEach(row => {
            var val = row.getAttribute('data-' + type).toLowerCase();
            row.style.display = val.includes(key) ? '' : 'none';
        });
    }

    function adminReset() {
        document.getElementById('searchKeyword').value = '';
        filterByBrand('ALL', document.querySelector('.btn-brand-tab:first-child'));
    }

    /* 5. 카카오 지도 로직 */
    var mapContainer = document.getElementById('adminMap'); 
    var mapOption = { center: new kakao.maps.LatLng(37.566826, 126.978656), level: 4 };
    var map = new kakao.maps.Map(mapContainer, mapOption); 
    var geocoder = new kakao.maps.services.Geocoder();
    var markers = []; 
    var infowindows = []; 

    // 데이터 루프 (마커 생성)
    var stores = [
        <c:forEach var="s" items="${adminStoreList}">
        { name: '${s.storeName}', addr: '${s.storeAddr}', status: '${s.storeUseYn}' },
        </c:forEach>
    ];

    stores.forEach(function(s, i) {
        geocoder.addressSearch(s.addr, function(res, stat) {
            if (stat === kakao.maps.services.Status.OK) {
                var pos = new kakao.maps.LatLng(res[0].y, res[0].x);
                var mark = new kakao.maps.Marker({ map: map, position: pos, opacity: (s.status==='N'?0.5:1.0) });
                markers[i] = mark; 
                var iw = new kakao.maps.InfoWindow({ 
                    content: '<div style="padding:10px; font-size:12px; text-align:center;"><b>'+s.name+'</b><br>'+(s.status==='Y'?'운영중':'미운영')+'</div>' 
                });
                infowindows[i] = iw;
                if(i === 0) map.setCenter(pos);
            }
        });
    });

    function focusStore(addr, idx) {
        document.querySelectorAll('.store-row').forEach(r => r.classList.remove('active-row'));
        document.getElementById('row-' + idx).classList.add('active-row');
        geocoder.addressSearch(addr, function(res, stat) {
            if (stat === kakao.maps.services.Status.OK) {
                var p = new kakao.maps.LatLng(res[0].y, res[0].x);
                map.panTo(p); 
                infowindows.forEach(w => { if(w) w.close(); });
                if(infowindows[idx]) infowindows[idx].open(map, markers[idx]);
            }
        });
    }
    </script>
</body>
</html>