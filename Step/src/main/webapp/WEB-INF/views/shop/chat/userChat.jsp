<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 고객센터 채팅</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<style>
/* --- 🚨 핵심 디테일 수정: 모든 요소의 테두리/여백을 너비에 포함 --- */
*, *::before, *::after { box-sizing: border-box; }

body {
    font-family: 'Pretendard', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    color: #333;
}

.chat-wrapper {
    max-width: 600px;
    margin: 40px auto;
    padding: 0 16px;
    height: calc(100vh - 140px); /* 헤더 제외 높이 계산 */
    display: flex;
    flex-direction: column;
}

.chat-container {
    flex: 1;
    background: #fff;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
    border: 1px solid #e2e8f0;
    display: flex;
    flex-direction: column;
}

/* --- 상단 헤더 --- */
.chat-hdr {
    background: #111827;
    padding: 18px 24px;
    display: flex;
    align-items: center;
    gap: 14px;
}
.chat-hdr-av {
    width: 44px;
    height: 44px;
    background: #fff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    flex-shrink: 0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}
.chat-hdr-info {
    flex: 1;
}
.chat-hdr-info .title {
    color: #fff;
    font-weight: 700;
    font-size: 16px;
    letter-spacing: -0.3px;
    margin-bottom: 2px;
}
.chat-hdr-info .sub {
    color: #94a3b8;
    font-size: 12.5px;
    font-weight: 400;
}
.chat-hdr-status {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #e2e8f0;
    font-size: 13px;
    font-weight: 600;
}
.status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #10b981;
    animation: pulse 2s infinite;
}
@keyframes pulse {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.5; transform: scale(0.85); }
}

/* --- 채팅 메시지 영역 --- */
.chat-msgs {
    flex: 1;
    overflow-y: auto;
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 18px;
    background: #f8fafc;
}
.chat-msgs::-webkit-scrollbar { width: 6px; }
.chat-msgs::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

.msg-row { display: flex; gap: 12px; align-items: flex-end; }
.msg-row.mine { flex-direction: row-reverse; }

.msg-av {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: 700;
    flex-shrink: 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.av-admin { background: #111827; color: #fff; }
.av-user { background: #fff; color: #475569; border: 1px solid #e2e8f0; }

.msg-group { display: flex; flex-direction: column; gap: 6px; max-width: 75%; }
.msg-group.mine { align-items: flex-end; }

.msg-sender-name { font-size: 12px; font-weight: 600; color: #64748b; padding-left: 2px; }

.msg-bubble {
    padding: 12px 16px;
    border-radius: 14px;
    font-size: 14px;
    line-height: 1.6;
    word-break: break-word;
    white-space: pre-wrap;
    box-shadow: 0 1px 2px rgba(0,0,0,0.03);
}
.bubble-admin {
    background: #fff;
    border: 1px solid #e2e8f0;
    color: #1e293b;
    border-radius: 4px 16px 16px 16px;
}
.bubble-mine {
    background: #3b82f6; /* 고객 화면: 내 말풍선은 파란색으로 통일 */
    color: #fff;
    border-radius: 16px 4px 16px 16px;
}

.msg-meta { display: flex; align-items: center; gap: 6px; padding: 0 2px; }
.msg-time { font-size: 11px; color: #94a3b8; font-family: 'Space Grotesk', sans-serif; font-weight: 500; }
.msg-unread { font-size: 11px; color: #ef4444; font-weight: 700; }

/* 운영시간 공지 */
.chat-notice {
    text-align: center;
    padding: 10px;
    background: #fffbeb;
    border-top: 1px solid #fef08a;
    font-size: 12.5px;
    color: #92400e;
    font-weight: 500;
}

/* --- 하단 입력창 --- */
.chat-inp {
    padding: 16px 20px;
    border-top: 1px solid #e2e8f0;
    background: #fff;
    display: flex;
    gap: 12px;
    align-items: flex-end;
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
    transition: all 0.2s ease;
    background: #f8fafc;
}
.chat-inp textarea:focus { border-color: #3b82f6; background: #fff; }

.send-btn {
    height: 46px; /* 텍스트 에어리어 기본 높이 일치 */
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
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="chat-wrapper">
    <div class="chat-container">

      <div class="chat-hdr">
        <div class="chat-hdr-av">👟</div>
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

      <div class="chat-notice">⏰ 평일 09:00 ~ 18:00 | 주말 및 공휴일 휴무</div>

      <div class="chat-inp">
        <textarea id="msgInput" placeholder="메시지 입력... (Enter: 전송, Shift+Enter: 줄바꿈)" rows="1"></textarea>
        <button class="send-btn" id="sendBtn" onclick="sendMsg()">전송</button>
      </div>

    </div>
</div>

<script>
var ROOM_NUM  = ${roomNum};   
var CTX       = '${pageContext.request.contextPath}';
var lastMsgNum = 0;           

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

if (initMsgs.length > 0) {
    renderMsgs(initMsgs);
}

let isSending = false;

function sendMsg() {
    var input   = document.getElementById('msgInput');
    var content = input.value.trim();
    if (!content || isSending) return; 

    isSending = true;
    document.getElementById('sendBtn').disabled = true;

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
            ROOM_NUM = data.roomNum; 
            loadMsgs();
        }
    })
    .catch(function(e) { console.log('전송 오류:', e); })
    .finally(function() {
        isSending = false; 
        document.getElementById('sendBtn').disabled = false;
    });
}

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