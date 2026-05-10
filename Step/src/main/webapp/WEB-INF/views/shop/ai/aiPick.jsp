<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - AI 신발 추천</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div style="display:flex; align-items:center; gap:16px; margin-bottom:24px;">
            <div class="page-title" style="margin-bottom:0; font-size:24px;">🤖 AI 신발 추천</div>
        </div>
        
        <%-- 만들어두신 .ai-wrap 사용 (1fr 1fr 반반 레이아웃) --%>
        <div class="ai-wrap">
            
            <%-- 왼쪽: 챗봇형 영역 --%>
            <div>
                <div style="font-size:14px; font-weight:700; margin-bottom:12px; color:var(--gray2);">💬 챗봇형 - 자유롭게 물어보기</div>
                <div class="ai-box">
                    <div class="ai-hdr">
                        <div class="ai-av">AI</div>
                        <div>
                            <div class="ai-title">ShoeMall AI 어시스턴트</div>
                            <div class="ai-sub-txt">무엇이든 물어보세요</div>
                        </div>
                    </div>
                    <%-- CSS 기본 높이(280px)보다 조금 더 늘려서 우측 상자와 균형을 맞춤 --%>
                    <div class="ai-msgs" style="height: 380px;">
                        <div class="ai-msg ai-bot">안녕하세요! 어떤 신발을 찾고 계세요? 용도, 예산, 사이즈 등을 자유롭게 말씀해주세요 😊</div>
                        <div class="ai-msg ai-user">등산용으로 15만원 이내로 추천해줘</div>
                        <div class="ai-msg ai-bot">
                            등산용 15만원 이내라면 현재 매장에서 추천드리는 상품은...<br><br>
                            1️⃣ <b>살로몬 X Ultra 4</b> - 143,200원 (방수, 입문자 추천)<br>
                            2️⃣ <b>메렐 모아브 3</b> - 139,000원 (편안한 착화감)<br><br>
                            두 상품 모두 재고 있습니다!
                        </div>
                    </div>
                    <div class="ai-inp">
                        <input type="text" placeholder="신발에 대해 물어보세요...">
                        <button>전송</button>
                    </div>
                </div>
            </div>

            <%-- 오른쪽: 설문형 영역 --%>
            <div>
                <div style="font-size:14px; font-weight:700; margin-bottom:12px; color:var(--gray2);">📋 설문형 - 선택지로 추천받기</div>
                <div class="survey-box" style="height: 485px; display:flex; flex-direction:column; justify-content:space-between;">
                    
                    <div>
                        <%-- 질문 1 --%>
                        <div style="display:flex; justify-content:space-between; align-items:flex-end;">
                            <div class="s-q">어떤 용도로 신으실 건가요?</div>
                        </div>
                        <div class="s-chips">
                            <div class="s-chip on">일상 착용</div>
                            <div class="s-chip">운동/스포츠</div>
                            <div class="s-chip">등산</div>
                            <div class="s-chip">비즈니스</div>
                        </div>

                        <%-- 질문 2 --%>
                        <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-top:20px;">
                            <div class="s-q">예산은 얼마 정도인가요?</div>
                        </div>
                        <div class="s-chips" style="align-items:center;">
                            <div class="s-chip">5만원 이하</div>
                            <div class="s-chip on">5~15만원</div>
                            <div class="s-chip">15~30만원</div>
                            <div class="s-chip">30만원+</div>
                            <div style="font-size:12px; color:var(--gray4); margin-left:4px; cursor:pointer;">직접입력?</div>
                        </div>

                        <%-- 질문 3 --%>
                        <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-top:20px;">
                            <div class="s-q">선호하는 스타일은?</div>
                        </div>
                        <div class="s-chips">
                            <div class="s-chip on">캐주얼</div>
                            <div class="s-chip">스포티</div>
                            <div class="s-chip">클래식</div>
                            <div class="s-chip">럭셔리</div>
                        </div>
                    </div>

                    <%-- 추천 버튼 및 결과 --%>
                    <div style="margin-top:20px;">
                        <button class="btn btn-black btn-full" style="padding:14px; font-size:14px;">AI 추천 받기</button>
                        <div class="s-result">
                            ✨ <b>추천 결과:</b> 일상 캐주얼 + 5~15만원에는 <b>아디다스 삼바 OG (116,100원)</b>와 <b>뉴발란스 574 (109,000원)</b>을 추천드립니다!
                        </div>
                    </div>
                    
                </div>
            </div>

        </div>
    </div>
</body>
</html>