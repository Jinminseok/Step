<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 매장 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">매장 찾기</div>
        
        <div class="map-layout" style="display: grid; grid-template-columns: 400px 1fr; gap: 20px;">
            <%-- 왼쪽: 매장 리스트 --%>
            <div class="store-list" style="height: 600px; overflow-y:auto; padding-right:10px;">
                <div class="hdr-search" style="max-width:100%; margin:0 0 16px 0;">
                    <input type="text" id="storeSearch" placeholder="지역명 또는 매장명 입력" style="border:1px solid var(--border); width:80%; padding:10px; border-radius:4px;">
                    <button class="hdr-search-btn" onclick="filterList()" style="padding:10px;">🔍</button>
                </div>
                
                <div id="storeCardContainer">
                    <c:forEach var="s" items="${storeList}" varStatus="status">
                        <%-- 매장 카드를 누르면 지도가 해당 위치로 이동하도록 onclick 추가 --%>
                        <div class="store-card" id="card-${status.index}" onclick="panToStore('${s.storeAddr}', ${status.index})" style="cursor:pointer; padding:15px; border:1px solid var(--gray6); border-radius:8px; margin-bottom:12px;">
                            <div class="store-nm" style="font-weight:700; font-size:16px; margin-bottom:8px;">${s.storeName}</div>
                            <div class="store-addr" style="font-size:13px; color:var(--gray3); margin-bottom:6px;">${s.storeAddr}</div>
                            <div class="store-info" style="font-size:12px; color:var(--gray4);">
                                <span>📞 ${s.storePhone}</span><br>
                                <span>⏰ ${s.openTime}</span>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty storeList}">
                        <div style="text-align:center; padding:50px; color:var(--gray4);">등록된 매장이 없습니다.</div>
                    </c:if>
                </div>
            </div>

            <%-- 오른쪽: 지도 영역 --%>
            <div id="map" style="height:600px; border-radius:12px; background:var(--bg2);"></div>
        </div>
    </div>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=여기에_발급받은_자바스크립트_키를_넣으십쇼&libraries=services"></script>

    <script>
    // ── 1. 지도 초기화 ──────────────────────────────────────────
    var mapContainer = document.getElementById('map'); 
    var mapOption = { 
        center: new kakao.maps.LatLng(37.566826, 126.978656), // 기본 서울 중심
        level: 4 
    };
    var map = new kakao.maps.Map(mapContainer, mapOption); 
    var geocoder = new kakao.maps.services.Geocoder();
    var markers = []; // 마커 관리를 위한 배열
    var infowindows = []; // 정보창 관리를 위한 배열

    // ── 2. 서버에서 넘어온 데이터를 JS 배열로 변환 ─────────────────────
    var stores = [
        <c:forEach var="s" items="${storeList}">
        {
            name: '${s.storeName}',
            addr: '${s.storeAddr}',
            phone: '${s.storePhone}',
            time: '${s.openTime}'
        },
        </c:forEach>
    ];

    // ── 3. 주소로 좌표 검색 및 마커 표시 ─────────────────────────────
    stores.forEach(function(store, index) {
        geocoder.addressSearch(store.addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });
                
                markers[index] = marker; // 인덱스에 맞춰 마커 저장

                var content = '<div style="padding:15px; width:200px; font-family:sans-serif;">' +
                              '  <div style="font-weight:bold; margin-bottom:5px;">' + store.name + '</div>' +
                              '  <div style="font-size:11px; color:#666;">' + store.addr + '</div>' +
                              '</div>';

                var infowindow = new kakao.maps.InfoWindow({
                    content: content
                });
                
                infowindows[index] = infowindow;

                kakao.maps.event.addListener(marker, 'click', function() {
                    closeAllInfoWindows();
                    infowindow.open(map, marker);
                    highlightCard(index);
                });

                // 첫 번째 매장으로 지도 중심 이동
                if (index === 0) map.setCenter(coords);
            }
        });
    });

    // ── 4. 리스트 클릭 시 해당 위치로 이동 ───────────────────────────
    function panToStore(addr, index) {
        geocoder.addressSearch(addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
                map.panTo(moveLatLon); // 부드럽게 이동
                
                closeAllInfoWindows();
                infowindows[index].open(map, markers[index]);
                highlightCard(index);
            }
        });
    }

    // 모든 정보창 닫기
    function closeAllInfoWindows() {
        infowindows.forEach(function(iw) { if(iw) iw.close(); });
    }

    // 클릭한 카드 강조 효과
    function highlightCard(index) {
        document.querySelectorAll('.store-card').forEach(c => c.style.borderColor = 'var(--gray6)');
        var activeCard = document.getElementById('card-' + index);
        if(activeCard) {
            activeCard.style.borderColor = 'var(--blue)';
            activeCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    // 간단한 리스트 필터링 (검색)
    function filterList() {
        var val = document.getElementById('storeSearch').value.toLowerCase();
        document.querySelectorAll('.store-card').forEach(card => {
            var name = card.querySelector('.store-nm').innerText.toLowerCase();
            var addr = card.querySelector('.store-addr').innerText.toLowerCase();
            card.style.display = (name.includes(val) || addr.includes(val)) ? '' : 'none';
        });
    }
    </script>
</body>
</html>