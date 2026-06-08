<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 회원 관리</title>
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

/* STATS ROW  */
.stats-row { display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 30px; }
.stat-card { background: #fff; padding: 20px 24px; border: 1px solid #e9ecef; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
.stat-label { font-size: 12px; font-weight: 600; color: #868e96; margin-bottom: 8px; }
.stat-val { font-family: 'Space Grotesk', sans-serif; font-size: 28px; font-weight: 700; color: #212529; }
.stat-change { font-size: 12px; margin-top: 8px; color: #adb5bd; }

/* ──  툴바 및 필터 검색창 ── */
.toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
.search-wrap { position: relative; width: 320px; flex-shrink: 0; }
.search-wrap input {
    width: 100%;
    height: 40px; 
    padding: 0 12px 0 38px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background: #fff;
    font-size: 13px;
    outline: none;
    color: #333;
    transition: all 0.2s ease;
}
.search-wrap input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.search-wrap input::placeholder { color: #9ca3af; }
.search-ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 14px; }

.sel {
    height: 40px; 
    padding: 0 30px 0 14px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background: #fff;
    font-size: 13px;
    font-family: inherit;
    outline: none;
    color: #475569;
    cursor: pointer;
    flex-shrink: 0;
}

/* BUTTONS */
.btn {
    height: 40px; 
    padding: 0 18px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    font-family: inherit;
    transition: all .2s;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    white-space: nowrap;
}
.btn-black { background: #111827; color: #fff; }
.btn-black:hover { background: #374151; }
.btn-outline { background: #fff; color: #475569; border: 1px solid #e2e8f0; }
.btn-outline:hover { border-color: #111827; color: #111827; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.btn-danger:hover { background: #ef4444; color: #fff; }

.btn-blue { background: #f0f4ff; color: #1a73e8; border: 1px solid #cce0ff; }
.btn-blue:hover { background: #1a73e8; color: #fff; border-color: #1a73e8; }
.btn-xs { height: 28px; padding: 0 10px; font-size: 11px; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
.b-vip { background: #fef3c7; color: #92400e; }      
.b-gold { background: #fff7ed; color: #c2410c; }     
.b-silver { background: #f1f5f9; color: #475569; }   
.b-normal { background: #dcfce7; color: #059669; }  

/* TABLE LIST */
.tbl-wrap { background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
table { width: 100%; border-collapse: collapse; }
th { padding: 14px 16px; font-size: 13px; font-weight: 600; color: #475569; border-bottom: 1px solid #e2e8f0; background: #f8fafc; text-align: center; }
td { padding: 14px 16px; border-bottom: 1px solid #f1f5f9; font-size: 14px; color: #334155; vertical-align: middle; text-align: center; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }

/* PAGINATION */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

/* ── MODAL OVERLAY & BOX ── */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 3000; align-items: center; justify-content: center; }
.modal-overlay.open { display: flex; }
.modal-box { background: #fff; width: 520px; border-radius: 12px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; gap: 8px; justify-content: flex-end; background: #f8fafc; }

/* FORM & DETAILED BOX */
.form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.f-label { font-size: 13px; font-weight: 600; color: #334155; }
.f-input { height: 40px; padding: 0 12px; border: 1px solid #e2e8f0; border-radius: 6px; background: #fff; font-size: 14px; outline: none; color: #0f172a; width: 100%; transition: border 0.2s; }
.f-input:focus { border-color: #3b82f6; }
.f-input[readonly] { background: #f8fafc; color: #64748b; cursor: default; }
.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.info-section { background: #f8fafc; border: 1px solid #e2e8f0; padding: 16px; margin-bottom: 20px; border-radius: 8px; }
.info-section-title { font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 12px; border-bottom: 2px solid #0f172a; padding-bottom: 4px; }

/* TOAST */
.toast { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%) translateY(20px); background: #111827; color: #fff; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 500; opacity: 0; transition: all .3s; z-index: 9999; pointer-events: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
.toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <c:set var="pageTitle" value="회원 관리" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <c:if test="${not empty msg}">
      <c:choose>
        <c:when test="${msg eq 'grade_ok'}">
          <script>window.onload = function(){ showToast('회원 등급이 변경되었습니다.'); }</script>
        </c:when>
        <c:when test="${msg eq 'delete_ok'}">
          <script>window.onload = function(){ showToast('회원이 삭제되었습니다.'); }</script>
        </c:when>
      </c:choose>
    </c:if>

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">회원 관리</div>
        <div class="page-hdr-sub">회원 정보 조회, 등급 변경, 계정 삭제를 관리합니다.</div>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">전체 회원</div>
        <div class="stat-val">${totalCount}</div>
        <div class="stat-change">가입 회원 수</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">일반 회원</div>
        <div class="stat-val" style="color:#059669">${normalCount}</div>
        <div class="stat-change">GRADE 1</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">실버</div>
        <div class="stat-val" style="color:#475569">${silverCount}</div>
        <div class="stat-change">GRADE 2</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">골드</div>
        <div class="stat-val" style="color:#c2410c">${goldCount}</div>
        <div class="stat-change">GRADE 3</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">VIP</div>
        <div class="stat-val" style="color:#92400e">${vipCount}</div>
        <div class="stat-change">GRADE 4</div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/shop/member/memberForm.do" method="get" class="toolbar">
      <div class="search-wrap">
        <span class="search-ico"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" name="keyword" value="${keyword}" placeholder="이름, 이메일, 전화번호 검색">
      </div>
      <select class="sel" name="grade" onchange="this.form.submit()">
        <option value="">등급 전체</option>
        <option value="1" ${gradeSel eq '1' ? 'selected':''}>일반</option>
        <option value="2" ${gradeSel eq '2' ? 'selected':''}>실버</option>
        <option value="3" ${gradeSel eq '3' ? 'selected':''}>골드</option>
        <option value="4" ${gradeSel eq '4' ? 'selected':''}>VIP</option>
      </select>
      <button type="submit" class="btn btn-outline"><i class="fa-solid fa-rotate-right"></i> 조회</button>
    </form>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:80px; text-align:center;">번호</th>
            <th style="width:120px; text-align:center;">아이디</th>
            <th style="text-align:left; padding-left:15px;">이름</th>
            <th style="text-align:left; padding-left:15px;">이메일</th>
            <th style="width:150px; text-align:center;">전화번호</th>
            <th style="width:100px; text-align:center;">등급</th>
            <th style="width:140px; text-align:center;">가입일</th>
            <th style="width:140px; text-align:center;">최근 로그인</th>
            <th style="width:180px; text-align:center;">관리</th>
          </tr>
        </thead>
        <tbody id="memberTbody">
          <c:forEach var="m" items="${memberList}">
            <tr class="member-row">
              <td style="color:#64748b; font-size:13px; text-align:center;">${m.userNum}</td>
              <td style="font-size:13px; color:#475569; text-align:center;">${m.userId}</td>
              <td style="font-weight:600; color:#0f172a; text-align:left; padding-left:15px;">${m.userName}</td>
              <td style="color:#475569; text-align:left; padding-left:15px;">${m.email}</td>
              <td style="text-align:center;">${m.phone}</td>
              <td style="text-align:center;">
                <c:choose>
                  <c:when test="${m.grade == 4}"><span class="badge b-vip">⭐ VIP</span></c:when>
                  <c:when test="${m.grade == 3}"><span class="badge b-gold">🥇 골드</span></c:when>
                  <c:when test="${m.grade == 2}"><span class="badge b-silver">🥈 실버</span></c:when>
                  <c:otherwise><span class="badge b-normal">일반</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-size:13px; color:#64748b; text-align:center;">${m.createdAt}</td>
              <td style="font-size:13px; color:#64748b; text-align:center;">${m.lastLogin}</td>
              <td style="text-align:center;">
                <div style="display:flex; gap:6px; justify-content:center;">
                  <button type="button" class="btn btn-blue btn-xs"
                    onclick="openDetailModal(
                      ${m.userNum}, '${m.userId}', '${m.userName}',
                      '${m.email}', '${m.phone}', ${m.grade},
                      '${m.createdAt}', '${m.lastLogin}'
                    )">👤 상세</button>
                  <button type="button" class="btn btn-danger btn-xs"
                    onclick="deleteMember(${m.userNum}, '${m.userName}')">🗑️ 삭제</button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty memberList}">
            <tr>
              <td colspan="9" style="text-align:center; padding:60px 0; color:#94a3b8;">
                <i class="fa-solid fa-users-slash" style="font-size:32px; margin-bottom:12px; display:block; color:#e2e8f0;"></i>등록된 회원이 없습니다.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>

      <%--  PAGINATION HTML  --%>
      <div class="pagination-wrap" id="memberPagination" style="display:none;">
        <div class="page-info" id="memberPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="memberPageBtns"></div>
      </div>

    </div>

  </div>
</div>

<div class="modal-overlay" id="modal-detail">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">회원 상세 정보</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-detail')"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/member/memberUpdate.do" method="post">
      <input type="hidden" name="userNum" id="detailUserNum">
      <div class="modal-body">

        <div class="info-section">
          <div class="info-section-title">기본 정보</div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">회원 번호</label>
              <input class="f-input" type="text" id="detailNum" readonly>
            </div>
            <div class="form-group">
              <label class="f-label">아이디</label>
              <input class="f-input" type="text" id="detailId" readonly>
            </div>
          </div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">이름</label>
              <input class="f-input" type="text" id="detailName" readonly>
            </div>
            <div class="form-group">
              <label class="f-label">전화번호</label>
              <input class="f-input" type="text" id="detailPhone" readonly>
            </div>
          </div>
          <div class="form-group">
            <label class="f-label">이메일</label>
            <input class="f-input" type="text" id="detailEmail" readonly>
          </div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">가입일</label>
              <input class="f-input" type="text" id="detailCreated" readonly>
            </div>
            <div class="form-group">
              <label class="f-label">최근 로그인</label>
              <input class="f-input" type="text" id="detailLogin" readonly>
            </div>
          </div>
        </div>

        <div class="info-section" style="margin-bottom:0;">
          <div class="info-section-title">등급 변경</div>
          <div class="form-group" style="margin-bottom:0">
            <label class="f-label">회원 등급 *</label>
            <select class="f-input" name="grade" id="detailGrade" style="cursor:pointer; padding:0 12px;">
              <option value="1">1 - 일반</option>
              <option value="2">2 - 실버</option>
              <option value="3">3 - 골드</option>
              <option value="4">4 - VIP</option>
            </select>
          </div>
        </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('modal-detail')">닫기</button>
        <button type="submit" class="btn btn-black">등급 저장</button>
      </div>
    </form>
  </div>
</div>

<form id="deleteForm" action="${pageContext.request.contextPath}/shop/member/memberDelete.do" method="post">
  <input type="hidden" name="userNum" id="deleteUserNum">
</form>

<div class="toast" id="toast"></div>

<script>
function openDetailModal(userNum, userId, userName, email, phone, grade, createdAt, lastLogin) {
    document.getElementById('detailUserNum').value = userNum;
    document.getElementById('detailNum').value     = userNum;
    document.getElementById('detailId').value      = userId;
    document.getElementById('detailName').value    = userName;
    document.getElementById('detailEmail').value   = email;
    document.getElementById('detailPhone').value   = phone;
    document.getElementById('detailGrade').value   = grade;
    document.getElementById('detailCreated').value = createdAt;
    document.getElementById('detailLogin').value   = lastLogin || '없음';
    document.getElementById('modal-detail').classList.add('open');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('open');
}
document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) {
        if (e.target === o) o.classList.remove('open');
    });
});
function deleteMember(userNum, name) {
    if (!confirm('[' + name + '] 회원을 삭제합니다.\n삭제된 회원 정보는 복구할 수 없습니다.\n계속하시겠습니까?')) return;
    document.getElementById('deleteUserNum').value = userNum;
    document.getElementById('deleteForm').submit();
}
function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

let currentMemberPage = 1;
const memberItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allMemberRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('memberTbody');
    if (tbody) {
        allMemberRows = Array.from(tbody.querySelectorAll('tr.member-row'));
        if (allMemberRows.length > 0) {
            renderMemberTable();
        } else {
            document.getElementById('memberPagination').style.display = 'none';
        }
    }
});

function renderMemberTable() {
    allMemberRows.forEach(r => r.style.display = 'none');
    const start = (currentMemberPage - 1) * memberItemsPerPage;
    const end = start + memberItemsPerPage;
    
    for (let i = start; i < end && i < allMemberRows.length; i++) {
        allMemberRows[i].style.display = '';
    }
    renderMemberPagination();
}

function renderMemberPagination() {
    const totalPages = Math.ceil(allMemberRows.length / memberItemsPerPage);
    const pw = document.getElementById('memberPagination');
    const pi = document.getElementById('memberPageInfo');
    const pb = document.getElementById('memberPageBtns');

    if (!pw || !pb) return;

    if (allMemberRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentMemberPage - 1) * memberItemsPerPage + 1;
    const en = Math.min(currentMemberPage * memberItemsPerPage, allMemberRows.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allMemberRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentMemberPage === 1 ? 'disabled' : ''}" onclick="changeMemberPage(\${currentMemberPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentMemberPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentMemberPage ? 'on' : ''}" onclick="changeMemberPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentMemberPage === totalPages ? 'disabled' : ''}" onclick="changeMemberPage(\${currentMemberPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeMemberPage(p) {
    const totalPages = Math.ceil(allMemberRows.length / memberItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentMemberPage = p;
    renderMemberTable();
}
</script>
</body>
</html>