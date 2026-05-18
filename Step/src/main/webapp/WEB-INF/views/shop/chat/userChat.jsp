<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 채팅 문의</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<style>
.chat-wrap{max-width:760px;margin:32px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);border:1px solid #e5e7eb}
.chat-hdr{background:#111;padding:16px 22px;display:flex;align-items:center;gap:12px}
.chat-hdr-av{width:42px;height:42px;background:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.chat-hdr-info .title{color:#fff;font-weight:700;font-size:16px}
.chat-hdr-info .sub{color:rgba(255,255,255,0.5);font-size:13px;margin-top:2px}
.chat-hdr-status{margin-left:auto;display:flex;align-items:center;gap:6px;color:rgba(255,255,255,0.7);font-size:13px}
.status-dot{width:8px;height:8px;border-radius:50%;background:#4ade80;animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:0.4}}

.chat-msgs{height:460px;overflow-y:auto;padding:20px;display:flex;flex-direction:column;gap:16px;background:#f9fafb}
.chat-msgs::-webkit-scrollbar{width:4px}
.chat-msgs::-webkit-scrollbar-thumb{background:#d1d5db;border-radius:2px}

.msg-row{display:flex;gap:10px;align-items:flex-end}
.msg-row.mine{flex-direction:row-reverse}
.msg-av{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0}
.av-admin{background:#111;color:#fff}
.av-user{background:#e5e7eb;color:#374151}
.msg-group{display:flex;flex-direction:column;gap:4px;max-width:70%}
.msg-group.mine{align-items:flex-end}
.msg-sender-name{font-size:12px;color:#9ca3af;margin-bottom:2px;padding-left:2px}
.msg-bubble{padding:12px 16px;border-radius:12px;font-size:15px;line-height:1.7;word-break:break-word;white-space:pre-wrap}
.bubble-admin{background:#fff;border:1px solid #e5e7eb;color:#111;border-radius:4px 12px 12px 12px}
.bubble-mine{background:#111;color:#fff;border-radius:12px 4px 12px 12px}
.msg-meta{display:flex;align-items:center;gap:5px}
.msg-time{font-size:11px;color:#9ca3af}
.msg-unread{font-size:10px;color:#f59e0b;font-weight:700} /* 읽지않음 표시 */

.chat-notice{text-align:center;padding:10px;background:#fffbeb;border-top:1px solid #fde68a;font-size:13px;color:#92400e}
.chat-inp{padding:16px 18px;border-top:1px solid #e5e7eb;background:#fff;display:flex;gap:10px;align-items:flex-end}
.chat-inp textarea{flex:1;padding:12px 16px;border:1.5px solid #e5e7eb;border-radius:8px;font-size:15px;font-family:'Noto Sans KR',sans-serif;outline:none;resize:none;max-height:120px;line-height:1.6;transition:border .15s}
.chat-inp textarea:focus{border-color:#111}
.send-btn{padding:12px 22px;background:#111;color:#fff;border:none;border-radius:8px;font-size:15px;font-weight:700;cursor:pointer;white-space:nowrap;font-family:'Noto Sans KR',sans-serif;transition:background .15s}
.send-btn:hover{background:#374151}
.send-btn:disabled{background:#9ca3af;cursor:not-allowed}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div style="padding:24px 0">
<div class="chat-wrap">

  <div class="chat-hdr">
    <div class="chat-hdr-av">🛒</div>
    <div class="chat-hdr-info">
      <div class="title">ShoeMall 고객센터</div>
      <div class="sub">궁금하신 점을 편하게 남겨주세요!</div>
    </div>
    <div class="chat-hdr-status">
      <div class="status-dot"></div>
      운영중
    </div>
  </div>

  <div class="chat-msgs" id="chatMsgs">
    <%-- 초기 안내 메시지 --%>
    <div class="msg-row" id="welcomeMsg">
      <div class="msg-av av-admin">CS</div>
      <div class="msg-group">
        <div class="msg-sender-name">ShoeMall 고객센터</div>
        <div class="msg-bubble bubble-admin">안녕하세요! 👋<br>주문, 배송, 반품 등 궁금하신 점을 편하게 말씀해 주세요.</div>
      </div>
    </div>
  </div>

  <div class="chat-notice">⏰ 운영시간: 평일 09:00 ~ 18:00 | 주말/공휴일 휴무</div>

  <div class="chat-inp">
    <textarea id="msgInput" placeholder="메시지 입력... (Enter: 전송, Shift+Enter: 줄바꿈)" rows="1"></textarea>
    <button class="send-btn" id="sendBtn" onclick="sendMsg()">전송</button>
  </div>

</div>
</div>

<script>
var ROOM_NUM  = ${roomNum};   // -1이면 아직 방 없음
var CTX       = '${pageContext.request.contextPath}';
var lastMsgNum = 0;           // 마지막으로 받은 메시지 번호

// 페이지 로드 시 기존 메시지 렌더링
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
    var isMine = (m.msgSender == 1);
    var rowClass = isMine ? 'msg-row mine' : 'msg-row';
    var avClass  = isMine ? 'msg-av av-user' : 'msg-av av-admin';
    var avText   = isMine ? '나' : 'CS';
    var bubbleClass = isMine ? 'msg-bubble bubble-mine' : 'msg-bubble bubble-admin';
    var groupClass  = isMine ? 'msg-group mine' : 'msg-group';

    var readMark = '';
    // 내가 보낸 메시지(1=사용자)이고 아직 읽지 않았으면 표시
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
    // 안내 메시지는 유지하고 나머지 삭제
    var welcome = document.getElementById('welcomeMsg');
    container.innerHTML = '';
    if (welcome) container.appendChild(welcome);

    msgs.forEach(function(m) {
        container.insertAdjacentHTML('beforeend', buildMsgHtml(m));
        if (m.msgNum > lastMsgNum) lastMsgNum = m.msgNum;
    });
    scrollBottom();
}

function scrollBottom() {
    var el = document.getElementById('chatMsgs');
    el.scrollTop = el.scrollHeight;
}

// 초기 메시지 렌더링
if (initMsgs.length > 0) {
    renderMsgs(initMsgs);
}

// 메시지 전송
function sendMsg() {
    var input   = document.getElementById('msgInput');
    var content = input.value.trim();
    if (!content) return;

    document.getElementById('sendBtn').disabled = true;

    // 낙관적 UI: 전송 즉시 화면에 표시
    var tempMsg = {
        msgNum: -1,
        msgSender: 1,
        senderName: '나',
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
        body: 'roomNum=' + ROOM_NUM + '&content=' + encodeURIComponent(content) + '&senderType=1'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.result === 'ok') {
            ROOM_NUM = data.roomNum; // 첫 메시지면 방 번호 저장
            loadMsgs();             // 서버에서 정확한 메시지 목록 로드
        }
        document.getElementById('sendBtn').disabled = false;
    })
    .catch(function() {
        document.getElementById('sendBtn').disabled = false;
    });
}

// JSON으로 메시지 목록 가져오기
function loadMsgs() {
    if (ROOM_NUM <= 0) return;
    fetch(CTX + '/shop/chat/chatMsgList.do?roomNum=' + ROOM_NUM + '&senderType=1')
    .then(function(res) { return res.json(); })
    .then(function(msgs) {
        if (msgs && msgs.length > 0) {
            renderMsgs(msgs);
        }
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
