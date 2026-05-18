<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 브랜드 관리</title>
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

.main {
    margin-left: 260px;
    padding: 30px;
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
.page-hdr {display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;}
.page-hdr-title {font-size:24px;font-weight:bold;margin-bottom:5px;color:#111827;}
.page-hdr-sub {font-size:14px;color:#666;}

/* STATS */
.stats-row {display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:30px;}
.stat-card {background:#fff;padding:20px 24px;border:1px solid #e9ecef;border-radius:12px;box-shadow:0 2px 4px rgba(0,0,0,0.02);}
.stat-label {font-size:12px;font-weight:600;color:#868e96;margin-bottom:8px;}
.stat-val {font-family:'Space Grotesk',sans-serif;font-size:28px;font-weight:700;color:#212529;}
.stat-change {font-size:12px;margin-top:8px;color:#adb5bd;}

/* --- 🚨 툴바(검색창 겹침 해결) --- */
.toolbar {
    display:flex;
    align-items:center;
    gap:12px; /* 요소 간 간격 확실히 확보 */
    margin-bottom:16px;
    flex-wrap:wrap;
}
.search-wrap {
    position:relative;
    width:320px; /* 크기 고정으로 겹침 방지 */
    flex-shrink:0;
}
.search-wrap input {
    width:100%;
    height:40px; /* 높이 통일 */
    padding:0 12px 0 38px;
    border:1px solid #e2e8f0;
    border-radius:6px;
    background:#fff;
    font-size:13px;
    font-family:inherit;
    outline:none;
    color:#333;
    transition:all 0.2s ease;
}
.search-wrap input:focus {border-color:#3b82f6; box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
.search-wrap input::placeholder {color:#9ca3af;}
.search-ico {position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#9ca3af;font-size:14px;}

.sel {
    height:40px; /* 높이 통일 */
    padding:0 30px 0 14px;
    border:1px solid #e2e8f0;
    border-radius:6px;
    background:#fff;
    font-size:13px;
    font-family:inherit;
    outline:none;
    color:#475569;
    cursor:pointer;
    flex-shrink:0;
}

/* BUTTONS */
.btn {
    height:40px; /* 높이 통일 */
    padding:0 18px;
    border:none;
    border-radius:6px;
    cursor:pointer;
    font-size:13px;
    font-weight:600;
    font-family:inherit;
    transition:all .2s;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:6px;
    flex-shrink:0;
}
.btn-black {background:#111827;color:#fff;}
.btn-black:hover {background:#374151;}
.btn-outline {background:#fff;color:#475569;border:1px solid #e2e8f0;}
.btn-outline:hover {border-color:#111827;color:#111827;}
.btn-danger {background:#fef2f2;color:#ef4444;border:1px solid #fecaca;}
.btn-danger:hover {background:#ef4444;color:#fff;}

.btn-xs {height:28px; padding:0 10px; font-size:11px;} /* 테이블 내부 작은 버튼 */

/* BADGE */
.badge {display:inline-flex;align-items:center;padding:4px 10px;border-radius:12px;font-size:11px;font-weight:600;}
.b-green {background:#dcfce7;color:#059669;}
.b-gray {background:#f1f5f9;color:#64748b;}

/* TABLE */
.tbl-wrap {background:#fff;border:1px solid #e2e8f0;border-radius:8px;overflow:hidden;box-shadow:0 1px 2px rgba(0,0,0,0.05);}
table {width:100%;border-collapse:collapse;}
th {padding:14px 16px;font-size:13px;font-weight:600;color:#475569;border-bottom:1px solid #e2e8f0;background:#f8fafc;text-align:left;}
td {padding:14px 16px;border-bottom:1px solid #f1f5f9;font-size:14px;color:#334155;vertical-align:middle;}
tr:last-child td {border-bottom:none;}
tr:hover td {background:#f8fafc;}

/* MODAL */
.modal-overlay {display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:3000;align-items:center;justify-content:center;}
.modal-overlay.open {display:flex;}
.modal-box {background:#fff;width:480px;border-radius:12px;max-height:90vh;display:flex;flex-direction:column;box-shadow:0 10px 25px rgba(0,0,0,0.2);overflow:hidden;}
.modal-hdr {display:flex;align-items:center;justify-content:space-between;padding:20px 24px;border-bottom:1px solid #e2e8f0;background:#fff;}
.modal-title {font-size:18px;font-weight:700;color:#0f172a;}
.modal-close {background:none;border:none;color:#94a3b8;cursor:pointer;font-size:22px;padding:0;transition:color 0.2s;}
.modal-close:hover {color:#ef4444;}
.modal-body {padding:24px;overflow-y:auto;flex:1;}
.modal-footer {padding:16px 24px;border-top:1px solid #e2e8f0;display:flex;gap:8px;justify-content:flex-end;background:#f8fafc;}

/* FORM */
.form-group {display:flex;flex-direction:column;gap:8px;margin-bottom:20px;}
.f-label {font-size:13px;font-weight:600;color:#334155;}
.f-input {height:42px; padding:0 14px; border:1px solid #e2e8f0; border-radius:6px; background:#fff; font-size:14px; outline:none; color:#0f172a; transition:border 0.2s;}
.f-input:focus {border-color:#3b82f6; box-shadow:0 0 0 3px rgba(59,130,246,0.1);}
.f-hint {font-size:12px;color:#64748b;}

.toast {position:fixed;bottom:30px;left:50%;transform:translateX(-50%) translateY(20px);background:#1e293b;color:#fff;padding:12px 24px;border-radius:8px;font-size:14px;font-weight:500;opacity:0;transition:all .3s;z-index:9999;pointer-events:none;box-shadow:0 4px 12px rgba(0,0,0,0.15);}
.toast.show {opacity:1;transform:translateX(-50%) translateY(0);}
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
    <c:set var="pageTitle" value="브랜드 관리" scope="request" />
    <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <c:if test="${not empty msg}">
      <c:choose>
        <c:when test="${msg eq 'insert_ok'}">
          <script>window.onload = function(){ showToast('브랜드가 등록되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'update_ok'}">
          <script>window.onload = function(){ showToast('브랜드가 수정되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'delete_ok'}">
          <script>window.onload = function(){ showToast('브랜드가 삭제되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'toggle_ok'}">
          <script>window.onload = function(){ showToast('상태가 변경되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'duplicate'}">
          <script>window.onload = function(){ showToast('이미 존재하는 브랜드명입니다.'); }</script>
        </c:when>
      </c:choose>
    </c:if>

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">브랜드 관리</div>
        <div class="page-hdr-sub">브랜드 등록·수정·활성화 여부를 관리합니다. 상품 등록 시 브랜드 목록에 반영됩니다.</div>
      </div>
      <button class="btn btn-black" onclick="openAddModal()"><i class="fa-solid fa-plus"></i> 브랜드 등록</button>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">전체 브랜드</div>
        <div class="stat-val">${totalCount}</div>
        <div class="stat-change">등록된 브랜드</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">활성 브랜드</div>
        <div class="stat-val" style="color:#059669">${activeCount}</div>
        <div class="stat-change">사용 중</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">비활성 브랜드</div>
        <div class="stat-val" style="color:#94a3b8">${inactiveCount}</div>
        <div class="stat-change">숨김 처리됨</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">상품 등록 가능</div>
        <div class="stat-val" style="color:#3b82f6">${activeCount}</div>
        <div class="stat-change">상품마스터 연동</div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/shop/brand/brandForm.do" method="get" class="toolbar">
      <div class="search-wrap">
        <span class="search-ico"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" name="keyword" value="${keyword}" placeholder="브랜드명 검색">
      </div>
      <select class="sel" name="useYn" onchange="this.form.submit()">
        <option value="">상태 전체</option>
        <option value="Y" ${useYnSel eq 'Y' ? 'selected':''}>활성</option>
        <option value="N" ${useYnSel eq 'N' ? 'selected':''}>비활성</option>
      </select>
      <button type="submit" class="btn btn-outline"><i class="fa-solid fa-rotate-right"></i> 조회</button>
    </form>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:80px; text-align:center;">번호</th>
            <th>브랜드명</th>
            <th style="width:100px; text-align:center;">상태</th>
            <th style="width:140px; text-align:center;">상품마스터 반영</th>
            <th style="width:240px; text-align:center;">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="b" items="${brandList}">
            <tr>
              <td style="color:#64748b;font-size:13px;text-align:center;">${b.brandNum}</td>
              <td style="font-weight:600;font-size:15px;color:#0f172a;">${b.brandName}</td>
              <td style="text-align:center;">
                <c:choose>
                  <c:when test="${b.brandUseYn eq 'Y'}">
                    <span class="badge b-green">● 활성</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge b-gray">● 비활성</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td style="font-size:13px;color:#475569;text-align:center;">
                <c:choose>
                  <c:when test="${b.brandUseYn eq 'Y'}"><i class="fa-solid fa-check" style="color:#059669"></i> 연동됨</c:when>
                  <c:otherwise><i class="fa-solid fa-xmark" style="color:#ef4444"></i> 제외됨</c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:center;">
                <div style="display:flex;gap:6px;justify-content:center;">
                  <button class="btn btn-outline btn-xs"
                    onclick="openEditModal(${b.brandNum}, '${b.brandName}', '${b.brandUseYn}')">
                    ✏️ 수정
                  </button>
                  <c:choose>
                    <c:when test="${b.brandUseYn eq 'Y'}">
                      <button class="btn btn-danger btn-xs"
                        onclick="toggleBrand(${b.brandNum}, 'N')">
                        🚫 비활성
                      </button>
                    </c:when>
                    <c:otherwise>
                      <button class="btn btn-outline btn-xs"
                        onclick="toggleBrand(${b.brandNum}, 'Y')"
                        style="color:#059669;border-color:#059669">
                        ✅ 활성화
                      </button>
                    </c:otherwise>
                  </c:choose>
                  <button class="btn btn-danger btn-xs"
                    onclick="deleteBrand(${b.brandNum}, '${b.brandName}')">
                    🗑️ 삭제
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty brandList}">
            <tr>
              <td colspan="5" style="text-align:center;padding:60px 0;color:#94a3b8;">
                <i class="fa-solid fa-folder-open" style="font-size:32px;margin-bottom:12px;display:block;color:#e2e8f0;"></i> 등록된 브랜드가 없습니다.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<div class="modal-overlay" id="modal-add">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">브랜드 등록</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-add')"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/brand/brandInsert.do" method="post">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">브랜드명 <span style="color:#ef4444">*</span></label>
          <input class="f-input" type="text" name="brandName" placeholder="예) 나이키, 아디다스" required>
          <div class="f-hint">등록 즉시 상품마스터 관리의 브랜드 목록에 반영됩니다.</div>
        </div>
        <div class="form-group">
          <label class="f-label">활성 여부</label>
          <select class="f-input" name="brandUseYn">
            <option value="Y">활성 (상품 등록 가능)</option>
            <option value="N">비활성 (숨김)</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('modal-add')">취소</button>
        <button type="submit" class="btn btn-black">등록하기</button>
      </div>
    </form>
  </div>
</div>

<div class="modal-overlay" id="modal-edit">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">브랜드 수정</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-edit')"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/brand/brandUpdate.do" method="post">
      <input type="hidden" name="brandNum" id="editBrandNum">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">브랜드명 <span style="color:#ef4444">*</span></label>
          <input class="f-input" type="text" name="brandName" id="editBrandName" required>
        </div>
        <div class="form-group">
          <label class="f-label">활성 여부</label>
          <select class="f-input" name="brandUseYn" id="editBrandUseYn">
            <option value="Y">활성 (상품 등록 가능)</option>
            <option value="N">비활성 (숨김)</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('modal-edit')">취소</button>
        <button type="submit" class="btn btn-black">수정 저장</button>
      </div>
    </form>
  </div>
</div>

<form id="toggleForm" action="${pageContext.request.contextPath}/shop/brand/brandToggle.do" method="post">
  <input type="hidden" name="brandNum" id="toggleBrandNum">
  <input type="hidden" name="brandUseYn" id="toggleBrandUseYn">
</form>

<form id="deleteForm" action="${pageContext.request.contextPath}/shop/brand/brandDelete.do" method="post">
  <input type="hidden" name="brandNum" id="deleteBrandNum">
</form>

<div class="toast" id="toast"></div>

<script>
function openAddModal() {
    document.getElementById('modal-add').classList.add('open');
}
function openEditModal(num, name, useYn) {
    document.getElementById('editBrandNum').value = num;
    document.getElementById('editBrandName').value = name;
    document.getElementById('editBrandUseYn').value = useYn;
    document.getElementById('modal-edit').classList.add('open');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('open');
}
document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) {
        if (e.target === o) o.classList.remove('open');
    });
});
function toggleBrand(num, useYn) {
    var msg = useYn === 'N' ? '비활성화하면 상품마스터에서 이 브랜드가 숨겨집니다. 계속하시겠습니까?' : '활성화하시겠습니까?';
    if (!confirm(msg)) return;
    document.getElementById('toggleBrandNum').value = num;
    document.getElementById('toggleBrandUseYn').value = useYn;
    document.getElementById('toggleForm').submit();
}
function deleteBrand(num, name) {
    if (!confirm('[' + name + '] 브랜드를 삭제합니다.\n이 브랜드에 등록된 상품이 있으면 삭제가 안될 수 있습니다.\n계속하시겠습니까?')) return;
    document.getElementById('deleteBrandNum').value = num;
    document.getElementById('deleteForm').submit();
}
function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}
</script>
</body>
</html>