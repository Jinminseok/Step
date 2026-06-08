<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 카테고리 관리</title>
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

/* --- 툴바 --- */
.toolbar {
    display:flex;
    align-items:center;
    gap:12px; 
    margin-bottom:16px;
    flex-wrap:wrap;
}
.search-wrap {
    position:relative;
    width:320px; 
    flex-shrink:0;
}
.search-wrap input {
    width:100%;
    height:40px; 
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
    height:40px; 
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
    height:40px; 
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
.btn-xs {height:28px; padding:0 10px; font-size:11px;} 

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

/*  PAGINATION  */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

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
    <c:set var="pageTitle" value="카테고리 관리" scope="request" />
    <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <c:if test="${not empty msg}">
      <c:choose>
        <c:when test="${msg eq 'insert_ok'}">
          <script>window.onload = function(){ showToast('카테고리가 등록되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'update_ok'}">
          <script>window.onload = function(){ showToast('카테고리가 수정되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'delete_ok'}">
          <script>window.onload = function(){ showToast('카테고리가 삭제되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'toggle_ok'}">
          <script>window.onload = function(){ showToast('상태가 변경되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'delete_fail'}">
          <script>window.onload = function(){ showToast('이 카테고리에 등록된 상품이 있어 삭제할 수 없습니다.'); }</script>
        </c:when>
      </c:choose>
    </c:if>

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">카테고리 관리</div>
        <div class="page-hdr-sub">카테고리 등록·수정·상태를 관리합니다. 상품 등록 시 카테고리 목록에 반영됩니다.</div>
      </div>
      <button class="btn btn-black" onclick="openAddModal()"><i class="fa-solid fa-plus"></i> 카테고리 등록</button>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">전체 카테고리</div>
        <div class="stat-val">${totalCount}</div>
        <div class="stat-change">등록된 카테고리</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">활성 카테고리</div>
        <div class="stat-val" style="color:#059669">${activeCount}</div>
        <div class="stat-change">사용 중</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">비활성 카테고리</div>
        <div class="stat-val" style="color:#94a3b8">${inactiveCount}</div>
        <div class="stat-change">숨김 처리됨</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">상품 등록 가능</div>
        <div class="stat-val" style="color:#3b82f6">${activeCount}</div>
        <div class="stat-change">상품마스터 연동</div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/shop/category/categoryForm.do" method="get" class="toolbar">
      <div class="search-wrap">
        <span class="search-ico"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" name="keyword" value="${keyword}" placeholder="카테고리명 검색">
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
            <th style="width:80px; text-align:center;">순서</th>
            <th style="width:80px; text-align:center;">번호</th>
            <th>카테고리명</th>
            <th style="width:100px; text-align:center;">상태</th>
            <th style="width:140px; text-align:center;">상품마스터 반영</th>
            <th style="width:240px; text-align:center;">관리</th>
          </tr>
        </thead>
        <tbody id="catTbody">
          <c:forEach var="c" items="${categoryList}">
            <tr class="cat-row">
              <td style="font-family:'Space Grotesk',sans-serif;font-weight:700;color:#94a3b8;text-align:center">${c.catSortNo}</td>
              <td style="color:#64748b;font-size:13px;text-align:center">${c.catNum}</td>
              <td style="font-weight:600;font-size:15px;color:#0f172a">${c.catName}</td>
              <td style="text-align:center">
                <c:choose>
                  <c:when test="${c.catUseYn eq 'Y'}"><span class="badge b-green">● 활성</span></c:when>
                  <c:otherwise><span class="badge b-gray">● 비활성</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-size:13px;color:#475569;text-align:center">
                <c:choose>
                  <c:when test="${c.catUseYn eq 'Y'}"><i class="fa-solid fa-check" style="color:#059669"></i> 연동됨</c:when>
                  <c:otherwise><i class="fa-solid fa-xmark" style="color:#ef4444"></i> 제외됨</c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:center">
                <div style="display:flex;gap:6px;justify-content:center;">
                  <button class="btn btn-outline btn-xs"
                    onclick="openEditModal(${c.catNum}, '${c.catName}', '${c.catUseYn}', ${c.catSortNo})">✏️ 수정</button>
                  <c:choose>
                    <c:when test="${c.catUseYn eq 'Y'}">
                      <button class="btn btn-danger btn-xs" onclick="toggleCategory(${c.catNum}, 'N')">🚫 비활성</button>
                    </c:when>
                    <c:otherwise>
                      <button class="btn btn-outline btn-xs" onclick="toggleCategory(${c.catNum}, 'Y')"
                        style="color:#059669;border-color:#059669">✅ 활성화</button>
                    </c:otherwise>
                  </c:choose>
                  <button class="btn btn-danger btn-xs" onclick="deleteCategory(${c.catNum}, '${c.catName}')">🗑️ 삭제</button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty categoryList}">
            <tr><td colspan="6" style="text-align:center;padding:60px 0;color:#94a3b8;"><i class="fa-solid fa-folder-open" style="font-size:32px;margin-bottom:12px;display:block;color:#e2e8f0;"></i> 등록된 카테고리가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
      
      <%-- PAGINATION HTML --%>
      <div class="pagination-wrap" id="catPagination" style="display:none;">
        <div class="page-info" id="catPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="catPageBtns"></div>
      </div>

    </div>
  </div>
</div>

<div class="modal-overlay" id="modal-add">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">카테고리 등록</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-add')"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/category/categoryInsert.do" method="post">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">카테고리명 <span style="color:#ef4444">*</span></label>
          <input class="f-input" type="text" name="catName" placeholder="예) 운동화, 샌들, 부츠" required>
          <div class="f-hint">등록 즉시 상품마스터 관리의 카테고리 목록에 반영됩니다.</div>
        </div>
        <div class="form-group">
          <label class="f-label">활성 여부</label>
          <select class="f-input" name="catUseYn">
            <option value="Y">활성 (상품 등록 가능)</option>
            <option value="N">비활성 (숨김)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="f-label">정렬 순서</label>
          <input class="f-input" type="number" name="catSortNo" value="${totalCount + 1}" min="1">
          <div class="f-hint">숫자가 작을수록 앞에 표시됩니다. (현재 마지막: ${totalCount})</div>
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
      <div class="modal-title">카테고리 수정</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-edit')"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/category/categoryUpdate.do" method="post">
      <input type="hidden" name="catNum" id="editCatNum">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">카테고리명 <span style="color:#ef4444">*</span></label>
          <input class="f-input" type="text" name="catName" id="editCatName" required>
        </div>
        <div class="form-group">
          <label class="f-label">활성 여부</label>
          <select class="f-input" name="catUseYn" id="editCatUseYn">
            <option value="Y">활성 (상품 등록 가능)</option>
            <option value="N">비활성 (숨김)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="f-label">정렬 순서</label>
          <input class="f-input" type="number" name="catSortNo" id="editCatSortNo" min="1">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('modal-edit')">취소</button>
        <button type="submit" class="btn btn-black">수정 저장</button>
      </div>
    </form>
  </div>
</div>

<form id="toggleForm" action="${pageContext.request.contextPath}/shop/category/categoryToggle.do" method="post">
  <input type="hidden" name="catNum" id="toggleCatNum">
  <input type="hidden" name="catUseYn" id="toggleCatUseYn">
</form>
<form id="deleteForm" action="${pageContext.request.contextPath}/shop/category/categoryDelete.do" method="post">
  <input type="hidden" name="catNum" id="deleteCatNum">
</form>

<div class="toast" id="toast"></div>

<script>
function openAddModal() { document.getElementById('modal-add').classList.add('open'); }
function openEditModal(num, name, useYn, sortNo) {
    document.getElementById('editCatNum').value = num;
    document.getElementById('editCatName').value = name;
    document.getElementById('editCatUseYn').value = useYn;
    document.getElementById('editCatSortNo').value = sortNo;
    document.getElementById('modal-edit').classList.add('open');
}
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) { if (e.target === o) o.classList.remove('open'); });
});
function toggleCategory(num, useYn) {
    var msg = useYn === 'N' ? '비활성화하면 상품마스터에서 이 카테고리가 숨겨집니다. 계속하시겠습니까?' : '활성화하시겠습니까?';
    if (!confirm(msg)) return;
    document.getElementById('toggleCatNum').value = num;
    document.getElementById('toggleCatUseYn').value = useYn;
    document.getElementById('toggleForm').submit();
}
function deleteCategory(num, name) {
    if (!confirm('[' + name + '] 카테고리를 삭제합니다.\n이 카테고리에 등록된 상품이 있으면 삭제가 안될 수 있습니다.\n계속하시겠습니까?')) return;
    document.getElementById('deleteCatNum').value = num;
    document.getElementById('deleteForm').submit();
}
function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg; t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

let currentCatPage = 1;
const catItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allCatRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('catTbody');
    if (tbody) {
        allCatRows = Array.from(tbody.querySelectorAll('tr.cat-row'));
        if (allCatRows.length > 0) {
            renderCatTable();
        } else {
            document.getElementById('catPagination').style.display = 'none';
        }
    }
});

function renderCatTable() {
    allCatRows.forEach(r => r.style.display = 'none');
    const start = (currentCatPage - 1) * catItemsPerPage;
    const end = start + catItemsPerPage;
    
    for (let i = start; i < end && i < allCatRows.length; i++) {
        allCatRows[i].style.display = '';
    }
    renderCatPagination();
}

function renderCatPagination() {
    const totalPages = Math.ceil(allCatRows.length / catItemsPerPage);
    const pw = document.getElementById('catPagination');
    const pi = document.getElementById('catPageInfo');
    const pb = document.getElementById('catPageBtns');

    if (!pw || !pb) return;

    if (allCatRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentCatPage - 1) * catItemsPerPage + 1;
    const en = Math.min(currentCatPage * catItemsPerPage, allCatRows.length);
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allCatRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentCatPage === 1 ? 'disabled' : ''}" onclick="changeCatPage(\${currentCatPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentCatPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentCatPage ? 'on' : ''}" onclick="changeCatPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentCatPage === totalPages ? 'disabled' : ''}" onclick="changeCatPage(\${currentCatPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeCatPage(p) {
    const totalPages = Math.ceil(allCatRows.length / catItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentCatPage = p;
    renderCatTable();
}
</script>
</body>
</html>