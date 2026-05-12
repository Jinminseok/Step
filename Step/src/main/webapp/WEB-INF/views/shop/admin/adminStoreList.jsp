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

body { background-color: #f4f6f9; margin: 0; font-family: 'Noto Sans KR', sans-serif; }
    
    .admin-dashboard { 
        max-width: 1500px; width: 95%; margin: 40px auto; 
        background: #ffffff; padding: 30px; border-radius: 12px; 
        box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
    }
    
    .admin-header { 
        display: flex; justify-content: space-between; align-items: center; 
        margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid var(--black); 
    }
    .admin-title { font-size: 24px; font-weight: 700; color: var(--black); margin: 0; }
    .btn-register { 
        background: var(--black); color: var(--white); padding: 10px 20px; 
        border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 14px; transition: 0.2s;
    }
    .btn-register:hover { background: #333; }

    /* 🌟 다중 조건 검색 바 */
    .search-bar {
        background: #f8f9fa; padding: 15px; border-radius: 8px; 
        border: 1px solid var(--border); margin-bottom: 20px;
        display: flex; gap: 10px; align-items: center;
    }
    .search-select { padding: 9px; border: 1px solid var(--border); border-radius: 4px; outline: none; font-family: 'Noto Sans KR', sans-serif; }
    .search-input { flex: 1; padding: 9px 15px; border: 1px solid var(--border); border-radius: 4px; outline: none; font-family: 'Noto Sans KR', sans-serif; }
    .btn-search { background: var(--black); color: var(--white); border: none; padding: 9px 25px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-reset { background: var(--white); color: var(--black); border: 1px solid var(--border); padding: 9px 20px; border-radius: 4px; cursor: pointer; font-weight: 500; }

    /* 레이아웃 (테이블 : 지도) */
    .admin-content { display: grid; grid-template-columns: 1.5fr 1fr; gap: 25px; }

    /* 테이블 영역 */
    .table-container { height: 650px; overflow-y: auto; border: 1px solid var(--border); border-radius: 8px; }
    .admin-table { width: 100%; border-collapse: collapse; text-align: center; }
    .admin-table th { 
        background: #f8f9fa; padding: 15px; font-weight: 700; color: #333; 
        position: sticky; top: 0; z-index: 1; border-bottom: 1px solid var(--border); 
    }
    .admin-table td { padding: 14px; border-bottom: 1px solid #eee; vertical-align: middle; color: #555; }
    
    .admin-table tbody tr { cursor: pointer; transition: 0.2s; }
    .admin-table tbody tr:hover { background: #f0f4ff; }
    .admin-table tbody tr.active-row { background: #e6f0ff; border-left: 4px solid var(--blue); }

    /* 상태 뱃지 및 수정 버튼 */
    .badge-y { background: #e6f4ea; color: #1e8e3e; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
    .badge-n { background: #fce8e6; color: #d93025; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
    .btn-sm { padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; background: var(--white); cursor: pointer; font-size: 12px; color: #333; font-weight: 500;}
    .btn-sm:hover { background: #f1f1f1; }

    /* 오른쪽 지도 */
    #adminMap { height: 650px; border-radius: 8px; border: 1px solid var(--border); background: #eaeaea; }
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
            <h2 class="admin-title">🏢 오프라인 매장 관리</h2>
            <a href="${pageContext.request.contextPath}/admin/storeWriteForm.do" class="btn-register">＋ 새 매장 등록</a>
        </div>

        <%-- 🌟 검색 영역 --%>
        <div class="search-bar">
            <select id="searchType" class="search-select">
                <option value="brand">브랜드</option>
                <option value="name">매장명</option>
                <option value="addr">주소</option>
                <option value="status">상태 (Y/N)</option>
            </select>
            <input type="text" id="searchKeyword" class="search-input" placeholder="검색어를 입력하세요" onkeyup="if(event.keyCode==13) adminSearch();">
            <button class="btn-search" onclick="adminSearch()">🔍 검색</button>
            <button class="btn-reset" onclick="adminReset()">🔄 초기화</button>
        </div>

        <div class="admin-content">
            <%-- 왼쪽: 매장 목록 테이블 --%>
            <div class="table-container">
                <table class="admin-table">
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 18%;">
                        <col style="width: auto;">
                        <col style="width: 13%;">
                        <col style="width: 15%;">
                        <col style="width: 10%;">
                        <col style="width: 10%;">
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
                            <%-- data-* 속성에 검색용 데이터 세팅 (Y/N 상태값 포함) --%>
                            <tr class="store-row" 
                                data-brand="${store.brandName}" 
                                data-name="${store.storeName}" 
                                data-addr="${store.storeAddr}" 
                                data-status="${store.storeUseYn}" 
                                id="row-${status.index}" 
                                onclick="focusStore('${store.storeAddr}', ${status.index})">
                                
                                <td style="font-weight: 700; color: var(--blue);">${store.brandName}</td>
                                <td style="font-weight: 700; color: var(--black);">${store.storeName}</td>
                                <td style="text-align: left; font-size: 13px;">${store.storeAddr}</td>
                                <td style="font-size: 13px;">${store.openTime}</td>
                                <td>${store.storePhone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${store.storeUseYn == 'Y'}"><span class="badge-y">운영중</span></c:when>
                                        <c:otherwise><span class="badge-n">미운영</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button type="button" class="btn-sm" onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/admin/storeModifyForm.do?storeNum=${store.storeNum}'">수정</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty adminStoreList}">
                            <tr>
                                <td colspan="7" style="padding: 100px; color: var(--gray4); font-size: 15px;">등록된 매장이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <%-- 오른쪽: 매장 위치 확인용 카카오맵 --%>
            <div id="adminMap"></div>
        </div>
    </div>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c976ca361528bd86cd80021916dd7c88&libraries=services"></script>

    <script>
    var mapContainer = document.getElementById('adminMap'); 
    var mapOption = { center: new kakao.maps.LatLng(37.566826, 126.978656), level: 4 };
    var map = new kakao.maps.Map(mapContainer, mapOption); 
    var geocoder = new kakao.maps.services.Geocoder();
    var markers = []; 
    var infowindows = []; 

    var adminStores = [
        <c:forEach var="s" items="${adminStoreList}">
        { name: '${s.storeName}', addr: '${s.storeAddr}', status: '${s.storeUseYn}' },
        </c:forEach>
    ];

    // 지도에 마커 꽂기
    adminStores.forEach(function(store, index) {
        geocoder.addressSearch(store.addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                
                // 💡 형님 팁: N(미운영) 매장은 지도 마커를 반투명(0.5)하게 처리해서 직관적으로 구분합니다!
                var markerOpacity = (store.status === 'N') ? 0.5 : 1.0;
                var marker = new kakao.maps.Marker({ map: map, position: coords, opacity: markerOpacity });
                markers[index] = marker; 

                var content = '<div style="padding:10px; font-family:sans-serif; text-align:center;">' +
                              '  <div style="font-weight:bold; font-size:13px;">' + store.name + '</div>' +
                              '  <div style="font-size:10px; color:#888;">' + (store.status==='Y' ? '운영중' : '미운영') + '</div>' +
                              '</div>';

                var infowindow = new kakao.maps.InfoWindow({ content: content });
                infowindows[index] = infowindow;

                if (index === 0) map.setCenter(coords);
            }
        });
    });

    // 테이블 행 클릭 시 지도 이동
    function focusStore(addr, index) {
        document.querySelectorAll('.admin-table tbody tr').forEach(row => row.classList.remove('active-row'));
        document.getElementById('row-' + index).classList.add('active-row');

        geocoder.addressSearch(addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
                map.panTo(moveLatLon); 
                
                infowindows.forEach(iw => { if(iw) iw.close(); });
                if(infowindows[index] && markers[index]) {
                    infowindows[index].open(map, markers[index]);
                }
            }
        });
    }

    // ── 🌟 다중 조건 검색 (상태 N 포함 완벽 호환) ──
    function adminSearch() {
        var searchType = document.getElementById('searchType').value; 
        var keyword = document.getElementById('searchKeyword').value.toLowerCase().trim(); 
        
        var rows = document.querySelectorAll('.store-row');
        
        rows.forEach(row => {
            var targetText = row.getAttribute('data-' + searchType).toLowerCase();
            
            if (targetText.includes(keyword)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // ── 🌟 검색 초기화 ──
    function adminReset() {
        document.getElementById('searchKeyword').value = '';
        document.querySelectorAll('.store-row').forEach(row => {
            row.style.display = ''; 
        });
    }
    </script>
</body>
</html>