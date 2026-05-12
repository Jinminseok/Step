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
				<div style="display:flex; gap:8px; margin-bottom:16px;">				    
				    <div class="hdr-search" style="flex:1; margin:0;">
				        <input type="text" id="storeSearch" placeholder="지역명 또는 매장명 입력" style="border-color:var(--border); color:var(--black); background:var(--white); width:100%;">
				        <button class="hdr-search-btn" onclick="filterList()">🔍</button>
				    </div>				    
				    <button onclick="resetList()" style="white-space:nowrap; padding:0 15px; border:1px solid var(--border); background:var(--white); border-radius:4px; cursor:pointer; font-size:13px; color:var(--black);">
				        🔄 초기화
				    </button>				    
				</div>
				
				<div class="brand-tabs" style="display:flex; gap:6px; margin-bottom:16px; overflow-x:auto; padding-bottom:5px;">
				    
				    <button class="brand-btn" onclick="selectBrand('ALL', this)" style="padding:6px 14px; border:1px solid var(--black); background:var(--black); color:var(--white); border-radius:20px; font-size:13px; cursor:pointer; white-space:nowrap;">전체</button>				   			    
				    <c:forEach var="brand" items="${brandList}">
				        <button class="brand-btn" onclick="selectBrand('${brand.brandName}', this)" style="padding:6px 14px; border:1px solid var(--border); background:var(--white); color:var(--black); border-radius:20px; font-size:13px; cursor:pointer; white-space:nowrap;">${brand.brandName}</button>
				    </c:forEach>
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

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c976ca361528bd86cd80021916dd7c88&libraries=services"></script>

    <script>
 // ── 1. 지도 초기화 ──────────────────────────────────────────
    var mapContainer = document.getElementById('map'); 
    var mapOption = { 
        center: new kakao.maps.LatLng(37.566826, 126.978656), // 기본 서울 중심
        level: 4 
    };
    var map = new kakao.maps.Map(mapContainer, mapOption); 
    var geocoder = new kakao.maps.services.Geocoder();
    var markers = []; 
    var infowindows = []; 

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
                
                markers[index] = marker; 

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

                if (index === 0) map.setCenter(coords);
            }
        });
    });

    // ── 4. 리스트 클릭 시 해당 위치로 이동 ───────────────────────────
    function panToStore(addr, index) {
        geocoder.addressSearch(addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
                map.panTo(moveLatLon); 
                
                closeAllInfoWindows();
                
                if(infowindows[index] && markers[index]) {
                    infowindows[index].open(map, markers[index]);
                }
                
                highlightCard(index);
            } 
            else {
                alert("카카오맵에서 다음 주소를 찾을 수 없습니다: \n[" + addr + "]\nDB에 저장된 주소를 확인해 주세요!");
            }
        });
    }

    function closeAllInfoWindows() {
        infowindows.forEach(function(iw) { if(iw) iw.close(); });
    }

    function highlightCard(index) {
        document.querySelectorAll('.store-card').forEach(c => c.style.borderColor = 'var(--gray6)');
        var activeCard = document.getElementById('card-' + index);
        if(activeCard) {
            activeCard.style.borderColor = 'var(--blue)';
            activeCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    // ── 5. 브랜드 탭 다중 필터링 (새로 추가된 핵심 로직!) ───────────────
    var currentBrand = 'ALL'; // 현재 선택된 브랜드 기억하기

    function selectBrand(brand, btnElement) {
        currentBrand = brand;

        // 형님이 설정하신 인라인 스타일에 맞춰서 모든 버튼을 기본(흰 바탕)으로 초기화
        document.querySelectorAll('.brand-btn').forEach(btn => {
            btn.style.background = 'var(--white)';
            btn.style.color = 'var(--black)';
            btn.style.borderColor = 'var(--border)';
        });
        
        // 클릭한 버튼만 까만색으로 강조 (형님 스타일 그대로!)
        btnElement.style.background = 'var(--black)';
        btnElement.style.color = 'var(--white)';
        btnElement.style.borderColor = 'var(--black)';

        // 탭을 바꿨으니 필터링 다시 실행
        filterList();
    }

    function filterList() {
        var searchVal = document.getElementById('storeSearch').value.toLowerCase();
        
        document.querySelectorAll('.store-card').forEach(card => {
            var name = card.querySelector('.store-nm').innerText;
            var nameLower = name.toLowerCase();
            var addrLower = card.querySelector('.store-addr').innerText.toLowerCase();
            
            // 🌟 형님 아이디어 적용: 매장 이름(store-nm)에 '나이키'가 포함되어 있는지 검사!
            var isBrandMatch = (currentBrand === 'ALL' || name.includes(currentBrand));
            
            // 검색어 검사
            var isSearchMatch = (nameLower.includes(searchVal) || addrLower.includes(searchVal));
            
            // 두 조건 모두 맞을 때만 보여주기
            if (isBrandMatch && isSearchMatch) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    }
    
    // ── 6. 검색 초기화 기능 ────────────────────────────────────────
    function resetList() {
        document.getElementById('storeSearch').value = '';
        
        // 모든 카드를 무식하게 다 띄우는 게 아니라, 
        // "현재 선택된 브랜드 탭 안에서" 텍스트 검색만 초기화합니다!
        filterList(); 
    }
    </script>
</body>
</html>