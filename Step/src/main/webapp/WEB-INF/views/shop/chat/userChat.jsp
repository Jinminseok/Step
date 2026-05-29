<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 고객센터 채팅</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
*,*::before,*::after{box-sizing:border-box}

body{
  background:#f2f3f5;
  font-family:'Noto Sans KR',sans-serif;
  color:#111;
  margin:0;
}

/* ── 전체 페이지 래퍼 ── */
.chat-page{
  max-width:780px;
  margin:0 auto;
  padding:32px 20px 60px;
  height:calc(100vh - 60px);
  display:flex;
  flex-direction:column;
  gap:0;
}

/* ── 채팅 카드 ── */
.chat-card{
  flex:1;
  background:#fff;
  border-radius:16px;
  border:1px solid #e4e6ea;
  box-shadow:0 4px 24px rgba(0,0,0,.07);
  display:flex;
  flex-direction:column;
  overflow:hidden;
  min-height:0;
}

/* ── 헤더 ── */
.chat-hdr{
  background:#0d0d0d;
  padding:18px 24px;
  display:flex;
  align-items:center;
  gap:14px;
  flex-shrink:0;
}
.chat-hdr-av{
  width:44px;height:44px;
  background:#1a6ef5;
  border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:20px;flex-shrink:0;
}
.chat-hdr-info{flex:1}
.chat-hdr-info .title{
  color:#fff;font-weight:700;font-size:15px;
  letter-spacing:-0.3px;margin-bottom:2px;
}
.chat-hdr-info .sub{
  color:rgba(255,255,255,.45);font-size:12px;
}
.chat-hdr-status{
  display:flex;align-items:center;gap:6px;
  background:rgba(16,185,129,.12);
  border:1px solid rgba(16,185,129,.25);
  border-radius:20px;
  padding:5px 12px;
  font-size:12px;font-weight:600;color:#34d399;
}
.status-dot{
  width:7px;height:7px;border-radius:50%;
  background:#10b981;
  animation:pulse 2s infinite;
}
@keyframes pulse{
  0%,100%{opacity:1;transform:scale(1)}
  50%{opacity:.5;transform:scale(.8)}
}

