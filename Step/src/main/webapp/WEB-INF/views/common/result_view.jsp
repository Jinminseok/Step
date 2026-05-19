<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - ${result_title}</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css" type="text/css">
<script>
    // 5초 후 자동으로 메인 쇼핑몰로 이동
    setTimeout(function() {
        location.href = '${pageContext.request.contextPath}/shop/user/main.do';
    }, 5000);
</script>
</head>
<body style="background-color: #f8f9fa;">
    
    <div class="result-page-wrap">
        <div class="result-card">
            <%-- 체크마크 아이콘 --%>
            <div class="rc-icon">✓</div>
            
            <%-- 영문 로고 --%>
            <div class="rc-logo">ShoeMall</div>
            
            <%-- 백엔드에서 받은 메시지 출력 --%>
            <div class="rc-title">${result_msg}</div>
            
            <%-- 환영 서브 텍스트 --%>
            <div class="rc-desc">
                <c:choose>
                    <c:when test="${result_title == '회원 가입 완료'}">
                        ShoeMall의 회원이 되신 것을 진심으로 환영합니다.<br>
                        가장 완벽한 한 걸음을 위한 준비가 모두 끝났습니다.
                    </c:when>
                    <c:when test="${result_title == '결제 완료' or result_title == '주문 완료'}">
                        안전하게 주문 및 결제 처리가 완료되었습니다.<br>
                        멋진 상품으로 빠르게 보답하겠습니다.
                    </c:when>
                    <c:otherwise>
                        요청하신 작업이 정상적으로 완료되었습니다.
                    </c:otherwise>
                </c:choose>
            </div>
            
            <%-- 상황에 맞게 버튼을 다르게 --%>
            <c:choose>
                <%-- 1. 회원 탈퇴 완료 --%>
                <c:when test="${result_title == '회원 탈퇴 완료'}">
                    <button class="btn btn-black btn-full" style="height:54px; font-size:15px;" 
                            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">메인 화면으로 돌아가기</button>
                </c:when>
                
                <%-- 2. 주문 완료 또는 결제 완료 --%>
                <c:when test="${result_title == '주문 완료' or result_title == '결제 완료'}">
                    <button class="btn btn-black btn-full" style="height:54px; font-size:15px; margin-bottom:10px;" 
                            onclick="location.href='${pageContext.request.contextPath}/shop/user/myPageForm.do'">주문 내역 확인하기</button>
                    <button class="btn btn-outline btn-full" style="height:54px; font-size:15px; border-color:var(--border); color:var(--gray3);" 
                            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">계속 쇼핑하기</button>
                </c:when>
                
                <%-- 3. 회원 가입 완료 --%>
                <c:otherwise>
                    <button class="btn btn-black btn-full" style="height:54px; font-size:15px; margin-bottom:10px;" 
                            onclick="location.href='${pageContext.request.contextPath}/shop/user/loginForm.do'">지금 로그인하기</button>
                    <button class="btn btn-outline btn-full" style="height:54px; font-size:15px; border-color:var(--border); color:var(--gray3);" 
                            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">메인 쇼핑몰로 이동</button>
                </c:otherwise>
            </c:choose>

        </div>
        
        <%-- 하단 카피라이트 --%>
        <div class="rc-footer">© 2026 ShoeMall. All rights reserved.</div>
    </div>
    
</body>
</html>