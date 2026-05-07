<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="page" id="pg-ai">
  <div class="page-title">🤖 AI 신발 추천</div>
  <div class="ai-wrap">
    <div>
      <div style="font-size:13px;font-weight:700;margin-bottom:8px">💬 챗봇형 — 자유롭게 물어보기</div>
  <div class="ai-box">
    <div class="ai-hdr"><div class="ai-av">AI</div><div><div class="ai-title">ShoeMall AI 어시스턴트</div><div class="ai-sub-txt">무엇이든 물어보세요</div></div></div>
    <div class="ai-msgs">
      <div class="ai-msg ai-bot">안녕하세요! 어떤 신발을 찾고 계세요? 용도, 예산, 사이즈 등을 자유롭게 말씀해주세요 😊</div>
      <div class="ai-msg ai-user">등산용으로 15만원 이내로 추천해줘</div>
      <div class="ai-msg ai-bot">등산용 15만원 이내라면 현재 매장에서 추천드리는 상품은…<br><br>1️⃣ 살로몬 X Ultra 4 — 143,200원 (방수, 입문자 추천)<br>2️⃣ 메렐 모아브 3 — 139,000원 (편안한 착화감)<br><br>두 상품 모두 재고 있습니다!</div>
    </div>
    <div class="ai-inp"><input type="text" placeholder="신발에 대해 물어보세요..."><button>전송</button></div>
  </div>
</div>
<div>
  <div style="font-size:13px;font-weight:700;margin-bottom:8px">📋 설문형 — 선택지로 추천받기</div>
<div class="survey-box">
  <div class="s-q">어떤 용도로 신으실 건가요?</div>
  <div class="s-chips"><span class="s-chip on">일상 착용</span><span class="s-chip">운동/스포츠</span><span class="s-chip">등산</span><span class="s-chip">비즈니스</span></div>
  <div class="s-q">예산은 얼마 정도인가요?</div>
  <div class="s-chips"><span class="s-chip">5만원 이하</span><span class="s-chip on">5~15만원</span><span class="s-chip">15~30만원</span><span class="s-chip">30만원+</span></div>
  <div class="s-q">선호하는 스타일은?</div>
  <div class="s-chips"><span class="s-chip on">캐주얼</span><span class="s-chip">스포티</span><span class="s-chip">클래식</span><span class="s-chip">럭셔리</span></div>
  <button class="btn btn-black btn-full" style="margin-top:4px">AI 추천 받기</button>
<div class="s-result" style="margin-top:12px">✨ <strong>추천 결과:</strong> 일상 캐주얼 + 5~15만원에는 <strong>아디다스 삼바 OG (116,100원)</strong>와 <strong>뉴발란스 574 (109,000원)</strong>을 추천드립니다!</div>
</div>
</div>
</div>
</div>
</body>
</html>