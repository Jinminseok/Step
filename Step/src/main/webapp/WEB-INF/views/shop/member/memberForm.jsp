<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 회원 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;gap:12px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;letter-spacing:.02em}
.topbar-path{font-size:11px;color:#444}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.t-btn{width:32px;height:32px;border:1px solid #333;background:transparent;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:14px;color:#888;border-radius:2px}
.t-btn:hover{border-color:#555;color:#fff}
.content{padding:24px;flex:1}
.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}
.stats-row{display:grid;grid-template-columns:repeat(5,1fr);gap:1px;background:var(--border);margin-bottom:20px;border:1px solid var(--border)}
.stat-card{background:var(--white);padding:16px 18px}
.stat-label{font-size:10px;font-weight:700;color:var(--gray4);margin-bottom:8px;text-transform:uppercase;letter-spacing:.08em}
.stat-val{font-family:'Space Grotesk',sans-serif;font-size:24px;font-weight:700;letter-spacing:-1px}
.stat-change{font-size:11px;margin-top:5px;color:var(--gray4)}
.toolbar{display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;max-width:300px}
.search-wrap input{width:100%;padding:9px 12px 9px 36px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black)}
.search-wrap input:focus{border-color:var(--black)}
.search-wrap input::placeholder{color:var(--gray5)}
.search-ico{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:14px}
.sel{padding:9px 12px;border:1px solid var(--border);background:var(--white);font-size:12px;font-family:inherit;outline:none;color:var(--gray2);cursor:pointer}
.btn{padding:9px 16px;border:none;cursor:pointer;font-size:12px;font-weight:700;font-family:inherit;transition:all .18s;display:inline-flex;align-items:center;justify-content:center;gap:6px;letter-spacing:.02em;white-space:nowrap}
.btn-black{background:var(--black);color:#fff}
.btn-black:hover{background:#333}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--border)}
.btn-outline:hover{border-color:var(--black);color:var(--black)}
.btn-danger{background:#fff0f0;color:var(--red);border:1px solid #ffd0d0}
.btn-danger:hover{background:var(--red);color:#fff}
.btn-blue{background:#e8f0ff;color:var(--blue);border:1px solid #c0d0ff}
.btn-blue:hover{background:var(--blue);color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px;white-space:nowrap}
.badge{display:inline-flex;align-items:center;padding:3px 9px;font-size:11px;font-weight:700;border-radius:20px}
.b-vip{background:#fff3cd;color:#856404}
.b-gold{background:#fff8e1;color:#f57c00}
.b-silver{background:#f0f0f0;color:#555}
.b-normal{background:#e8f5e8;color:var(--green)}
.tbl-wrap{overflow-x:auto;background:var(--white);border:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray4);letter-spacing:.08em;text-transform:uppercase;border-bottom:1px solid var(--border);text-align:left;background:var(--white)}
td{padding:12px 14px;border-bottom:1px solid var(--border);font-size:13px;color:var(--gray2);vertical-align:middle;white-space:nowrap}
tr:last-child td{border-bottom:none}
tr:hover td{background:#fafafa}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:520px;max-height:90vh;display:flex;flex-direction:column;border:1px solid var(--border)}
.modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--black);color:#fff}
.modal-title{font-family:'Space Grotesk',sans-serif;font-size:15px;font-weight:700}
.modal-close{background:none;border:none;color:#888;cursor:pointer;font-size:20px;line-height:1;padding:0}
.modal-close:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-footer{padding:14px 22px;border-top:1px solid var(--border);display:flex;gap:8px;justify-content:flex-end;background:var(--gray7)}
.form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
.f-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.f-input{padding:10px 12px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black);width:100%}
.f-input:focus{border-color:var(--black)}
.f-input[readonly]{background:#f9f9f9;color:var(--gray3)}
.f-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.info-section{background:#f9f9f9;border:1px solid var(--border);padding:14px 16px;margin-bottom:14px}
.info-section-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:10px}
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--black);color:#fff;padding:11px 22px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="topbar">
    <div class="topbar-title">회원 관리</div>
    <div class="topbar-path">Admin > 회원 관리</div>
    <div class="topbar-right">
      <div class="t-btn">🔔</div>
      <div class="t-btn">⚙️</div>
    </div>
  </div>

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

    <!-- 통계 카드 -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">전체 회원</div>
        <div class="stat-val">${totalCount}</div>
        <div class="stat-change">가입 회원 수</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">일반 회원</div>
        <div class="stat-val" style="color:var(--green)">${normalCount}</div>
        <div class="stat-change">GRADE 1</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">실버</div>
        <div class="stat-val" style="color:#555">${silverCount}</div>
        <div class="stat-change">GRADE 2</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">골드</div>
        <div class="stat-val" style="color:#f57c00">${goldCount}</div>
        <div class="stat-change">GRADE 3</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">VIP</div>
        <div class="stat-val" style="color:#856404">${vipCount}</div>
        <div class="stat-change">GRADE 4</div>
      </div>
    </div>

    <!-- 툴바 -->
    <form action="${pageContext.request.contextPath}/shop/member/memberForm.do" method="get" class="toolbar">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input type="text" name="keyword" value="${keyword}" placeholder="이름, 이메일, 전화번호 검색">
      </div>
      <select class="sel" name="grade" onchange="this.form.submit()">
        <option value="">전체 등급</option>
        <option value="1" ${gradeSel eq '1' ? 'selected':''}>일반</option>
        <option value="2" ${gradeSel eq '2' ? 'selected':''}>실버</option>
        <option value="3" ${gradeSel eq '3' ? 'selected':''}>골드</option>
        <option value="4" ${gradeSel eq '4' ? 'selected':''}>VIP</option>
      </select>
      <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>
    </form>

    <!-- 테이블 -->
    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:60px">번호</th>
            <th style="width:100px">아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th style="width:130px">전화번호</th>
            <th style="width:80px">등급</th>
            <th style="width:130px">가입일</th>
            <th style="width:130px">최근 로그인</th>
            <th style="width:160px">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="m" items="${memberList}">
            <tr>
              <td style="color:var(--gray4);font-size:12px">${m.userNum}</td>
              <td style="font-size:12px;color:var(--gray3)">${m.userId}</td>
              <td style="font-weight:700">${m.userName}</td>
              <td style="color:var(--gray3)">${m.email}</td>
              <td>${m.phone}</td>
              <td>
                <c:choose>
                  <c:when test="${m.grade == 4}"><span class="badge b-vip">⭐ VIP</span></c:when>
                  <c:when test="${m.grade == 3}"><span class="badge b-gold">🥇 골드</span></c:when>
                  <c:when test="${m.grade == 2}"><span class="badge b-silver">🥈 실버</span></c:when>
                  <c:otherwise><span class="badge b-normal">일반</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-size:12px;color:var(--gray4)">${m.createdAt}</td>
              <td style="font-size:12px;color:var(--gray4)">${m.lastLogin}</td>
              <td>
                <div style="display:flex;gap:6px">
                  <button class="btn btn-blue btn-xs"
                    onclick="openDetailModal(
                      ${m.userNum}, '${m.userId}', '${m.userName}',
                      '${m.email}', '${m.phone}', ${m.grade},
                      '${m.createdAt}', '${m.lastLogin}'
                    )">👤 상세</button>
                  <button class="btn btn-danger btn-xs"
                    onclick="deleteMember(${m.userNum}, '${m.userName}')">🗑️ 삭제</button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty memberList}">
            <tr>
              <td colspan="9" style="text-align:center;padding:40px;color:var(--gray4)">
                📭 등록된 회원이 없습니다.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<!-- 회원 상세 / 등급 변경 모달 -->
<div class="modal-overlay" id="modal-detail">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">회원 상세 정보</div>
      <button class="modal-close" onclick="closeModal('modal-detail')">✕</button>
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

        <div class="info-section">
          <div class="info-section-title">등급 변경</div>
          <div class="form-group" style="margin-bottom:0">
            <label class="f-label">회원 등급 *</label>
            <select class="f-input" name="grade" id="detailGrade">
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

<!-- 삭제 폼 -->
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
</script>
</body>
</html>