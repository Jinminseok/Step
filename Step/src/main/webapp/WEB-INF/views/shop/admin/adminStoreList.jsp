<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 매장 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body { 
    background-color: #f8f9fa; 
    margin: 0; 
    font-family: 'Pretendard', sans-serif; 
    color: #333;
    overflow-y: scroll; 
}

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

/* ── 필터 툴바 (검색창 겹침 및 높이 40px 통일) ── */
.toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
.search-wrap { position: relative; width: 280px; flex-shrink: 0; }
.search-wrap input {
    width: 100%; height: 40px; padding: 0 12px 0 38px;
    border: 1px solid #e2e8f0; border-radius: 6px; background: #fff;
    font-size: 13px; outline: none; color: #333; transition: all 0.2s ease;
}
.search-wrap input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.search-wrap input::placeholder { color: #9ca3af; }
.search-ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 14px; }

.sel {
    height: 40px; padding: 0 30px 0 14px; border: 1px solid #e2e8f0; border-radius: 6px;
    background: #fff; font-size: 13px; outline: none; color: #475569; cursor: pointer; flex-shrink: 0;
}

/* BUTTONS */
.btn {
    height: 40px; padding: 0 18px; border: none; border-radius: 6px; cursor: pointer;
    font-size: 13px; font-weight: 600; font-family: inherit; transition: all .2s;
    display: inline-flex; align-items: center; justify-content: center; gap: 6px; flex-shrink: 0;
}
.btn-black { background: #111827; color: #fff; }
.btn-black:hover { background: #374151; box-shadow: 0 2px 4px rgba(17,24,39,0.1); }
.btn-outline { background: #fff; color: #475569; border: 1px solid #e2e8f0; }
.btn-outline:hover { border-color: #111827; color: #111827; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.btn-danger:hover { background: #ef4444; color: #fff; }
.btn-xs { height: 28px; padding: 0 10px; font-size: 11.5px; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11.5px; font-weight: 600; }
.b-normal { background: #dcfce7; color: #059669; }   /* 운영중 */
.b-silver { background: #fef2f2; color: #ef4444; }   /* 미운영 */

/* ── 메인 콘텐츠 그리드 (좌: 목록, 우: 지도) ── */
.admin-content { display: grid; grid-template-columns: 1.6fr 1fr; gap: 24px; align-items: start; }

/* ── 테이블 영역 ── */
.table-container { 
    height: 700px; 
    overflow-y: auto; 
    background: #fff; 
    border: 1px solid #e2e8f0; 
    border-radius: 12px; 
    box-shadow: 0 2px 6px rgba(0,0,0,0.02); 
}
.table-container::-webkit-scrollbar { width: 6px; }
.table-container::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

table { width: 100%; border-collapse: collapse; }
th { 
    padding: 14px 16px; font-size: 13px; font-weight: 600; color: #475569; 
    border-bottom: 1px solid #e2e8f0; background: #f8fafc; text-align: center; 
    position: sticky; top: 0; z-index: 10; 
}
td { 
    padding: 14px 16px; border-bottom: 1px solid #f1f5f9; font-size: 13.5px; 
    color: #334155; vertical-align: middle; text-align: center; white-space: nowrap; 
}
td.addr-cell { text-align: left; white-space: normal; line-height: 1.4; }

.store-row { cursor: pointer; transition: all 0.15s; }
.store-row:hover { background: #f8fafc; }
.store-row.active-row { background: #eff6ff; border-left: 4px solid #3b82f6; }

/* ── 지도 영역 ── */
#adminMap { 
    height: 700px; 
    border-radius: 12px; 
    border: 1px solid #e2e8f0; 
    background: #f1f5f9; 
    position: sticky; 
    top: 90px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.02); 
}

/* ── MODAL OVERLAY & BOX  ── */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 3000; align-items: center; justify-content: center; }
.modal-overlay.open { display: flex; }
.modal-box { background: #fff; width: 640px; border-radius: 12px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; gap: 8px; justify-content: flex-end; background: #f8fafc; }

/* FORM */
.form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 20px; }
.f-label { font-size: 13px; font-weight: 600; color: #334155; }
.f-input { height: 42px; padding: 0 14px; border: 1px solid #e2e8f0; border-radius: 6px; background: #fff; font-size: 14px; outline: none; color: #0f172a; transition: border 0.2s; width: 100%; font-family: 'Pretendard', sans-serif;}
.f-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.f-input[readonly] { background: #f8fafc; color: #64748b; cursor: default; }

.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

/* 주소 검색 그룹 */
.addr-group { display: flex; gap: 8px; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>

<div class="main">
  <c:set var="pageTitle" value="매장 정보 관리" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">오프라인 매장 관리</div>
        <div class="page-hdr-sub">쇼핑몰에 등록된 오프라인 매장을 등록, 수정, 삭제합니다.</div>
      </div>
      <button class="btn btn-black" onclick="openInsertModal()"><i class="fa-solid fa-plus"></i> 새 매장 등록</button>
    </div>

    <div class="toolbar">        
        <select id="brandFilter" class="sel" onchange="adminSearch()">
            <option value="ALL">브랜드 전체</option>
            <c:forEach var="brand" items="${brandList}">
                <option value="${brand.brandName}">${brand.brandName}</option>
            </c:forEach>
        </select>
        
        <select id="searchType" class="sel">
            <option value="name">매장명</option>
            <option value="addr">주소</option>
            <option value="status">상태 (Y/N)</option>
        </select>           

        <div class="search-wrap">
            <span class="search-ico"><i class="fa-solid fa-magnifying-glass"></i></span>
            <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요..." onkeyup="if(event.keyCode==13) adminSearch();">
        </div>
        
        <button class="btn btn-outline" onclick="adminSearch()">조회</button>
        <button class="btn btn-outline" onclick="adminReset()"><i class="fa-solid fa-rotate-right"></i> 초기화</button>
    </div>
        
    <div class="admin-content">
        <div class="table-container">
            <table>
                <colgroup>
                    <col style="width: 120px;">
                    <col style="width: 160px;">
                    <col style="width: auto;">
                    <col style="width: 130px;">
                    <col style="width: 130px;">
                    <col style="width: 90px;">
                    <col style="width: 90px;">
                </colgroup>
                <thead>
                    <tr>
                        <th>브랜드</th>
                        <th>매장명</th>
                        <th style="text-align: left;">주소</th>
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
                            
                            <td style="font-weight: 600; color: #3b82f6;">${store.brandName}</td>
                            <td style="font-weight: 600; color: #0f172a;">${store.storeName}</td>
                            <td class="addr-cell">${store.storeAddr}</td>
                            <td>${store.openTime}</td>
                            <td style="font-family: 'Space Grotesk';">${store.storePhone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${store.storeUseYn == 'Y'}"><span class="badge b-normal">운영중</span></c:when>
                                    <c:otherwise><span class="badge b-silver">미운영</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn btn-outline btn-xs" onclick="event.stopPropagation(); openModifyModal(this.closest('tr'))">✏️ 수정</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty adminStoreList}">
                        <tr><td colspan="7" style="padding: 100px 0; color: #94a3b8; text-align:center;"><i class="fa-solid fa-store-slash" style="font-size:36px; display:block; margin-bottom:12px; color:#cbd5e1;"></i>등록된 매장 데이터가 없습니다.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div id="adminMap"></div>
    </div>
  </div>
</div>

<div class="modal-overlay" id="insertModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <div class="modal-title">🏢 새 매장 등록</div>
            <button type="button" class="modal-close" onclick="closeInsertModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/shop/admin/adminStoreInsert.do" method="post" id="insertForm" style="display:flex; flex-direction:column; height:100%;">
            <div class="modal-body">
                <div class="form-group">
                    <label class="f-label">소속 브랜드 <span style="color:#ef4444;">*</span></label>
                    <select name="brandNum" class="f-input" style="cursor:pointer;" required>
                        <option value="">-- 브랜드를 선택하세요 --</option>
                        <c:forEach var="brand" items="${brandList}">
                            <option value="${brand.brandNum}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="f-label">매장명 <span style="color:#ef4444;">*</span></label>
                    <input type="text" name="storeName" class="f-input" placeholder="예: 나이키 홍대점" required>
                </div>
                <div class="form-group">
                    <label class="f-label">매장 주소 <span style="color:#ef4444;">*</span></label>
                    <div class="addr-group">
                        <input type="text" id="insertAddr" name="storeAddr" class="f-input" placeholder="검색을 이용하세요" readonly required>
                        <button type="button" class="btn btn-outline" onclick="searchAddress('insertAddr')"><i class="fa-solid fa-magnifying-glass"></i> 주소 검색</button>
                    </div>
                </div>
                <div class="f-row">
                    <div class="form-group"><label class="f-label">전화번호</label><input type="text" name="storePhone" class="f-input" placeholder="예: 02-123-4567"></div>
                    <div class="form-group"><label class="f-label">운영 시간</label><input type="text" name="openTime" class="f-input" placeholder="예: 10:00 ~ 21:00"></div>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="f-label">운영 상태 <span style="color:#ef4444;">*</span></label>
                    <select name="storeUseYn" class="f-input" style="cursor:pointer;">
                        <option value="Y" selected>운영중 (Y)</option>
                        <option value="N">미운영 (N)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeInsertModal()">취소</button>
                <button type="submit" class="btn btn-black">✅ 등록 완료</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-overlay" id="modifyModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <div class="modal-title">🛠️ 매장 정보 수정</div>
            <button type="button" class="modal-close" onclick="closeModifyModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/shop/admin/adminStoreUpdate.do" method="post" id="modifyForm" style="display:flex; flex-direction:column; height:100%;">
            <input type="hidden" id="modStoreNum" name="storeNum">
            <div class="modal-body">
                <div class="form-group">
                    <label class="f-label">소속 브랜드 <span style="color:#ef4444;">*</span></label>
                    <select id="modBrandNum" name="brandNum" class="f-input" style="cursor:pointer;" required>
                        <c:forEach var="brand" items="${brandList}">
                            <option value="${brand.brandNum}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group"><label class="f-label">매장명 <span style="color:#ef4444;">*</span></label><input type="text" id="modStoreName" name="storeName" class="f-input" required></div>
                <div class="form-group">
                    <label class="f-label">매장 주소 <span style="color:#ef4444;">*</span></label>
                    <div class="addr-group">
                        <input type="text" id="modStoreAddr" name="storeAddr" class="f-input" readonly required>
                        <button type="button" class="btn btn-outline" onclick="searchAddress('modStoreAddr')"><i class="fa-solid fa-magnifying-glass"></i> 주소 검색</button>
                    </div>
                </div>
                <div class="f-row">
                    <div class="form-group"><label class="f-label">전화번호</label><input type="text" id="modStorePhone" name="storePhone" class="f-input"></div>
                    <div class="form-group"><label class="f-label">운영 시간</label><input type="text" id="modOpenTime" name="openTime" class="f-input"></div>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="f-label">운영 상태 <span style="color:#ef4444;">*</span></label>
                    <select id="modStoreUseYn" name="storeUseYn" class="f-input" style="cursor:pointer;">
                        <option value="Y">운영중 (Y)</option>
                        <option value="N">미운영 (N)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer" style="justify-content: space-between;">
                <button type="button" class="btn btn-danger" onclick="adminDeleteStore()">🗑️ 매장 삭제</button>
                <div style="display:flex; gap:8px;">
                    <button type="button" class="btn btn-outline" onclick="closeModifyModal()">취소</button>
                    <button type="submit" class="btn btn-black">💾 수정 저장</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c976ca361528bd86cd80021916dd7c88&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
/* 모달 제어 로직  */
function openInsertModal() { document.getElementById('insertModal').classList.add('open'); }
function closeInsertModal() { document.getElementById('insertModal').classList.remove('open'); document.getElementById('insertForm').reset(); }

function openModifyModal(trElement) {
    document.getElementById('modStoreNum').value = trElement.getAttribute('data-num');
    document.getElementById('modBrandNum').value = trElement.getAttribute('data-brandnum');
    document.getElementById('modStoreName').value = trElement.getAttribute('data-name');
    document.getElementById('modStoreAddr').value = trElement.getAttribute('data-addr');
    document.getElementById('modStorePhone').value = trElement.getAttribute('data-phone');
    document.getElementById('modOpenTime').value = trElement.getAttribute('data-time');
    document.getElementById('modStoreUseYn').value = trElement.getAttribute('data-status');
    document.getElementById('modifyModal').classList.add('open');
}
function closeModifyModal() { document.getElementById('modifyModal').classList.remove('open'); }

// 배경 클릭 시 닫기
window.onclick = function(event) {
    if (event.target == document.getElementById('insertModal')) closeInsertModal();
    if (event.target == document.getElementById('modifyModal')) closeModifyModal();
}

/* 주소 검색 (다음 API) */
function searchAddress(inputId) {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
            document.getElementById(inputId).value = addr;
        }
    }).open();
}

/* 삭제 처리 */
function adminDeleteStore() {
    var storeNum = document.getElementById('modStoreNum').value;
    if(confirm("정말로 이 매장 정보를 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.")) {
        location.href = "${pageContext.request.contextPath}/shop/admin/adminStoreDelete.do?storeNum=" + storeNum;
    }
}

/* 카카오 지도 로직 */
var mapContainer = document.getElementById('adminMap'); 
var mapOption = { center: new kakao.maps.LatLng(37.566826, 126.978656), level: 4 };
var map = new kakao.maps.Map(mapContainer, mapOption); 
var geocoder = new kakao.maps.services.Geocoder();
var markers = []; 
var infowindows = []; 

// 마커 생성
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
                content: '<div style="padding:12px; font-size:13px; font-family:\'Pretendard\', sans-serif; text-align:center; color:#111827;"><b>'+s.name+'</b><br><span style="color:'+(s.status==='Y'?'#059669':'#ef4444')+'; font-size:11px; margin-top:4px; display:block;">'+(s.status==='Y'?'● 운영중':'● 미운영')+'</span></div>' 
            });
            infowindows[i] = iw;
            if(i === 0) map.setCenter(pos);
        }
    });
});

function adminSearch() {
    var selectedBrand = document.getElementById('brandFilter').value; 
    var searchType = document.getElementById('searchType').value; 
    var keyword = document.getElementById('searchKeyword').value.toLowerCase().trim(); 

    var rows = document.querySelectorAll('.store-row');
    
    rows.forEach(row => {
        var rowBrand = row.getAttribute('data-brand'); 
        var rowTargetText = row.getAttribute('data-' + searchType).toLowerCase(); 
        
        var isBrandMatch = (selectedBrand === 'ALL' || rowBrand === selectedBrand);
        var isKeywordMatch = rowTargetText.includes(keyword);

        if (isBrandMatch && isKeywordMatch) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function adminReset() {
    document.getElementById('brandFilter').value = 'ALL'; 
    document.getElementById('searchType').value = 'name'; 
    document.getElementById('searchKeyword').value = '';  
    adminSearch(); 
}

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