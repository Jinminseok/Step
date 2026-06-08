<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 채팅 답변</title>
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
    overflow-y: hidden; 
}

.main {
    margin-left: 260px;
    padding: 30px;
    box-sizing: border-box;
    height: 100vh;
    display: flex;
    flex-direction: column;
}

.topbar-back-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    font-weight: 600;
    color: #64748b;
    text-decoration: none;
    transition: color 0.2s ease;
    margin-right: 15px;
}
.topbar-back-btn:hover { color: #0f172a; }

/* --- 💬 채팅 레이아웃 --- */
.chat-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    margin-top: 10px; /* 서브 타이틀 밑 여백 */
}

.chat-box {
    flex: 1;
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    background: #fff;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
}

/* 채팅 메시지 영역 */
.chat-msgs {
    flex: 1;
    overflow-y: auto;
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    background: #f8fafc;
}
.chat-msgs::-webkit-scrollbar { width: 6px; }
.chat-msgs::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

/* 개별 메시지 행 */
.msg-row { display: flex; gap: 12px; align-items: flex-end; }
.msg-row.mine { flex-direction: row-reverse; }

/* 프로필 아이콘 */
.msg-av {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 700;
    flex-shrink: 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.av-admin { background: #111827; color: #fff; }
.av-user { background: #fff; color: #475569; border: 1px solid #e2e8f0; }

/* 말풍선 그룹 */
.msg-group { display: flex; flex-direction: column; gap: 6px; max-width: 75%; }
.msg-group.mine { align-items: flex-end; }

.msg-sender-name { font-size: 12px; font-weight: 600; color: #64748b; padding-left: 2px; }

/* 말풍선 디자인 */
.msg-bubble {
    padding: 12px 16px;
    border-radius: 14px;
    font-size: 14px;
    line-height: 1.6;
    word-break: break-word;
    white-space: pre-wrap;
    box-shadow: 0 1px 2px rgba(0,0,0,0.03);
}
.bubble-mine {
    background: #111827; 
    color: #fff;
    border-radius: 16px 4px 16px 16px;
}
.bubble-user {
    background: #fff;
    border: 1px solid #e2e8f0;
    color: #1e293b;
    border-radius: 4px 16px 16px 16px;
}

/* 시간 및 읽음표시 */
.msg-meta { display: flex; align-items: center; gap: 6px; padding: 0 2px; }
.msg-time { font-size: 11px; color: #94a3b8; font-family: 'Space Grotesk', sans-serif; font-weight: 500; }
.msg-unread { font-size: 11px; color: #ef4444; font-weight: 700; letter-spacing: -0.5px; }

/* --- 하단 입력창 --- */
.chat-inp {
    padding: 16px 24px;
    border-top: 1px solid #e2e8f0;
    background: #fff;
    display: flex;
    gap: 12px;
    align-items: flex-end;
    flex-shrink: 0;
}
.chat-inp textarea {
    flex: 1;
    padding: 12px 16px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    font-family: inherit;
    outline: none;
    resize: none;
    max-height: 120px;
    line-height: 1.5;
    transition: border 0.2s;
    background: #f8fafc;
}
.chat-inp textarea:focus { border-color: #3b82f6; background: #fff; }

.send-btn {
    height: 46px; 
    padding: 0 24px;
    background: #111827;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    white-space: nowrap;
    font-family: inherit;
    transition: background 0.2s ease;
}
.send-btn:hover { background: #374151; }
.send-btn:disabled { background: #cbd5e1; cursor: not-allowed; }
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
    <c:set var="pageTitle" value="채팅 답변" scope="request" />
    <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div style="margin-top: -15px;">
      <a href="${pageContext.request.contextPath}/shop/chat/adminChatList.do" class="topbar-back-btn">
          <i class="fa-solid fa-arrow-left"></i> 목록으로 돌아가기
      </a>
  </div>

  <div class="chat-container">
    <div class="chat-box">
      <div class="chat-msgs" id="chatMsgs">
        <c:if test="${empty msgList}">
          <div id="emptyMsg" style="text-align:center; padding:60px 0; color:#94a3b8;">
            <i class="fa-regular fa-comment-dots" style="font-size:36px; display:block; margin-bottom:12px; color:#cbd5e1;"></i>
            아직 주고받은 메시지가 없습니다.
          </div>
        </c:if>
      </div>
      <div class="chat-inp">
        <textarea id="msgInput" placeholder="답변을 입력하세요... (Enter: 전송, Shift+Enter: 줄바꿈)" rows="1"></textarea>
        <button class="send-btn" id="sendBtn" onclick="sendMsg()"><i class="fa-regular fa-paper-plane" style="margin-right:4px;"></i> 전송</button>
      </div>
    </div>
  </div>
</div>

<script>
var ROOM_NUM = ${roomNum};
var CTX      = '${pageContext.request.contextPath}';

// 초기 메시지 (JSP에서 서버 데이터)
var initMsgs = [
<c:forEach var="m" items="${msgList}" varStatus="st">
    {
        msgNum:    ${m.msgNum},
        msgSender: ${m.msgSender},
        senderName:"<c:out value='${m.senderName}'/>",
        msgContent:"<c:out value='${m.msgContent}'/>",
        msgTime:   "${m.msgTime}",
        isRead:    ${m.isRead}
    }<c:if test="${!st.last}">,</c:if>
</c:forEach>
];

function escapeHtml(text) {
    return text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function buildMsgHtml(m) {
    var isMine  = (m.msgSender == 2); // 관리자(2)가 나
    var rowClass = isMine ? 'msg-row mine' : 'msg-row';
    var avClass  = isMine ? 'msg-av av-admin' : 'msg-av av-user';
    var avText   = isMine ? '<i class="fa-solid fa-headset"></i>' : '<i class="fa-regular fa-user"></i>';
    var bubbleClass = isMine ? 'msg-bubble bubble-mine' : 'msg-bubble bubble-user';
    var groupClass  = isMine ? 'msg-group mine' : 'msg-group';

    // 내가 보낸 메시지이고 아직 읽지 않았으면 표시
    var readMark = '';
    if (isMine && m.isRead == 0) {
        readMark = '<span class="msg-unread">1</span>';
    }

    var html = '<div class="' + rowClass + '" data-msg-num="' + m.msgNum + '">';
    html += '<div class="' + avClass + '">' + avText + '</div>';
    html += '<div class="' + groupClass + '">';
    if (!isMine) {
        html += '<div class="msg-sender-name">' + escapeHtml(m.senderName) + '</div>';
    }
    html += '<div class="' + bubbleClass + '">' + escapeHtml(m.msgContent) + '</div>';
    html += '<div class="msg-meta">';
    html += readMark;
    html += '<span class="msg-time">' + m.msgTime + '</span>';
    html += '</div>';
    html += '</div></div>';
    return html;
}

function renderMsgs(msgs) {
    var container = document.getElementById('chatMsgs');
    var emptyMsg  = document.getElementById('emptyMsg');
    container.innerHTML = '';

    if (!msgs || msgs.length === 0) {
        container.innerHTML = '<div id="emptyMsg" style="text-align:center; padding:60px 0; color:#94a3b8;"><i class="fa-regular fa-comment-dots" style="font-size:36px; display:block; margin-bottom:12px; color:#cbd5e1;"></i>아직 주고받은 메시지가 없습니다.</div>';
        return;
    }

    msgs.forEach(function(m) {
        container.insertAdjacentHTML('beforeend', buildMsgHtml(m));
    });
    scrollBottom();
}

function scrollBottom() {
    var el = document.getElementById('chatMsgs');
    el.scrollTop = el.scrollHeight;
}

// 초기 메시지 렌더링
renderMsgs(initMsgs);

// 메시지 전송
function sendMsg() {
    var input   = document.getElementById('msgInput');
    var content = input.value.trim();
    if (!content) return;

    document.getElementById('sendBtn').disabled = true;

    var tempMsg = {
        msgNum: -1,
        msgSender: 2,
        senderName: '관리자',
        msgContent: content,
        msgTime: new Date().toTimeString().slice(0,5),
        isRead: 0
    };
    document.getElementById('chatMsgs').insertAdjacentHTML('beforeend', buildMsgHtml(tempMsg));
    scrollBottom();
    input.value = '';
    input.style.height = 'auto'; // 입력창 높이 초기화

    fetch(CTX + '/shop/chat/chatSend.do', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
        body: 'roomNum=' + ROOM_NUM + '&content=' + encodeURIComponent(content) + '&senderType=2'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.result === 'ok') {
            loadMsgs(); // 서버 데이터로 정확하게 갱신
        }
        document.getElementById('sendBtn').disabled = false;
    })
    .catch(function() {
        document.getElementById('sendBtn').disabled = false;
    });
}

// JSON으로 메시지 목록 가져오기 (senderType=2: 관리자가 읽으므로 사용자 메시지 읽음처리)
function loadMsgs() {
    fetch(CTX + '/shop/chat/chatMsgList.do?roomNum=' + ROOM_NUM + '&senderType=2')
    .then(function(res) { return res.json(); })
    .then(function(msgs) {
        renderMsgs(msgs);
    })
    .catch(function(e) { console.log('폴링 오류:', e); });
}

// 3초마다 폴링
setInterval(loadMsgs, 3000);

document.getElementById('msgInput').addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMsg(); }
});
document.getElementById('msgInput').addEventListener('input', function() {
    this.style.height = 'auto';
    this.style.height = Math.min(this.scrollHeight, 120) + 'px';
});
</script>
</body>
</html>