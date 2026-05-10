<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 매장 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">매장 찾기</div>
        
        <div class="map-layout" style="grid-template-columns: 400px 1fr;">
            <%-- 왼쪽: 매장 리스트 --%>
            <div class="store-list" style="height: 600px; overflow-y:auto; padding-right:10px;">
                <div class="hdr-search" style="max-width:100%; margin:0 0 16px 0;">
                    <input type="text" placeholder="지역명 또는 매장명 입력" style="border-color:var(--border); color:var(--black); background:var(--white);">
                    <button class="hdr-search-btn">🔍</button>
                </div>
                
                <%-- 매장 아이템 임시 데이터 --%>
                <div class="store-card on">
                    <div class="store-nm">ShoeMall 강남점</div>
                    <div class="store-addr">서울특별시 강남구 테헤란로 123</div>
                    <div class="store-info"><span>📞 02-123-4567</span> <span>⏰ 10:00 ~ 22:00</span></div>
                </div>
                <div class="store-card">
                    <div class="store-nm">ShoeMall 홍대점</div>
                    <div class="store-addr">서울특별시 마포구 홍익로 45</div>
                    <div class="store-info"><span>📞 02-987-6543</span> <span>⏰ 11:00 ~ 23:00</span></div>
                </div>
            </div>

            <%-- 오른쪽: 지도 영역 --%>
            <div class="map-ph" style="height:600px;">
                <div style="text-align:center;">
                    <span style="font-size:40px;">📍</span>
                    <p style="margin-top:10px; color:var(--gray4);">지도 API(Kakao/Google) 연결 영역입니다.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>