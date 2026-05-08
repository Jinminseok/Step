<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <%-- 공통 헤더 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <%-- 비로그인 시 안내 배너 --%>
        <c:if test="${empty sessionScope.user_num}">
            <div style="background:#fff3e0;border-bottom:1px solid #ffe0b2;padding:10px 20px;text-align:center;font-size:13px;color:#e65100;margin-bottom:20px;">
              🔔 로그인하시면 장바구니, 즐겨찾기, 주문 내역 등 다양한 서비스를 이용하실 수 있습니다. &nbsp;
              <a href="${pageContext.request.contextPath}/shop/user/loginForm.do" style="font-weight:700;text-decoration:underline;color:inherit;">지금 로그인하기 →</a>
            </div>
        </c:if>

        <%-- 메인 광고 배너(더미 데이터) --%>
        <div class="slider-wrap">
            <div class="slides">
                <div class="slide">
                    <div class="slide-content">
                        <div class="slide-tag">BEST</div>
                        <div class="slide-title">나이키 에어맥스 270<br>신상 컬러 출시</div>
                        <div class="slide-sub">가장 인기있는 에어맥스 라인에 새 색상 추가</div>
                        <button class="slide-cta">지금 보러가기 →</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 왼쪽 사이드바, 오른쪽 상품 그리드 분할 레이아웃 --%>
        <div class="home-layout">
            
            <%-- 좌측 필터 사이드바 --%>
            <div class="filter-side">
                <form id="filterForm" action="${pageContext.request.contextPath}/shop/user/main.do" method="get">
                    
                    <%-- 1. 카테고리 필터--%>
                    <div class="filter-box">
                        <div class="filter-title">카테고리 ▾</div>
                        <div class="filter-opts">
                            <label class="filter-opt">
                                <input type="radio" name="cat_num" value="0" ${selected_cat == 0 ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                전체보기
                            </label>
                            <%-- DB 목록 반복 --%>
                            <c:forEach var="cat" items="${categoryList}">
                                <label class="filter-opt">
                                    <input type="radio" name="cat_num" value="${cat.cat_num}" ${selected_cat == cat.cat_num ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                    ${cat.cat_name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <%-- 2. 브랜드 필터 --%>
                    <div class="filter-box">
                        <div class="filter-title">브랜드 ▾</div>
                        <div class="filter-opts">
                            <label class="filter-opt">
                                <input type="radio" name="brand_num" value="0" ${selected_brand == 0 ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                전체 브랜드
                            </label>
                            <c:forEach var="brand" items="${brandList}">
                                <label class="filter-opt">
                                    <input type="radio" name="brand_num" value="${brand.brand_num}" ${selected_brand == brand.brand_num ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                    ${brand.brand_name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                </form>
            </div>
            <%-- 좌측 필터 사이드바 끝 --%>


            <%-- 우측 상품 리스트 영역 --%>
            <div class="prod-wrap" style="flex:1; margin:0; padding:0; max-width: none;">
                <div class="prod-title" style="text-align: left;">✨ NEW ARRIVALS</div>
                
                <div class="prod-grid">
                    <c:forEach var="product" items="${productList}">
                        <div class="prod-item" onclick="location.href='${pageContext.request.contextPath}/shop/product/userdetail.do?prod_num=${product.prod_num}'">
                            <div class="prod-img">
                                <img src="${pageContext.request.contextPath}/upload/${product.prod_img_url}" alt="${product.prod_name}">
                            </div>
                            <div class="prod-info">
                                <div class="prod-brand">${product.brand_name}</div>
                                <div class="prod-name">${product.prod_name}</div>
                                <div class="prod-price">
                                    <fmt:formatNumber value="${product.prod_price}" pattern="#,###"/>원
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty productList}">
                        <div style="grid-column: 1 / -1; text-align: center; padding: 100px 0; color: #999; background: var(--gray7); border: 1px solid var(--border);">
                            선택하신 조건에 맞는 상품이 없습니다. 🥲
                        </div>
                    </c:if>
                </div>
            </div>
            <%-- 우측 상품 리스트 영역 끝 --%>
        </div>
    </div>
</body>
</html>