<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 채팅 문의</title>
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
.page-hdr-title { font-size: 24px; font-weight: bold; margin-bottom: 5px; color: #111827; }
.page-hdr-sub { font-size: 14px; color: #666; margin-bottom: 24px; }

/* ──  채팅방 목록 인박스 ── */
.room-list {
    display: flex;
    flex-direction: column;
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.room-item {
    background: #fff;
    padding: 18px 24px;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #f1f5f9;
    transition: all 0.2s ease;
    position: relative;
}
.room-item:last-child { border-bottom: none; }
.room-item:hover { background: #f8fafc; }

/* 안 읽은 메시지가 있을 때 왼쪽 포인트 라인 */
.room-item.has-unread {
    border-left: 4px solid #ef4444;
}
.room-item.has-unread a {
    padding-left: -4px; 
}

/* 프로필 아바타 디테일화 */
.room-av {
    width: 46px;
    height: 46px;
    border-radius: 50%;
    background: #f1f5f9;
    color: #475569;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    flex-shrink: 0;
    border: 1px solid #e2e8f0;
}

.room-info {
    flex: 1;
    min-width: 0;
    padding-right: 20px;
}
.room-name {
    font-weight: 600;
    font-size: 15px;
    color: #111827;
    margin-bottom: 4px;
}
.room-last {
    font-size: 13px;
    color: #64748b;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.room-meta {
    text-align: right;
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 6px;
    margin-right: 15px;
}
.room-time {
    font-size: 12px;
    color: #94a3b8;
    font-family: 'Space Grotesk', sans-serif;
}

/* 알림 배지 모던 스칼렛 레드로 변경 */
.unread-badge {
    background: #ef4444;
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    padding: 3px 9px;
    border-radius: 20px;
    box-shadow: 0 2px 6px rgba(239, 68, 68, 0.3);
}
.no-unread {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #e2e8f0;
}

/* 삭제 버튼 스타일 정밀화 */
.del-btn {
    padding: 8px 14px;
    background: #fef2f2;
    color: #ef4444;
    border: 1px solid #fecaca;
    border-radius: 6px;
    font-size: 12.5px;
    font-weight: 600;
    cursor: pointer;
    white-space: nowrap;
    font-family: inherit;
    flex-shrink: 0;
    transition: all 0.15s ease;
}
.del-btn:hover {
    background: #ef4444;
    color: #fff;
    border-color: #ef4444;
}

/* 상단 알림 메시지 배너 */
.alert-success {
    background: #dcfce7;
    color: #155724;
    padding: 14px 20px;
    border: 1px solid #bbf7d0;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 14px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
}

/*  PAGINATION  */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

/* 토스트 알림 */
.toast {
    position: fixed;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%) translateY(20px);
    background: #111827;
    color: #fff;
    padding: 12px 24px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    opacity: 0;
    transition: all .3s;
    z-index: 9999;
    pointer-events: none;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <c:set var="pageTitle" value="채팅 문의" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <div class="page-hdr-title">채팅 문의 관리</div>
    <div class="page-hdr-sub">고객의 채팅 문의를 확인하고 실시간으로 답변을 제공하세요.</div>

    <%-- 삭제 완료 메시지 --%>
    <c:if test="${param.msg eq 'delete_ok'}">
      <div class="alert-success"><i class="fa-solid fa-circle-check"></i> 채팅방이 안전하게 삭제되었습니다.</div>
    </c:if>

    <div class="room-list" id="chatRoomContainer">

      <c:forEach var="r" items="${roomList}">
        <div class="room-item ${r.unreadCnt > 0 ? 'has-unread' : ''}">

          <%-- 채팅방 클릭 영역 --%>
          <a href="${pageContext.request.contextPath}/shop/chat/adminChatView.do?roomNum=${r.roomNum}"
             style="display:flex;align-items:center;gap:16px;flex:1;text-decoration:none;color:inherit;min-width:0">
            <div class="room-av"><i class="fa-regular fa-user"></i></div>
            <div class="room-info">
              <div class="room-name">${r.userName}</div>
              <div class="room-last">
                <c:choose>
                  <c:when test="${not empty r.lastMsg}">${r.lastMsg}</c:when>
                  <c:otherwise><span style="color:#94a3b8; font-style: italic;">아직 주고받은 메시지가 없습니다.</span></c:otherwise>
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
          <button type="button" class="del-btn" onclick="deleteRoom(${r.roomNum}, '${r.userName}')">
            <i class="fa-regular fa-trash-can"></i> 삭제
          </button>

        </div>
      </c:forEach>

      <c:if test="${empty roomList}">
        <div style="text-align:center; padding:80px 0; color:#94a3b8; background:#fff;">
          <i class="fa-regular fa-comments" style="font-size:36px; display:block; margin-bottom:12px; color:#e2e8f0;"></i>
          아직 인입된 고객 채팅 문의 내역이 존재하지 않습니다.
        </div>
      </c:if>

   
      <div class="pagination-wrap" id="chatPagination" style="display:none;">
        <div class="page-info" id="chatPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="chatPageBtns"></div>
      </div>

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

let currentChatPage = 1;
const chatItemsPerPage = 10; // 한 페이지에 보여줄 채팅방 개수
let allChatItems = [];

window.addEventListener('load', function() {
    // 1. 토스트 메시지 처리
    var params = new URLSearchParams(window.location.search);
    if (params.get('msg') === 'delete_ok') {
        var t = document.getElementById('toast');
        if(t) {
            t.textContent = '✅ 채팅방이 삭제되었습니다.';
            t.classList.add('show');
            setTimeout(function() { t.classList.remove('show'); }, 2800);
        }
    }

    // 2. 페이징 초기화
    const container = document.getElementById('chatRoomContainer');
    if (container) {
        allChatItems = Array.from(container.querySelectorAll('.room-item'));
        if (allChatItems.length > 0) {
            renderChatList();
        } else {
            document.getElementById('chatPagination').style.display = 'none';
        }
    }
});

function renderChatList() {
    allChatItems.forEach(item => item.style.display = 'none');
    const start = (currentChatPage - 1) * chatItemsPerPage;
    const end = start + chatItemsPerPage;
    
    for (let i = start; i < end && i < allChatItems.length; i++) {
        allChatItems[i].style.display = ''; 
    }
    renderChatPagination();
}

function renderChatPagination() {
    const totalPages = Math.ceil(allChatItems.length / chatItemsPerPage);
    const pw = document.getElementById('chatPagination');
    const pi = document.getElementById('chatPageInfo');
    const pb = document.getElementById('chatPageBtns');

    if (!pw || !pb) return;

    if (allChatItems.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentChatPage - 1) * chatItemsPerPage + 1;
    const en = Math.min(currentChatPage * chatItemsPerPage, allChatItems.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allChatItems.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentChatPage === 1 ? 'disabled' : ''}" onclick="changeChatPage(\${currentChatPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentChatPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentChatPage ? 'on' : ''}" onclick="changeChatPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentChatPage === totalPages ? 'disabled' : ''}" onclick="changeChatPage(\${currentChatPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeChatPage(p) {
    const totalPages = Math.ceil(allChatItems.length / chatItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentChatPage = p;
    renderChatList();
}
</script>
</body>
</html>