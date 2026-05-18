<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 채팅 문의</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff}
.content{padding:24px;flex:1}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px;margin-bottom:4px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-bottom:20px}

.room-list{display:flex;flex-direction:column;gap:1px;background:var(--border);border:1px solid var(--border)}
.room-item{background:#fff;padding:16px 20px;display:flex;align-items:center;gap:0;transition:background .15s}
.room-item:hover{background:#f5f5f5}
.room-item.has-unread{border-left:3px solid #ff4d4d}

.room-av{width:44px;height:44px;border-radius:50%;background:#111;color:#fff;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.room-info{flex:1;min-width:0}
.room-name{font-weight:700;font-size:14px;margin-bottom:3px}
.room-last{font-size:12px;color:#9ca3af;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}

.room-meta{text-align:right;flex-shrink:0;display:flex;flex-direction:column;align-items:flex-end;gap:5px}
.room-time{font-size:11px;color:#9ca3af}
.unread-badge{background:#ff4d4d;color:#fff;font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px}
.no-unread{width:8px;height:8px;border-radius:50%;background:#e5e7eb;margin-right:2px}

.del-btn{margin-left:16px;padding:7px 14px;background:#fff0f0;color:#dc2626;border:1px solid #fca5a5;border-radius:6px;font-size:12px;font-weight:700;cursor:pointer;white-space:nowrap;font-family:'Noto Sans KR',sans-serif;flex-shrink:0;transition:background .15s}
.del-btn:hover{background:#dc2626;color:#fff}

.alert-success{background:#d4edda;color:#155724;padding:12px 16px;border:1px solid #c3e6cb;border-radius:6px;margin-bottom:16px;font-size:13px;font-weight:700}

.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:#111;color:#fff;padding:11px 22px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;border-radius:6px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="topbar"><div class="topbar-title">채팅 문의</div></div>
  <div class="content">

    <div class="page-hdr-title">채팅 문의 관리</div>
    <div class="page-hdr-sub">고객의 채팅 문의를 확인하고 답변하세요.</div>

    <%-- 삭제 완료 메시지 --%>
    <c:if test="${param.msg eq 'delete_ok'}">
      <div class="alert-success">✅ 채팅방이 삭제되었습니다.</div>
    </c:if>

    <div class="room-list">

      <c:forEach var="r" items="${roomList}">
        <div class="room-item ${r.unreadCnt > 0 ? 'has-unread' : ''}">

          <%-- 채팅방 클릭 영역 --%>
          <a href="${pageContext.request.contextPath}/shop/chat/adminChatView.do?roomNum=${r.roomNum}"
             style="display:flex;align-items:center;gap:14px;flex:1;text-decoration:none;color:inherit;min-width:0">
            <div class="room-av">👤</div>
            <div class="room-info">
              <div class="room-name">${r.userName}</div>
              <div class="room-last">
                <c:choose>
                  <c:when test="${not empty r.lastMsg}">${r.lastMsg}</c:when>
                  <c:otherwise>아직 메시지가 없습니다.</c:otherwise>
                </c:choose>
              </div>
            </div>
            <div class="room-meta">
              <div class="room-time">${r.lastTime}</div>
              <c:choose>
                <c:when test="${r.unreadCnt > 0}">
                  <span class="unread-badge">+${r.unreadCnt}</span>
                </c:when>
                <c:otherwise>
                  <div class="no-unread"></div>
                </c:otherwise>
              </c:choose>
            </div>
          </a>

          <%-- 삭제 버튼 --%>
          <button class="del-btn"
            onclick="deleteRoom(${r.roomNum}, '${r.userName}')">
            🗑️ 삭제
          </button>

        </div>
      </c:forEach>

      <c:if test="${empty roomList}">
        <div style="text-align:center;padding:60px;color:#9ca3af;background:#fff">
          💬 아직 채팅 문의가 없습니다.
        </div>
      </c:if>

    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
function deleteRoom(roomNum, userName) {
    if (!confirm(
        '[' + userName + '] 채팅방을 삭제합니다.\n\n' +
        '모든 대화 내역이 삭제되며 복구할 수 없습니다.\n\n' +
        '계속하시겠습니까?'
    )) return;
    location.href = '${pageContext.request.contextPath}/shop/chat/adminChatDelete.do?roomNum=' + roomNum;
}

// 삭제 완료 토스트
window.onload = function() {
    var params = new URLSearchParams(window.location.search);
    if (params.get('msg') === 'delete_ok') {
        var t = document.getElementById('toast');
        t.textContent = '✅ 채팅방이 삭제되었습니다.';
        t.classList.add('show');
        setTimeout(function() { t.classList.remove('show'); }, 3000);
    }
};
</script>
</body>
</html>