/* ── 메시지 영역 ── */
.chat-msgs{
  flex:1;
  overflow-y:auto;
  padding:24px 20px;
  display:flex;flex-direction:column;gap:20px;
  background:#f8f9fb;
  min-height:0;
}
.chat-msgs::-webkit-scrollbar{width:4px}
.chat-msgs::-webkit-scrollbar-thumb{background:#d1d5db;border-radius:2px}

/* 날짜 구분선 */
.chat-date-divider{
  text-align:center;font-size:11px;color:#bbb;
  display:flex;align-items:center;gap:10px;
  margin:4px 0;
}
.chat-date-divider::before,.chat-date-divider::after{
  content:'';flex:1;height:1px;background:#ebebeb;
}

/* 메시지 행 */
.msg-row{display:flex;gap:10px;align-items:flex-end}
.msg-row.mine{flex-direction:row-reverse}

/* 아바타 */
.msg-av{
  width:36px;height:36px;border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:13px;font-weight:700;flex-shrink:0;
}
.av-admin{background:#0d0d0d;color:#fff}
.av-user{background:#e8edf2;color:#555;border:1px solid #ddd}

/* 말풍선 그룹 */
.msg-group{display:flex;flex-direction:column;gap:4px;max-width:72%}
.msg-group.mine{align-items:flex-end}
.msg-sender-name{font-size:11px;font-weight:600;color:#94a3b8;padding-left:2px;margin-bottom:2px}

/* 말풍선 */
.msg-bubble{
  padding:11px 15px;font-size:14px;
  line-height:1.65;word-break:break-word;white-space:pre-wrap;
}
.bubble-admin{
  background:#fff;border:1px solid #e4e6ea;
  color:#1e293b;border-radius:4px 14px 14px 14px;
  box-shadow:0 1px 3px rgba(0,0,0,.04);
}
.bubble-mine{
  background:#1a6ef5;color:#fff;
  border-radius:14px 4px 14px 14px;
}

/* 메타(시간/읽음) */
.msg-meta{display:flex;align-items:center;gap:5px;padding:0 2px}
.msg-time{font-size:10px;color:#b0b8c4;font-family:'Space Grotesk',sans-serif}
.msg-unread{font-size:10px;color:#1a6ef5;font-weight:700}

/* ── 운영시간 공지 ── */
.chat-notice{
  display:flex;align-items:center;justify-content:center;gap:6px;
  padding:9px 20px;
  background:#fffbea;border-top:1px solid #fde68a;
  font-size:12px;color:#92400e;font-weight:500;
  flex-shrink:0;
}

/* ── 입력창 ── */
.chat-inp{
  padding:14px 18px;
  border-top:1px solid #eee;
  background:#fff;
  display:flex;gap:10px;align-items:flex-end;
  flex-shrink:0;
}
.chat-inp textarea{
  flex:1;padding:11px 14px;
  border:1.5px solid #e4e6ea;border-radius:10px;
  font-size:14px;font-family:inherit;
  outline:none;resize:none;
  max-height:110px;line-height:1.5;
  transition:border-color .18s,background .18s;
  background:#f8f9fb;color:#111;
}
.chat-inp textarea:focus{border-color:#1a6ef5;background:#fff}
.chat-inp textarea::placeholder{color:#bbb}
.send-btn{
  height:44px;padding:0 22px;
  background:#0d0d0d;color:#fff;
  border:none;border-radius:10px;
  font-size:14px;font-weight:700;
  cursor:pointer;white-space:nowrap;
  font-family:inherit;
  transition:background .15s,transform .1s;
  flex-shrink:0;
}
.send-btn:hover{background:#1a6ef5}
.send-btn:active{transform:scale(.97)}
.send-btn:disabled{background:#ccc;cursor:not-allowed;transform:none}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="chat-page">
  <div class="chat-card">

    <%-- 헤더 --%>
    <div class="chat-hdr">
      <div class="chat-hdr-av">👟</div>
      <div class="chat-hdr-info">
        <div class="title">ShoeMall 고객센터</div>
        <div class="sub">주문 · 배송 · 반품 등 무엇이든 물어보세요</div>
      </div>
      <div class="chat-hdr-status">
        <div class="status-dot"></div>
        운영중
      </div>
    </div>

    <%-- 메시지 영역 --%>
    <div class="chat-msgs" id="chatMsgs">
      <div class="msg-row" id="welcomeMsg">
        <div class="msg-av av-admin">CS</div>
        <div class="msg-group">
          <div class="msg-sender-name">ShoeMall 고객센터</div>
          <div class="msg-bubble bubble-admin">안녕하세요! 👋<br>주문, 배송, 반품 등 궁금하신 점을 편하게 말씀해 주세요.</div>
        </div>
      </div>
    </div>

    <%-- 운영시간 --%>
    <div class="chat-notice">
      ⏰ 평일 09:00 ~ 18:00 &nbsp;|&nbsp; 주말 및 공휴일 휴무
    </div>

    <%-- 입력창 --%>
    <div class="chat-inp">
      <textarea id="msgInput" placeholder="메시지 입력... (Enter: 전송, Shift+Enter: 줄바꿈)" rows="1"></textarea>
      <button class="send-btn" id="sendBtn" onclick="sendMsg()">전송</button>
    </div>

  </div>
</div>

<%-- ── JS: 기능 동일 ── --%>
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
    return text.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function buildMsgHtml(m) {
    var isMine      = (m.msgSender == 1);
    var rowClass    = isMine ? 'msg-row mine' : 'msg-row';
    var avClass     = isMine ? 'msg-av av-user' : 'msg-av av-admin';
    var avText      = isMine ? '나' : 'CS';
    var bubbleClass = isMine ? 'msg-bubble bubble-mine' : 'msg-bubble bubble-admin';
    var groupClass  = isMine ? 'msg-group mine' : 'msg-group';
    var readMark    = (isMine && m.isRead == 0) ? '<span class="msg-unread">1</span>' : '';

    var html = '<div class="' + rowClass + '" data-msg-num="' + m.msgNum + '">';
    html += '<div class="' + avClass + '">' + avText + '</div>';
    html += '<div class="' + groupClass + '">';
    if (!isMine) html += '<div class="msg-sender-name">' + escapeHtml(m.senderName) + '</div>';
    html += '<div class="' + bubbleClass + '">' + escapeHtml(m.msgContent) + '</div>';
    html += '<div class="msg-meta">' + readMark + '<span class="msg-time">' + m.msgTime + '</span></div>';
    html += '</div></div>';
    return html;
}

function renderMsgs(msgs) {
    var container = document.getElementById('chatMsgs');
    var welcome   = document.getElementById('welcomeMsg');
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

if (initMsgs.length > 0) renderMsgs(initMsgs);

var isSending = false;

function sendMsg() {
    var input   = document.getElementById('msgInput');
    var content = input.value.trim();
    if (!content || isSending) return;

    isSending = true;
    document.getElementById('sendBtn').disabled = true;

    var tempMsg = { msgNum:-1, msgSender:1, senderName:'나', msgContent:content,
                    msgTime:new Date().toTimeString().slice(0,5), isRead:0 };
    document.getElementById('chatMsgs').insertAdjacentHTML('beforeend', buildMsgHtml(tempMsg));
    scrollBottom();
    input.value = ''; input.style.height = 'auto';

    fetch(CTX + '/shop/chat/chatSend.do', {
        method:'POST',
        headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'},
        body:'roomNum=' + ROOM_NUM + '&content=' + encodeURIComponent(content) + '&senderType=1'
    })
    .then(function(r){ return r.json(); })
    .then(function(d){ if(d.result==='ok'){ ROOM_NUM=d.roomNum; loadMsgs(); } })
    .catch(function(e){ console.log('전송 오류:',e); })
    .finally(function(){ isSending=false; document.getElementById('sendBtn').disabled=false; });
}

function loadMsgs() {
    if (ROOM_NUM <= 0) return;
    fetch(CTX + '/shop/chat/chatMsgList.do?roomNum=' + ROOM_NUM + '&senderType=1')
    .then(function(r){ return r.json(); })
    .then(function(msgs){ if(msgs && msgs.length > 0) renderMsgs(msgs); })
    .catch(function(e){ console.log('폴링 오류:',e); });
}

setInterval(loadMsgs, 3000);

document.getElementById('msgInput').addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMsg(); }
});
document.getElementById('msgInput').addEventListener('input', function() {
    this.style.height = 'auto';
    this.style.height = Math.min(this.scrollHeight, 110) + 'px';
});
</script>
</body>
</html>
