<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 매장 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
/* --- 🚨 전역 스타일 --- */
*, *::before, *::after { box-sizing: border-box; }

body {
    font-family: 'Pretendard', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    color: #333;
}

/* --- 메인 레이아웃 --- */
.wrap {
    max-width: 1280px;
    margin: 40px auto;
    padding: 0 20px;
    min-height: calc(100vh - 100px);
}

.page-title {
    font-size: 28px;
    font-weight: 800;
    color: #111827;
    margin-bottom: 24px;
    letter-spacing: -0.5px;
}

/* 2단 그리드 (리스트 / 지도) */
.map-layout {
    display: grid;
    grid-template-columns: 400px 1fr;
    gap: 24px;
    background: #fff;
    padding: 24px;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.03);
    border: 1px solid #e2e8f0;
}

/* --- 좌측: 매장 리스트 영역 --- */
.store-list {
    height: 650px;
    overflow-y: auto;
    padding-right: 12px;
    display: flex;
    flex-direction: column;
}
.store-list::-webkit-scrollbar { width: 6px; }
.store-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

/* 검색바 영역 */
.search-area {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
    flex-shrink: 0;
}
.search-input-wrap {
    position: relative;
    flex: 1;
}
.search-input-wrap input {
    width: 100%;
    height: 44px;
    padding: 0 40px 0 16px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    outline: none;
    transition: all 0.2s;
    background: #f8fafc;
}
.search-input-wrap input:focus {
    border-color: #111827;
    background: #fff;
}
.search-btn {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #64748b;
    cursor: pointer;
    font-size: 16px;
}
.btn-reset {
    height: 44px;
    padding: 0 16px;
    border: 1px solid #e2e8f0;
    background: #fff;
    color: #475569;
    border-radius: 8px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    transition: all 0.2s;
}
.btn-reset:hover {
    background: #f1f5f9;
    color: #111827;
}

/* 브랜드 탭 */
.brand-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 20px;
    overflow-x: auto;
    padding-bottom: 8px;
    flex-shrink: 0;
}
.brand-tabs::-webkit-scrollbar { height: 4px; }
.brand-tabs::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 2px; }

.brand-btn {
    padding: 8px 16px;
    border: 1px solid #e2e8f0;
    background: #fff;
    color: #475569;
    border-radius: 24px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    white-space: nowrap;
    transition: all 0.2s ease;
}
.brand-btn:hover { border-color: #94a3b8; }
.brand-btn.active {
    background: #111827;
    color: #fff;
    border-color: #111827;
}

/* 매장 카드 */
.store-card {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    margin-bottom: 12px;
    cursor: pointer;
    background: #fff;
    transition: all 0.2s ease;
}
.store-card:hover {
    border-color: #94a3b8;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.store-card.active {
    border-color: #3b82f6;
    background: #eff6ff; /* 파란색 아주 연한 배경 */
}
.store-nm {
    font-weight: 700;
    font-size: 16px;
    color: #0f172a;
    margin-bottom: 8px;
}
.store-addr {
    font-size: 13.5px;
    color: #64748b;
    margin-bottom: 12px;
    line-height: 1.4;
}
.store-info {
    font-size: 12.5px;
    color: #475569;
    display: flex;
    flex-direction: column;
    gap: 4px;
}
.store-info i { width: 16px; color: #94a3b8; }

/* --- 우측: 지도 영역 --- */
#map {
    width: 100%;
    height: 650px;
    border-radius: 12px;
    background: #f1f5f9;
    border: 1px solid #e2e8f0;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">오프라인 매장 찾기</div>
        
        <div class="map-layout">
            <%-- 왼쪽: 매장 리스트 --%>
            <div class="store-list">
                <div class="search-area">				    
				    <div class="search-input-wrap">
				        <input type="text" id="storeSearch" placeholder="지역명 또는 매장명 입력" onkeyup="if(event.keyCode==13) filterList();">
				        <button class="search-btn" onclick="filterList()"><i class="fa-solid fa-magnifying-glass"></i></button>
				    </div>				    
				    <button class="btn-reset" onclick="resetList()"><i class="fa-solid fa-rotate-right"></i> 초기화</button>				    
				</div>
				
                <div class="brand-tabs">
				    <button class="brand-btn active" onclick="selectBrand('ALL', this)">전체보기</button>				   			    
				    <c:forEach var="brand" items="${brandList}">
				        <button class="brand-btn" onclick="selectBrand('${brand.brandName}', this)">${brand.brandName}</button>
				    </c:forEach>
				</div>
                
                <div id="storeCardContainer">
                    <c:forEach var="s" items="${storeList}" varStatus="status">
                        <div class="store-card" id="card-${status.index}" onclick="panToStore('${s.storeAddr}', ${status.index})">
                            <div class="store-nm">${s.storeName}</div>
                            <div class="store-addr">${s.storeAddr}</div>
                            <div class="store-info">
                                <span><i class="fa-solid fa-phone"></i> ${s.storePhone}</span>
                                <span><i class="fa-regular fa-clock"></i> ${s.openTime}</span>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty storeList}">
                        <div style="text-align:center; padding:80px 0; color:#94a3b8;">
                            <i class="fa-solid fa-store-slash" style="font-size:36px; color:#cbd5e1; margin-bottom:12px; display:block;"></i>
                            등록된 매장이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>

            <%-- 오른쪽: 지도 영역 --%>
            <div id="map"></div>
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

                // 인포윈도우 디자인 개선
                var content = '<div style="padding:15px; width:220px; font-family:\'Pretendard\', sans-serif; border-radius:8px; border:none;">' +
                              '  <div style="font-weight:700; font-size:14px; margin-bottom:6px; color:#111827;">' + store.name + '</div>' +
                              '  <div style="font-size:12px; color:#64748b; line-height:1.4;">' + store.addr + '</div>' +
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

                // 첫 번째 매장을 중심 좌표로 설정
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
                alert("카카오맵에서 해당 주소 좌표를 찾을 수 없습니다.\n(" + addr + ")");
            }
        });
    }

    function closeAllInfoWindows() {
        infowindows.forEach(function(iw) { if(iw) iw.close(); });
    }

    // 카드 선택(하이라이트) 처리: 인라인 스타일 대신 클래스 사용
    function highlightCard(index) {
        document.querySelectorAll('.store-card').forEach(c => c.classList.remove('active'));
        var activeCard = document.getElementById('card-' + index);
        if(activeCard) {
            activeCard.classList.add('active');
            activeCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    // ── 5. 브랜드 탭 다중 필터링 ───────────────────────────────
    var currentBrand = 'ALL'; 

    function selectBrand(brand, btnElement) {
        currentBrand = brand;

        // 모든 브랜드 버튼에서 active 클래스 제거 후 클릭한 버튼만 추가
        document.querySelectorAll('.brand-btn').forEach(btn => btn.classList.remove('active'));
        btnElement.classList.add('active');

        filterList();
    }

    function filterList() {
        var searchVal = document.getElementById('storeSearch').value.toLowerCase();
        
        document.querySelectorAll('.store-card').forEach(card => {
            var name = card.querySelector('.store-nm').innerText;
            var nameLower = name.toLowerCase();
            var addrLower = card.querySelector('.store-addr').innerText.toLowerCase();
            
            // 매장명에 브랜드 이름 포함 여부 검사
            var isBrandMatch = (currentBrand === 'ALL' || name.includes(currentBrand));
            
            // 검색어 검사
            var isSearchMatch = (nameLower.includes(searchVal) || addrLower.includes(searchVal));
            
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
        filterList(); 
    }
    </script>
</body>
</html>