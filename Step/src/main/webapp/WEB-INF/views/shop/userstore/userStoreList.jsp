<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 매장 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
*,*::before,*::after{box-sizing:border-box}

body{
  background:#f2f3f5;
  font-family:'Noto Sans KR',sans-serif;
  color:#111; margin:0;
}

.store-page{
  max-width:1280px;
  margin:0 auto;
  padding:32px 24px 60px;
}

/* ── 페이지 타이틀 ── */
.store-page-title{
  font-size:22px;font-weight:900;
  letter-spacing:-0.5px;color:#0d0d0d;
  margin-bottom:24px;
}

/* ── 2단 레이아웃 ── */
.map-layout{
  display:grid;
  grid-template-columns:380px 1fr;
  gap:20px;
  align-items:start;
}

/* ── 왼쪽 패널 ── */
.store-panel{
  background:#fff;
  border:1px solid #e4e6ea;
  border-radius:14px;
  overflow:hidden;
  display:flex;flex-direction:column;
  height:660px;
}

/* 패널 헤더 */
.store-panel-hdr{
  padding:16px 18px 0;
  border-bottom:1px solid #f0f0f0;
  background:#fff;
  flex-shrink:0;
}

/* 검색 */
.search-area{
  display:flex;gap:8px;
  margin-bottom:14px;
}
.search-input-wrap{
  position:relative;flex:1;
}
.search-input-wrap input{
  width:100%;height:42px;
  padding:0 40px 0 14px;
  border:1.5px solid #e4e6ea;
  border-radius:8px;font-size:13px;
  outline:none;background:#f8f9fb;
  color:#111;font-family:inherit;
  transition:border-color .18s,background .18s;
}
.search-input-wrap input:focus{
  border-color:#0d0d0d;background:#fff;
}
.search-input-wrap input::placeholder{color:#bbb}
.search-icon-btn{
  position:absolute;right:12px;top:50%;transform:translateY(-50%);
  background:none;border:none;cursor:pointer;
  font-size:15px;color:#aaa;line-height:1;padding:0;
}
.search-icon-btn:hover{color:#0d0d0d}
.btn-reset{
  height:42px;padding:0 14px;
  border:1.5px solid #e4e6ea;background:#fff;
  color:#666;border-radius:8px;cursor:pointer;
  font-size:12px;font-weight:600;
  white-space:nowrap;font-family:inherit;
  transition:all .15s;
}
.btn-reset:hover{border-color:#0d0d0d;color:#0d0d0d;background:#f8f9fb}

/* 브랜드 탭 */
.brand-tabs{
  display:flex;gap:6px;
  overflow-x:auto;padding-bottom:14px;
  flex-shrink:0;
}
.brand-tabs::-webkit-scrollbar{height:3px}
.brand-tabs::-webkit-scrollbar-thumb{background:#e0e0e0;border-radius:2px}
.brand-btn{
  height:32px;padding:0 14px;
  border:1.5px solid #e4e6ea;background:#fff;
  color:#666;border-radius:20px;
  font-size:12px;font-weight:600;
  cursor:pointer;white-space:nowrap;
  font-family:inherit;transition:all .15s;
}
.brand-btn:hover{border-color:#999;color:#111}
.brand-btn.active{
  background:#0d0d0d;color:#fff;
  border-color:#0d0d0d;
}

/* 카드 목록 */
.store-card-list{
  flex:1;overflow-y:auto;
  padding:14px 14px 14px 16px;
}
.store-card-list::-webkit-scrollbar{width:4px}
.store-card-list::-webkit-scrollbar-thumb{background:#ddd;border-radius:2px}

/* 매장 카드 */
.store-card{
  padding:16px;
  border:1.5px solid #ebebeb;
  border-radius:10px;
  margin-bottom:10px;
  cursor:pointer;
  background:#fff;
  transition:border-color .18s,box-shadow .18s,transform .15s;
}
.store-card:last-child{margin-bottom:0}
.store-card:hover{
  border-color:#bbb;
  box-shadow:0 3px 12px rgba(0,0,0,.07);
  transform:translateY(-1px);
}
.store-card.active{
  border-color:#1a6ef5;
  background:#f0f6ff;
  box-shadow:0 3px 16px rgba(26,110,245,.12);
}

.store-nm{
  font-size:14px;font-weight:700;
  color:#0d0d0d;margin-bottom:6px;
}
.store-card.active .store-nm{color:#1a6ef5}

.store-addr{
  font-size:12.5px;color:#777;
  margin-bottom:10px;line-height:1.45;
}
.store-info-row{
  display:flex;flex-direction:column;gap:3px;
}
.store-info-item{
  display:flex;align-items:center;gap:6px;
  font-size:12px;color:#999;
}
.store-info-icon{font-size:12px;width:14px;text-align:center;color:#bbb;flex-shrink:0}

/* 빈 상태 */
.store-empty{
  padding:60px 0;text-align:center;color:#ccc;font-size:14px;
}
.store-empty-icon{font-size:40px;margin-bottom:12px}

/* ── 오른쪽: 지도 ── */
#map{
  width:100%;height:660px;
  border-radius:14px;
  border:1px solid #e4e6ea;
  background:#f2f3f5;
  box-shadow:0 2px 12px rgba(0,0,0,.05);
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="store-page">
  <div class="store-page-title">🗺️ 오프라인 매장 찾기</div>

  <div class="map-layout">

    <%-- ── 왼쪽: 매장 리스트 ── --%>
    <div class="store-panel">

      <div class="store-panel-hdr">
        <%-- 검색 --%>
        <div class="search-area">
          <div class="search-input-wrap">
            <input type="text" id="storeSearch"
                   placeholder="지역명 또는 매장명 입력"
                   onkeyup="if(event.keyCode==13) filterList();">
            <button class="search-icon-btn" onclick="filterList()">🔍</button>
          </div>
          <button class="btn-reset" onclick="resetList()">초기화</button>
        </div>

        <%-- 브랜드 탭 --%>
        <div class="brand-tabs">
          <button class="brand-btn active" onclick="selectBrand('ALL', this)">전체</button>
          <c:forEach var="brand" items="${brandList}">
            <button class="brand-btn" onclick="selectBrand('${brand.brandName}', this)">${brand.brandName}</button>
          </c:forEach>
        </div>
      </div>

      <%-- 카드 목록 --%>
      <div class="store-card-list" id="storeCardContainer">
        <c:forEach var="s" items="${storeList}" varStatus="status">
          <div class="store-card" id="card-${status.index}"
               onclick="panToStore('${s.storeAddr}', ${status.index})">
            <div class="store-nm">${s.storeName}</div>
            <div class="store-addr">${s.storeAddr}</div>
            <div class="store-info-row">
              <div class="store-info-item">
                <span class="store-info-icon">📞</span>
                <span>${s.storePhone}</span>
              </div>
              <div class="store-info-item">
                <span class="store-info-icon">🕐</span>
                <span>${s.openTime}</span>
              </div>
            </div>
          </div>
        </c:forEach>

        <c:if test="${empty storeList}">
          <div class="store-empty">
            <div class="store-empty-icon">🏪</div>
            등록된 매장이 없습니다.
          </div>
        </c:if>
      </div>

    </div>

    <%-- ── 오른쪽: 지도 ── --%>
    <div id="map"></div>

  </div>
</div>

<%-- 카카오맵 SDK --%>
<script type="text/javascript"
  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c976ca361528bd86cd80021916dd7c88&libraries=services"></script>

<script>
/* ── 지도 초기화 ── */
var mapContainer = document.getElementById('map');
var map = new kakao.maps.Map(mapContainer, {
    center: new kakao.maps.LatLng(37.566826, 126.978656),
    level: 4
});
var geocoder    = new kakao.maps.services.Geocoder();
var markers     = [];
var infowindows = [];

/* ── 서버 데이터 ── */
var stores = [
    <c:forEach var="s" items="${storeList}">
    { name:'${s.storeName}', addr:'${s.storeAddr}', phone:'${s.storePhone}', time:'${s.openTime}' },
    </c:forEach>
];

/* ── 마커 & 인포윈도우 생성 ── */
stores.forEach(function(store, index) {
    geocoder.addressSearch(store.addr, function(result, status) {
        if (status !== kakao.maps.services.Status.OK) return;
        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        var marker = new kakao.maps.Marker({ map: map, position: coords });
        markers[index] = marker;

        var content =
            '<div style="padding:14px 16px;min-width:200px;font-family:\'Noto Sans KR\',sans-serif;">' +
            '<div style="font-weight:700;font-size:13px;color:#0d0d0d;margin-bottom:5px;">' + store.name + '</div>' +
            '<div style="font-size:12px;color:#777;line-height:1.5;">' + store.addr + '</div>' +
            '</div>';

        var iw = new kakao.maps.InfoWindow({ content: content });
        infowindows[index] = iw;

        kakao.maps.event.addListener(marker, 'click', function() {
            closeAllInfoWindows();
            iw.open(map, marker);
            highlightCard(index);
        });

        if (index === 0) map.setCenter(coords);
    });
});

/* ── 카드 클릭 시 지도 이동 ── */
function panToStore(addr, index) {
    geocoder.addressSearch(addr, function(result, status) {
        if (status !== kakao.maps.services.Status.OK) {
            alert("주소 좌표를 찾을 수 없습니다.\n(" + addr + ")");
            return;
        }
        map.panTo(new kakao.maps.LatLng(result[0].y, result[0].x));
        closeAllInfoWindows();
        if (infowindows[index] && markers[index]) infowindows[index].open(map, markers[index]);
        highlightCard(index);
    });
}

function closeAllInfoWindows() {
    infowindows.forEach(function(iw) { if (iw) iw.close(); });
}

function highlightCard(index) {
    document.querySelectorAll('.store-card').forEach(function(c) { c.classList.remove('active'); });
    var card = document.getElementById('card-' + index);
    if (card) { card.classList.add('active'); card.scrollIntoView({ behavior:'smooth', block:'nearest' }); }
}

/* ── 브랜드 탭 ── */
var currentBrand = 'ALL';

function selectBrand(brand, btn) {
    currentBrand = brand;
    document.querySelectorAll('.brand-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');
    filterList();
}

/* ── 검색 필터 ── */
function filterList() {
    var kw = document.getElementById('storeSearch').value.toLowerCase();
    document.querySelectorAll('.store-card').forEach(function(card) {
        var name = card.querySelector('.store-nm').innerText;
        var addr = card.querySelector('.store-addr').innerText.toLowerCase();
        var brandOk  = (currentBrand === 'ALL' || name.includes(currentBrand));
        var searchOk = (name.toLowerCase().includes(kw) || addr.includes(kw));
        card.style.display = (brandOk && searchOk) ? '' : 'none';
    });
}

function resetList() {
    document.getElementById('storeSearch').value = '';
    filterList();
}
</script>
</body>
</html>
