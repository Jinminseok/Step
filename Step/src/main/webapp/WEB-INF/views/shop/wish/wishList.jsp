<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 찜한 상품</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">찜한 상품</div>
        
        <div class="wish-grid" style="grid-template-columns: repeat(5, 1fr); gap:20px; border:none;">
            <%-- 찜 목록 더미 데이터 --%>
            <div class="prod-item">
                <div class="prod-img">
                    <img src="${pageContext.request.contextPath}/upload/sample.jpg" alt="상품이미지" style="width:100%; height:100%; object-fit:cover;">
                    <div class="prod-wish on" style="top:10px; right:10px; z-index:10;">❤️</div>
                </div>
                <div class="prod-info">
                    <div class="prod-brand">NIKE</div>
                    <div class="prod-name">에어맥스 97 화이트</div>
                    <div class="prod-price">199,000원</div>
                    <button class="btn btn-outline btn-full btn-sm" style="margin-top:10px;">장바구니 담기</button>
                </div>
            </div>
            <div class="prod-item">
                <div class="prod-img">
                    <img src="${pageContext.request.contextPath}/upload/sample2.jpg" alt="상품이미지" style="width:100%; height:100%; object-fit:cover;">
                    <div class="prod-wish on" style="top:10px; right:10px; z-index:10;">❤️</div>
                </div>
                <div class="prod-info">
                    <div class="prod-brand">ADIDAS</div>
                    <div class="prod-name">삼바 OG 클라우드 화이트</div>
                    <div class="prod-price">139,000원</div>
                    <button class="btn btn-outline btn-full btn-sm" style="margin-top:10px;">장바구니 담기</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>