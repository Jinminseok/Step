<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 카테고리 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
/* MAIN */
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

/* STATS */
.stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:var(--border);margin-bottom:20px;border:1px solid var(--border)}
.stat-card{background:var(--white);padding:16px 18px}
.stat-label{font-size:10px;font-weight:700;color:var(--gray4);margin-bottom:8px;text-transform:uppercase;letter-spacing:.08em}
.stat-val{font-family:'Space Grotesk',sans-serif;font-size:24px;font-weight:700;letter-spacing:-1px}
.stat-change{font-size:11px;margin-top:5px;color:var(--gray4)}

/* TOOLBAR */
.toolbar{display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;max-width:300px}
.search-wrap input{width:100%;padding:9px 12px 9px 36px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black)}
.search-wrap input:focus{border-color:var(--black)}
.search-wrap input::placeholder{color:var(--gray5)}
.search-ico{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:14px}
.sel{padding:9px 12px;border:1px solid var(--border);background:var(--white);font-size:12px;font-family:inherit;outline:none;color:var(--gray2);cursor:pointer}

/* BUTTONS */
.btn{padding:9px 16px;border:none;cursor:pointer;font-size:12px;font-weight:700;font-family:inherit;transition:all .18s;display:inline-flex;align-items:center;justify-content:center;gap:6px;letter-spacing:.02em;white-space:nowrap}
.btn-black{background:var(--black);color:#fff}
.btn-black:hover{background:#333}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--border)}
.btn-outline:hover{border-color:var(--black);color:var(--black)}
.btn-danger{background:#fff0f0;color:var(--red);border:1px solid #ffd0d0}
.btn-danger:hover{background:var(--red);color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px;white-space:nowrap}

/* BADGE */
.badge{display:inline-flex;align-items:center;padding:2px 7px;font-size:10px;font-weight:700}
.b-green{background:#e8f5e8;color:var(--green)}
.b-gray{background:var(--gray7);color:var(--gray3)}

/* TABLE */
.tbl-wrap{overflow-x:auto;background:var(--white);border:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray4);letter-spacing:.08em;text-transform:uppercase;border-bottom:1px solid var(--border);text-align:left;background:var(--white)}
td{padding:12px 14px;border-bottom:1px solid var(--border);font-size:13px;color:var(--gray2);vertical-align:middle;white-space:nowrap}
tr:last-child td{border-bottom:none}
tr:hover td{background:#fafafa}

/* MODAL */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:480px;max-height:90vh;display:flex;flex-direction:column;border:1px solid var(--border)}
.modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--black);color:#fff}
.modal-title{font-family:'Space Grotesk',sans-serif;font-size:15px;font-weight:700;letter-spacing:.02em}
.modal-close{background:none;border:none;color:#888;cursor:pointer;font-size:20px;line-height:1;padding:0}
.modal-close:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-footer{padding:14px 22px;border-top:1px solid var(--border);display:flex;gap:8px;justify-content:flex-end;background:var(--gray7)}

/* FORM */
.form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:16px}
.f-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.f-input{padding:10px 12px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black);width:100%}
.f-input:focus{border-color:var(--black)}
.f-input::placeholder{color:var(--gray5)}
.f-hint{font-size:11px;color:var(--gray4);margin-top:3px}

/* 카테고리 전용 */
.sort-btns{display:flex;gap:4px}
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--black);color:#fff;padding:11px 22px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="topbar">
    <div class="topbar-title">카테고리 관리</div>
    <div class="topbar-path">Admin > 카테고리 관리</div>
    <div class="topbar-right">
      <div class="t-btn">🔔</div>
      <div class="t-btn">⚙️</div>
    </div>
  </div>

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
        <div class="page-hdr-sub">카테고리 등록·수정·순서 변경을 관리합니다. 상품 등록 시 카테고리 목록에 반영됩니다.</div>
      </div>
      <button class="btn btn-black" onclick="openAddModal()">+ 카테고리 등록</button>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">전체 카테고리</div>
        <div class="stat-val">${totalCount}</div>
        <div class="stat-change">등록된 카테고리</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">활성 카테고리</div>
        <div class="stat-val" style="color:var(--green)">${activeCount}</div>
        <div class="stat-change">사용 중</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">비활성 카테고리</div>
        <div class="stat-val" style="color:var(--gray4)">${inactiveCount}</div>
        <div class="stat-change">숨김 처리됨</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">상품 등록 가능</div>
        <div class="stat-val" style="color:var(--blue)">${activeCount}</div>
        <div class="stat-change">상품마스터 연동</div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/shop/category/categoryForm.do" method="get" class="toolbar">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input type="text" name="keyword" value="${keyword}" placeholder="카테고리명 검색">
      </div>
      <select class="sel" name="useYn" onchange="this.form.submit()">
        <option value="">전체 상태</option>
        <option value="Y" ${useYnSel eq 'Y' ? 'selected':''}>활성</option>
        <option value="N" ${useYnSel eq 'N' ? 'selected':''}>비활성</option>
      </select>
      <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>
    </form>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:60px">순서</th>
            <th style="width:60px">번호</th>
            <th>카테고리명</th>
            <th style="width:100px">상태</th>
            <th style="width:120px">상품마스터 반영</th>
            <th style="width:100px">순서 변경</th>
            <th style="width:220px">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${categoryList}" varStatus="vs">
            <tr>
              <td style="font-family:'Space Grotesk',sans-serif;font-weight:700;color:var(--gray3);text-align:center">${c.catSortNo}</td>
              <td style="color:var(--gray4);font-size:12px">${c.catNum}</td>
              <td style="font-weight:700;font-size:14px">${c.catName}</td>
              <td>
                <c:choose>
                  <c:when test="${c.catUseYn eq 'Y'}"><span class="badge b-green">● 활성</span></c:when>
                  <c:otherwise><span class="badge b-gray">● 비활성</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-size:12px;color:var(--gray3)">
                <c:choose>
                  <c:when test="${c.catUseYn eq 'Y'}">✅ 연동됨</c:when>
                  <c:otherwise>❌ 제외됨</c:otherwise>
                </c:choose>
              </td>
              <td>
                <div class="sort-btns">
                  <c:if test="${!vs.first}">
                    <button class="btn btn-outline btn-xs" onclick="sortCategory(${c.catNum}, 'up')">▲</button>
                  </c:if>
                  <c:if test="${!vs.last}">
                    <button class="btn btn-outline btn-xs" onclick="sortCategory(${c.catNum}, 'down')">▼</button>
                  </c:if>
                </div>
              </td>
              <td>
                <div style="display:flex;gap:6px">
                  <button class="btn btn-outline btn-xs"
                    onclick="openEditModal(${c.catNum}, '${c.catName}', '${c.catUseYn}', ${c.catSortNo})">✏️ 수정</button>
                  <c:choose>
                    <c:when test="${c.catUseYn eq 'Y'}">
                      <button class="btn btn-danger btn-xs" onclick="toggleCategory(${c.catNum}, 'N')">🚫 비활성화</button>
                    </c:when>
                    <c:otherwise>
                      <button class="btn btn-outline btn-xs" onclick="toggleCategory(${c.catNum}, 'Y')"
                        style="color:var(--green);border-color:var(--green)">✅ 활성화</button>
                    </c:otherwise>
                  </c:choose>
                  <button class="btn btn-danger btn-xs" onclick="deleteCategory(${c.catNum}, '${c.catName}')">🗑️ 삭제</button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty categoryList}">
            <tr><td colspan="7" style="text-align:center;padding:40px;color:var(--gray4)">📭 등록된 카테고리가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<!-- 카테고리 등록 모달 -->
