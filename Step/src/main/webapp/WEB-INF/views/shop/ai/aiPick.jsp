<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - AI 신발 추천</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<style>
.ai-chat-wrap {
    max-width: 760px;
    margin: 0 auto;
}
.ai-chat-box {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 24px rgba(0,0,0,0.07);
}
.ai-chat-hdr {
    background: #111;
    padding: 18px 24px;
    display: flex;
    align-items: center;
    gap: 12px;
}
.ai-chat-hdr-av {
    width: 40px; height: 40px;
    background: #fff;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-weight: 900; font-size: 14px; color: #111;
}
.ai-chat-hdr-info .title { color: #fff; font-weight: 700; font-size: 15px; }
.ai-chat-hdr-info .sub   { color: rgba(255,255,255,0.5); font-size: 12px; margin-top: 2px; }
.ai-chat-hdr-reset {
    margin-left: auto;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: rgba(255,255,255,0.7);
    border-radius: 6px;
    padding: 6px 12px;
    font-size: 12px;
    cursor: pointer;
    text-decoration: none;
    transition: all 0.15s;
}
.ai-chat-hdr-reset:hover { background: rgba(255,255,255,0.2); color: #fff; }

.ai-msgs-area {
    height: 460px;
    overflow-y: auto;
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    background: #f9fafb;
}
.ai-msgs-area::-webkit-scrollbar { width: 4px; }
.ai-msgs-area::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 2px; }

.msg-row { display: flex; gap: 10px; align-items: flex-start; }
.msg-row.user-row { flex-direction: row-reverse; }

.msg-av {
    width: 32px; height: 32px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 12px; font-weight: 700; flex-shrink: 0;
}
.bot-av  { background: #111; color: #fff; }
.user-av { background: #e5e7eb; color: #374151; }

.msg-bubble {
    max-width: 72%;
    padding: 12px 16px;
    border-radius: 12px;
    font-size: 14px;
    line-height: 1.7;
    white-space: pre-wrap;
    word-break: break-word;
}
.bot-bubble  { background: #fff; border: 1px solid #e5e7eb; color: #111; border-radius: 4px 12px 12px 12px; }
.user-bubble { background: #111; color: #fff; border-radius: 12px 4px 12px 12px; }

.ai-inp-area {
    padding: 16px 24px;
    border-top: 1px solid #e5e7eb;
    background: #fff;
    display: flex;
    gap: 10px;
}
.ai-inp-area input {
    flex: 1;
    padding: 12px 16px;
    border: 1.5px solid #e5e7eb;
    border-radius: 8px;
    font-size: 14px;
    font-family: 'Noto Sans KR', sans-serif;
    outline: none;
    transition: border 0.15s;
}
.ai-inp-area input:focus { border-color: #111; }
.ai-inp-area button {
    padding: 12px 24px;
    background: #111;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    font-family: 'Noto Sans KR', sans-serif;
    transition: background 0.15s;
    white-space: nowrap;
}
.ai-inp-area button:hover { background: #374151; }
.ai-inp-area button:disabled { background: #9ca3af; cursor: not-allowed; }

.loading-dot {
    display: inline-block;
    width: 6px; height: 6px;
    background: #9ca3af;
    border-radius: 50%;
    animation: blink 1.2s infinite;
}
.loading-dot:nth-child(2) { animation-delay: 0.2s; }
.loading-dot:nth-child(3) { animation-delay: 0.4s; }
@keyframes blink { 0%,80%,100%{opacity:0} 40%{opacity:1} }

.guide-chips {
    display: flex; flex-wrap: wrap; gap: 8px;
    padding: 0 24px 16px;
    background: #fff;
    border-top: 1px solid #f3f4f6;
}
.guide-chip {
    padding: 6px 14px;
    background: #f3f4f6;
    border: 1px solid #e5e7eb;
    border-radius: 20px;
    font-size: 12px;
    color: #374151;
    cursor: pointer;
    transition: all 0.15s;
}
.guide-chip:hover { background: #111; color: #fff; border-color: #111; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div style="display:flex; align-items:center; gap:16px; margin-bottom:24px;">
            <div class="page-title" style="margin-bottom:0; font-size:24px;">🤖 AI 신발 추천</div>
            <div style="font-size:13px; color:#9ca3af;">현재 판매 중인 상품 기반으로 추천해드립니다</div>
        </div>

        <div class="ai-chat-wrap">
            <div class="ai-chat-box">

                <%-- 헤더 --%>
                <div class="ai-chat-hdr">
                    <div class="ai-chat-hdr-av">AI</div>
                    <div class="ai-chat-hdr-info">
                        <div class="title">ShoeMall AI 어시스턴트</div>
                        <div class="sub">용도 · 예산 · 스타일 등 자유롭게 물어보세요</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/shop/ai/aiPick.do?reset=true" class="ai-chat-hdr-reset">🔄 대화 초기화</a>
                </div>

                <%-- 메시지 영역 --%>
                <div class="ai-msgs-area" id="msgArea">

                    <%-- 첫 인사말 --%>
                    <div class="msg-row">
                        <div class="msg-av bot-av">AI</div>
                        <div class="msg-bubble bot-bubble">
                            안녕하세요! 👟 ShoeMall AI 어시스턴트입니다.<br><br>
                            어떤 신발을 찾고 계세요? 용도, 예산, 사이즈, 선호 스타일 등을 자유롭게 말씀해주시면 현재 판매 중인 상품 중에서 딱 맞는 걸 추천해드릴게요!
                        </div>
                    </div>

                    <%-- 대화 기록 출력 --%>
                    <c:if test="${not empty chatHistory}">
                        <c:forEach var="chat" items="${chatHistory}">
                            <c:choose>
                                <c:when test="${chat[0] eq 'user'}">
                                    <div class="msg-row user-row">
                                        <div class="msg-av user-av">나</div>
                                        <div class="msg-bubble user-bubble"><c:out value="${chat[1]}"/></div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="msg-row">
                                        <div class="msg-av bot-av">AI</div>
                                        <div class="msg-bubble bot-bubble"><c:out value="${chat[1]}"/></div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:if>

                    <%-- 로딩 중 표시 (전송 후 나타남) --%>
                    <div class="msg-row" id="loadingMsg" style="display:none;">
                        <div class="msg-av bot-av">AI</div>
                        <div class="msg-bubble bot-bubble">
                            <span class="loading-dot"></span>
                            <span class="loading-dot"></span>
                            <span class="loading-dot"></span>
                        </div>
                    </div>

                </div>

                <%-- 추천 예시 칩 --%>
                <div class="guide-chips">
                    <div class="guide-chip" onclick="setMsg('등산용으로 15만원 이내 추천해줘')">🏔️ 등산용 15만원 이내</div>
                    <div class="guide-chip" onclick="setMsg('일상에서 신기 편한 운동화 추천해줘')">👟 편한 일상 운동화</div>
                    <div class="guide-chip" onclick="setMsg('여성용 캐주얼 신발 추천해줘')">👩 여성 캐주얼</div>
                    <div class="guide-chip" onclick="setMsg('러닝화 추천해줘')">🏃 러닝화</div>
                    <div class="guide-chip" onclick="setMsg('10만원 이하 남성 운동화 추천해줘')">💰 10만원 이하 남성</div>
                </div>

                <%-- 입력창 --%>
                <form action="${pageContext.request.contextPath}/shop/ai/aiChatSend.do" method="post" class="ai-inp-area" id="chatForm" onsubmit="onSubmit()">
                    <input type="text" name="userMsg" id="userMsgInput" placeholder="예) 등산용으로 15만원 이내 추천해줘" autocomplete="off">
                    <button type="submit" id="sendBtn">전송</button>
                </form>

            </div>
        </div>
    </div>

    <script>
    // 페이지 로드 시 스크롤 맨 아래로
    window.onload = function() {
        scrollToBottom();
    };

    function scrollToBottom() {
        var msgArea = document.getElementById('msgArea');
        msgArea.scrollTop = msgArea.scrollHeight;
    }

    // 전송 시 로딩 표시
    function onSubmit() {
        var input = document.getElementById('userMsgInput');
        if (!input.value.trim()) return false;
        document.getElementById('loadingMsg').style.display = 'flex';
        document.getElementById('sendBtn').disabled = true;
        document.getElementById('sendBtn').textContent = '전송 중...';
        scrollToBottom();
    }

    // 추천 예시 칩 클릭 시 입력창에 텍스트 채우기
    function setMsg(text) {
        document.getElementById('userMsgInput').value = text;
        document.getElementById('userMsgInput').focus();
    }

    // Enter 키 전송
    document.getElementById('userMsgInput').addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            if (this.value.trim()) {
                document.getElementById('chatForm').dispatchEvent(new Event('submit'));
                document.getElementById('chatForm').submit();
            }
        }
    });
    </script>
</body>
</html>
