<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>채팅 답변</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;background:var(--black);flex-shrink:0}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff}
.topbar-back{color:rgba(255,255,255,0.6);font-size:12px;text-decoration:none;margin-right:14px;transition:color .15s}
.topbar-back:hover{color:#fff}

.chat-container{flex:1;display:flex;flex-direction:column;overflow:hidden;padding:20px}
.chat-box{flex:1;display:flex;flex-direction:column;border:1px solid var(--border);border-radius:8px;overflow:hidden;background:#fff}

.chat-msgs{flex:1;overflow-y:auto;padding:20px;display:flex;flex-direction:column;gap:14px;background:#f9fafb}
.chat-msgs::-webkit-scrollbar{width:4px}
.chat-msgs::-webkit-scrollbar-thumb{background:#d1d5db;border-radius:2px}

.msg-row{display:flex;gap:8px;align-items:flex-end}
.msg-row.mine{flex-direction:row-reverse}
.msg-av{width:34px;height:34px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0}
.av-admin{background:#111;color:#fff}
.av-user{background:#e5e7eb;color:#374151}
.msg-group{display:flex;flex-direction:column;gap:4px;max-width:70%}
.msg-group.mine{align-items:flex-end}
.msg-sender-name{font-size:11px;color:#9ca3af;margin-bottom:2px;padding-left:2px}
.msg-bubble{padding:11px 15px;border-radius:12px;font-size:14px;line-height:1.7;word-break:break-word;white-space:pre-wrap}
.bubble-mine{background:#111;color:#fff;border-radius:12px 4px 12px 12px}
.bubble-user{background:#fff;border:1px solid #e5e7eb;color:#111;border-radius:4px 12px 12px 12px}
.msg-meta{display:flex;align-items:center;gap:5px}
.msg-time{font-size:10px;color:#9ca3af}
.msg-unread{font-size:10px;color:#f59e0b;font-weight:700} /* 읽지않음 표시 */

.chat-inp{padding:14px 18px;border-top:1px solid #e5e7eb;background:#fff;display:flex;gap:10px;align-items:flex-end;flex-shrink:0}
.chat-inp textarea{flex:1;padding:10px 14px;border:1.5px solid #e5e7eb;border-radius:8px;font-size:14px;font-family:'Noto Sans KR',sans-serif;outline:none;resize:none;max-height:120px;line-height:1.5;transition:border .15s}
.chat-inp textarea:focus{border-color:#111}
.send-btn{padding:10px 20px;background:#111;color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:700;cursor:pointer;white-space:nowrap;font-family:'Noto Sans KR',sans-serif;transition:background .15s}
.send-btn:hover{background:#374151}
.send-btn:disabled{background:#9ca3af;cursor:not-allowed}
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="topbar">
    <a href="${pageContext.request.contextPath}/shop/chat/adminChatList.do" class="topbar-back">← 목록으로</a>
    <div class="topbar-title">채팅 답변</div>
  </div>

  <div class="chat-container">
    <div class="chat-box">
      <div class="chat-msgs" id="chatMsgs">
        <c:if test="${empty msgList}">
          <div id="emptyMsg" style="text-align:center;padding:40px;color:#9ca3af">
            아직 메시지가 없습니다.
          </div>
        </c:if>
      </div>
      <div class="chat-inp">
        <textarea id="msgInput" placeholder="답변을 입력하세요... (Enter: 전송, Shift+Enter: 줄바꿈)" rows="1"></textarea>
        <button class="send-btn" id="sendBtn" onclick="sendMsg()">전송</button>
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
    var avText   = isMine ? '관' : '👤';
    var bubbleClass = isMine ? 'msg-bubble bubble-mine' : 'msg-bubble bubble-user';
    var groupClass  = isMine ? 'msg-group mine' : 'msg-group';

    // 내가 보낸 메시지이고 아직 읽지 않았으면 표시
    var readMark = '';
    if (isMine && m.isRead == 0) {
        readMark = '<span class="msg-unread">읽지않음</span>';
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
        container.innerHTML = '<div id="emptyMsg" style="text-align:center;padding:40px;color:#9ca3af">아직 메시지가 없습니다.</div>';
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

    // 낙관적 UI: 즉시 화면에 표시
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
    input.style.height = 'auto';

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