<div class="modal-overlay" id="modal-add">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">카테고리 등록</div>
      <button class="modal-close" onclick="closeModal('modal-add')">✕</button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/category/categoryInsert.do" method="post">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">카테고리명 *</label>
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

<!-- 카테고리 수정 모달 -->
<div class="modal-overlay" id="modal-edit">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">카테고리 수정</div>
      <button class="modal-close" onclick="closeModal('modal-edit')">✕</button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/category/categoryUpdate.do" method="post">
      <input type="hidden" name="catNum" id="editCatNum">
      <div class="modal-body">
        <div class="form-group">
          <label class="f-label">카테고리명 *</label>
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

<!-- hidden 폼 -->
<form id="toggleForm" action="${pageContext.request.contextPath}/shop/category/categoryToggle.do" method="post">
  <input type="hidden" name="catNum" id="toggleCatNum">
  <input type="hidden" name="catUseYn" id="toggleCatUseYn">
</form>
<form id="deleteForm" action="${pageContext.request.contextPath}/shop/category/categoryDelete.do" method="post">
  <input type="hidden" name="catNum" id="deleteCatNum">
</form>
<form id="sortForm" action="${pageContext.request.contextPath}/shop/category/categorySort.do" method="post">
  <input type="hidden" name="catNum" id="sortCatNum">
  <input type="hidden" name="direction" id="sortDirection">
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
function sortCategory(num, direction) {
    document.getElementById('sortCatNum').value = num;
    document.getElementById('sortDirection').value = direction;
    document.getElementById('sortForm').submit();
}
function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg; t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}
</script>
</body>
</html>